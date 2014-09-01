require 'redmine'

Redmine::Plugin.register :redmine_workflow_macro do
  name 'Redmine Custom Workflow macro extension'
  url 'https://github.com'
  author 'Stefan Roethig'
  description 'Add the macro.'
  author_url 'mailto:dev@realraum-media.de'
  version '0.1'
end

Redmine::WikiFormatting::Macros.register do
  desc "Insert the ID of the currently logged in user. Examples: \n\n <pre>{{wf_userid}}</pre>\n\nis printed as: {{wf_userid}}"
  macro :wf_userid do |obj, args|
    out = ''.html_safe
    user_id = User.current.id
    out << user_id.to_s
  end
  
  desc "Replaces various fields:\n- #usr-id User's ID value\n- #usr-login User's login name\n- #today Current date\nin the contained text block. Examples: \n\n
  <pre>{{wf_replace(
   Dies ist ein Beipiel von Nutzer #usr-id (#usr-login-name).
   Heute ist der #today[%d.%m.%Y] oder anders formatiert: #today[%Y-%m-%d].
  )}}</pre>is printed as: 

  bq. {{wf_replace(
   Dies ist ein Beipiel von Nutzer #usr-id (#usr-login-name).
   Heute ist der #today[%d.%m.%Y] oder anders formatiert: #today[%Y-%m-%d].
  )}}\n\nFeel free to extend this macro with your own replacers ;)"
  macro :wf_replace do |obj, args|
    user_id = User.current.id
    user_login = User.current.login
	out = "#{args.join(', ')}".html_safe
	out = out.gsub('#usr-id',user_id.to_s)
	out = out.gsub('#usr-login-name',user_login.to_s)
	out = out.gsub(/(#today)\[(.*?)\]/){ Time.now.strftime($2) }
  end
  
  desc "Insert the user-login-name of the currently logged in user. Examples: \n\n <pre>{{wf_userlogin}}</pre>\n\nis printed as: {{wf_userlogin}}"
  macro :wf_userlogin do |obj, args|
      user_login = User.current.login
      h(user_login.to_s)
  end
end

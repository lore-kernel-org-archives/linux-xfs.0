Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61D7F7F5D
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 11:31:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2425D8F8035
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 09:31:12 -0700 (PDT)
Received: from nihrelayxway4.hub.nih.gov (nihrelayxway4.hub.nih.gov
	[128.231.90.98]) by cuda.sgi.com with ESMTP id B6HJO1G1vb6DOTxk
	for <xfs@oss.sgi.com>; Fri, 09 Aug 2013 09:31:10 -0700 (PDT)
Subject: Re: prjquota not updating used blocks
MIME-Version: 1.0 (Apple Message framework v1283)
From: "Weber, Charles (NIH/NIA/IRP) [C]" <WeberC@grc.nia.nih.gov>
In-Reply-To: <20130809151957.GZ3111@sgi.com>
Date: Fri, 9 Aug 2013 12:29:20 -0400
Message-ID: <C33DFB5C-9524-4D7D-8F9A-8E17088CA20E@grc.nia.nih.gov>
References: <6D3CECD5-FBBF-4946-A0D0-5B0C71E772DD@grc.nia.nih.gov>
	<20130809151957.GZ3111@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4571246798002379372=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============4571246798002379372==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_FDEF82E4-D4C2-4448-9ACC-8C750C235AA5"

--Apple-Mail=_FDEF82E4-D4C2-4448-9ACC-8C750C235AA5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Ben,
When I referred to initialize I meant  running xfs_quota -x project -s =
name
When I run xfs_quota -x 'project -c lg'
I do get warnings about project identifier and inheritance but only for =
the new directories that I created and copied the large data sets into. =
I don't get those warning about the earlier files and folders for a =
given project.
When I run the project -s again it does update the block usage. But I =
would think the block usage should update automatically.
Thanks for replying so quickly.
Chuck


Weber, Charles (NIH/NIA/IRP)=20
weberc@mail.nih.gov
p: 410-558-8001
c: 443-473-6493
251 Bayview Blvd
Baltimore MD 21224
NCTS performance comments and survey at:
https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey





On Aug 9, 2013, at 11:19 AM, Ben Myers wrote:

> Hi Charles,
>=20
> On Fri, Aug 09, 2013 at 10:14:21AM -0400, Weber, Charles (NIH/NIA/IRP) =
[C] wrote:
>> CentOS 6.4=20
>> Linux niairpfs1.irp.nia.nih.gov 2.6.32-358.6.2.el6.x86_64 #1 SMP Thu =
May 16 20:59:36 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>> xfsprogs-3.1.1-10.el6_4.1.x86_64
>> xfsdump-3.0.4-3.el6.x86_64
>>=20
>> mount
>> /dev/mapper/shared1_vg-niairp_lv on /share/niairp type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)
>>=20
>> this is a 63T filesystem
>> xfs_quota report
>> Project quota on /share/niairp (/dev/mapper/shared1_vg-niairp_lv)
>> Project ID   Used   Soft   Hard Warn/Grace  =20
>> ---------- ---------------------------------=20
>> lbnnas          0      0     1T  00 [------]
>> lbnnccu         0      0   4.4T  00 [------]
>> tgb          1.3T      0     2T  00 [------]
>> apps       106.4G      0   150G  00 [------]
>> ncts       205.7G      0   250G  00 [------]
>> lg           1.4T      0    10T  00 [------]
>>=20
>> Since initializing a project quota, there is no change in used =
blocks. When I initialize the block count is correct.  If I =
re-initialize, the used block count is updated properly.=20
>>=20
>> I copied 2T last night into the folder referenced by the lg project =
quota and there is no change in used blocks today.
>> What have I missed?
>=20
> An initial guess is you did not set up the project in xfs_quota using =
the
> 'project -s' xfs_quota command.
>=20
> 'project -c' output should look like this:
>=20
> xfs_quota> project -c testproject =20
> Checking project testproject (path /mnt/test/testa)...
> Checking project testproject (path /mnt/test/testb)...
> Processed 2 (/etc/projects and cmdline) paths for project testproject =
with recursion depth infinite (-1).
>=20
> But if you don't set up a project you might see something like this:
>=20
> xfs_quota> project -c testproject
> Checking project testproject (path /mnt/test/testa)...
> /mnt/test/testa - project identifier is not set (inode=3D0, tree=3D33)
> /mnt/test/testa - project inheritance flag is not set
> /mnt/test/testa/file - project identifier is not set (inode=3D0, =
tree=3D33)
> /mnt/test/testa/file - project inheritance flag is not set
> Checking project testproject (path /mnt/test/testb)...
> /mnt/test/testb - project identifier is not set (inode=3D0, tree=3D33)
> /mnt/test/testb - project inheritance flag is not set
> Processed 2 (/etc/projects and cmdline) paths for project testproject =
with recursion depth infinite (-1).
>=20
> And you'd have similar symptoms.  You can also check which project the =
files
> you created are in by using the xfs_io 'lsproj' command.  There is =
also a
> 'chproj' command if find that your existing files aren't in the =
project and
> need to add them in.
>=20
> Regards,
> 	Ben


--Apple-Mail=_FDEF82E4-D4C2-4448-9ACC-8C750C235AA5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; ">Hi =
Ben,<div>When I referred to initialize I meant &nbsp;running xfs_quota =
-x project -s name</div><div>When I run xfs_quota -x 'project -c =
lg'</div><div>I do get warnings about project identifier and inheritance =
but only for the new directories that I created and copied the large =
data sets into. I don't get those warning about the earlier files and =
folders for a given project.</div><div>When I run the project -s again =
it does update the block usage. But I would think the block usage should =
update automatically.</div><div>Thanks for replying so =
quickly.</div><div>Chuck</div><div><br></div><div><br><div =
apple-content-edited=3D"true">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
color: rgb(0, 0, 0); font-family: Helvetica; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; "><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-style: normal; font-variant: =
normal; font-weight: normal; letter-spacing: normal; line-height: =
normal; orphans: 2; text-align: -webkit-auto; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; "><div =
style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; "><div =
style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div><div><div><div>Weber, =
Charles (NIH/NIA/IRP)&nbsp;</div><div><a =
href=3D"mailto:weberc@mail.nih.gov">weberc@mail.nih.gov</a></div><div>p: =
410-558-8001</div><div>c: 443-473-6493</div><div>251 Bayview =
Blvd</div><div>Baltimore MD 21224</div><div><div =
apple-content-edited=3D"true"><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; ">NCTS =
performance comments and survey at:</span></div><div><a =
href=3D"https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey">http=
s://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey</a></div></div></=
div></div></div><div><br></div></div></span><br =
class=3D"Apple-interchange-newline"></div></span><br =
class=3D"Apple-interchange-newline"></span><br =
class=3D"Apple-interchange-newline">
</div>
<br><div><div>On Aug 9, 2013, at 11:19 AM, Ben Myers wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>Hi =
Charles,<br><br>On Fri, Aug 09, 2013 at 10:14:21AM -0400, Weber, Charles =
(NIH/NIA/IRP) [C] wrote:<br><blockquote type=3D"cite">CentOS 6.4 =
<br></blockquote><blockquote type=3D"cite">Linux =
niairpfs1.irp.nia.nih.gov 2.6.32-358.6.2.el6.x86_64 #1 SMP Thu May 16 =
20:59:36 UTC 2013 x86_64 x86_64 x86_64 =
GNU/Linux<br></blockquote><blockquote =
type=3D"cite">xfsprogs-3.1.1-10.el6_4.1.x86_64<br></blockquote><blockquote=
 type=3D"cite">xfsdump-3.0.4-3.el6.x86_64<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">mount<br></blockquote><blockquote =
type=3D"cite">/dev/mapper/shared1_vg-niairp_lv on /share/niairp type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)<br></block=
quote><blockquote type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">this is a 63T filesystem<br></blockquote><blockquote =
type=3D"cite">xfs_quota report<br></blockquote><blockquote =
type=3D"cite">Project quota on /share/niairp =
(/dev/mapper/shared1_vg-niairp_lv)<br></blockquote><blockquote =
type=3D"cite">Project ID &nbsp;&nbsp;Used &nbsp;&nbsp;Soft =
&nbsp;&nbsp;Hard Warn/Grace &nbsp;&nbsp;<br></blockquote><blockquote =
type=3D"cite">---------- --------------------------------- =
<br></blockquote><blockquote type=3D"cite">lbnnas =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;&nbsp;&nbsp;1T &nbsp;00 =
[------]<br></blockquote><blockquote type=3D"cite">lbnnccu =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;4.4T &nbsp;00 =
[------]<br></blockquote><blockquote type=3D"cite">tgb =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.3T =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;&nbsp;&nbsp;2T &nbsp;00 =
[------]<br></blockquote><blockquote type=3D"cite">apps =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;106.4G =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;150G &nbsp;00 =
[------]<br></blockquote><blockquote type=3D"cite">ncts =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;205.7G =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;250G &nbsp;00 =
[------]<br></blockquote><blockquote type=3D"cite">lg =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.4T =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 &nbsp;&nbsp;&nbsp;10T &nbsp;00 =
[------]<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Since =
initializing a project quota, there is no change in used blocks. When I =
initialize the block count is correct. &nbsp;If I re-initialize, the =
used block count is updated properly. <br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I copied 2T =
last night into the folder referenced by the lg project quota and there =
is no change in used blocks today.<br></blockquote><blockquote =
type=3D"cite">What have I missed?<br></blockquote><br>An initial guess =
is you did not set up the project in xfs_quota using the<br>'project -s' =
xfs_quota command.<br><br>'project -c' output should look like =
this:<br><br>xfs_quota&gt; project -c testproject &nbsp;<br>Checking =
project testproject (path /mnt/test/testa)...<br>Checking project =
testproject (path /mnt/test/testb)...<br>Processed 2 (/etc/projects and =
cmdline) paths for project testproject with recursion depth infinite =
(-1).<br><br>But if you don't set up a project you might see something =
like this:<br><br>xfs_quota&gt; project -c testproject<br>Checking =
project testproject (path /mnt/test/testa)...<br>/mnt/test/testa - =
project identifier is not set (inode=3D0, tree=3D33)<br>/mnt/test/testa =
- project inheritance flag is not set<br>/mnt/test/testa/file - project =
identifier is not set (inode=3D0, tree=3D33)<br>/mnt/test/testa/file - =
project inheritance flag is not set<br>Checking project testproject =
(path /mnt/test/testb)...<br>/mnt/test/testb - project identifier is not =
set (inode=3D0, tree=3D33)<br>/mnt/test/testb - project inheritance flag =
is not set<br>Processed 2 (/etc/projects and cmdline) paths for project =
testproject with recursion depth infinite (-1).<br><br>And you'd have =
similar symptoms. &nbsp;You can also check which project the =
files<br>you created are in by using the xfs_io 'lsproj' command. =
&nbsp;There is also a<br>'chproj' command if find that your existing =
files aren't in the project and<br>need to add them =
in.<br><br>Regards,<br><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>Ben<br></div></blockquote></div><br></div></body></html>=

--Apple-Mail=_FDEF82E4-D4C2-4448-9ACC-8C750C235AA5--


--===============4571246798002379372==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4571246798002379372==--

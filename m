Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48D787FAE
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 13:27:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09DAF304053
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 11:27:36 -0700 (PDT)
Received: from nihrelayxway4.hub.nih.gov (nihrelayxway4.hub.nih.gov
	[128.231.90.98]) by cuda.sgi.com with ESMTP id 3od3vRP6VTS8luRG
	for <xfs@oss.sgi.com>; Fri, 09 Aug 2013 11:27:33 -0700 (PDT)
Subject: Re: prjquota not updating used blocks
MIME-Version: 1.0 (Apple Message framework v1283)
From: "Weber, Charles (NIH/NIA/IRP) [C]" <WeberC@grc.nia.nih.gov>
In-Reply-To: <20130809171750.GV1681@sgi.com>
Date: Fri, 9 Aug 2013 14:27:33 -0400
Message-ID: <AEEA663C-426F-4C9E-9A57-46AD3E2B5F6E@grc.nia.nih.gov>
References: <6D3CECD5-FBBF-4946-A0D0-5B0C71E772DD@grc.nia.nih.gov>
	<20130809151957.GZ3111@sgi.com>
	<C33DFB5C-9524-4D7D-8F9A-8E17088CA20E@grc.nia.nih.gov>
	<20130809171750.GV1681@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3593646265558089359=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

--===============3593646265558089359==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_08AB0798-25F7-4068-87DD-F7872DEDDB7C"

--Apple-Mail=_08AB0798-25F7-4068-87DD-F7872DEDDB7C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

I think I understand it.

I have an existing path on a new server:
/share/niairp/LG
mkdir /share/niairp/LG/NEW
set rights....
# above is normal
copy data from other server
xfsdump... | ssh xfsrestore....

Because I am copying the files from a partition on remote server to a =
subdirectory on new server via xfsdump and restore, the project tags are =
not getting applied. The existing files on the other server are xfs but =
definitely do not have project quotas.
So the solution is to project -s each new dir_name after I do the copy =
and afterward all should be fine.

I'll try over next week or so to monitor, but it does sound reasonable.
Thanks,
Chuck


Weber, Charles (NIH/NIA/IRP)=20
weberc@mail.nih.gov
p: 410-558-8001
c: 443-473-6493
251 Bayview Blvd
Baltimore MD 21224
NCTS performance comments and survey at:
https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey





On Aug 9, 2013, at 1:17 PM, Ben Myers wrote:

> Hey Charles,
>=20
> On Fri, Aug 09, 2013 at 12:29:20PM -0400, Weber, Charles (NIH/NIA/IRP) =
[C] wrote:
>> When I referred to initialize I meant  running xfs_quota -x project =
-s name
>=20
> Hmm.  What if you used 'xfs_quota -x project -s -p /path/to/new/dirs =
name'?
>=20
>> When I run xfs_quota -x 'project -c lg'
>>=20
>> I do get warnings about project identifier and inheritance but only =
for the
>> new directories that I created and copied the large data sets into. I =
don't
>> get those warning about the earlier files and folders for a given =
project.
>=20
> Those warnings refer to not having a project id set in the inode core, =
and
> whether a directory will set it's project id into the inode cores of =
whatever
> you create inside.  Without that project id set in the new files you =
create,
> the quota subsystem won't know which project quota to reserve blocks
> against.  That's why your block usage wasn't changing.
>=20
>> When I run the project -s again it does update the block usage.
>=20
> Maybe the first try failed to find the new directory?  I'm not sure.
>=20
>> But I would think the block usage should update automatically.
>=20
> Could you cut an paste the procedure to you used to create the new =
directories?
>=20
> Thanks,
> 	Ben


--Apple-Mail=_08AB0798-25F7-4068-87DD-F7872DEDDB7C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<html><head></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; ">I =
think I understand it.<div><br></div><div>I have an existing path on a =
new server:</div><div>/share/niairp/LG</div><div>mkdir =
/share/niairp/LG/NEW</div><div>set rights....</div><div># above is =
normal</div><div>copy data from other server</div><div>xfsdump... | ssh =
xfsrestore....</div><div><br></div><div>Because I am copying the files =
from a partition on remote server to a subdirectory on new server via =
xfsdump and restore, the project tags are not getting applied. The =
existing files on the other server are xfs but definitely do not have =
project quotas.</div><div>So the solution is to project -s each new =
dir_name after I do the copy and afterward all should be =
fine.</div><div><br></div><div>I'll try over next week or so to monitor, =
but it does sound =
reasonable.</div><div>Thanks,</div><div>Chuck</div><div><br></div><div><br=
><div apple-content-edited=3D"true">
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
<br><div><div>On Aug 9, 2013, at 1:17 PM, Ben Myers wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>Hey =
Charles,<br><br>On Fri, Aug 09, 2013 at 12:29:20PM -0400, Weber, Charles =
(NIH/NIA/IRP) [C] wrote:<br><blockquote type=3D"cite">When I referred to =
initialize I meant &nbsp;running xfs_quota -x project -s =
name<br></blockquote><br>Hmm. &nbsp;What if you used 'xfs_quota -x =
project -s -p /path/to/new/dirs name'?<br><br><blockquote =
type=3D"cite">When I run xfs_quota -x 'project -c =
lg'<br></blockquote><blockquote type=3D"cite"><br></blockquote><blockquote=
 type=3D"cite">I do get warnings about project identifier and =
inheritance but only for the<br></blockquote><blockquote type=3D"cite">new=
 directories that I created and copied the large data sets into. I =
don't<br></blockquote><blockquote type=3D"cite">get those warning about =
the earlier files and folders for a given =
project.<br></blockquote><br>Those warnings refer to not having a =
project id set in the inode core, and<br>whether a directory will set =
it's project id into the inode cores of whatever<br>you create inside. =
&nbsp;Without that project id set in the new files you create,<br>the =
quota subsystem won't know which project quota to reserve =
blocks<br>against. &nbsp;That's why your block usage wasn't =
changing.<br><br><blockquote type=3D"cite">When I run the project -s =
again it does update the block usage.<br></blockquote><br>Maybe the =
first try failed to find the new directory? &nbsp;I'm not =
sure.<br><br><blockquote type=3D"cite">But I would think the block usage =
should update automatically.<br></blockquote><br>Could you cut an paste =
the procedure to you used to create the new =
directories?<br><br>Thanks,<br><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>Ben<br></div></blockquote></div><br></div></body></html>=

--Apple-Mail=_08AB0798-25F7-4068-87DD-F7872DEDDB7C--


--===============3593646265558089359==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3593646265558089359==--

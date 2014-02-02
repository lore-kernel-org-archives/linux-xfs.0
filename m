Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3AAB7FBC
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 09:31:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B14588F8040
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 07:31:44 -0800 (PST)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	alvkdvNlBXsd1VU7 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 07:31:42 -0800 (PST)
Received: by mail-lb0-f170.google.com with SMTP id u14so4771439lbd.29
	for <xfs@oss.sgi.com>; Sun, 02 Feb 2014 07:31:41 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Extended attributes limit in Linux
From: Sun_Blood <sblood@gmail.com>
In-Reply-To: <52EE62AD.4030509@oracle.com>
Date: Sun, 2 Feb 2014 16:31:33 +0100
Message-Id: <55DCB69E-4C06-4D70-87F8-949D2C1DDB9C@gmail.com>
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>	<1391172723.4275.11.camel@ubuntu>	<52EBA783.1080801@oracle.com>	<1391178074.4275.19.camel@ubuntu>	<52EBB431.50301@oracle.com>	<6C94A326-DADE-4A32-97F6-AE84E9F57777@gmail.com>	<1D87A7C9-988F-4F61-A577-67300DAF2554@dubeyko.com>	<14FE2575-4C84-43B8-9992-F91ABE2B6F26@gmail.com>
	<52EE6069.7090905@oracle.com> <52EE62AD.4030509@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2419209047326040144=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, xfs@oss.sgi.com


--===============2419209047326040144==
Content-Type: multipart/alternative; boundary="Apple-Mail=_5F7A9653-2687-445A-9723-60EC8A35F82C"


--Apple-Mail=_5F7A9653-2687-445A-9723-60EC8A35F82C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On 2 feb 2014, at 16:22, Jeff Liu <jeff.liu@oracle.com> wrote:

>=20
> On 02/02 2014 23:12 PM, Jeff Liu wrote:
>>=20
>> On 02/02 2014 22:33 PM, Sun_Blood wrote:
> <snip>
>>>>> FYI, Example of output from one of the failing files. First from =
OS X
>>>>> and then same file after failed copy to XFS.
>>>>>=20
>>>>> OS X Maverik:
>>>>> file: "/Users/username/Pictures/iPhoto
>>>>> Library/Database/apdb/BigBlobs.apdb"
>>>>> type: "\0\0\0\0"
>>>>> creator: "\0\0\0\0"
>>>>> attributes: avbstclinmedz
>>>>> created: 01/25/2014 11:43:17
>>>>> modified: 01/28/2014 20:02:46
>>>>>=20
>>>>>=20
>>>>> Ubunutu=20
>>>>> getfattr: Removing leading '/' from absolute path names
>>>>> # file: srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto
>>>>> Library/Database/BigBlobs.apdb
>>>>> user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94
>>>>=20
>>>>=20
>>>> Sorry, but I don't quite follow your thought. What do you show by =
this
>>>> output?
>>>> What do you mean? Could you describe in more details?
>>>>=20
>>>> Thanks,
>>>> Vyacheslav Dubeyko.
>>>=20
>>> Sorry late reply. The output is just to show what happen after I
>>> transfer a file from OS X to XFS that has EA bigger then 64k(I =
think).
>>> When I try for example to rsync this file from OS X to Linux XFS I =
get
>>> this error:
>>> rsync: rsync_xal_set:
>>> lsetxattr(""/srv/nas/home/apple_bak_rsync/xxxxxx/Pictures/iPhoto
>>> Library/Database/BigBlobs.apdb"","user.com.apple.FinderInfo") =
failed:
>>> Operation not permitted (1)
>>>=20
>>> But also rsync can give this error.
>>> rsync: rsync_xal_set:
>>> =
lsetxattr(""/srv/danne/extern2/1000_EXT/2013/2013-03-05/IMG_6872-Edit.tif"=
","user.com.apple.ResourceFork")
>>> failed: Argument list too long (7)
>>>=20
>>> Is this 2 errors related?
>>=20
>> Those errors are unrelated IMO, the first one is due to the =
permission rules but
>> I'm not sure the root cause, the second one is occurred as the EA =
value is larger
>> than 64K I guess.
>>=20
>>>=20
>>> I will make a bug report for rsync also that it should not try to =
copy
>>> files with EA bigger then the destination can handle. But it would =
be
>>> great if XFS could handle this files and be fully compatible with OS =
X
>>> backups.
>>=20
>> 64K size is not limited by XFS directly, it is limited by VFS =
setxattr syscall.
>> IOWs, EA set operation is not yet get into XFS when "Argument list =
too long" error
>> is returned, so I think you would ran into the same error on other =
file systems
>> which are support 64K EA value size as well.
>=20
> To be more precise, larger EA set operation would not works via =
setxattr(2) on Linux
> regardless of the underlying file systems :).

Correct I did a quick test on ext4 and got the same fault.

>=20
> Thanks,
> -Jeff

So to be able to support this type of EA that OS X produce we need a =
change in the Linux kernel? Because XFS does handle it and is not the =
problem here.=

--Apple-Mail=_5F7A9653-2687-445A-9723-60EC8A35F82C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=windows-1252

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dwindows-1252"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;"><br><div><div>On 2 feb 2014, at 16:22, Jeff Liu =
&lt;<a href=3D"mailto:jeff.liu@oracle.com">jeff.liu@oracle.com</a>&gt; =
wrote:</div><br class=3D"Apple-interchange-newline"><blockquote =
type=3D"cite"><div style=3D"font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: 0px;"><br>On 02/02 2014 23:12 PM, Jeff =
Liu wrote:<br><blockquote type=3D"cite"><br>On 02/02 2014 22:33 PM, =
Sun_Blood wrote:<br></blockquote>&lt;snip&gt;<br><blockquote =
type=3D"cite"><blockquote type=3D"cite"><blockquote =
type=3D"cite"><blockquote type=3D"cite">FYI, Example of output from one =
of the failing files. First from OS X<br>and then same file after failed =
copy to XFS.<br><br>OS X Maverik:<br>file: =
"/Users/username/Pictures/iPhoto<br>Library/Database/apdb/BigBlobs.apdb"<b=
r>type: "\0\0\0\0"<br>creator: "\0\0\0\0"<br>attributes: =
avbstclinmedz<br>created: 01/25/2014 11:43:17<br>modified: 01/28/2014 =
20:02:46<br><br><br>Ubunutu<span =
class=3D"Apple-converted-space">&nbsp;</span><br>getfattr: Removing =
leading '/' from absolute path names<br># file: =
srv/nas/home/apple_bak_rsync/username/Pictures/iPhoto<br>Library/Database/=
BigBlobs.apdb<br>user.com.apple.quarantine=3D"0006;52e39545;iPhoto;=94<br>=
</blockquote><br><br>Sorry, but I don't quite follow your thought. What =
do you show by this<br>output?<br>What do you mean? Could you describe =
in more details?<br><br>Thanks,<br>Vyacheslav =
Dubeyko.<br></blockquote><br>Sorry late reply. The output is just to =
show what happen after I<br>transfer a file from OS X to XFS that has EA =
bigger then 64k(I think).<br>When I try for example to rsync this file =
from OS X to Linux XFS I get<br>this error:<br>rsync: =
rsync_xal_set:<br>lsetxattr(""/srv/nas/home/apple_bak_rsync/xxxxxx/Picture=
s/iPhoto<br>Library/Database/BigBlobs.apdb"","user.com.apple.FinderInfo") =
failed:<br>Operation not permitted (1)<br><br>But also rsync can give =
this error.<br>rsync: =
rsync_xal_set:<br>lsetxattr(""/srv/danne/extern2/1000_EXT/2013/2013-03-05/=
IMG_6872-Edit.tif"","user.com.apple.ResourceFork")<br>failed: Argument =
list too long (7)<br><br>Is this 2 errors =
related?<br></blockquote><br>Those errors are unrelated IMO, the first =
one is due to the permission rules but<br>I'm not sure the root cause, =
the second one is occurred as the EA value is larger<br>than 64K I =
guess.<br><br><blockquote type=3D"cite"><br>I will make a bug report for =
rsync also that it should not try to copy<br>files with EA bigger then =
the destination can handle. But it would be<br>great if XFS could handle =
this files and be fully compatible with OS =
X<br>backups.<br></blockquote><br>64K size is not limited by XFS =
directly, it is limited by VFS setxattr syscall.<br>IOWs, EA set =
operation is not yet get into XFS when "Argument list too long" =
error<br>is returned, so I think you would ran into the same error on =
other file systems<br>which are support 64K EA value size as =
well.<br></blockquote><br>To be more precise, larger EA set operation =
would not works via setxattr(2) on Linux<br>regardless of the underlying =
file systems :).<br></div></blockquote><div><br></div><div>Correct I did =
a quick test on ext4 and got the same fault.</div><br><blockquote =
type=3D"cite"><div style=3D"font-size: 12px; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: auto; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: auto; word-spacing: =
0px; -webkit-text-stroke-width: =
0px;"><br>Thanks,<br>-Jeff</div></blockquote><br></div><div>So to be =
able to support this type of EA that OS X produce we need a change in =
the Linux kernel? Because XFS does handle it and is not the problem =
here.</div></body></html>=

--Apple-Mail=_5F7A9653-2687-445A-9723-60EC8A35F82C--


--===============2419209047326040144==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2419209047326040144==--

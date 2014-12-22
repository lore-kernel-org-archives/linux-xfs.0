Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0C7229DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 10:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 673E88F8033
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 08:34:47 -0800 (PST)
Received: from mail-qg0-f48.google.com (mail-qg0-f48.google.com
	[209.85.192.48]) by cuda.sgi.com with ESMTP id LTCsFgGkjUBZVdSq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2014 08:34:45 -0800 (PST)
Received: by mail-qg0-f48.google.com with SMTP id f51so3475282qge.7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 08:34:45 -0800 (PST)
Received: from [156.40.66.13] ([156.40.66.13]) by mx.google.com with ESMTPSA id
	e45sm16695458qgd.35.2014.12.22.08.34.43 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Mon, 22 Dec 2014 08:34:44 -0800 (PST)
From: Charles Weber <chaweber@gmail.com>
Message-Id: <DB71170E-CC30-48A7-AAB9-21E44EA629FE@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: weird quota issue
Date: Mon, 22 Dec 2014 11:34:42 -0500
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
In-Reply-To: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6449680087486480565=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6449680087486480565==
Content-Type: multipart/alternative; boundary="Apple-Mail=_D16214AC-02F7-4953-B610-55F980783BEF"


--Apple-Mail=_D16214AC-02F7-4953-B610-55F980783BEF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Odd fix but there you go.
1. I saw in earlier list mail to look at /proc/self/mounts.=20
Indeed my /home was mounted there with the noquota option, even though =
the fstab clearly stated the quota user and project options.=20
This persisted even if I dismounted and ran xfs_repair of the partition =
in question.

2. I rebooted with a forcefsck file. After the reboot/fsck, proc and =
fstab now match. Both list the partition with valid quota options.


> On Dec 19, 2014, at 4:26 PM, Weber, Charles (NIH/NIA/IRP) [E] =
<WeberC@grc.nia.nih.gov> wrote:
>=20
> HI everyone, long time xfs/quota user with new server and problem
> hardware is HP BL460 G7 blade, qlogic fiber channel and 3Par 7200 =
storage
> 3 16TB vols exported from 3Par to server via FC. These are thin =
volumes, but plenty of available backing storage.
>=20
> Server runs current patched CentOS 6.6
> kernel 2.6.32-504.3.3.el6.x86_64
> xfsprogs 2.1.1-16.el6
> Default mkfs.xfs options for volumes
>=20
> mount options for logical volumes  home_lv 39TB imap_lv 4.6TB
> /dev/mapper/irphome_vg-home_lv on /home type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)
> /dev/mapper/irphome_vg-imap_lv on /mail type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)
>=20
> Users are from large AD via winbind set to not enumerate. I saw the =
bug with xfs_quota report not listing winbind defined user names. Yes =
this happens to me.
> I can assign project quota to smaller volume. xfs_quota will not =
report it. I cannot assign a project quota to larger volume. I get this =
error: xfs_quota: cannot set limits: Function not implemented.
>=20
> xfs_quota -x -c 'report -uh' /mail
> User quota on /mail (/dev/mapper/irphome_vg-imap_lv)
>                         Blocks             =20
> User ID      Used   Soft   Hard Warn/Grace  =20
> ---------- ---------------------------------=20
> root         2.2G      0      0  00 [------]
>=20
> [xfs_quota -x -c 'report -uh' /home
>=20
> nothing is returned
>=20
> I can set user and project quotas on /mail but cannot see them. I have =
not tested them yet.
> I cannot set user or project quotas on /home.
> At one time I could definitely set usr quotas on /home. I did so and =
verified it worked.=20
>=20
> Any ideas what is messed up on the /home volume?
>=20
>=20
>=20
> Weber, Charles (NIH/NIA/IRP)=20
> weberc@mail.nih.gov <mailto:weberc@mail.nih.gov>
> p: 410-558-8001
> c: 443-473-6493
> 251 Bayview Blvd
> Baltimore MD 21224
> NCTS performance comments and survey at:
> https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey =
<https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey>
>=20
>=20
>=20
>=20
>=20
>=20


--Apple-Mail=_D16214AC-02F7-4953-B610-55F980783BEF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">Odd fix but there you go.<div class=3D"">1. I saw in earlier =
list mail to look at /proc/self/mounts.&nbsp;</div><div class=3D"">Indeed =
my /home was mounted there with the noquota option, even though the =
fstab clearly stated the quota user and project options.&nbsp;</div><div =
class=3D"">This persisted even if I dismounted and ran xfs_repair of the =
partition in question.</div><div class=3D""><br class=3D""></div><div =
class=3D"">2. I rebooted with a forcefsck file. After the reboot/fsck, =
proc and fstab now match. Both list the partition with valid quota =
options.<br class=3D""><div class=3D""><br =
class=3D"webkit-block-placeholder"></div>
<br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">On Dec 19, 2014, at 4:26 PM, Weber, Charles (NIH/NIA/IRP) [E] =
&lt;<a href=3D"mailto:WeberC@grc.nia.nih.gov" =
class=3D"">WeberC@grc.nia.nih.gov</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D"">
<meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dus-ascii" class=3D""><div style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">HI everyone, long time xfs/quota user with new server and =
problem<div class=3D"">hardware is HP BL460 G7 blade, qlogic fiber =
channel and 3Par 7200 storage</div><div class=3D"">3 16TB vols exported =
from 3Par to server via FC. These are thin volumes, but plenty of =
available backing storage.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Server runs current patched CentOS 6.6</div><div =
class=3D"">kernel 2.6.32-504.3.3.el6.x86_64</div><div class=3D"">xfsprogs =
2.1.1-16.el6</div><div class=3D"">Default mkfs.xfs options for =
volumes</div><div class=3D""><br class=3D""></div><div class=3D"">mount =
options for logical volumes &nbsp;home_lv 39TB imap_lv 4.6TB</div><div =
class=3D""><div class=3D"">/dev/mapper/irphome_vg-home_lv on /home type =
xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)</div><div =
class=3D"">/dev/mapper/irphome_vg-imap_lv on /mail type xfs =
(rw,delaylog,inode64,nobarrier,logbsize=3D256k,uquota,prjquota)</div></div=
><div class=3D""><br class=3D""></div><div class=3D"">Users are from =
large AD via winbind set to not enumerate. I saw the bug with xfs_quota =
report not listing winbind defined user names. Yes this happens to =
me.</div><div class=3D"">I can assign project quota to smaller volume. =
xfs_quota will not report it. I cannot assign a project quota to larger =
volume. I get this error:&nbsp;xfs_quota: cannot set limits: Function =
not implemented.</div><div class=3D""><br class=3D""></div><div =
class=3D""><div class=3D"">xfs_quota -x -c 'report -uh' /mail</div><div =
class=3D"">User quota on /mail =
(/dev/mapper/irphome_vg-imap_lv)</div><div class=3D"">&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
Blocks &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div><div =
class=3D"">User ID &nbsp; &nbsp; &nbsp;Used &nbsp; Soft &nbsp; Hard =
Warn/Grace &nbsp;&nbsp;</div><div class=3D"">---------- =
---------------------------------&nbsp;</div><div class=3D"">root &nbsp; =
&nbsp; &nbsp; &nbsp; 2.2G &nbsp; &nbsp; &nbsp;0 &nbsp; &nbsp; &nbsp;0 =
&nbsp;00 [------]</div><div class=3D""><br class=3D""></div><div =
class=3D"">[xfs_quota -x -c 'report -uh' /home</div></div><div =
class=3D""><br class=3D""></div><div class=3D"">nothing is =
returned</div><div class=3D""><br class=3D""></div><div class=3D"">I can =
set user and project quotas on /mail but cannot see them. I have not =
tested them yet.</div><div class=3D"">I cannot set user or project =
quotas on /home.</div><div class=3D"">At one time I could definitely set =
usr quotas on /home. I did so and verified it worked.&nbsp;</div><div =
class=3D""><br class=3D""></div><div class=3D"">Any ideas what is messed =
up on the /home volume?</div><div class=3D""><br class=3D""></div><div =
class=3D""><br class=3D""></div><div class=3D""><br class=3D""><div =
apple-content-edited=3D"true" class=3D"">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
border-spacing: 0px;"><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; font-family: Helvetica; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: -webkit-auto; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; border-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-stroke-width: =
0px;"><div style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; " class=3D""><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; border-spacing: =
0px; -webkit-text-decorations-in-effect: none; =
-webkit-text-stroke-width: 0px;"><div style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; " =
class=3D""><span class=3D"Apple-style-span" style=3D"border-collapse: =
separate; font-family: Helvetica; font-style: normal; font-variant: =
normal; font-weight: normal; letter-spacing: normal; line-height: =
normal; orphans: 2; text-align: -webkit-auto; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
border-spacing: 0px; -webkit-text-decorations-in-effect: none; =
-webkit-text-stroke-width: 0px;"><div style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; " =
class=3D""><div class=3D"">Weber, Charles (NIH/NIA/IRP)&nbsp;</div><div =
class=3D""><a href=3D"mailto:weberc@mail.nih.gov" =
class=3D"">weberc@mail.nih.gov</a></div><div class=3D"">p: =
410-558-8001</div><div class=3D"">c: 443-473-6493</div><div class=3D"">251=
 Bayview Blvd</div><div class=3D"">Baltimore MD 21224</div><div =
class=3D""><div apple-content-edited=3D"true" class=3D""><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; border-spacing: =
0px; -webkit-text-decorations-in-effect: none; =
-webkit-text-stroke-width: 0px;">NCTS performance comments and survey =
at:</span></div><div class=3D""><a =
href=3D"https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey" =
class=3D"">https://niairpkiosk.irp.nia.nih.gov/content/ncts-user-survey</a=
></div></div><div class=3D""><br class=3D""></div></div></span><br =
class=3D"Apple-interchange-newline"></div></span><br =
class=3D"Apple-interchange-newline"></div></span><br =
class=3D"Apple-interchange-newline"></span><br =
class=3D"Apple-interchange-newline">
</div>
<br class=3D""></div></div></div></blockquote></div><br =
class=3D""></div></body></html>=

--Apple-Mail=_D16214AC-02F7-4953-B610-55F980783BEF--


--===============6449680087486480565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6449680087486480565==--

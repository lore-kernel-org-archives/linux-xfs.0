Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76A1ilV157139 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 05:01:44 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBD781202D71
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 03:02:48 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id sq1R0GdVkW6B0Cno
	for <xfs@oss.sgi.com>; Sat, 06 Aug 2011 03:02:48 -0700 (PDT)
Received: by wyg36 with SMTP id 36so104638wyg.26
	for <xfs@oss.sgi.com>; Sat, 06 Aug 2011 03:01:42 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 6 Aug 2011 20:01:42 +1000
Message-ID: <CAPH64aG=uqdcyxaHQq1Phbmn-xs_rPmhJVoerKKSHG+wumGdrg@mail.gmail.com>
Subject: Errors mounting xfs file system
From: Warrick Howieson <whowieson@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0836244051812373356=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0836244051812373356==
Content-Type: multipart/alternative; boundary=0016e65ae69605d9fe04a9d34d69

--0016e65ae69605d9fe04a9d34d69
Content-Type: text/plain; charset=ISO-8859-1

Hi:

I have a couple of disks out of a NAS unit that I cannot mount.

They were in a Thecus N2200 NAS

When I look at the in gParted, they happily show up as xfs disks, but when I
rty to mount them, Iget a hole bunch of errors.

Can anyone point me in the right direction on how I can mount these disks to
get the data off them


root@sysresccd /mnt % man xfs_repair
root@sysresccd /mnt % xfs_repair -v /dev/sdb2
xfs_repair: cannot open /dev/sdb2: Device or resource busy
root@sysresccd /mnt % man xfs_repair
root@sysresccd /mnt %
root@sysresccd /mnt % xfs_repair -d /dev/sdb2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
 ERROR: The filesystem has valuable metadata changes in a log which needs to
 be replayed.  Mount the filesystem to replay the log, and unmount it before
 re-running xfs_repair.  If you are unable to mount the filesystem, then use
 the -L option to destroy the log and attempt a repair.
 Note that destroying the log may cause corruption -- please attempt a mount
 of the filesystem before doing this.
 root@sysresccd /mnt % mount -t xfs /dev/sdb2 /nas
 mount: /dev/sdb2 already mounted or /nas busy
 root@sysresccd /mnt % xfs_repair -L /dev/sdb2
 xfs_repair: cannot open /dev/sdb2: Device or resource busy

--0016e65ae69605d9fe04a9d34d69
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><div><br></div><div>Hi:</div><div><br></div><div>I have a couple of dis=
ks out of a NAS unit that I cannot mount.</div><div><br></div><div>They wer=
e in a Thecus N2200 NAS</div><div><span class=3D"Apple-style-span" style=3D=
"color: rgb(32, 32, 32); font-family: &#39;Droid Sans&#39;, arial, sans-ser=
if; font-size: 13px; background-color: rgb(255, 255, 255); "><div>
=A0</div><div>When I look at the in gParted, they happily show up as xfs di=
sks, but when I rty to mount them, Iget a hole bunch of errors.</div><div><=
br></div><div>Can anyone point me in the right direction on how I can mount=
 these disks to get the data off them</div>
<div><br></div><div><br></div><div><a href=3D"mailto:root@sysresccd" target=
=3D"_blank" style=3D"color: rgb(103, 117, 58); ">root@sysresccd</a>=A0/mnt =
% man xfs_repair<br><a href=3D"mailto:root@sysresccd" target=3D"_blank" sty=
le=3D"color: rgb(103, 117, 58); ">root@sysresccd</a>=A0/mnt % xfs_repair -v=
 /dev/sdb2<br>
xfs_repair: cannot open /dev/sdb2: Device or resource busy<br><a href=3D"ma=
ilto:root@sysresccd" target=3D"_blank" style=3D"color: rgb(103, 117, 58); "=
>root@sysresccd</a>=A0/mnt % man xfs_repair<br><a href=3D"mailto:root@sysre=
sccd" target=3D"_blank" style=3D"color: rgb(103, 117, 58); ">root@sysresccd=
</a>=A0/mnt %=A0<br>
<a href=3D"mailto:root@sysresccd" target=3D"_blank" style=3D"color: rgb(103=
, 117, 58); ">root@sysresccd</a>=A0/mnt % xfs_repair -d /dev/sdb2<br>Phase =
1 - find and verify superblock...<br>Phase 2 - using internal log<br>=A0=A0=
=A0=A0=A0=A0=A0 - zero log...<br>
=A0ERROR: The filesystem has valuable metadata changes in a log which needs=
 to<br>=A0be replayed.=A0 Mount the filesystem to replay the log, and unmou=
nt it before<br>=A0re-running xfs_repair.=A0 If you are unable to mount the=
 filesystem, then use<br>
=A0the -L option to destroy the log and attempt a repair.<br>=A0Note that d=
estroying the log may cause corruption -- please attempt a mount<br>=A0of t=
he filesystem before doing this.<br>=A0<a href=3D"mailto:root@sysresccd" ta=
rget=3D"_blank" style=3D"color: rgb(103, 117, 58); ">root@sysresccd</a>=A0/=
mnt % mount -t xfs /dev/sdb2 /nas<br>
=A0mount: /dev/sdb2 already mounted or /nas busy<br>=A0<a href=3D"mailto:ro=
ot@sysresccd" target=3D"_blank" style=3D"color: rgb(103, 117, 58); ">root@s=
ysresccd</a>=A0/mnt % xfs_repair -L /dev/sdb2<br>=A0xfs_repair: cannot open=
 /dev/sdb2: Device or resource busy</div>
<div>=A0</div><div>=A0</div></span></div>

--0016e65ae69605d9fe04a9d34d69--


--===============0836244051812373356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0836244051812373356==--

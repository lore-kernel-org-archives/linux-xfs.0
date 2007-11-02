Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 20:00:22 -0700 (PDT)
Received: from sc3app27.rit.edu (sc3app27.rit.edu [129.21.35.56])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA230Ibt021435
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 20:00:19 -0700
Received: from cias-jpspgd-macbook.jayps.home
 (cpe-72-230-182-205.rochester.res.rr.com [72.230.182.205])
 by smtp-server.rit.edu (PMDF V6.3-x14 #31420)
 with ESMTPSA id <0JQU00IC1WLNI4@smtp-server.rit.edu> for xfs@oss.sgi.com; Thu,
 01 Nov 2007 22:08:13 -0400 (EDT)
Date: Thu, 01 Nov 2007 22:08:09 -0400
From: Jay Sullivan <jpspgd@rit.edu>
Subject: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Message-id: <3A2120EF-3EB0-4CF1-8C4E-920B9688D51F@rit.edu>
MIME-version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

(Sorry if this is a dupe to the list; it has been a long day.)

I have an XFS filesystem that has had the following happen twice in 3=20=20
months, both times an impossibly large block number was requested.=20=20=20
Unfortunately my logs don=92t go back far enough for me to know if it=20=20
was the _exact_ same block both times=85  I=92m running xfsprogs 2.8.21.=20=
=20=20
Excerpt from syslog (hostname obfuscated to =91servername=92 to protect=20=
=20
the innocent):

##
Nov  1 14:06:32 servername dm-1: rw=3D0, want=3D39943195856896,=20=20
limit=3D7759462400
Nov  1 14:06:32 servername I/O error in filesystem ("dm-1") meta-data=20=20
dev dm-1 block 0x245400000ff8       ("xfs_trans_read_buf") error 5 buf=20=
=20
count 4096
Nov  1 14:06:32 servername xfs_force_shutdown(dm-1,0x1) called from=20=20
line 415 of file fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc02baa25
Nov  1 14:06:32 servername Filesystem "dm-1": I/O Error Detected.=20=20=20
Shutting down filesystem: dm-1
Nov  1 14:06:32 servername Please umount the filesystem, and rectify=20=20
the problem(s)
###

I ran xfs_repair =96L on the FS and it could be mounted again, but how=20=
=20
long until it happens a third time?  What concerns me is that this is=20=20
a FS smaller than 4TB and 39943195856896 (or 0x245400000ff8) seems=20=20
like a block that I would only have if my FS was muuuuuch larger.  The=20=
=20
following is output from some pertinent programs:

###
servername ~ # xfs_info /mnt/san
meta-data=3D/dev/servername-sanvg01/servername-sanlv01 isize=3D256=20=20=20=
=20=20
agcount=3D5, agsize=3D203161600 blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D969932800,=20=20
imaxpct=3D25
          =3D                       sunit=3D0      swidth=3D0 blks,=20=20
unwritten=3D1
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=20
count=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
servername ~ # mount
/dev/sda3 on / type ext3 (rw,noatime,acl)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec)
udev on /dev type tmpfs (rw,nosuid)
devpts on /dev/pts type devpts (rw,nosuid,noexec)
shm on /dev/shm type tmpfs (rw,noexec,nosuid,nodev)
usbfs on /proc/bus/usb type usbfs=20=20
(rw,noexec,nosuid,devmode=3D0664,devgid=3D85)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc=20=20
(rw,noexec,nosuid,nodev)
nfsd on /proc/fs/nfsd type nfsd (rw)
/dev/mapper/servername--sanvg01-servername--sanlv01 on /mnt/san type=20=20
xfs (rw,noatime,nodiratime,logbufs=3D8,attr2)
/dev/mapper/servername--sanvg01-servername--rendersharelv01 on /mnt/=20
san/rendershare type xfs (rw,noatime,nodiratime,logbufs=3D8,attr2)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
servername ~ # uname -a
Linux servername 2.6.20-gentoo-r8 #7 SMP Fri Jun 29 14:46:02 EDT 2007=20=20
i686 Intel(R) Xeon(TM) CPU 3.20GHz GenuineIntel GNU/Linux
###

Does anyone know if this points to a bad block on a disk or if=20=20
something is corrupted and can be fixed with some expert knowledge of=20=20
xfs_db?

~Jay

[[HTML alternate version deleted]]

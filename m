Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD9FB7FB4
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 11:04:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84004304043
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:04:13 -0800 (PST)
Received: from srvmail.3sr-grenoble.fr (3sr-srvmail.ampere.inpg.fr
	[147.171.64.82]) by cuda.sgi.com with ESMTP id d5cvXIGv2sFH8EC5
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 09:04:12 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by srvmail.3sr-grenoble.fr (Postfix) with SMTP id 0AB0828A0AC
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 18:04:12 +0100 (CET)
Received: from [147.171.84.252] (hamaika.3sr.grenoble-inp.fr [147.171.84.252])
	by srvmail.3sr-grenoble.fr (Postfix) with ESMTPSA id E3FF028A0AB
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 18:04:11 +0100 (CET)
Message-ID: <511BC78B.6070205@3sr-grenoble.fr>
Date: Wed, 13 Feb 2013 18:04:11 +0100
From: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
MIME-Version: 1.0
Subject: problem after growing
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I face a strange and scary issue. I just grow a xfs filesystem (44To), =

and no way to mount it anymore :
XFS: device supports only 4096 byte sectors (not 512)

# xfs_check /dev/vg0/tomo-201111
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

# xfs_repair -L /dev/vg0/tomo-201111
xfs_repair: warning - cannot set blocksize 512 on block device =

/dev/vg0/tomo-201111: Argument invalide
Phase 1 - find and verify superblock...
superblock read failed, offset 1099511623680, size 2048, ag 1, rval -1

fatal error -- Invalid argument

Conf is as follow :

LVM : 3pv - 1vg

the lv containing the xfs system is on several extents :

   tomo-201111 vg0  -wi-ao    1 linear  15,34t /dev/sda:5276160-9298322
   tomo-201111 vg0  -wi-ao    1 linear  18,66t /dev/sdb:0-4890732
   tomo-201111 vg0  -wi-ao    1 linear   8,81t /dev/sdb:6987885-9298322
   tomo-201111 vg0  -wi-ao    1 linear   1,19t /dev/sdc:2883584-3194585

before growing fs, I lvextend the vg, and a new extents on /dev/sdc was =

used. I cant think it caused this issue... I saw there can be problem =

with underlying device (an ARECA 1880). With xfs_db, I found this strange :
  "logsectsize =3D 0"

# xfs_db -c "sb 0" -c "p" /dev/vg0/tomo-201111
magicnum =3D 0x58465342
blocksize =3D 4096
dblocks =3D 10468982745
rblocks =3D 0
rextents =3D 0
uuid =3D 09793bea-952b-44fa-be71-02f59e69b41b
logstart =3D 1342177284
rootino =3D 128
rbmino =3D 129
rsumino =3D 130
rextsize =3D 1
agblocks =3D 268435455
agcount =3D 39
rbmblocks =3D 0
logblocks =3D 521728
versionnum =3D 0xb4b4
sectsize =3D 512
inodesize =3D 256
inopblock =3D 16
fname =3D "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog =3D 12
sectlog =3D 9
inodelog =3D 8
inopblog =3D 4
agblklog =3D 28
rextslog =3D 0
inprogress =3D 0
imax_pct =3D 5
icount =3D 6233280
ifree =3D 26
fdblocks =3D 1218766953
frextents =3D 0
uquotino =3D 0
gquotino =3D 0
qflags =3D 0
flags =3D 0
shared_vn =3D 0
inoalignmt =3D 2
unit =3D 0
width =3D 0
dirblklog =3D 0
logsectlog =3D 0
logsectsize =3D 0
logsunit =3D 1
features2 =3D 0xa
bad_features2 =3D 0xa


Any idea ?

Cheers,
r=E9mi

-- =

R=E9mi Cailletaud - IE CNRS
3SR - Laboratoire Sols, Solides, Structures - Risques
BP53, 38041 Grenoble CEDEX 0
FRANCE
remi.cailletaud@3sr-grenoble.fr
T=E9l: +33 (0)4 76 82 52 78
Fax: +33 (0)4 76 82 70 43



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

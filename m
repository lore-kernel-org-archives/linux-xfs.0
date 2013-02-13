Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 49C027FB1
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 10:10:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 311EA8F8078
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 08:10:48 -0800 (PST)
Received: from srvmail.3sr-grenoble.fr (3sr-srvmail.ampere.inpg.fr
	[147.171.64.82]) by cuda.sgi.com with ESMTP id Br7e28g8HkcoDGD4
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 08:10:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by srvmail.3sr-grenoble.fr (Postfix) with SMTP id 1275E28A0A9
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 17:10:46 +0100 (CET)
Received: from [147.171.84.252] (hamaika.3sr.grenoble-inp.fr [147.171.84.252])
	by srvmail.3sr-grenoble.fr (Postfix) with ESMTPSA id E92F728A0A3
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 17:10:45 +0100 (CET)
Message-ID: <511BBB05.5040002@3sr-grenoble.fr>
Date: Wed, 13 Feb 2013 17:10:45 +0100
From: =?ISO-8859-1?Q?R=E9mi_Cailletaud?= <remi.cailletaud@3sr-grenoble.fr>
MIME-Version: 1.0
Subject: sector change after growing ?
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

xfs_check /dev/vg0/tomo-201111
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check.  If you are unable to mount the filesystem, then use
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

xfs_repair -L /dev/vg0/tomo-201111
xfs_repair: warning - cannot set blocksize 512 on block device =

/dev/vg0/tomo-201111: Argument invalide
Phase 1 - find and verify superblock...
superblock read failed, offset 1099511623680, size 2048, ag 1, rval -1

fatal error -- Invalid argument


I  don't think i did a mistake, my conf is as follow :

LVM : 3pv - 1vg

the lv containing the xfs system is on several extents :

   tomo-201111 vg0  -wi-ao    1 linear  15,34t /dev/sda:5276160-9298322
   tomo-201111 vg0  -wi-ao    1 linear  18,66t /dev/sdb:0-4890732
   tomo-201111 vg0  -wi-ao    1 linear   8,81t /dev/sdb:6987885-9298322
   tomo-201111 vg0  -wi-ao    1 linear   1,19t /dev/sdc:2883584-3194585

before growing fs, I lvextend the vg, and a new extents on /dev/sdc was =

used. I cant think it caused this issue...

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

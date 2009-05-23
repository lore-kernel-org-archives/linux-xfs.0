Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NJU2W8015019 for <xfs@oss.sgi.com>; Sat, 23 May 2009 14:30:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86C4FFFF9CD
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 12:35:48 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 4JaUNaphUyM4rnKL for
	<xfs@oss.sgi.com>; Sat, 23 May 2009 12:35:48 -0700 (PDT)
Message-ID: <4A184EC4.1050007@sandeen.net>
Date: Sat, 23 May 2009 14:30:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix overflow in xfs_growfs_data_private
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Richard Ems <Richard.Ems@cape-horn-eng.com>

In the case where growing a filesystem would leave the last AG
too small, the fixup code has an overflow in the calculation
of the new size with one fewer ag, because "nagcount" is a 32
bit number.  If the new filesystem has > 2^32 blocks in it
this causes a problem resulting in an EINVAL return from growfs:

# xfs_io -f -c "truncate 19998630180864" fsfile
# mkfs.xfs -f -bsize=4096 -dagsize=76288719b,size=3905982455b fsfile
# mount -o loop fsfile mnt/
# xfs_growfs mnt/
meta-data=/dev/loop0             isize=256    agcount=52,
agsize=76288719 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3905982455, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument

Reported-by: richard.ems@cape-horn-eng.com
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c
+++ linux-2.6/fs/xfs/xfs_fsops.c
@@ -160,7 +160,7 @@ xfs_growfs_data_private(
 	nagcount = new + (nb_mod != 0);
 	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
 		nagcount--;
-		nb = nagcount * mp->m_sb.sb_agblocks;
+		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
 		if (nb < mp->m_sb.sb_dblocks)
 			return XFS_ERROR(EINVAL);
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

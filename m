Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1B0NAgb085408 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 18:23:11 -0600
Received: from [134.14.52.238] (unknown [134.14.52.238])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 804678F80CF
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 16:22:30 -0800 (PST)
Message-ID: <49921B3E.8040406@sgi.com>
Date: Wed, 11 Feb 2009 11:26:38 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Don't reset di_format in xfs_ifree()
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

I hit a panic while flushing a reclaimed inode that is fairly
reproducible under load.

In xfs_iflush_fork() we're led to believe that there are extents
on this inode but there aren't any.  Actually the inode was a
directory.  I added some debugging to xfs_ifree() and found
that di_format was XFS_DINODE_FMT_LOCAL and got reset to
XFS_DINODE_FMT_EXTENTS and this has confused the code in
xfs_iflush_fork().

[<ffffffffa0047de7>] xfs_iext_get_ext+0x6c/0xca [xfs]
[<ffffffffa004a3d4>] xfs_iflush_fork+0x1b0/0x3c6 [xfs]
[<ffffffffa004aa3f>] xfs_iflush_int+0x455/0x5a1 [xfs]
[<ffffffffa004b0da>] xfs_iflush+0x229/0x2d6 [xfs]
[<ffffffffa007283c>] xfs_reclaim_inode+0xd8/0x10f [xfs]
[<ffffffffa0072976>] xfs_reclaim_inodes_ag+0x103/0x13e [xfs]
[<ffffffffa00729f3>] xfs_reclaim_inodes+0x42/0x60 [xfs]
[<ffffffffa0072d1b>] xfs_sync_worker+0x30/0x8a [xfs]
[<ffffffffa0073416>] xfssyncd+0x14e/0x1a2 [xfs]
[<ffffffffa00732c8>] ? xfssyncd+0x0/0x1a2 [xfs]
[<ffffffff8104fc70>] kthread+0x49/0x79

I made this change and it passes the load test and XFSQA too.  I'm
not sure if this is indicative of a bigger problem though.

Index: xfs-fix/fs/xfs/xfs_inode.c
===================================================================
--- xfs-fix.orig/fs/xfs/xfs_inode.c
+++ xfs-fix/fs/xfs/xfs_inode.c
@@ -2165,8 +2165,6 @@ xfs_ifree(
  	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
  	ip->i_df.if_ext_max =
  		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
  	/*
  	 * Bump the generation count so no one will be confused
  	 * by reincarnations of this inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

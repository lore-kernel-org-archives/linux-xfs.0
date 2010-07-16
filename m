Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6GIpL7U019053 for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 13:51:22 -0500
Received: from CF--AMER002E--3.americas.sgi.com
	(cf--amer002e--3.americas.sgi.com [137.38.100.6])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35DE58F80B8
	for <xfs@oss.sgi.com>; Fri, 16 Jul 2010 11:54:17 -0700 (PDT)
Subject: [PATCH] xfs:negative_icount.patch
From: Stuart Brodsky <sbrodsky@sgi.com>
Date: Fri, 16 Jul 2010 13:53:41 -0500
Message-ID: <1279306421.17689.38.camel@superior.americas.sgi.com>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

This patch fixes the stat -f icount field going negative.  The use of
lazy counts means that the super block field sb_icount is not updated
correctly and will allow over allocation of inodes above maxicount.

Signed-off-by: Stu Brodsky <sbrodsky@sgi.com>

Index: a/fs/xfs/xfs_ialloc.c
===================================================================
--- a/fs/xfs/xfs_ialloc.c.orig	2010-07-16 10:12:02.000000000 -0500
+++ b/fs/xfs/xfs_ialloc.c	2010-07-16 10:19:56.312633030 -0500
@@ -260,7 +260,7 @@
 	 */
 	newlen = XFS_IALLOC_INODES(args.mp);
 	if (args.mp->m_maxicount &&
-	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
+	    atomic64_read(&args.mp->m_inodesinuse) + newlen >
args.mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
 	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
 	/*
@@ -708,7 +708,7 @@
 	 */
 
 	if (mp->m_maxicount &&
-	    mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
+	    atomic64_read(&mp->m_inodesinuse) + XFS_IALLOC_INODES(mp) >
mp->m_maxicount)
 		noroom = 1;
 		okalloc = 0;
 	}
Index: b/fs/xfs/xfs_mount.c
===================================================================
--- a/fs/xfs/xfs_mount.c.orig	2010-07-16 10:12:02.000000000 -0500
+++ b/fs/xfs/xfs_mount.c	2010-07-16 10:20:49.717572132 -0500
@@ -744,6 +744,7 @@
 	mp->m_blockmask = sbp->sb_blocksize - 1;
 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
 	mp->m_blockwmask = mp->m_blockwsize - 1;
+	atomic64_set(&mp->m_inodesinuse,sbp->sb_icount);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
Index: a/fs/xfs/xfs_mount.h
===================================================================
--- a/fs/xfs/xfs_mount.h.orig	2010-07-16 10:12:02.000000000 -0500
+++ b/fs/xfs/xfs_mount.h	2010-07-16 10:21:36.377577685 -0500
@@ -137,6 +137,7 @@
 	__uint8_t		m_agno_log;	/* log #ag's */
 	__uint8_t		m_agino_log;	/* #bits for agino in inum */
 	__uint16_t		m_inode_cluster_size;/* min inode buf size */
+	atomic64_t		m_inodesinuse;	/* in use inodes */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
Index: a/fs/xfs/xfs_trans.c
===================================================================
--- a/fs/xfs/xfs_trans.c.orig	2010-07-16 10:12:02.000000000 -0500
+++ b/fs/xfs/xfs_trans.c	2010-07-16 10:22:47.690249548 -0500
@@ -805,6 +805,7 @@
 	switch (field) {
 	case XFS_TRANS_SB_ICOUNT:
 		tp->t_icount_delta += delta;
+		atomic64_add(delta,&tp->t_mountp->m_inodesinuse);
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
 			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;




-- 
Stuart Brodsky
2750 Blue Water Road
Eagan, MN. 55121
651-683-7910
<sbrodsky@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

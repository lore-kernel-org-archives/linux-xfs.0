Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:02:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7572YPm019666
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:02:35 -0700
Message-ID: <4897FCC7.400@sgi.com>
Date: Tue, 05 Aug 2008 17:09:59 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Use KM_NOFS for debug trace buffers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Use KM_NOFS to prevent recursion back into the filesystem which can
cause deadlocks.

In the case of xfs_iread() we hold the lock on the inode cluster buffer
while allocating memory for the trace buffers.  If we recurse back into
XFS to flush data that may require a transaction to allocate extents
which needs log space.  This can deadlock with the xfsaild thread which
can't push the tail of the log because it is trying to get the inode
cluster buffer lock.

--- a/fs/xfs/linux-2.6/xfs_buf.c	2008-08-05 16:38:48.000000000 +1000
+++ b/fs/xfs/linux-2.6/xfs_buf.c	2008-08-05 16:38:43.000000000 +1000
@@ -1795,7 +1795,7 @@ int __init
 xfs_buf_init(void)
 {
 #ifdef XFS_BUF_TRACE
-	xfs_buf_trace_buf = ktrace_alloc(XFS_BUF_TRACE_SIZE, KM_SLEEP);
+	xfs_buf_trace_buf = ktrace_alloc(XFS_BUF_TRACE_SIZE, KM_NOFS);
 #endif
 
 	xfs_buf_zone = kmem_zone_init_flags(sizeof(xfs_buf_t), "xfs_buf",
--- a/fs/xfs/quota/xfs_dquot.c	2008-08-05 16:38:48.000000000 +1000
+++ b/fs/xfs/quota/xfs_dquot.c	2008-08-05 13:54:41.000000000 +1000
@@ -105,7 +105,7 @@ xfs_qm_dqinit(
 		sv_init(&dqp->q_pinwait, SV_DEFAULT, "pdq");
 
 #ifdef XFS_DQUOT_TRACE
-		dqp->q_trace = ktrace_alloc(DQUOT_TRACE_SIZE, KM_SLEEP);
+		dqp->q_trace = ktrace_alloc(DQUOT_TRACE_SIZE, KM_NOFS);
 		xfs_dqtrace_entry(dqp, "DQINIT");
 #endif
 	} else {
--- a/fs/xfs/xfs_buf_item.c	2008-08-05 16:38:48.000000000 +1000
+++ b/fs/xfs/xfs_buf_item.c	2008-08-05 13:54:42.000000000 +1000
@@ -737,7 +737,7 @@ xfs_buf_item_init(
 	bip->bli_format.blf_len = (ushort)BTOBB(XFS_BUF_COUNT(bp));
 	bip->bli_format.blf_map_size = map_size;
 #ifdef XFS_BLI_TRACE
-	bip->bli_trace = ktrace_alloc(XFS_BLI_TRACE_SIZE, KM_SLEEP);
+	bip->bli_trace = ktrace_alloc(XFS_BLI_TRACE_SIZE, KM_NOFS);
 #endif
 
 #ifdef XFS_TRANS_DEBUG
--- a/fs/xfs/xfs_filestream.c	2008-08-05 16:38:48.000000000 +1000
+++ b/fs/xfs/xfs_filestream.c	2008-08-05 13:54:42.000000000 +1000
@@ -400,7 +400,7 @@ xfs_filestream_init(void)
 	if (!item_zone)
 		return -ENOMEM;
 #ifdef XFS_FILESTREAMS_TRACE
-	xfs_filestreams_trace_buf = ktrace_alloc(XFS_FSTRM_KTRACE_SIZE, KM_SLEEP);
+	xfs_filestreams_trace_buf = ktrace_alloc(XFS_FSTRM_KTRACE_SIZE, KM_NOFS);
 #endif
 	return 0;
 }
--- a/fs/xfs/xfs_inode.c	2008-08-05 16:38:48.000000000 +1000
+++ b/fs/xfs/xfs_inode.c	2008-08-05 13:54:42.000000000 +1000
@@ -835,22 +835,22 @@ xfs_iread(
 	 * Do this before xfs_iformat in case it adds entries.
 	 */
 #ifdef	XFS_INODE_TRACE
-	ip->i_trace = ktrace_alloc(INODE_TRACE_SIZE, KM_SLEEP);
+	ip->i_trace = ktrace_alloc(INODE_TRACE_SIZE, KM_NOFS);
 #endif
 #ifdef XFS_BMAP_TRACE
-	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_SLEEP);
+	ip->i_xtrace = ktrace_alloc(XFS_BMAP_KTRACE_SIZE, KM_NOFS);
 #endif
 #ifdef XFS_BMBT_TRACE
-	ip->i_btrace = ktrace_alloc(XFS_BMBT_KTRACE_SIZE, KM_SLEEP);
+	ip->i_btrace = ktrace_alloc(XFS_BMBT_KTRACE_SIZE, KM_NOFS);
 #endif
 #ifdef XFS_RW_TRACE
-	ip->i_rwtrace = ktrace_alloc(XFS_RW_KTRACE_SIZE, KM_SLEEP);
+	ip->i_rwtrace = ktrace_alloc(XFS_RW_KTRACE_SIZE, KM_NOFS);
 #endif
 #ifdef XFS_ILOCK_TRACE
-	ip->i_lock_trace = ktrace_alloc(XFS_ILOCK_KTRACE_SIZE, KM_SLEEP);
+	ip->i_lock_trace = ktrace_alloc(XFS_ILOCK_KTRACE_SIZE, KM_NOFS);
 #endif
 #ifdef XFS_DIR2_TRACE
-	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_SLEEP);
+	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
 
 	/*
--- a/fs/xfs/xfs_log.c	2008-08-05 16:38:48.000000000 +1000
+++ b/fs/xfs/xfs_log.c	2008-08-05 13:54:42.000000000 +1000
@@ -160,7 +160,7 @@ void
 xlog_trace_iclog(xlog_in_core_t *iclog, uint state)
 {
 	if (!iclog->ic_trace)
-		iclog->ic_trace = ktrace_alloc(256, KM_SLEEP);
+		iclog->ic_trace = ktrace_alloc(256, KM_NOFS);
 	ktrace_enter(iclog->ic_trace,
 		     (void *)((unsigned long)state),
 		     (void *)((unsigned long)current_pid()),

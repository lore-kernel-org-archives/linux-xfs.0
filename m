Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:18739 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbeLCNRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 08:17:02 -0500
From: Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH] fs/xfs: Add support for passing write life-time hint with
 log
Date: Mon, 03 Dec 2018 18:42:49 +0530
Message-id: <1543842769-6363-1-git-send-email-joshi.k@samsung.com>
References: <CGME20181203131558epcas2p14b6b38cb67d4915b1ba782e11ce7ffe6@epcas2p1.samsung.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>

Log gets updated in a circular fashion, and that makes life-time   
of log-data different from other types of meta/user-data.                            
By passing a write life-time hint with log, GC efficiency of multi-stream SSD   
gets improved, leading to endurance/performance benefits.                       
It is described in greater detail (along with results) in this "FAST 2018"      
paper -                                                                         
https://www.usenix.org/conference/fast18/presentation/rho                       
                                                                                
This patch introduces new mount option "logwritehint" to pass write hint
with XFS log.
Among other Linux file-systems, F2FS supports passing down such write      
hints. While for Ext4 journal, I am preparing similar proposal.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/xfs/xfs_buf.c         |  2 ++
 fs/xfs/xfs_buf.h         |  1 +
 fs/xfs/xfs_log.c         |  3 +++
 fs/xfs/xfs_log_recover.c |  1 +
 fs/xfs/xfs_mount.h       |  2 ++
 fs/xfs/xfs_super.c       | 15 +++++++++++++--
 6 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b21ea2b..00d17f6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1370,6 +1370,8 @@ xfs_buf_ioapply_map(
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 	bio_set_op_attrs(bio, op, op_flags);
+	/* set write hint in bio */
+	bio->bi_write_hint = bp->b_write_hint;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511..ba9c78c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -196,6 +196,7 @@ typedef struct xfs_buf {
 	int			b_retries;
 	unsigned long		b_first_retry_time; /* in jiffies */
 	int			b_last_error;
+	enum rw_hint		b_write_hint;	/* write hint for I/O */
 
 	const struct xfs_buf_ops	*b_ops;
 } xfs_buf_t;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b..45e220d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1881,6 +1881,8 @@ xlog_sync(
 	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
 
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
+	/* set write hint in buffer */
+	bp->b_write_hint = log->l_mp->m_logwritehint;
 
 	/* Do we need to split this write into 2 parts? */
 	if (XFS_BUF_ADDR(bp) + BTOBB(count) > log->l_logBBsize) {
@@ -1971,6 +1973,7 @@ xlog_sync(
 		bp->b_log_item = iclog;
 		bp->b_flags &= ~XBF_FLUSH;
 		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
+		bp->b_write_hint = log->l_mp->m_logwritehint;
 
 		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
 		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1fc9e90..8bf89fa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -282,6 +282,7 @@ xlog_bwrite(
 	xfs_buf_lock(bp);
 	bp->b_io_length = nbblks;
 	bp->b_error = 0;
+	bp->b_write_hint = log->l_mp->m_logwritehint;
 
 	error = xfs_bwrite(bp);
 	if (error)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7964513..7f6b2b8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -171,6 +171,8 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
+	/* To store write hint (for log writes) passed during mount */
+	int			m_logwritehint;
 
 	/*
 	 * Generation of the filesysyem layout.  This is incremented by each
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d3e6cd0..6449d213 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -71,7 +71,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_logwritehint, Opt_err,
 };
 
 static const match_table_t tokens = {
@@ -119,6 +119,7 @@ static const match_table_t tokens = {
 	{Opt_discard,	"discard"},	/* Discard unused blocks */
 	{Opt_nodiscard,	"nodiscard"},	/* Do not discard unused blocks */
 	{Opt_dax,	"dax"},		/* Enable direct access to bdev pages */
+	{Opt_logwritehint, "logwritehint=%u"},/* Write-hint for log */
 	{Opt_err,	NULL},
 };
 
@@ -225,6 +226,10 @@ xfs_parseargs(
 			if (match_int(args, &mp->m_logbufs))
 				return -EINVAL;
 			break;
+		case Opt_logwritehint:
+			if (match_int(args, &mp->m_logwritehint))
+				return -EINVAL;
+			break;
 		case Opt_logbsize:
 			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
 				return -EINVAL;
@@ -405,7 +410,6 @@ xfs_parseargs(
 		mp->m_dalign = dsunit;
 		mp->m_swidth = dswidth;
 	}
-
 	if (mp->m_logbufs != -1 &&
 	    mp->m_logbufs != 0 &&
 	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
@@ -438,6 +442,13 @@ xfs_parseargs(
 		mp->m_readio_log = iosizelog;
 		mp->m_writeio_log = iosizelog;
 	}
+	if (mp->m_logwritehint < WRITE_LIFE_NOT_SET ||
+	    mp->m_logwritehint > WRITE_LIFE_EXTREME) {
+		xfs_warn(mp, "invalid logwritehint value: %d [not %d-%d]",
+			mp->m_logwritehint, WRITE_LIFE_NOT_SET, WRITE_LIFE_EXTREME);
+		return -EINVAL;
+
+	}
 
 	return 0;
 }
-- 
2.7.4

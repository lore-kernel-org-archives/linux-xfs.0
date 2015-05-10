Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DD9E7F4E
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 14:20:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 938ED304048
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 12:20:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4CvotXE1AiuWfIG3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 May 2015 12:19:55 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YrWlX-0006TI-0M
	for xfs@oss.sgi.com; Sun, 10 May 2015 19:19:55 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: pass a boolean flag to xfs_trans_free_items
Date: Sun, 10 May 2015 21:18:36 +0200
Message-Id: <1431285519-7768-2-git-send-email-hch@lst.de>
In-Reply-To: <1431285519-7768-1-git-send-email-hch@lst.de>
References: <1431285519-7768-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The flags value always was 0 or XFS_TRANS_ABORT.  Switch to a bool
parameter to allow further cleanups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c    | 2 +-
 fs/xfs/xfs_trans.c      | 8 ++++----
 fs/xfs/xfs_trans_priv.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 45cc0ce..7e0e63e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -809,7 +809,7 @@ xfs_log_commit_cil(
 	 * the log items. This affects (at least) processing of stale buffers,
 	 * inodes and EFIs.
 	 */
-	xfs_trans_free_items(tp, tp->t_commit_lsn, 0);
+	xfs_trans_free_items(tp, tp->t_commit_lsn, false);
 
 	xlog_cil_push_background(log);
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a2dfb30..42a1adf 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -744,7 +744,7 @@ void
 xfs_trans_free_items(
 	struct xfs_trans	*tp,
 	xfs_lsn_t		commit_lsn,
-	int			flags)
+	bool			abort)
 {
 	struct xfs_log_item_desc *lidp, *next;
 
@@ -755,7 +755,7 @@ xfs_trans_free_items(
 
 		if (commit_lsn != NULLCOMMITLSN)
 			lip->li_ops->iop_committing(lip, commit_lsn);
-		if (flags & XFS_TRANS_ABORT)
+		if (abort)
 			lip->li_flags |= XFS_LI_ABORTED;
 		lip->li_ops->iop_unlock(lip);
 
@@ -969,7 +969,7 @@ out_unreserve:
 			error = -EIO;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-	xfs_trans_free_items(tp, NULLCOMMITLSN, error ? XFS_TRANS_ABORT : 0);
+	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
 	xfs_trans_free(tp);
 
 	XFS_STATS_INC(xs_trans_empty);
@@ -1031,7 +1031,7 @@ xfs_trans_cancel(
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 
-	xfs_trans_free_items(tp, NULLCOMMITLSN, flags);
+	xfs_trans_free_items(tp, NULLCOMMITLSN, flags & XFS_TRANS_ABORT);
 	xfs_trans_free(tp);
 }
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index bd12818..1b73629 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -30,7 +30,7 @@ void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
-				int flags);
+				bool abort);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

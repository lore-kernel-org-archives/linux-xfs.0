Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 18:12:52 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B1Co2G017329
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:12:50 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0535C18B0C62
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:13:55 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id JIMTBgc7QUWqRmtf for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:13:55 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] Replace the XFS buf iodone semaphore with a completion
Date: Fri, 11 Jul 2008 11:13:46 +1000
Message-Id: <1215738830-31048-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1215738830-31048-1-git-send-email-david@fromorbit.com>
References: <1215738830-31048-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx, Dave Chinner <david@fromorbit.com>

The xfs_buf_t b_iodonesema is really just a semaphore
that wants to be a completion. Change it to a completion
and remove the last user of the sema_t from XFS.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    6 +++---
 fs/xfs/linux-2.6/xfs_buf.h |    4 ++--
 fs/xfs/xfs_buf_item.c      |    2 +-
 fs/xfs/xfs_rw.c            |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 9cc8f02..9438c90 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -253,7 +253,7 @@ _xfs_buf_initialize(
 
 	memset(bp, 0, sizeof(xfs_buf_t));
 	atomic_set(&bp->b_hold, 1);
-	init_MUTEX_LOCKED(&bp->b_iodonesema);
+	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_hash_list);
 	init_MUTEX_LOCKED(&bp->b_sema); /* held, no waiters */
@@ -1037,7 +1037,7 @@ xfs_buf_ioend(
 			xfs_buf_iodone_work(&bp->b_iodone_work);
 		}
 	} else {
-		up(&bp->b_iodonesema);
+		complete(&bp->b_iowait);
 	}
 }
 
@@ -1275,7 +1275,7 @@ xfs_buf_iowait(
 	XB_TRACE(bp, "iowait", 0);
 	if (atomic_read(&bp->b_io_remaining))
 		blk_run_address_space(bp->b_target->bt_mapping);
-	down(&bp->b_iodonesema);
+	wait_for_completion(&bp->b_iowait);
 	XB_TRACE(bp, "iowaited", (long)bp->b_error);
 	return bp->b_error;
 }
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 29d1d4a..fe01099 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -157,7 +157,7 @@ typedef struct xfs_buf {
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	xfs_buf_relse_t		b_relse;	/* releasing function */
 	xfs_buf_bdstrat_t	b_strat;	/* pre-write function */
-	struct semaphore	b_iodonesema;	/* Semaphore for I/O waiters */
+	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
 	void			*b_fspriv3;
@@ -352,7 +352,7 @@ extern void xfs_buf_trace(xfs_buf_t *, char *, void *, void *);
 #define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
 #define XFS_BUF_VSEMA(bp)	xfs_buf_unlock(bp)
 #define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
-#define XFS_BUF_V_IODONESEMA(bp) up(&bp->b_iodonesema);
+#define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
 #define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
 #define XFS_BUF_TARGET(bp)		((bp)->b_target)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d86ca2c..215c36d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1056,7 +1056,7 @@ xfs_buf_iodone_callbacks(
 			   anyway. */
 			XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
 			XFS_BUF_DONE(bp);
-			XFS_BUF_V_IODONESEMA(bp);
+			XFS_BUF_FINISH_IOWAIT(bp);
 		}
 		return;
 	}
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
index b0f31c0..3a82576 100644
--- a/fs/xfs/xfs_rw.c
+++ b/fs/xfs/xfs_rw.c
@@ -314,7 +314,7 @@ xfs_bioerror_relse(
 		 * ASYNC buffers.
 		 */
 		XFS_BUF_ERROR(bp, EIO);
-		XFS_BUF_V_IODONESEMA(bp);
+		XFS_BUF_FINISH_IOWAIT(bp);
 	} else {
 		xfs_buf_relse(bp);
 	}
-- 
1.5.6

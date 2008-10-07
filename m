Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:12:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97MCMos011232
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:12:22 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 167B64C8373
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:14:01 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id CZ3sAgpdVzaELJVW for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:14:01 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKoY-0002dU-Ju
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:13:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] XFS: Allow 64 bit machines to avoid the AIL lock during flushes
Date: Wed,  8 Oct 2008 09:13:54 +1100
Message-Id: <1223417638-10050-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417638-10050-1-git-send-email-david@fromorbit.com>
References: <1223417638-10050-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When copying lsn's from the log item to the inode or dquot
flush lsn, we currently grab the AIL lock. We do this because the
LSN is a 64 bit quantity and it needs to be read atomically.
The lock is used to guarantee atomicity for 32 bit platforms.

Make the LSN copying a small function, and make the function
used conditional on BITS_PER_LONG so that 64 bit machines don't
need to take the AIL lock in these places.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c |    6 ++----
 fs/xfs/xfs_inode.c       |   17 +++++++----------
 fs/xfs/xfs_trans_priv.h  |   23 +++++++++++++++++++++++
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index d3f4fbb..560c072 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1274,10 +1274,8 @@ xfs_qm_dqflush(
 	dqp->dq_flags &= ~(XFS_DQ_DIRTY);
 	mp = dqp->q_mount;
 
-	/* lsn is 64 bits */
-	spin_lock(&mp->m_ail_lock);
-	dqp->q_logitem.qli_flush_lsn = dqp->q_logitem.qli_item.li_lsn;
-	spin_unlock(&mp->m_ail_lock);
+	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
+					&dqp->q_logitem.qli_item.li_lsn);
 
 	/*
 	 * Attach an iodone routine so that we can remove this dquot from the
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 456941e..58a80ae 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2213,9 +2213,9 @@ xfs_ifree_cluster(
 				iip = (xfs_inode_log_item_t *)lip;
 				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*)) xfs_istale_done;
-				spin_lock(&mp->m_ail_lock);
-				iip->ili_flush_lsn = iip->ili_item.li_lsn;
-				spin_unlock(&mp->m_ail_lock);
+				xfs_trans_ail_copy_lsn(mp->m_ail,
+							&iip->ili_flush_lsn,
+							&iip->ili_item.li_lsn);
 				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
 				pre_flushed++;
 			}
@@ -2236,9 +2236,8 @@ xfs_ifree_cluster(
 			iip->ili_last_fields = iip->ili_format.ilf_fields;
 			iip->ili_format.ilf_fields = 0;
 			iip->ili_logged = 1;
-			spin_lock(&mp->m_ail_lock);
-			iip->ili_flush_lsn = iip->ili_item.li_lsn;
-			spin_unlock(&mp->m_ail_lock);
+			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
+						&iip->ili_item.li_lsn);
 
 			xfs_buf_attach_iodone(bp,
 				(void(*)(xfs_buf_t*,xfs_log_item_t*))
@@ -3479,10 +3478,8 @@ xfs_iflush_int(
 		iip->ili_format.ilf_fields = 0;
 		iip->ili_logged = 1;
 
-		ASSERT(sizeof(xfs_lsn_t) == 8);	/* don't lock if it shrinks */
-		spin_lock(&mp->m_ail_lock);
-		iip->ili_flush_lsn = iip->ili_item.li_lsn;
-		spin_unlock(&mp->m_ail_lock);
+		xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
+					&iip->ili_item.li_lsn);
 
 		/*
 		 * Attach the function xfs_iflush_done to the inode's
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index aa58535..708cff7 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -106,4 +106,27 @@ void	xfsaild_wakeup(struct xfs_ail *, xfs_lsn_t);
 int	xfsaild_start(struct xfs_ail *);
 void	xfsaild_stop(struct xfs_ail *);
 
+#if BITS_PER_LONG != 64
+static inline void
+xfs_trans_ail_copy_lsn(
+	struct xfs_ail	*ailp,
+	xfs_lsn_t	*dst,
+	xfs_lsn_t	*src)
+{
+	ASSERT(sizeof(xfs_lsn_t) == 8);	/* don't lock if it shrinks */
+	spin_lock(&ailp->xa_mount->m_ail_lock);
+	*dst = *src;
+	spin_unlock(&ailp->xa_mount->m_ail_lock);
+}
+#else
+static inline void
+xfs_trans_ail_copy_lsn(
+	struct xfs_ail	*ailp,
+	xfs_lsn_t	*dst,
+	xfs_lsn_t	*src)
+{
+	ASSERT(sizeof(xfs_lsn_t) == 8);
+	*dst = *src;
+}
+#endif
 #endif	/* __XFS_TRANS_PRIV_H__ */
-- 
1.5.6.5

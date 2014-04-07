Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C0F77F9B
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 749538F8052
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ALM34BrdNEIN5cP9 for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:09 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 18/19] xfs: remove unused ail pointer arg from
	xfs_trans_ail_cursor_done()
Date: Mon,  7 Apr 2014 14:59:05 -0500
Message-Id: <1396900746-22201-19-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_trans.c       |    2 +-
 fs/xfs/xfs_trans_ail.c   |    5 ++---
 fs/xfs/xfs_trans_priv.h  |    3 +--
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bce53ac..7801052 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3145,7 +3145,7 @@ xlog_recover_efd_pass2(
 		}
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
-	xfs_trans_ail_cursor_done(ailp, &cur);
+	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->xa_lock);
 
 	return 0;
@@ -3757,7 +3757,7 @@ xlog_recover_process_efis(
 		lip = xfs_trans_ail_cursor_next(ailp, &cur);
 	}
 out:
-	xfs_trans_ail_cursor_done(ailp, &cur);
+	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->xa_lock);
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c812c5c..737eb04 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -827,7 +827,7 @@ xfs_trans_committed_bulk(
 		xfs_log_item_batch_insert(ailp, &cur, log_items, i, commit_lsn);
 
 	spin_lock(&ailp->xa_lock);
-	xfs_trans_ail_cursor_done(ailp, &cur);
+	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->xa_lock);
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a728735..cb0f3a8 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -173,7 +173,6 @@ xfs_trans_ail_cursor_next(
  */
 void
 xfs_trans_ail_cursor_done(
-	struct xfs_ail		*ailp,
 	struct xfs_ail_cursor	*cur)
 {
 	cur->item = NULL;
@@ -368,7 +367,7 @@ xfsaild_push(
 		 * If the AIL is empty or our push has reached the end we are
 		 * done now.
 		 */
-		xfs_trans_ail_cursor_done(ailp, &cur);
+		xfs_trans_ail_cursor_done(&cur);
 		spin_unlock(&ailp->xa_lock);
 		goto out_done;
 	}
@@ -453,7 +452,7 @@ xfsaild_push(
 			break;
 		lsn = lip->li_lsn;
 	}
-	xfs_trans_ail_cursor_done(ailp, &cur);
+	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->xa_lock);
 
 	if (xfs_buf_delwri_submit_nowait(&ailp->xa_buf_list))
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 12e86af..bd12818 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -133,8 +133,7 @@ struct xfs_log_item *	xfs_trans_ail_cursor_last(struct xfs_ail *ailp,
 					xfs_lsn_t lsn);
 struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur);
-void			xfs_trans_ail_cursor_done(struct xfs_ail *ailp,
-					struct xfs_ail_cursor *cur);
+void			xfs_trans_ail_cursor_done(struct xfs_ail_cursor *cur);
 
 #if BITS_PER_LONG != 64
 static inline void
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

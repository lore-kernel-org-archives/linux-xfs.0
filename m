Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 021247F50
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 20:21:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76DD0AC001
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 18:21:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sWAtmPRbRHSwvBex for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 18:21:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XM5SC-0000KA-5t
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XM5SC-0002UC-4o
	for xfs@oss.sgi.com; Tue, 26 Aug 2014 11:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: refactor xlog_recover_process_data()
Date: Tue, 26 Aug 2014 11:21:38 +1000
Message-Id: <1409016101-9511-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1409016101-9511-1-git-send-email-david@fromorbit.com>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Clean up xlog_recover_process_data() structure in preparation for
fixing the allocationa nd freeing context of the transaction being
recovered.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 151 ++++++++++++++++++++++++++---------------------
 1 file changed, 84 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 01becbb..1970732f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3531,12 +3531,78 @@ out:
 }
 
 STATIC int
-xlog_recover_unmount_trans(
-	struct xlog		*log)
+xlog_recovery_process_ophdr(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead,
+	xfs_caddr_t		dp,
+	xfs_caddr_t		lp,
+	int			pass)
 {
-	/* Do nothing now */
-	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-	return 0;
+	struct xlog_recover	*trans;
+	xlog_tid_t		tid;
+	int			error;
+	unsigned long		hash;
+	uint			flags;
+	unsigned int		hlen;
+
+	hlen = be32_to_cpu(ohead->oh_len);
+	tid = be32_to_cpu(ohead->oh_tid);
+	hash = XLOG_RHASH(tid);
+	trans = xlog_recover_find_tid(&rhash[hash], tid);
+	if (!trans) {
+		/* add new tid if this is a new transaction */
+		if (ohead->oh_flags & XLOG_START_TRANS) {
+			xlog_recover_new_tid(&rhash[hash], tid,
+					     be64_to_cpu(rhead->h_lsn));
+		}
+		return 0;
+	}
+
+	error = -EIO;
+	if (dp + hlen > lp) {
+		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, hlen);
+		WARN_ON(1);
+		goto out_free;
+	}
+
+	flags = ohead->oh_flags & ~XLOG_END_TRANS;
+	if (flags & XLOG_WAS_CONT_TRANS)
+		flags &= ~XLOG_CONTINUE_TRANS;
+
+	switch (flags) {
+	/* expected flag values */
+	case 0:
+	case XLOG_CONTINUE_TRANS:
+		error = xlog_recover_add_to_trans(log, trans, dp, hlen);
+		break;
+	case XLOG_WAS_CONT_TRANS:
+		error = xlog_recover_add_to_cont_trans(log, trans, dp, hlen);
+		break;
+	case XLOG_COMMIT_TRANS:
+		error = xlog_recover_commit_trans(log, trans, pass);
+		break;
+
+	/* unexpected flag values */
+	case XLOG_UNMOUNT_TRANS:
+		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
+		error = 0;
+		break;
+	case XLOG_START_TRANS:
+		xfs_warn(log->l_mp, "%s: bad transaction 0x%x", __func__, tid);
+		ASSERT(0);
+		break;
+	default:
+		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
+		ASSERT(0);
+		break;
+	}
+
+out_free:
+	if (error)
+		xlog_recover_free_trans(trans);
+	return error;
 }
 
 /*
@@ -3556,14 +3622,10 @@ xlog_recover_process_data(
 	xfs_caddr_t		dp,
 	int			pass)
 {
+	struct xlog_op_header	*ohead;
 	xfs_caddr_t		lp;
 	int			num_logops;
-	xlog_op_header_t	*ohead;
-	xlog_recover_t		*trans;
-	xlog_tid_t		tid;
 	int			error;
-	unsigned long		hash;
-	uint			flags;
 
 	lp = dp + be32_to_cpu(rhead->h_len);
 	num_logops = be32_to_cpu(rhead->h_num_logops);
@@ -3573,69 +3635,24 @@ xlog_recover_process_data(
 		return -EIO;
 
 	while ((dp < lp) && num_logops) {
-		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
-		ohead = (xlog_op_header_t *)dp;
-		dp += sizeof(xlog_op_header_t);
+		ASSERT(dp + sizeof(struct xlog_op_header) <= lp);
+
+		ohead = (struct xlog_op_header *)dp;
+		dp += sizeof(*ohead);
+
 		if (ohead->oh_clientid != XFS_TRANSACTION &&
 		    ohead->oh_clientid != XFS_LOG) {
 			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
-					__func__, ohead->oh_clientid);
+				__func__, ohead->oh_clientid);
 			ASSERT(0);
 			return -EIO;
 		}
-		tid = be32_to_cpu(ohead->oh_tid);
-		hash = XLOG_RHASH(tid);
-		trans = xlog_recover_find_tid(&rhash[hash], tid);
-		if (trans == NULL) {		   /* not found; add new tid */
-			if (ohead->oh_flags & XLOG_START_TRANS)
-				xlog_recover_new_tid(&rhash[hash], tid,
-					be64_to_cpu(rhead->h_lsn));
-		} else {
-			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
-				xfs_warn(log->l_mp, "%s: bad length 0x%x",
-					__func__, be32_to_cpu(ohead->oh_len));
-				WARN_ON(1);
-				return -EIO;
-			}
-			flags = ohead->oh_flags & ~XLOG_END_TRANS;
-			if (flags & XLOG_WAS_CONT_TRANS)
-				flags &= ~XLOG_CONTINUE_TRANS;
-			switch (flags) {
-			case XLOG_COMMIT_TRANS:
-				error = xlog_recover_commit_trans(log,
-								trans, pass);
-				break;
-			case XLOG_UNMOUNT_TRANS:
-				error = xlog_recover_unmount_trans(log);
-				break;
-			case XLOG_WAS_CONT_TRANS:
-				error = xlog_recover_add_to_cont_trans(log,
-						trans, dp,
-						be32_to_cpu(ohead->oh_len));
-				break;
-			case XLOG_START_TRANS:
-				xfs_warn(log->l_mp, "%s: bad transaction",
-					__func__);
-				ASSERT(0);
-				error = -EIO;
-				break;
-			case 0:
-			case XLOG_CONTINUE_TRANS:
-				error = xlog_recover_add_to_trans(log, trans,
-						dp, be32_to_cpu(ohead->oh_len));
-				break;
-			default:
-				xfs_warn(log->l_mp, "%s: bad flag 0x%x",
-					__func__, flags);
-				ASSERT(0);
-				error = -EIO;
-				break;
-			}
-			if (error) {
-				xlog_recover_free_trans(trans);
-				return error;
-			}
-		}
+
+		error = xlog_recovery_process_ophdr(log, rhash, rhead, ohead,
+						    dp, lp, pass);
+		if (error)
+			return error;
+
 		dp += be32_to_cpu(ohead->oh_len);
 		num_logops--;
 	}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

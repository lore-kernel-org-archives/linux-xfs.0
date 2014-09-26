Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1290D7FF3
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 21:19:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 843D3AC001
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 19:19:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fdzNjgzl8Rgrh6wo for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 19:19:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XXL7q-0000Rj-Pr
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XXL7q-0006Ry-PF
	for xfs@oss.sgi.com; Fri, 26 Sep 2014 12:19:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: refactor xlog_recover_process_data()
Date: Fri, 26 Sep 2014 12:19:08 +1000
Message-Id: <1411697952-24741-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1411697952-24741-1-git-send-email-david@fromorbit.com>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
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
fixing the allocation and freeing context of the transaction being
recovered.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 200 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 127 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c6427b3..b5e081b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3533,12 +3533,122 @@ out:
 }
 
 STATIC int
-xlog_recover_unmount_trans(
-	struct xlog		*log)
+xlog_recovery_process_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	xfs_caddr_t		dp,
+	unsigned int		len,
+	unsigned int		flags,
+	int			pass)
 {
-	/* Do nothing now */
-	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-	return 0;
+	int			error = -EIO;
+
+	/* mask off ophdr transaction container flags */
+	flags &= ~XLOG_END_TRANS;
+	if (flags & XLOG_WAS_CONT_TRANS)
+		flags &= ~XLOG_CONTINUE_TRANS;
+
+	switch (flags) {
+	/* expected flag values */
+	case 0:
+	case XLOG_CONTINUE_TRANS:
+		error = xlog_recover_add_to_trans(log, trans, dp, len);
+		break;
+	case XLOG_WAS_CONT_TRANS:
+		error = xlog_recover_add_to_cont_trans(log, trans, dp, len);
+		break;
+	case XLOG_COMMIT_TRANS:
+		error = xlog_recover_commit_trans(log, trans, pass);
+		break;
+
+	/* unexpected flag values */
+	case XLOG_UNMOUNT_TRANS:
+		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
+		error = 0; /* just skip trans */
+		break;
+	case XLOG_START_TRANS:
+		xfs_warn(log->l_mp, "%s: bad transaction", __func__);
+		ASSERT(0);
+		break;
+	default:
+		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
+		ASSERT(0);
+		break;
+	}
+	return error;
+}
+
+STATIC struct xlog_recover *
+xlog_recover_ophdr_to_trans(
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead)
+{
+	struct xlog_recover	*trans;
+	xlog_tid_t		tid;
+	struct hlist_head	*rhp;
+
+	tid = be32_to_cpu(ohead->oh_tid);
+	rhp = &rhash[XLOG_RHASH(tid)];
+	trans = xlog_recover_find_tid(rhp, tid);
+	if (trans)
+		return trans;
+
+	/*
+	 * If this is a new transaction, the ophdr only contains the
+	 * start record. In that case, the only processing we need to do
+	 * on this opheader is allocate a new recovery container to hold
+	 * the recovery ops that will follow.
+	 */
+	if (ohead->oh_flags & XLOG_START_TRANS)
+		xlog_recover_new_tid(rhp, tid, be64_to_cpu(rhead->h_lsn));
+	return NULL;
+}
+
+STATIC int
+xlog_recover_process_ophdr(
+	struct xlog		*log,
+	struct hlist_head	rhash[],
+	struct xlog_rec_header	*rhead,
+	struct xlog_op_header	*ohead,
+	xfs_caddr_t		dp,
+	xfs_caddr_t		lp,
+	int			pass)
+{
+	struct xlog_recover	*trans;
+	int			error;
+	unsigned int		len;
+
+	/* Do we understand who wrote this op? */
+	if (ohead->oh_clientid != XFS_TRANSACTION &&
+	    ohead->oh_clientid != XFS_LOG) {
+		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
+			__func__, ohead->oh_clientid);
+		ASSERT(0);
+		return -EIO;
+	}
+
+	/*
+	 * Check the ophdr contains all the data it is supposed to contain.
+	 */
+	len = be32_to_cpu(ohead->oh_len);
+	if (dp + len > lp) {
+		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
+		WARN_ON(1);
+		return -EIO;
+	}
+
+	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
+	if (!trans) {
+		/* nothing to do, so skip over this ophdr */
+		return 0;
+	}
+
+	error = xlog_recovery_process_trans(log, trans, dp, len,
+					    ohead->oh_flags, pass);
+	if (error)
+		xlog_recover_free_trans(trans);
+	return error;
 }
 
 /*
@@ -3558,14 +3668,10 @@ xlog_recover_process_data(
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
@@ -3575,69 +3681,17 @@ xlog_recover_process_data(
 		return -EIO;
 
 	while ((dp < lp) && num_logops) {
-		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
-		ohead = (xlog_op_header_t *)dp;
-		dp += sizeof(xlog_op_header_t);
-		if (ohead->oh_clientid != XFS_TRANSACTION &&
-		    ohead->oh_clientid != XFS_LOG) {
-			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
-					__func__, ohead->oh_clientid);
-			ASSERT(0);
-			return -EIO;
-		}
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
+		ohead = (struct xlog_op_header *)dp;
+		dp += sizeof(*ohead);
+		ASSERT(dp <= lp);
+
+		/* errors will abort recovery */
+		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
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

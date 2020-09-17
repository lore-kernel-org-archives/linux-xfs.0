Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C93EC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B6932080C
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 03:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DzzRL2IW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgIQDaR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 23:30:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgIQDaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:30:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3O30F162321;
        Thu, 17 Sep 2020 03:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CitMLXLgQdnip6qBfXd4k2YYLPJ8J8cU+kFbBvvxkMU=;
 b=DzzRL2IWhAd2KKFRYCLsgn7YSLDp876IQBxYWsoMwRn0/ja/1g8YfWahBrUPleHWDavo
 dr+EBTLt/ZIfa6bQ5Xz0i8RD6QI8jAXOTaZAISOmQr7j5EsS0WUn07od7s7mF1bo9fGq
 JeQ0jwWmf1Sd1v373oafLgGIlIPS6pLIQRo8X1SZw6pYbCfrIm8iSVAdAm7YjB2Z14hd
 DUA9DmCzAgANJhsfelSYNqgx+5J1SwS1l7BHDvw3HiXreimCzalZtz4AcdumJ4jNL8F8
 Ld0M/5cKlAK/Ds1noegr6yFxSin8kHBMFafUuZLk959BpukgYRfZq7wqWyW3FmWHomCQ 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33gnrr6jad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:30:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3OuNp041665;
        Thu, 17 Sep 2020 03:30:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33h892y6hq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:30:12 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3UBKh030416;
        Thu, 17 Sep 2020 03:30:11 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:30:10 +0000
Subject: [PATCH 3/3] xfs: use the log grant push threshold to decide if we're
 going to relog deferred items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 16 Sep 2020 20:30:09 -0700
Message-ID: <160031340936.3624707.125940597283537162.stgit@magnolia>
In-Reply-To: <160031338724.3624707.1335084348340671147.stgit@magnolia>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=3 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=3
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've landed a means for the defer ops manager to ask log items
to relog themselves to move the log tail forward, we can improve how we
decide when to relog so that we're not just using an arbitrary hardcoded
value.

The XFS log has "push threshold", which tells us how far we'd have to
move the log tail forward to keep 25% of the ondisk log space available.
We use this threshold to decide when to force defer ops chains to relog
themselves.  This avoids unnecessary relogging (which adds extra steps
to metadata updates) while helping us to avoid pinning the tail.

A better algorithm would be to relog only when we detect that the time
required to move the tail forward is greater than the time remaining
before all the log space gets used up, but letting the upper levels
drive the relogging means that it is difficult to coordinate relogging
the lowest LSN'd intents first.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   32 +++++++++++++++++++++++++-------
 fs/xfs/xfs_log.c          |   41 +++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log.h          |    2 ++
 3 files changed, 58 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 7938e4d3af90..97ec36f32a0a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
 
 /*
  * Deferred Operations in XFS
@@ -372,15 +373,35 @@ xfs_defer_relog(
 	struct list_head		*dfops)
 {
 	struct xfs_defer_pending	*dfp;
+	xfs_lsn_t			threshold_lsn;
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	/*
+	 * Figure out where we need the tail to be in order to maintain the
+	 * minimum required free space in the log.
+	 */
+	threshold_lsn = xlog_grant_push_threshold((*tpp)->t_mountp->m_log, 0);
+	if (threshold_lsn == NULLCOMMITLSN)
+		return 0;
+
 	list_for_each_entry(dfp, dfops, dfp_list) {
+		/*
+		 * If the log intent item for this deferred op is behind the
+		 * threshold, we're running out of space and need to relog it
+		 * to release the tail.
+		 */
+		if (dfp->dfp_intent == NULL ||
+		    XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) < 0)
+			continue;
+
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
 	}
 
-	return xfs_defer_trans_roll(tpp);
+	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
+		return xfs_defer_trans_roll(tpp);
+	return 0;
 }
 
 /*
@@ -444,7 +465,6 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp;
-	unsigned int			nr_rolls = 0;
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 
@@ -471,11 +491,9 @@ xfs_defer_finish_noroll(
 			goto out_shutdown;
 
 		/* Every few rolls we relog all the intent items. */
-		if (!(++nr_rolls % 7)) {
-			error = xfs_defer_relog(tp, &dop_pending);
-			if (error)
-				goto out_shutdown;
-		}
+		error = xfs_defer_relog(tp, &dop_pending);
+		if (error)
+			goto out_shutdown;
 
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ad0c69ee8947..62c9e0aaa7df 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1475,14 +1475,15 @@ xlog_commit_record(
 }
 
 /*
- * Push on the buffer cache code if we ever use more than 75% of the on-disk
- * log space.  This code pushes on the lsn which would supposedly free up
- * the 25% which we want to leave free.  We may need to adopt a policy which
- * pushes on an lsn which is further along in the log once we reach the high
- * water mark.  In this manner, we would be creating a low water mark.
+ * Compute the LSN push target needed to push on the buffer cache code if we
+ * ever use more than 75% of the on-disk log space.  This code pushes on the
+ * lsn which would supposedly free up the 25% which we want to leave free.  We
+ * may need to adopt a policy which pushes on an lsn which is further along in
+ * the log once we reach the high water mark.  In this manner, we would be
+ * creating a low water mark.
  */
-STATIC void
-xlog_grant_push_ail(
+xfs_lsn_t
+xlog_grant_push_threshold(
 	struct xlog	*log,
 	int		need_bytes)
 {
@@ -1508,7 +1509,7 @@ xlog_grant_push_ail(
 	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
 	free_threshold = max(free_threshold, 256);
 	if (free_blocks >= free_threshold)
-		return;
+		return NULLCOMMITLSN;
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
 						&threshold_block);
@@ -1528,13 +1529,33 @@ xlog_grant_push_ail(
 	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
 		threshold_lsn = last_sync_lsn;
 
+	return threshold_lsn;
+}
+
+/*
+ * Push on the buffer cache code if we ever use more than 75% of the on-disk
+ * log space.  This code pushes on the lsn which would supposedly free up
+ * the 25% which we want to leave free.  We may need to adopt a policy which
+ * pushes on an lsn which is further along in the log once we reach the high
+ * water mark.  In this manner, we would be creating a low water mark.
+ */
+STATIC void
+xlog_grant_push_ail(
+	struct xlog	*log,
+	int		need_bytes)
+{
+	xfs_lsn_t	threshold_lsn;
+
+	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
+	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+		return;
+
 	/*
 	 * Get the transaction layer to kick the dirty buffers out to
 	 * disk asynchronously. No point in trying to do this if
 	 * the filesystem is shutting down.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log))
-		xfs_ail_push(log->l_ailp, threshold_lsn);
+	xfs_ail_push(log->l_ailp, threshold_lsn);
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 1412d6993f1e..58c3fcbec94a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -141,4 +141,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 bool	xfs_log_in_recovery(struct xfs_mount *);
 
+xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
+
 #endif	/* __XFS_LOG_H__ */


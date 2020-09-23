Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1834EC4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 05:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C951421D43
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 05:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gUhXO7b0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgIWFdT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 01:33:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgIWFdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 01:33:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N5Uhhr077058;
        Wed, 23 Sep 2020 05:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ubesKTcE0O+kvfI046tzzalIfLWY5JZazJPAqAOOaL4=;
 b=gUhXO7b0SLU9uHJIBTTM95Idra8P/TLmGFp2gFpH/GIUfrp7MBNPnrbLmJ8J3CsEd3/5
 ny9aV7zMHBDrG/65BqGecSIwWLckYyus3jc0NqL7AJlDwkQGfmORLxnCOYVnTRPHakLm
 CVj5LItieo/i8ymqX0ggbK+vvF3UYhtsfFbUYkUgrSMiFhHpOQ1Ex+NBb4A91l0N3xYG
 HF+vMzEhVLHw5k78JUjWSPNwU+M1j/8Rukd5MoeyKDU9HwRRwJ7fcvLv7uLLFXGtWNF4
 6PPayw6lrXHurvbNAeQpWYAp2o+4G4XSVziWGWLnQ8arjHU3UJ58USKBLmzLNocftwnC ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33q5rgenty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 05:33:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08N5URwG163817;
        Wed, 23 Sep 2020 05:33:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33nujp56hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 05:33:16 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08N5XEHZ020906;
        Wed, 23 Sep 2020 05:33:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 22:33:14 -0700
Subject: [PATCH 2/3] xfs: expose the log push threshold
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Tue, 22 Sep 2020 22:33:13 -0700
Message-ID: <160083919333.1401135.1467785318303966214.stgit@magnolia>
In-Reply-To: <160083917978.1401135.9502772939838940679.stgit@magnolia>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=3
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=3 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230043
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Separate the computation of the log push threshold and the push logic in
xlog_grant_push_ail.  This enables higher level code to determine (for
example) that it is holding on to a logged intent item and the log is so
busy that it is more than 75% full.  In that case, it would be desirable
to move the log item towards the head to release the tail, which we will
cover in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |   41 +++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log.h |    2 ++
 2 files changed, 33 insertions(+), 10 deletions(-)


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


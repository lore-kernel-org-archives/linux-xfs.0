Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD07C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F4C920B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CNzBAOoh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgJESXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:23:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:23:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095I9bHu101678;
        Mon, 5 Oct 2020 18:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lsGamF5ke4Awjtcr8ODqDIu7Xtg+ug9k+620wENOo6M=;
 b=CNzBAOohiajJ10Xr5hcSZitaW6QItX5Gb57kslFU+U//ZHXxnjKQ02A5RlXEbZjvu1h4
 zDFpV8zkgSgHxTrpmYuxy2rbHLEqaUn5WhcTe8WEmMaftoTuwdu26law2Z7mu1Bd5Z0G
 /oK6QCogPiVrT+T8gF39j0WzrVqUgX2cuMAKsVViJAbKVQJtjpQRWWuDRzxfN/6teCB0
 VN3It3+iVBZ4e/CqKhJBK3VNS/sfYwzZZqUXOtE7cxWlKgpPUjRpBpenl1eejlHF4FG8
 yvq3sqWyUqze/q3mnCe00vXMOVkDTYwkS1mxNPa91TxjNFL2Nepp4FR7n3xlS7kdZSVg 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmpyvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:21:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA5RO019019;
        Mon, 5 Oct 2020 18:21:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y37vn4pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:21:16 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095ILFDW017047;
        Mon, 5 Oct 2020 18:21:15 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:21:14 -0700
Subject: [PATCH 3/4] xfs: expose the log push threshold
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com, hch@lst.de
Date:   Mon, 05 Oct 2020 11:21:13 -0700
Message-ID: <160192207381.2569788.16789278552120954445.stgit@magnolia>
In-Reply-To: <160192205402.2569788.11403566753219528155.stgit@magnolia>
References: <160192205402.2569788.11403566753219528155.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=3 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c |   40 ++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log.h |    2 ++
 2 files changed, 32 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7a4ba408a3a2..fa2d05e65ff1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1475,14 +1475,14 @@ xlog_commit_record(
 }
 
 /*
- * Push on the buffer cache code if we ever use more than 75% of the on-disk
- * log space.  This code pushes on the lsn which would supposedly free up
- * the 25% which we want to leave free.  We may need to adopt a policy which
- * pushes on an lsn which is further along in the log once we reach the high
- * water mark.  In this manner, we would be creating a low water mark.
+ * Compute the LSN that we'd need to push the log tail towards in order to have
+ * (a) enough on-disk log space to log the number of bytes specified, (b) at
+ * least 25% of the log space free, and (c) at least 256 blocks free.  If the
+ * log free space already meets all three thresholds, this function returns
+ * NULLCOMMITLSN.
  */
-STATIC void
-xlog_grant_push_ail(
+xfs_lsn_t
+xlog_grant_push_threshold(
 	struct xlog	*log,
 	int		need_bytes)
 {
@@ -1508,7 +1508,7 @@ xlog_grant_push_ail(
 	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
 	free_threshold = max(free_threshold, 256);
 	if (free_blocks >= free_threshold)
-		return;
+		return NULLCOMMITLSN;
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
 						&threshold_block);
@@ -1528,13 +1528,33 @@ xlog_grant_push_ail(
 	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
 		threshold_lsn = last_sync_lsn;
 
+	return threshold_lsn;
+}
+
+/*
+ * Push the tail of the log if we need to do so to maintain the free log space
+ * thresholds set out by xlog_grant_push_threshold.  We may need to adopt a
+ * policy which pushes on an lsn which is further along in the log once we
+ * reach the high water mark.  In this manner, we would be creating a low water
+ * mark.
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


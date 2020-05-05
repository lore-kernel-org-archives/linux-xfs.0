Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6201C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE91520705
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E1Gjvd5z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEEBMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgEEBMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045148fK056139
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RbjXFq138LVQjJG5IB4h+9evK9JxCb6YM0ga25fgixo=;
 b=E1Gjvd5zuw5JEXOQKKmjqkkDJlAMmOeaLu9E+vGYNzXJ37H+5VLTuM+MSw/OF60q/fEM
 n2nrb1oe8hT5rmX+bm/Zt2Pf6zqhvHegoppOJKof68GLfeALwxEvSqF2+yOLhwlBzwgv
 7Qhaz4UJNmC0C85Cq0e3T+/uWXk7NyCWJipmoOjTWpzEAy9ZKHLaPcU2Lpzylo63PaGG
 AQs6gLjUVUCCRyFerObqnSRb7y/UEAVKaaKBgyoucjFZe99gUVHohGlAIiJlegWzuuBD
 HFV9wom/4MIUjD4wb23dPsTMr6VYHxrKoj4uHNVh0RH58whwe/Lb1KC1Z39HBzvqokWx nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn1vmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516rFh004694
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30sjdrtxwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451CgTd015150
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:42 -0700
Subject: [PATCH 20/28] xfs: report iunlink recovery failure upwards
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:41 -0700
Message-ID: <158864116132.182683.16387605365627894770.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we fail to recover unlinked inodes due to corruption or whatnot, we
should report this upwards and fail the mount instead of continuing on
like nothing's wrong.  Eventually the user will trip over the busted
AGI anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 +-
 fs/xfs/xfs_log.c                |    4 +++-
 fs/xfs/xfs_log_recover.c        |    7 ++++++-
 fs/xfs/xfs_unlink_recover.c     |    4 +++-
 4 files changed, 13 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 33c14dd22b77..d4d6d4f84fda 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -124,6 +124,6 @@ bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 void xlog_recover_iodone(struct xfs_buf *bp);
-void xlog_recover_process_unlinked(struct xlog *log);
+int xlog_recover_process_unlinked(struct xlog *log);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00fda2e8e738..8203b9b0fd08 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -727,6 +727,8 @@ xfs_log_mount_finish(
 		xfs_log_work_queue(mp);
 	mp->m_super->s_flags &= ~SB_ACTIVE;
 	evict_inodes(mp->m_super);
+	if (error)
+		return error;
 
 	/*
 	 * Drain the buffer LRU after log recovery. This is required for v4
@@ -737,7 +739,7 @@ xfs_log_mount_finish(
 	 * Don't push in the error case because the AIL may have pending intents
 	 * that aren't removed until recovery is cancelled.
 	 */
-	if (!error && recovered) {
+	if (recovered) {
 		xfs_log_force(mp, XFS_LOG_SYNC);
 		xfs_ail_push_all_sync(mp->m_ail);
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 362296b34490..0ccc09c004f1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3399,7 +3399,12 @@ xlog_recover_finish(
 		 */
 		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
-		xlog_recover_process_unlinked(log);
+		error = xlog_recover_process_unlinked(log);
+		if (error) {
+			xfs_alert(log->l_mp,
+					"Failed to recover unlinked metadata");
+			return error;
+		}
 
 		xlog_recover_check_summary(log);
 
diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
index 413b34085640..fe7fa3d623f2 100644
--- a/fs/xfs/xfs_unlink_recover.c
+++ b/fs/xfs/xfs_unlink_recover.c
@@ -195,7 +195,7 @@ xlog_recover_process_iunlinked(
 	return 0;
 }
 
-void
+int
 xlog_recover_process_unlinked(
 	struct xlog		*log)
 {
@@ -208,4 +208,6 @@ xlog_recover_process_unlinked(
 		if (error)
 			break;
 	}
+
+	return error;
 }


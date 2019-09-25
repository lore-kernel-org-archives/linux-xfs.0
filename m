Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8826BC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B4E21D81
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="irgLeL3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfIYVdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:33:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfIYVdv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:33:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTRJU006312;
        Wed, 25 Sep 2019 21:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=2TD3g0lhcBTYpe7iUi/2qFcRXq2wMoM/JBYnFPhVDyQ=;
 b=irgLeL3VLFMnJD9sjl/DS/6l9dGWTdUMoAQfa98lfgU1ogsFbdEDthcDFrel59/iVu97
 oDzrJqlo+tiOn13ssfccVh/w5rYyMWRYCmLI85f/nlv0hn48egbJf3jh0xSNcuETxzS1
 YN+3DBhPWt2BI8y/zecplCPHWrQiByAuTqllYEw91m84i1XX9iac8yx2QvZBqSILmIqU
 fpYVg5My0Zc9CJQMTstZjqhRaWeDSN+sH8zbRxowutCrQ5N+ru/RYvuXuRRE5wwf9+6+
 5ylozh8tv4+c+5rpqIBHwg/B/Naf1zoBvH7TlticdWCRstQVwCe+5Jk1qOTJqenyd03K /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:33:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTOaB194399;
        Wed, 25 Sep 2019 21:31:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2v829w4tt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:39 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLVcQ6018407;
        Wed, 25 Sep 2019 21:31:38 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:38 -0700
Subject: [PATCH 5/5] xfs_scrub: check summary counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:31:37 -0700
Message-ID: <156944709719.296129.9144102828813666346.stgit@magnolia>
In-Reply-To: <156944706528.296129.7604742756772046951.stgit@magnolia>
References: <156944706528.296129.7604742756772046951.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach scrub to ask the kernel to check and repair summary counters
during phase 7.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 scrub/phase4.c |   12 ++++++++++++
 scrub/phase7.c |   14 ++++++++++++++
 scrub/repair.c |    3 +++
 scrub/scrub.c  |   12 ++++++++++++
 scrub/scrub.h  |    2 ++
 5 files changed, 43 insertions(+)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 589777f6..25fedc83 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -107,6 +107,18 @@ bool
 xfs_repair_fs(
 	struct scrub_ctx		*ctx)
 {
+	bool				moveon;
+
+	/*
+	 * Check the summary counters early.  Normally we do this during phase
+	 * seven, but some of the cross-referencing requires fairly-accurate
+	 * counters, so counter repairs have to be put on the list now so that
+	 * they get fixed before we stop retrying unfixed metadata repairs.
+	 */
+	moveon = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
+	if (!moveon)
+		return false;
+
 	return xfs_process_action_items(ctx);
 }
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index f82b60d6..308b8bb3 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -9,10 +9,13 @@
 #include <sys/statvfs.h>
 #include "libfrog/paths.h"
 #include "libfrog/ptvar.h"
+#include "list.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "scrub.h"
 #include "fscounters.h"
 #include "spacemap.h"
+#include "repair.h"
 
 /* Phase 7: Check summary counters. */
 
@@ -91,6 +94,7 @@ xfs_scan_summary(
 	struct scrub_ctx	*ctx)
 {
 	struct summary_counts	totalcount = {0};
+	struct xfs_action_list	alist;
 	struct ptvar		*ptvar;
 	unsigned long long	used_data;
 	unsigned long long	used_rt;
@@ -110,6 +114,16 @@ xfs_scan_summary(
 	int			ip;
 	int			error;
 
+	/* Check and fix the fs summary counters. */
+	xfs_action_list_init(&alist);
+	moveon = xfs_scrub_fs_summary(ctx, &alist);
+	if (!moveon)
+		return false;
+	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, &alist,
+			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	if (!moveon)
+		return moveon;
+
 	/* Flush everything out to disk before we start counting. */
 	error = syncfs(ctx->mnt.fd);
 	if (error) {
diff --git a/scrub/repair.c b/scrub/repair.c
index 0e5afb20..04a9dccf 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -84,6 +84,9 @@ xfs_action_item_priority(
 	case XFS_SCRUB_TYPE_GQUOTA:
 	case XFS_SCRUB_TYPE_PQUOTA:
 		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
+	case XFS_SCRUB_TYPE_FSCOUNTERS:
+		/* This should always go after AG headers no matter what. */
+		return PRIO(aitem, INT_MAX);
 	}
 	abort();
 }
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 2557da2a..d7a6b49b 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -388,6 +388,18 @@ xfs_scrub_fs_metadata(
 	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
 }
 
+/* Scrub FS summary metadata. */
+bool
+xfs_scrub_fs_summary(
+	struct scrub_ctx		*ctx,
+	struct xfs_action_list		*alist)
+{
+	int				ret;
+
+	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
+	return ret == 0;
+}
+
 /* How many items do we have to check? */
 unsigned int
 xfs_scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 7e28b522..d407abb0 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -25,6 +25,8 @@ bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct xfs_action_list *alist);
 bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
+bool xfs_scrub_fs_summary(struct scrub_ctx *ctx,
+		struct xfs_action_list *alist);
 
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool xfs_can_scrub_inode(struct scrub_ctx *ctx);


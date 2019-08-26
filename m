Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD393C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9538820850
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fN/kbDgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfHZVVO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:21:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfHZVVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:21:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLF5Jn162141;
        Mon, 26 Aug 2019 21:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eLoz3Gxm2NObFtw75WYLKYdq4UlxeWMANyTq8QFm/4w=;
 b=fN/kbDgBbroGon1FAMfc0C1Y4jO8qlh/yUpAb4Ei+r/aovEybkvFFfrjppfsFCIFQTaw
 aRB/8Vo746fVrEbKHCX/fZeOAzKaosIvhHB/lpv+ilgyzkA92voZqZ2bcIOB41QFARV0
 dwCmp7/Mv6t/mrwK0LjVRdeFZ7nfaso/l0jc9DBlcyFa0qLuwEdbntuRLGeoQh8/YNFS
 adYvzb8H3GPBL4+VuqqSCb9RoWbpQunTBpp3VPZa4pa+/T3cuA6Hy0UcrvCiXDRZUDcA
 XNoyukXkxWKdEZlHlNTnH0cUK+me2zNtx2bsKSHHCcP6R39zn83rYM4lYn2QqQaMD//5 uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2umq5t80wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIcHN169567;
        Mon, 26 Aug 2019 21:21:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7wsvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:21:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLLAo6001801;
        Mon, 26 Aug 2019 21:21:10 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 21:21:10 +0000
Subject: [PATCH 2/2] xfs_scrub: check summary counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:21:09 -0700
Message-ID: <156685446969.2839983.12626550627146659080.stgit@magnolia>
In-Reply-To: <156685445746.2839983.1426723444334605572.stgit@magnolia>
References: <156685445746.2839983.1426723444334605572.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach scrub to ask the kernel to check and repair summary counters
during phase 7.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase4.c |   12 ++++++++++++
 scrub/phase7.c |   14 ++++++++++++++
 scrub/repair.c |    3 +++
 scrub/scrub.c  |   13 +++++++++++++
 scrub/scrub.h  |    2 ++
 5 files changed, 44 insertions(+)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 49f00723..c4da4852 100644
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
index 1c459dfc..b3156fdf 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -7,12 +7,15 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <sys/statvfs.h>
+#include "list.h"
 #include "path.h"
 #include "ptvar.h"
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
index 45450d8c..54639752 100644
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
index 136ed529..a428b524 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -28,6 +28,7 @@ enum scrub_type {
 	ST_PERAG,	/* per-AG metadata */
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
+	ST_SUMMARY,	/* summary counters (phase 7) */
 };
 struct scrub_descr {
 	const char	*name;
@@ -84,6 +85,8 @@ static const struct scrub_descr scrubbers[XFS_SCRUB_TYPE_NR] = {
 		{"group quotas",			ST_FS},
 	[XFS_SCRUB_TYPE_PQUOTA] =
 		{"project quotas",			ST_FS},
+	[XFS_SCRUB_TYPE_FSCOUNTERS] =
+		{"filesystem summary counters",		ST_SUMMARY},
 };
 
 /* Format a scrub description. */
@@ -105,6 +108,7 @@ format_scrub_descr(
 				(uint64_t)meta->sm_ino, _(sc->name));
 		break;
 	case ST_FS:
+	case ST_SUMMARY:
 		snprintf(buf, buflen, _("%s"), _(sc->name));
 		break;
 	case ST_NONE:
@@ -446,6 +450,15 @@ xfs_scrub_fs_metadata(
 	return xfs_scrub_metadata(ctx, ST_FS, 0, alist);
 }
 
+/* Scrub FS summary metadata. */
+bool
+xfs_scrub_fs_summary(
+	struct scrub_ctx		*ctx,
+	struct xfs_action_list		*alist)
+{
+	return xfs_scrub_metadata(ctx, ST_SUMMARY, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 xfs_scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index e6e3f16f..449c43de 100644
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


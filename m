Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6196C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A114C21D82
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i+WQhDgI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfIYVer (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:34:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfIYVer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYVaC010202;
        Wed, 25 Sep 2019 21:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KM+uem9EuTsoFkf0sp66TsWVxxqnitpnpzmHFKd9gtM=;
 b=i+WQhDgIj8cJJ8KDMffhgKmjasMeybijZ+hhp2YiKvrag7iBBwXnwDctaJNR0Hn5UAdA
 c66jYUQyRHYy3US6yL0zqgofH/Vsg0KOOIhBflspMViyRJYY1bxmTbuxBpGYBd+J9Dvp
 os+7F1XUiuYAKu54360yftlVzD7B8vsiu2phePBdFv8/QIWRvnwX6A04n1kJr2uXpm04
 RuZIgJAoPaTX3TdKmcy5yPGPRe8smPsfrXdkfKn4qX5HusPHpc8/PuN2K3gCaCqhuAJz
 DtMIuIWddd9ZFtYpTzG+oH59g7YV31WDpeXsbU2JFCcHK1TwlVOUTYEqWFTWRANlMK83 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btq7hqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRFb078742;
        Wed, 25 Sep 2019 21:34:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v82tkrefc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:42 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLXVtk019607;
        Wed, 25 Sep 2019 21:33:31 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:30 -0700
Subject: [PATCH 01/13] libfrog: fix workqueue error communication problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:33:29 -0700
Message-ID: <156944720949.297677.6259044122864374968.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert all the workqueue functions to return positive error codes so
that we can move away from the libc-style indirect errno handling and
towards passing error codes directly back to callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/workqueue.c |    4 ++--
 scrub/fscounters.c  |    5 ++---
 scrub/inodes.c      |    5 ++---
 scrub/phase2.c      |    8 +++-----
 scrub/phase4.c      |    6 +++---
 scrub/read_verify.c |    3 +--
 scrub/spacemap.c    |   11 ++++-------
 scrub/vfs.c         |    3 +--
 8 files changed, 18 insertions(+), 27 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 73114773..a806da3e 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -106,8 +106,8 @@ workqueue_add(
 	}
 
 	wi = malloc(sizeof(struct workqueue_item));
-	if (wi == NULL)
-		return ENOMEM;
+	if (!wi)
+		return errno;
 
 	wi->function = func;
 	wi->index = index;
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index ad467e0c..669c5ab0 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -115,15 +115,14 @@ xfs_count_all_inodes(
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		moveon = false;
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		str_liberror(ctx, ret, _("creating icount workqueue"));
 		goto out_free;
 	}
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
 		if (ret) {
 			moveon = false;
-			str_info(ctx, ctx->mntpoint,
-_("Could not queue AG %u icount work."), agno);
+			str_liberror(ctx, ret, _("queueing icount work"));
 			break;
 		}
 	}
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 4cf8a120..644a6372 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -243,7 +243,7 @@ xfs_scan_all_inodes(
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
 		return false;
 	}
 
@@ -251,8 +251,7 @@ xfs_scan_all_inodes(
 		ret = workqueue_add(&wq, xfs_scan_ag_inodes, agno, &si);
 		if (ret) {
 			si.moveon = false;
-			str_info(ctx, ctx->mntpoint,
-_("Could not queue AG %u bulkstat work."), agno);
+			str_liberror(ctx, ret, _("queueing bulkstat work"));
 			break;
 		}
 	}
diff --git a/scrub/phase2.c b/scrub/phase2.c
index f064c83d..1d2244a4 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -124,7 +124,7 @@ xfs_scan_metadata(
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		str_liberror(ctx, ret, _("creating scrub workqueue"));
 		return false;
 	}
 
@@ -145,8 +145,7 @@ xfs_scan_metadata(
 		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
 		if (ret) {
 			moveon = false;
-			str_info(ctx, ctx->mntpoint,
-_("Could not queue AG %u scrub work."), agno);
+			str_liberror(ctx, ret, _("queueing per-AG scrub work"));
 			goto out;
 		}
 	}
@@ -157,8 +156,7 @@ _("Could not queue AG %u scrub work."), agno);
 	ret = workqueue_add(&wq, xfs_scan_fs_metadata, 0, &moveon);
 	if (ret) {
 		moveon = false;
-		str_info(ctx, ctx->mntpoint,
-_("Could not queue filesystem scrub work."));
+		str_liberror(ctx, ret, _("queueing per-FS scrub work"));
 		goto out;
 	}
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 25fedc83..903da6d2 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -74,7 +74,7 @@ xfs_process_action_items(
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_error(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		str_liberror(ctx, ret, _("creating repair workqueue"));
 		return false;
 	}
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
@@ -82,8 +82,8 @@ xfs_process_action_items(
 			ret = workqueue_add(&wq, xfs_repair_ag, agno, &moveon);
 			if (ret) {
 				moveon = false;
-				str_error(ctx, ctx->mntpoint,
-_("Could not queue repair work."));
+				str_liberror(ctx, ret,
+						_("queueing repair work"));
 				break;
 			}
 		}
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 2152d167..ff4d3572 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -197,8 +197,7 @@ read_verify_queue(
 
 	ret = workqueue_add(&rvp->wq, read_verify, 0, tmp);
 	if (ret) {
-		str_info(rvp->ctx, rvp->ctx->mntpoint,
-_("Could not queue read-verify work."));
+		str_liberror(rvp->ctx, ret, _("queueing read-verify work"));
 		free(tmp);
 		return false;
 	}
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index a7876478..4258e318 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -200,7 +200,7 @@ xfs_scan_all_spacemaps(
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		str_liberror(ctx, ret, _("creating fsmap workqueue"));
 		return false;
 	}
 	if (ctx->fsinfo.fs_rt) {
@@ -208,8 +208,7 @@ xfs_scan_all_spacemaps(
 				ctx->mnt.fsgeom.agcount + 1, &sbx);
 		if (ret) {
 			sbx.moveon = false;
-			str_info(ctx, ctx->mntpoint,
-_("Could not queue rtdev fsmap work."));
+			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
 			goto out;
 		}
 	}
@@ -218,8 +217,7 @@ _("Could not queue rtdev fsmap work."));
 				ctx->mnt.fsgeom.agcount + 2, &sbx);
 		if (ret) {
 			sbx.moveon = false;
-			str_info(ctx, ctx->mntpoint,
-_("Could not queue logdev fsmap work."));
+			str_liberror(ctx, ret, _("queueing logdev fsmap work"));
 			goto out;
 		}
 	}
@@ -227,8 +225,7 @@ _("Could not queue logdev fsmap work."));
 		ret = workqueue_add(&wq, xfs_scan_ag_blocks, agno, &sbx);
 		if (ret) {
 			sbx.moveon = false;
-			str_info(ctx, ctx->mntpoint,
-_("Could not queue AG %u fsmap work."), agno);
+			str_liberror(ctx, ret, _("queueing per-AG fsmap work"));
 			break;
 		}
 	}
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 1a1482dd..0cff2e3f 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -102,8 +102,7 @@ queue_subdir(
 	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
 	if (error) {
 		dec_nr_dirs(sft);
-		str_info(ctx, ctx->mntpoint,
-_("Could not queue subdirectory scan work."));
+		str_liberror(ctx, error, _("queueing directory scan work"));
 		goto out_path;
 	}
 


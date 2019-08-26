Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE52BC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C4D2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nJxrZps1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfHZV23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47894 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFVKd162597;
        Mon, 26 Aug 2019 21:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UiWLGE6dXoz/Sjpkn1OeVgwiKG6mXXdaROWd0CYJLdE=;
 b=nJxrZps13yJhOt8CkUQpEgjW/WVoHBzvzzGot5/baqn9kwNcTsc7sjF4Wr9454Ze2BhM
 nuOs+wdAHWiqncEIuhp0qZDU93+/9oUR/CyeyglVUX1YIY/aODh5iBVzN1uIVAD/rRdA
 AtwKiCl7voWhEe41/AtqwqWTb6nGFLBK7AFW8LmQVSVr4ooMCBLlOJb9ZMgJc3AshC3g
 /gZM9DsKGR11i41NcHc2j27Xo+zQFgAdFmPD6B+aGYsbkcwm2q/Au/H5gjxaLQaF965a
 iW/NUoKrapevK5QM7s/xw/brumgRhMZCWcevUapPzOA027LbMa+YsH3o4lzfrECdhDxG mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t81yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIICS169934;
        Mon, 26 Aug 2019 21:28:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2umj2785xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLSP7L028201;
        Mon, 26 Aug 2019 21:28:25 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:25 -0700
Subject: [PATCH 01/13] libfrog: fix workqueue error communication problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:24 -0700
Message-ID: <156685490445.2841546.18161974605479380089.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
 scrub/common.h      |    2 ++
 scrub/fscounters.c  |    5 ++---
 scrub/inodes.c      |    5 ++---
 scrub/phase2.c      |    8 +++-----
 scrub/phase4.c      |    6 +++---
 scrub/read_verify.c |    3 +--
 scrub/spacemap.c    |   11 ++++-------
 scrub/vfs.c         |    3 +--
 9 files changed, 20 insertions(+), 27 deletions(-)


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
diff --git a/scrub/common.h b/scrub/common.h
index e85a0333..33555891 100644
--- a/scrub/common.h
+++ b/scrub/common.h
@@ -28,6 +28,8 @@ void __str_out(struct scrub_ctx *ctx, const char *descr, enum error_level level,
 
 #define str_errno(ctx, str) \
 	__str_out(ctx, str, S_ERROR,	errno,	__FILE__, __LINE__, NULL)
+#define str_liberror(ctx, error, str) \
+	__str_out(ctx, str, S_ERROR,	error,	__FILE__, __LINE__, NULL)
 #define str_error(ctx, str, ...) \
 	__str_out(ctx, str, S_ERROR,	0,	__FILE__, __LINE__, __VA_ARGS__)
 #define str_warn(ctx, str, ...) \
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index c90143c0..ee07da9e 100644
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
index ae59d7ef..dcce2df0 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -240,7 +240,7 @@ xfs_scan_all_inodes(
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
+		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
 		return false;
 	}
 
@@ -248,8 +248,7 @@ xfs_scan_all_inodes(
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
index a80da7fd..8c8aad97 100644
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
index c4da4852..10199ca1 100644
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
index 4a9b91f2..c7e34cf5 100644
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
index c3621a3a..03d05eed 100644
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
index 0e971d27..e5ed5d83 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -103,8 +103,7 @@ queue_subdir(
 	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
 	if (error) {
 		dec_nr_dirs(sft);
-		str_info(ctx, ctx->mntpoint,
-_("Could not queue subdirectory scan work."));
+		str_liberror(ctx, error, _("queueing directory scan work"));
 		return false;
 	}
 


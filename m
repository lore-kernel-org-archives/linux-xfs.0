Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBAAC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F27B205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bwwZdart"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfIYVj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfIYVj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOrl013212;
        Wed, 25 Sep 2019 21:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=q+nPv+dV5qGTt76Z2otr0GAk8mibrOuEpdqsK1sY9eY=;
 b=bwwZdartHwdkpQrIpAPMBJKc5d60ZYMHxJzl6A+9YofkOd6500MNfzw+9wUFVj48SMEL
 m9qwqaUAfUsrb6HeeRCmcTi4CD479JtrV6R4mMjeJhdD7fRHSb3VXWjoktowG6ge1fxO
 C5/aX3nY90Pzmu+rl4f1VO68AJuj3PtwWjgC4fXF1Y3CaAblOpM+ZMAzRTa4vUQyrGth
 C8L3yUJzjrX9mTjX4MytSww8L5a0a8u4D0b16WGuX1pd5H1jrzGz5psShbvUki498U2m
 MiZdRH92H4wbYFq0JvvxYn/MG9xcTH00QzI+xlNXS22+Pgkwn/pHbxV5898/t/X0hXi1 gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btq7j68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdL7Z088251;
        Wed, 25 Sep 2019 21:39:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v82tkrnqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:22 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLctM2022470;
        Wed, 25 Sep 2019 21:38:55 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:38:55 -0700
Subject: [PATCH 08/18] xfs_scrub: remove moveon from scrub ioctl wrappers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:38:53 -0700
Message-ID: <156944753385.301514.11191607939839219329.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the scrub ioctl wrapper functions
with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase2.c    |   23 ++++++++-------
 scrub/phase3.c    |   38 +++++++++++++-----------
 scrub/phase4.c    |    8 +++--
 scrub/phase5.c    |    4 +--
 scrub/phase7.c    |    4 +--
 scrub/scrub.c     |   84 ++++++++++++++++++++++++++++++-----------------------
 scrub/scrub.h     |   26 ++++++++--------
 scrub/xfs_scrub.h |    2 +
 8 files changed, 102 insertions(+), 87 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index d92b7e29..016d8ec5 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -32,6 +32,7 @@ xfs_scan_ag_metadata(
 	unsigned long long		broken_secondaries;
 	bool				moveon;
 	char				descr[DESCR_BUFSZ];
+	int				ret;
 
 	xfs_action_list_init(&alist);
 	xfs_action_list_init(&immediate_alist);
@@ -41,8 +42,8 @@ xfs_scan_ag_metadata(
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	moveon = xfs_scrub_ag_headers(ctx, agno, &alist);
-	if (!moveon)
+	ret = xfs_scrub_ag_headers(ctx, agno, &alist);
+	if (ret)
 		goto err;
 
 	/* Repair header damage. */
@@ -51,8 +52,8 @@ xfs_scan_ag_metadata(
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	moveon = xfs_scrub_ag_metadata(ctx, agno, &alist);
-	if (!moveon)
+	ret = xfs_scrub_ag_metadata(ctx, agno, &alist);
+	if (ret)
 		goto err;
 
 	/*
@@ -100,11 +101,11 @@ xfs_scan_fs_metadata(
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = arg;
 	struct xfs_action_list		alist;
-	bool				moveon;
+	int				ret;
 
 	xfs_action_list_init(&alist);
-	moveon = xfs_scrub_fs_metadata(ctx, &alist);
-	if (!moveon)
+	ret = xfs_scrub_fs_metadata(ctx, &alist);
+	if (ret)
 		*pmoveon = false;
 
 	xfs_action_list_defer(ctx, agno, &alist);
@@ -134,9 +135,11 @@ xfs_scan_metadata(
 	 * anything else.
 	 */
 	xfs_action_list_init(&alist);
-	moveon = xfs_scrub_primary_super(ctx, &alist);
-	if (!moveon)
+	ret = xfs_scrub_primary_super(ctx, &alist);
+	if (ret) {
+		moveon = false;
 		goto out;
+	}
 	moveon = xfs_action_list_process_or_defer(ctx, 0, &alist);
 	if (!moveon)
 		goto out;
@@ -178,7 +181,7 @@ xfs_estimate_metadata_work(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = xfs_scrub_estimate_ag_work(ctx);
+	*items = scrub_estimate_ag_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
 	return true;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 13601ed7..02a9a098 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -25,10 +25,10 @@
  * ensure that the inode we're checking matches what the inode scan
  * told us to look at.
  */
-static bool
-xfs_scrub_fd(
+static int
+scrub_fd(
 	struct scrub_ctx	*ctx,
-	bool			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
+	int			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
 				      uint32_t gen, struct xfs_action_list *a),
 	struct xfs_bulkstat	*bs,
 	struct xfs_action_list	*alist)
@@ -85,8 +85,8 @@ xfs_scrub_inode(
 	}
 
 	/* Scrub the inode. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_inode_fields, bstat, &alist);
+	if (error)
 		goto out;
 
 	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
@@ -94,14 +94,14 @@ xfs_scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_data_fork, bstat, &alist);
+	if (error)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_attr_fork, bstat, &alist);
+	if (error)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_cow_fork, bstat, &alist);
+	if (error)
 		goto out;
 
 	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
@@ -110,23 +110,23 @@ xfs_scrub_inode(
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
-		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
+		error = xfs_scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
 				&alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
+		error = scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
 	}
-	if (!moveon)
+	if (error)
 		goto out;
 
 	/* Check all the extended attributes. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_attr, bstat, &alist);
+	if (error)
 		goto out;
 
 	/* Check parent pointers. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_parent, bstat, &alist);
+	if (error)
 		goto out;
 
 	/* Try to repair the file while it's open. */
@@ -135,6 +135,8 @@ xfs_scrub_inode(
 		goto out;
 
 out:
+	if (error)
+		moveon = false;
 	error = ptcounter_add(icount, 1);
 	if (error) {
 		str_liberror(ctx, error,
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 07927036..c60012b7 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -112,9 +112,9 @@ xfs_process_action_items(
 /* Fix everything that needs fixing. */
 bool
 xfs_repair_fs(
-	struct scrub_ctx		*ctx)
+	struct scrub_ctx	*ctx)
 {
-	bool				moveon;
+	int			ret;
 
 	/*
 	 * Check the summary counters early.  Normally we do this during phase
@@ -122,8 +122,8 @@ xfs_repair_fs(
 	 * counters, so counter repairs have to be put on the list now so that
 	 * they get fixed before we stop retrying unfixed metadata repairs.
 	 */
-	moveon = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
-	if (!moveon)
+	ret = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
+	if (ret)
 		return false;
 
 	return xfs_process_action_items(ctx);
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 763685fd..cb79752f 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -390,8 +390,8 @@ _("Filesystem has errors, skipping connectivity checks."));
 		return true;
 	}
 
-	moveon = xfs_scrub_fs_label(ctx);
-	if (!moveon)
+	ret = xfs_scrub_fs_label(ctx);
+	if (ret)
 		return false;
 
 	ret = scrub_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 4314904f..b5f77b36 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -121,8 +121,8 @@ xfs_scan_summary(
 
 	/* Check and fix the fs summary counters. */
 	xfs_action_list_init(&alist);
-	moveon = xfs_scrub_fs_summary(ctx, &alist);
-	if (!moveon)
+	error = xfs_scrub_fs_summary(ctx, &alist);
+	if (error)
 		return false;
 	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, &alist,
 			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 8171082d..80a8cfdc 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -250,7 +250,7 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 }
 
 /* Save a scrub context for later repairs. */
-static bool
+static int
 xfs_scrub_save_repair(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist,
@@ -261,9 +261,10 @@ xfs_scrub_save_repair(
 	/* Schedule this item for later repairs. */
 	aitem = malloc(sizeof(struct action_item));
 	if (!aitem) {
-		str_errno(ctx, _("repair list"));
-		return false;
+		str_errno(ctx, _("adding item to repair list"));
+		return errno;
 	}
+
 	memset(aitem, 0, sizeof(*aitem));
 	aitem->type = meta->sm_type;
 	aitem->flags = meta->sm_flags;
@@ -281,10 +282,15 @@ xfs_scrub_save_repair(
 	}
 
 	xfs_action_list_add(alist, aitem);
-	return true;
+	return 0;
 }
 
-/* Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later. */
+/*
+ * Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later.
+ *
+ * Returns 0 for success.  If errors occur, this function will log them and
+ * return a positive error code.
+ */
 static int
 xfs_scrub_meta_type(
 	struct scrub_ctx		*ctx,
@@ -297,6 +303,7 @@ xfs_scrub_meta_type(
 		.sm_agno		= agno,
 	};
 	enum check_outcome		fix;
+	int				ret;
 
 	background_sleep();
 
@@ -308,8 +315,9 @@ xfs_scrub_meta_type(
 	case CHECK_ABORT:
 		return ECANCELED;
 	case CHECK_REPAIR:
-		if (!xfs_scrub_save_repair(ctx, alist, &meta))
-			return ENOMEM;
+		ret = xfs_scrub_save_repair(ctx, alist, &meta);
+		if (ret)
+			return ret;
 		/* fall through */
 	case CHECK_DONE:
 		return 0;
@@ -345,30 +353,28 @@ xfs_scrub_all_types(
 
 		ret = xfs_scrub_meta_type(ctx, type, agno, alist);
 		if (ret)
-			return false;
+			return ret;
 	}
 
-	return true;
+	return 0;
 }
 
 /*
  * Scrub primary superblock.  This will be useful if we ever need to hook
  * a filesystem-wide pre-scrub activity off of the sb 0 scrubber (which
- * currently does nothing).
+ * currently does nothing).  If errors occur, this function will log them and
+ * return nonzero.
  */
-bool
+int
 xfs_scrub_primary_super(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	int				ret;
-
-	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
-	return ret == 0;
+	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
 }
 
 /* Scrub each AG's header blocks. */
-bool
+int
 xfs_scrub_ag_headers(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
@@ -378,7 +384,7 @@ xfs_scrub_ag_headers(
 }
 
 /* Scrub each AG's metadata btrees. */
-bool
+int
 xfs_scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
@@ -388,7 +394,7 @@ xfs_scrub_ag_metadata(
 }
 
 /* Scrub whole-FS metadata btrees. */
-bool
+int
 xfs_scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
@@ -397,20 +403,17 @@ xfs_scrub_fs_metadata(
 }
 
 /* Scrub FS summary metadata. */
-bool
+int
 xfs_scrub_fs_summary(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	int				ret;
-
-	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
-	return ret == 0;
+	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
 }
 
 /* How many items do we have to check? */
 unsigned int
-xfs_scrub_estimate_ag_work(
+scrub_estimate_ag_work(
 	struct scrub_ctx		*ctx)
 {
 	const struct xfrog_scrub_descr	*sc;
@@ -434,8 +437,11 @@ xfs_scrub_estimate_ag_work(
 	return estimate;
 }
 
-/* Scrub inode metadata. */
-static bool
+/*
+ * Scrub inode metadata.  If errors occur, this function will log them and
+ * return nonzero.
+ */
+static int
 __xfs_scrub_file(
 	struct scrub_ctx		*ctx,
 	uint64_t			ino,
@@ -456,14 +462,14 @@ __xfs_scrub_file(
 	/* Scrub the piece of metadata. */
 	fix = xfs_check_metadata(ctx, &meta, true);
 	if (fix == CHECK_ABORT)
-		return false;
+		return ECANCELED;
 	if (fix == CHECK_DONE)
-		return true;
+		return 0;
 
 	return xfs_scrub_save_repair(ctx, alist, &meta);
 }
 
-bool
+int
 xfs_scrub_inode_fields(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -473,7 +479,7 @@ xfs_scrub_inode_fields(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
 }
 
-bool
+int
 xfs_scrub_data_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -483,7 +489,7 @@ xfs_scrub_data_fork(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
 }
 
-bool
+int
 xfs_scrub_attr_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -493,7 +499,7 @@ xfs_scrub_attr_fork(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
 }
 
-bool
+int
 xfs_scrub_cow_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -503,7 +509,7 @@ xfs_scrub_cow_fork(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
 }
 
-bool
+int
 xfs_scrub_dir(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -513,7 +519,7 @@ xfs_scrub_dir(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
 }
 
-bool
+int
 xfs_scrub_attr(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -523,7 +529,7 @@ xfs_scrub_attr(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
 }
 
-bool
+int
 xfs_scrub_symlink(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -533,7 +539,7 @@ xfs_scrub_symlink(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
 }
 
-bool
+int
 xfs_scrub_parent(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -543,7 +549,11 @@ xfs_scrub_parent(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
 }
 
-/* Test the availability of a kernel scrub command. */
+/*
+ * Test the availability of a kernel scrub command.  If errors occur (or the
+ * scrub ioctl is rejected) the errors will be logged and this function will
+ * return false.
+ */
 static bool
 __xfs_scrub_test(
 	struct scrub_ctx		*ctx,
diff --git a/scrub/scrub.h b/scrub/scrub.h
index d407abb0..bfb3f8e3 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -17,15 +17,15 @@ enum check_outcome {
 struct action_item;
 
 void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
-bool xfs_scrub_primary_super(struct scrub_ctx *ctx,
+int xfs_scrub_primary_super(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
-bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+int xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct xfs_action_list *alist);
-bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+int xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct xfs_action_list *alist);
-bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
+int xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
-bool xfs_scrub_fs_summary(struct scrub_ctx *ctx,
+int xfs_scrub_fs_summary(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
 
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
@@ -37,21 +37,21 @@ bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
 bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
-bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 6558bad7..4353756c 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -99,7 +99,7 @@ bool xfs_repair_fs(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
-unsigned int xfs_scrub_estimate_ag_work(struct scrub_ctx *ctx);
+unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
 bool xfs_estimate_metadata_work(struct scrub_ctx *ctx, uint64_t *items,
 				unsigned int *nr_threads, int *rshift);
 bool xfs_estimate_inodes_work(struct scrub_ctx *ctx, uint64_t *items,


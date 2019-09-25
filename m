Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8B1C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22FE121D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FQaSqjAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfIYVja (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:39:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfIYVja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPv1058283;
        Wed, 25 Sep 2019 21:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cttNM1v4jqdnECinfSI1ToTbLGLIjlU8/80QMvpbIPI=;
 b=FQaSqjAUSmoktQmKcD8ik/lGvJ71bbeXcAHefwMUh86p88WsyGmpP4FprsHsbanYPiJl
 76B43ddRsoeJcwRV8IPP0j/wtd84Or/Nq0syhYV9eVv98Be7gLMLDL4grcfNbe2DT7gZ
 zwdMHs0PtxrAqS1+mSoC5pa2va8s9YfvcfCRg4zgyrrpPwk5k1QmfpnNza2+SGWrRWNK
 59mHvYnOU/q0y6Dl9nK6pJXdr4qaKKouJFmwBRankhvPVHaUBeJ02MJvn6pps1sVyl6C
 uSdjrxhD1Ze/QIlsl9uKAzJvwhz3z3F9TANnALJ3FR1bkBft5bVpeESb3IScB9dVR3uU VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7fbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdF0d021079;
        Wed, 25 Sep 2019 21:39:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v829w5515-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLd1LK017383;
        Wed, 25 Sep 2019 21:39:01 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:39:01 -0700
Subject: [PATCH 09/18] xfs_scrub: remove moveon from repair action list
 helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:39:00 -0700
Message-ID: <156944754005.301514.15712729631846142529.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the repair action list processing
functions with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c    |    9 +++---
 scrub/phase2.c    |   37 ++++++++++++-----------
 scrub/phase3.c    |   22 +++++++-------
 scrub/phase4.c    |   20 ++++++------
 scrub/phase7.c    |   10 +++---
 scrub/repair.c    |   85 ++++++++++++++++++++++++++++-------------------------
 scrub/repair.h    |   32 +++++++++-----------
 scrub/scrub.c     |   36 +++++++++++-----------
 scrub/scrub.h     |   29 ++++++++----------
 scrub/xfs_scrub.h |    2 +
 10 files changed, 142 insertions(+), 140 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 3211a488..8a68a2bf 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -50,7 +50,7 @@ xfs_cleanup_fs(
 {
 	int			error;
 
-	xfs_action_lists_free(&ctx->action_lists);
+	action_lists_free(&ctx->action_lists);
 	if (ctx->fshandle)
 		free_handle(ctx->fshandle, ctx->fshandle_len);
 	if (ctx->rtdev)
@@ -125,9 +125,10 @@ _("Not an XFS filesystem."));
 		return false;
 	}
 
-	if (!xfs_action_lists_alloc(ctx->mnt.fsgeom.agcount,
-				&ctx->action_lists)) {
-		str_error(ctx, ctx->mntpoint, _("Not enough memory."));
+	error = action_lists_alloc(ctx->mnt.fsgeom.agcount,
+			&ctx->action_lists);
+	if (error) {
+		str_liberror(ctx, error, ctx->mntpoint);
 		return false;
 	}
 
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 016d8ec5..7388b8e2 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -26,16 +26,15 @@ xfs_scan_ag_metadata(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = arg;
-	struct xfs_action_list		alist;
-	struct xfs_action_list		immediate_alist;
+	struct action_list		alist;
+	struct action_list		immediate_alist;
 	unsigned long long		broken_primaries;
 	unsigned long long		broken_secondaries;
-	bool				moveon;
 	char				descr[DESCR_BUFSZ];
 	int				ret;
 
-	xfs_action_list_init(&alist);
-	xfs_action_list_init(&immediate_alist);
+	action_list_init(&alist);
+	action_list_init(&immediate_alist);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
 
 	/*
@@ -47,8 +46,8 @@ xfs_scan_ag_metadata(
 		goto err;
 
 	/* Repair header damage. */
-	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
-	if (!moveon)
+	ret = action_list_process_or_defer(ctx, agno, &alist);
+	if (ret)
 		goto err;
 
 	/* Now scrub the AG btrees. */
@@ -65,7 +64,7 @@ xfs_scan_ag_metadata(
 	 */
 	broken_secondaries = 0;
 	broken_primaries = 0;
-	xfs_action_list_find_mustfix(&alist, &immediate_alist,
+	action_list_find_mustfix(&alist, &immediate_alist,
 			&broken_primaries, &broken_secondaries);
 	if (broken_secondaries && !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
 		if (broken_primaries)
@@ -79,12 +78,12 @@ _("Filesystem might not be repairable."));
 	}
 
 	/* Repair (inode) btree damage. */
-	moveon = xfs_action_list_process_or_defer(ctx, agno, &immediate_alist);
-	if (!moveon)
+	ret = action_list_process_or_defer(ctx, agno, &immediate_alist);
+	if (ret)
 		goto err;
 
 	/* Everything else gets fixed during phase 4. */
-	xfs_action_list_defer(ctx, agno, &alist);
+	action_list_defer(ctx, agno, &alist);
 
 	return;
 err:
@@ -100,15 +99,15 @@ xfs_scan_fs_metadata(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = arg;
-	struct xfs_action_list		alist;
+	struct action_list		alist;
 	int				ret;
 
-	xfs_action_list_init(&alist);
+	action_list_init(&alist);
 	ret = xfs_scrub_fs_metadata(ctx, &alist);
 	if (ret)
 		*pmoveon = false;
 
-	xfs_action_list_defer(ctx, agno, &alist);
+	action_list_defer(ctx, agno, &alist);
 }
 
 /* Scan all filesystem metadata. */
@@ -116,7 +115,7 @@ bool
 xfs_scan_metadata(
 	struct scrub_ctx	*ctx)
 {
-	struct xfs_action_list	alist;
+	struct action_list	alist;
 	struct workqueue	wq;
 	xfs_agnumber_t		agno;
 	bool			moveon = true;
@@ -134,15 +133,17 @@ xfs_scan_metadata(
 	 * upgrades (followed by a full scrub), do that before we launch
 	 * anything else.
 	 */
-	xfs_action_list_init(&alist);
+	action_list_init(&alist);
 	ret = xfs_scrub_primary_super(ctx, &alist);
 	if (ret) {
 		moveon = false;
 		goto out;
 	}
-	moveon = xfs_action_list_process_or_defer(ctx, 0, &alist);
-	if (!moveon)
+	ret = action_list_process_or_defer(ctx, 0, &alist);
+	if (ret) {
+		moveon = false;
 		goto out;
+	}
 
 	for (agno = 0; moveon && agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 02a9a098..a5f95004 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -29,9 +29,9 @@ static int
 scrub_fd(
 	struct scrub_ctx	*ctx,
 	int			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
-				      uint32_t gen, struct xfs_action_list *a),
+				      uint32_t gen, struct action_list *a),
 	struct xfs_bulkstat	*bs,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return fn(ctx, bs->bs_ino, bs->bs_gen, alist);
 }
@@ -64,7 +64,7 @@ xfs_scrub_inode(
 	struct xfs_bulkstat	*bstat,
 	void			*arg)
 {
-	struct xfs_action_list	alist;
+	struct action_list	alist;
 	struct scrub_inode_ctx	*ictx = arg;
 	struct ptcounter	*icount = ictx->icount;
 	xfs_agnumber_t		agno;
@@ -72,7 +72,7 @@ xfs_scrub_inode(
 	int			fd = -1;
 	int			error;
 
-	xfs_action_list_init(&alist);
+	action_list_init(&alist);
 	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
 	background_sleep();
 
@@ -89,8 +89,8 @@ xfs_scrub_inode(
 	if (error)
 		goto out;
 
-	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
-	if (!moveon)
+	error = action_list_process_or_defer(ctx, agno, &alist);
+	if (error)
 		goto out;
 
 	/* Scrub all block mappings. */
@@ -104,8 +104,8 @@ xfs_scrub_inode(
 	if (error)
 		goto out;
 
-	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
-	if (!moveon)
+	error = action_list_process_or_defer(ctx, agno, &alist);
+	if (error)
 		goto out;
 
 	if (S_ISLNK(bstat->bs_mode)) {
@@ -130,8 +130,8 @@ xfs_scrub_inode(
 		goto out;
 
 	/* Try to repair the file while it's open. */
-	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
-	if (!moveon)
+	error = action_list_process_or_defer(ctx, agno, &alist);
+	if (error)
 		goto out;
 
 out:
@@ -144,7 +144,7 @@ xfs_scrub_inode(
 		return false;
 	}
 	progress_add(1);
-	xfs_action_list_defer(ctx, agno, &alist);
+	action_list_defer(ctx, agno, &alist);
 	if (fd >= 0) {
 		error = close(fd);
 		if (error)
diff --git a/scrub/phase4.c b/scrub/phase4.c
index c60012b7..ba60a1db 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -29,23 +29,23 @@ xfs_repair_ag(
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = priv;
-	struct xfs_action_list		*alist;
+	struct action_list		*alist;
 	size_t				unfixed;
 	size_t				new_unfixed;
 	unsigned int			flags = 0;
-	bool				moveon;
+	int				ret;
 
 	alist = &ctx->action_lists[agno];
-	unfixed = xfs_action_list_length(alist);
+	unfixed = action_list_length(alist);
 
 	/* Repair anything broken until we fail to make progress. */
 	do {
-		moveon = xfs_action_list_process(ctx, ctx->mnt.fd, alist, flags);
-		if (!moveon) {
+		ret = action_list_process(ctx, ctx->mnt.fd, alist, flags);
+		if (ret) {
 			*pmoveon = false;
 			return;
 		}
-		new_unfixed = xfs_action_list_length(alist);
+		new_unfixed = action_list_length(alist);
 		if (new_unfixed == unfixed)
 			break;
 		unfixed = new_unfixed;
@@ -56,8 +56,8 @@ xfs_repair_ag(
 
 	/* Try once more, but this time complain if we can't fix things. */
 	flags |= ALP_COMPLAIN_IF_UNFIXED;
-	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, alist, flags);
-	if (!moveon)
+	ret = action_list_process(ctx, ctx->mnt.fd, alist, flags);
+	if (ret)
 		*pmoveon = false;
 }
 
@@ -78,7 +78,7 @@ xfs_process_action_items(
 		return false;
 	}
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		if (xfs_action_list_length(&ctx->action_lists[agno]) > 0) {
+		if (action_list_length(&ctx->action_lists[agno]) > 0) {
 			ret = workqueue_add(&wq, xfs_repair_ag, agno, &moveon);
 			if (ret) {
 				moveon = false;
@@ -141,7 +141,7 @@ xfs_estimate_repair_work(
 	size_t			need_fixing = 0;
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
-		need_fixing += xfs_action_list_length(&ctx->action_lists[agno]);
+		need_fixing += action_list_length(&ctx->action_lists[agno]);
 	need_fixing++;
 	*items = need_fixing;
 	*nr_threads = scrub_nproc(ctx) + 1;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index b5f77b36..452d56ad 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -98,7 +98,7 @@ xfs_scan_summary(
 	struct scrub_ctx	*ctx)
 {
 	struct summary_counts	totalcount = {0};
-	struct xfs_action_list	alist;
+	struct action_list	alist;
 	struct ptvar		*ptvar;
 	unsigned long long	used_data;
 	unsigned long long	used_rt;
@@ -120,14 +120,14 @@ xfs_scan_summary(
 	int			error;
 
 	/* Check and fix the fs summary counters. */
-	xfs_action_list_init(&alist);
+	action_list_init(&alist);
 	error = xfs_scrub_fs_summary(ctx, &alist);
 	if (error)
 		return false;
-	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, &alist,
+	error = action_list_process(ctx, ctx->mnt.fd, &alist,
 			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
-	if (!moveon)
-		return moveon;
+	if (error)
+		return false;
 
 	/* Flush everything out to disk before we start counting. */
 	error = syncfs(ctx->mnt.fd);
diff --git a/scrub/repair.c b/scrub/repair.c
index 04a9dccf..1604e252 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -112,9 +112,9 @@ xfs_action_item_compare(
  * to the inode scan.
  */
 void
-xfs_action_list_find_mustfix(
-	struct xfs_action_list		*alist,
-	struct xfs_action_list		*immediate_alist,
+action_list_find_mustfix(
+	struct action_list		*alist,
+	struct action_list		*immediate_alist,
 	unsigned long long		*broken_primaries,
 	unsigned long long		*broken_secondaries)
 {
@@ -146,30 +146,33 @@ xfs_action_list_find_mustfix(
 	}
 }
 
-/* Allocate a certain number of repair lists for the scrub context. */
-bool
-xfs_action_lists_alloc(
+/*
+ * Allocate a certain number of repair lists for the scrub context.  Returns
+ * zero or a positive error number.
+ */
+int
+action_lists_alloc(
 	size_t				nr,
-	struct xfs_action_list		**listsp)
+	struct action_list		**listsp)
 {
-	struct xfs_action_list		*lists;
+	struct action_list		*lists;
 	xfs_agnumber_t			agno;
 
-	lists = calloc(nr, sizeof(struct xfs_action_list));
+	lists = calloc(nr, sizeof(struct action_list));
 	if (!lists)
-		return false;
+		return errno;
 
 	for (agno = 0; agno < nr; agno++)
-		xfs_action_list_init(&lists[agno]);
+		action_list_init(&lists[agno]);
 	*listsp = lists;
 
-	return true;
+	return 0;
 }
 
 /* Free the repair lists. */
 void
-xfs_action_lists_free(
-	struct xfs_action_list		**listsp)
+action_lists_free(
+	struct action_list		**listsp)
 {
 	free(*listsp);
 	*listsp = NULL;
@@ -177,8 +180,8 @@ xfs_action_lists_free(
 
 /* Initialize repair list */
 void
-xfs_action_list_init(
-	struct xfs_action_list		*alist)
+action_list_init(
+	struct action_list		*alist)
 {
 	INIT_LIST_HEAD(&alist->list);
 	alist->nr = 0;
@@ -187,16 +190,16 @@ xfs_action_list_init(
 
 /* Number of repairs in this list. */
 size_t
-xfs_action_list_length(
-	struct xfs_action_list		*alist)
+action_list_length(
+	struct action_list		*alist)
 {
 	return alist->nr;
 };
 
 /* Add to the list of repairs. */
 void
-xfs_action_list_add(
-	struct xfs_action_list		*alist,
+action_list_add(
+	struct action_list		*alist,
 	struct action_item		*aitem)
 {
 	list_add_tail(&aitem->list, &alist->list);
@@ -206,9 +209,9 @@ xfs_action_list_add(
 
 /* Splice two repair lists. */
 void
-xfs_action_list_splice(
-	struct xfs_action_list		*dest,
-	struct xfs_action_list		*src)
+action_list_splice(
+	struct action_list		*dest,
+	struct action_list		*src)
 {
 	if (src->nr == 0)
 		return;
@@ -220,11 +223,11 @@ xfs_action_list_splice(
 }
 
 /* Repair everything on this list. */
-bool
-xfs_action_list_process(
+int
+action_list_process(
 	struct scrub_ctx		*ctx,
 	int				fd,
-	struct xfs_action_list		*alist,
+	struct action_list		*alist,
 	unsigned int			repair_flags)
 {
 	struct action_item		*aitem;
@@ -247,7 +250,7 @@ xfs_action_list_process(
 			free(aitem);
 			continue;
 		case CHECK_ABORT:
-			return false;
+			return ECANCELED;
 		case CHECK_RETRY:
 			continue;
 		case CHECK_REPAIR:
@@ -255,35 +258,37 @@ xfs_action_list_process(
 		}
 	}
 
-	return !xfs_scrub_excessive_errors(ctx);
+	if (xfs_scrub_excessive_errors(ctx))
+		return ECANCELED;
+	return 0;
 }
 
 /* Defer all the repairs until phase 4. */
 void
-xfs_action_list_defer(
+action_list_defer(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	ASSERT(agno < ctx->mnt.fsgeom.agcount);
 
-	xfs_action_list_splice(&ctx->action_lists[agno], alist);
+	action_list_splice(&ctx->action_lists[agno], alist);
 }
 
 /* Run actions now and defer unfinished items for later. */
-bool
-xfs_action_list_process_or_defer(
+int
+action_list_process_or_defer(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
-	bool				moveon;
+	int				ret;
 
-	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, alist,
+	ret = action_list_process(ctx, ctx->mnt.fd, alist,
 			ALP_REPAIR_ONLY | ALP_NOPROGRESS);
-	if (!moveon)
-		return moveon;
+	if (ret)
+		return ret;
 
-	xfs_action_list_defer(ctx, agno, alist);
-	return true;
+	action_list_defer(ctx, agno, alist);
+	return 0;
 }
diff --git a/scrub/repair.h b/scrub/repair.h
index c8693ccf..1994c50a 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -6,24 +6,22 @@
 #ifndef XFS_SCRUB_REPAIR_H_
 #define XFS_SCRUB_REPAIR_H_
 
-struct xfs_action_list {
+struct action_list {
 	struct list_head	list;
 	size_t			nr;
 	bool			sorted;
 };
 
-bool xfs_action_lists_alloc(size_t nr, struct xfs_action_list **listsp);
-void xfs_action_lists_free(struct xfs_action_list **listsp);
+int action_lists_alloc(size_t nr, struct action_list **listsp);
+void action_lists_free(struct action_list **listsp);
 
-void xfs_action_list_init(struct xfs_action_list *alist);
-size_t xfs_action_list_length(struct xfs_action_list *alist);
-void xfs_action_list_add(struct xfs_action_list *dest,
-		struct action_item *item);
-void xfs_action_list_splice(struct xfs_action_list *dest,
-		struct xfs_action_list *src);
+void action_list_init(struct action_list *alist);
+size_t action_list_length(struct action_list *alist);
+void action_list_add(struct action_list *dest, struct action_item *item);
+void action_list_splice(struct action_list *dest, struct action_list *src);
 
-void xfs_action_list_find_mustfix(struct xfs_action_list *actions,
-		struct xfs_action_list *immediate_alist,
+void action_list_find_mustfix(struct action_list *actions,
+		struct action_list *immediate_alist,
 		unsigned long long *broken_primaries,
 		unsigned long long *broken_secondaries);
 
@@ -32,11 +30,11 @@ void xfs_action_list_find_mustfix(struct xfs_action_list *actions,
 #define ALP_COMPLAIN_IF_UNFIXED	(XRM_COMPLAIN_IF_UNFIXED)
 #define ALP_NOPROGRESS		(1U << 31)
 
-bool xfs_action_list_process(struct scrub_ctx *ctx, int fd,
-		struct xfs_action_list *alist, unsigned int repair_flags);
-void xfs_action_list_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct xfs_action_list *alist);
-bool xfs_action_list_process_or_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct xfs_action_list *alist);
+int action_list_process(struct scrub_ctx *ctx, int fd,
+		struct action_list *alist, unsigned int repair_flags);
+void action_list_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct action_list *alist);
+int action_list_process_or_defer(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+		struct action_list *alist);
 
 #endif /* XFS_SCRUB_REPAIR_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 80a8cfdc..5eb1b276 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -253,7 +253,7 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 static int
 xfs_scrub_save_repair(
 	struct scrub_ctx		*ctx,
-	struct xfs_action_list		*alist,
+	struct action_list		*alist,
 	struct xfs_scrub_metadata	*meta)
 {
 	struct action_item		*aitem;
@@ -281,7 +281,7 @@ xfs_scrub_save_repair(
 		break;
 	}
 
-	xfs_action_list_add(alist, aitem);
+	action_list_add(alist, aitem);
 	return 0;
 }
 
@@ -296,7 +296,7 @@ xfs_scrub_meta_type(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
 	xfs_agnumber_t			agno,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {
 		.sm_type		= type,
@@ -337,7 +337,7 @@ xfs_scrub_all_types(
 	struct scrub_ctx		*ctx,
 	enum xfrog_scrub_type		scrub_type,
 	xfs_agnumber_t			agno,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	const struct xfrog_scrub_descr	*sc;
 	unsigned int			type;
@@ -368,7 +368,7 @@ xfs_scrub_all_types(
 int
 xfs_scrub_primary_super(
 	struct scrub_ctx		*ctx,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
 }
@@ -378,7 +378,7 @@ int
 xfs_scrub_ag_headers(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
 }
@@ -388,7 +388,7 @@ int
 xfs_scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
 }
@@ -397,7 +397,7 @@ xfs_scrub_ag_metadata(
 int
 xfs_scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
 }
@@ -406,7 +406,7 @@ xfs_scrub_fs_metadata(
 int
 xfs_scrub_fs_summary(
 	struct scrub_ctx		*ctx,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
 }
@@ -447,7 +447,7 @@ __xfs_scrub_file(
 	uint64_t			ino,
 	uint32_t			gen,
 	unsigned int			type,
-	struct xfs_action_list		*alist)
+	struct action_list		*alist)
 {
 	struct xfs_scrub_metadata	meta = {0};
 	enum check_outcome		fix;
@@ -474,7 +474,7 @@ xfs_scrub_inode_fields(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
 }
@@ -484,7 +484,7 @@ xfs_scrub_data_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
 }
@@ -494,7 +494,7 @@ xfs_scrub_attr_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
 }
@@ -504,7 +504,7 @@ xfs_scrub_cow_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
 }
@@ -514,7 +514,7 @@ xfs_scrub_dir(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
 }
@@ -524,7 +524,7 @@ xfs_scrub_attr(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
 }
@@ -534,7 +534,7 @@ xfs_scrub_symlink(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
 }
@@ -544,7 +544,7 @@ xfs_scrub_parent(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
 	uint32_t		gen,
-	struct xfs_action_list	*alist)
+	struct action_list	*alist)
 {
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index bfb3f8e3..161e694f 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -17,16 +17,13 @@ enum check_outcome {
 struct action_item;
 
 void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
-int xfs_scrub_primary_super(struct scrub_ctx *ctx,
-		struct xfs_action_list *alist);
+int xfs_scrub_primary_super(struct scrub_ctx *ctx, struct action_list *alist);
 int xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
-		struct xfs_action_list *alist);
-int xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
-		struct xfs_action_list *alist);
-int xfs_scrub_fs_summary(struct scrub_ctx *ctx,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
+int xfs_scrub_fs_metadata(struct scrub_ctx *ctx, struct action_list *alist);
+int xfs_scrub_fs_summary(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool xfs_can_scrub_inode(struct scrub_ctx *ctx);
@@ -38,21 +35,21 @@ bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
 int xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 int xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
-		struct xfs_action_list *alist);
+		struct action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */
 struct action_item {
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 4353756c..f997136b 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -71,7 +71,7 @@ struct scrub_ctx {
 
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
-	struct xfs_action_list	*action_lists;
+	struct action_list	*action_lists;
 	unsigned long long	max_errors;
 	unsigned long long	runtime_errors;
 	unsigned long long	errors_found;


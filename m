Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDCFC4708D
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Dec 2022 15:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiL1PrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Dec 2022 10:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbiL1Pqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Dec 2022 10:46:44 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C891E167E4
        for <linux-xfs@vger.kernel.org>; Wed, 28 Dec 2022 07:46:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VYI2m8y_1672242395;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VYI2m8y_1672242395)
          by smtp.aliyun-inc.com;
          Wed, 28 Dec 2022 23:46:38 +0800
Date:   Wed, 28 Dec 2022 23:46:35 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, jack.qiu@huawei.com,
        yi.zhang@huawei.com, zhengbin13@huawei.com
Subject: Re: [PATCH] xfs: fix btree splitting failure when AG space about to
 be exhausted
Message-ID: <Y6xk2xwrkdF/BoXM@B-P7TQMD6M-0146.local>
Mail-Followup-To: Guo Xuenan <guoxuenan@huawei.com>, djwong@kernel.org,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, jack.qiu@huawei.com,
        yi.zhang@huawei.com, zhengbin13@huawei.com
References: <20221228133204.4021519-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221228133204.4021519-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Xuenan,

On Wed, Dec 28, 2022 at 09:32:04PM +0800, Guo Xuenan wrote:
> Recently, I noticed an special problem on our products. The disk space
> is sufficient, while encounter btree split failure. After looking inside
> the disk, I found the specific AG space is about to be exhausted.
> More seriously, under this special situation, btree split failure will
> always be triggered and XFS filesystem is unavailable.
> 
> After analysis the disk image and the AG, which seem same as Gao Xiang met
> before [1], The slight difference is my problem is triggered by creating
> new inode, I read through your discussion the mailing list[1], I think it's
> probably the same root cause.
> 
> As Dave pointed out, args->minleft has an *exact* meaning, both inode fork
> allocations and inode chunk extent allocation pre-calculate args->minleft
> to ensure inobt record insertion succeed in any circumstances. But, this
> guarantee dosen't seem to be reliable, especially when it happens to meet
> cnt&bno btree splitting. Gao Xiang proposed an solution by adding postalloc
> to make current allocation reserve more space for inobt splitting, I think
> it's ok to slove their own problem, but may not be sloved completely, since
> inode chunk extent allocation may failed during inobt splitting too.
> 
> Meanwhile, Gao Xiang also noticed strip align requirement may increase
> probablility of the problem, which is totally true. I think the reason is
> that align requirement may lead to one free extent divied into two, which
> increase probablility of the problem. eg: we needs an extent length 4 and
> align 4 and find a suitable free extent [3,10] ([start,length]), after this
> allocation, the lefted extents are [3,1] and [9,5]. Therefore, alignment
> allocation is more likely to increase the number of free extents, then may
> lead cnt&bno btree splitting, which increases likelihood of the problem.
> 
> In my opinion, XFS has avariety of btrees, in order to ensure the growth of
> the btrees, XFS use args->minleft/agfl/perag reservation to achieve this,
> which corresponds as follows:
> 
> perag reservation: for reverse map & freeinode & refcount btree
> args->minleft    : for inode btree & inode/attr fork btree
> agfl             : for block btree (bnobt) & count btree (cntbt)
> (rmapbt is exception, it has reservation but get free block from agfl,
> since agfl blocks are considered as free when calculate available space,
> and rmapbt allocates block from it's reservation, *rmapbt growth* don't
> affect available space calculation, so don't care about it)
> 
> Before each allocation need to calculate or prepare these reservation,
> more precisely, call `xfs_alloc_space_available` to determine whether there
> is enough space to complete current allocation, including those involved
> tree growth. if xfs_alloc_space_available is true which means tree growth
> can definitely success.
> 
> I think the root cause of the current problem is when AG space is about to
> exhausted and happened to encounter cnt&bno btree splitting,
> `xfs_alloc_space_available` does't work well.
> 
> Because, considering btree splitting during "space allocation", we will
> meet block allocations many times for each "space allocation":
> 1st. allocation for space required at the beginning, i.e extent A1.
> 2nd. then need to *insert* or *update* free extent to cntbt & bnobt, which
>      *may* lead to btree splitting and need allocation (as explained above)
> 3rd. extent A1 need to insert inode/attr fork btree or inobt etc.. which
>      *may* also lead to splitting and allocation
> 
> So, during block allocations, which will calling xfs_alloc_space_available
> at least 2 times (2nd don't call it, because bnt&cnt btree get block from
> agfl). Since the 1st judgement of space available, it has guaranteed there
> is enough space to complete 2nd and 3rd allocation, *BUT* after 2nd
> allocation, if the height bno&cnt btree increase, min_freelist of agfl will
> increase, more acurrate, xfs_alloc_min_freelist will increase, which may
> lead to 3rd allocation failed, and 3rd allocation failure will make our xfs
> filesystem unavailable.
> 
> According to the above description, since every space allocation, we have
> guaranteed agfl min free list is enough for bno&cnt btree growth by
> calling `xfs_alloc_fix_freelist` to reserve enough agfl before we do 1st

Personally I'm not sure if it's the right way since I don't think we
should select _this AG_ at all in the 1st allocation (yet due to lack of
necessary reservation for bnobt/cntbt splits, currently it could select
it by mistake) rather than silently select _this AG_ which may could
impact another reservation and cause even very rare corner cases to
users.

Anyway, I have a low-confident unfinished AGFL reservation patchset without
verification (I don't have a real reproducer-- need to seek Zorro and
I badly got COVID with fever since the last week..)


From 7aed129bbd23fa2cc67c1818f6e904d681b43858 Mon Sep 17 00:00:00 2001
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Date: Mon, 19 Dec 2022 08:03:52 +0800
Subject: [PATCH 1/2] xfs: add AGFL refilling reservation

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_ag.h      |  4 +--
 fs/xfs/libxfs/xfs_ag_resv.c | 52 +++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_ag_resv.h |  3 ++-
 3 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 191b22b9a35b..1e46d3068afe 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -61,8 +61,8 @@ struct xfs_perag {

 	/* Blocks reserved for all kinds of metadata. */
 	struct xfs_ag_resv	pag_meta_resv;
-	/* Blocks reserved for the reverse mapping btree. */
-	struct xfs_ag_resv	pag_rmapbt_resv;
+	/* Blocks reserved for the reverse mapping btree and AGFL refilling. */
+	struct xfs_ag_resv	pag_agfl_resv;

 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 5af123d13a63..f9bc190dd718 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -75,13 +75,13 @@ xfs_ag_resv_critical(

 	switch (type) {
 	case XFS_AG_RESV_METADATA:
-		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved;
+		avail = pag->pagf_freeblks - pag->pag_agfl_resv.ar_reserved;
 		orig = pag->pag_meta_resv.ar_asked;
 		break;
 	case XFS_AG_RESV_RMAPBT:
 		avail = pag->pagf_freeblks + pag->pagf_flcount -
 			pag->pag_meta_resv.ar_reserved;
-		orig = pag->pag_rmapbt_resv.ar_asked;
+		orig = pag->pag_agfl_resv.ar_asked;
 		break;
 	default:
 		ASSERT(0);
@@ -107,10 +107,11 @@ xfs_ag_resv_needed(
 {
 	xfs_extlen_t			len;

-	len = pag->pag_meta_resv.ar_reserved + pag->pag_rmapbt_resv.ar_reserved;
+	len = pag->pag_meta_resv.ar_reserved + pag->pag_agfl_resv.ar_reserved;
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
+	case XFS_AG_RESV_AGFL:
 		len -= xfs_perag_resv(pag, type)->ar_reserved;
 		break;
 	case XFS_AG_RESV_NONE:
@@ -145,7 +146,7 @@ __xfs_ag_resv_free(
 	 * considered "free", so whatever was reserved at mount time must be
 	 * given back at umount.
 	 */
-	if (type == XFS_AG_RESV_RMAPBT)
+	if (type == XFS_AG_RESV_RMAPBT || type == XFS_AG_RESV_AGFL)
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
@@ -168,7 +169,7 @@ xfs_ag_resv_free(
 	int				error;
 	int				err2;

-	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
+	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
 	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
 	if (err2 && !error)
 		error = err2;
@@ -191,7 +192,7 @@ __xfs_ag_resv_init(
 		ask = used;

 	switch (type) {
-	case XFS_AG_RESV_RMAPBT:
+	case XFS_AG_RESV_AGFL:
 		/*
 		 * Space taken by the rmapbt is not subtracted from fdblocks
 		 * because the rmapbt lives in the free space.  Here we must
@@ -244,6 +245,27 @@ __xfs_ag_resv_init(
 	return 0;
 }

+int
+xfs_agfl_calc_reserves(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_extlen_t		*ask,
+	xfs_extlen_t		*used)
+{
+	xfs_extlen_t len, allocbtres;
+
+	ASSERT(mp->m_alloc_maxlevels);
+
+	allocbtres = mp->m_alloc_maxlevels;
+	len = 2 * allocbtres *
+		max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]);
+	len = max(len, allocbtres * M_IGEO(mp)->inobt_maxlevels);
+
+	*ask += len;
+	return 0;
+}
+
 /* Create a per-AG block reservation. */
 int
 xfs_ag_resv_init(
@@ -296,15 +318,19 @@ xfs_ag_resv_init(
 			has_resv = true;
 	}

-	/* Create the RMAPBT metadata reservation */
-	if (pag->pag_rmapbt_resv.ar_asked == 0) {
+	/* Create the RMAPBT metadata and AGFL refilling reservation */
+	if (pag->pag_agfl_resv.ar_asked == 0) {
 		ask = used = 0;

 		error = xfs_rmapbt_calc_reserves(mp, tp, pag, &ask, &used);
 		if (error)
 			goto out;

-		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
+		error = xfs_agfl_calc_reserves(mp, tp, pag, &ask, &used);
+		if (error)
+			goto out;
+
+		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
 		if (error)
 			goto out;
 		if (ask)
@@ -336,7 +362,7 @@ xfs_ag_resv_init(
 		 */
 		if (!error &&
 		    xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
-		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
+		    xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved >
 		    pag->pagf_freeblks + pag->pagf_flcount)
 			error = -ENOSPC;
 	}
@@ -359,7 +385,6 @@ xfs_ag_resv_alloc_extent(

 	switch (type) {
 	case XFS_AG_RESV_AGFL:
-		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
 		resv = xfs_perag_resv(pag, type);
@@ -376,7 +401,7 @@ xfs_ag_resv_alloc_extent(

 	len = min_t(xfs_extlen_t, args->len, resv->ar_reserved);
 	resv->ar_reserved -= len;
-	if (type == XFS_AG_RESV_RMAPBT)
+	if (type == XFS_AG_RESV_RMAPBT || type == XFS_AG_RESV_AGFL)
 		return;
 	/* Allocations of reserved blocks only need on-disk sb updates... */
 	xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS, -(int64_t)len);
@@ -401,7 +426,6 @@ xfs_ag_resv_free_extent(

 	switch (type) {
 	case XFS_AG_RESV_AGFL:
-		return;
 	case XFS_AG_RESV_METADATA:
 	case XFS_AG_RESV_RMAPBT:
 		resv = xfs_perag_resv(pag, type);
@@ -416,7 +440,7 @@ xfs_ag_resv_free_extent(

 	leftover = min_t(xfs_extlen_t, len, resv->ar_asked - resv->ar_reserved);
 	resv->ar_reserved += leftover;
-	if (type == XFS_AG_RESV_RMAPBT)
+	if (type == XFS_AG_RESV_RMAPBT || type == XFS_AG_RESV_AGFL)
 		return;
 	/* Freeing into the reserved pool only requires on-disk update... */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index b74b210008ea..e9e963c8aebb 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -27,7 +27,8 @@ xfs_perag_resv(
 	case XFS_AG_RESV_METADATA:
 		return &pag->pag_meta_resv;
 	case XFS_AG_RESV_RMAPBT:
-		return &pag->pag_rmapbt_resv;
+	case XFS_AG_RESV_AGFL:
+		return &pag->pag_agfl_resv;
 	default:
 		return NULL;
 	}
--
2.24.4



From 88e218d652f62d07a48510f9069a6747fed9ec0a Mon Sep 17 00:00:00 2001
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Date: Thu, 3 Nov 2022 21:10:25 +0800
Subject: [PATCH 2/2] xfs: extend the freelist before available space check

Reported-by: Zirong Lang <zlang@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 189 ++++++++++++++++++++++++--------------
 1 file changed, 121 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 989cf341779b..b72106bc9a94 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2362,7 +2362,6 @@ xfs_free_agfl_block(
 	if (error)
 		return error;
 	xfs_trans_binval(tp, bp);
-
 	return 0;
 }

@@ -2583,6 +2582,86 @@ xfs_exact_minlen_extent_available(
 }
 #endif

+/*
+ * The freelist has to be in a good state before the available space check
+ * since multiple allocations could be performed from a single AG and
+ * transaction under certain conditions.  For example, A bmbt allocation
+ * request made for inode extent to bmap format conversion after an extent
+ * allocation is expected to be satisfied by the same AG.  Such bmap conversion
+ * allocation can fail due to the available space check if allocbt required an
+ * extra btree block from the freelist in the previous allocation but without
+ * making the freelist longer.
+ */
+int
+xfs_fill_agfl(
+	struct xfs_alloc_arg    *args,
+	int			flags,
+	xfs_extlen_t		need,
+	struct xfs_buf          *agbp)
+{
+	struct xfs_trans	*tp = args->tp;
+	struct xfs_perag	*pag = agbp->b_pag;
+	struct xfs_alloc_arg	targs = {
+		.tp		= tp,
+		.mp		= tp->t_mountp,
+		.agbp		= agbp,
+		.agno		= args->agno,
+		.alignment	= 1,
+		.minlen		= 1,
+		.prod		= 1,
+		.type		= XFS_ALLOCTYPE_THIS_AG,
+		.pag		= pag,
+	};
+	struct xfs_buf          *agflbp = NULL;
+	xfs_agblock_t		bno;
+	int error;
+
+	if (flags & XFS_ALLOC_FLAG_NORMAP)
+		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	else
+		targs.oinfo = XFS_RMAP_OINFO_AG;
+
+	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
+	if (error)
+		return error;
+
+	/* Make the freelist longer if it's too short. */
+	while (pag->pagf_flcount < need) {
+		targs.agbno = 0;
+		targs.maxlen = need - pag->pagf_flcount;
+		targs.resv = XFS_AG_RESV_AGFL;
+
+		/* Allocate as many blocks as possible at once. */
+		error = xfs_alloc_ag_vextent(&targs);
+		if (error)
+			goto out_agflbp_relse;
+
+		/*
+		 * Stop if we run out.  Won't happen if callers are obeying
+		 * the restrictions correctly.  Can happen for free calls
+		 * on a completely full ag.
+		 */
+		if (targs.agbno == NULLAGBLOCK) {
+			if (flags & XFS_ALLOC_FLAG_FREEING)
+				break;
+			goto out_agflbp_relse;
+		}
+
+		/*
+		 * Put each allocated block on the list.
+		 */
+		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
+			error = xfs_alloc_put_freelist(pag, tp, agbp,
+							agflbp, bno, 0);
+			if (error)
+				goto out_agflbp_relse;
+		}
+	}
+out_agflbp_relse:
+	xfs_trans_brelse(tp, agflbp);
+	return error;
+}
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2596,8 +2675,7 @@ xfs_alloc_fix_freelist(
 	struct xfs_perag	*pag = args->pag;
 	struct xfs_trans	*tp = args->tp;
 	struct xfs_buf		*agbp = NULL;
-	struct xfs_buf		*agflbp = NULL;
-	struct xfs_alloc_arg	targs;	/* local allocation arguments */
+	struct xfs_owner_info	oinfo;
 	xfs_agblock_t		bno;	/* freelist block */
 	xfs_extlen_t		need;	/* total blocks needed in freelist */
 	int			error = 0;
@@ -2626,22 +2704,45 @@ xfs_alloc_fix_freelist(
 		goto out_agbp_relse;
 	}

-	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, flags |
-			XFS_ALLOC_FLAG_CHECK))
-		goto out_agbp_relse;
-
 	/*
-	 * Get the a.g. freespace buffer.
-	 * Can fail if we're not blocking on locks, and it's held.
+	 * See the comment above xfs_fill_agfl() for the reason why we need to
+	 * make freelist longer here.  Assumed that such case is quite rare, so
+	 * in order to simplify the code, let's take agbp unconditionally.
 	 */
-	if (!agbp) {
-		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
-		if (error) {
-			/* Couldn't lock the AGF so skip this AG. */
-			if (error == -EAGAIN)
-				error = 0;
-			goto out_no_agbp;
+	need = xfs_alloc_min_freelist(mp, pag);
+	if (pag->pagf_flcount < need) {
+		/*
+		 * Get the a.g. freespace buffer.
+		 * Can fail if we're not blocking on locks, and it's held.
+		 */
+		if (!agbp) {
+			error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
+			if (error) {
+				/* Couldn't lock the AGF so skip this AG. */
+				if (error == -EAGAIN)
+					error = 0;
+				goto out_no_agbp;
+			}
+		}
+
+		need = xfs_alloc_min_freelist(mp, pag);
+		error = xfs_fill_agfl(args, flags, need, agbp);
+		if (error)
+			goto out_agbp_relse;
+	} else {
+		if (!xfs_alloc_space_available(args, need, flags |
+				XFS_ALLOC_FLAG_CHECK))
+			goto out_agbp_relse;
+
+		/* Get the a.g. freespace buffer. */
+		if (!agbp) {
+			error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
+			if (error) {
+				/* Couldn't lock the AGF so skip this AG. */
+				if (error == -EAGAIN)
+					error = 0;
+				goto out_no_agbp;
+			}
 		}
 	}

@@ -2687,69 +2788,21 @@ xfs_alloc_fix_freelist(
 	 * regenerated AGFL, bnobt, and cntbt.  See repair/phase5.c and
 	 * repair/rmap.c in xfsprogs for details.
 	 */
-	memset(&targs, 0, sizeof(targs));
-	/* struct copy below */
 	if (flags & XFS_ALLOC_FLAG_NORMAP)
-		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+		oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	else
-		targs.oinfo = XFS_RMAP_OINFO_AG;
+		oinfo = XFS_RMAP_OINFO_AG;
 	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
 		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;

 		/* defer agfl frees */
-		xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
-	}
-
-	targs.tp = tp;
-	targs.mp = mp;
-	targs.agbp = agbp;
-	targs.agno = args->agno;
-	targs.alignment = targs.minlen = targs.prod = 1;
-	targs.type = XFS_ALLOCTYPE_THIS_AG;
-	targs.pag = pag;
-	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
-	if (error)
-		goto out_agbp_relse;
-
-	/* Make the freelist longer if it's too short. */
-	while (pag->pagf_flcount < need) {
-		targs.agbno = 0;
-		targs.maxlen = need - pag->pagf_flcount;
-		targs.resv = XFS_AG_RESV_AGFL;
-
-		/* Allocate as many blocks as possible at once. */
-		error = xfs_alloc_ag_vextent(&targs);
-		if (error)
-			goto out_agflbp_relse;
-
-		/*
-		 * Stop if we run out.  Won't happen if callers are obeying
-		 * the restrictions correctly.  Can happen for free calls
-		 * on a completely full ag.
-		 */
-		if (targs.agbno == NULLAGBLOCK) {
-			if (flags & XFS_ALLOC_FLAG_FREEING)
-				break;
-			goto out_agflbp_relse;
-		}
-		/*
-		 * Put each allocated block on the list.
-		 */
-		for (bno = targs.agbno; bno < targs.agbno + targs.len; bno++) {
-			error = xfs_alloc_put_freelist(pag, tp, agbp,
-							agflbp, bno, 0);
-			if (error)
-				goto out_agflbp_relse;
-		}
+		xfs_defer_agfl_block(tp, args->agno, bno, &oinfo);
 	}
-	xfs_trans_brelse(tp, agflbp);
 	args->agbp = agbp;
 	return 0;

-out_agflbp_relse:
-	xfs_trans_brelse(tp, agflbp);
 out_agbp_relse:
 	if (agbp)
 		xfs_trans_brelse(tp, agbp);
--
2.24.4




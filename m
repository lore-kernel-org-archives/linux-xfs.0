Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D84347F771
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201690; cv=none; b=uHtPXVTOeRqVSDp0z4nkxWRSuE69uNaCY7rTics5zJfp02PEfxfz50n7vUKJ3AfOxFecDkhSqazOh8zeD57JjUAkUiTLiYXQeawfuARJNxv411h/RACJAdgh1mcti4btIuUstMJ6CNn18tne4QoY0Kbp2R436Kskox3GjfuYrlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201690; c=relaxed/simple;
	bh=wMOEs1+W+9poWF4Ls4bsfj34dvOxE6oMicC3VInXiY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DzS0sFYFY42vSMi2u8bvCkRuK3/2+TzQ73bKfYsqSPI3QNdqRuroMVeKUQVsqTmWqPnv5rRmfZRPJOmsXW15YQ9GQTzwSfDA4xSpx38umWSI/jVKQfWoy97LrkysNUzy4wcuBInoArX11+CzpBaarWB4m1h3bwV8U0ThXXS9J0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hhQlF6D5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hhQlF6D5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791201687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kddpipk3JAAYBIr8Q8TVRmX+cmMeL6Ou5wqwfo1LQGQ=;
	b=hhQlF6D5fTQb/86IejPpXnFMWeuZwcPnQnT7yAgL2gnprFVZ4xvny0FZbOmh1Dsg8c4M2R
	uGjveepeHFsQy6QpIJ5wF3imH5q/WJ3I99wmKRYJuoxyfHR2F7Nfnt31lstc/3tRZqKyFi
	8W5VG88ieptxu8lcofTNr6hqoYg0d1w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-kWGkkRBONWaflILEd-d_kQ-1; Mon,
 05 Oct 2026 08:01:23 -0400
X-MC-Unique: kWGkkRBONWaflILEd-d_kQ-1
X-Mimecast-MFC-AGG-ID: kWGkkRBONWaflILEd-d_kQ_1791201682
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B02A11955F6F;
	Mon,  5 Oct 2026 12:01:22 +0000 (UTC)
Received: from bfoster.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32B6D1956087;
	Mon,  5 Oct 2026 12:01:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v5 4/4] xfs: incorporate increased AGFL min requirement for minleft allocs
Date: Mon,  5 Oct 2026 08:01:18 -0400
Message-ID: <20261005120118.229086-5-bfoster@redhat.com>
In-Reply-To: <20261005120118.229086-1-bfoster@redhat.com>
References: <20261005120118.229086-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Matt Fleming reports a filesystem shutdown due to inobt block
allocation failure during sparse chunk allocation. Inode creation
can involve multiple allocations in a transaction: the initial chunk
allocation and inode btree blocks via inobt record insertion. This
is expected to be safe by using the minleft parameter on the chunk
allocation to guarantee the selected AG has blocks available for
a followup inobt insertion.

The sequence that leads to this failure is that the alloc and inode
btrees are all full (require a full split on next insertion) and the
AG has just enough free space to satisfy a sparse chunk allocation
with minleft set (i.e. 7 blocks in this example). The chunk
allocation splits a free extent, triggers full allocbt splits, and
consumes 4 free blocks for the chunk and 4 AGFL blocks for the
btrees.

Next, the inobt record insertion triggers an inobt split. The AG has
enough free blocks, but the allocbt splits caused by the chunk
allocation have increased the min AGFL requirement for the AG due to
btree level increases. The AGFL requirement as calculated by
xfs_alloc_fix_freelist() is:

	free + AGFL - res - minfree - minleft = avail

This evaluates to the following on initial chunk allocation:

	2514 + 8 - 2505 - 8 - 2 = 7

... and then after the chunk allocation but before the inobt block
allocation:

	2510 + 4 - 2505 - 12 - 0 = -3

This causes the inobt alloc to fail despite minleft being set in the
first allocation. The error path cancels the dirty transaction and
shuts down the fs. The problem here is that while minleft ensures
free blocks are available for the inobt insert, it is not sufficient
to cover the increase of the AGFL min free requirement.

To address this, first have xfs_alloc_freelist() return both min and
max freelist values. The min value is the current AGFL requirement
and remains used for actual AGFL sizing. The max value calculates
the worst case AGFL requirement after potential allocbt splits
during the current allocation. Incorporate the max value into space
availability checks for AG selection and the longest free extent
calculation. The latter is necessary because callers like the bmap
layer can size allocation requests based on the longest free extent.
Without this, aligned allocs can end up oversized, prematurely fail,
and fall back to non-aligned to make up the difference.

This ensures the selected AG has enough blocks for both the caller's
minleft value and the worst case AGFL increase. In the example
above, the initial calculation now evaluates to 3 blocks available
instead of 7 and the inode allocation fails gracefully with -ENOSPC.

Assisted-by: LLM
Reported-by: Matt Fleming <matt@readmodwrite.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 58 +++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h |  3 +-
 fs/xfs/libxfs/xfs_bmap.c  |  6 ++--
 3 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index af63926cc9ee..ae221a158764 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2397,31 +2397,36 @@ xfs_alloc_compute_maxlevels(
 }
 
 /*
- * Find the length of the longest extent in an AG.  The 'need' parameter
- * specifies how much space we're going to need for the AGFL and the
- * 'reserved' parameter tells us how many blocks in this AG are reserved for
+ * Find the length of the longest extent in an AG. The @min_agfl and @max_agfl
+ * parameters specify how much space we're going to need for the AGFL and the
+ * @reserved parameter tells us how many blocks in this AG are reserved for
  * other callers.
  */
 xfs_extlen_t
 xfs_alloc_longest_free_extent(
 	struct xfs_perag	*pag,
-	xfs_extlen_t		need,
+	xfs_extlen_t		min_agfl,
+	xfs_extlen_t		max_agfl,
 	xfs_extlen_t		reserved)
 {
 	xfs_extlen_t		delta = 0;
 
 	/*
-	 * If the AGFL needs a recharge, we'll have to subtract that from the
-	 * longest extent.
+	 * If the AGFL needs a recharge, subtract that from the longest extent
+	 * because AGFL refill happens before the alloc.
 	 */
-	if (need > pag->pagf_flcount)
-		delta = need - pag->pagf_flcount;
+	if (min_agfl > pag->pagf_flcount)
+		delta = min_agfl - pag->pagf_flcount;
 
 	/*
-	 * If we cannot maintain others' reservations with space from the
-	 * not-longest freesp extents, we'll have to subtract /that/ from
-	 * the longest extent too.
+	 * Extra AGFL blocks beyond the min are reserved by ->minleft during
+	 * allocation. Similar to reserved, these blocks are not available to
+	 * this allocation. Check if we can preserve the combined total without
+	 * the longest extent. If not, deduct the necessary blocks from the
+	 * longest extent.
 	 */
+	if (max_agfl > min_agfl)
+		reserved += max_agfl - min_agfl;
 	if (pag->pagf_freeblks - pag->pagf_longest < reserved)
 		delta += reserved - (pag->pagf_freeblks - pag->pagf_longest);
 
@@ -2519,6 +2524,7 @@ static bool
 xfs_alloc_space_available(
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		min_free,
+	xfs_extlen_t		max_free,
 	int			flags)
 {
 	struct xfs_perag	*pag = args->pag;
@@ -2526,15 +2532,32 @@ xfs_alloc_space_available(
 	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
 	xfs_extlen_t		agflcount;
+	xfs_extlen_t		minleft;
 
 	if (flags & XFS_ALLOC_FLAG_FREEING)
 		return true;
 
 	reservation = xfs_ag_resv_needed(pag, args->resv);
 
+	/*
+	 * minleft implies a multi-alloc transaction. If set, the first alloc
+	 * might cause btree splits that increase the AGFL requirement for the
+	 * next. This worst case requirement is calculated in max_free.
+	 *
+	 * We don't prepopulate the AGFL because we don't know in advance if
+	 * splits will occur. Instead, add the delta to minleft so it is
+	 * accounted for in AG selection. This ensures the AG has enough space
+	 * for the caller's minleft plus that needed to repopulate the AGFL on
+	 * the next alloc if splits do occur.
+	 */
+	minleft = args->minleft;
+	if (minleft)
+		minleft += max_free - min_free;
+
 	/* do we have enough contiguous free space for the allocation? */
 	alloc_len = args->minlen + (args->alignment - 1) + args->minalignslop;
-	longest = xfs_alloc_longest_free_extent(pag, min_free, reservation);
+	longest = xfs_alloc_longest_free_extent(pag, min_free,
+			minleft ? max_free : min_free, reservation);
 	if (longest < alloc_len)
 		return false;
 
@@ -2545,7 +2568,7 @@ xfs_alloc_space_available(
 	 */
 	agflcount = min_t(xfs_extlen_t, pag->pagf_flcount, min_free);
 	available = (int)(pag->pagf_freeblks + agflcount -
-			  reservation - min_free - args->minleft);
+			  reservation - min_free - minleft);
 	if (available < (int)max(args->total, alloc_len))
 		return false;
 
@@ -2859,6 +2882,7 @@ xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	targs;	/* local allocation arguments */
 	xfs_agblock_t		bno;	/* freelist block */
 	xfs_extlen_t		min_free;/* total blocks needed in freelist */
+	xfs_extlen_t		max_free; /* max freelist requirement */
 	int			error = 0;
 
 	/* deferred ops (AGFL block frees) require permanent transactions */
@@ -2886,8 +2910,8 @@ xfs_alloc_fix_freelist(
 		goto out_agbp_relse;
 	}
 
-	xfs_alloc_freelist(mp, pag, &min_free, NULL);
-	if (!xfs_alloc_space_available(args, min_free, alloc_flags |
+	xfs_alloc_freelist(mp, pag, &min_free, &max_free);
+	if (!xfs_alloc_space_available(args, min_free, max_free, alloc_flags |
 			XFS_ALLOC_FLAG_CHECK))
 		goto out_agbp_relse;
 
@@ -2910,8 +2934,8 @@ xfs_alloc_fix_freelist(
 		xfs_agfl_reset(tp, agbp, pag);
 
 	/* If there isn't enough total space or single-extent, reject it. */
-	xfs_alloc_freelist(mp, pag, &min_free, NULL);
-	if (!xfs_alloc_space_available(args, min_free, alloc_flags))
+	xfs_alloc_freelist(mp, pag, &min_free, &max_free);
+	if (!xfs_alloc_space_available(args, min_free, max_free, alloc_flags))
 		goto out_agbp_relse;
 
 	if (IS_ENABLED(CONFIG_XFS_DEBUG) && args->alloc_minlen_only) {
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 44a10f4a22a2..5812c9b5e609 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -70,7 +70,8 @@ unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
 unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_perag *pag,
-		xfs_extlen_t need, xfs_extlen_t reserved);
+		xfs_extlen_t min_free, xfs_extlen_t max_free,
+		xfs_extlen_t reserved);
 void xfs_alloc_freelist(struct xfs_mount *mp, struct xfs_perag *pag,
 		unsigned int *min_free, unsigned int *max_free);
 int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d6be6734bd90..9bffde1484a7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3150,6 +3150,7 @@ xfs_bmap_longest_free_extent(
 {
 	xfs_extlen_t		longest;
 	unsigned int		min_free;
+	unsigned int		max_free;
 	int			error = 0;
 
 	if (!xfs_perag_initialised_agf(pag)) {
@@ -3159,8 +3160,9 @@ xfs_bmap_longest_free_extent(
 			return error;
 	}
 
-	xfs_alloc_freelist(pag_mount(pag), pag, &min_free, NULL);
-	longest = xfs_alloc_longest_free_extent(pag, min_free,
+	/* bmap allocs always have minleft set, so account for max_free */
+	xfs_alloc_freelist(pag_mount(pag), pag, &min_free, &max_free);
+	longest = xfs_alloc_longest_free_extent(pag, min_free, max_free,
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
-- 
2.55.0


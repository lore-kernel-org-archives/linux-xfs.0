Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9166379C44
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370839; cv=none; b=IIqlY7AtHl9a+xEwZa2kylVlaV0ND+CvcPE/78BB0QNF8sNKZHkdIDARz1N/UOJvOlTXc5WoqACmPDoUfNnptb8W3mlLphc2/KdTs233Xyh13Jk6YLLuE1ySZjAOdLwYzLYVTB2hS/nWwp4vP+zc+ktJ5nOdXYjlx2QacEBzqjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370839; c=relaxed/simple;
	bh=KCSwxlfMiMzlpEjMkVPwL05H/4hg3ta0ZWN1TDchmoM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=auBz2nYVkfdIU/aCwJwMQ2VmpKj8uZa40Q41SAtZUj8WW2On/4m9/PHwR6j+5uloc7sgYfUqE8OjS92nCTNj27cpsPmOWPkyOmkjgX/CGm1pSMyCvqgUh4nGr6eZwRcPG3EJ/7l8nOqEjx68WdS+hK+kwebzIf9cGlyK448Fb0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdsqjcUf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdsqjcUf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIl5U6yBZKIkpb97+jyILFJmV8KKqazuPGt5a5ZwYV0=;
	b=CdsqjcUfYKVyGSYO7/fwU5XX+tZGzP5wqXOH9TjsAxBuUtJ/R8z6bL/ExmdxmLH6Z3x/L8
	JvfZzY78lC0z+YwxWUVsrVpg1A0Xt+cvEhG4NnJXHupBAZ4Qz7xpfaHnw0mzuPBmrBZ5d6
	lXKRbOyLelqG40fcPTKdvQiLRYm/OTk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-XeqW3OqLN3elT95dp-N7NA-1; Wed,
 02 Sep 2026 13:40:34 -0400
X-MC-Unique: XeqW3OqLN3elT95dp-N7NA-1
X-Mimecast-MFC-AGG-ID: XeqW3OqLN3elT95dp-N7NA_1788370833
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 748541956070
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:33 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 177271803A40
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 17:40:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v3 4/4] xfs: incorporate increased AGFL min requirement for minleft allocs
Date: Wed,  2 Sep 2026 13:40:25 -0400
Message-ID: <20260902174025.284387-5-bfoster@redhat.com>
In-Reply-To: <20260902174025.284387-1-bfoster@redhat.com>
References: <20260902174025.284387-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
---
 fs/xfs/libxfs/xfs_alloc.c | 58 +++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h |  3 +-
 fs/xfs/libxfs/xfs_bmap.c  |  6 ++--
 3 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1377c65d694e..2ed269080bbb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2397,31 +2397,36 @@ xfs_alloc_compute_maxlevels(
 }
 
 /*
- * Find the length of the longest extent in an AG.  The 'need' parameter
- * specifies how much space we're going to need for the AGFL and the
- * 'reserved' parameter tells us how many blocks in this AG are reserved for
+ * Find the length of the longest extent in an AG. The @min_free and @max_free
+ * parameters specify how much space we're going to need for the AGFL and the
+ * @reserved parameter tells us how many blocks in this AG are reserved for
  * other callers.
  */
 xfs_extlen_t
 xfs_alloc_longest_free_extent(
 	struct xfs_perag	*pag,
-	xfs_extlen_t		need,
+	xfs_extlen_t		min_free,
+	xfs_extlen_t		max_free,
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
+	if (min_free > pag->pagf_flcount)
+		delta = min_free - pag->pagf_flcount;
 
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
+	if (max_free > min_free)
+		reserved += max_free - min_free;
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
index 17604e510ffc..d5b6b0592158 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3151,6 +3151,7 @@ xfs_bmap_longest_free_extent(
 {
 	xfs_extlen_t		longest;
 	unsigned int		min_free;
+	unsigned int		max_free;
 	int			error = 0;
 
 	if (!xfs_perag_initialised_agf(pag)) {
@@ -3160,8 +3161,9 @@ xfs_bmap_longest_free_extent(
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88F52B9C9
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 05:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724303010; cv=none; b=kgC3KOp7mDogYrfSGvTOUJJ+/S9+Q3tx3EkeYtfJ+F25tyZOJDO+OWs48Cw5smvzVo+5upDiTJGmKEJyyt8qGFyUSIzV5SmC5Tb5M9JmAhMw6Q18ONCgozFi2azukAsFYioThQNhF6E/75KS7aDmLHBSgFApUvn3PA8TtVlHVbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724303010; c=relaxed/simple;
	bh=z/KO8F5tRHKg/aKT1YvBjg1yIf7249Yllt1gAB+yu68=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CigddhK5FjPfU5f2V5Wr8yDCJo3mmIqqymzDRuTkp8lMFiibfgbww+T7CWSVaH98+/xc9NvbyezpXqgMHcDqegW6tIlg1z/3bYQ0tF+B87Yyvv3h30hvtp9KdXh1Mi0u4r0bASYD8QrHAf0ZIaYwuxHPM+gihK3vHKsgYtOtNLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPEvwt3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPEvwt3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702E9C4AF0B;
	Thu, 22 Aug 2024 05:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724303009;
	bh=z/KO8F5tRHKg/aKT1YvBjg1yIf7249Yllt1gAB+yu68=;
	h=Date:From:To:Cc:Subject:From;
	b=VPEvwt3NxHfTSc7oXA4PZp/GXdW11/HfiHl5oOswJnzMFU4Yeh3m3KNssqE7Ixqjk
	 GA5N3jLVO2ZczHi0CLoioeVL3T6swYcPrgKQy8OWlLP1m4ZpWAcjQDx76Lg9CHOL0H
	 V4y9xQlYY+hOCOdP02HEQjjwbIbes2mLHKQoRcbI3vOuQM4EGhhzNJK+69peVWIAFc
	 ZbvzShxKwm1xphTFH8nKrpVKGYF8WE9RqklmrCzlvq6944qg4fmC0v/rqpmEZuyMq5
	 3eQo6a1YKQusKImmsgmkCde1YZ4xpVNL48U9Hp0QzpNi1IyqOgK4DtISHCf3XrouiO
	 l2+za5VJNs00A==
Date: Wed, 21 Aug 2024 22:03:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH] xfs: don't bother reporting blocks trimmed via FITRIM
Message-ID: <20240822050328.GS6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Don't bother reporting the number of bytes that we "trimmed" because the
underlying storage isn't required to do anything(!) and failed discard
IOs aren't reported to the caller anyway.  It's not like userspace can
use the reported value for anything useful like adjusting the offset
parameter of the next call, and it's not like anyone ever wrote a
manpage about FITRIM's out parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6f0fc7fe1f2b..60c6ff1578e0 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -158,8 +158,7 @@ static int
 xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
 	struct xfs_trim_cur	*tcur,
-	struct xfs_busy_extents	*extents,
-	uint64_t		*blocks_trimmed)
+	struct xfs_busy_extents	*extents)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_trans	*tp;
@@ -280,7 +279,6 @@ xfs_trim_gather_extents(
 
 		xfs_extent_busy_insert_discard(pag, fbno, flen,
 				&extents->extent_list);
-		*blocks_trimmed += flen;
 next_extent:
 		if (tcur->by_bno)
 			error = xfs_btree_increment(cur, 0, &i);
@@ -327,8 +325,7 @@ xfs_trim_perag_extents(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		start,
 	xfs_agblock_t		end,
-	xfs_extlen_t		minlen,
-	uint64_t		*blocks_trimmed)
+	xfs_extlen_t		minlen)
 {
 	struct xfs_trim_cur	tcur = {
 		.start		= start,
@@ -354,8 +351,7 @@ xfs_trim_perag_extents(
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
-		error = xfs_trim_gather_extents(pag, &tcur, extents,
-				blocks_trimmed);
+		error = xfs_trim_gather_extents(pag, &tcur, extents);
 		if (error) {
 			kfree(extents);
 			break;
@@ -389,8 +385,7 @@ xfs_trim_datadev_extents(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
-	xfs_extlen_t		minlen,
-	uint64_t		*blocks_trimmed)
+	xfs_extlen_t		minlen)
 {
 	xfs_agnumber_t		start_agno, end_agno;
 	xfs_agblock_t		start_agbno, end_agbno;
@@ -411,8 +406,7 @@ xfs_trim_datadev_extents(
 
 		if (start_agno == end_agno)
 			agend = end_agbno;
-		error = xfs_trim_perag_extents(pag, start_agbno, agend, minlen,
-				blocks_trimmed);
+		error = xfs_trim_perag_extents(pag, start_agbno, agend, minlen);
 		if (error)
 			last_error = error;
 
@@ -431,9 +425,6 @@ struct xfs_trim_rtdev {
 	/* list of rt extents to free */
 	struct list_head	extent_list;
 
-	/* pointer to count of blocks trimmed */
-	uint64_t		*blocks_trimmed;
-
 	/* minimum length that caller allows us to trim */
 	xfs_rtblock_t		minlen_fsb;
 
@@ -551,7 +542,6 @@ xfs_trim_gather_rtextent(
 	busyp->length = rlen;
 	INIT_LIST_HEAD(&busyp->list);
 	list_add_tail(&busyp->list, &tr->extent_list);
-	*tr->blocks_trimmed += rlen;
 
 	tr->restart_rtx = rec->ar_startext + rec->ar_extcount;
 	return 0;
@@ -562,13 +552,11 @@ xfs_trim_rtdev_extents(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
-	uint64_t		*blocks_trimmed)
+	xfs_daddr_t		minlen)
 {
 	struct xfs_rtalloc_rec	low = { };
 	struct xfs_rtalloc_rec	high = { };
 	struct xfs_trim_rtdev	tr = {
-		.blocks_trimmed	= blocks_trimmed,
 		.minlen_fsb	= XFS_BB_TO_FSB(mp, minlen),
 	};
 	struct xfs_trans	*tp;
@@ -661,7 +649,6 @@ xfs_ioc_trim(
 	xfs_daddr_t		start, end;
 	xfs_extlen_t		minlen;
 	xfs_rfsblock_t		max_blocks;
-	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -706,15 +693,13 @@ xfs_ioc_trim(
 	end = start + BTOBBT(range.len) - 1;
 
 	if (bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev)) {
-		error = xfs_trim_datadev_extents(mp, start, end, minlen,
-				&blocks_trimmed);
+		error = xfs_trim_datadev_extents(mp, start, end, minlen);
 		if (error)
 			last_error = error;
 	}
 
 	if (rt_bdev && !xfs_trim_should_stop()) {
-		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
-				&blocks_trimmed);
+		error = xfs_trim_rtdev_extents(mp, start, end, minlen);
 		if (error)
 			last_error = error;
 	}
@@ -722,7 +707,9 @@ xfs_ioc_trim(
 	if (last_error)
 		return last_error;
 
-	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
+	range.len = min_t(unsigned long long, range.len,
+			  XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks +
+					   mp->m_sb.sb_rblocks));
 	if (copy_to_user(urange, &range, sizeof(range)))
 		return -EFAULT;
 	return 0;

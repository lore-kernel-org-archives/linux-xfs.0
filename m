Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665318732C
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371189; cv=none; b=f/4MN+H9mnrpDKFxPoWtNBpXxzOWR0JDMMU49sz7Dl84mqUVFvwWRV5K2HvX2jX0xEJbdz+Zy8eE1m6JT7qFl+0NWiMhWaeCXibC01aGuyd57wYWM5hOOc5RmA86M6VaVOpf0Keh4c3/oTK2v4uzlPFBgKxPdsZZ+oa+O+VSnY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371189; c=relaxed/simple;
	bh=0quQVLfRgrTxIiQE05bcM8l4Wi+bXiQSK/sWva+K1oQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPRl2OsFWojSiV0Wn2ALxQZdHOh0EYF60xKLyQdAS/MsCAXBSVZ2jsel4Hql4TThaxhCBKfok4SxUgFaulKbkWDGILNh3MA75qqpvBIyjjfnWAHvhvbUfKB9WQcIb1s8Kla84zyilEqBu2RF7zrnIGSOe5H3W71ulVVCmcKrD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njmH1HEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njmH1HEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF74C32782;
	Thu, 22 Aug 2024 23:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371189;
	bh=0quQVLfRgrTxIiQE05bcM8l4Wi+bXiQSK/sWva+K1oQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=njmH1HEBmRjFsvb5b71m3nyCVBooyKRZ5IwQRf13Uu1ki4A0hFHCAWfp2CjtnyO/P
	 n2Pox7VlP0LBoCtZic6Yd+L5qYKAU34SNO7fb0rwxePTgw4oDGGSYEBXKslKVC27Z5
	 TYrbSzbnCYRJh85gVnAtW2AcRCcF/tZENFhGRcmT51O20bGsGadzdiYvDFdrf1sJN0
	 1Bc/Z4b4Xlkse8y5Rd7k0bY8EwC6ll8UJXt4C2RlISPfEJDRFUjIn+JEzkHs+A2Cf+
	 /akNa6PnebZ66Pwx1nu0QdOynOv43z+lSXjSHLVK5aHtDGOG6Pn6qshMsLYk78C8Sl
	 ulCZoXrMWo/Sw==
Date: Thu, 22 Aug 2024 16:59:48 -0700
Subject: [PATCH 4/9] xfs: don't bother reporting blocks trimmed via FITRIM
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083819.56860.1505619846644204416.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't bother reporting the number of bytes that we "trimmed" because the
underlying storage isn't required to do anything(!) and failed discard
IOs aren't reported to the caller anyway.  It's not like userspace can
use the reported value for anything useful like adjusting the offset
parameter of the next call, and it's not like anyone ever wrote a
manpage about FITRIM's out parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_discard.c |   36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6f0fc7fe1f2ba..25f5dffeab2ae 100644
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
@@ -634,7 +622,7 @@ xfs_trim_rtdev_extents(
 	return error;
 }
 #else
-# define xfs_trim_rtdev_extents(m,s,e,n,b)	(-EOPNOTSUPP)
+# define xfs_trim_rtdev_extents(...)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 /*
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
@@ -722,7 +707,8 @@ xfs_ioc_trim(
 	if (last_error)
 		return last_error;
 
-	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
+	range.len = min_t(unsigned long long, range.len,
+			  XFS_FSB_TO_B(mp, max_blocks));
 	if (copy_to_user(urange, &range, sizeof(range)))
 		return -EFAULT;
 	return 0;


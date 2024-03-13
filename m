Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85861B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295549; cv=none; b=OQvRjJ2mtdTjGOr+46Dt9Mbp3k5c6Q7ixsbF2F0JHgVRTI4HoWRDq6CdAtkSwmwbHbvwM5ldcPaPhrhyt1aW0w+hf0Vq2LAYY0EuGjsHTHVlHuVWqyZsQFTX2YmuYctw4IxNFCSw+tdIzj/OZO+SIp6FsekQETg4ovMZ2NKoV9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295549; c=relaxed/simple;
	bh=ln/bdOJCNmdC30DriNw+erDI9OxRke2HdFo6oKAbP74=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AcjWiWbl9nAkZP4FsxQCIT6NhVfKXolNXJWVHTsr7i0GPhpayvOvlW7ivh1meGXrUUFbfaIIN2JP+KNqGBQI7uIkiu8Zak1JiM/xCFtXy9Rusphrz30ekR7+6itEcOGzIXComyOdc57dNPALtUOnGILSxg4okI2TZyOYZLyPDRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNPfvpuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNPfvpuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFDCC433C7;
	Wed, 13 Mar 2024 02:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295549;
	bh=ln/bdOJCNmdC30DriNw+erDI9OxRke2HdFo6oKAbP74=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CNPfvpuWYHo2hbBnCyfNYcrtV+KEfw6psqvSavJOFqDHtS8nOT7UAxFwWigZAYCJP
	 5Vkb3j74G4agpevC4OY4WKqJCeBAthfAWWGea0EHApTpeorPz2lMxXqqFasfP08VwZ
	 reBUx7R3GTSpHeZR9oqqI/rXKqDEvlrCgfTRBTAuzt4G9aUf//7Khu8k/F97igxlG6
	 BSRBGDblbsG13RAFoiWbD9R2pXe9bre4dGFPdLdp6B8Njwfuutcl8D/f13ic7XvUF1
	 n+ltzBahaSq5V0lzv7JLxV9xgGBAX6u8Jbyv7wxgjrvy/hjgIc+gd0uSo4gGLUpr9q
	 03HFcUlvf3GCg==
Date: Tue, 12 Mar 2024 19:05:48 -0700
Subject: [PATCH 49/67] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431900.2061787.12869819211714775705.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 676544c27e710aee7f8357f57abd348d98b1ccd4

Add a return value to xfs_bmap_adjacent to indicate if it did change
ap->blkno or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h |    2 +-
 libxfs/xfs_bmap.c    |   19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 28ee192509c7..705b66bed13f 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -565,7 +565,7 @@ int xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
 			   struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
 			   int rt, int eof, int delay, int convert,
 			   xfs_fileoff_t *offp, xfs_extlen_t *lenp);
-void xfs_bmap_adjacent(struct xfs_bmalloca *ap);
+bool xfs_bmap_adjacent(struct xfs_bmalloca *ap);
 int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 			 int whichfork, struct xfs_bmbt_irec *rec,
 			 int *is_empty);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4f6bd8dff47e..b977032d8244 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3038,7 +3038,8 @@ xfs_bmap_extsize_align(
 
 #define XFS_ALLOC_GAP_UNITS	4
 
-void
+/* returns true if ap->blkno was modified */
+bool
 xfs_bmap_adjacent(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
@@ -3073,13 +3074,14 @@ xfs_bmap_adjacent(
 		if (adjust &&
 		    ISVALID(ap->blkno + adjust, ap->prev.br_startblock))
 			ap->blkno += adjust;
+		return true;
 	}
 	/*
 	 * If not at eof, then compare the two neighbor blocks.
 	 * Figure out whether either one gives us a good starting point,
 	 * and pick the better one.
 	 */
-	else if (!ap->eof) {
+	if (!ap->eof) {
 		xfs_fsblock_t	gotbno;		/* right side block number */
 		xfs_fsblock_t	gotdiff=0;	/* right side difference */
 		xfs_fsblock_t	prevbno;	/* left side block number */
@@ -3159,14 +3161,21 @@ xfs_bmap_adjacent(
 		 * If both valid, pick the better one, else the only good
 		 * one, else ap->blkno is already set (to 0 or the inode block).
 		 */
-		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK)
+		if (prevbno != NULLFSBLOCK && gotbno != NULLFSBLOCK) {
 			ap->blkno = prevdiff <= gotdiff ? prevbno : gotbno;
-		else if (prevbno != NULLFSBLOCK)
+			return true;
+		}
+		if (prevbno != NULLFSBLOCK) {
 			ap->blkno = prevbno;
-		else if (gotbno != NULLFSBLOCK)
+			return true;
+		}
+		if (gotbno != NULLFSBLOCK) {
 			ap->blkno = gotbno;
+			return true;
+		}
 	}
 #undef ISVALID
+	return false;
 }
 
 int


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81D312882F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422937; cv=none; b=YV16LNXi0tcwkiZDyFHtzRE3VZRVZ8rWy2wIEZ3j2/CJS9S619doeI29FAjzCaen15wdFvVQoXBAVhXICjTPZaDRyQkfJ5YqO3jeosEFvNSVSGMNcbfy6AylqdwGAWMi8HHY13Eujp6d6owQzdn7gWJ5oMf18f99IiPREDzVGQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422937; c=relaxed/simple;
	bh=5jwjkf1jFJ68XlkJNFR7p59L+RL4lxX3yavmKNphXC4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NgkTndfVoOu60ANFdxLqFPFErPoorllYMLpFeeiOiwlG5qq6qAZpIuzUfGmBo8zVclA5M+nRENpHVlBQtFI/ZqQ2UvXK6gwy/wEOBRdX6cGpmTPmu9QaRlFKyDxgw9C6X+ZzYQ+6i3UrmzztLU8Sr7vzrNphhNZdn6+p+lmSdHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szLPZYWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szLPZYWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E43C433C7;
	Tue, 26 Mar 2024 03:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422937;
	bh=5jwjkf1jFJ68XlkJNFR7p59L+RL4lxX3yavmKNphXC4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=szLPZYWmCF2GDIf5OZ5m4iOwfJY9anrATCRe378H+GKoT4GXziLNRFioGspQqVxzu
	 nXEIiTmYAwO+gK9vpZjUmubayS66VhQrWiSCBZJKYHsVC9cO5n6PU+Qd+LMzVUGXLO
	 tQEesj/4VeIZBMqQSYcB3nZAxzgWSjVJyTiJDb4+h9Hyiv/M31jYfsIlhvXRWwRW/0
	 AJ5p22TO6jt2W3Yq5VOOU5zJnSUsnGyrSkbpAs1QHhwN1/6OZQ6PzrBHEeLbnFjLEc
	 qPDySWxHXA+gbk22RepN2PChkfLgwP4noEbaQtvv39CPzqu+8DrWhLUBTbdg6Pgaae
	 3+/gnVKUyEZIQ==
Date: Mon, 25 Mar 2024 20:15:37 -0700
Subject: [PATCH 49/67] xfs: indicate if xfs_bmap_adjacent changed ap->blkno
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127663.2212320.3748659958428283048.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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


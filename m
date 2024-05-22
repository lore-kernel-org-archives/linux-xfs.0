Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C434C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347316; cv=none; b=QszzAZMpTFTZk04tNt9LTgvWwE26VhUY7YAv+f8qNvNG/zGvayClbXjgZl73ZXRz9DHCxkGu9CLDj0+OC13s2pXbRgk94UZdGu6gyvP0ftK1k4Hujw2VRnYNVl+YF8ebcy95gZbZphGYXY4eur7Sg+1LkqSbYgENyrRU/e2SCRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347316; c=relaxed/simple;
	bh=NYdlUvURW9xgTcS2D0l87D1V3zx9yLmgz1ZXzvbzrbg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6nRHrEdyq5BkhhdAn8KHtJrbB+nohs7GUD929qksBQWfuFKRAb72GwOcJZnv+Q0Qnb1uhwEKZZ95WZjTOBs++rt8s5AppxF/jiv1Cu5tZub/vHmlgUtEnEbloxZFxmakTcjBMq0wRO3bKrRWKnSKx6QU9baF9mexqW1/PTdWHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOm/foTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOm/foTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382E8C2BD11;
	Wed, 22 May 2024 03:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347316;
	bh=NYdlUvURW9xgTcS2D0l87D1V3zx9yLmgz1ZXzvbzrbg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lOm/foTI+zNRJ01Sv8PgtQVvUUFRE7FXiw3qXteoSqbM/CDUMi3La0X8c1rMbSLt3
	 Q9tDFn//GrJ1ptVqmbG6m5HLB3/y42QJqGUsBnfhdM1Q7RploYhNTOibODdC1GEZeE
	 t9JZHy9CHZslarj4bsudoDYPazkbgIHZF5gqdQXxGb/mG8zskut7Whfsg6aWw7Lvtr
	 WU9Knex8/NPsGvCjvpuYD0h7tEhamE5oupYcVzE0GQcsnSu/kCMabO/U4vWWLg8ppw
	 WjzBFj1lpp0elsN554k7Ipv+1qp3zTKIYDQ+PmkVyAUO3npKwK3V/pkqwP+S/jlhKh
	 CigmEZHkGwxPw==
Date: Tue, 21 May 2024 20:08:35 -0700
Subject: [PATCH 076/111] xfs: simplify xfs_btree_check_lblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532838.2478931.11066528602248746914.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8b8ada973cacff338a0e817a97dd0afa301798c0

Stop using xfs_btree_check_lptr in xfs_btree_check_lblock_siblings,
as it only duplicates the xfs_verify_fsbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4ba36ecbb..55775ddf0 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -56,8 +56,6 @@ xfs_btree_magic(
 static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_fsblock_t		fsb,
 	__be64			dsibling)
 {
@@ -69,14 +67,8 @@ xfs_btree_check_lblock_siblings(
 	sibling = be64_to_cpu(dsibling);
 	if (sibling == fsb)
 		return __this_address;
-	if (level >= 0) {
-		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
-			return __this_address;
-	} else {
-		if (!xfs_verify_fsbno(mp, sibling))
-			return __this_address;
-	}
-
+	if (!xfs_verify_fsbno(mp, sibling))
+		return __this_address;
 	return NULL;
 }
 
@@ -136,10 +128,9 @@ __xfs_btree_check_lblock(
 	if (bp)
 		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
-	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
-			block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+		fa = xfs_btree_check_lblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }
@@ -4648,10 +4639,9 @@ xfs_btree_lblock_verify(
 
 	/* sibling pointer verification */
 	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
-			block->bb_u.l.bb_leftsib);
+	fa = xfs_btree_check_lblock_siblings(mp, fsb, block->bb_u.l.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+		fa = xfs_btree_check_lblock_siblings(mp, fsb,
 				block->bb_u.l.bb_rightsib);
 	return fa;
 }


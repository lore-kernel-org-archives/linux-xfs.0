Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419AD85278
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817194; cv=none; b=uBELApsBsA25KkBGuPx//qFmXWukROW/yw2UkQC2szrLV5HR5JtjyBSL1JIu+TkWt8xQViUNSeMdzJjgtR8zZPOioISssuERQ9LlIXZSJUj/TvjwtTYDbX4rSoWD5/lKt97z6JIS8m130JIMVRI/5lVcslb77PRAEn6hS/CQsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817194; c=relaxed/simple;
	bh=FPNvLkLHD8f17ag1OtDQJyNtb7FV5jHgyhmGV807qLg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fin43xZ8AsFu8gT5AffAcleDR5CP1y8bZ068VhyyXPZqcXYd7qsB70NajVUxjVxZ2lHOnRlHOKq6EgbVyGVSRhk1R8rQEbzQmdN+AT8IHCuhxHUeLdAKjsqDspERSMlnUUOuJrfgqjRK7WA91WrA9gSKcuqqd/IFKBD+VN6UW1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eA3Omxk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eA3Omxk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFD2C433F1;
	Thu,  1 Feb 2024 19:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817193;
	bh=FPNvLkLHD8f17ag1OtDQJyNtb7FV5jHgyhmGV807qLg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eA3Omxk2DuVGDbus/GGOdgCl2JeUJb0hRMq5uh8fn11ouuox1BHlpJiTNhZNqik1p
	 ibaU2hENkRvY9mD7PtaklaYnep+m7h41h1OtsLgbr/DHN2oOKK+ddSGqvCi6NXwAo+
	 SEis5FKu+5amx9cA7dX9DLkwvk6yMHNjmKCOaTxZFr3vcxn7/a50IsHQAkOJLwCSWG
	 RycQ0wSnwNs9LBj0ZQHAUT+7I2SdN2JHpw8KELAtgelPZNdNrjnQ0MC5CCJn63wy1r
	 cuVS4DbZygsYhi0JSWPiacukZym7u+ZaUZjG4jDiTFA2w2T+8AR4R3yHOSqTzd2FmU
	 taJAYydcqAZwA==
Date: Thu, 01 Feb 2024 11:53:13 -0800
Subject: [PATCH 02/10] xfs: simplify xfs_btree_check_lblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335645.1606142.7279699028862867976.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

Stop using xfs_btree_check_lptr in xfs_btree_check_lblock_siblings,
as it only duplicates the xfs_verify_fsbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index cea5500a0ecee..fc877188919e3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -59,8 +59,6 @@ xfs_btree_magic(
 static inline xfs_failaddr_t
 xfs_btree_check_lblock_siblings(
 	struct xfs_mount	*mp,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_fsblock_t		fsb,
 	__be64			dsibling)
 {
@@ -72,14 +70,8 @@ xfs_btree_check_lblock_siblings(
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
 
@@ -139,10 +131,9 @@ __xfs_btree_check_lblock(
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
@@ -4651,10 +4642,9 @@ xfs_btree_lblock_verify(
 
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


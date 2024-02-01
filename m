Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71B485278
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817178; cv=none; b=XZZMkvDqC70hyOaw2XUTsXCQpEY2vav0eGvL0RVMRC27O/UGgiTw46Ez12Dkw4jnTuXOKchJBLs2Ek45iR7OU+b+GLIuG0DHqrgrctMeVOk1ZoSn42dJvxgf+j/i2q+k0yYPIoXYXu6doXmjvQcbGDnq3raXy247svMjcEJy1d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817178; c=relaxed/simple;
	bh=20+X7pM1GNp2jCHszrwwI/VGTkk2uo9qVWr/733Rxtg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0lx6Wkooapo7NqM12XyhNfxyZ6p5D6ePDlfN0EmFIvURT1ffllCOzeUXmgkQfLKFvh0Ca/bXMDhDz12aVovE5Pg7EZZCMZ3RF28aa3w5SUCiRbKHa4BfHALL+6xsB8gafovwFJZ5KfeNWVLROhLUr//FeNNU/k3LW5Yq+vdHTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl11rbg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl11rbg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F540C433F1;
	Thu,  1 Feb 2024 19:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817178;
	bh=20+X7pM1GNp2jCHszrwwI/VGTkk2uo9qVWr/733Rxtg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yl11rbg4THZguprSew6wLQHhC6cW/HAgJYZg7Nt6EuU2tzK2s5CSCIPyaV33+cJqx
	 5nqko/GodSKwUYxHeCAIgqdGXpk/t0GP6ggVhC+iKVt7jZ6VQUgl5Y+BJ5KLWt/xyM
	 mC9jzwYo5a6JHtId1WRc8lc/I93HuUEEwW9DZ6+GYSfbtOaAVjde1+UXCCZIkZ9F/G
	 vzBaKVSyVm1OuypaoLKYSQ+BGV+hH0XqmqT6pOkhjsIkPV2efO83yXD8LmnBKEtTll
	 J3P7pFsgVMnki/3dfUmRLUOMCmj4hvgkvL1PqPaZSuXQ5psMIosEw6MbE0PKUBbx3D
	 8vy/Voduli4tA==
Date: Thu, 01 Feb 2024 11:52:57 -0800
Subject: [PATCH 01/10] xfs: simplify xfs_btree_check_sblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335629.1606142.17707152277668258528.stgit@frogsfrogsfrogs>
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

Stop using xfs_btree_check_sptr in xfs_btree_check_sblock_siblings,
as it only duplicates the xfs_verify_agbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 769be61ad63f3..cea5500a0ecee 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -86,8 +86,6 @@ xfs_btree_check_lblock_siblings(
 static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_perag	*pag,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
 {
@@ -99,13 +97,8 @@ xfs_btree_check_sblock_siblings(
 	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
-	if (level >= 0) {
-		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
-			return __this_address;
-	} else {
-		if (!xfs_verify_agbno(pag, sibling))
-			return __this_address;
-	}
+	if (!xfs_verify_agbno(pag, sibling))
+		return __this_address;
 	return NULL;
 }
 
@@ -212,10 +205,10 @@ __xfs_btree_check_sblock(
 	if (bp)
 		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 
-	fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+		fa = xfs_btree_check_sblock_siblings(pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }
@@ -4713,10 +4706,10 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
+	fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
+		fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }


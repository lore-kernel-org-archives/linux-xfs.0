Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A05A13C677
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441897; cv=none; b=i+QxFfPCnzfVhUwTLj91HNJvhJloK7m1INrCTAADOuiycIiviN0oRfOxYuDiSNQm1leVLw2JZ5L51i9d6Ed6jBASronbMhLWUUGr4RQhkwhEf/B8g8qO8kbXoJrVYc2pWhoi3UCfEh58K0tSpEELsxWVgSWD3m/6F5W5cz3aH6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441897; c=relaxed/simple;
	bh=1bMrgCjUNpuSCWi826yh2h2+UEUdZSPBuorPnRFA49U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HtHkf4z3Zthzt617sBTUeR3rs2FYTcOEnv29IkjFQ2Yv80cUMw5i/ZXTMUkdfF4heJ6BYJfn3cRH+yFBLazxnEWb6mzf5K8dch4NL3XSnbihGKRMZ90hVMuX9It5IjVamrE4dbCkA9s0gHd+Ag5eg5lEH+mZNmJ1fwCRW7xHwp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGxIdt4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGxIdt4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D833DC2BD10;
	Mon,  3 Jun 2024 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441896;
	bh=1bMrgCjUNpuSCWi826yh2h2+UEUdZSPBuorPnRFA49U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cGxIdt4oUMlUCFB8mx6kC1iF0I5A0mVBhOJlL58uaCq0UcjUBHeNsvNUFM8kXBwy7
	 fpHQ9ZyPmHDpOIO8V2wInURmNitwZvVVERbGE6nr+E7BiYLiAZJHulhcQNWocHq5zW
	 uM1Fo1FtbHKbxXxiGArk2eop3v7Lz18wQaGCiM99x5beFewEuGgUCm3UgWVG6mX1PW
	 Kjq7W5x32/B2xQXdbJOB/FNgcnk3tN3+6hY98iXcVK6xrJiWholWN+tVz/m8MaHuSn
	 LReVxVcjtW0Pk9yMJne+QziEdlnbMpXLqD1cYgSW9SgX7nmfyA5UZRKX5HitKhzwLu
	 +mlHdqbUBpvRg==
Date: Mon, 03 Jun 2024 12:11:36 -0700
Subject: [PATCH 075/111] xfs: simplify xfs_btree_check_sblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040501.1443973.3776458988656413137.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bc94bf640e08cf970354036683ec143a7ae974e

Stop using xfs_btree_check_sptr in xfs_btree_check_sblock_siblings,
as it only duplicates the xfs_verify_agbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0b6d8d6f1..4ba36ecbb 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -83,8 +83,6 @@ xfs_btree_check_lblock_siblings(
 static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_perag	*pag,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
 {
@@ -96,13 +94,8 @@ xfs_btree_check_sblock_siblings(
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
 
@@ -209,10 +202,10 @@ __xfs_btree_check_sblock(
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
@@ -4710,10 +4703,10 @@ xfs_btree_sblock_verify(
 
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


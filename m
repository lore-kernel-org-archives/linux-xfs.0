Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E207E8F40
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832005; cv=none; b=JQq2Zqi8FVoahVXOU94zwSHYXqbr96fiJECY0Rkm4bg2eVSkczCp7NI9P6eIGwI692DmCB33ev5S8ZDA+3L3nN86lhR8d58FZmL0WoTYR8IVGdWHcN8oHdChSiAEou0qu4cFHBCrcFE5y1RVn0EjEGTsYudJ4illTN0Jcx0AS/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832005; c=relaxed/simple;
	bh=tNgqCr4eZTE37RAPGozGdRterF7eKOiQ1R3n4TVlGMg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJLjZShGVFqTmW5Nes5WKwganOyCUi/WDRMqV86sjhEwk1+RGgYCbUP8LQN4JP0unaIOb9IBtVi/0lVDF83iGnBLU6LleNXurFWMYZ5t6hc50s1GYw+lfhypO7y5faXacAge0awQ87E2qYNSkpiORjz1LhoTB6bgnvAs0JCYN34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFGWZcSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFGWZcSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80905C4CEC6;
	Wed,  2 Oct 2024 01:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832004;
	bh=tNgqCr4eZTE37RAPGozGdRterF7eKOiQ1R3n4TVlGMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iFGWZcSPGiATbYfQudC1M2Ko2kGIq8t9qvXvEXDW43y0O+telYa/JVjzhFaVck/23
	 sgSHNM1GIVLj7ssh6QuEJ80u+/kL6bI/duf3aGdPoCQz4lcQw6dBUcyuD9pgi2Asrt
	 YB1Z0ELVq5zRPWd8KCGZagGlv3o+tdmn9LqC2OdkLvdCz6K5HNXHXpGXFD1TSUuC9m
	 A4bpzVUci2fx9yg3mY3CHys48ild5doj3U6kUP/nV/eNcwIAkJfnQzH7W6TMIvVB/I
	 5KqIrazLeVNCm+u5TJDt/BRD+VYXpUVxCxhJs0m1V54taYXJK/lMgr6e0mSDbOzzmS
	 WE7tpl9y/Gf4Q==
Date: Tue, 01 Oct 2024 18:20:04 -0700
Subject: [PATCH 47/64] xfs: simplify usage of the rcur local variable in
 xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102490.4036371.3354599645070081989.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 905af72610d90f58f994feff4ead1fc258f5d2b1

Only update rcur when we know the final *pcur value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 1b5004b9c..d60edaa23 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2569,7 +2569,7 @@ xfs_rmap_finish_one(
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	xfs_agblock_t			bno;
 	bool				unwritten;
@@ -2584,7 +2584,6 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
@@ -2606,9 +2605,8 @@ xfs_rmap_finish_one(
 			return -EFSCORRUPTED;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 	}
-	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff);


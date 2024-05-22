Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779DB28371
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347222; cv=none; b=MXu1gHkYxzAO6cYHK9klHWapPNkHr7hzokwVp8PIsx7Fsa9IsjfwhdjbgpqhRe6ROiNIWN1Cxnz1LmxuibebTJwb2t4tYk9j7LbOGlQpS8WGUNDWxls+c8P14Re+sxPOJShWfIzc7KN0eeeiyr/TB+BqwKlKvRiB7O+XBRBOV0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347222; c=relaxed/simple;
	bh=53ZzQqultuGSJbSUAIS7STN03Yjz/7iEXat/n4ltOLk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DttoLQYBJOZaIzu1PilCT+Q0+IUbBRObQj+I06e8LzqXJE4KNsLDPqd1kW7I9I1HxT4ryiBLJCeCL9EOAakHbbHKC1kdLo2/sMkoez7n9fFaSbiOZ1eV5NrOjY8JZPr5mN+1Y1geJJRO1K4oHpaJUJnYVyli8pSjp+S0dy82EyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okXCzn3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okXCzn3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCB8C2BD11;
	Wed, 22 May 2024 03:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347222;
	bh=53ZzQqultuGSJbSUAIS7STN03Yjz/7iEXat/n4ltOLk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=okXCzn3hw1/mJw7NJgOiUMx0up3dB6lmTqX19bK+k/5Urz5sB1XbjhXD2N5SaFHa2
	 YFEc8QzcNqrSPm9g12CydQqscz98MjGXUSxfmNcDjxpyIrL+2zNz7lkFuZKS+0F/DE
	 lnix5vb8qRkFYmUTWnp1qk8tG2s0cjS08tCWy3PPBGrtaMeFYyFPn/VL5KhK9Toh3j
	 X1pPPPSvrX2exR0kTytEvQeWDeUGUwiquTy6zoHRbNZvWf1KQRFRma79PdhRaGChCZ
	 /kDRsBJV+MdHi9VQMNcmUBXMoi3QtaGCRSSaomly3ojcyc2H4timhj9wh45MRvpiVC
	 A4gh/stBeuDVg==
Date: Tue, 21 May 2024 20:07:01 -0700
Subject: [PATCH 070/111] xfs: remove the btnum argument to
 xfs_inobt_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532747.2478931.2434181402166709846.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bfb028a4c00d0a079a625d7867325efb3c37de2

xfs_inobt_count_blocks is only used for the finobt.  Hardcode the btnum
argument and rename the function to match that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc_btree.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index cf59530ea..609f62c65 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -710,10 +710,9 @@ xfs_inobt_max_size(
 }
 
 static int
-xfs_inobt_count_blocks(
+xfs_finobt_count_blocks(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum,
 	xfs_extlen_t		*tree_blocks)
 {
 	struct xfs_buf		*agbp = NULL;
@@ -724,7 +723,7 @@ xfs_inobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
@@ -772,8 +771,7 @@ xfs_finobt_calc_reserves(
 	if (xfs_has_inobtcounts(pag->pag_mount))
 		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
-		error = xfs_inobt_count_blocks(pag, tp, XFS_BTNUM_FINO,
-				&tree_len);
+		error = xfs_finobt_count_blocks(pag, tp, &tree_len);
 	if (error)
 		return error;
 


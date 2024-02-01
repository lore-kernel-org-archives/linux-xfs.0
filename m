Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DD643AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817084; cv=none; b=eHAcjIwTO2TJeH/caiKa6aa0eJ2NaeAQxL/IpdmsIx9X5qvW1TRnMUHkYsGgLTcfYBQPH/29Z4zlrD9T2JVrxKwrwx56YI1ME4MFoQVthVlCbA4LB0/TVkOW1WwFYE8oUzd+XpOfnrzFWF20G92Q85Itw30wjfP9RCoy/0gMTTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817084; c=relaxed/simple;
	bh=iREkTBIy9GKanm7Evf2+XjcjhgQ30Q0+AJs7BW1RgFA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpIF3A2+bV6qVCs8PqnwMG3hZ+AfPd96oGoJVxy/yOEdfdDJFhMFpijuefQaujXv4Jx9IjJkeUnIzveeqdQCV4LMtyEOftMcd2Fy3USQKvqsh5CWZ9kFJe2pvELITOFUWHJj1Zvf0ASiyLHBO2kJhmAhfESrpxi8lMCrWub1Jts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMItkeha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMItkeha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EAAC433F1;
	Thu,  1 Feb 2024 19:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817084;
	bh=iREkTBIy9GKanm7Evf2+XjcjhgQ30Q0+AJs7BW1RgFA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IMItkehapnoQzTLg37drzca7/ypW1uxXLUDJM23CF+KpYmoaamTkL2w9UqhhRvkYT
	 YId8qw+qJ4Xc2SvEbT1V06qCWlKIzL/Nk43wh6+xVJSiMw1kR5BY4XNQLxliz1UZ+y
	 WZTBwyeSGtu/sfFPzEwvulHlKAU5oxrl3TJdLtZRRbZvPZBn/6SDunN5rT0VBKZAoT
	 3pJq3V3UDTeDT5dhm7P45dZj5NF9MZ7UYZ/2nI5FyJjhkqnkLfPX8WNYb+Cv6+AVaT
	 VbOMBh4IkLBu5w9W0tJwtPBRvVvs13GaT4/msJ57EEO5mFnaYSFfFs20QMK5mKj9jT
	 TAcE/RRmNUbNA==
Date: Thu, 01 Feb 2024 11:51:23 -0800
Subject: [PATCH 22/27] xfs: remove the btnum argument to
 xfs_inobt_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335147.1605438.9294364123104075691.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

xfs_inobt_count_blocks is only used for the finobt.  Hardcode the btnum
argument and rename the function to match that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 441c5a7be1e0f..c920aee4a7daf 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -711,10 +711,9 @@ xfs_inobt_max_size(
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
@@ -725,7 +724,7 @@ xfs_inobt_count_blocks(
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(pag, tp, agbp, btnum);
+	cur = xfs_inobt_init_cursor(pag, tp, agbp, XFS_BTNUM_FINO);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
@@ -773,8 +772,7 @@ xfs_finobt_calc_reserves(
 	if (xfs_has_inobtcounts(pag->pag_mount))
 		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
-		error = xfs_inobt_count_blocks(pag, tp, XFS_BTNUM_FINO,
-				&tree_len);
+		error = xfs_finobt_count_blocks(pag, tp, &tree_len);
 	if (error)
 		return error;
 


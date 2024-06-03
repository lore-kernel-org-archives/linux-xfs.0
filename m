Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF39A13B28D
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441818; cv=none; b=k2AAXR2xZt5eP7voNb+kS+9aCfNnUox1WjDvO+J2MX9Q7XztK0FvY0k6ySNydZTgzwcb+U6pmGXWJAtpsU0IxAk09u8U+tzAsql4R/NwLrEJ27bxH1yBmEO/0Xq7vbSlaVUu8ibfjPtYpVo8Q/6PQf7OFtX5uguu951UZ//SWoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441818; c=relaxed/simple;
	bh=/m+iIMwP5yI88UzYhuprBeEkVpzZXi2LUmcyauuDdrk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TBGroZgIFvZ9v3GUCiclcHfT2jny9FsGZv/SJwtij9bDnImxgZOV8lI/lRa7VqNBGyHyUJPSDxER2pS1IQ5fgqDT5FGQXqt3fOQqFu1vKUatM5r1iYRX4hv3KcHly3SrsiYJhejsV6julR/uSe1BW4qJq+J7bqsltS4c6jgV054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKgoELA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKgoELA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F660C2BD10;
	Mon,  3 Jun 2024 19:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441818;
	bh=/m+iIMwP5yI88UzYhuprBeEkVpzZXi2LUmcyauuDdrk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BKgoELA9+19XxA7YG0k/SMcl9IAk5zkMCxgAF4Bcgk8I0LznCF/Hl84s1jfjWjo9R
	 Ifj2lnk5vgiYaJ4LYyHLuzI1HMaFvPBX5taAqm+76JHjpmWydzKorhuz4ktWU8xZp1
	 6mvn/cJeE43TFIWCBv55nt4RlkAzZheOpfU+KjZWuAaAvbMIbyi54OVATbc4Y1G47C
	 ScnR2WZbQ1a5ZeFahWdh/2JT+IpPr5FeTzY9+R7CGoou3C2QmzJ+irJcGNI/jxvOvQ
	 GuffON6spz8FCxmq8KHduQNfeKAMG9I6y0gCnkp/UuTa0va8O+AwbUbKxUvUjMb3lu
	 hrBJbfE4cI2sg==
Date: Mon, 03 Jun 2024 12:10:18 -0700
Subject: [PATCH 070/111] xfs: remove the btnum argument to
 xfs_inobt_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040425.1443973.7596464567743410849.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bfb028a4c00d0a079a625d7867325efb3c37de2

xfs_inobt_count_blocks is only used for the finobt.  Hardcode the btnum
argument and rename the function to match that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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
 


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F6E41760
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816756; cv=none; b=DankNhFzqu0pgoUvebd/qeTGn7teysbh5JItuGq/2/cwsJzrPExKBH3dwPN2xnUzP7BDoYmNyW7YQnipDGQTq7avgfFJyx/05djxH32eMPbCbjoWeEGc9WD3qfYaInLYXo9mPeAzrPLFL0uEbX1qputbccjEP5exEC8watlbAxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816756; c=relaxed/simple;
	bh=sZg4qCQgfftDorZ+2R9CmKci4Wy1waNlUCMaX7M96XI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXE1dZrfziwldz8Svc/9VeoKVCC5kgsya1apz5gpzd1gHJr5iZBYLApMoQLw9bSop3fI+9hSkASAv6ad8yddKslOgFapUHmp85nt37MN66Err+KO8ynLeWsm+2nzhXfnXzx4x4dii+35eyL8zjunzN0qbRNMCVMJ0SaBEzwVBKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJQ2wros; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJQ2wros"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F35C433F1;
	Thu,  1 Feb 2024 19:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816756;
	bh=sZg4qCQgfftDorZ+2R9CmKci4Wy1waNlUCMaX7M96XI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kJQ2wrosDKd7jHyuSNpkAqHKqO9RbTCBijiIf4tqacnZwvIz4AwniBy/vm9KTvvJy
	 VbXErdJTwSlEM4fSl78XBeSoHkWEWtOiQgKRtN6KYnKAe++GFSZn9XdazFqQv4LYP8
	 zId/hxBmCi2wqUXSzDX66y5JjmSznEX8pKwAwrkirM81qbNsMgOs/GndEg9Zfnsjh4
	 5zF3pCAC+tqyPnhVhOXlQ3fzd3WraE0xzl9NGgb1jTzTYFsrA5R5QfrYDcvCFlkx4/
	 /KBeMtJUmIMhxYmjhsTkNYbCr4w+n1J3RwbtPy48Z+88DVD4mCPe5L46D1CLZoFmZX
	 ReabbOXdSj2Aw==
Date: Thu, 01 Feb 2024 11:45:55 -0800
Subject: [PATCH 01/27] xfs: move comment about two 2 keys per pointer in the
 rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334802.1605438.24065943896306899.stgit@frogsfrogsfrogs>
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

Move it to the relevant initialization of the ops structure instead
of a place that has nothing to do with the key size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 62efcfaa41730..4fdbd6368a034 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -477,6 +477,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
@@ -509,7 +510,6 @@ xfs_rmapbt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);


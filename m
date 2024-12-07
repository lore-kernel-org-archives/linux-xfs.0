Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4512A8C1;
	Sat,  7 Dec 2024 00:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529817; cv=none; b=VkhIBx8BnQIsXgJgG7gSFpPmJvUFe8RipdyMtGEVVYhRHDOVJcd+t9JmfcQ+Di1RZEuoeYAGEZgcr2Y0nGwIH+Ab6TK5Gq1a6gUE5eC2JFkfDwF8M8F7ViiIU8OosnZ1X8y9PlGgGzJl+f/9K5EQGfWsJ0XHhY3E/SsKL+zk63E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529817; c=relaxed/simple;
	bh=Fy4iqRobx8evseMbf4CjhAQEVkhVopkrBmfUcRgRoOM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUiYG3OitrSVCyak6o5VaM6eHojjsUYRd3EeJcH0qMg0HeDPscQ/iinGzMreAZfirOPM526PQCgHXRhupYHNU9jkGLxG8oLtkYh6cAYmhOGOpJwnD1tmyTdfjFGxcuu059g1c9EFODVKoyXapxegshC60tyVwu2hirrbiFilOns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7PXeLEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7PXeLEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99254C4CED1;
	Sat,  7 Dec 2024 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529817;
	bh=Fy4iqRobx8evseMbf4CjhAQEVkhVopkrBmfUcRgRoOM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s7PXeLEIr5zR1aufhknuoHIJV66pfLzY0pmzD0gFsgQ+6Kdsp5tc17XZl/FSdCLKV
	 hCuvnGBFiIGmQMmqjouZP1jVqIHlvpb4XjUTTpCp1KUjyDvuodL4ql4ri3zDnof7m1
	 DSyPHQxqhlnwx6Rc9ZcoZOMsXIaEjSglFe+6Hay5aC36stK2Ui/VuqHI3hnWMUo74a
	 1pj+X9iL383oQoGL5giCgU8fkBTzhDj/KXEqDiCsd1LzPJ66eFcJjPOWU6A7JYJBsu
	 cilx5LoGJWGF6gZNYuT8beuCpkAhX3h4L9Suvp41G3wOL9Wr6/ksQ4oGrL6tH6ZHHW
	 7FspdgEaWnGEQ==
Date: Fri, 06 Dec 2024 16:03:37 -0800
Subject: [PATCH 1/6] xfs: return a 64-bit block count from
 xfs_btree_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352751213.126106.11484272025980381078.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
References: <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

With the nrext64 feature enabled, it's possible for a data fork to have
2^48 extent mappings.  Even with a 64k fsblock size, that maps out to
a bmbt containing more than 2^32 blocks.  Therefore, this predicate must
return a u64 count to avoid an integer wraparound that will cause scrub
to do the wrong thing.

It's unlikely that any such filesystem currently exists, because the
incore bmbt would consume more than 64GB of kernel memory on its own,
and so far nobody except me has driven a filesystem that far, judging
from the lack of complaints.

Cc: <stable@vger.kernel.org> # v5.19
Fixes: df9ad5cc7a5240 ("xfs: Introduce macros to represent new maximum extent counts for data/attr forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_btree.c        |    4 ++--
 libxfs/xfs_btree.h        |    2 +-
 libxfs/xfs_ialloc_btree.c |    4 +++-
 3 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3d870f3f4a5165..5c293ccf623336 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5142,7 +5142,7 @@ xfs_btree_count_blocks_helper(
 	int			level,
 	void			*data)
 {
-	xfs_extlen_t		*blocks = data;
+	xfs_filblks_t		*blocks = data;
 	(*blocks)++;
 
 	return 0;
@@ -5152,7 +5152,7 @@ xfs_btree_count_blocks_helper(
 int
 xfs_btree_count_blocks(
 	struct xfs_btree_cur	*cur,
-	xfs_extlen_t		*blocks)
+	xfs_filblks_t		*blocks)
 {
 	*blocks = 0;
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 3b739459ebb0f4..c5bff273cae255 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -484,7 +484,7 @@ typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 		xfs_btree_visit_blocks_fn fn, unsigned int flags, void *data);
 
-int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
+int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_filblks_t *blocks);
 
 union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
 		struct xfs_btree_block *block);
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 19fca9fad62b1d..4cccac145dc775 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -743,6 +743,7 @@ xfs_finobt_count_blocks(
 {
 	struct xfs_buf		*agbp = NULL;
 	struct xfs_btree_cur	*cur;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
@@ -750,9 +751,10 @@ xfs_finobt_count_blocks(
 		return error;
 
 	cur = xfs_finobt_init_cursor(pag, tp, agbp);
-	error = xfs_btree_count_blocks(cur, tree_blocks);
+	error = xfs_btree_count_blocks(cur, &blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
+	*tree_blocks = blocks;
 
 	return error;
 }


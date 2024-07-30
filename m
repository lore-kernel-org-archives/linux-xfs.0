Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC85323D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300498; cv=none; b=hyTUQV9HuKZPZoGEDpvg5l8gSFfq7OhynpRMYXkcAoZS84ycloMuPiOySFSPCQZy56JudWA8jFpEQq0Dgik0rU+wlJmCZUUq4p1Tm1W5iqCEk8MLzO3W35MsVTYf3efOuw5E4XHxZliKUhfA1qiX6Uddcg+zcdIVDoHWiRNuaRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300498; c=relaxed/simple;
	bh=T70NHbvucxMmim/PVM6KUfLxZ04QSGW6Nj75mJ4+VME=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phy80mDR2t3XumJD6SWepTPCCKI4bfP5JWJU20vENvxj587DNu8v+re2ldlA+3g7OtrjCHJssYxTJCYWbgDHt96bIzuIF9NVLzeXe1Ic/2kE2BE/Vcumj9LlXkpHPYcER/HrIFpNJSotYy9kp0Jhp1hLAGCVWegCVhmZ9pdL+8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFc/Ba1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFc/Ba1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E042C32786;
	Tue, 30 Jul 2024 00:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300498;
	bh=T70NHbvucxMmim/PVM6KUfLxZ04QSGW6Nj75mJ4+VME=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SFc/Ba1JZfalh5IQpefmyN2SogAK8bmfGTe4BZghcGCUCyCzmlqvT1kEhuqV5i6Y1
	 5A+i/UieNVfUQJFahLp6h8bgJiBFCrElRElUjSt7+2lWPxR6l8b+BD3tFKir5HTNRb
	 cl1zsSAX9lOvJOAKmWW/2akZcWYKwPfGXLsL4+vWXTXLcK3wEuPCsKQAzEiadenn5p
	 cxpYXTspHTHjRA856yAiTd+3X0rYan4J1JurmcG/omHvlkuQOGyqBzLQKZyMP0Vx2K
	 5Q2NzZVjW4RI0KIymPGdcX/VhG7zNFbwP1yhrm7VK331MpCBCNpzGTk9egxx10OQpx
	 DKXezr5OE8eTw==
Date: Mon, 29 Jul 2024 17:48:17 -0700
Subject: [PATCH 094/115] xfs: fix error returns from xfs_bmapi_write
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, =?utf-8?b?5YiY6YCa?= <lyutoon@gmail.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229843789.1338752.2337505729207039424.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6773da870ab89123d1b513da63ed59e32a29cb77

xfs_bmapi_write can return 0 without actually returning a mapping in
mval in two different cases:

1) when there is absolutely no space available to do an allocation
2) when converting delalloc space, and the allocation is so small
that it only covers parts of the delalloc extent before the
range requested by the caller

Callers at best can handle one of these cases, but in many cases can't
cope with either one.  Switch xfs_bmapi_write to always return a
mapping or return an error code instead.  For case 1) above ENOSPC is
the obvious choice which is very much what the callers expect anyway.
For case 2) there is no really good error code, so pick a funky one
from the SysV streams portfolio.

This fixes the reproducer here:

https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com0/

which uses reserved blocks to create file systems that are gravely
out of space and thus cause at least xfs_file_alloc_space to hang
and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.

Note that this patch does not actually make any caller but
xfs_alloc_file_space deal intelligently with case 2) above.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: 刘通 <lyutoon@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr_remote.c |    1 -
 libxfs/xfs_bmap.c        |   46 +++++++++++++++++++++++++++++++++++++---------
 libxfs/xfs_da_btree.c    |   20 +++++---------------
 3 files changed, 42 insertions(+), 25 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index eb15b272b..282cf2cb9 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -624,7 +624,6 @@ xfs_attr_rmtval_set_blk(
 	if (error)
 		return error;
 
-	ASSERT(nmap == 1);
 	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
 	       (map->br_startblock != HOLESTARTBLOCK));
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9fce05e1f..84760c889 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4211,8 +4211,10 @@ xfs_bmapi_allocate(
 	} else {
 		error = xfs_bmap_alloc_userdata(bma);
 	}
-	if (error || bma->blkno == NULLFSBLOCK)
+	if (error)
 		return error;
+	if (bma->blkno == NULLFSBLOCK)
+		return -ENOSPC;
 
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
@@ -4391,6 +4393,15 @@ xfs_bmapi_finish(
  * extent state if necessary.  Details behaviour is controlled by the flags
  * parameter.  Only allocates blocks from a single allocation group, to avoid
  * locking problems.
+ *
+ * Returns 0 on success and places the extent mappings in mval.  nmaps is used
+ * as an input/output parameter where the caller specifies the maximum number
+ * of mappings that may be returned and xfs_bmapi_write passes back the number
+ * of mappings (including existing mappings) it found.
+ *
+ * Returns a negative error code on failure, including -ENOSPC when it could not
+ * allocate any blocks and -ENOSR when it did allocate blocks to convert a
+ * delalloc range, but those blocks were before the passed in range.
  */
 int
 xfs_bmapi_write(
@@ -4519,10 +4530,16 @@ xfs_bmapi_write(
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
-			if (error)
+			if (error) {
+				/*
+				 * If we already allocated space in a previous
+				 * iteration return what we go so far when
+				 * running out of space.
+				 */
+				if (error == -ENOSPC && bma.nallocs)
+					break;
 				goto error0;
-			if (bma.blkno == NULLFSBLOCK)
-				break;
+			}
 
 			/*
 			 * If this is a CoW allocation, record the data in
@@ -4560,7 +4577,6 @@ xfs_bmapi_write(
 		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
 			eof = true;
 	}
-	*nmap = n;
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -4571,7 +4587,22 @@ xfs_bmapi_write(
 	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
-		orig_nmap, *nmap);
+		orig_nmap, n);
+
+	/*
+	 * When converting delayed allocations, xfs_bmapi_allocate ignores
+	 * the passed in bno and always converts from the start of the found
+	 * delalloc extent.
+	 *
+	 * To avoid a successful return with *nmap set to 0, return the magic
+	 * -ENOSR error code for this particular case so that the caller can
+	 * handle it.
+	 */
+	if (!n) {
+		ASSERT(bma.nallocs >= *nmap);
+		return -ENOSR;
+	}
+	*nmap = n;
 	return 0;
 error0:
 	xfs_bmapi_finish(&bma, whichfork, error);
@@ -4679,9 +4710,6 @@ xfs_bmapi_convert_one_delalloc(
 	if (error)
 		goto out_finish;
 
-	error = -ENOSPC;
-	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
-		goto out_finish;
 	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
 		xfs_bmap_mark_sick(ip, whichfork);
 		error = -EFSCORRUPTED;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 3c0dc26b7..820e85752 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2293,8 +2293,8 @@ xfs_da_grow_inode_int(
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
 	xfs_rfsblock_t		nblks = dp->i_nblocks;
-	struct xfs_bmbt_irec	map, *mapp;
-	int			nmap, error, got, i, mapi;
+	struct xfs_bmbt_irec	map, *mapp = &map;
+	int			nmap, error, got, i, mapi = 1;
 
 	/*
 	 * Find a spot in the file space to put the new block.
@@ -2310,14 +2310,7 @@ xfs_da_grow_inode_int(
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->total, &map, &nmap);
-	if (error)
-		return error;
-
-	ASSERT(nmap <= 1);
-	if (nmap == 1) {
-		mapp = &map;
-		mapi = 1;
-	} else if (nmap == 0 && count > 1) {
+	if (error == -ENOSPC && count > 1) {
 		xfs_fileoff_t		b;
 		int			c;
 
@@ -2335,16 +2328,13 @@ xfs_da_grow_inode_int(
 					args->total, &mapp[mapi], &nmap);
 			if (error)
 				goto out_free_map;
-			if (nmap < 1)
-				break;
 			mapi += nmap;
 			b = mapp[mapi - 1].br_startoff +
 			    mapp[mapi - 1].br_blockcount;
 		}
-	} else {
-		mapi = 0;
-		mapp = NULL;
 	}
+	if (error)
+		goto out_free_map;
 
 	/*
 	 * Count the blocks we got, make sure it matches the total.


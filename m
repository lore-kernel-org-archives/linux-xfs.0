Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6EA79E1
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831287; cv=none; b=ipAd5JQaUcI4x85kODXdWWuMvvZOp4soAlXwxMw/72j23Jvm8c6Uj+RUNZNUvk6jIC75DTVnLcUyvSVKtq/JVkN1ZLHcUu0kppocKFWT+TBOUV1hVlJsOl0CQiwj4F06+JJtIFBzk36KuSg33ap1x0nF7m2sd5ncSWTD7Rbubcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831287; c=relaxed/simple;
	bh=3zxpttKskTlaaqtwY9MUwBXtKDLoqtI++bXM1Ho9jh0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rUcwSnuzcQejTClTMnpzIiEdJ9zX+a9/0+XLg/G8EVBLUq1N+o+KP4YokALpDAx+gJpE7k4ICpF8tT8+ytPyAS5/7Iic/MsBp6yJIITF8cG8CPP2tREtcJmQj9sXIsZHWNGk32z1AOAvbyp9TG6wu6iYD847vJXzCqm/7xVv/iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fe4V6qql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fe4V6qql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0ADC4CEC6;
	Wed,  2 Oct 2024 01:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831287;
	bh=3zxpttKskTlaaqtwY9MUwBXtKDLoqtI++bXM1Ho9jh0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fe4V6qql4hCj7IQVwMG1TLZy4JPcRQIY3SLMd6RC892aYLVG63Im9v6FNe86B49Tv
	 AQd4gj81imKOVvYeuR25AvmzL+g3zcQG2TrLmMGcTYt4kEgOmm6HmnJpBQQgH7qZlC
	 L7kNlEWAWJqaeTMq0zGGc4pbwhBQJTzQ7exOix+RkJmz1XuyJMTWNidj0UbH9L/Rk4
	 4QL0GFa7N/Dj89Tf7bMo4PTGqyCaaUfITV/aFyQ8mochriImYbxLB4j46kNLu5fy3u
	 cunWx1dHW32EOcU3K66kYPVxa2o0UcLsZ/8NlUEOFPLcb5twzVXDaQVQbqYFSZvb1b
	 8Q50aTe09sH2A==
Date: Tue, 01 Oct 2024 18:08:05 -0700
Subject: [PATCH 01/64] xfs: avoid redundant AGFL buffer invalidation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
 Dave Chinner <dchinner@redhat.com>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172783101795.4036371.15102625450249242753.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: d40c2865bdbbbba6418436b0a877daebe1d7c63e

Currently AGFL blocks can be filled from the following three sources:
- allocbt free blocks, as in xfs_allocbt_free_block();
- rmapbt free blocks, as in xfs_rmapbt_free_block();
- refilled from freespace btrees, as in xfs_alloc_fix_freelist().

Originally, allocbt free blocks would be marked as stale only when they
put back in the general free space pool as Dave mentioned on IRC, "we
don't stale AGF metadata btree blocks when they are returned to the
AGFL .. but once they get put back in the general free space pool, we
have to make sure the buffers are marked stale as the next user of
those blocks might be user data...."

However, after commit ca250b1b3d71 ("xfs: invalidate allocbt blocks
moved to the free list") and commit edfd9dd54921 ("xfs: move buffer
invalidation to xfs_btree_free_block"), even allocbt / bmapbt free
blocks will be invalidated immediately since they may fail to pass
V5 format validation on writeback even writeback to free space would be
safe.

IOWs, IMHO currently there is actually no difference of free blocks
between AGFL freespace pool and the general free space pool.  So let's
avoid extra redundant AGFL buffer invalidation, since otherwise we're
currently facing unnecessary xfs_log_force() due to xfs_trans_binval()
again on buffers already marked as stale before as below:

[  333.507469] Call Trace:
[  333.507862]  xfs_buf_find+0x371/0x6a0       <- xfs_buf_lock
[  333.508451]  xfs_buf_get_map+0x3f/0x230
[  333.509062]  xfs_trans_get_buf_map+0x11a/0x280
[  333.509751]  xfs_free_agfl_block+0xa1/0xd0
[  333.510403]  xfs_agfl_free_finish_item+0x16e/0x1d0
[  333.511157]  xfs_defer_finish_noroll+0x1ef/0x5c0
[  333.511871]  xfs_defer_finish+0xc/0xa0
[  333.512471]  xfs_itruncate_extents_flags+0x18a/0x5e0
[  333.513253]  xfs_inactive_truncate+0xb8/0x130
[  333.513930]  xfs_inactive+0x223/0x270

xfs_log_force() will take tens of milliseconds with AGF buffer locked.
It becomes an unnecessary long latency especially on our PMEM devices
with FSDAX enabled and fsops like xfs_reflink_find_shared() at the same
time are stuck due to the same AGF lock.  Removing the double
invalidation on the AGFL blocks does not make this issue go away, but
this patch fixes for our workloads in reality and it should also work
by the code analysis.

Note that I'm not sure I need to remove another redundant one in
xfs_alloc_ag_vextent_small() since it's unrelated to our workloads.
Also fstests are passed with this patch.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/defer_item.c |    4 ++--
 libxfs/xfs_alloc.c  |   28 +---------------------------
 libxfs/xfs_alloc.h  |    6 ++++--
 3 files changed, 7 insertions(+), 31 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 8cdf57eac..77a368e6f 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -189,8 +189,8 @@ xfs_agfl_free_finish_item(
 
 	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
-		error = xfs_free_agfl_block(tp, xefi->xefi_pag->pag_agno,
-				agbno, agbp, &oinfo);
+		error = xfs_free_ag_extent(tp, agbp, xefi->xefi_pag->pag_agno,
+				agbno, 1, &oinfo, XFS_AG_RESV_AGFL);
 
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 45feff034..ab547d80c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1928,7 +1928,7 @@ xfs_alloc_ag_vextent_size(
 /*
  * Free the extent starting at agno/bno for length.
  */
-STATIC int
+int
 xfs_free_ag_extent(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
@@ -2418,32 +2418,6 @@ xfs_alloc_space_available(
 	return true;
 }
 
-int
-xfs_free_agfl_block(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		agbno,
-	struct xfs_buf		*agbp,
-	struct xfs_owner_info	*oinfo)
-{
-	int			error;
-	struct xfs_buf		*bp;
-
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
-				   XFS_AG_RESV_AGFL);
-	if (error)
-		return error;
-
-	error = xfs_trans_get_buf(tp, tp->t_mountp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(tp->t_mountp, agno, agbno),
-			tp->t_mountp->m_bsize, 0, &bp);
-	if (error)
-		return error;
-	xfs_trans_binval(tp, bp);
-
-	return 0;
-}
-
 /*
  * Check the agfl fields of the agf for inconsistency or corruption.
  *
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 0b956f8b9..3dc8e44fe 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -80,6 +80,10 @@ int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, struct xfs_buf *agflbp,
 		xfs_agblock_t bno, int btreeblk);
+int xfs_free_ag_extent(struct xfs_trans *tp, struct xfs_buf *agbp,
+		xfs_agnumber_t agno, xfs_agblock_t bno,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+		enum xfs_ag_resv_type type);
 
 /*
  * Compute and fill in value of m_alloc_maxlevels.
@@ -194,8 +198,6 @@ int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agfl(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf **bpp);
-int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
-			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, uint32_t alloc_flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_buf **agbp);


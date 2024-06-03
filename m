Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20378139587
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441162; cv=none; b=dGb0+sTpQB8gKmXtR7/VV6xz2X6G0/BlZYRnNly/jQ5bOHmrZ9SYGksvg0qUtyvAmWC+DtvYbgk02C1pP8z4ugajzk2cdQd8zU/xAxq9mHvhdBv8sYaslZI/2PXJwLQap29zRRgr/SjfhF/dIkjkR6KPe1nAZZea97vBF4BW4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441162; c=relaxed/simple;
	bh=55WBFNjmPJwPbqlt7/zss0iSBpr3S3nx+Z9h3WV6wF0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ItYPZ9sDJjLDTWgdCo6sddyGe56l08AoUAYzGaXxIN3tNks4xhHyWaehxmalRW+w8fjPn/6tDoLPCQ2W9y2ugvbT6hZf6zOJ5ofDO+gNEPB3+GY3d0EvTujMLsve29w1EBIl0YS7DMXSGHqvbCPt3mPmVLEygRkamaCkp0nRdCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzYpckTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzYpckTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31F9C2BD10;
	Mon,  3 Jun 2024 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441161;
	bh=55WBFNjmPJwPbqlt7/zss0iSBpr3S3nx+Z9h3WV6wF0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dzYpckTr1JabOAKZhvgoLKI/xk/gOxMPn7cfIkc76O2frtD+G+JDZFSh+wYzBvk1a
	 Ry1M7484gyfWQTm8oc2MfMhTy4nkx/sRHcHxR+bj6a2shNjMA2PRosG3BSOk4lkXa4
	 jJZnFd4e83RljAE8GyGDa0etk76u/iQfuwy5QXMkkZFy1XXLJM6E867J40+esSchtH
	 CrHiP9WTUHsf2COY7ZkxHIOmd35nj1XNp1mopPPS4RkQZGcnxygqUBCzRcBl4HYezf
	 A8+0n3cyyLtoI1ajBnadMWuZjlzixPeADVpXSWky3KiEl6UQmgK5yeAZpTzdUCMxFI
	 qUvOfIsJIVehQ==
Date: Mon, 03 Jun 2024 11:59:21 -0700
Subject: [PATCH 028/111] xfs: consolidate btree block freeing tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039791.1443973.8501735335441966759.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 78067b92b9096a70ca731a6cde1c286582ff03d7

Don't waste memory on extra per-btree block freeing tracepoints when we
can do it from the generic btree code.

With this patch applied, two tracepoints are collapsed into one
tracepoint, with the following effects on objdump -hx xfs.ko output:

Before:

10 __tracepoints_ptrs 00000b3c  0000000000000000  0000000000000000  00140eb0  2**2
14 __tracepoints_strings 00005453  0000000000000000  0000000000000000  00168540  2**5
29 __tracepoints 00010d90  0000000000000000  0000000000000000  0023f5e0  2**5

After:

10 __tracepoints_ptrs 00000b38  0000000000000000  0000000000000000  001412f0  2**2
14 __tracepoints_strings 00005433  0000000000000000  0000000000000000  001689a0  2**5
29 __tracepoints 00010d30  0000000000000000  0000000000000000  0023fe00  2**5

Column 3 is the section size in bytes; removing these two tracepoints
reduces the size of the ELF segments by 132 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/xfs_trace.h         |    3 +--
 libxfs/xfs_btree.c          |    2 ++
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index f172b61d6..98819653b 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -68,6 +68,7 @@
 #define trace_xfs_btree_commit_ifakeroot(a)	((void) 0)
 #define trace_xfs_btree_bload_level_geometry(a,b,c,d,e,f,g) ((void) 0)
 #define trace_xfs_btree_bload_block(a,b,c,d,e,f) ((void) 0)
+#define trace_xfs_btree_free_block(...)		((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -256,7 +257,6 @@
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
-#define trace_xfs_rmapbt_free_block(...)	((void) 0)
 #define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
 
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
@@ -276,7 +276,6 @@
 #define trace_xfs_refcount_insert_error(...)	((void) 0)
 #define trace_xfs_refcount_delete(...)		((void) 0)
 #define trace_xfs_refcount_delete_error(...)	((void) 0)
-#define trace_xfs_refcountbt_free_block(...)	((void) 0)
 #define trace_xfs_refcountbt_alloc_block(...)	((void) 0)
 #define trace_xfs_refcount_rec_order_error(...)	((void) 0)
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index b9af447ab..fb36a3b69 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -411,6 +411,8 @@ xfs_btree_free_block(
 {
 	int			error;
 
+	trace_xfs_btree_free_block(cur, bp);
+
 	error = cur->bc_ops->free_block(cur, bp);
 	if (!error) {
 		xfs_trans_binval(cur->bc_tp, bp);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index ac1c3ab86..67551df02 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -106,8 +106,6 @@ xfs_refcountbt_free_block(
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index d6e2fc0a3..7966a3e6a 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -123,8 +123,6 @@ xfs_rmapbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
-			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 	error = xfs_alloc_put_freelist(pag, cur->bc_tp, agbp, NULL, bno, 1);


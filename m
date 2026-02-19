Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D30724729A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544798; cv=none; b=RtG0585g97w4IkGUQEYVD1cZo1DwgEvEPCeYjxpu2dM1W2aGX9pbI30jZTmNvmE09/yH3SpjL5p8/bAaxPWS2q49GA0MrkmCjhHoHLmUMcGUunRL07fXic05YtTFFTCm2b3H4NbBhfikH8QdeAFFxH3T+w9dzxJ0JjJRPf/uVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544798; c=relaxed/simple;
	bh=zZ1HPrnBaJyjK4lzaZjWUjljApSyn81mdq8o4OiaOdc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lM9vHgcrMasXQzctUmDaM6odGMtrhq58To6ZA5ISGPD3Ot2dN/oW+9dRiuLSccwuZSC9Uv9SVNxFoqNtFMvJGSUKGO8rfsE54GONgutTx8MKu0QVcqfpvmMiIOsvIzyUO4nGBtNUA4EFJ4YF0UDM07Ao+nnR2Sg5vEARq6I7k5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf8a/B5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf8a/B5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47026C4CEF7;
	Thu, 19 Feb 2026 23:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544798;
	bh=zZ1HPrnBaJyjK4lzaZjWUjljApSyn81mdq8o4OiaOdc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yf8a/B5+AXI5KHYYdy0nDpsVPrINHMrz/+PfZDmppax2Lg1EyR/9WgoEGDLWjaImD
	 nXynXkKmW20BJg6cohrjMibQ8aOntzO3CS4jfkoqqnGsd+emMUf0rxN5DmZmAwbwBl
	 LwmrOVX+Br90HPJ/vvlldkWQPRzdmXqqh/eUAW+w9KfNXRUeiuIsDA3bsolD82Ljbj
	 +Ee2Plmxs4ir7GL4Dfy5Oes4JlHs+CWIuO6IahbkYlcG9x4tfXqLWDGGsnVxABeVT8
	 EAiEHZS4hYKz7tM6yXCF9PBl15qRAeKfKoZd3rXiA0CmP6w4x9gD4rEH/owwp8SVrT
	 mC1dYk1ZQx3IA==
Date: Thu, 19 Feb 2026 15:46:37 -0800
Subject: [PATCH 12/12] xfs: set max_agbno to allow sparse alloc of last full
 inode chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: bfoster@redhat.com, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177154456944.1285810.4770680055136852899.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Brian Foster <bfoster@redhat.com>

Source kernel commit: c360004c0160dbe345870f59f24595519008926f

Sparse inode cluster allocation sets min/max agbno values to avoid
allocating an inode cluster that might map to an invalid inode
chunk. For example, we can't have an inode record mapped to agbno 0
or that extends past the end of a runt AG of misaligned size.

The initial calculation of max_agbno is unnecessarily conservative,
however. This has triggered a corner case allocation failure where a
small runt AG (i.e. 2063 blocks) is mostly full save for an extent
to the EOFS boundary: [2050,13]. max_agbno is set to 2048 in this
case, which happens to be the offset of the last possible valid
inode chunk in the AG. In practice, we should be able to allocate
the 4-block cluster at agbno 2052 to map to the parent inode record
at agbno 2048, but the max_agbno value precludes it.

Note that this can result in filesystem shutdown via dirty trans
cancel on stable kernels prior to commit 9eb775968b68 ("xfs: walk
all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags") because
the tail AG selection by the allocator sets t_highest_agno on the
transaction. If the inode allocator spins around and finds an inode
chunk with free inodes in an earlier AG, the subsequent dir name
creation path may still fail to allocate due to the AG restriction
and cancel.

To avoid this problem, update the max_agbno calculation to the agbno
prior to the last chunk aligned agbno in the AG. This is not
necessarily the last valid allocation target for a sparse chunk, but
since inode chunks (i.e. records) are chunk aligned and sparse
allocs are cluster sized/aligned, this allows the sb_spino_align
alignment restriction to take over and round down the max effective
agbno to within the last valid inode chunk in the AG.

Note that even though the allocator improvements in the
aforementioned commit seem to avoid this particular dirty trans
cancel situation, the max_agbno logic improvement still applies as
we should be able to allocate from an AG that has been appropriately
selected. The more important target for this patch however are
older/stable kernels prior to this allocator rework/improvement.

Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ialloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 9f4ec7bbc02531..1da6f07fa030d0 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -843,15 +843,16 @@ xfs_ialloc_ag_alloc(
 		 * invalid inode records, such as records that start at agbno 0
 		 * or extend beyond the AG.
 		 *
-		 * Set min agbno to the first aligned, non-zero agbno and max to
-		 * the last aligned agbno that is at least one full chunk from
-		 * the end of the AG.
+		 * Set min agbno to the first chunk aligned, non-zero agbno and
+		 * max to one less than the last chunk aligned agbno from the
+		 * end of the AG. We subtract 1 from max so that the cluster
+		 * allocation alignment takes over and allows allocation within
+		 * the last full inode chunk in the AG.
 		 */
 		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
 		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
 							pag_agno(pag)),
-					    args.mp->m_sb.sb_inoalignmt) -
-				 igeo->ialloc_blks;
+					    args.mp->m_sb.sb_inoalignmt) - 1;
 
 		error = xfs_alloc_vextent_near_bno(&args,
 				xfs_agbno_to_fsb(pag,


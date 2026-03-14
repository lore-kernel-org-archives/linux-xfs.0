Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA40275870
	for <linux-xfs@vger.kernel.org>; Sat, 14 Mar 2026 00:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773447537; cv=none; b=N6EDD2ps0/3EZuESmVJluJ+NhTtvczYsAkbx/P8y4DCEGJn6mWbKpm/fHcZ1NhFlQQZoLSQDV755qINoArKY/mJPw3LOrTkOM/0zSDGilmh7mRXyNUHq5Vqc+qkg57p6z7Kpd6S9HT9WunU74v+tzKS4PRYC36BtlR9sVLMiinU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773447537; c=relaxed/simple;
	bh=TOpwd+JUUb20849P6XnXLVsbR/b+MXZuNWmwDq4PZo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLl7g+GDANvfvJ+vAsML/QXvfzU4eRkavz7R+EFUNLT0S/I/GFvWh6etdmWAslW2+1Fsnu1LNrmT3I+UKEAdckFBCyYrAU/dgS+XRfne9pN8dbdxF8fXG5KACvaM3Qw0IH6nqJ/TOIigRcQT8Er9cq0DxUtzdYGIraXF/bi5MnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTzif8va; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTzif8va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FCCC19421;
	Sat, 14 Mar 2026 00:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773447536;
	bh=TOpwd+JUUb20849P6XnXLVsbR/b+MXZuNWmwDq4PZo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VTzif8varJ7rSSgBusG/3HhR6KAZavACgdhlTM8FGbm9t4imBw8NQrOG0Seu0+j5m
	 w4NL2bo0WugcNjvGe1t3/ZBl/uSO39CT2NBZ8Tzj6sOaBpDJvOXzK8ZZGcq9y6SvQ7
	 N7X6OWDhLizXL0ocrnvl1yGbG9oSiTvFUPbP3bwB3szTCauqKn9lZispKdJ3mTLrCX
	 x/fXi1+uFbiCXWhlqvfcvOn/H7RrdPUb+NEUWhqhGbTk2q7yGht5/EpLFyICG3mi7X
	 Vm74q4Iiq//q2ahVRwygWqBDJqk1W3WgJK499XO9xxAZeFt4YnbE0A73bAf2zCz5zj
	 GAHHCESKZpkTQ==
Date: Fri, 13 Mar 2026 17:18:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v2 4/4] xfs: close crash window in attr dabtree
 inactivation
Message-ID: <20260314001856.GS1770774@frogsfrogsfrogs>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
 <20260312085800.1213919-5-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312085800.1213919-5-leo.lilong@huawei.com>

On Thu, Mar 12, 2026 at 04:58:00PM +0800, Long Li wrote:
> When inactivating an inode with node-format extended attributes,
> xfs_attr3_node_inactive() invalidates all child leaf/node blocks via
> xfs_trans_binval(), but intentionally does not remove the corresponding
> entries from their parent node blocks.  The implicit assumption is that
> xfs_attr_inactive() will truncate the entire attr fork to zero extents
> afterwards, so log recovery will never reach the root node and follow
> those stale pointers.
> 
> However, if a log shutdown occurs after the leaf/node block cancellations
> commit but before the attr bmap truncation commits, this assumption
> breaks.  Recovery replays the attr bmap intact (the inode still has
> attr fork extents), but suppresses replay of all cancelled leaf/node
> blocks, maybe leaving them as stale data on disk.  On the next mount,
> xlog_recover_process_iunlinks() retries inactivation and attempts to
> read the root node via the attr bmap. If the root node was not replayed,
> reading the unreplayed root block triggers a metadata verification
> failure immediately; if it was replayed, following its child pointers
> to unreplayed child blocks triggers the same failure:
> 
>  XFS (pmem0): Metadata corruption detected at
>  xfs_da3_node_read_verify+0x53/0x220, xfs_da3_node block 0x78
>  XFS (pmem0): Unmount and run xfs_repair
>  XFS (pmem0): First 128 bytes of corrupted metadata buffer:
>  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  XFS (pmem0): metadata I/O error in "xfs_da_read_buf+0x104/0x190" at daddr 0x78 len 8 error 117
> 
> Fix this in two places:
> 
> In xfs_attr3_node_inactive(), after calling xfs_trans_binval() on a
> child block, immediately remove the entry that references it from the
> parent node in the same transaction.  This eliminates the window where
> the parent holds a pointer to a cancelled block.  Once all children are
> removed, the now-empty root node is converted to a leaf block within the
> same transaction. This node-to-leaf conversion is necessary for crash
> safety. If the system shutdown after the empty node is written to the
> log but before the second-phase bmap truncation commits, log recovery
> will attempt to verify the root block on disk. xfs_da3_node_verify()
> does not permit a node block with count == 0; such a block will fail
> verification and trigger a metadata corruption shutdown. on the other
> hand, leaf blocks are allowed to have this transient state.
> 
> In xfs_attr_inactive(), split the attr fork truncation into two explicit
> phases.  First, truncate all extents beyond the root block (the child
> extents whose parent references have already been removed above).
> Second, invalidate the root block and truncate the attr bmap to zero in
> a single transaction.  The two operations in the second phase must be
> atomic: as long as the attr bmap has any non-zero length, recovery can
> follow it to the root block, so the root block invalidation must commit
> together with the bmap-to-zero truncation.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Long Li <leo.lilong@huawei.com>

I think this looks ok, but let me run it through g753 over the weekend
to see if it fixes that problem too.  Thanks for answering my questions
the last time through.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_inactive.c | 93 ++++++++++++++++++++++----------------
>  1 file changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index 92331991f9fd..235f19a68fa2 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -140,7 +140,7 @@ xfs_attr3_node_inactive(
>  	xfs_daddr_t		parent_blkno, child_blkno;
>  	struct xfs_buf		*child_bp;
>  	struct xfs_da3_icnode_hdr ichdr;
> -	int			error, i;
> +	int			error;
>  
>  	/*
>  	 * Since this code is recursive (gasp!) we must protect ourselves.
> @@ -152,7 +152,7 @@ xfs_attr3_node_inactive(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	xfs_da3_node_hdr_from_disk(dp->i_mount, &ichdr, bp->b_addr);
> +	xfs_da3_node_hdr_from_disk(mp, &ichdr, bp->b_addr);
>  	parent_blkno = xfs_buf_daddr(bp);
>  	if (!ichdr.count) {
>  		xfs_trans_brelse(*trans, bp);
> @@ -167,7 +167,7 @@ xfs_attr3_node_inactive(
>  	 * over the leaves removing all of them.  If this is higher up
>  	 * in the tree, recurse downward.
>  	 */
> -	for (i = 0; i < ichdr.count; i++) {
> +	while (ichdr.count > 0) {
>  		/*
>  		 * Read the subsidiary block to see what we have to work with.
>  		 * Don't do this in a transaction.  This is a depth-first
> @@ -218,29 +218,32 @@ xfs_attr3_node_inactive(
>  		xfs_trans_binval(*trans, child_bp);
>  		child_bp = NULL;
>  
> -		/*
> -		 * If we're not done, re-read the parent to get the next
> -		 * child block number.
> -		 */
> -		if (i + 1 < ichdr.count) {
> -			struct xfs_da3_icnode_hdr phdr;
> +		error = xfs_da3_node_read_mapped(*trans, dp,
> +				parent_blkno, &bp, XFS_ATTR_FORK);
> +		if (error)
> +			return error;
>  
> -			error = xfs_da3_node_read_mapped(*trans, dp,
> -					parent_blkno, &bp, XFS_ATTR_FORK);
> +		/*
> +		 * Remove entry from parent node, prevents being indexed to.
> +		 */
> +		xfs_attr3_node_entry_remove(*trans, dp, bp, 0);
> +
> +		xfs_da3_node_hdr_from_disk(mp, &ichdr, bp->b_addr);
> +		bp = NULL;
> +
> +		if (ichdr.count > 0) {
> +			/*
> +			 * If we're not done, get the next child block number.
> +			 */
> +			child_fsb = be32_to_cpu(ichdr.btree[0].before);
> +
> +			/*
> +			 * Atomically commit the whole invalidate stuff.
> +			 */
> +			error = xfs_trans_roll_inode(trans, dp);
>  			if (error)
>  				return error;
> -			xfs_da3_node_hdr_from_disk(dp->i_mount, &phdr,
> -						  bp->b_addr);
> -			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
> -			xfs_trans_brelse(*trans, bp);
> -			bp = NULL;
>  		}
> -		/*
> -		 * Atomically commit the whole invalidate stuff.
> -		 */
> -		error = xfs_trans_roll_inode(trans, dp);
> -		if (error)
> -			return  error;
>  	}
>  
>  	return 0;
> @@ -257,10 +260,8 @@ xfs_attr3_root_inactive(
>  	struct xfs_trans	**trans,
>  	struct xfs_inode	*dp)
>  {
> -	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_da_blkinfo	*info;
>  	struct xfs_buf		*bp;
> -	xfs_daddr_t		blkno;
>  	int			error;
>  
>  	/*
> @@ -272,7 +273,6 @@ xfs_attr3_root_inactive(
>  	error = xfs_da3_node_read(*trans, dp, 0, &bp, XFS_ATTR_FORK);
>  	if (error)
>  		return error;
> -	blkno = xfs_buf_daddr(bp);
>  
>  	/*
>  	 * Invalidate the tree, even if the "tree" is only a single leaf block.
> @@ -283,6 +283,16 @@ xfs_attr3_root_inactive(
>  	case cpu_to_be16(XFS_DA_NODE_MAGIC):
>  	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
>  		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Empty root node block are not allowed, convert it to leaf.
> +		 */
> +		error = xfs_attr3_leaf_init(*trans, dp, 0);
> +		if (error)
> +			return error;
> +		error = xfs_trans_roll_inode(trans, dp);
>  		break;
>  	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
>  	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
> @@ -295,21 +305,6 @@ xfs_attr3_root_inactive(
>  		xfs_trans_brelse(*trans, bp);
>  		break;
>  	}
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Invalidate the incore copy of the root block.
> -	 */
> -	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
> -			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0, &bp);
> -	if (error)
> -		return error;
> -	xfs_trans_binval(*trans, bp);	/* remove from cache */
> -	/*
> -	 * Commit the invalidate and start the next transaction.
> -	 */
> -	error = xfs_trans_roll_inode(trans, dp);
>  
>  	return error;
>  }
> @@ -328,6 +323,7 @@ xfs_attr_inactive(
>  {
>  	struct xfs_trans	*trans;
>  	struct xfs_mount	*mp;
> +	struct xfs_buf          *bp;
>  	int			lock_mode = XFS_ILOCK_SHARED;
>  	int			error = 0;
>  
> @@ -363,10 +359,27 @@ xfs_attr_inactive(
>  	 * removal below.
>  	 */
>  	if (dp->i_af.if_nextents > 0) {
> +		/*
> +		 * Invalidate and truncate all blocks but leave the root block.
> +		 */
>  		error = xfs_attr3_root_inactive(&trans, dp);
>  		if (error)
>  			goto out_cancel;
>  
> +		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK,
> +				XFS_FSB_TO_B(mp, mp->m_attr_geo->fsbcount));
> +		if (error)
> +			goto out_cancel;
> +
> +		/*
> +		 * Invalidate and truncate the root block and ensure that the
> +		 * operation is completed within a single transaction.
> +		 */
> +		error = xfs_da_get_buf(trans, dp, 0, &bp, XFS_ATTR_FORK);
> +		if (error)
> +			goto out_cancel;
> +
> +		xfs_trans_binval(trans, bp);
>  		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
>  		if (error)
>  			goto out_cancel;
> -- 
> 2.39.2
> 
> 

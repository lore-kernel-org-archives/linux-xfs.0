Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC1E3859D7
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 21:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773782776; cv=none; b=qrDqvqvoORhEvHJrmw5x0/28hpmpfZyXvWsHWxjKp2o167UN8Kzh/6YD009wdEhN1vM0+WmNBH0WoYj4dcNgGidpsiS2u9aUIpJi0KMoJsWyE/v47fgGaxliLPnYZN3/gM3zvKxCfdzVciGUUgaYLC0JzASbW9hiSg2OobvSpJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773782776; c=relaxed/simple;
	bh=UQLQ31Vr5OZCj/HAPOMzyQ4wrKxetJ+IqUF2CEfsVCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVHN6NMfJoq67V2moXoMXz4VDC5Wh7UaS5bR5z2BMk0jQ9JqzlvE2h+LTopXN4Nf2mbPEiwFPcttHNOCC5MLnfXcAMg1vBm+ZR0jMq6ukvqJAT8IWbdjz/OXOwfMX0001jwQQVXunqc9PU1Mrc1fgcua/IVNpLnFkoI5UcOj+14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/ysjH9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/ysjH9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9223DC4CEF7;
	Tue, 17 Mar 2026 21:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773782775;
	bh=UQLQ31Vr5OZCj/HAPOMzyQ4wrKxetJ+IqUF2CEfsVCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y/ysjH9YD6sTrl1bVXG3kbrG7X/cyPnzzbr5Bik8xAG1UH5/JSCNSddxEBdAFdTK1
	 hqlmQAGYxzvXnLLTqG0aDtxykUy1vD3yG02jtXm3ck9tpV8KppWNej+7WsdkgAZe5i
	 uz8JD6gtlVZPIhtReaCjp51Z2oYdHzyOWDavsgCXDqGTqIQeB7EELDt48KkkjNPwRq
	 LJSmYy+VZyEazvcmVW8tYKyzGCdbP7X6Q6hXcVsG3YVQvfUsFRoIdHBurkeMsAx3Dv
	 2GG/8aXBWPg3728snTKfz9EydxixVukiVm5wirj/gZ3bXk2xdKlCRKWBzK64lKhRdV
	 BBKHyURm08HkA==
Date: Tue, 17 Mar 2026 14:26:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH v3 4/4] xfs: close crash window in attr dabtree
 inactivation
Message-ID: <20260317212614.GK1770774@frogsfrogsfrogs>
References: <20260317015155.589955-1-leo.lilong@huawei.com>
 <20260317015155.589955-5-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317015155.589955-5-leo.lilong@huawei.com>

On Tue, Mar 17, 2026 at 09:51:55AM +0800, Long Li wrote:
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

Looks good, lemme run that through QA one more time...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_inactive.c | 99 +++++++++++++++++++++++---------------
>  1 file changed, 59 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index 92331991f9fd..a5b69c0fbfd0 100644
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
> @@ -283,10 +283,26 @@ xfs_attr3_root_inactive(
>  	case cpu_to_be16(XFS_DA_NODE_MAGIC):
>  	case cpu_to_be16(XFS_DA3_NODE_MAGIC):
>  		error = xfs_attr3_node_inactive(trans, dp, bp, 1);
> +		/*
> +		 * Empty root node block are not allowed, convert it to leaf.
> +		 */
> +		if (!error)
> +			error = xfs_attr3_leaf_init(*trans, dp, 0);
> +		if (!error)
> +			error = xfs_trans_roll_inode(trans, dp);
>  		break;
>  	case cpu_to_be16(XFS_ATTR_LEAF_MAGIC):
>  	case cpu_to_be16(XFS_ATTR3_LEAF_MAGIC):
>  		error = xfs_attr3_leaf_inactive(trans, dp, bp);
> +		/*
> +		 * Reinit the leaf before truncating extents so that a crash
> +		 * mid-truncation leaves an empty leaf rather than one with
> +		 * entries that may reference freed remote value blocks.
> +		 */
> +		if (!error)
> +			error = xfs_attr3_leaf_init(*trans, dp, 0);
> +		if (!error)
> +			error = xfs_trans_roll_inode(trans, dp);
>  		break;
>  	default:
>  		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
> @@ -295,21 +311,6 @@ xfs_attr3_root_inactive(
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
> @@ -328,6 +329,7 @@ xfs_attr_inactive(
>  {
>  	struct xfs_trans	*trans;
>  	struct xfs_mount	*mp;
> +	struct xfs_buf          *bp;
>  	int			lock_mode = XFS_ILOCK_SHARED;
>  	int			error = 0;
>  
> @@ -363,10 +365,27 @@ xfs_attr_inactive(
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

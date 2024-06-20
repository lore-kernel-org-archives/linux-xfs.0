Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39CF1AD486
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896833; cv=none; b=m2qRNHA0egUsI+44e1tkbmAhPoMAGSS9nHyxWV0qa1dI4rdvuU3dt3b6krKyR5BnTliIK5p6HvyyWdybMPqEsr3o0MMYDM69V29tl365ytt0dPq9tWa7tiRqOOSTNj+tkbq4SnWColCn+DzVD6YZ1HAhb9u3m47nnDFbLCQmCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896833; c=relaxed/simple;
	bh=O7hgUswDn9034GO6Ge3QQK3PF59B4QFgawo93TD+tzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2c+yXUwdu7hRXpZnIs6sKpkcFt4DE6hHkL06XyRp8w9ca+C4EAfbDKzMZt44deMbdDauJxnrMZ41K0xe3/bwGUGim9GYfPw1o+7PWC/eE9SuFiyhnR+0aCQkKE8VtlBU0s7T3UIuhP5g5oQXTMqzCmh9DAONYkS+FSG20e17bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eki/OI7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eki/OI7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7217EC2BD10;
	Thu, 20 Jun 2024 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718896832;
	bh=O7hgUswDn9034GO6Ge3QQK3PF59B4QFgawo93TD+tzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eki/OI7iDZgeT6tN0EHZOsZJYnfNGOlWklsWtQQCZ8s7zik/lgFqBGokAbyzBIoFS
	 D2voEpDRSZKYwTTDcpEHbXcz+EXxm5CjRub/judCC3Qpwe23F8zr/51LZYOkl2jLDc
	 bTeRhtbiuqOy5FlJdiIpER/G5AcmhzpbuCb0iMCHIefdet6rKg1n3Qh961HvNJPAmw
	 r5Lf1tkctNf4kyPhBO57bdxPaUwA8IocXQPTLG+08ki9tXUC3BYPJ65SydbeX8xOo7
	 /aI9f2SOcts1zV8oSJdHgzPf59fKSaf2pjNJ/cAsKKDuy7arJmf31quIQ/9GM3hdaC
	 uljC0vmgZ5m1A==
Date: Thu, 20 Jun 2024 08:20:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix freeing speculative preallocations for
 preallocated files
Message-ID: <20240620152031.GT103034@frogsfrogsfrogs>
References: <20240620042701.482510-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620042701.482510-1-hch@lst.de>

On Thu, Jun 20, 2024 at 06:26:18AM +0200, Christoph Hellwig wrote:
> xfs_can_free_eofblocks returns false for files that have persistent
> preallocations unless the force flag is passed and there are delayed
> blocks.  This means it won't free delalloc reservations for files
> with persistent preallocations unless the force flag is set, and it
> will also free the persistent preallocations if the force flag is
> set and the file happens to have delayed allocations.
> 
> Both of these are bad, so do away with the force flag and always
> free post-EOF delayed allocations only for files with the
> XFS_DIFLAG_PREALLOC flag set.
> 
> While these are old issues, the only started to reliably triggering
> asserts in 6.10-rc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This also fixes the problems that I was seeing, so

Tested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 30 ++++++++++++++++++++++--------
>  fs/xfs/xfs_bmap_util.h |  2 +-
>  fs/xfs/xfs_icache.c    |  2 +-
>  fs/xfs/xfs_inode.c     | 14 ++++----------
>  4 files changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index ac2e77ebb54c73..a4d9fbc21b8343 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -486,13 +486,11 @@ xfs_bmap_punch_delalloc_range(
>  
>  /*
>   * Test whether it is appropriate to check an inode for and free post EOF
> - * blocks. The 'force' parameter determines whether we should also consider
> - * regular files that are marked preallocated or append-only.
> + * blocks.
>   */
>  bool
>  xfs_can_free_eofblocks(
> -	struct xfs_inode	*ip,
> -	bool			force)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_bmbt_irec	imap;
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -526,11 +524,11 @@ xfs_can_free_eofblocks(
>  		return false;
>  
>  	/*
> -	 * Do not free real preallocated or append-only files unless the file
> -	 * has delalloc blocks and we are forced to remove them.
> +	 * Only free real extents for inodes with persistent preallocations or
> +	 * the append-only flag.
>  	 */
>  	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
> -		if (!force || ip->i_delayed_blks == 0)
> +		if (ip->i_delayed_blks == 0)
>  			return false;
>  
>  	/*
> @@ -584,6 +582,22 @@ xfs_free_eofblocks(
>  	/* Wait on dio to ensure i_size has settled. */
>  	inode_dio_wait(VFS_I(ip));
>  
> +	/*
> +	 * For preallocated files only free delayed allocations.
> +	 *
> +	 * Note that this means we also leave speculative preallocations in
> +	 * place for preallocated files.
> +	 */
> +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
> +		if (ip->i_delayed_blks) {
> +			xfs_bmap_punch_delalloc_range(ip,
> +				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
> +				LLONG_MAX);
> +		}
> +		xfs_inode_clear_eofblocks_tag(ip);
> +		return 0;
> +	}
> +
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
>  	if (error) {
>  		ASSERT(xfs_is_shutdown(mp));
> @@ -891,7 +905,7 @@ xfs_prepare_shift(
>  	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
>  	 * into the accessible region of the file.
>  	 */
> -	if (xfs_can_free_eofblocks(ip, true)) {
> +	if (xfs_can_free_eofblocks(ip)) {
>  		error = xfs_free_eofblocks(ip);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
> index 51f84d8ff372fa..eb0895bfb9dae4 100644
> --- a/fs/xfs/xfs_bmap_util.h
> +++ b/fs/xfs/xfs_bmap_util.h
> @@ -63,7 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
>  				xfs_off_t len);
>  
>  /* EOF block manipulation functions */
> -bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
> +bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
>  int	xfs_free_eofblocks(struct xfs_inode *ip);
>  
>  int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0953163a2d8492..9967334ea99f1a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1155,7 +1155,7 @@ xfs_inode_free_eofblocks(
>  	}
>  	*lockflags |= XFS_IOLOCK_EXCL;
>  
> -	if (xfs_can_free_eofblocks(ip, false))
> +	if (xfs_can_free_eofblocks(ip))
>  		return xfs_free_eofblocks(ip);
>  
>  	/* inode could be preallocated or append-only */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 58fb7a5062e1e6..b699fa6ee3b64e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1595,7 +1595,7 @@ xfs_release(
>  	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
>  		return 0;
>  
> -	if (xfs_can_free_eofblocks(ip, false)) {
> +	if (xfs_can_free_eofblocks(ip)) {
>  		/*
>  		 * Check if the inode is being opened, written and closed
>  		 * frequently and we have delayed allocation blocks outstanding
> @@ -1856,15 +1856,13 @@ xfs_inode_needs_inactive(
>  
>  	/*
>  	 * This file isn't being freed, so check if there are post-eof blocks
> -	 * to free.  @force is true because we are evicting an inode from the
> -	 * cache.  Post-eof blocks must be freed, lest we end up with broken
> -	 * free space accounting.
> +	 * to free.
>  	 *
>  	 * Note: don't bother with iolock here since lockdep complains about
>  	 * acquiring it in reclaim context. We have the only reference to the
>  	 * inode at this point anyways.
>  	 */
> -	return xfs_can_free_eofblocks(ip, true);
> +	return xfs_can_free_eofblocks(ip);
>  }
>  
>  /*
> @@ -1947,15 +1945,11 @@ xfs_inactive(
>  
>  	if (VFS_I(ip)->i_nlink != 0) {
>  		/*
> -		 * force is true because we are evicting an inode from the
> -		 * cache. Post-eof blocks must be freed, lest we end up with
> -		 * broken free space accounting.
> -		 *
>  		 * Note: don't bother with iolock here since lockdep complains
>  		 * about acquiring it in reclaim context. We have the only
>  		 * reference to the inode at this point anyways.
>  		 */
> -		if (xfs_can_free_eofblocks(ip, true))
> +		if (xfs_can_free_eofblocks(ip))
>  			error = xfs_free_eofblocks(ip);
>  
>  		goto out;
> -- 
> 2.43.0
> 
> 

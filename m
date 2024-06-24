Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3891DFEA
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243027; cv=none; b=IYMyGuE2dCvMzCbXBhB8kPz9x6NqW13xi4FFERdAJJQ46R+1sMPzMKoTWnGi+6uVjuygRXaieOFHIL0VuKL/RUQelml3EznRCrdPUjq7sz2AHgxMyHjbijNPeM5Kg8Sa/ZXP932QBXI5YFgdUzfh93TuQ1u8p3uSXtOuBrlA+Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243027; c=relaxed/simple;
	bh=pj4FiTgGVFJBHojCVgReVu3/gwJzLS4AXZ+YqoS1rBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6F3j51tLoPOQIO4a3yV1+J5XsIdqlkHSNruW/CF64b7d0dIVAZOoPZqGSac2Im/VF4Otq36tjMHxBrp0EgbyZjQmFJZ7X3HSlLNXHgjezVDValoU8dJKH7jUOKv7NvAh/LStuukhzFXMMjcqkClsDkk2G+5IrDejaIAPWYFyqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qzu5aPoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qzu5aPoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025B4C2BBFC;
	Mon, 24 Jun 2024 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243027;
	bh=pj4FiTgGVFJBHojCVgReVu3/gwJzLS4AXZ+YqoS1rBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qzu5aPojR2AHFAHaEKX9mQZtg5yzCBCvcYRR2Nl8dOY4mI9LjTj3NlmHzetMecRzj
	 1Bl/CWJjbw9TDUrGqLoUzXumDd26h+Ri1gB1AGTUA26JJmhlU+gEIebRoFRvbQSPR3
	 OPoV5OU5ewFx9Q7rycN3mEFHTFyQAyEBdNAsPPLqKCkDwy7Vmux+Ja7okjkwqXfECJ
	 Ez8foNgR0jnNIV1WjP0Yzx8FL07LlLeNvWf6tOLxBM2UgHbOfx86ABQ2jZidDcAZbx
	 BvsfVyxSmu20zKU6nrF2wRlFhilOn2reSOhNd1XpBsAnZ0s873LciBU9oekN1bo9Op
	 nG5aplEKKxRNQ==
Date: Mon, 24 Jun 2024 08:30:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: fix freeing speculative preallocations for
 preallocated files
Message-ID: <20240624153026.GE3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-2-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:46AM +0200, Christoph Hellwig wrote:
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
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine
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
> index f36091e1e7f50b..38f946e3be2da3 100644
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

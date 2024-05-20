Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F734CDE
	for <linux-xfs@vger.kernel.org>; Mon, 20 May 2024 18:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716228529; cv=none; b=fKjhUfJyTor7zowEUqIHoHZyJ8JJFpaXwhPKvQtArslxVxpXOj9tSXHbPf4ICtYyTFNAS2N2SHiFOYYAdGsZHbh3UuClgstRhGKSeLgKLqbKMcpaIopoffLnaOkvvZmyJwgqI5AIN/+i/WH/UThxUpioEGFyaYaLO5M5EMP816o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716228529; c=relaxed/simple;
	bh=by4MpnmRvwrj/lKGsMOIL4eGshHC5Vj4VZjw8WZz+Lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yb3nW06qDGXjXL8IIrOPpJN6HrjBRC/35XPx256VoBkbmrRUnpWcrUJW4yAEmNr3ELydG8ccWdpcxt2U/i+jh+T6eTxzHUHZw6k+ahCEZwWcMAT/4KkZif+ZWvR81hzLHnWzfJZMg1k2yc9b1E7CYjL/mjSc8TJskOJx9tnnexs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rvNhXkuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvNhXkuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD14C2BD10;
	Mon, 20 May 2024 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716228529;
	bh=by4MpnmRvwrj/lKGsMOIL4eGshHC5Vj4VZjw8WZz+Lw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rvNhXkuTN/bwthToHAJO1vR6tDYKDowzWp+jz4DSY/8xpguCsXOPyOEZf6VoRp36I
	 C+MbvduXs01IoCMcWXbnxTpTD02CJ9A7QkuFsUfbhyLHXKLh/iDj5h9uN7paTJBDod
	 I02huObptHQ32zYHIrsnVD6GU4taaZtott5+vt/3l9ti4kk9nyTDO/oEs3QSzfy2c0
	 /kn0+G/ODLIyYUbQR/NVTM8ig/IMrD8gkb8msIQRJmiI5Jsln8yubANQLT6MbpsU5c
	 AsmO/GCTwiYR4ItO+y9biHpXJirQlONv8OCys5kSO2RJKoa8iguO9kzzGRxpAfnP+U
	 k/4jkPmAdYm4A==
Date: Mon, 20 May 2024 11:08:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Message-ID: <20240520180848.GI25518@frogsfrogsfrogs>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240517212621.9394-1-wen.gang.wang@oracle.com>

On Fri, May 17, 2024 at 02:26:21PM -0700, Wengang Wang wrote:
> Unsharing blocks is implemented by doing CoW to those blocks. That has a side
> effect that some new allocatd blocks remain in inode Cow fork. As unsharing blocks

                       allocated

> has no hint that future writes would like come to the blocks that follow the
> unshared ones, the extra blocks in Cow fork is meaningless.
> 
> This patch makes that no new blocks caused by unshare remain in Cow fork.
> The change in xfs_get_extsz_hint() makes the new blocks have more change to be
> contigurous in unshare path when there are multiple extents to unshare.

  contiguous

Aha, so you're trying to combat fragmentation by making unshare use
delayed allocation so that we try to allocate one big extent all at once
instead of doing this piece by piece.  Or maybe you also don't want
unshare to preallocate cow extents beyond the range requested?

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/xfs_inode.c   | 17 ++++++++++++++++
>  fs/xfs/xfs_inode.h   | 48 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_reflink.c |  7 +++++--
>  3 files changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d55b42b2480d..ade945c8d783 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -58,6 +58,15 @@ xfs_get_extsz_hint(
>  	 */
>  	if (xfs_is_always_cow_inode(ip))
>  		return 0;
> +
> +	/*
> +	 * let xfs_buffered_write_iomap_begin() do delayed allocation
> +	 * in unshare path so that the new blocks have more chance to
> +	 * be contigurous
> +	 */
> +	if (xfs_iflags_test(ip, XFS_IUNSHARE))
> +		return 0;

What if the inode is a realtime file?  Will this work with the rt
delalloc support coming online in 6.10?

> +
>  	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
>  		return ip->i_extsize;
>  	if (XFS_IS_REALTIME_INODE(ip))
> @@ -77,6 +86,14 @@ xfs_get_cowextsz_hint(
>  {
>  	xfs_extlen_t		a, b;
>  
> +	/*
> +	 * in unshare path, allocate exactly the number of the blocks to be
> +	 * unshared so that no new blocks caused the unshare operation remain
> +	 * in Cow fork after the unshare is done
> +	 */
> +	if (xfs_iflags_test(ip, XFS_IUNSHARE))
> +		return 1;

Aha, so this is also about turning off speculative preallocations
outside the range that's being unshared?

> +
>  	a = 0;
>  	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  		a = ip->i_cowextsize;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index ab46ffb3ac19..6a8ad68dac1e 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -207,13 +207,13 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
>   * i_flags helper functions
>   */
>  static inline void
> -__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> +__xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)

I think this is already queued for 6.10.

>  {
>  	ip->i_flags |= flags;
>  }
>  
>  static inline void
> -xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> +xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)
>  {
>  	spin_lock(&ip->i_flags_lock);
>  	__xfs_iflags_set(ip, flags);
> @@ -221,7 +221,7 @@ xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
>  }
>  
>  static inline void
> -xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
> +xfs_iflags_clear(xfs_inode_t *ip, unsigned long flags)
>  {
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags &= ~flags;
> @@ -229,13 +229,13 @@ xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
>  }
>  
>  static inline int
> -__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
> +__xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
>  {
>  	return (ip->i_flags & flags);
>  }
>  
>  static inline int
> -xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
> +xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
>  {
>  	int ret;
>  	spin_lock(&ip->i_flags_lock);
> @@ -245,7 +245,7 @@ xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
>  }
>  
>  static inline int
> -xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
> +xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned long flags)
>  {
>  	int ret;
>  
> @@ -258,7 +258,7 @@ xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
>  }
>  
>  static inline int
> -xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
> +xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned long flags)
>  {
>  	int ret;
>  
> @@ -321,25 +321,25 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>  /*
>   * In-core inode flags.
>   */
> -#define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
> -#define XFS_ISTALE		(1 << 1) /* inode has been staled */
> -#define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
> -#define XFS_INEW		(1 << 3) /* inode has just been allocated */
> -#define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
> -#define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
> -#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
> -#define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
> +#define XFS_IRECLAIM		(1UL << 0) /* started reclaiming this inode */
> +#define XFS_ISTALE		(1UL << 1) /* inode has been staled */
> +#define XFS_IRECLAIMABLE	(1UL<< 2) /* inode can be reclaimed */
> +#define XFS_INEW		(1UL<< 3) /* inode has just been allocated */
> +#define XFS_IPRESERVE_DM_FIELDS	(1UL << 4) /* has legacy DMAPI fields set */
> +#define XFS_ITRUNCATED		(1UL << 5) /* truncated down so flush-on-close */
> +#define XFS_IDIRTY_RELEASE	(1UL << 6) /* dirty release already seen */
> +#define XFS_IFLUSHING		(1UL << 7) /* inode is being flushed */
>  #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
> -#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
> -#define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
> -#define XFS_NEED_INACTIVE	(1 << 10) /* see XFS_INACTIVATING below */
> +#define XFS_IPINNED		(1UL << __XFS_IPINNED_BIT)UL
> +#define XFS_IEOFBLOCKS		(1UL << 9) /* has the preallocblocks tag set */
> +#define XFS_NEED_INACTIVE	(1UL << 10) /* see XFS_INACTIVATING below */
>  /*
>   * If this unlinked inode is in the middle of recovery, don't let drop_inode
>   * truncate and free the inode.  This can happen if we iget the inode during
>   * log recovery to replay a bmap operation on the inode.
>   */
> -#define XFS_IRECOVERY		(1 << 11)
> -#define XFS_ICOWBLOCKS		(1 << 12)/* has the cowblocks tag set */
> +#define XFS_IRECOVERY		(1UL << 11)
> +#define XFS_ICOWBLOCKS		(1UL << 12)/* has the cowblocks tag set */
>  
>  /*
>   * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
> @@ -348,10 +348,10 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>   * inactivation completes, both flags will be cleared and the inode is a
>   * plain old IRECLAIMABLE inode.
>   */
> -#define XFS_INACTIVATING	(1 << 13)
> +#define XFS_INACTIVATING	(1UL << 13)
>  
>  /* Quotacheck is running but inode has not been added to quota counts. */
> -#define XFS_IQUOTAUNCHECKED	(1 << 14)
> +#define XFS_IQUOTAUNCHECKED	(1UL << 14)
>  
>  /*
>   * Remap in progress. Callers that wish to update file data while
> @@ -359,7 +359,9 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>   * the lock in exclusive mode. Relocking the file will block until
>   * IREMAPPING is cleared.
>   */
> -#define XFS_IREMAPPING		(1U << 15)
> +#define XFS_IREMAPPING		(1UL << 15)
> +
> +#define XFS_IUNSHARE		(1UL << 16) /* file under unsharing */
>  
>  /* All inode state flags related to inode reclaim. */
>  #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7da0e8f961d3..7867e4a80b16 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1703,12 +1703,15 @@ xfs_reflink_unshare(
>  
>  	inode_dio_wait(inode);
>  
> -	if (IS_DAX(inode))
> +	if (IS_DAX(inode)) {
>  		error = dax_file_unshare(inode, offset, len,
>  				&xfs_dax_write_iomap_ops);
> -	else
> +	} else {
> +		xfs_iflags_set(ip, XFS_IUNSHARE);
>  		error = iomap_file_unshare(inode, offset, len,
>  				&xfs_buffered_write_iomap_ops);
> +		xfs_iflags_clear(ip, XFS_IUNSHARE);
> +	}
>  	if (error)
>  		goto out;
>  
> -- 
> 2.39.3 (Apple Git-146)
> 
> 

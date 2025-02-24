Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4253E126F0A
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 19:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424577; cv=none; b=Od/cyLVXM1QYxuALTsrOIpo+r0ScjK/aFGBYcdoNkx9rkWZtHxYpe8XZFP/fD5h3vV9bHr8odIZ/l7WiZ/Y2VYFUgO9GbArR7JodpZtN7NJQHDDn8OQGGnH7TJylZrawvCafES2y4t0YVX6M5OM424CP6BrdhYfwvDhEJBxNhFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424577; c=relaxed/simple;
	bh=dlgwBEMSgtwH9Z6zd0j+NeeNwRx9/u3/IfKYrKZmAQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cf5Okw1CM1GZgWMnuCD/tF8dMRKP/LOAYNzUFv46C9oqE9pTJBoH1+r6KGiVM901c4Nyal+sb4oBXehtQBsaOuUYB43uAv1EdCP8SXIlizpC8SGRsTdsgRhf9Jw0SOZqmZnJ7VuELYo5CkPONOtBSq5WchNgcjos45s4OVkBDAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DA07uw4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DA07uw4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16847C4CED6;
	Mon, 24 Feb 2025 19:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424577;
	bh=dlgwBEMSgtwH9Z6zd0j+NeeNwRx9/u3/IfKYrKZmAQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DA07uw4OjO9Y+hPwKJHZ7UNxi9RlUvgcq0CB1zJbm/dfmgEsck/AHQELsWJ+zplA1
	 QJuaGREXIxl0DMFe0CHVnGR2WEhNSk4s19ECAy6r7xAXzyLVMQVU6vCzujGMr3Dr9s
	 SLtfDY/stgqVD27BLwZ91iz/+zwwUOM25dGNH94FM0zLr1JGv+Nwac01/vICXlOpio
	 ++3n/9TUMGHPcqhIhbZ2Xoe2LDl6gPHPlFtmPOI/g54UNm5UqI3+Mhgm0lZxdnrLgT
	 Vp1qkPOMXVP5Ad45NfmYmj/TyEh4l3Qq8m+ifgFQeDLbQQ+0rWhzPZHl6x6vLhyLk7
	 WBG2OEp53YqbQ==
Date: Mon, 24 Feb 2025 11:16:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove most in-flight buffer accounting
Message-ID: <20250224191616.GB21808@frogsfrogsfrogs>
References: <20250224151144.342859-1-hch@lst.de>
 <20250224151144.342859-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224151144.342859-4-hch@lst.de>

On Mon, Feb 24, 2025 at 07:11:37AM -0800, Christoph Hellwig wrote:
> The buffer cache keeps a bt_io_count per-CPU counter to track all
> in-flight I/O, which is used to ensure no I/O is in flight when
> unmounting the file system.
> 
> For most I/O we already keep track of inflight I/O at higher levels:
> 
>  - for synchronous I/O (xfs_buf_read/xfs_bwrite/xfs_buf_delwri_submit),
>    the caller has a reference and waits for I/O completions using
>    xfs_buf_iowait
>  - for xfs_buf_delwri_submit_nowait the only caller (AIL writeback)
>    tracks the log items that the buffer attached to
> 
> This only leaves only xfs_buf_readahead_map as a submitter of
> asynchronous I/O that is not tracked by anything else.  Replace the
> bt_io_count per-cpu counter with a more specific bt_readahead_count
> counter only tracking readahead I/O.  This allows to simply increment
> it when submitting readahead I/O and decrementing it when it completed,
> and thus simplify xfs_buf_rele and remove the needed for the
> XBF_NO_IOACCT flags and the XFS_BSTATE_IN_FLIGHT buffer state.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c     | 90 ++++++++------------------------------------
>  fs/xfs/xfs_buf.h     |  5 +--
>  fs/xfs/xfs_buf_mem.c |  2 +-
>  fs/xfs/xfs_mount.c   |  7 +---
>  fs/xfs/xfs_rtalloc.c |  2 +-
>  5 files changed, 20 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3a422b696749..cde8707b9892 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c

<snip>

> @@ -1786,9 +1727,8 @@ xfs_buftarg_wait(
>  	struct xfs_buftarg	*btp)
>  {
>  	/*
> -	 * First wait on the buftarg I/O count for all in-flight buffers to be
> -	 * released. This is critical as new buffers do not make the LRU until
> -	 * they are released.
> +	 * First wait for all in-flight readahead buffers to be released.  This is
> +	 8 critical as new buffers do not make the LRU until they are released.

Nit:     ^ should be a "*"

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	 *
>  	 * Next, flush the buffer workqueue to ensure all completion processing
>  	 * has finished. Just waiting on buffer locks is not sufficient for
> @@ -1797,7 +1737,7 @@ xfs_buftarg_wait(
>  	 * all reference counts have been dropped before we start walking the
>  	 * LRU list.
>  	 */
> -	while (percpu_counter_sum(&btp->bt_io_count))
> +	while (percpu_counter_sum(&btp->bt_readahead_count))
>  		delay(100);
>  	flush_workqueue(btp->bt_mount->m_buf_workqueue);
>  }
> @@ -1914,8 +1854,8 @@ xfs_destroy_buftarg(
>  	struct xfs_buftarg	*btp)
>  {
>  	shrinker_free(btp->bt_shrinker);
> -	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
> -	percpu_counter_destroy(&btp->bt_io_count);
> +	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
> +	percpu_counter_destroy(&btp->bt_readahead_count);
>  	list_lru_destroy(&btp->bt_lru);
>  }
>  
> @@ -1969,7 +1909,7 @@ xfs_init_buftarg(
>  
>  	if (list_lru_init(&btp->bt_lru))
>  		return -ENOMEM;
> -	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
> +	if (percpu_counter_init(&btp->bt_readahead_count, 0, GFP_KERNEL))
>  		goto out_destroy_lru;
>  
>  	btp->bt_shrinker =
> @@ -1983,7 +1923,7 @@ xfs_init_buftarg(
>  	return 0;
>  
>  out_destroy_io_count:
> -	percpu_counter_destroy(&btp->bt_io_count);
> +	percpu_counter_destroy(&btp->bt_readahead_count);
>  out_destroy_lru:
>  	list_lru_destroy(&btp->bt_lru);
>  	return -ENOMEM;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 2e747555ad3f..80e06eecaf56 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -27,7 +27,6 @@ struct xfs_buf;
>  #define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
>  #define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
>  #define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
> -#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
>  #define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
>  #define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
>  #define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
> @@ -58,7 +57,6 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_READ,		"READ" }, \
>  	{ XBF_WRITE,		"WRITE" }, \
>  	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
> -	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
>  	{ XBF_ASYNC,		"ASYNC" }, \
>  	{ XBF_DONE,		"DONE" }, \
>  	{ XBF_STALE,		"STALE" }, \
> @@ -77,7 +75,6 @@ typedef unsigned int xfs_buf_flags_t;
>   * Internal state flags.
>   */
>  #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
> -#define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
>  
>  struct xfs_buf_cache {
>  	struct rhashtable	bc_hash;
> @@ -116,7 +113,7 @@ struct xfs_buftarg {
>  	struct shrinker		*bt_shrinker;
>  	struct list_lru		bt_lru;
>  
> -	struct percpu_counter	bt_io_count;
> +	struct percpu_counter	bt_readahead_count;
>  	struct ratelimit_state	bt_ioerror_rl;
>  
>  	/* Atomic write unit values */
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index 07bebbfb16ee..5b64a2b3b113 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -117,7 +117,7 @@ xmbuf_free(
>  	struct xfs_buftarg	*btp)
>  {
>  	ASSERT(xfs_buftarg_is_mem(btp));
> -	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
> +	ASSERT(percpu_counter_sum(&btp->bt_readahead_count) == 0);
>  
>  	trace_xmbuf_free(btp);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 477c5262cf91..b69356582b86 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -181,14 +181,11 @@ xfs_readsb(
>  
>  	/*
>  	 * Allocate a (locked) buffer to hold the superblock. This will be kept
> -	 * around at all times to optimize access to the superblock. Therefore,
> -	 * set XBF_NO_IOACCT to make sure it doesn't hold the buftarg count
> -	 * elevated.
> +	 * around at all times to optimize access to the superblock.
>  	 */
>  reread:
>  	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
> -				      BTOBB(sector_size), XBF_NO_IOACCT, &bp,
> -				      buf_ops);
> +				      BTOBB(sector_size), 0, &bp, buf_ops);
>  	if (error) {
>  		if (loud)
>  			xfs_warn(mp, "SB validate failed with error %d.", error);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d8e6d073d64d..57bef567e011 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1407,7 +1407,7 @@ xfs_rtmount_readsb(
>  
>  	/* m_blkbb_log is not set up yet */
>  	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
> -			mp->m_sb.sb_blocksize >> BBSHIFT, XBF_NO_IOACCT, &bp,
> +			mp->m_sb.sb_blocksize >> BBSHIFT, 0, &bp,
>  			&xfs_rtsb_buf_ops);
>  	if (error) {
>  		xfs_warn(mp, "rt sb validate failed with error %d.", error);
> -- 
> 2.45.2
> 
> 

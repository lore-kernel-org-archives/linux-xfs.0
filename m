Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC8C17A2FC;
	Fri,  2 May 2025 20:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216407; cv=none; b=LSbqWlRlW3LYNuVmkWV8V4TkkYlWdViUdyfyvtUR+41qy2Qp8/Q5I7xpgALeBny5CN00WGgcwNjyXFbg/hXI80w3nB2224XQEHP10R3SxGGQe40FVkA0Nt1RRFk/pFfndPfCbOXCIoiC4uK8ist+5RvKlNb8pZdd42q+FNgnzhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216407; c=relaxed/simple;
	bh=iN9LEkH8+3F5pqYUVOoF9p3A+vrENyVhTwTygVgN2Ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFimdf0oA34iikypoPOoyJKxWe/4VFl5q5piyqpBuYDkX/zjOBVHznUQ2/yD3AeBgrc/t21uCcq1pV8dbE/ZGbWEh+isu0jIKglc1wtEcvf1JZOASjjGdwOyVBb87F9ozyZyYdX+Jbdr1zpFvF/VPsg2OSf+My+Lxpvwd+NMLZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbPliZfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbPliZfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CA4C4CEE4;
	Fri,  2 May 2025 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746216407;
	bh=iN9LEkH8+3F5pqYUVOoF9p3A+vrENyVhTwTygVgN2Ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dbPliZfiYvyM/mYLB9zIsiBj8rm3G3Mtps7tGpmG4TwBbRsNEJuTTimjYdKJWm+kx
	 skIHRIvAkCWDSSdfl1ebWDjAlWYKflXxg26W6fbrzMB2Qy9yHK+hKRwRBzREDcmAHc
	 Lghlwp0Cqgog3b0LvyBNwXkcrkGp7KUVWgty4MtEHOQ12d1064cD+AUY3Hy9BX5F4p
	 R+rzPiShvLwNeBxhRmQrbfYRv9LzHtwz4KSVMlcJKfQReJ+SgDg7inSivtkkUk4HIB
	 8mTqoxt3xpwRtVodAcJdnoN5MSSnhZW78Ug7yXmPt7ozIiO8rVb0PRf0u7W0LQyYZg
	 L8pLtWxxW5SfQ==
Date: Fri, 2 May 2025 13:06:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on
 failure
Message-ID: <20250502200646.GT25675@frogsfrogsfrogs>
References: <20250430084117.9850-1-hans.holmberg@wdc.com>
 <20250430084117.9850-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430084117.9850-2-hans.holmberg@wdc.com>

On Wed, Apr 30, 2025 at 08:41:21AM +0000, Hans Holmberg wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Call the provided free_func when xfs_mru_cache_insert as that's what
> the callers need to do anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
>  fs/xfs/xfs_filestream.c | 15 ++++-----------
>  fs/xfs/xfs_mru_cache.c  | 15 ++++++++++++---
>  2 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index a961aa420c48..044918fbae06 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -304,11 +304,9 @@ xfs_filestream_create_association(
>  	 * for us, so all we need to do here is take another active reference to
>  	 * the perag for the cached association.
>  	 *
> -	 * If we fail to store the association, we need to drop the fstrms
> -	 * counter as well as drop the perag reference we take here for the
> -	 * item. We do not need to return an error for this failure - as long as
> -	 * we return a referenced AG, the allocation can still go ahead just
> -	 * fine.
> +	 * If we fail to store the association, we do not need to return an
> +	 * error for this failure - as long as we return a referenced AG, the
> +	 * allocation can still go ahead just fine.
>  	 */
>  	item = kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!item)
> @@ -316,14 +314,9 @@ xfs_filestream_create_association(
>  
>  	atomic_inc(&pag_group(args->pag)->xg_active_ref);
>  	item->pag = args->pag;
> -	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
> -	if (error)
> -		goto out_free_item;
> +	xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);

Hmm, don't you still need to check for -ENOMEM returns?  Or if truly
none of the callers care anymore, then can we get rid of the return
value for xfs_mru_cache_insert?

--D

>  	return 0;
>  
> -out_free_item:
> -	xfs_perag_rele(item->pag);
> -	kfree(item);
>  out_put_fstrms:
>  	atomic_dec(&args->pag->pagf_fstrms);
>  	return 0;
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index d0f5b403bdbe..08443ceec329 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -414,6 +414,8 @@ xfs_mru_cache_destroy(
>   * To insert an element, call xfs_mru_cache_insert() with the data store, the
>   * element's key and the client data pointer.  This function returns 0 on
>   * success or ENOMEM if memory for the data element couldn't be allocated.
> + *
> + * The passed in elem is freed through the per-cache free_func on failure.
>   */
>  int
>  xfs_mru_cache_insert(
> @@ -421,14 +423,15 @@ xfs_mru_cache_insert(
>  	unsigned long		key,
>  	struct xfs_mru_cache_elem *elem)
>  {
> -	int			error;
> +	int			error = -EINVAL;
>  
>  	ASSERT(mru && mru->lists);
>  	if (!mru || !mru->lists)
> -		return -EINVAL;
> +		goto out_free;
>  
> +	error = -ENOMEM;
>  	if (radix_tree_preload(GFP_KERNEL))
> -		return -ENOMEM;
> +		goto out_free;
>  
>  	INIT_LIST_HEAD(&elem->list_node);
>  	elem->key = key;
> @@ -440,6 +443,12 @@ xfs_mru_cache_insert(
>  		_xfs_mru_cache_list_insert(mru, elem);
>  	spin_unlock(&mru->lock);
>  
> +	if (error)
> +		goto out_free;
> +	return 0;
> +
> +out_free:
> +	mru->free_func(mru->data, elem);
>  	return error;
>  }
>  
> -- 
> 2.34.1
> 

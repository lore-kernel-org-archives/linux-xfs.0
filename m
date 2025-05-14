Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22295191F98;
	Wed, 14 May 2025 13:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747231194; cv=none; b=n47/74yuqS94pNstuu2dyEjk5hSKPl216hCNfe3wFtKVw2NthnQcvEaV6a9prX7O32XW9TTGk5g/LBaVcjastNXhwPd7JKoGj0e84sDTaiRQGMEsE+AEJrAUAGw0tGS1d0+8TIIV1UI+OtPRXTr/acRHNiFSVJfhltIXy8I0EsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747231194; c=relaxed/simple;
	bh=Vp0cWt1QN9P8A+6/RDjk5kaawoFIZGE0tA1Ec+A9zK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INC5uK8lEicwrPhgwDUpNp0xtfZsTM12P7b12UvmiPCjqL9lDXhsdCERwO8LaqmgvHLgiT0yswa74am+xLYuNhyzY9baZD+1JKT5T0ZSKM9TJRmgGrHdsBQAmKx56CZEVJGAWu8J7pEhwblVc4zfA+Ah58S5Yl2omU+S0DNgg64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW9JP3Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW9JP3Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E06FC4CEE3;
	Wed, 14 May 2025 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747231193;
	bh=Vp0cWt1QN9P8A+6/RDjk5kaawoFIZGE0tA1Ec+A9zK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lW9JP3QscXtn5vrRZSJ9lc2lrqpCQLKHKp/dVbGH1p3ZDoeBCK6DaOZEPpZmRshCz
	 ogrCvwu4IQDsMOIb1NGdbRMh0qtRQMqTnT9jWDI0fKK+icsCWLGs3mRZWHbBdy/Vu+
	 WIroWOysEfJ47GxW1xztuq0PQM1s+LJ2RnmMajFCzwG4FffXIEnWTAjx5OPIoOHaxo
	 x3flP6wOKaENmTjACcTH3MtZtc6hrybQN3e9BZkyKC+Dwr8vadrmeMAKkBaw109Hag
	 3N+WCYKoKSAww6TH/0j/Bulqod1clSedfoSH4VFP+81Gj6pEazC9LnGEzj5Zkgy3VL
	 CyLX8Wm2YDX2g==
Date: Wed, 14 May 2025 15:59:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on failure
Message-ID: <rc3lc5eexwkmrdskw2hq63jhtccwtajus2vpd4dewysmxi3bwh@3opnt2majubs>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
 <9LMrAvjyedm7xNxjrgohdvh5SMMXvERDG8oPUAaNiuSfQf8-fOFdkj49_0hwtfvbEquKrs6OvA6elgVWnzgAjQ==@protonmail.internalid>
 <20250514104937.15380-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514104937.15380-2-hans.holmberg@wdc.com>

On Wed, May 14, 2025 at 10:50:37AM +0000, Hans Holmberg wrote:
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

Looks fine.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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

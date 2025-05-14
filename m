Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDD619E806;
	Wed, 14 May 2025 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747238656; cv=none; b=ENtXfx74roJwpS3ZDL5nSgxOnEmIZtAw+RmeaPCyjFhvlXki+tGH53jhiuiNzooBIUjmYuScOcw4EwbHmHnBDHd7jelzJ04GX4nva+G0t1sHvUDeDZFjFOGSkPsxLzdePoYIOX9lTRcKWL82VZ8UgkIwUvw8eYg7PIB0civoOmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747238656; c=relaxed/simple;
	bh=UoILDnodfwOQfF4Slytdr6msXd/TxOnELBTp+mEsNYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRcTkVExnTGEzr7bQTt+GP+EifM7cnIKaa8AO10EKLItFFRRYW6HWNI7T2yvnzuSxnZrqyxfwS39NBo+KKB0ukHoy8aPd28Vc926UeFGk7MyeR2HaZQB7GmEEW+zRCDUgUR8tZPgpCiJ/z2F0SU6XZhOX5ITQ7tlQ+eMhypDLhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdaCLCcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdaCLCcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1646CC4CEE3;
	Wed, 14 May 2025 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747238654;
	bh=UoILDnodfwOQfF4Slytdr6msXd/TxOnELBTp+mEsNYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdaCLCcs11Cu1hg+8W9I5k07vrZa8caQxBD5XI9vJn2ey58p3Zk6bFob8ZpEDpVZ8
	 DqK9HPNuGQDy7oAF3aq8worLfxkrBFCiXvURJxfvB3w/L/Pl7sDV1L6kl0vPDQ213J
	 Il0LlumxlZET2D/EM4l10/XYU8HF696FHyIGpDcnQVnMv6zTTBzSHIMbSliB5fL3fI
	 KTlQ6iPserXdf56v7DdejD5ZeCWKl2atBtK775dPtZ9Nt5CuXRZ01dKzoRW3i8DAAX
	 zYYyrYjOgYbuN0Iut4oPqxvZzwlHw2WlX4l65hEns1SlOgiltgEiuVYCUqVVUPvaGu
	 dmKbwUvklAWzw==
Date: Wed, 14 May 2025 09:04:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on failure
Message-ID: <20250514160413.GL2701446@frogsfrogsfrogs>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
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

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105FD1F92C
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 23:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hv22/uS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79420C433C8;
	Wed,  3 Jan 2024 23:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704324962;
	bh=q1/He56ZfObyAbbkFqAXfu9H1s3WwKykt+JjEkoFD1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hv22/uS86EpyqzeSGsHaoqgsgpauK/uLvWiFJ2hxFE37x0eq+dsixxtRb+xUMTDum
	 hoY9tN43FIrwFazB5ikx2j9SLkQVY5HAhLF2hUpzxB9+TuHCQiQQQv2nIWxB/kkIpZ
	 samf06N9XT3fkaqM8gEX/HPmeQ+poOVLDKm56hmbVXc9WsOxr8wXLV9nxiV6Y7hHaL
	 HLJAI0mFgURY6VL5cGz24APhWfOKvZFF0UuA8RSmwyASnt3TAJsnTfO0Ntd3K8483g
	 Q/gSl4cB6AatakEj7dBsqUtwCnAXggIF0PmYUu/P7ekp+EF+o5ZIobLtjEQTcyCYWb
	 nNGfozhUeJm0A==
Date: Wed, 3 Jan 2024 15:36:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/15] shmem: export shmem_get_folio
Message-ID: <20240103233601.GW361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-3-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:13AM +0000, Christoph Hellwig wrote:
> Export shmem_get_folio as a slightly lower-level variant of
> shmem_read_folio_gfp.  This will be useful for XFS xfile use cases
> that want to pass SGP_NOALLOC or get a locked page, which the thin
> shmem_read_folio_gfp wrapper can't provide.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I've long wanted more direct coordination with tmpfs for xfiles...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mm/shmem.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3349df6d4e0360..328eb3dbea9f1c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2116,12 +2116,27 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	return error;
>  }
>  
> +/**
> + * shmem_get_folio - find and get a reference to a shmem folio.
> + * @inode:	inode to search
> + * @index:	the page index.
> + * @foliop:	pointer to the found folio if one was found
> + * @sgp:	SGP_* flags to control behavior
> + *
> + * Looks up the page cache entry at @inode & @index.
> + *
> + * If this function returns a folio, it is returned with an increased refcount.
> + *
> + * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
> + * and no folio was found at @index, or an ERR_PTR() otherwise.
> + */
>  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
>  		enum sgp_type sgp)
>  {
>  	return shmem_get_folio_gfp(inode, index, foliop, sgp,
>  			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
>  }
> +EXPORT_SYMBOL_GPL(shmem_get_folio);
>  
>  /*
>   * This is like autoremove_wake_function, but it removes the wait queue
> -- 
> 2.39.2
> 
> 

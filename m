Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082201F606
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 23:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgVVFAhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBD2C433C7;
	Wed,  3 Jan 2024 23:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704324758;
	bh=+5o/V3NHEhBC28Q/AGRGKxOFWI4+5MHUYEGWMTi0chY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PgVVFAhHl5JMUKNiKjmFIkqIjrGVUcgWRsy6tbQ55SEFxuoLeYjR5j/R0cZFwRhf/
	 0LUZNfIPXHdNLvJhZT2BqYC7xVPGd3/E1nDeNbu3nIoFrecfutBDvWB2taXLN6aCwo
	 XYICA4gIN1fg8K9hntpNtshe0MWayWKv6uE0vUvsXPQOsvfXyg3cVRkvpYeh5ipbfI
	 HlI1I9O5qK1SSiI/yvESHZ4gg+RBx8F4USLq6/Ge9lQNXm1cyx26WrVoAZsSufp8Bi
	 vl9IkxVvxxHK8bs7k3t1iA/NcqtpjdXvTY3TzJQniaBsw/464B2vmm4NH6YnK8NR8i
	 gb5uZdjwMmwuw==
Date: Wed, 3 Jan 2024 15:32:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 01/15] shmem: move the shmem_mapping assert into
 shmem_get_folio_gfp
Message-ID: <20240103233237.GV361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-2-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:12AM +0000, Christoph Hellwig wrote:
> Move the check that the inode really is a shmemfs one from
> shmem_read_folio_gfp to shmem_get_folio_gfp given that shmem_get_folio
> can also be called from outside of shmem.c.  Also turn it into a
> WARN_ON_ONCE and error return instead of BUG_ON to be less severe.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

No complaints from me about converting a BUGON to an error return...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mm/shmem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 91e2620148b2f6..3349df6d4e0360 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1951,6 +1951,9 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	int error;
>  	bool alloced;
>  
> +	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
> +		return -EINVAL;
> +
>  	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
>  		return -EFBIG;
>  repeat:
> @@ -4895,7 +4898,6 @@ struct folio *shmem_read_folio_gfp(struct address_space *mapping,
>  	struct folio *folio;
>  	int error;
>  
> -	BUG_ON(!shmem_mapping(mapping));
>  	error = shmem_get_folio_gfp(inode, index, &folio, SGP_CACHE,
>  				    gfp, NULL, NULL);
>  	if (error)
> -- 
> 2.39.2
> 
> 

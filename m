Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC8C1F926
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQ6p+AvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55E3C433C8;
	Wed,  3 Jan 2024 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704326138;
	bh=EJSAFOJfk72w4zuiDhQmYeZvUi0r8YsG9q1WbFswCD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sQ6p+AvMgCzxQNuCbHBclImm9cXZeCde6NGKgvPFQkfr9/jcs158pQDO1avR9X2D4
	 MvrxuDyWU43RLdTnAA0GrwV3lpHAHJh52XI2g3WHbFw5fBPmZdcSbK93ibiSeIVIta
	 xga0DD9YbmsdyVSIn1gC3cInnWrMa+y4VfdnCp5pSBDckByBMmy9GNS/WjbKJVA/2T
	 yRUnuIDl0hfB5Uv3cMCn30oKY3hIc7obWPJbohb3Kmfa/jS0n4ZRYB63Gn1mp9/Nza
	 se2P/OGvJbzDlL3wBLSehIRCzNVbp2ErbDb7yvHjGjeGTUH62uzCOnTqyW4ytyYlTx
	 Gv2fqz9RSxq0w==
Date: Wed, 3 Jan 2024 15:55:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/15] xfs: don't try to handle non-update pages in
 xfile_obj_load
Message-ID: <20240103235538.GZ361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-7-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:17AM +0000, Christoph Hellwig wrote:
> shmem_read_mapping_page_gfp always returns an uptodate page or an
> ERR_PTR.  Remove the code that tries to handle a non-uptodate page.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hmm.  xfile_pread calls shmem_read_mapping_page_gfp ->
shmem_read_folio_gfp -> shmem_get_folio_gfp(..., SGP_CACHE), right?

Therefore, if the page is !uptodate then the "clear:" code will mark it
uptodate, right?  And that's why xfile.c doesn't need to check uptodate?

If that's correct, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> ---
>  fs/xfs/scrub/xfile.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 9e25ecf3dc2fec..46f4a06029cd4b 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -166,18 +166,14 @@ xfile_obj_load(
>  			goto advance;
>  		}
>  
> -		if (PageUptodate(page)) {
> -			/*
> -			 * xfile pages must never be mapped into userspace, so
> -			 * we skip the dcache flush.
> -			 */
> -			kaddr = kmap_local_page(page);
> -			p = kaddr + offset_in_page(pos);
> -			memcpy(buf, p, len);
> -			kunmap_local(kaddr);
> -		} else {
> -			memset(buf, 0, len);
> -		}
> +		/*
> +		 * xfile pages must never be mapped into userspace, so
> +		 * we skip the dcache flush.
> +		 */
> +		kaddr = kmap_local_page(page);
> +		p = kaddr + offset_in_page(pos);
> +		memcpy(buf, p, len);
> +		kunmap_local(kaddr);
>  		put_page(page);
>  
>  advance:
> -- 
> 2.39.2
> 
> 

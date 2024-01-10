Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B2A4BA85
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzcRXxJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B224CC433F1;
	Wed, 10 Jan 2024 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704897155;
	bh=F0ShIjdliAg3W0ldLllOaPfckEHdwow8cbD2CbxdFPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FzcRXxJy8/vHuLKWDWVr4fThtwkYbaHLKEJG/GDlgxuy8hoVHtvQkflc3jhjkyyD8
	 Muo5cWjyj2PdmOvM/4nWr+n89OJjWCId8iMka6k5YfmRD2uQ0089IwCM1+80JG1bnV
	 c9ZG7vIdG4jPPM/2VoLs976W9W6ZomDqsCYRIM7xvi3ElGVkGfXPuYq07m9C/2SRFl
	 jdgmNGfntgwBbc4iR1TkUcjZ1oIS+NcfYclPvXgWAPiFDsur+PAvgHLWcAvy43PODV
	 9W0bfiKz9cXh5y3bqcZEn/6URBSAYF9GZ2+O/Li66+JSBYVzSym8/wPlwF/X1bBoHD
	 7/PqzirKjHBrQ==
Date: Wed, 10 Jan 2024 15:32:31 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] libxfs: fix krealloc to allow freeing data
Message-ID: <x5rjhlc7ke2nvsyoibz22sknn2eoqfn7hxj3b6tnllu4lvvpeg@i5oepr5c5leq>
References: <2onNX45hvnUFtiC16p8O9n99X8jUyzmVCTFDAh86Ad8TlJFw-TI9pxu8Q7mQX7jCGMxA4XV6Q4zisMbabJN5YQ==@protonmail.internalid>
 <20240109055118.GC722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109055118.GC722975@frogsfrogsfrogs>

On Mon, Jan 08, 2024 at 09:51:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A recent refactoring to xfs_idata_realloc in the kernel made it depend
> on krealloc returning NULL if the new size is zero.  The xfsprogs
> wrapper instead aborts, so we need to make it follow the kernel
> behavior.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/kmem.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/libxfs/kmem.c b/libxfs/kmem.c
> index 42d813088d6a..c264be018bdc 100644
> --- a/libxfs/kmem.c
> +++ b/libxfs/kmem.c
> @@ -98,6 +98,16 @@ kmem_zalloc(size_t size, int flags)
>  void *
>  krealloc(void *ptr, size_t new_size, int flags)
>  {
> +	/*
> +	 * If @new_size is zero, Linux krealloc will free the memory and return
> +	 * NULL, so force that behavior here.  The return value of realloc with
> +	 * a zero size is implementation dependent, so we cannot use that.
> +	 */
> +	if (!new_size) {
> +		free(ptr);
> +		return NULL;
> +	}
> +
>  	ptr = realloc(ptr, new_size);
>  	if (ptr == NULL) {
>  		fprintf(stderr, _("%s: realloc failed (%d bytes): %s\n"),

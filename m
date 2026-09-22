Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846393F1640;
	Tue, 22 Sep 2026 04:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051645; cv=none; b=TRCDvPGVz5cWO8HNGAjG9BN946wcUSgV/At3IcdAS6iqbdIvMUDyyWoBZ89GHm0E37HJHWg8c5uN06PKRcPcLEWlpKX5FdcZ1CdhBeTKI6nqV7la1qYOOMJCxh4Lmmj0JBUEGRgniNHKIioTWkGfrwihByOlQUefRq4igmOyePs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051645; c=relaxed/simple;
	bh=fVoMUHa11ui7Ze6xWmC+tDsHn44EI4pra82UZtrMuGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oF+iv2aR4jQu7w3d4YdXd+oKA6qIOSwfJaX6Nf5NBA32kabKHs3ayWVitASTjREC45ERS1ean0qXH9DagPtzTcb2EB0hCMxp10RGHggnFuWuo8z7nGznfJ+BJdRrcdHoAmAhlh81340Z1MJtNaikp1WkiKV42Ym5bcw+98G9Bpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwqL4D0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwqL4D0O"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A206D1F000FF;
	Tue, 22 Sep 2026 04:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051642;
	bh=xIUsqdTQPFnoKt9EnfUmvbFaGcMJVQ4YA3rI0Kzdh7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gwqL4D0O/UjlOCn56Mp2fmUtkof8dZHMjba1D2crqNr2z3OIuKQfQ+R8MYqM/9qBY
	 +MZrfysIILUxfXdW92FglRkZnLFkEH+RMuzwOkvZNgrDIh16XCfiCMybtyLIOFeMR3
	 6tvJPqf99pUG34bvSoEkqWPslrNQbSm0FwHnUX8WkU44xPnASgnLQtWygHnkzxIPmF
	 4f+o0kY/FyxBscHKGqWdkUTo2vfIG0ZCQgbZQH1sqCY0n54AmhY4xWyTMBRTezUVDe
	 u32quEfqB5qsbHxdVSjO7gRhVGOkILDi77C/IIvlDjVGt+7jcT084+zoGT2AKuDJml
	 /PeDEFYcz7SwQ==
Date: Mon, 21 Sep 2026 21:34:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <20260922043402.GM2705364@frogsfrogsfrogs>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-14-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-14-aalbersh@kernel.org>

On Fri, Sep 18, 2026 at 01:15:25PM +0200, Andrey Albershteyn wrote:
> The __xfs_bunmapi() is used to remove all extents past EOF. Add
> XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
> written ones in place. This will be used in following patch to clean up
> unwritten extents on fsverity inodes.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 +++++-
>  fs/xfs/libxfs/xfs_bmap.h | 6 +++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cc48f6e20e80..7ba76017ae56 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5280,6 +5280,10 @@ __xfs_bunmapi(
>  		if (del.br_startoff + del.br_blockcount > end + 1)
>  			del.br_blockcount = end + 1 - del.br_startoff;
>  
> +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> +				del.br_state != XFS_EXT_UNWRITTEN)

Odd indentation?

		if ((flags & XFS_BMAPI_UNWRITTEN) &&
		    del.br_state != XFS_EXT_UNWRITTEN)

/me again wonders if bunmapi ought to have its own flags instaed of
reusing *some* of bmapi.  But I concede that ought to be a different
cleanup, because figuring out which flags are for bunmapi.  I think it's
REMAP, ATTR_FORK, NODISCARD, and UNWRITTEN?

With the indentation fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +			goto skip;
> +
>  		if (!isrt || (flags & XFS_BMAPI_REMAP))
>  			goto delete;
>  
> @@ -5414,7 +5418,7 @@ __xfs_bunmapi(
>  			if (error)
>  				goto error0;
>  		}
> -
> +skip:
>  		end = del.br_startoff - 1;
>  nodelete:
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index d5f2729305fa..0f36431d9936 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -90,6 +90,9 @@ struct xfs_bmalloca {
>  /* Try to align allocations to the extent size hint */
>  #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
>  
> +/* Process unwritten extents only. Used for unmapping */
> +#define XFS_BMAPI_UNWRITTEN	(1u << 12)
> +
>  #define XFS_BMAPI_FLAGS \
>  	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
>  	{ XFS_BMAPI_METADATA,	"METADATA" }, \
> @@ -102,7 +105,8 @@ struct xfs_bmalloca {
>  	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
>  	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
>  	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
> -	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
> +	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
> +	{ XFS_BMAPI_UNWRITTEN,	"UNWRITTEN" }
>  
>  
>  static inline int xfs_bmapi_aflag(int w)
> -- 
> 2.54.0
> 
> 

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480132BD5B9;
	Tue, 10 Mar 2026 00:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104243; cv=none; b=Cz+rRHBq8I/ei34UNJom6uTTVspKYED1SRm4H5mbTFPWD0ukEpp7qvtchYfKH3skc++zpB/bK82E5jA3ZezIajBQQ14wU3fbWUj3g40zKicpqdPgHfbeXxJwJ1e5pSOpNnhVnyEK4J3VgkBA62JrImybi/AYdY+t6O2fXC6n/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104243; c=relaxed/simple;
	bh=iFfH4GoxlpMzD7FlVr3QH3NNuwbWxg7Oyz+8cddwelk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tFvS7pvBv+uZfs1oBsT6cjalS0Z0u4zVP0HVXDYj7wM7mpvhRhYbJkfypUs6cHbcWFtK5HYrEXNHPBWm8yM1wBBPMzNGyjDU5/HUby9mYvcf7VYkfMkVIMnuQQXvofKBKjhWsMZNN+KGA8eEWS1MREtIwvwSKpiJ2pVqEqHK7+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUUIEuXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUUIEuXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A999FC4CEF7;
	Tue, 10 Mar 2026 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104242;
	bh=iFfH4GoxlpMzD7FlVr3QH3NNuwbWxg7Oyz+8cddwelk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dUUIEuXPW5xAglItpVBzDlJT93IBW/dPL/CjgwRq2n7Ugd+Yj1avtGSJZV9w24l7k
	 6bvv/BoqhohXNRHcIKeOTRr0s9ncsK/CA0ZK2s1/jCkl4KUjx/PCT+wP/O4epQIYvq
	 pu6O79M4ChdcxpmWjiZmd4fGloOsUwrYSonE50pKySY1h+sSeEFKTxfwu3IF0043iL
	 nMKwy1+eiXnj3WFwrGnM6G0XC/xpMq6gBySMEjl1ynitlwNTIN7A2FE5XWR3b7l6ha
	 Vzzc3DRZv5vZ1fw7j/Bfmf8pF2vqGdfPKV5dWcPUmXEbiIfi1xUGPzsLSFmpiESWqJ
	 QhRYqNSUdCK7g==
Date: Mon, 9 Mar 2026 17:57:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 08/25] iomap: obtain fsverity info for read path
Message-ID: <20260310005722.GB6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-9-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-9-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:23PM +0100, Andrey Albershteyn wrote:
> Obtain fsverity info for folios with file data. Filesystem can pass vi
> down to ioend and then to fsverity for verification. XFS will use it in
> further patch for fsverity integration.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 7 +++++++
>  include/linux/iomap.h  | 2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 530794dcdd91..a335a18c307f 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -9,6 +9,7 @@
>  #include <linux/swap.h>
>  #include <linux/migrate.h>
>  #include <linux/fserror.h>
> +#include <linux/fsverity.h>
>  #include "internal.h"
>  #include "trace.h"
>  
> @@ -590,6 +591,9 @@ void iomap_read_folio(const struct iomap_ops *ops,
>  
>  	trace_iomap_readpage(iter.inode, 1);
>  
> +	if (iter.pos < i_size_read(iter.inode))
> +		ctx->vi = fsverity_get_info(iter.inode);
> +
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.status = iomap_read_folio_iter(&iter, ctx,
>  				&bytes_submitted);
> @@ -656,6 +660,9 @@ void iomap_readahead(const struct iomap_ops *ops,
>  
>  	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
>  
> +	if (iter.pos < i_size_read(iter.inode))
> +		ctx->vi = fsverity_get_info(iter.inode);
> +
>  	while (iomap_iter(&iter, ops) > 0)
>  		iter.status = iomap_readahead_iter(&iter, ctx,
>  					&cur_bytes_submitted);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index dc39837b0d45..89e5a7abc012 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -432,6 +432,7 @@ struct iomap_ioend {
>  	loff_t			io_offset;	/* offset in the file */
>  	sector_t		io_sector;	/* start sector of ioend */
>  	void			*io_private;	/* file system private data */
> +	struct fsverity_info	*io_vi;		/* fsverity info */
>  	struct bio		io_bio;		/* MUST BE LAST! */
>  };
>  
> @@ -506,6 +507,7 @@ struct iomap_read_folio_ctx {
>  	struct readahead_control *rac;
>  	void			*read_ctx;
>  	loff_t			read_ctx_file_offset;
> +	struct fsverity_info	*vi;
>  };
>  
>  struct iomap_read_ops {
> -- 
> 2.51.2
> 
> 

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263492BD11;
	Tue, 10 Mar 2026 00:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773103635; cv=none; b=Dj4kFEqabjry6zFDkUmlv3R7c24okvlDxxMTHqAXuHMAJsF29LVyqisd/BDMqGw5Rx+o2sEvgO2e2dtqBrtB0zioDjKTxbc54BLHotoA+cU0MxqGQ0IldnKNx275DvExiCqrCyY2YkdmLM9YdmmzxLqQUOhHuO9WckIlZNa6wsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773103635; c=relaxed/simple;
	bh=YeLZxMDoZgvRF0++QZ8HZfV0ZARN8oRvq+jsJMMmY90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMu3xushXUzcuKuAFzdk43sA/ss8mio0t9JY3wRffOAh3mNaG6yGeqBmKvlW92TwI2bxE3WPq36n06Rn7pqxedP9ecJXBH7e1Amr/rc90nMXik/yXcGiNMD6y6P+iqt5TCQw2H4J4e0DYM8wCGypBmAruigg3Hqv7SJQ/1nqlTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KU2eQlK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KU2eQlK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F21C2BC9E;
	Tue, 10 Mar 2026 00:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773103634;
	bh=YeLZxMDoZgvRF0++QZ8HZfV0ZARN8oRvq+jsJMMmY90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KU2eQlK0UC+rvlXiIchmhHWSks78KArmkAPWXgK5bqiD2Q/EIcNzB4OiMIvb6sA71
	 yA6L+qs8aGwaQT5KoJsw4+B0DfQoUxt4B6h7f/gwqXGp8abCPR8NHe67LCQxdbXmt2
	 /Hj7cMCDwNy9oWlE75wKURW+r9G7kLMm/nh33zgvBHg56AMb3zyL/AP1+YY9W7oB1o
	 tu1lSZdnA7ogwB8AheYYwRcZIhRc14MPVYBuY6h7s69Rrj71diJvFM1N8M5r/q+KsL
	 ejowd2fp8rM0fETHkUwre1RjwzZFfcfD8ykIIpRcfNNy9UTD2mHGVmhQblQepYr9U6
	 QNhb+cTvuiuEg==
Date: Mon, 9 Mar 2026 17:47:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 04/25] fsverity: introduce fsverity_folio_zero_hash()
Message-ID: <20260310004713.GW6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-5-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-5-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:19PM +0100, Andrey Albershteyn wrote:
> Helper to pre-fill folio with hashes of empty blocks. This will be used
> by iomap to synthesize blocks full of zero hashes on the fly.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/verity/pagecache.c    | 22 ++++++++++++++++++++++
>  include/linux/fsverity.h |  2 ++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
> index 1819314ecaa3..1d94bf73f38c 100644
> --- a/fs/verity/pagecache.c
> +++ b/fs/verity/pagecache.c
> @@ -2,6 +2,7 @@
>  /*
>   * Copyright 2019 Google LLC
>   */
> +#include "fsverity_private.h"
>  
>  #include <linux/export.h>
>  #include <linux/fsverity.h>
> @@ -56,3 +57,24 @@ void generic_readahead_merkle_tree(struct inode *inode, pgoff_t index,
>  		folio_put(folio);
>  }
>  EXPORT_SYMBOL_GPL(generic_readahead_merkle_tree);
> +
> +/**
> + * fsverity_folio_zero_hash() - fill folio with hashes of zero data block
> + * @folio:	folio to fill
> + * @poff:	offset in the folio to start
> + * @plen:	length of the range to fill with hashes
> + * @vi:		fsverity info
> + */
> +void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
> +			      struct fsverity_info *vi)
> +{
> +	size_t offset = poff;
> +
> +	WARN_ON_ONCE(!IS_ALIGNED(poff, vi->tree_params.digest_size));
> +	WARN_ON_ONCE(!IS_ALIGNED(plen, vi->tree_params.digest_size));
> +
> +	for (; offset < (poff + plen); offset += vi->tree_params.digest_size)
> +		memcpy_to_folio(folio, offset, vi->tree_params.zero_digest,
> +				vi->tree_params.digest_size);
> +}
> +EXPORT_SYMBOL_GPL(fsverity_folio_zero_hash);
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 8ba7806b225e..b490b2c8a393 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -321,5 +321,7 @@ void fsverity_cleanup_inode(struct inode *inode);
>  struct page *generic_read_merkle_tree_page(struct inode *inode, pgoff_t index);
>  void generic_readahead_merkle_tree(struct inode *inode, pgoff_t index,
>  				   unsigned long nr_pages);
> +void fsverity_folio_zero_hash(struct folio *folio, size_t poff, size_t plen,
> +			      struct fsverity_info *vi);
>  
>  #endif	/* _LINUX_FSVERITY_H */
> -- 
> 2.51.2
> 
> 

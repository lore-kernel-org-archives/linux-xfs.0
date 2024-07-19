Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E081362
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721348727; cv=none; b=IhBZNgJflxeoxLgcUZyWy6CQ1bCTaI199GsacBaDJB1Q7VhDWLj9BVEU1Q5twR/9zEK3TdobeXDbUTyeieXSjZJp69gLusnH9J38AgPx1gylsHBuXJE6lMU8wQhaxnMwMr8xSADxyNJIIpATH0pui7FHsWRkHsTg+vB3vHU6otc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721348727; c=relaxed/simple;
	bh=td+aM0rgYI+vOP/GmMfZXbsWfNpIUbeZIy4qcN1Any0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8c71aZO6xsaKrc+Ulhac/C3Ukrc7YLGpJoZEzhjX9SUH98jjudESoP7rufMYj27piCHjmk/EAym6x/KcOPrFJ+Nd6sAeKuqxqwU3xk5JwWpoh7sCufNU5oAQYq0Jpg3cpCgQM6gNY4sVMuoBEFuJmdw/F9wMUqfAvWUgbaUuJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EyvNpIvS; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EyvNpIvS"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6bce380eb96so923659a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 17:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1721348724; x=1721953524; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eOcvsNPNJsOW5of/uY6NJFdmB3X8eXRaur0mZXAcEBY=;
        b=EyvNpIvS9wuSjyCK9mUNZsAe5jp8m+SzKXGsPQ0u8mLDTOpQmJPcGwayA88YfXGwuw
         PaQJFflZ61lop+sZnPZr2HuQkxEfLOdtiZSbUGYIGv5FaNjtE7akIC/O14jXvRk9pSLV
         ye1rSafawJlnBPMNupTrkDFyyZ4Oh3wevJPR9CZA4s+lSYiOwPm+j2qomSiS+fZBFGAN
         5zQUbyH+rIlLAcYwIYTVXjtl42kyfDdT6NMTg/psKcw2dAFYL3zZoENW2HyEsnEt824f
         scz+6ndHhS7kVCCunrjOeT46mSbE0A5JiZ462o2iSjE33IJ5kvi+4Uzyzib4qdDJsvs5
         qx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721348724; x=1721953524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOcvsNPNJsOW5of/uY6NJFdmB3X8eXRaur0mZXAcEBY=;
        b=F2EQpCYCH431xuC/YgdN1FKlKmfy57mofuy+LkgjsuTjNqb/xiBYJ8VlY6Ou5CSErn
         liVETuzW/N/mwLcix1cC2rdfidZDOWZhGP+kNW5EXGU2dWLjJUf4jy59FXdXbrOCyYqF
         ADxX+5gCz8HK5bv4YZN6t9m3GvJP7KPBjOkP/0dSje/QjQleEu+ny5gt+JvtG2ZGIMIj
         7Qfkii2Cz6vbp/NX5Cnyehcv8ibHjOiNZCeugluLstyQCqSXN3DymljhtnhoRH3bCKWW
         kiLe/RSIVr7RNqIrEGY7qYK0U/CB/fgb8WBMCcUq+YC7qs+LTkBhNbRh+Jl6NTxHub/w
         fW/w==
X-Forwarded-Encrypted: i=1; AJvYcCUj3uPtSbsnFo3gHpHHybZ5kIuSaty2K1gCmjlP8fBKN/8VK3bNntbyu5Tf7iZUiKgzfcz+x00sj9/hhQa6gKF6e5sFLA4Ec28h
X-Gm-Message-State: AOJu0YwjL540wi9DaTd7MdPutOhjzZJjlsaLPck1yIShxo/rE63zTbxe
	Zq2sLyKMeL0fTlcM7yr3nlixSOnk8WHp3pBc7XEm3Yfg3Y4Qh9yjKotku9r2hN0=
X-Google-Smtp-Source: AGHT+IHVRTt+YTASMX6gtjziVqWXoTgY5Jeq2DjrB0huGt95tcGCxDjV8hgTw93Gk6UrlB0ObIF8lw==
X-Received: by 2002:a05:6a20:6a27:b0:1c2:9070:90ce with SMTP id adf61e73a8af0-1c3fdd30a79mr7668339637.43.1721348724405;
        Thu, 18 Jul 2024 17:25:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf7b5c342sm248371a91.19.2024.07.18.17.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 17:25:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sUbR2-003Db1-2P;
	Fri, 19 Jul 2024 10:25:20 +1000
Date: Fri, 19 Jul 2024 10:25:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] iomap: fix handling of dirty folios over unwritten
 extents
Message-ID: <ZpmycN7FraEm+jRs@dread.disaster.area>
References: <20240718130212.23905-1-bfoster@redhat.com>
 <20240718130212.23905-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718130212.23905-4-bfoster@redhat.com>

On Thu, Jul 18, 2024 at 09:02:11AM -0400, Brian Foster wrote:
> iomap_zero_range() does not correctly handle unwritten mappings with
> dirty folios in pagecache. It skips unwritten mappings
> unconditionally as if they were already zeroed, and thus potentially
> exposes stale data from a previous write if affected folios are not
> written back before the zero range.
> 
> Most callers already flush the target range of the zero for
> unrelated, context specific reasons, so this problem is not
> necessarily prevalent. The known outliers (in XFS) are file
> extension via buffered write and truncate. The truncate path issues
> a flush to work around this iomap problem, but the file extension
> path does not and thus can expose stale data if current EOF is
> unaligned and has a dirty folio over an unwritten block.
> 
> This patch implements a mechanism for making zero range pagecache
> aware for filesystems that support mapping validation (i.e.
> folio_ops->iomap_valid()). Instead of just skipping unwritten
> mappings, scan the corresponding pagecache range for dirty or
> writeback folios. If found, explicitly zero them via buffered write.
> Clean or uncached subranges of unwritten mappings are skipped, as
> before.
> 
> The quirk with a post-iomap_begin() pagecache scan is that it is
> racy with writeback and reclaim activity. Even if the higher level
> code holds the invalidate lock, nothing prevents a dirty folio from
> being written back, cleaned, and even reclaimed sometime after
> iomap_begin() returns an unwritten map but before a pagecache scan
> might find the dirty folio. To handle this situation, we can rely on
> the fact that writeback completion converts unwritten extents in the
> fs before writeback state is cleared on the folio.
> 
> This means that a pagecache scan followed by a mapping revalidate of
> an unwritten mapping should either find a dirty folio if it exists,
> or detect a mapping change if a dirty folio did exist and had been
> cleaned sometime before the scan but after the unwritten mapping was
> found. If the revalidation succeeds then we can safely assume
> nothing has been written back and skip the range. If the
> revalidation fails then we must assume any offset in the range could
> have been modified by writeback. In other words, we must be
> particularly careful to make sure that any uncached range we intend
> to skip does not make it into iter.processed until the mapping is
> revalidated.
> 
> Altogether, this allows zero range to handle dirty folios over
> unwritten extents without needing to flush and wait for writeback
> completion.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 53 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index a9425170df72..ea1d396ef445 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1385,6 +1385,23 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
>  }
>  EXPORT_SYMBOL_GPL(iomap_file_unshare);
>  
> +/*
> + * Scan an unwritten mapping for dirty pagecache and return the length of the
> + * clean or uncached range leading up to it. This is the range that zeroing may
> + * skip once the mapping is validated.
> + */
> +static inline loff_t
> +iomap_zero_iter_unwritten(struct iomap_iter *iter, loff_t pos, loff_t length)
> +{
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	loff_t fpos = pos;
> +
> +	if (!filemap_range_has_writeback(mapping, &fpos, length))
> +		return length;
> +	/* fpos can be smaller if the start folio is dirty */
> +	return max(fpos, pos) - pos;

I'm not sure this is safe. filemap_range_has_writeback() doesn't do
checks for invalidation races or that the folio is actually valid.
It also treats locked folios as dirty and a locked folio isn't
necessarily dirty. IOWs, this check assumes that we'll do all these
checks during the actual writeback operation that would follow this
check and so skip anything that might have given a false positive
here.

iomap_write_begin() doesn't do those sorts of check. If there's no
folio in the cache, it will simply instantiate a new one and dirty
it. If there's an existing folio, it will simply dirty it.

Hence I don't think a "is there a folio  in this range that is a
potential writeback candidate" check is correct here. I think we
need to be more robust in determining if a cached folio in the range
exists and needs zeroing. Ideas on that to follow...

>  static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
>  {
>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> @@ -1393,16 +1410,46 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
>  	loff_t written = 0;
>  
>  	/* already zeroed?  we're done. */
> -	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> +	if (srcmap->type == IOMAP_HOLE)
>  		return length;
>  
>  	do {
>  		struct folio *folio;
>  		int status;
>  		size_t offset;
> -		size_t bytes = min_t(u64, SIZE_MAX, length);
> +		size_t bytes;
> +		loff_t pending = 0;
>  		bool ret;
>  
> +		/*
> +		 * Determine the range of the unwritten mapping that is clean in
> +		 * pagecache. We can skip this range, but only if the mapping is
> +		 * still valid after the pagecache scan. This is because
> +		 * writeback may have cleaned folios after the mapping lookup
> +		 * but before we were able to find them here. If that occurs,
> +		 * then the mapping must now be stale and we must reprocess the
> +		 * range.
> +		 */
> +		if (srcmap->type == IOMAP_UNWRITTEN) {
> +			pending = iomap_zero_iter_unwritten(iter, pos, length);
> +			if (pending == length) {
> +				/* no dirty cache, revalidate and bounce as we're
> +				 * either done or the mapping is stale */
> +				if (iomap_revalidate(iter))
> +					written += pending;

Ok, this isn't really how the revalidation was supposed to be used
(i.e. it's not stabilising the data and page cache state first),
but it looks like works for this situation. We can use this. :)

> +				break;
> +			}
> +
> +			/*
> +			 * Found a dirty folio. Update pos/length to point at
> +			 * it. written is updated only after the mapping is
> +			 * revalidated by iomap_write_begin().
> +			 */
> +			pos += pending;
> +			length -= pending;
> +		}
> +
> +		bytes = min_t(u64, SIZE_MAX, length);
>  		status = iomap_write_begin(iter, pos, bytes, &folio);
>  		if (status)
>  			return status;

We don't hold any references to the page cache between the
iomap_zero_iter_unwritten() and then the actual folio lookup in
iomap_write_begin() where we reference and lock the folio at the
given offset. e.g. we get a "dirty" hit because of a locked folio,
and that folio is clean and contains zeroes (e.g. mmap read,
readahead, etc). We now write zeroes to that folio and dirty it
when, we should actually be skipping it and leaving the range as
unwritten.

In previous patches that fixed this zeroing issue, this wasn't a
problem because it used the existing iomap page cache lookup
mechanisms from iomap_write_begin() to get referenced, locked folios
over the zeroing range. Instead of skipping potential page cache
holes, it prevented page cache instantiation over page cache holes
from occurring when zeroing unwritten extents and that skipped page
cache holes naturally.

https://lore.kernel.org/linux-xfs/20240529095206.2568162-2-yi.zhang@huaweicloud.com/

This means the iteration would skip holes but still safely
revalidate the iomap once it found and locked a folio in the given
range. It could also then check the folio is dirty to determine if
zeroing was necessary.  Yes, this means it iterated holes in the
range PAGE_SIZE by PAGE_SIZE to do lookups, so it was inefficient.

However, we could still use this filemap_range_has_writeback()
optimisation to skip unwritten extents that don't have any cached
pages over them completely, but ti don't think it is really safe to
use it during the iteration to discover regions that don't need
zeroing. i.e. the fast path is this:

	if (srcmap->type == IOMAP_HOLE)
		return length;
	if (srcmap->type == IOMAP_UNWRITTEN &&
	    !filemap_range_has_writeback(mapping, pos, length)) {
		if (!iomap_revalidate(iter))
			return 0; /* stale mapping */
		return length;
	}

And the slow path does something similar to the above patch.
However, I'm still not sure that filemap_range_has_writeback() is
the right set of checks to use here.

I just thought of another option - after thinking about how you've
modified filemap_range_has_writeback() to increment the iomap
iterator position to skip empty ranges, I think we could actually
drive that inwards to the page cache lookup. We could use
use filemap_get_folios() instead of __filemap_get_folio() for
unwritten extent zeroing iteration. This would allow the page cache
lookup to return the first folio in the range as a referenced folio
which we can then lock and validate similar to __filemap_get_folio().

We can then increment the iterator position based on the folio
position, the iomap_write_begin() code will do the revalidation of
the iomap, and the zeroing code can then determine if zeroing is
needed based on whether the folio is dirty/writeback or not. As this
all happens under the folio lock, it is largely safe from both page
cache data and state and extent state changes racing with the
zeroing operation.

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

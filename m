Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2474C14;
	Tue, 10 Mar 2026 00:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104073; cv=none; b=eQSKJ7mXptj9/jvxlOCuDL41o8IBc4p9Zl9ZqXiSls3m3ZeoMOks7PMTbp07X+FTsSWjPqIX0ys8G/riWR/ferFBd1zFy4hfBWI6QCtsKsl4wxnpUXpiKPNmNOGianwOH6L7xWSZdWNJL5SirQ5wV6TTpCJ7F5s9zWIGx1Q9w1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104073; c=relaxed/simple;
	bh=dD+yDAtPqSGN+bF1VISeh1X1ceJWh7z9IlEn5rSOH7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdom8ysHvdEwtFmPu3MfCCS6fvKrYgYJqY8vKPv0Fttz5ZsdPX3XPVNtcQmS+7RUeImPFA96dJ4goF0eXtxJRxPYxZPvpZNrLKPWJr8U+l9VYNNOmllf+4ig6vN2gRGfH7e4GfNQ3xO+JAf1Hx+uWeAkbDsnLRgUKm3oV7L1LXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=de78d+Mn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="de78d+Mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D34C4CEF7;
	Tue, 10 Mar 2026 00:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104072;
	bh=dD+yDAtPqSGN+bF1VISeh1X1ceJWh7z9IlEn5rSOH7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=de78d+MnaW8U0E7l3cvBN4U2h6z25ueH/JD+bLWjeJ5i8/COdlU9RMWIwQ2vMl1eG
	 UqdGxK760OqIVcJVwqj/YSJ3Qs7eHh2XvSxZmK9hgeCc/Iw9TSmalgWOLBP73Kk4Hq
	 scbpdIcB5PHMsLzcajK9DZzyZ8mqiRijXbDL/TqNxGOTU5BKqZD1GoWsx6i4PS7wrR
	 OOhFjlM/7/NMuM/NV72zht48rjUKr/l7/GN47nV+OYvmZB9YMo0dXI10g6+NluLzmI
	 WEwl/XIuXdSd1a1Mqr5otnqUaTGRFonWqTxl+Lf2HC6AgKi2W7Y1SyWdyX8IZ3SOg9
	 pN546PuLivhWw==
Date: Mon, 9 Mar 2026 17:54:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 07/25] iomap: introduce IOMAP_F_FSVERITY and teach
 writeback to handle fsverity
Message-ID: <20260310005432.GZ6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-8-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:22PM +0100, Andrey Albershteyn wrote:
> This flag indicates that I/O is for fsverity metadata.
> 
> In the write path skip i_size check and i_size updates as metadata is
> past EOF. In writeback don't update i_size and continue writeback if
> even folio is beyond EOF. In read path don't zero fsverity folios, again
> they are past EOF.
> 
> The iomap_block_needs_zeroing() is also called from write path. For
> folios of larger order we don't want to zero out pages in the folio as
> these could contain other merkle tree blocks. For fsverity, filesystem
> will request to read PAGE_SIZE memory regions. For data folios, iomap
> will zero the rest of the folio for anything which is beyond EOF. We
> don't want this for fsverity folios.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

This feels like a reasonable means to implement post-EOF data stashing
for fsverity having gone through many other merkle tree IO path designs
and discarded them all. :/

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Hey, at least some day we might get fscrypt+fsverity on xfs for free.

--D

> ---
>  fs/iomap/buffered-io.c | 34 +++++++++++++++++++++++++---------
>  fs/iomap/trace.h       |  3 ++-
>  include/linux/iomap.h  |  5 +++++
>  3 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 51a58a0bfe6c..530794dcdd91 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -344,9 +344,16 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
>  {
>  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
>  
> -	return srcmap->type != IOMAP_MAPPED ||
> -		(srcmap->flags & IOMAP_F_NEW) ||
> -		pos >= i_size_read(iter->inode);
> +	if (srcmap->type != IOMAP_MAPPED)
> +		return true;
> +
> +	if (srcmap->flags & IOMAP_F_NEW)
> +		return true;
> +
> +	if (srcmap->flags & IOMAP_F_FSVERITY)
> +		return false;
> +
> +	return pos >= i_size_read(iter->inode);
>  }
>  
>  /**
> @@ -1152,13 +1159,14 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
>  		 * unlock and release the folio.
>  		 */
>  		old_size = iter->inode->i_size;
> -		if (pos + written > old_size) {
> +		if (pos + written > old_size &&
> +		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
>  			i_size_write(iter->inode, pos + written);
>  			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
>  		}
>  		__iomap_put_folio(iter, write_ops, written, folio);
>  
> -		if (old_size < pos)
> +		if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
>  			pagecache_isize_extended(iter->inode, old_size, pos);
>  
>  		cond_resched();
> @@ -1786,13 +1794,21 @@ static int iomap_writeback_range(struct iomap_writepage_ctx *wpc,
>   * Check interaction of the folio with the file end.
>   *
>   * If the folio is entirely beyond i_size, return false.  If it straddles
> - * i_size, adjust end_pos and zero all data beyond i_size.
> + * i_size, adjust end_pos and zero all data beyond i_size. Don't skip fsverity
> + * folios as those are beyond i_size.
>   */
> -static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
> -		u64 *end_pos)
> +static bool iomap_writeback_handle_eof(struct folio *folio,
> +				       struct iomap_writepage_ctx *wpc,
> +				       u64 *end_pos)
>  {
> +	struct inode *inode = wpc->inode;
>  	u64 isize = i_size_read(inode);
>  
> +	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
> +		WARN_ON_ONCE(folio_pos(folio) < isize);
> +		return true;
> +	}
> +
>  	if (*end_pos > isize) {
>  		size_t poff = offset_in_folio(folio, isize);
>  		pgoff_t end_index = isize >> PAGE_SHIFT;
> @@ -1858,7 +1874,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
>  
>  	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
>  
> -	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
> +	if (!iomap_writeback_handle_eof(folio, wpc, &end_pos))
>  		return 0;
>  	WARN_ON_ONCE(end_pos <= pos);
>  
> diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
> index 532787277b16..5252051cc137 100644
> --- a/fs/iomap/trace.h
> +++ b/fs/iomap/trace.h
> @@ -118,7 +118,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
>  	{ IOMAP_F_ATOMIC_BIO,	"ATOMIC_BIO" }, \
>  	{ IOMAP_F_PRIVATE,	"PRIVATE" }, \
>  	{ IOMAP_F_SIZE_CHANGED,	"SIZE_CHANGED" }, \
> -	{ IOMAP_F_STALE,	"STALE" }
> +	{ IOMAP_F_STALE,	"STALE" }, \
> +	{ IOMAP_F_FSVERITY,	"FSVERITY" }
>  
>  
>  #define IOMAP_DIO_STRINGS \
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 531f9ebdeeae..dc39837b0d45 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -87,6 +87,11 @@ struct vm_fault;
>  #define IOMAP_F_INTEGRITY	0
>  #endif /* CONFIG_BLK_DEV_INTEGRITY */
>  
> +/*
> + * IO happens beyond inode EOF, fsverity metadata is stored there
> + */
> +#define IOMAP_F_FSVERITY	(1U << 10)
> +
>  /*
>   * Flag reserved for file system specific usage
>   */
> -- 
> 2.51.2
> 
> 

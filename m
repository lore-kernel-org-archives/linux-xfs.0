Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A40381EAE;
	Thu,  2 Jul 2026 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009396; cv=none; b=OK76dF6IvJKKLrV4OjTyZHuMgiPg/LCDJdf+qKpfX8Pax5a9n8uZR73gSELyiaS1yZoBRLOXt+w2VXt583/mtpqIt4vBsSDoSbukE9JZIVnmb/XyRjiQFAieNY6nRAdoMFuAp7sBpaAeWvX0TzQr32ps6WE2EuY/2bFb6/epl/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009396; c=relaxed/simple;
	bh=VIrG7qz1jMLHlfpqKxZwsYxtGxJXTHNW5KveB/5uhg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQSWzV+jXS8lahhbMiwREDY2kvaTu1lanqLv6TNqJpd5Pz/Uf0/xvfY/HAilZ4wWCr6q8syZCe7udi4Z+/oMWbBobiILDvV1KMVN2WyWnx/GSfeKSftT+T8YXuQtiOb5HsDPfwPiJsgHGmqvSgQe0IOdcXJuHcRnUHLFG48edjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0HtnPFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0HtnPFn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DAFA81F00A3A;
	Thu,  2 Jul 2026 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009389;
	bh=mSS2awFYGmptPDTP1sDpnwSpZhB1AN5V+x+dYz8CTfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e0HtnPFnaIVwKt3uxyXrsrXvSaHLvKYAcHFz3MeY0L3JQXKVG+FgtIFPDw2DKsppd
	 YD4jwKH1RWZN067PEFgNXk4Cgmalfu7F9d0ZCu5PlN8py6i56CKOtRHwFay6ImtR5S
	 IfRkax50+0CQl6WPCbSwIVLLNp2Ip/gTEd8YHW6wyh0W9V8klF+qK9CezJmjMDeL3/
	 z3tiEqXjXWKPJlcKT3C8GmoUXDrAxesJiUA7C+gWekGc4ZwlrAUBnecCCwVw6uuJBq
	 +cskcpOLMToulOuvwLpPeoBLQ7Z5ZywbYq6+TBzyap87iJ0rdCQFWdbFjvIO3cQQvR
	 Ybti3Ff4I7Dyg==
Date: Thu, 2 Jul 2026 09:23:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/18] iomap: add ->iomap_next() and iomap_process()
 helper
Message-ID: <20260702162308.GH9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-2-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-2-joannelkoong@gmail.com>

On Tue, Jun 30, 2026 at 05:09:16PM -0700, Joanne Koong wrote:
> Have one ->iomap_next() callback instead of ->iomap_begin() and
> ->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
> and produces the next mapping. This lets performance-critical callers
> inline the iteration with a fixed callback, which the compiler is able
> to call directly instead of indirectly.

Er... what is being called directly here?  The iomap_{begin,end}
functions?  It looks to me like ->iomap_next is still an indirect call
even at the end of the series, right?  That's still a net reduction of
indirect calls at least.

Oh, wait, it's the __always_inline iomap_process function that a smart
compiler can use to turn the indirect calls into direct ones, isn't it?
It might be useful to add a comment to that function saying that out
loud so that dolts like me will pick up on why it's critical for it to
be an inline function.

I like how this is going. :)

> iomap_iter() uses ->iomap_next() when the filesystem provides that
> callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
> path, so filesystems can be converted one at a time.

> Add a iomap_process() inline helper that does most of the logic needed
> in an ->iomap_next() implementation.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/iomap/iter.c       | 113 ++++++++++++++++++++++++++++++++++++------
>  include/linux/iomap.h |  91 +++++++++++++++++++++++++++-------
>  2 files changed, 171 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index e4a29829591a..1062e4e34c38 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -39,22 +39,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
>  		trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);
>  }
>  
> -/**
> - * iomap_iter - iterate over a ranges in a file
> - * @iter: iteration structue
> - * @ops: iomap ops provided by the file system
> - *
> - * Iterate over filesystem-provided space mappings for the provided file range.
> - *
> - * This function handles cleanup of resources acquired for iteration when the
> - * filesystem indicates there are no more space mappings, which means that this
> - * function must be called in a loop that continues as long it returns a
> - * positive value.  If 0 or a negative value is returned, the caller must not
> - * return to the loop body.  Within a loop body, there are two ways to break out
> - * of the loop body:  leave @iter.status unchanged, or set it to a negative
> - * errno.
> - */
> -int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +static int iomap_iter_legacy(struct iomap_iter *iter, const struct iomap_ops *ops)
>  {
>  	bool stale = iter->iomap.flags & IOMAP_F_STALE;
>  	ssize_t advanced;
> @@ -114,3 +99,99 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  	iomap_iter_done(iter);
>  	return 1;
>  }
> +
> +static int iomap_iter_next(struct iomap_iter *iter, const struct iomap_ops *ops)
> +{
> +	int ret;
> +
> +	trace_iomap_iter(iter, ops, _RET_IP_);
> +
> +	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
> +	iter->status = 0;
> +	if (ret > 0)
> +		iomap_iter_done(iter);
> +
> +	return ret;
> +}
> +
> +/**
> + * iomap_iter - iterate over a ranges in a file
> + * @iter: iteration structue
> + * @ops: iomap ops provided by the file system
> + *
> + * Iterate over filesystem-provided space mappings for the provided file range.
> + *
> + * This function handles cleanup of resources acquired for iteration when the
> + * filesystem indicates there are no more space mappings, which means that this
> + * function must be called in a loop that continues as long it returns a
> + * positive value.  If 0 or a negative value is returned, the caller must not
> + * return to the loop body.  Within a loop body, there are two ways to break out
> + * of the loop body:  leave @iter.status unchanged, or set it to a negative
> + * errno.
> + */
> +int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +{
> +	if (ops->iomap_next)
> +		return iomap_iter_next(iter, ops);
> +
> +	return iomap_iter_legacy(iter, ops);
> +}
> +
> +/**
> + * iomap_iter_continue - decide whether iteration should continue
> + * @iter: iteration structure
> + * @iomap: the mapping that was just processed
> + * @srcmap: the source mapping that was just processed
> + *
> + * Helper for ->iomap_next() implementations, normally called via
> + * iomap_process().  Called after the previous mapping has been finished to
> + * determine whether there is more of the file range left to process.
> + *
> + * Returns 1 if there is more work to do, in which case @iomap and @srcmap are
> + * cleared so the caller can produce the next mapping; zero if the range is
> + * fully consumed; or a negative errno on error.  Any folio batch attached to
> + * the mapping is released before returning.
> + */
> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap, int ret)
> +{
> +	bool stale = iomap->flags & IOMAP_F_STALE;
> +	ssize_t advanced = iter->pos - iter->iter_start_pos;

These both could be const, right?

--D

> +
> +	if (!iomap->length)
> +		return 1;
> +
> +	/*
> +	 * Use iter->len to determine whether to continue onto the next mapping.
> +	 * Explicitly terminate on error status or if the current iter has not
> +	 * advanced at all (i.e. no work was done for some reason) unless the
> +	 * mapping has been marked stale and needs to be reprocessed.
> +	 */
> +	if (ret < 0 && !advanced)
> +		return ret;
> +
> +	/* detect old return semantics where this would advance */
> +	if (WARN_ON_ONCE(iter->status > 0))
> +		ret = -EIO;
> +	else if (iter->status < 0)
> +		ret = iter->status;
> +	else if (iter->len == 0 || (!advanced && !stale))
> +		ret = 0;
> +	else
> +		ret = 1;
> +
> +	if (iomap->flags & IOMAP_F_FOLIO_BATCH) {
> +		folio_batch_release(iter->fbatch);
> +		folio_batch_reinit(iter->fbatch);
> +		iomap->flags &= ~IOMAP_F_FOLIO_BATCH;
> +	}
> +
> +	if (ret <= 0)
> +		return ret;
> +
> +	memset(iomap, 0, sizeof(*iomap));
> +	memset(srcmap, 0, sizeof(*srcmap));
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iomap_iter_continue);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3582ed1fe236..8a78f47c557b 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -212,24 +212,35 @@ struct iomap_write_ops {
>  #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
>  #define IOMAP_DONTCACHE		(1 << 10)
>  
> -struct iomap_ops {
> -	/*
> -	 * Return the existing mapping at pos, or reserve space starting at
> -	 * pos for up to length, as long as we can do it as a single mapping.
> -	 * The actual length is returned in iomap->length.
> -	 */
> -	int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
> -			unsigned flags, struct iomap *iomap,
> -			struct iomap *srcmap);
> +/*
> + * Return the existing mapping at pos, or reserve space starting at pos for up
> + * to length, as long as we can do it as a single mapping.
> + * The actual length is returned in iomap->length.
> + */
> +typedef int (*iomap_begin_fn)(struct inode *inode, loff_t pos, loff_t length,
> +		unsigned flags, struct iomap *iomap, struct iomap *srcmap);
>  
> -	/*
> -	 * Commit and/or unreserve space previous allocated using iomap_begin.
> -	 * Written indicates the length of the successful write operation which
> -	 * needs to be commited, while the rest needs to be unreserved.
> -	 * Written might be zero if no data was written.
> -	 */
> -	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
> -			ssize_t written, unsigned flags, struct iomap *iomap);
> +/*
> + * Commit and/or unreserve space previous allocated using iomap_begin.
> + * Written indicates the length of the successful write operation which needs
> + * to be commited, while the rest needs to be unreserved.
> + * Written might be zero if no data was written.
> + */
> +typedef int (*iomap_end_fn)(struct inode *inode, loff_t pos, loff_t length,
> +		ssize_t written, unsigned flags, struct iomap *iomap);
> +
> +/*
> + * Produce the next mapping (finishing the previous one if needed).
> + * Return 1 to continue iterating, 0 if the range is fully consumed, or a
> + * negative error on failure.
> + */
> +typedef int (*iomap_next_fn)(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap);
> +
> +struct iomap_ops {
> +	iomap_begin_fn iomap_begin;
> +	iomap_end_fn iomap_end;
> +	iomap_next_fn iomap_next;
>  };
>  
>  /**
> @@ -317,6 +328,9 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
>  	return &i->iomap;
>  }
>  
> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap, int ret);
> +
>  /*
>   * Return the file offset for the first unchanged block after a short write.
>   *
> @@ -648,4 +662,47 @@ static inline void iomap_bio_readahead(struct readahead_control *rac,
>  }
>  #endif /* CONFIG_BLOCK */
>  
> +/**
> + * iomap_process - finish the previous mapping and produce the next one
> + * @iter: iteration structure
> + * @iomap: mapping to finish and then repopulate
> + * @srcmap: source mapping to finish and then repopulate
> + * @begin: callback that produces a mapping for the current position
> + * @end: optional callback that finishes the previous mapping, or NULL
> + *
> + * Inline helper that implements the common body of an ->iomap_next()
> + * callback: it finishes the previous mapping via @end (if present), decides
> + * via iomap_iter_continue() whether to keep going, and obtains the next
> + * mapping via @begin.
> + *
> + * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
> + * negative errno on error.
> + */
> +static __always_inline int iomap_process(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap, iomap_begin_fn begin,
> +		iomap_end_fn end)
> +{
> +	int ret = 0;
> +
> +	if (iomap->length && end) {
> +		ssize_t advanced = iter->pos - iter->iter_start_pos;
> +		loff_t len;
> +
> +		len = iomap_length_trim(iter, iter->iter_start_pos,
> +				iter->len + advanced);
> +
> +		ret = end(iter->inode, iter->iter_start_pos, len, advanced,
> +				iter->flags, iomap);
> +	}
> +
> +	ret = iomap_iter_continue(iter, iomap, srcmap, ret);
> +	if (ret <= 0)
> +		return ret;
> +
> +	ret = begin(iter->inode, iter->pos, iter->len, iter->flags, iomap,
> +			srcmap);
> +
> +	return ret < 0 ? ret : 1;
> +}
> +
>  #endif /* LINUX_IOMAP_H */
> -- 
> 2.52.0
> 
> 

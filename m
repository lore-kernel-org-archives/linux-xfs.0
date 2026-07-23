Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B007F364022;
	Thu, 23 Jul 2026 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825011; cv=none; b=ZZLkRytl0woeMxrWRSHY9lfRzTzdCkV21d8DNoQHzlaiMlskaJ+9gXcX/RmTqSzQ0E5X3wz8ilf19kjF1U1zYO5HZlf9kVCmSIfsJwogJzmhFjLlc9WszdRricRjPOsjTxGH9rw8nG663xoQO2bUH5Bv5gDPpMcwWOI3ghTiQfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825011; c=relaxed/simple;
	bh=MTTpTdx0oR5CP6fzZ05DW1h3S/+X+8T7C8B5KBCnpLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOuuzmLmQYiqLoIdFdt+3PZMnMWIhj3/kdMAM3tBSfARSiZ9c6kobiZveqkAulzg0+sz08rRI9QB+pPQwdtiIqy+FDfzvneabmgBTtNslfiP+NjJTd44zgRxr2N926vqstyysqlFpw/xVxozRETOQAWQ4h4322vt7gC+tlM2C50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUoQbfjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUoQbfjI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E0A51F000E9;
	Thu, 23 Jul 2026 16:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784825009;
	bh=pzzhfqWVmJLeOJpMrJBO7yUDmA0I6V76qoaEbG2KeAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lUoQbfjIPGTcrZrpNPiIehhry0CsMm+lYAyomEgoko0PHNSDqwgSuAdGbN0Z3E6DZ
	 IqUw7dcMnw5w7OmslrCZYVuS2O7N8XPKon/4R9KTyRrjmsOEfk7oF028qb0RVSsXJk
	 Ki2R03L+q9LlcseiVPylsGGTe1WdMH41tp8qlinNw2AnAERBQlOJDYFkCFJB6hrn2V
	 sd6iRG+Vq3Ufn6DZgJa3FkZezGREyFvVVX+4PE7mRr1mQBBWxBFOh4dBNpQssDbZ8S
	 PfHZJnXLmwhdL06WOcoVHWBdMrex3Q59N//rKguyMsF36dTTMcXozfCl59FULCMeXM
	 wZTf7oNSCKG2A==
Date: Thu, 23 Jul 2026 09:43:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, Joanne Koong <joannelkoong@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: split iomap_iter() logic into
 iomap_iter_next()
Message-ID: <20260723164328.GD7380@frogsfrogsfrogs>
References: <20260723050201.3381045-1-hch@lst.de>
 <20260723050201.3381045-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723050201.3381045-2-hch@lst.de>

On Thu, Jul 23, 2026 at 07:01:39AM +0200, Christoph Hellwig wrote:
> From: Joanne Koong <joannelkoong@gmail.com>
> 
> In preparation for changing iomap to use an in-iter (->iomap_next())
> model, move the iomap_iter() logic out into the new iomap_iter_next()
> helper function.
> 
> iomap_iter_next() is added as an inlined helper so it can be called
> directly by ->iomap_next() implementations where the begin()/end()
> callbacks can be direct calls.
> 
> The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
> also provided to generate the boilerplate ->iomap_next() wrapper
> functions that simply forward to iomap_iter_next() with the appropriate
> begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
> where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
> the case where there is an explicit end() callback.
> 
> No functional change intended. The only code-level difference is that on
> the iomap_end() error path (ret < 0 && !advanced), the old code returned
> with iter.status left as the caller's last value whereas the new code
> zeroes it, but this is not observable in practice as there are no in-tree
> callers that read iter.status after the iteration loop.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Looks good to me now.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/iter.c       | 123 +++++++++++++++++++++---------------------
>  include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
>  2 files changed, 147 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index e4a29829591a..66ccb87441ab 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -6,15 +6,6 @@
>  #include <linux/iomap.h>
>  #include "trace.h"
>  
> -static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
> -{
> -	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
> -		folio_batch_release(iter->fbatch);
> -		folio_batch_reinit(iter->fbatch);
> -		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
> -	}
> -}
> -
>  /* Advance the current iterator position and decrement the remaining length */
>  int iomap_iter_advance(struct iomap_iter *iter, u64 count)
>  {
> @@ -40,51 +31,28 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
>  }
>  
>  /**
> - * iomap_iter - iterate over a ranges in a file
> - * @iter: iteration structue
> - * @ops: iomap ops provided by the file system
> + * iomap_iter_continue - decide whether iteration should continue
> + * @iter: iteration structure
> + * @iomap: the mapping that was just processed
> + * @srcmap: the source mapping that was just processed
>   *
> - * Iterate over filesystem-provided space mappings for the provided file range.
> + * Helper normally called via iomap_iter_next(). Called after the previous
> + * mapping has been finished to determine whether there is more of the file
> + * range left to process.
>   *
> - * This function handles cleanup of resources acquired for iteration when the
> - * filesystem indicates there are no more space mappings, which means that this
> - * function must be called in a loop that continues as long it returns a
> - * positive value.  If 0 or a negative value is returned, the caller must not
> - * return to the loop body.  Within a loop body, there are two ways to break out
> - * of the loop body:  leave @iter.status unchanged, or set it to a negative
> - * errno.
> + * Returns 1 if there is more work to do, in which case @iomap and @srcmap are
> + * cleared so the caller can produce the next mapping; zero if the range is
> + * fully consumed; or a negative errno on error. Any folio batch attached to
> + * the mapping is released before returning.
>   */
> -int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap, int ret)
>  {
> -	bool stale = iter->iomap.flags & IOMAP_F_STALE;
> -	ssize_t advanced;
> -	u64 olen;
> -	int ret;
> -
> -	trace_iomap_iter(iter, ops, _RET_IP_);
> -
> -	if (!iter->iomap.length)
> -		goto begin;
> -
> -	/*
> -	 * Calculate how far the iter was advanced and the original length bytes
> -	 * for ->iomap_end().
> -	 */
> -	advanced = iter->pos - iter->iter_start_pos;
> -	olen = iter->len + advanced;
> -
> -	if (ops->iomap_end) {
> -		ret = ops->iomap_end(iter->inode, iter->iter_start_pos,
> -				iomap_length_trim(iter, iter->iter_start_pos,
> -						  olen),
> -				advanced, iter->flags, &iter->iomap);
> -		if (ret < 0 && !advanced)
> -			return ret;
> -	}
> +	const bool stale = iomap->flags & IOMAP_F_STALE;
> +	const ssize_t advanced = iter->pos - iter->iter_start_pos;
>  
> -	/* detect old return semantics where this would advance */
> -	if (WARN_ON_ONCE(iter->status > 0))
> -		iter->status = -EIO;
> +	if (ret < 0 && !advanced)
> +		return ret;
>  
>  	/*
>  	 * Use iter->len to determine whether to continue onto the next mapping.
> @@ -92,25 +60,58 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  	 * advanced at all (i.e. no work was done for some reason) unless the
>  	 * mapping has been marked stale and needs to be reprocessed.
>  	 */
> -	if (iter->status < 0)
> +	if (WARN_ON_ONCE(iter->status > 0))
> +		/* detect old return semantics where this would advance */
> +		ret = -EIO;
> +	else if (iter->status < 0)
>  		ret = iter->status;
>  	else if (iter->len == 0 || (!advanced && !stale))
>  		ret = 0;
>  	else
>  		ret = 1;
> -	iomap_iter_clean_fbatch(iter);
> -	iter->status = 0;
> +
> +	if (iomap->flags & IOMAP_F_FOLIO_BATCH) {
> +		folio_batch_release(iter->fbatch);
> +		folio_batch_reinit(iter->fbatch);
> +		iomap->flags &= ~IOMAP_F_FOLIO_BATCH;
> +	}
> +
>  	if (ret <= 0)
>  		return ret;
>  
> -	memset(&iter->iomap, 0, sizeof(iter->iomap));
> -	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> +	memset(iomap, 0, sizeof(*iomap));
> +	memset(srcmap, 0, sizeof(*srcmap));
>  
> -begin:
> -	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
> -			       &iter->iomap, &iter->srcmap);
> -	if (ret < 0)
> -		return ret;
> -	iomap_iter_done(iter);
> -	return 1;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iomap_iter_continue);
> +
> +/**
> + * iomap_iter - iterate over ranges in a file
> + * @iter: iteration structure
> + * @ops: iomap ops provided by the filesystem
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
> +	int ret;
> +
> +	trace_iomap_iter(iter, ops, _RET_IP_);
> +
> +	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
> +			ops->iomap_begin, ops->iomap_end);
> +	iter->status = 0;
> +	if (ret > 0)
> +		iomap_iter_done(iter);
> +
> +	return ret;
>  }
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3582ed1fe236..3df851d0f76b 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -212,24 +212,27 @@ struct iomap_write_ops {
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
> +typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
> +		loff_t length, unsigned flags, struct iomap *iomap,
> +		struct iomap *srcmap);
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
> + * Commit and/or unreserve space previously allocated by iomap_iter_begin_fn.
> + * Written indicates the length of the successful write operation which needs
> + * to be committed, while the rest needs to be unreserved.
> + * Written might be zero if no data was written.
> + */
> +typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
> +		ssize_t written, unsigned flags, struct iomap *iomap);
> +
> +struct iomap_ops {
> +	iomap_iter_begin_fn iomap_begin;
> +	iomap_iter_end_fn iomap_end;
>  };
>  
>  /**
> @@ -317,6 +320,71 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
>  	return &i->iomap;
>  }
>  
> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
> +		struct iomap *srcmap, int ret);
> +
> +/**
> + * iomap_iter_next - finish the previous mapping and produce the next one
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
> + * This helper is marked __always_inline so that when a caller passes
> + * compile-time-constant @begin and @end callbacks, the compiler can call them
> + * directly, avoiding the indirect-call overhead.
> + *
> + * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
> + * negative errno on error.
> + */
> +static __always_inline int iomap_iter_next(const struct iomap_iter *iter,
> +		struct iomap *iomap, struct iomap *srcmap,
> +		iomap_iter_begin_fn begin, iomap_iter_end_fn end)
> +{
> +	int ret = 0;
> +
> +	if (iomap->length) {
> +		if (end) {
> +			/*
> +			 * Calculate how far the iter was advanced and the
> +			 * original length bytes for end().
> +			 */
> +			ssize_t advanced = iter->pos - iter->iter_start_pos;
> +			loff_t len;
> +
> +			len = iomap_length_trim(iter, iter->iter_start_pos,
> +					iter->len + advanced);
> +
> +			ret = end(iter->inode, iter->iter_start_pos, len,
> +					advanced, iter->flags, iomap);
> +		}
> +		ret = iomap_iter_continue(iter, iomap, srcmap, ret);
> +		if (ret <= 0)
> +			return ret;
> +	}
> +
> +	ret = begin(iter->inode, iter->pos, iter->len, iter->flags, iomap,
> +			srcmap);
> +
> +	return ret < 0 ? ret : 1;
> +}
> +
> +#define DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, end_fn)		\
> +int name(const struct iomap_iter *iter, struct iomap *iomap,		\
> +		struct iomap *srcmap)					\
> +{									\
> +	return iomap_iter_next(iter, iomap, srcmap, begin_fn, end_fn);	\
> +}
> +
> +#define DEFINE_IOMAP_ITER_NEXT(name, begin_fn)				\
> +	DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, NULL)
> +
>  /*
>   * Return the file offset for the first unchanged block after a short write.
>   *
> -- 
> 2.53.0
> 
> 

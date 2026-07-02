Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E886318EC5;
	Thu,  2 Jul 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011107; cv=none; b=p6MhwviuSdqslV0D0Kfn/CeKIQKG6xYg9u5MmlCOV7/yzJtEt2dU7KFa5yEsURjewdFRlI2jIXJttprw7lOkV4q1paUXbO64N9GLv9T+TYEcJZLCGrpX4vi4CDBwlJN2AOxMtLKM7KTRCUla1sjxAkvDkISDaGtP/PhBrDqDjS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011107; c=relaxed/simple;
	bh=nlkb5QSgZEo5ddZ4GiOEvImLZNwNVOBr0lo1Wphn0pY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+ckay8FIOKC8QzDh3OxOLDQQwfIXoWHoHr65mX9Z7vMbR22NdfDvaRzipJ3A07U2iwhfMWxLDb+l6H5InG4o7EulHKuia3QPpIRmRPudYLc3rFYKoCI/xAxNMP+LIhEsywBF3DR+hgavz9aiCnoI30McBItD5/tNe5XZzaSUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MBt6qSsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MBt6qSsm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6085A1F000E9;
	Thu,  2 Jul 2026 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011106;
	bh=nbaNpLRlMIlEe3KC0+ug0SaMQ1/Dk2+riEadlyDDhNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MBt6qSsmxzhjp5VSaUW939eZk2nHYx8cbx3WpKoE/kXBBkZ7LVTo5XgEeSmEC9vrQ
	 fUCh5MWgxYalCd06JrOnfO3ne+xILfLmpIOxViWlQL3LbKpvI3kLhtOru5nthmGuxB
	 1u8yIh4a7WupBw/iIrFyIk7aLhytLQTWNrclwvonkwzruUBTOPlPtcWeYHLU+sqIDn
	 kakGF1ac9Pq54hC2im+Pt+HGAZb3SmLaGrdfmVvhGxW2QGR+XSC1SF+fVVn/K8L07Z
	 z7KAiiP1chwRwpUtn4RMXzdvZz/BhzgOKRk1C03l5Mm02CNqHsWvXbMOm2zaMviL5k
	 qMcsLwn//+h4g==
Date: Thu, 2 Jul 2026 09:51:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/18] iomap: remove ->iomap_begin()/->iomap_end()
 legacy path
Message-ID: <20260702165146.GL9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-17-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-17-joannelkoong@gmail.com>

On Tue, Jun 30, 2026 at 05:09:31PM -0700, Joanne Koong wrote:
> With all in-tree filesystems implementing ->iomap_next(), drop the
> ->iomap_begin()/->iomap_end() path.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Yeah, the legacy path can go away. :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/iter.c       | 87 +++++--------------------------------------
>  include/linux/iomap.h |  4 +-
>  2 files changed, 11 insertions(+), 80 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index 1062e4e34c38..466c491bdef6 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -39,81 +39,6 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
>  		trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);
>  }
>  
> -static int iomap_iter_legacy(struct iomap_iter *iter, const struct iomap_ops *ops)
> -{
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
> -
> -	/* detect old return semantics where this would advance */
> -	if (WARN_ON_ONCE(iter->status > 0))
> -		iter->status = -EIO;
> -
> -	/*
> -	 * Use iter->len to determine whether to continue onto the next mapping.
> -	 * Explicitly terminate on error status or if the current iter has not
> -	 * advanced at all (i.e. no work was done for some reason) unless the
> -	 * mapping has been marked stale and needs to be reprocessed.
> -	 */
> -	if (iter->status < 0)
> -		ret = iter->status;
> -	else if (iter->len == 0 || (!advanced && !stale))
> -		ret = 0;
> -	else
> -		ret = 1;
> -	iomap_iter_clean_fbatch(iter);
> -	iter->status = 0;
> -	if (ret <= 0)
> -		return ret;
> -
> -	memset(&iter->iomap, 0, sizeof(iter->iomap));
> -	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
> -
> -begin:
> -	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
> -			       &iter->iomap, &iter->srcmap);
> -	if (ret < 0)
> -		return ret;
> -	iomap_iter_done(iter);
> -	return 1;
> -}
> -
> -static int iomap_iter_next(struct iomap_iter *iter, const struct iomap_ops *ops)
> -{
> -	int ret;
> -
> -	trace_iomap_iter(iter, ops, _RET_IP_);
> -
> -	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
> -	iter->status = 0;
> -	if (ret > 0)
> -		iomap_iter_done(iter);
> -
> -	return ret;
> -}
> -
>  /**
>   * iomap_iter - iterate over a ranges in a file
>   * @iter: iteration structue
> @@ -131,10 +56,16 @@ static int iomap_iter_next(struct iomap_iter *iter, const struct iomap_ops *ops)
>   */
>  int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  {
> -	if (ops->iomap_next)
> -		return iomap_iter_next(iter, ops);
> +	int ret;
> +
> +	trace_iomap_iter(iter, ops, _RET_IP_);
>  
> -	return iomap_iter_legacy(iter, ops);
> +	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
> +	iter->status = 0;
> +	if (ret > 0)
> +		iomap_iter_done(iter);
> +
> +	return ret;
>  }
>  
>  /**
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 8a78f47c557b..52d6f585b941 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -194,7 +194,7 @@ struct iomap_write_ops {
>  };
>  
>  /*
> - * Flags for iomap_begin / iomap_end.  No flag implies a read.
> + * Flags for iomap_next.  No flag implies a read.
>   */
>  #define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
>  #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
> @@ -254,7 +254,7 @@ struct iomap_ops {
>   *	incremental iter advance.
>   * @status: Status of the most recent iteration. Zero on success or a negative
>   *	errno on error.
> - * @flags: Zero or more of the iomap_begin flags above.
> + * @flags: Zero or more of the iomap_next flags above.
>   * @iomap: Map describing the I/O iteration
>   * @srcmap: Source map for COW operations
>   */
> -- 
> 2.52.0
> 
> 

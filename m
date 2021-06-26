Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A1BC2B9F4
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Jun 2021 02:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B5796196E
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Jun 2021 02:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhFZCId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 22:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229906AbhFZCId (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 22:08:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECEF16157E;
        Sat, 26 Jun 2021 02:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624673172;
        bh=jA9QkEvjdNKpYi0nRotkBVzsoBLSoQPnm2z8SON/rbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GyupCat/s8kliaP4fXaLJZYQCyGJm3Gp0XBsk6rVbt9jen0ldmrdM39TB9jS0YAz2
         6bp9F4tLyHI7b9tN50w03XhNHlPRsYwFOtW6/Ymxpnj+kt91wAasdGqQKdfGKY0jfv
         MULoQ7sK1ipvNQ4gu95OG1rX2I2SAafdNRGz6JMCNoDmuVBFC0pZUedEbLQNytM7kz
         RNPYalG1X4hnYudYAlZ8wVJmj6eypofKqAH3v7bFTBbWp2jB+4aZKjbpcQRZSBMXj2
         Q0FW0ziaTOtqo4/MnNjEUWG5GYzflX0etDEoe+YMobqlNsE6VIwcbAIrcHpvuFmZAU
         1bvwPxAYxnXsg==
Date:   Fri, 25 Jun 2021 19:06:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: replace kmem_alloc_large() with kvmalloc()
Message-ID: <20210626020611.GI13784@locust>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625023029.1472466-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 25, 2021 at 12:30:29PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is no reason for this wrapper existing anymore. All the places
> that use KM_NOFS allocation are within transaction contexts and
> hence covered by memalloc_nofs_save/restore contexts. Hence we don't
> need any special handling of vmalloc for large IOs anymore and
> so special casing this code isn't necessary.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/kmem.c                 | 39 -----------------------------------
>  fs/xfs/kmem.h                 |  1 -
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/scrub/attr.c           | 14 +++++++------
>  fs/xfs/scrub/attr.h           |  3 ---
>  fs/xfs/xfs_log.c              |  4 ++--
>  fs/xfs/xfs_log_cil.c          | 10 ++++++++-
>  fs/xfs/xfs_log_recover.c      |  2 +-
>  fs/xfs/xfs_trace.h            |  1 -
>  9 files changed, 21 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 3f2979fd2f2b..6f49bf39183c 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -29,42 +29,3 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	} while (1);
>  }
> -
> -
> -/*
> - * __vmalloc() will allocate data pages and auxiliary structures (e.g.
> - * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
> - * we need to tell memory reclaim that we are in such a context via
> - * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
> - * and potentially deadlocking.
> - */
> -static void *
> -__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
> -{
> -	unsigned nofs_flag = 0;
> -	void	*ptr;
> -	gfp_t	lflags = kmem_flags_convert(flags);
> -
> -	if (flags & KM_NOFS)
> -		nofs_flag = memalloc_nofs_save();
> -
> -	ptr = __vmalloc(size, lflags);
> -
> -	if (flags & KM_NOFS)
> -		memalloc_nofs_restore(nofs_flag);
> -
> -	return ptr;
> -}
> -
> -void *
> -kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> -{
> -	void	*ptr;
> -
> -	trace_kmem_alloc_large(size, flags, _RET_IP_);
> -
> -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> -	if (ptr)
> -		return ptr;
> -	return __kmem_vmalloc(size, flags);
> -}
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 9ff20047f8b8..54da6d717a06 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -57,7 +57,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  }
>  
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> -extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
>  {
>  	kvfree(ptr);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b910bd209949..16d64872acc0 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -489,7 +489,7 @@ xfs_attr_copy_value(
>  	}
>  
>  	if (!args->value) {
> -		args->value = kmem_alloc_large(valuelen, KM_NOLOCKDEP);
> +		args->value = kvmalloc(valuelen, GFP_KERNEL | __GFP_NOLOCKDEP);
>  		if (!args->value)
>  			return -ENOMEM;
>  	}
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 552af0cf8482..6c36af6dbd35 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -25,11 +25,11 @@
>   * reallocating the buffer if necessary.  Buffer contents are not preserved
>   * across a reallocation.
>   */
> -int
> +static int
>  xchk_setup_xattr_buf(
>  	struct xfs_scrub	*sc,
>  	size_t			value_size,
> -	xfs_km_flags_t		flags)
> +	gfp_t			flags)
>  {
>  	size_t			sz;
>  	struct xchk_xattr_buf	*ab = sc->buf;
> @@ -57,7 +57,7 @@ xchk_setup_xattr_buf(
>  	 * Don't zero the buffer upon allocation to avoid runtime overhead.
>  	 * All users must be careful never to read uninitialized contents.
>  	 */
> -	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
> +	ab = kvmalloc(sizeof(*ab) + sz, flags);
>  	if (!ab)
>  		return -ENOMEM;
>  
> @@ -79,7 +79,7 @@ xchk_setup_xattr(
>  	 * without the inode lock held, which means we can sleep.
>  	 */
>  	if (sc->flags & XCHK_TRY_HARDER) {
> -		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, 0);
> +		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, GFP_KERNEL);
>  		if (error)
>  			return error;
>  	}
> @@ -138,7 +138,8 @@ xchk_xattr_listent(
>  	 * doesn't work, we overload the seen_enough variable to convey
>  	 * the error message back to the main scrub function.
>  	 */
> -	error = xchk_setup_xattr_buf(sx->sc, valuelen, KM_MAYFAIL);
> +	error = xchk_setup_xattr_buf(sx->sc, valuelen,
> +			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (error == -ENOMEM)
>  		error = -EDEADLOCK;
>  	if (error) {
> @@ -323,7 +324,8 @@ xchk_xattr_block(
>  		return 0;
>  
>  	/* Allocate memory for block usage checking. */
> -	error = xchk_setup_xattr_buf(ds->sc, 0, KM_MAYFAIL);
> +	error = xchk_setup_xattr_buf(ds->sc, 0,
> +			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (error == -ENOMEM)
>  		return -EDEADLOCK;
>  	if (error)
> diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
> index 13a1d2e8424d..1719e1c4da59 100644
> --- a/fs/xfs/scrub/attr.h
> +++ b/fs/xfs/scrub/attr.h
> @@ -65,7 +65,4 @@ xchk_xattr_dstmap(
>  			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
>  }
>  
> -int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size,
> -		xfs_km_flags_t flags);
> -
>  #endif	/* __XFS_SCRUB_ATTR_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 404970a4343c..6cc51b0cb99e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1462,8 +1462,8 @@ xlog_alloc_log(
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
>  
> -		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
> -						KM_MAYFAIL | KM_ZERO);
> +		iclog->ic_data = kvzalloc(log->l_iclog_size,
> +				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
>  #ifdef DEBUG
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3c2b1205944d..bf9d747352df 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -185,7 +185,15 @@ xlog_cil_alloc_shadow_bufs(
>  			 */
>  			kmem_free(lip->li_lv_shadow);
>  
> -			lv = kmem_alloc_large(buf_size, KM_NOFS);
> +			/*
> +			 * We are in transaction context, which means this
> +			 * allocation will pick up GFP_NOFS from the
> +			 * memalloc_nofs_save/restore context the transaction
> +			 * holds. This means we can use GFP_KERNEL here so the
> +			 * generic kvmalloc() code will run vmalloc on
> +			 * contiguous page allocation failure as we require.
> +			 */
> +			lv = kvmalloc(buf_size, GFP_KERNEL);
>  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
>  
>  			lv->lv_item = lip;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index cc559815e08f..1a291bf50776 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -106,7 +106,7 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL | KM_ZERO);
> +	return kvzalloc(BBTOB(nbblks), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 6865e838a71b..38f2f67303f7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3689,7 +3689,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
>  	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
>  	TP_ARGS(size, flags, caller_ip))
>  DEFINE_KMEM_EVENT(kmem_alloc);
> -DEFINE_KMEM_EVENT(kmem_alloc_large);
>  
>  TRACE_EVENT(xfs_check_new_dalign,
>  	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> -- 
> 2.31.1
> 

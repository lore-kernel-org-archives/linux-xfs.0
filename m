Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA35C2B9F4
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Jun 2021 02:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F01D6196E
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Jun 2021 02:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhFZCEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 22:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhFZCEH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 22:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E1826194B;
        Sat, 26 Jun 2021 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624672906;
        bh=7lj1wJ8aXwILaejhB67DJ9JA/rD3ghlBZV8kLV7rAx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IcKWvO9nDOy6y9CgYnIGelRKStZ1/jnHvlEbAzK0osyIKcuc9p5mdnqjAGI2jytn4
         BX+dYC4uezHikHTNkjIK15nkIIx8FU0gnasEKG/vua9rNiOi8ryOyifUoGrAfAT+wl
         A1BV2kZKj3JjrnaP7kfn/9rJAcMGFbZv1q+sx9PLDUAcs/aFl93teTnNHQ5A3wZ223
         Zj+n4RXV8TvFT1ahWZ8Mbxuta050Kwlkg63pYIVGQI4W3yP+Ano6guND5XJ/kZF5Qg
         BFMchMDmggHN6oHyR17KTUs7t17i0xyypq7sHKEJdN/EWvULxYRv0wbDOEhJxHgYxm
         UI/GAGV8c484w==
Date:   Fri, 25 Jun 2021 19:01:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: remove kmem_alloc_io()
Message-ID: <20210626020145.GH13784@locust>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625023029.1472466-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 25, 2021 at 12:30:28PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
> for kmalloc(power-of-two)"), the core slab code now guarantees slab
> alignment in all situations sufficient for IO purposes (i.e. minimum
> of 512 byte alignment of >= 512 byte sized heap allocations) we no
> longer need the workaround in the XFS code to provide this
> guarantee.
> 
> Replace the use of kmem_alloc_io() with kmem_alloc() or
> kmem_alloc_large() appropriately, and remove the kmem_alloc_io()
> interface altogether.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/kmem.c            | 25 -------------------------
>  fs/xfs/kmem.h            |  1 -
>  fs/xfs/xfs_buf.c         |  3 +--
>  fs/xfs/xfs_log.c         |  3 +--
>  fs/xfs/xfs_log_recover.c |  4 +---
>  fs/xfs/xfs_trace.h       |  1 -
>  6 files changed, 3 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index e986b95d94c9..3f2979fd2f2b 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -56,31 +56,6 @@ __kmem_vmalloc(size_t size, xfs_km_flags_t flags)
>  	return ptr;
>  }
>  
> -/*
> - * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
> - * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
> - * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
> - * aligned region.
> - */
> -void *
> -kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
> -{
> -	void	*ptr;
> -
> -	trace_kmem_alloc_io(size, flags, _RET_IP_);
> -
> -	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
> -		align_mask = PAGE_SIZE - 1;
> -
> -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> -	if (ptr) {
> -		if (!((uintptr_t)ptr & align_mask))
> -			return ptr;
> -		kfree(ptr);
> -	}
> -	return __kmem_vmalloc(size, flags);
> -}
> -
>  void *
>  kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  {
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 38007117697e..9ff20047f8b8 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -57,7 +57,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  }
>  
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> -extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
>  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
>  static inline void  kmem_free(const void *ptr)
>  {
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8ff42b3585e0..a5ef1f9eb622 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -315,7 +315,6 @@ xfs_buf_alloc_kmem(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> -	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);

Is xfs_buftarg_dma_alignment unused now?

-or-

Should we trust that the memory allocators will always maintain at least
the current alignment guarantees, or actually check the alignment of the
returned buffer if CONFIG_XFS_DEBUG=y?

--D

>  	xfs_km_flags_t	kmflag_mask = KM_NOFS;
>  	size_t		size = BBTOB(bp->b_length);
>  
> @@ -323,7 +322,7 @@ xfs_buf_alloc_kmem(
>  	if (!(flags & XBF_READ))
>  		kmflag_mask |= KM_ZERO;
>  
> -	bp->b_addr = kmem_alloc_io(size, align_mask, kmflag_mask);
> +	bp->b_addr = kmem_alloc(size, kmflag_mask);
>  	if (!bp->b_addr)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e93cac6b5378..404970a4343c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1451,7 +1451,6 @@ xlog_alloc_log(
>  	 */
>  	ASSERT(log->l_iclog_size >= 4096);
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		int align_mask = xfs_buftarg_dma_alignment(mp->m_logdev_targp);
>  		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
>  				sizeof(struct bio_vec);
>  
> @@ -1463,7 +1462,7 @@ xlog_alloc_log(
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
>  
> -		iclog->ic_data = kmem_alloc_io(log->l_iclog_size, align_mask,
> +		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
>  						KM_MAYFAIL | KM_ZERO);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index fee4fbadea0a..cc559815e08f 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -79,8 +79,6 @@ xlog_alloc_buffer(
>  	struct xlog	*log,
>  	int		nbblks)
>  {
> -	int align_mask = xfs_buftarg_dma_alignment(log->l_targ);
> -
>  	/*
>  	 * Pass log block 0 since we don't have an addr yet, buffer will be
>  	 * verified on read.
> @@ -108,7 +106,7 @@ xlog_alloc_buffer(
>  	if (nbblks > 1 && log->l_sectBBsize > 1)
>  		nbblks += log->l_sectBBsize;
>  	nbblks = round_up(nbblks, log->l_sectBBsize);
> -	return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);
> +	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL | KM_ZERO);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9d8d605f9b1..6865e838a71b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3689,7 +3689,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
>  	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
>  	TP_ARGS(size, flags, caller_ip))
>  DEFINE_KMEM_EVENT(kmem_alloc);
> -DEFINE_KMEM_EVENT(kmem_alloc_io);
>  DEFINE_KMEM_EVENT(kmem_alloc_large);
>  
>  TRACE_EVENT(xfs_check_new_dalign,
> -- 
> 2.31.1
> 

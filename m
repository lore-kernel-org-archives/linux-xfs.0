Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CE940927A
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 07:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786692306; cv=none; b=GdkKyk/UJVlme1kIV6H0R9tvg5PKzrFQdMZFAa6jZ2g4VfX6qT0flyEDp7IVqId9GsGda3ZWQ7fhxA7FPVeTyE0f//uKeC4tU9yb76r+GkWYMjYv9ZUKkVnGdAs+6xdcCoDQPJSSW4/b4EHD2eCml0BQJwFe1tLHUkafNB0RSvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786692306; c=relaxed/simple;
	bh=hcumep/Zk4Yg+BXjbll3UfbKGxZemYod06jEvQDUAAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UJLi/CYr56iTOt1iDgqA8eRr6CYZX58xpa96Bm7eSJMIofu6yXDowrWhtYOlyorNGX89gFG7KJ6em4EA+m5A2lCl+Zr7b8H0Ufi/u/32EhvXkszLQbYF4StInFxT8v5A0vnAnQ66ArliYsJKBe5CCQlKEgbl0WucTApnSjOlX3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YbJ8UEqS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YbJ8UEqS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9yOs9kYzeSlKq0S9/5dhyVg+xcTBXyHYEJKRhv8XhK0=; b=YbJ8UEqS+yyXP/qJROa85BALOS
	dJsKfcChl5wxE++iuWb2tsBLpb8GNzexLBSpEO3g1cktaZQfYOh2OZiQ6InjKt4siWcm+34ZHfFbX
	4lgxAvpRWU0MBssKmXwrq7IqNToWeakan1NG4zgzUYkHIYQNA7IJXdV9AuC+unIl+dF1c5bA7K+H1
	/WHpGBbLUZsAC/HXDGsesUxUhzR+l6GJVg3Wz5tpHf0ZTkB+T+G+5mhP4IsZ+WEF5fctpLcObq+8N
	/HpOu0DdhpsfMeM/5xKrQRU6b4ou3WfGmZskeLsq1mniNxsvu9qFRyNRYUFZ3fLRXYo5WCF76FYyj
	InUyqAUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wumHo-000000028rg-2oTL;
	Fri, 14 Aug 2026 07:25:04 +0000
Date: Fri, 14 Aug 2026 00:25:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/2] xfs: count folio alloc'd xfs_buf items in
 NR_KERNEL_MISC_RECLAIMABLE
Message-ID: <an7C0L2PT-Ous0hn@infradead.org>
References: <20260813204929.2253988-1-sandeen@redhat.com>
 <20260813204929.2253988-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813204929.2253988-3-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 13, 2026 at 03:40:53PM -0500, Eric Sandeen wrote:
> xfs_buf allocations via xfs_buf_alloc_folio are actually reclaimable,
> but are not accounted for as such. NR_KERNEL_MISC_RECLAIMABLE seems
> made for this purpose, although AFAICT there are no users today.
> 
> To achieve this, add a new flag _XBF_PAGES to track what we have
> allocated this way, increment the NR_KERNEL_MISC_RECLAIMABLE
> count when we do, and then do the reverse when they are freed.

I don't see why we'd need the flag.  All buffers are either allocated
using vmalloc, kmalloc or as folios.  So it should always be set for
folio allocations (and is misnamed since it now covers folios as well).

> 
> These allocations now show up under nr_kernel_misc_reclaimable in
> /proc/vmstat when allocations are active, which in turn makes
> MemAvailable more accurate in /proc/meminfo.

Adding linux-mm and a few people that touched this counter for
opinions.  I guess the counter is only for full folios, and we
should not set it for the small than page kmalloc allocations?
But even with that, why not set it for the vmalloc allocations?

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 16 +++++++++++++---
>  fs/xfs/xfs_buf.h |  2 ++
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2e00a33ebb62..0a853ec361d0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -114,8 +114,15 @@ xfs_buf_free(
>  		vfree(bp->b_addr);
>  	else if (bp->b_flags & _XBF_KMEM)
>  		kfree(bp->b_addr);
> -	else if (bp->b_addr)
> -		folio_put(virt_to_folio(bp->b_addr));
> +	else if (bp->b_addr) {
> +		struct folio *folio = virt_to_folio(bp->b_addr);
> +
> +		if (bp->b_flags & _XBF_PAGES)
> +			mod_node_page_state(folio_pgdat(folio),
> +					NR_KERNEL_MISC_RECLAIMABLE,
> +					-folio_nr_pages(folio));
> +		folio_put(folio);
> +	}
>  
>  	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
>  }
> @@ -132,6 +139,9 @@ xfs_buf_alloc_folio(
>  	if (!folio)
>  		return -ENOMEM;
>  	bp->b_addr = folio_address(folio);
> +	bp->b_flags |= _XBF_PAGES;
> +	mod_node_page_state(folio_pgdat(folio), NR_KERNEL_MISC_RECLAIMABLE,
> +			folio_nr_pages(folio));
>  	trace_xfs_buf_backing_folio(bp, _RET_IP_);
>  	return 0;
>  }
> @@ -427,7 +437,7 @@ xfs_buf_find_lock(
>  			return -ENOENT;
>  		}
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM;
> +		bp->b_flags &= (_XBF_PAGES | _XBF_KMEM);
>  		bp->b_ops = NULL;
>  	}
>  	return 0;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 79cc9c3f0254..ba7bfafe67b6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -38,6 +38,7 @@ struct xfs_buf;
>  #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
>  
>  /* flags used only internally */
> +#define _XBF_PAGES	 (1u << 20)/* backed by folio/page allocator */
>  #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
>  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
>  
> @@ -62,6 +63,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
> +	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
>  	/* The following interface flags should never be set */ \
> -- 
> 2.55.0
> 
> 
---end quoted text---

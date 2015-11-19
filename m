Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18D1429DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 09:55:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 079CC8F8059
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:55:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MpKlDvtMFUDPospc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:55:27 -0800 (PST)
Date: Thu, 19 Nov 2015 10:55:25 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151119155525.GB13055@bfoster.bfoster>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> Naive implementation for non-mmu architectures: allocate physically
> contiguous xfs buffers with alloc_pages. Terribly inefficient with
> memory and fragmentation on high I/O loads but it may be good enough
> for basic usage (which most non-mmu architectures will need).
> 
> This patch was tested with lklfuse [1] and basic operations seems to
> work even with 16MB allocated for LKL.
> 
> [1] https://github.com/lkl/linux
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---

Interesting, though this makes me wonder why we couldn't have a new
_XBF_VMEM (for example) buffer type that uses vmalloc(). I'm not
familiar with mmu-less context, but I see that mm/nommu.c has a
__vmalloc() interface that looks like it ultimately translates into an
alloc_pages() call. Would that accomplish what this patch is currently
trying to do?

I ask because it seems like that would help clean up the code a bit, for
one. It might also facilitate some degree of testing of the XFS bits
(even if utilized sparingly in DEBUG mode if it weren't suitable enough
for generic/mmu use). We currently allocate and map the buffer pages
separately and I'm not sure if there's any particular reasons for doing
that outside of some congestion handling in the allocation code and
XBF_UNMAPPED buffers, the latter probably being irrelevant for nommu.
Any other thoughts on that?

>  fs/xfs/xfs_buf.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8ecffb3..50b5246 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
...
> @@ -816,11 +835,19 @@ xfs_buf_get_uncached(
>  	if (error)
>  		goto fail_free_buf;
>  
> +#ifdef CONFIG_MMU
>  	for (i = 0; i < page_count; i++) {
>  		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
>  		if (!bp->b_pages[i])
>  			goto fail_free_mem;
>  	}
> +#else
> +	bp->b_pages[0] = alloc_pages(flags, order_base_2(page_count));
> +	if (!bp->b_pages[0])
> +		goto fail_free_buf;
> +	for (i = 1; i < page_count; i++)
> +		bp->b_pages[i] = bp->b_pages[i-1] + 1;
> +#endif

We still have a path into __free_page() further down in this function if
_xfs_buf_map_pages() fails. Granted, _xfs_buf_map_pages() should
probably never fail in this case, but it still looks like a land mine at
the very least.

Brian

>  	bp->b_flags |= _XBF_PAGES;
>  
>  	error = _xfs_buf_map_pages(bp, 0);
> -- 
> 1.9.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

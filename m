Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE851C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01606139A
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 23:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhE0XCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 19:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0XCg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F206A6139A;
        Thu, 27 May 2021 23:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156463;
        bh=aIC7FltkRH+clP5hHDI4JTYbSsf7wD+O/qyh5p+k1oM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BBvn2LvPAsmX2rRIN0AzzsdsOVKM+GIgcrhCCTROOqd+NtU5thVt6imrSDfZzBMar
         MJLoy73u+cDoDkid3DM6Eq2tdB439R8KhT/ZU4wS4gYpm83ZaL7kY9T9a7l6aI0Kdz
         zB5OPAFDFI0/ykfbzfBfEJE4OV6PBWkvr0mJSAN2D3j9MUEZxhJV/dMKIQDe68afKt
         Ab4b9FsWSy+tqmK+Dmz9MXNZecnPZclTueFcLSA5K43jK1KqwHBAuHR/iDKNZ/JCy3
         p+kFz7szu3MmlTeIleVlo3mbJT37u35gPfKpbqnJlwPan8Nm6iu05OiT1r9DQJ95fx
         x2tjScggGgLZA==
Date:   Thu, 27 May 2021 16:01:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/10] xfs: use alloc_pages_bulk_array() for buffers
Message-ID: <20210527230102.GD2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-4-david@fromorbit.com>
 <20210527225951.GC2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527225951.GC2402049@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 03:59:51PM -0700, Darrick J. Wong wrote:
> On Thu, May 27, 2021 at 08:47:15AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because it's more efficient than allocating pages one at a time in a
> > loop.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 62 +++++++++++++++++++-----------------------------
> >  1 file changed, 24 insertions(+), 38 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index b1610115d401..8ca4add138c5 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -386,10 +386,7 @@ xfs_buf_alloc_pages(
> >  	xfs_buf_flags_t	flags)
> >  {
> >  	gfp_t		gfp_mask = xb_to_gfp(flags);
> > -	size_t		size;
> > -	size_t		offset;
> > -	size_t		nbytes;
> > -	int		i;
> > +	long		filled = 0;
> >  	int		error;
> >  
> >  	/* Assure zeroed buffer for non-read cases. */
> > @@ -400,50 +397,39 @@ xfs_buf_alloc_pages(
> >  	if (unlikely(error))
> >  		return error;
> >  
> > -	offset = bp->b_offset;
> >  	bp->b_flags |= _XBF_PAGES;
> >  
> > -	for (i = 0; i < bp->b_page_count; i++) {
> > -		struct page	*page;
> > -		uint		retries = 0;
> > -retry:
> > -		page = alloc_page(gfp_mask);
> > -		if (unlikely(page == NULL)) {
> > -			if (flags & XBF_READ_AHEAD) {
> > -				bp->b_page_count = i;
> > -				error = -ENOMEM;
> > -				goto out_free_pages;
> > -			}
> > +	/*
> > +	 * Bulk filling of pages can take multiple calls. Not filling the entire
> > +	 * array is not an allocation failure, so don't back off if we get at
> > +	 * least one extra page.
> > +	 */
> > +	for (;;) {
> > +		long	last = filled;
> >  
> > -			/*
> > -			 * This could deadlock.
> > -			 *
> > -			 * But until all the XFS lowlevel code is revamped to
> > -			 * handle buffer allocation failures we can't do much.
> > -			 */
> > -			if (!(++retries % 100))
> > -				xfs_err(NULL,
> > -		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
> > -					current->comm, current->pid,
> > -					__func__, gfp_mask);
> > -
> > -			XFS_STATS_INC(bp->b_mount, xb_page_retries);
> > -			congestion_wait(BLK_RW_ASYNC, HZ/50);
> > -			goto retry;
> > +		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
> > +						bp->b_pages);
> > +		if (filled == bp->b_page_count) {
> > +			XFS_STATS_INC(bp->b_mount, xb_page_found);
> > +			break;
> >  		}
> >  
> > -		XFS_STATS_INC(bp->b_mount, xb_page_found);
> > +		if (filled != last)
> > +			continue;
> >  
> > -		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
> > -		size -= nbytes;
> > -		bp->b_pages[i] = page;
> > -		offset = 0;
> > +		if (flags & XBF_READ_AHEAD) {
> > +			error = -ENOMEM;
> > +			goto out_free_pages;
> > +		}
> > +
> > +		XFS_STATS_INC(bp->b_mount, xb_page_retries);
> > +		congestion_wait(BLK_RW_ASYNC, HZ/50);
> 
> Nit: spaces around operators ("HZ / 50").
> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> I have a question about _xfs_buf_get_pages:

Never mind, you fixed all this in the next patch, which my grep didn't
find.  Question withdrawn.

--D

> 
> STATIC int
> _xfs_buf_get_pages(
> 	struct xfs_buf		*bp,
> 	int			page_count)
> {
> 	/* Make sure that we have a page list */
> 	if (bp->b_pages == NULL) {
> 		bp->b_page_count = page_count;
> 		if (page_count <= XB_PAGES) {
> 			bp->b_pages = bp->b_page_array;
> 		} else {
> 			bp->b_pages = kmem_alloc(sizeof(struct page *) *
> 						 page_count, KM_NOFS);
> 			if (bp->b_pages == NULL)
> 				return -ENOMEM;
> 		}
> 		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
> 	}
> 	return 0;
> }
> 
> xfs_bufs are kmem_cache_zalloc'd, which means that b_page_array should
> be zeroed, right?
> 
> And we could use kmem_zalloc for the pagecount > XB_PAGES case, which
> would make the memset necessary, wouldn't it?
> 
> OFC that only holds if a buffer that fails the memory allocation is
> immediately fed to _xfs_buf_free_pages to null out b_pages, which I
> think is true...?
> 
> --D
> 
> >  	}
> >  	return 0;
> >  
> >  out_free_pages:
> > -	for (i = 0; i < bp->b_page_count; i++)
> > -		__free_page(bp->b_pages[i]);
> > +	while (--filled >= 0)
> > +		__free_page(bp->b_pages[filled]);
> >  	bp->b_flags &= ~_XBF_PAGES;
> >  	return error;
> >  }
> > -- 
> > 2.31.1
> > 

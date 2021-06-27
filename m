Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F372C48BC2
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Jun 2021 23:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5909F61441
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Jun 2021 23:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhF0XQf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Jun 2021 19:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231491AbhF0XQe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 27 Jun 2021 19:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0693761C31;
        Sun, 27 Jun 2021 23:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624835650;
        bh=LMFjHBLX5BFUE8ZqD5MDNy76f8CYEw4jtZQtvOJdXj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTEqT1+PE8lZt9doliNJNM1CFeWUTnEDUvj16KZj8My6UVYzjhME2nv8W5NZOXLsm
         jl/HwnaefRBtnSQiuePEBsU77EiF0s+hobSSqSGPPAbF7JGU/RwK7O2k+Mk/Ay0lfl
         ky2YwjcGpuhfAs21/m5sYFkI1wKoNpwzM6CtDtu+ab4VQAJp4HLNThuI4FPxOpECeE
         ujKO/zDGRBjypKNWU7Hda6gGdfHRLloGxYll5ZaKTf0hWoQAxDgQnfJyabCtgevJuP
         jSLMVV+Wg2pGxCNzMHamZaKrQ1jLLzR3Xdd46qun8m2c7Zd3ZM1qdqbZgAVI2ZTQ/+
         Rm2aExWH9RX0g==
Date:   Sun, 27 Jun 2021 16:14:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: remove kmem_alloc_io()
Message-ID: <20210627231409.GK13784@locust>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-3-david@fromorbit.com>
 <20210626020145.GH13784@locust>
 <20210627220946.GD664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210627220946.GD664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 28, 2021 at 08:09:46AM +1000, Dave Chinner wrote:
> On Fri, Jun 25, 2021 at 07:01:45PM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 25, 2021 at 12:30:28PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
> > > for kmalloc(power-of-two)"), the core slab code now guarantees slab
> > > alignment in all situations sufficient for IO purposes (i.e. minimum
> > > of 512 byte alignment of >= 512 byte sized heap allocations) we no
> > > longer need the workaround in the XFS code to provide this
> > > guarantee.
> > > 
> > > Replace the use of kmem_alloc_io() with kmem_alloc() or
> > > kmem_alloc_large() appropriately, and remove the kmem_alloc_io()
> > > interface altogether.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/kmem.c            | 25 -------------------------
> > >  fs/xfs/kmem.h            |  1 -
> > >  fs/xfs/xfs_buf.c         |  3 +--
> > >  fs/xfs/xfs_log.c         |  3 +--
> > >  fs/xfs/xfs_log_recover.c |  4 +---
> > >  fs/xfs/xfs_trace.h       |  1 -
> > >  6 files changed, 3 insertions(+), 34 deletions(-)
> > > 
> > > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > > index e986b95d94c9..3f2979fd2f2b 100644
> > > --- a/fs/xfs/kmem.c
> > > +++ b/fs/xfs/kmem.c
> > > @@ -56,31 +56,6 @@ __kmem_vmalloc(size_t size, xfs_km_flags_t flags)
> > >  	return ptr;
> > >  }
> > >  
> > > -/*
> > > - * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
> > > - * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
> > > - * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
> > > - * aligned region.
> > > - */
> > > -void *
> > > -kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
> > > -{
> > > -	void	*ptr;
> > > -
> > > -	trace_kmem_alloc_io(size, flags, _RET_IP_);
> > > -
> > > -	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
> > > -		align_mask = PAGE_SIZE - 1;
> > > -
> > > -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > > -	if (ptr) {
> > > -		if (!((uintptr_t)ptr & align_mask))
> > > -			return ptr;
> > > -		kfree(ptr);
> > > -	}
> > > -	return __kmem_vmalloc(size, flags);
> > > -}
> > > -
> > >  void *
> > >  kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> > >  {
> > > diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> > > index 38007117697e..9ff20047f8b8 100644
> > > --- a/fs/xfs/kmem.h
> > > +++ b/fs/xfs/kmem.h
> > > @@ -57,7 +57,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
> > >  }
> > >  
> > >  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> > > -extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
> > >  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> > >  static inline void  kmem_free(const void *ptr)
> > >  {
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 8ff42b3585e0..a5ef1f9eb622 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -315,7 +315,6 @@ xfs_buf_alloc_kmem(
> > >  	struct xfs_buf	*bp,
> > >  	xfs_buf_flags_t	flags)
> > >  {
> > > -	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> > 
> > Is xfs_buftarg_dma_alignment unused now?
> 
> It is unused, I'll remove it.
> 
> > -or-
> > 
> > Should we trust that the memory allocators will always maintain at least
> > the current alignment guarantees, or actually check the alignment of the
> > returned buffer if CONFIG_XFS_DEBUG=y?
> 
> It's documented in Documentation/core-api/memory-allocation.rst that
> the alignment of the memory for power of two sized allocations is
> guaranteed. That means it's the responsibility of the mm developers
> to test and ensure this API-defined behaviour does not regress. I
> don't think it's viable for us to test every guarantee other
> subsystems are supposed to provide us with regardless of whether
> CONFIG_XFS_DEBUG=y is set or not...
> 
> Unfortunately, I don't see any debug or test infrastructure that
> ensures the allocation alignment guarantee is being met. Perhaps
> that's something the mm developers need to address?

That would be nice.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

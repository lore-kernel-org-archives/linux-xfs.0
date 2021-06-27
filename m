Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63C4C48BC2
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Jun 2021 22:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A233161A36
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Jun 2021 22:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhF0WMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Jun 2021 18:12:15 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40443 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231702AbhF0WMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Jun 2021 18:12:15 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6663680BBCF;
        Mon, 28 Jun 2021 08:09:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lxcyI-0009Og-Vl; Mon, 28 Jun 2021 08:09:47 +1000
Date:   Mon, 28 Jun 2021 08:09:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: remove kmem_alloc_io()
Message-ID: <20210627220946.GD664593@dread.disaster.area>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-3-david@fromorbit.com>
 <20210626020145.GH13784@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210626020145.GH13784@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Nvv_ug2qO9mfdb48CmQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 25, 2021 at 07:01:45PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 25, 2021 at 12:30:28PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
> > for kmalloc(power-of-two)"), the core slab code now guarantees slab
> > alignment in all situations sufficient for IO purposes (i.e. minimum
> > of 512 byte alignment of >= 512 byte sized heap allocations) we no
> > longer need the workaround in the XFS code to provide this
> > guarantee.
> > 
> > Replace the use of kmem_alloc_io() with kmem_alloc() or
> > kmem_alloc_large() appropriately, and remove the kmem_alloc_io()
> > interface altogether.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/kmem.c            | 25 -------------------------
> >  fs/xfs/kmem.h            |  1 -
> >  fs/xfs/xfs_buf.c         |  3 +--
> >  fs/xfs/xfs_log.c         |  3 +--
> >  fs/xfs/xfs_log_recover.c |  4 +---
> >  fs/xfs/xfs_trace.h       |  1 -
> >  6 files changed, 3 insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index e986b95d94c9..3f2979fd2f2b 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -56,31 +56,6 @@ __kmem_vmalloc(size_t size, xfs_km_flags_t flags)
> >  	return ptr;
> >  }
> >  
> > -/*
> > - * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
> > - * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
> > - * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
> > - * aligned region.
> > - */
> > -void *
> > -kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
> > -{
> > -	void	*ptr;
> > -
> > -	trace_kmem_alloc_io(size, flags, _RET_IP_);
> > -
> > -	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
> > -		align_mask = PAGE_SIZE - 1;
> > -
> > -	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > -	if (ptr) {
> > -		if (!((uintptr_t)ptr & align_mask))
> > -			return ptr;
> > -		kfree(ptr);
> > -	}
> > -	return __kmem_vmalloc(size, flags);
> > -}
> > -
> >  void *
> >  kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> >  {
> > diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> > index 38007117697e..9ff20047f8b8 100644
> > --- a/fs/xfs/kmem.h
> > +++ b/fs/xfs/kmem.h
> > @@ -57,7 +57,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
> >  }
> >  
> >  extern void *kmem_alloc(size_t, xfs_km_flags_t);
> > -extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
> >  extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
> >  static inline void  kmem_free(const void *ptr)
> >  {
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 8ff42b3585e0..a5ef1f9eb622 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -315,7 +315,6 @@ xfs_buf_alloc_kmem(
> >  	struct xfs_buf	*bp,
> >  	xfs_buf_flags_t	flags)
> >  {
> > -	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);
> 
> Is xfs_buftarg_dma_alignment unused now?

It is unused, I'll remove it.

> -or-
> 
> Should we trust that the memory allocators will always maintain at least
> the current alignment guarantees, or actually check the alignment of the
> returned buffer if CONFIG_XFS_DEBUG=y?

It's documented in Documentation/core-api/memory-allocation.rst that
the alignment of the memory for power of two sized allocations is
guaranteed. That means it's the responsibility of the mm developers
to test and ensure this API-defined behaviour does not regress. I
don't think it's viable for us to test every guarantee other
subsystems are supposed to provide us with regardless of whether
CONFIG_XFS_DEBUG=y is set or not...

Unfortunately, I don't see any debug or test infrastructure that
ensures the allocation alignment guarantee is being met. Perhaps
that's something the mm developers need to address?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BC2C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 20:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AB0D20679
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 20:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfKMUGZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 15:06:25 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48280 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbfKMUGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 15:06:25 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F2D9E3A1F77;
        Thu, 14 Nov 2019 07:06:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUyuC-00070m-Fd; Thu, 14 Nov 2019 07:06:20 +1100
Date:   Thu, 14 Nov 2019 07:06:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: Remove kmem_alloc_{io, large} and
 kmem_zalloc_large
Message-ID: <20191113200620.GU4614@dread.disaster.area>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-12-cmaiolino@redhat.com>
 <20191113182343.GH6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113182343.GH6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=sf5rwiSoPyxK5rdA5NcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 10:23:43AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2019 at 03:23:35PM +0100, Carlos Maiolino wrote:
> > Getting rid of these functions, is a bit more complicated, giving the
> > fact they use a vmalloc fallback, and (in case of _io version) uses an
> > alignment check, so they have their useness.
> > 
> > Instead of keeping both of them, I think sharing the same function for
> > both cases is a more interesting idea, giving the fact they both have
> > the same purpose, with the only difference being the alignment check,
> > which can be selected by using a flag.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/kmem.c                 | 39 +++++++++++------------------------
> >  fs/xfs/kmem.h                 | 10 +--------
> >  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
> >  fs/xfs/scrub/attr.c           |  2 +-
> >  fs/xfs/scrub/symlink.c        |  3 ++-
> >  fs/xfs/xfs_acl.c              |  3 ++-
> >  fs/xfs/xfs_buf.c              |  4 ++--
> >  fs/xfs/xfs_ioctl.c            |  8 ++++---
> >  fs/xfs/xfs_ioctl32.c          |  3 ++-
> >  fs/xfs/xfs_log.c              |  5 +++--
> >  fs/xfs/xfs_log_cil.c          |  2 +-
> >  fs/xfs/xfs_log_recover.c      |  4 ++--
> >  fs/xfs/xfs_rtalloc.c          |  3 ++-
> >  13 files changed, 36 insertions(+), 52 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index 44145293cfc9..bb4990970647 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -8,40 +8,25 @@
> >  #include "xfs_message.h"
> >  #include "xfs_trace.h"
> >  
> > -/*
> > - * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
> > - * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
> > - * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
> > - * aligned region.
> > - */
> >  void *
> > -kmem_alloc_io(size_t size, int align_mask, gfp_t flags)
> > +xfs_kmem_alloc(size_t size, gfp_t flags, bool align, int align_mask)
> 
> A boolean for the align /and/ an alignment mask?  Yuck.
> 
> I think I'd rather have:
> 
> void *
> kmem_alloc(
> 	size_t		size,
> 	gfp_t		flags,
> 	unsigned int	align_mask)
> {
> 	... allocation logic ...
> }

If you avoid changing the order of the flags/alignmask parameters,
most of the churn in this patch goes away.

> 
> and in kmem.h:
> 
> static inline void *
> kmem_alloc_io(
> 	size_t		size,
> 	gfp_t		flags,
> 	unsigned int	align_mask)
> {
> 	trace_kmem_alloc_io(size, flags, align_mask, _RET_IP_);
> 	return kmem_alloc(size, flags, align_mask);
> }

This should be able to go away soon, because the heap allocator will
guarantee alignment soon. That means kmem.c is a single function,
and kmem.h is a single function. I'd be looking to move the two
helper functions into some other utility file at that point
(fsops?)...

ANother question: how much work is there to be done on the userspace
side of things?

> >   */
> >  
> > -extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
> > -extern void *kmem_alloc_large(size_t size, gfp_t);
> > +extern void *xfs_kmem_alloc(size_t, gfp_t, bool, int);
> >  static inline void  kmem_free(const void *ptr)
> >  {
> >  	kvfree(ptr);
> >  }

Didn't an earlier patch get rid of kmem_free(), or am I just
imagining this? Seems silly to leave this behind, now that the
only place that needs kvfree() is the callers to kmem_alloc_io and
kmem_alloc_large...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

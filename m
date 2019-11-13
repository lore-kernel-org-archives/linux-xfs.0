Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF791C432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 19:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9D1206E4
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 19:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfKMT46 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 14:56:58 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57126 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbfKMT46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 14:56:58 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8EDF63A0857;
        Thu, 14 Nov 2019 06:56:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iUyl3-0006xk-4w; Thu, 14 Nov 2019 06:56:53 +1100
Date:   Thu, 14 Nov 2019 06:56:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: rework kmem_alloc_{io,large} to use GFP_*
 flags
Message-ID: <20191113195653.GT4614@dread.disaster.area>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
 <20191113142335.1045631-10-cmaiolino@redhat.com>
 <20191113180850.GK6235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113180850.GK6235@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=sf5rwiSoPyxK5rdA5NcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 10:08:50AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 13, 2019 at 03:23:33PM +0100, Carlos Maiolino wrote:
> > Pass slab flags directly to these functions
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/kmem.c                 | 60 ++++-------------------------------
> >  fs/xfs/kmem.h                 |  8 ++---
> >  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
> >  fs/xfs/scrub/attr.c           |  8 ++---
> >  fs/xfs/scrub/attr.h           |  3 +-
> >  fs/xfs/xfs_buf.c              |  7 ++--
> >  fs/xfs/xfs_log.c              |  2 +-
> >  fs/xfs/xfs_log_cil.c          |  2 +-
> >  fs/xfs/xfs_log_recover.c      |  3 +-
> >  9 files changed, 22 insertions(+), 73 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index 79467813d810..44145293cfc9 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -8,54 +8,6 @@
> >  #include "xfs_message.h"
> >  #include "xfs_trace.h"
> >  
> > -static void *
> > -__kmem_alloc(size_t size, xfs_km_flags_t flags)
> > -{
> > -	int	retries = 0;
> > -	gfp_t	lflags = kmem_flags_convert(flags);
> > -	void	*ptr;
> > -
> > -	trace_kmem_alloc(size, flags, _RET_IP_);
> > -
> > -	do {
> > -		ptr = kmalloc(size, lflags);
> > -		if (ptr || (flags & KM_MAYFAIL))
> > -			return ptr;
> > -		if (!(++retries % 100))
> > -			xfs_err(NULL,
> > -	"%s(%u) possible memory allocation deadlock size %u in %s (mode:0x%x)",
> > -				current->comm, current->pid,
> > -				(unsigned int)size, __func__, lflags);
> > -		congestion_wait(BLK_RW_ASYNC, HZ/50);
> 
> Why is it ok to remove the "wait for congestion and retry" logic here?
> Does GFP_NOFAIL do all that for us?

Yes - kmalloc will never return failure if GFP_NOFAIL is set, and
it has internal congestion_wait() backoffs. All we lose here is
the XFS specific error message - we'll get the generic warnings
now...

> Same question for the other two patches that remove similar loops from
> other functions.
> 
> > -	} while (1);
> > -}
> > -
> > -
> > -/*
> > - * __vmalloc() will allocate data pages and auxiliary structures (e.g.
> > - * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here. Hence
> > - * we need to tell memory reclaim that we are in such a context via
> > - * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem here
> > - * and potentially deadlocking.
> > - */
> > -static void *
> > -__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
> > -{
> > -	unsigned nofs_flag = 0;
> > -	void	*ptr;
> > -	gfp_t	lflags = kmem_flags_convert(flags);
> > -
> > -	if (flags & KM_NOFS)
> > -		nofs_flag = memalloc_nofs_save();
> > -
> > -	ptr = __vmalloc(size, lflags, PAGE_KERNEL);
> > -
> > -	if (flags & KM_NOFS)
> > -		memalloc_nofs_restore(nofs_flag);
> > -
> > -	return ptr;
> > -}
> 
> I think this deletes too much -- as the comment says, a caller can pass
> in GFP_NOFS and we have to push that context all the way through to
> /any/ allocation that happens under __vmalloc.
> 
> However, it's possible that the mm developers have fixed __vmalloc to
> pass GFP_NOFS through to every allocation that can be made.  Is that the
> case?

Nope, vmalloc will still do GFP_KERNEL allocations internally. We
need to keep the kmem_vmalloc wrappers as they stand, just converted
to use GFP flags.

> TBH this series would be better sequenced as (1) get rid of pointless
> wrappers, (2) convert kmem* callers to use GFP flags, and (3) save
> whatever logic changes for the end.  If nothing else I could pull the
> first two parts and leave the third for later.

*nod*

> >  static inline void *
> > -kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> > +kmem_zalloc_large(size_t size, gfp_t flags)
> >  {
> > -	return kmem_alloc_large(size, flags | KM_ZERO);
> > +	return kmem_alloc_large(size, flags | __GFP_ZERO);
> >  }

I'd also kill these zalloc wrappers and just pass __GFP_ZERO
directly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F00C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 21:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D0CF6162A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 21:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhEKVyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 17:54:01 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:54888 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKVyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 17:54:01 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5870780ACA6;
        Wed, 12 May 2021 07:52:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgaJ8-00ER0d-TM; Wed, 12 May 2021 07:52:50 +1000
Date:   Wed, 12 May 2021 07:52:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <20210511215250.GU63242@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
 <YJp43sNHyTkk+SDU@bfoster>
 <20210511205152.GP8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511205152.GP8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=n6_QYJw76Bk_qOwXdQ4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 01:51:52PM -0700, Darrick J. Wong wrote:
> On Tue, May 11, 2021 at 08:30:22AM -0400, Brian Foster wrote:
> > On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Which will eventually completely replace the agno in it.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
> > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
> > >  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
> > >  fs/xfs/libxfs/xfs_btree.c          |  2 ++
> > >  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
> > >  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
> > >  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
> > >  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
> > >  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
> > >  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
> > >  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
> > >  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
> > >  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
> > >  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
> > >  fs/xfs/scrub/bmap.c                |  2 +-
> > >  fs/xfs/scrub/common.c              | 12 ++++++------
> > >  fs/xfs/scrub/repair.c              |  5 +++--
> > >  fs/xfs/xfs_discard.c               |  2 +-
> > >  fs/xfs/xfs_fsmap.c                 |  6 +++---
> > >  fs/xfs/xfs_reflink.c               |  2 +-
> > >  21 files changed, 112 insertions(+), 70 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index 0f12b885600d..44044317c0fb 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -377,6 +377,8 @@ xfs_btree_del_cursor(
> > >  	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
> > >  	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> > >  		kmem_free(cur->bc_ops);
> > > +	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> > > +		xfs_perag_put(cur->bc_ag.pag);
> > 
> > What's the correlation with BTREE_LONG_PTRS?

Only the btrees that index agbnos within a specific AG use the
cur->bc_ag structure to store the agno the btree is rooted in.
These are all btrees that use short pointers.

IOWs, we need an agno to turn the agbno into a full fsbno, daddr,
inum or anything else with global scope. Translation of short
pointers to physical location is necessary just to walk the tree,
while long pointer trees already record physical location of the
blocks within the tree and hence do not need an agno for
translation.

Hence needing the agno is specific, at this point in
time, to a btree containing short pointers.

> maybe this should be:
> 
> 	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> 		xfs_perag_put(cur->bc_ag.pag);

Given that the only long pointer btree we have is also the only
btree we have rooted in an inode, this is just another way of saying
!BTREE_LONG_PTRS. But "root in inode" is less obvious, because then we
lose the context taht "short pointers need translation via agno to
calculate their physical location in the wider filesystem"...

If we are going to put short ptrs in an inode, then at that point
we need to change the btree cursor, anyway, because then we are
going to need both an inode pointer and something else to turn those
short pointers into global scope pointers for IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

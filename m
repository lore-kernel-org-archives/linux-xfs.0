Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108EFC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898B622CF7
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 21:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgLDVXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 16:23:12 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40999 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730048AbgLDVXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 16:23:12 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 1019E7659FE;
        Sat,  5 Dec 2020 08:22:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1klIX0-000XI9-MX; Sat, 05 Dec 2020 08:22:22 +1100
Date:   Sat, 5 Dec 2020 08:22:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201204212222.GG3913616@dread.disaster.area>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201204123137.GA1404170@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204123137.GA1404170@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=vsqdUP0MVNUnAF5Z7yIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 07:31:37AM -0500, Brian Foster wrote:
> On Thu, Dec 03, 2020 at 10:27:24AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we allocate a new inode, we often need to add an attribute to
> > the inode as part of the create. This can happen as a result of
> > needing to add default ACLs or security labels before the inode is
> > made visible to userspace.
> > 
> > This is highly inefficient right now. We do the create transaction
> > to allocate the inode, then we do an "add attr fork" transaction to
> > modify the just created empty inode to set the inode fork offset to
> > allow attributes to be stored, then we go and do the attribute
> > creation.
> > 
> > This means 3 transactions instead of 1 to allocate an inode, and
> > this greatly increases the load on the CIL commit code, resulting in
> > excessive contention on the CIL spin locks and performance
> > degradation:
> > 
> >  18.99%  [kernel]                [k] __pv_queued_spin_lock_slowpath
> >   3.57%  [kernel]                [k] do_raw_spin_lock
> >   2.51%  [kernel]                [k] __raw_callee_save___pv_queued_spin_unlock
> >   2.48%  [kernel]                [k] memcpy
> >   2.34%  [kernel]                [k] xfs_log_commit_cil
> > 
> > The typical profile resulting from running fsmark on a selinux enabled
> > filesytem is adds this overhead to the create path:
> > 
> ...
> > 
> > And fsmark creation rate performance drops by ~25%. The key point to
> > note here is that half the additional overhead comes from adding the
> > attribute fork to the newly created inode. That's crazy, considering
> > we can do this same thing at inode create time with a couple of
> > lines of code and no extra overhead.
> > 
> > So, if we know we are going to add an attribute immediately after
> > creating the inode, let's just initialise the attribute fork inside
> > the create transaction and chop that whole chunk of code out of
> > the create fast path. This completely removes the performance
> > drop caused by enabling SELinux, and the profile looks like:
> > 
> ...
> > 
> > Which indicates the XFS overhead of creating the selinux xattr has
> > been halved. This doesn't fix the CIL lock contention problem, just
> > means it's not a limiting factor for this workload. Lock contention
> > in the security subsystems is going to be an issue soon, though...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.c | 20 +++++++++++++++-----
> >  fs/xfs/libxfs/xfs_inode_fork.h |  1 +
> >  fs/xfs/xfs_inode.c             | 24 ++++++++++++++++++++----
> >  fs/xfs/xfs_inode.h             |  5 +++--
> >  fs/xfs/xfs_iops.c              | 10 +++++++++-
> >  fs/xfs/xfs_qm.c                |  2 +-
> >  fs/xfs/xfs_symlink.c           |  2 +-
> >  7 files changed, 50 insertions(+), 14 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2bfbcf28b1bd..9ee2e0b4c6fd 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> ...
> > @@ -918,6 +919,18 @@ xfs_ialloc(
> >  		ASSERT(0);
> >  	}
> >  
> > +	/*
> > +	 * If we need to create attributes immediately after allocating the
> > +	 * inode, initialise an empty attribute fork right now. We use the
> > +	 * default fork offset for attributes here as we don't know exactly what
> > +	 * size or how many attributes we might be adding. We can do this safely
> > +	 * here because we know the data fork is completely empty right now.
> > +	 */
> > +	if (init_attrs) {
> > +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> > +		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> > +	}
> > +
> 
> Seems reasonable in principle, but why not refactor
> xfs_bmap_add_attrfork() such that the internals (i.e. everything within
> the transaction/ilock code) can be properly reused in both contexts
> rather than open-coding (and thus duplicating) a somewhat stripped down
> version?

We don't know the size of the attribute that is being created, so
the attr size dependent parts of it can't be used.

> At a glance, it looks like there are some subtle differences in
> the initial setup of the attr fork for a device node inode, for example.

Yes, there's a difference, but it's largely irrelevant as adding
the first attribute to a device format inode will reset the
forkoffset to the min via xfs_attr_shortform_bytesfit().

And if the attribute is larger than will fit in the default fork
offset space, but can fit the attr in shrotform by shrinking the
empty data fork space, xfs_attr_shortform_bytesfit() will do that as
well. IOWs, we only need to set a non-zero fork offset here and init
the ip->i_afp pointer - immediately setting an attribute on the
empty inode literal area will do the rest for the fork offset setup
for us...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C550AC4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EAB423120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgLFXeI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:34:08 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42183 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgLFXeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:34:07 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AEB6B3CA6FF;
        Mon,  7 Dec 2020 10:33:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1km3Ws-001G8O-Ia; Mon, 07 Dec 2020 10:33:22 +1100
Date:   Mon, 7 Dec 2020 10:33:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201206233322.GK3913616@dread.disaster.area>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201204123137.GA1404170@bfoster>
 <20201204212222.GG3913616@dread.disaster.area>
 <20201205113444.GA1485029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205113444.GA1485029@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=oflAuAwyQYcZkxkKKxsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 05, 2020 at 06:34:44AM -0500, Brian Foster wrote:
> On Sat, Dec 05, 2020 at 08:22:22AM +1100, Dave Chinner wrote:
> > On Fri, Dec 04, 2020 at 07:31:37AM -0500, Brian Foster wrote:
> > > On Thu, Dec 03, 2020 at 10:27:24AM +1100, Dave Chinner wrote:
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index 2bfbcf28b1bd..9ee2e0b4c6fd 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > ...
> > > > @@ -918,6 +919,18 @@ xfs_ialloc(
> > > >  		ASSERT(0);
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * If we need to create attributes immediately after allocating the
> > > > +	 * inode, initialise an empty attribute fork right now. We use the
> > > > +	 * default fork offset for attributes here as we don't know exactly what
> > > > +	 * size or how many attributes we might be adding. We can do this safely
> > > > +	 * here because we know the data fork is completely empty right now.
> > > > +	 */
> > > > +	if (init_attrs) {
> > > > +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> > > > +		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> > > > +	}
> > > > +
> > > 
> > > Seems reasonable in principle, but why not refactor
> > > xfs_bmap_add_attrfork() such that the internals (i.e. everything within
> > > the transaction/ilock code) can be properly reused in both contexts
> > > rather than open-coding (and thus duplicating) a somewhat stripped down
> > > version?
> > 
> > We don't know the size of the attribute that is being created, so
> > the attr size dependent parts of it can't be used.
> 
> Not sure I see the problem here. It looks to me that
> xfs_bmap_add_attrfork() would do the right thing if we just passed a
> size of zero.

Yes, but it also does an awful lot that we do not need.

> The only place the size value is actually used is down in
> xfs_attr_shortform_bytesfit(), and I'd expect that to identify that the
> requested size is <= than the current afork size (also zero for a newly
> allocated inode..?) and bail out.

RIght it ends up doing that because an uninitialised inode fork
(di_forkoff = 0) is the same size as the requested size of zero, and
then it does ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;

But that's decided another two function calls deep, after a lot of
branches and shifting and comparisons to determine that the attr
fork is empty. Yet we already know that the attr fork is empty here
so all that extra CPU work is completely unnecessary.

Keep in mind we do exactly the same thing in
xfs_bmap_forkoff_reset(). We don't care about all the setup stuff in
xfs_bmap_add_attrfork(), we just reset the attr fork offset to the
default if the attr fork had grown larger than the default offset.

> That said, I wouldn't be opposed to tweaking xfs_bmap_set_attrforkoff()
> by a line or two to just skip the shortform call if size == 0. Then we
> can be more explicit about the "size == 0 means preemptive fork alloc,
> use the default offset" use case and perhaps actually document it with
> some comments as well.

It just seems wrong to me to code a special case into some function
to optimise that special case when the code that needs the special
case has no need to call that function in the first place.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20032 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753764AbdIDPqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 11:46:43 -0400
Date: Mon, 4 Sep 2017 08:46:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH] fstests: regression test for xfs leftover CoW
 extent error
Message-ID: <20170904154635.GF4671@magnolia>
References: <1504451271-29202-1-git-send-email-amir73il@gmail.com>
 <20170903174513.GI4073@magnolia>
 <20170903182133.GA1757@lst.de>
 <20170903210427.GJ4073@magnolia>
 <20170904153026.GA6469@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904153026.GA6469@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 04, 2017 at 05:30:26PM +0200, Christoph Hellwig wrote:
> On Sun, Sep 03, 2017 at 02:04:27PM -0700, Darrick J. Wong wrote:
> > On Sun, Sep 03, 2017 at 08:21:33PM +0200, Christoph Hellwig wrote:
> > > > So basically there are two bugs here -- the fcollapse/finsert code needs
> > > > to shift the CoW fork extents down and up;
> > > 
> > > Or make sure that we don't have any extents in the COW fork?
> > 
> > It's a big hammer approach, but yes that'd work.
> > 
> > We're already forcing all the dirty pages out anyway so I guess it's no
> > big deal.
> 
> It might be a big deal for my O_ATOMIC work, but I'll need to need
> to find that work and actually define semantics vs nasty operations
> like insert and swapext for that.
> 
> Then again shifting the cow forks seems relatively easy - we'd just
> need to look at the whichfork argument in the low-level helpers
> basically.

Yes, it looks pretty straightforward.  I'll send my dumb version that
merely evicts everything from the cow fork to the list and see if that
motivates anyone to try their hand at shifting the cow fork.

> > > >         /*
> > > >          * Clear the reflink flag if we truncated everything.
> > > >          */
> > > > -       if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
> > > > +       if (ip->i_d.di_nblocks == 0 && ip->i_cnextents == 0 && xfs_is_reflink_inode(ip)) {
> > > 
> > > Btw, it seems like we should generally clear the reflink flag and
> > > tag if ip->i_cnextents is zero and not even bother looking at di_nblocks.
> > 
> > We can't -- imagine shortening to 8k a reflinked 12k file that hasn't been
> > written to.  It has no cow extents, but we cannot drop the reflink flag.
> 
> True for the reflink flag.  But we should be able to clear the cowblocks
> tag whenever i_cnextents reaches zero.

<nod> I was about to send out a cleaner patch.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

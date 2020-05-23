Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFF4C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 23:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D8220727
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 23:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388125AbgEWXOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 19:14:53 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38070 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388123AbgEWXOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 19:14:52 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0ABA98210F0;
        Sun, 24 May 2020 09:14:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcdLZ-000132-18; Sun, 24 May 2020 09:14:29 +1000
Date:   Sun, 24 May 2020 09:14:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200523231429.GM2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-23-david@fromorbit.com>
 <20200523001334.GZ8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523001334.GZ8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=mIFWBmn3b01En58K-xYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 05:13:34PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:27PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have all the dirty inodes attached to the cluster
> > buffer, we don't actually have to do radix tree lookups to find
> > them. Sure, the radix tree is efficient, but walking a linked list
> > of just the dirty inodes attached to the buffer is much better.
> > 
> > We are also no longer dependent on having a locked inode passed into
> > the function to determine where to start the lookup. This means we
> > can drop it from the function call and treat all inodes the same.
> > 
> > We also make xfs_iflush_cluster skip inodes marked with
> > XFS_IRECLAIM. This we avoid races with inodes that reclaim is
> > actively referencing or are being re-initialised by inode lookup. If
> > they are actually dirty, they'll get written by a future cluster
> > flush....
> > 
> > We also add a shutdown check after obtaining the flush lock so that
> > we catch inodes that are dirty in memory and may have inconsistent
> > state due to the shutdown in progress. We abort these inodes
> > directly and so they remove themselves directly from the buffer list
> > and the AIL rather than having to wait for the buffer to be failed
> > and callbacks run to be processed correctly.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c      | 150 ++++++++++++++++------------------------
> >  fs/xfs/xfs_inode.h      |   2 +-
> >  fs/xfs/xfs_inode_item.c |  15 +++-
> >  3 files changed, 74 insertions(+), 93 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index cbf8edf62d102..7db0f97e537e3 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3428,7 +3428,7 @@ xfs_rename(
> >  	return error;
> >  }
> >  
> > -static int
> > +int
> >  xfs_iflush(
> 
> Not sure why this drops the static?

Stray hunk from reordering the patchset. This used to be before the
removal of writeback from reclaim, so it needed to be called from
there. But that ordering made no sense as it required heaps of
temporary changes to the reclaim code, so I put it first and got
rid of of all the reclaim writeback futzing. Clearly I forgot to
remove this hunk when I cleared xfs_iflush() out of the header file.

> > -		if (!cip->i_ino) {
> > -			xfs_ifunlock(cip);
> > -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> > +		if (XFS_FORCED_SHUTDOWN(mp)) {
> > +			xfs_iunpin_wait(ip);
> > +			/* xfs_iflush_abort() drops the flush lock */
> > +			xfs_iflush_abort(ip);
> > +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +			error = EIO;
> 
> error = -EIO?

Yup, good catch.

> > -	error = xfs_iflush_cluster(ip, bp);
> > +	/*
> > +	 * We need to hold a reference for flushing the cluster buffer as it may
> > +	 * fail the buffer without IO submission. In which case, we better have
> > +	 * a reference for that completion as otherwise we don't get a reference
> > +	 * for IO until we queue it for delwri submission.
> 
> <confused>
> 
> What completion are we talking about?  Does this refer to the fact that
> xfs_iflush_cluster handles a flush failure by simulating an async write
> failure which could result in us giving away the inode log item's
> reference to the buffer?

Yes. This is the way the code currently works before this patchset.
The IO reference used by the AIL writeback comes from
xfs_imap_to_bp(), and getting rid of that from the writeback path
means we no longer have an IO reference to the buffer before calling
xfs_iflush_cluster(). And, yes, the xfs_buf_ioend_fail() call in
xfs_iflush_cluster() implicitly relies on this reference existing.
Hence we have to take one ourselves and we cannot rely on the
IO reference we get from adding the buffer to the delwri list.

This was a bug I found a couple of hours before I posted the
patchset, and the bisect pointed at this patch as the cause. It may
be that it should be in the patch that gets rid of the xfs_iflush()
call and propagate through that way. However, after 3 days of
continuous bisecting to find bugs as a result of implicit,
undocumented stuff like this over and over again, the novelty was
starting to wear a bit thin.

I'll revisit this when I've regained some patience....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

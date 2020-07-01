Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5837C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD5B220853
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGAWYc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:24:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58606 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbgGAWYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:24:31 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C57463A454C;
        Thu,  2 Jul 2020 08:24:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jql9Y-0000gn-44; Thu, 02 Jul 2020 08:24:28 +1000
Date:   Thu, 2 Jul 2020 08:24:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: introduce inode unlink log item
Message-ID: <20200701222428.GX2005@dread.disaster.area>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-5-david@fromorbit.com>
 <20200701143219.GC1087@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701143219.GC1087@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=U-3SrbzIN0axRbdASIcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 10:32:19AM -0400, Brian Foster wrote:
> On Tue, Jun 23, 2020 at 07:50:15PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Tracking dirty inodes via cluster buffers creates lock ordering
> > issues with logging unlinked inode updates direct to the cluster
> > buffer. The unlinked inode list is unordered, so we can lock cluster
> > buffers in random orders and that causes deadlocks.
> > 
> > To solve this problem, we really want to dealy locking the cluster
> > buffers until the pre-commit phase where we can order the buffers
> > correctly along with all the other inode cluster buffers that are
> > locked by the transaction. However, to do this we need to be able to
> > tell the transaction which inodes need to have there unlinked list
> > updated and what it should be updated to.
> > 
> > We can delay the buffer update to the pre-commit phase based on the
> > fact taht all unlinked inode list updates are serialised by the AGI
> > buffer. It will be locked into the transaction before the list
> > update starts, and will remain locked until the transaction commits.
> > Hence we can lock and update the cluster buffers safely any time
> > during the transaction and we are still safe from other racing
> > unlinked list updates.
> > 
> > The iunlink log item currently only exists in memory. we need a log
> > item to attach information to the transaction, but it's context
> > is completely owned by the transaction. Hence it is never formatted
> > or inserted into the CIL, nor is it seen by the journal, the AIL or
> > log recovery.
> > 
> > This makes it a very simple log item, and the changes makes results
> > in adding addition buffer log items to the transaction. Hence once
> > the iunlink log item has run it's pre-commit operation, it can be
> > dropped by the transaction and released.
> > 
> > The creation of this in-memory intent does not prevent us from
> > extending it in future to the journal to replace buffer based
> > logging of the unlinked list. Changing the format of the items we
> > write to the on disk journal is beyond the scope of this patchset,
> > hence we limit it to being in-memory only.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/Makefile           |   1 +
> >  fs/xfs/xfs_inode.c        |  70 +++----------------
> >  fs/xfs/xfs_inode_item.c   |   3 +-
> >  fs/xfs/xfs_iunlink_item.c | 141 ++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_iunlink_item.h |  24 +++++++
> >  fs/xfs/xfs_super.c        |  10 +++
> >  6 files changed, 189 insertions(+), 60 deletions(-)
> >  create mode 100644 fs/xfs/xfs_iunlink_item.c
> >  create mode 100644 fs/xfs/xfs_iunlink_item.h
> > 
> ...
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 0494b907c63d..bc1970c37edc 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -488,8 +488,9 @@ xfs_inode_item_push(
> >  	ASSERT(iip->ili_item.li_buf);
> >  
> >  	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> > -	    (ip->i_flags & XFS_ISTALE))
> > +	    (ip->i_flags & XFS_ISTALE)) {
> >  		return XFS_ITEM_PINNED;
> > +	}
> 
> Spurious change..?

*nod*

Likely a left over from adding debug traceprints...

> >  	/* If the inode is already flush locked, we're already flushing. */
> >  	if (xfs_iflags_test(ip, XFS_IFLUSHING))
> > diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> > new file mode 100644
> > index 000000000000..83f1dc81133b
> > --- /dev/null
> > +++ b/fs/xfs/xfs_iunlink_item.c
> > @@ -0,0 +1,141 @@
> ...
> > +
> > +static const struct xfs_item_ops xfs_iunlink_item_ops = {
> > +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> > +	.iop_release	= xfs_iunlink_item_release,
> 
> Presumably we need the release callback for transaction abort, but the
> flag looks unnecessary. That triggers a release on commit to the on-disk
> log, which IIUC should never happen for this item.

You are probably right - I didn't look that further than "it should
be freed at commit time" and the flag name implies it is freed at
commit time.

Which, of course, then raises the question: "Which commit are we
talking about here?". But because it's RFC work at this point I
didn't bother chasing that detail down because the code worked and I
had other things to do.....

> > +	.iop_sort	= xfs_iunlink_item_sort,
> > +	.iop_precommit	= xfs_iunlink_item_precommit,
> > +};
> > +
> > +
> > +/*
> > + * Initialize the inode log item for a newly allocated (in-core) inode.
> > + *
> > + * Inode extents can only reside within an AG. Hence specify the starting
> > + * block for the inode chunk by offset within an AG as well as the
> > + * length of the allocated extent.
> > + *
> > + * This joins the item to the transaction and marks it dirty so
> > + * that we don't need a separate call to do this, nor does the
> > + * caller need to know anything about the iunlink item.
> > + */
> 
> Looks like some copy/paste remnants in the comment.

Yup, I did just copy-pasta at lot of stuff around here...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

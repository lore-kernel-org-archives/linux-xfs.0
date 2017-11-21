Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16967 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751263AbdKUW2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2017 17:28:11 -0500
Date: Wed, 22 Nov 2017 09:28:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171121222806.GQ5858@dastard>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
 <20171120202606.GN5858@dastard>
 <20171120215100.GB8933@bombadil.infradead.org>
 <20171120222749.GO5858@dastard>
 <20171121013753.GA12441@magnolia>
 <20171121043240.GB8774@bombadil.infradead.org>
 <20171121064815.GP5858@dastard>
 <20171121125253.GA1484@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171121125253.GA1484@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Tue, Nov 21, 2017 at 04:52:53AM -0800, Matthew Wilcox wrote:
> On Tue, Nov 21, 2017 at 05:48:15PM +1100, Dave Chinner wrote:
> > On Mon, Nov 20, 2017 at 08:32:40PM -0800, Matthew Wilcox wrote:
> > > On Mon, Nov 20, 2017 at 05:37:53PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Nov 21, 2017 at 09:27:49AM +1100, Dave Chinner wrote:
> > > > > First thing I noticed was that "xa" as a prefix is already quite
> > > > > widely used in XFS - it's shorthand for "XFS AIL". Indeed, xa_lock
> > >
> > > The X stands for 'eXpandable' or 'eXtending'.  I really don't want to
> > > use more than a two-letter acronym for whatever the XArray ends up being
> > > called.  One of the problems with the radix tree is that everything has
> > > that 11-character 'radix_tree_' prefix; just replacing that with 'xa_'
> > > makes a huge improvement to readability.
> > 
> > Yeah, understood. That's why
> > we have very little clear
> > prefix namespace left.... :/
> > 
> > [ somedays I write something that looks sorta like a haiku, and from
> > that point on everything just starts falling out of my brain that
> > way. I blame Eric for this today! :P ]
> 
> When the namespace is
> tight we must consider the
> competing users.
> 
> The earliest us'r
> has a claim to a prefix
> we are used to it.
> 
> Also a more wide-
> spread user has a claim to
> a shorter prefix.
> 
> Would you mind changing
> your prefix to one only
> one letter longer?

We can do something
like that, though Darrick has the
final say in it.

> ... ok, I give up ;-)

Top marks for effort :)

> All your current usage of the xa_ prefix looks somewhat like this:
> 
> fs/xfs/xfs_trans_ail.c: spin_lock(&ailp->xa_lock);
> 
> with honourable mentions to:
> fs/xfs/xfs_log.c:	spin_lock(&mp->m_ail->xa_lock);
> 
> Would you mind if I bolt a patch on to the front of the series called
> something like "free up xa_ namespace" that renamed your xa_* to ail_*?
> There are no uses of the 'ail_' prefix in the kernel today.
> 
> I don't think that
> 	spin_lock(&ailp->ail_lock);
> loses any readability.

Not sure that's going to work - there's an "xa_ail" member for the
AIL list head. That would now read in places:

	if (list_empty(&ailp->ail_ail))

I'd be inclined to just drop the "xa_" prefix from the XFS
structure.  There is no information loss by removing the prefix in
the XFS code because the pointer name tells us what structure it is
pointing at.

> 
> By the way, what does AIL stand for?  It'd be nice if it were spelled out
> in at least one of the header files, maybe fs/xfs/xfs_trans_priv.h?

Active Item List. See the section "Tracking Changes" in
Documentation/filesystems/xfs-delayed-logging-design.txt for the
full rundown, but in short:

"The log item is already used to track the log items that have been
written to the log but not yet written to disk. Such log items are
considered "active" and as such are stored in the Active Item List
(AIL) which is a LSN-ordered double linked list. Items are inserted
into this list during log buffer IO completion, after which they are
unpinned and can be written to disk."

The lack of comments describing the AIL is historic - it's never
been documented in the code, nor has the whole relogging concept it
implements. I wrote the document above when introducing the CIL
(Commited Item List) because almost no-one actively working on XFS
understood how the whole journalling subsystem worked in any detail.

> > Zoetrope Array.
> > Labyrinth of illusion.
> > Structure never ends.
> 
> Thank you for making me look up zoetrope ;-)

My pleasure :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

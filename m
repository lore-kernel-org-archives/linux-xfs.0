Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbdKUMw4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Nov 2017 07:52:56 -0500
Date: Tue, 21 Nov 2017 04:52:53 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171121125253.GA1484@bombadil.infradead.org>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
 <20171120202606.GN5858@dastard>
 <20171120215100.GB8933@bombadil.infradead.org>
 <20171120222749.GO5858@dastard>
 <20171121013753.GA12441@magnolia>
 <20171121043240.GB8774@bombadil.infradead.org>
 <20171121064815.GP5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171121064815.GP5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Tue, Nov 21, 2017 at 05:48:15PM +1100, Dave Chinner wrote:
> On Mon, Nov 20, 2017 at 08:32:40PM -0800, Matthew Wilcox wrote:
> > On Mon, Nov 20, 2017 at 05:37:53PM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 21, 2017 at 09:27:49AM +1100, Dave Chinner wrote:
> > > > First thing I noticed was that "xa" as a prefix is already quite
> > > > widely used in XFS - it's shorthand for "XFS AIL". Indeed, xa_lock
> >
> > The X stands for 'eXpandable' or 'eXtending'.  I really don't want to
> > use more than a two-letter acronym for whatever the XArray ends up being
> > called.  One of the problems with the radix tree is that everything has
> > that 11-character 'radix_tree_' prefix; just replacing that with 'xa_'
> > makes a huge improvement to readability.
> 
> Yeah, understood. That's why
> we have very little clear
> prefix namespace left.... :/
> 
> [ somedays I write something that looks sorta like a haiku, and from
> that point on everything just starts falling out of my brain that
> way. I blame Eric for this today! :P ]

When the namespace is
tight we must consider the
competing users.

The earliest us'r
has a claim to a prefix
we are used to it.

Also a more wide-
spread user has a claim to
a shorter prefix.

Would you mind changing
your prefix to one only
one letter longer?

... ok, I give up ;-)

All your current usage of the xa_ prefix looks somewhat like this:

fs/xfs/xfs_trans_ail.c: spin_lock(&ailp->xa_lock);

with honourable mentions to:
fs/xfs/xfs_log.c:	spin_lock(&mp->m_ail->xa_lock);

Would you mind if I bolt a patch on to the front of the series called
something like "free up xa_ namespace" that renamed your xa_* to ail_*?
There are no uses of the 'ail_' prefix in the kernel today.

I don't think that
	spin_lock(&ailp->ail_lock);
loses any readability.

By the way, what does AIL stand for?  It'd be nice if it were spelled out
in at least one of the header files, maybe fs/xfs/xfs_trans_priv.h?

> Zoetrope Array.
> Labyrinth of illusion.
> Structure never ends.

Thank you for making me look up zoetrope ;-)

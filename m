Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:9874 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750780AbdH3ILJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 04:11:09 -0400
Date: Wed, 30 Aug 2017 18:10:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: skip free eofblocks if inode is under written back
Message-ID: <20170830081030.GL10621@dastard>
References: <20170830042628.5592-1-eguan@redhat.com>
 <20170830072950.GJ10621@dastard>
 <20170830075109.GA4711@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830075109.GA4711@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 12:51:09AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 30, 2017 at 05:29:50PM +1000, Dave Chinner wrote:
> > Quick patch below, doesn't work on reflink filesystems yet because
> > the way it handles cached COW mapping invalidation is unnecessarily
> > special and so doesn't work. Can you test it and see if it fixes the
> > problem?
> 
> FYI, I thought about this problem a while ago in the context of
> rcu lookups of the extent tree (not, I'm not doing those quite yet,
> but I though of the possibilities once we've got a btree!) and
> then my answer was that we'd really need a seqlock around uses of
> the imaps.  I didn't think far enough that we might need something
> like that even now..

Now that you mention it, a seqlock is probably a pretty good
fit for this. I'll have a look at it tomorrow....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

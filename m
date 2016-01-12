Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF2477F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:07:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B75A7304032
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:07:19 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vJAVlKg2LqitNVl7 for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 13:07:16 -0800 (PST)
Date: Wed, 13 Jan 2016 08:05:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/8] xfs: shrink the struct xfs_icdinode
Message-ID: <20160112210517.GK10456@dastard>
References: <1452589280-30167-1-git-send-email-david@fromorbit.com>
	<20160112153010.GA29662@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112153010.GA29662@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 07:30:10AM -0800, Christoph Hellwig wrote:
> Nice!
> 
> I had started on some of this a while ago but never finished it..

*nod*

> > 72 bytes. This means it takes 104 bytes off the size of the struct
> > xfs_inode, which a 12% reduction in size. This will be a massive win
> > for systems that cache lots of inodes!
> 
> How many more inodes can we fit into a slab cache now?  Back when I
> started I noticed it doesn't help us to actually fit more inodes into
> a 4k page due to the bloated VFS inode.  But these days slub actually
> uses a high order allocations if I remember correctly so it might be
> more useful.

On a debug build (because that's the only numbers I have at hand),
the current code is 1280 bytes/inode, 25 inodes/slab, 8 pages/slab.
This patch set makes it 1152 bytes/inode, 28 inodes/slab, 8
pages/slab, so that's a 12% increase in the number of cached inodes
for a given amount of slab memory.

IIRC, a production build is around 960 bytes/inode, so that would
put it at 34 inodes/slab for the current code and 38 inodes/slab
for the current patchset. That, again, is roughly 12% increase in
inodes per slab....

> > With this change made, the xfs_icdinode is no long an "in core disk
> > inode" so I'm wondering whether I should rename it or simply make it
> > go away altogether and pull the remaining fields straight into the
> > struct xfs_inode. Any thoughts on new names and/or getting rid of it
> > woul dbe appreciated.
> 
> I think it should be merged into the xfs_inode structure soner or
> later.

Ok, I'll look at doing that.

> Another thign I planned but never got to is to move fields
> into the inode fork that were specific to the attr or data fork.

That's a whole different problem ;)

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

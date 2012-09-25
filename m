Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PLNThP107761 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 16:23:29 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	atwxy6mQGfyCjJg6 for <xfs@oss.sgi.com>;
	Tue, 25 Sep 2012 14:24:45 -0700 (PDT)
Date: Wed, 26 Sep 2012 07:24:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair: enabling lazy sb counters
Message-ID: <20120925212442.GE29154@dastard>
References: <CAH4wwdG4j_53UYUtU-h3uwaqMOwDz+EsvXLojWKgCx5i7Ftndw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAH4wwdG4j_53UYUtU-h3uwaqMOwDz+EsvXLojWKgCx5i7Ftndw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 25, 2012 at 11:40:33AM -0400, Peter Watkins wrote:
> Hello,
> 
> Has anyone noticed that phase1 updates the lazy count flag in the
> superblock, and then writes out the sb before the traversal in phase5
> counts btree blocks consumed and sets agf_btreeblks?

Not until now. :/

> Seems like if xfs_repair is interrupted or crashes at the wrong time,
> you'd have enabled lazy count but not set agf_btreeblks, which would
> trigger the corruption check in xfs_alloc.c:xfs_read_agf().

Which tells you to run xfs_repair, right?

> If you just re-run xfs_repair to enable lazy counts, it would stop
> early saying they're already enabled. You'd have to disable them, and
> then enable again to get a consistent state.

Or you just run xfs_repair without trying to change the lazy count
state - that will recalculate the btreeblks count as part of the
normal repair process....

> Second, is it possible to enable lazy counts without doing the
> full repair traversal, i.e. a cheap and easy way to set
> agf_btreeblks if the fs is already consistent?  On some systems,
> the whole repair enchilada can take a long time!

The current process is that xfs_repair -rebuilds- the freespace
trees from it's in memory state, and it takes until phase 5 for
xfs_repair to have a full picture of the freespace in the filesystem
after fixing up possible errors.

So basically when you enable lazy counters, repair essentially
verifies all the freespace is correct before enabling it. That's a
necessary pre-requisite for lazy-counters to work correctly, and the
only way to ensure it is to walk the filesystem first.

That said, if you really want to avoid running a full xfs_repair,
you can always count the btree blocks manually with xfs_db and set
the btreeblk count fields yourself. You get to keep the broken
pieces when something goes wrong, though. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

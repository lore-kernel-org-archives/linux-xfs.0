Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9NBch4003539 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 17:11:38 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E13716D26CB
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 15:11:35 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mR9aKF1EeI7izQCA for <xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 15:11:35 -0800 (PST)
Date: Thu, 10 Nov 2011 10:11:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH repair: do not walk the unlinked inode list
Message-ID: <20111109231133.GS5534@dastard>
References: <20111109083729.GA23169@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111109083729.GA23169@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Pfetzing <stefan.pfetzing@1und1.de>, xfs@oss.sgi.com

On Wed, Nov 09, 2011 at 03:37:29AM -0500, Christoph Hellwig wrote:
> Stefan Pfetzing reported a bug where xfs_repair got stuck eating 100% CPU in
> phase3.  We track it down to a loop in the unlinked inode list, apparently
> caused by memory corruption on an iSCSI target.
> 
> I looked into tracking if we already saw a given unlinked inode, but given
> that we keep walking even for inodes where we can't find an allocation btree
> record that seems infeasible.  On the other hand these inodes had their
> final unlink and thus were dead even before the system went down.  There
> really is no point in adding them to the uncertain list and looking for
> references to them later.

You're making the assumption that log recovery has done the correct
thing any only replayed entire unlink transactions and hence the
filesystem is otherwise consistent (i.e that there are no other
references). I think that's a bad assumption - there's no guarantee
that the unlinked list only contains unreferenced inodes if there's
been corruption and/or log replay was not able to be run.

> So the simplest fix seems to be to simply remove the unlinked inode list
> walk and just clear it - when we rebuild the inode allocation btrees these
> will simply be marked free.

I also think there's more to it than that. The walk of the inode list
also marks all the blocks in the block map as containing inodes, and
all the blocks still used by those inodes as data/bmap/attr types.
This change removes that, so we're going to potentially lose that
state if all the inodes in a block are on the unlinked list.

Hence we'll end up with blocks containing inodes that are still
marked as used in the AGINO btree, but are marked as free space in
the block map. We'll also end up with data blocks that are otherwise
still used as not being marked as used, and that is especially
important for discovering multiply allocated blocks when a block has
been freed (e.g. just before unlink) and then immediately
reallocated and then the crash has left the state on disk
inconsistent....

IOWs, it seems to me that simply removing the walk has more
potential downsides in terms of error detection and tracking than it
provides in benefits. I suspect that just capping the number of
loops that can be executed is the simplest thing to do here. e.g.
allow it to loop for as many times as there are inodes allocated in
the AG or filesystem (e.g. agi->agi_count - agi->agi_free). Yes, it will
still spin for some time on this sort of corruption, but it won't
get stuck, and it won't add new holes into our block/inode usage
tracking...

The logical extension of this is that having a "unlinked inode
count" in the AGI would be really useful here. I'll add it to the
(growing) list of "things to add with CRC checking on-disk format
modifications".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

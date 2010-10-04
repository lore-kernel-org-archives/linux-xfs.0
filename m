Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o947IFde050881 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 02:18:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D38D4EB23C7
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 00:32:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	mnJnaX4lqPcmbdbX for <xfs@oss.sgi.com>;
	Mon, 04 Oct 2010 00:32:48 -0700 (PDT)
Date: Mon, 4 Oct 2010 18:19:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: properly account for reclaimed inodes
Message-ID: <20101004071904.GH4681@dastard>
References: <20101001074354.GF2618@cmpxchg.org> <1285953443.2422.4.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285953443.2422.4.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: stable@kernel.org, xfs@oss.sgi.com, John Hawley <warthog9@kernel.org>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

On Fri, Oct 01, 2010 at 12:17:23PM -0500, Alex Elder wrote:
> On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
> > When marking an inode reclaimable, a per-AG counter is increased, the
> > inode is tagged reclaimable in its per-AG tree, and, when this is the
> > first reclaimable inode in the AG, the AG entry in the per-mount tree
> > is also tagged.
> > 
> > When an inode is finally reclaimed, however, it is only deleted from
> > the per-AG tree.  Neither the counter is decreased, nor is the parent
> > tree's AG entry untagged properly.
> > 
> > Since the tags in the per-mount tree are not cleared, the inode
> > shrinker iterates over all AGs that have had reclaimable inodes at one
> > point in time.
> > 
> > The counters on the other hand signal an increasing amount of slab
> > objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
> > per-filesystem context" this is not a real issue anymore because the
> > shrinker bails out after one iteration.
> > 
> > But the problem was observable on a machine running v2.6.34, where the
> > reclaimable work increased and each process going into direct reclaim
> > eventually got stuck on the xfs inode shrinking path, trying to scan
> > several million objects.
> > 
> > Fix this by properly unwinding the reclaimable-state tracking of an
> > inode when it is reclaimed.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: stable@kernel.org
> 
> Yes, this looks right to me.  The state was correctly
> adjusted in xfs_iget_cache_hit() when a RECLAIMABLE
> inode is found in the cache, but it was not done when
> reclaim completes.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Alex, can you push this to Linus ASAP? This needs to go back to
stable kernels as well..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51NpsKH155965 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 18:51:55 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C9D3D6CA39
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 16:51:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	oEPioWcFES5uOxXH for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 16:51:53 -0700 (PDT)
Date: Thu, 2 Jun 2011 09:51:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crashes with shrink_slab:
	xfs_reclaim_inode_shrink+0x0/0x10d negative objects to delete nr
Message-ID: <20110601235150.GL561@dastard>
References: <4DE61A7F.40800@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE61A7F.40800@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

On Wed, Jun 01, 2011 at 12:54:55PM +0200, Stefan Priebe - Profihost AG wrote:
> Hi guys,
> 
> we're seeing a really bad behaviour on one of our machines running
> vanilla 2.6.32.40 kernel.
> 
> It freezes from time to time or processes starts to hang. At the
> same time the following message appears in the kernel log:

Perhaps 2.6.32.40 needs this patch:

commit 081003fff467ea0e727f66d5d435b4f473a789b3
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Fri Oct 1 07:43:54 2010 +0000

    xfs: properly account for reclaimed inodes

    When marking an inode reclaimable, a per-AG counter is increased, the
    inode is tagged reclaimable in its per-AG tree, and, when this is the
    first reclaimable inode in the AG, the AG entry in the per-mount tree
    is also tagged.

    When an inode is finally reclaimed, however, it is only deleted from
    the per-AG tree.  Neither the counter is decreased, nor is the parent
    tree's AG entry untagged properly.

    Since the tags in the per-mount tree are not cleared, the inode
    shrinker iterates over all AGs that have had reclaimable inodes at one
    point in time.

    The counters on the other hand signal an increasing amount of slab
    objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
    per-filesystem context" this is not a real issue anymore because the
    shrinker bails out after one iteration.

    But the problem was observable on a machine running v2.6.34, where the
    reclaimable work increased and each process going into direct reclaim
    eventually got stuck on the xfs inode shrinking path, trying to scan
    several million objects.

    Fix this by properly unwinding the reclaimable-state tracking of an
    inode when it is reclaimed.

    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Cc: stable@kernel.org
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Alex Elder <aelder@sgi.com>

> 
> shrink_slab: xfs_reclaim_inode_shrink+0x0/0x10d negative objects to
> delete nr=-274207938304

That's an error messge that was introduced in 2.6.34, and the above
patch was introduced in 2.6.36. Obvious a bug has been backported to
2.6.32, but was the fix? It was clearly marked for stable kernels,
but I have no I have no idea if the stable kernel folks pushed it
back to .32. I really don't have the time to track what fixes were
or were not backported to what kernels because there are too many
"long term stable" kernels in existance now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

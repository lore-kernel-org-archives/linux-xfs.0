Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91E1oYL080551 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 09:01:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B9F31E72D4A
	for <xfs@oss.sgi.com>; Fri,  1 Oct 2010 07:02:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	48LktbxfBpsYXqqj for <xfs@oss.sgi.com>;
	Fri, 01 Oct 2010 07:02:49 -0700 (PDT)
Date: Sat, 2 Oct 2010 00:02:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: properly account for reclaimed inodes
Message-ID: <20101001140237.GC4681@dastard>
References: <20101001074354.GF2618@cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101001074354.GF2618@cmpxchg.org>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@kernel.org, John Hawley <warthog9@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 01, 2010 at 09:43:54AM +0200, Johannes Weiner wrote:
> When marking an inode reclaimable, a per-AG counter is increased, the
> inode is tagged reclaimable in its per-AG tree, and, when this is the
> first reclaimable inode in the AG, the AG entry in the per-mount tree
> is also tagged.
> 
> When an inode is finally reclaimed, however, it is only deleted from
> the per-AG tree.  Neither the counter is decreased, nor is the parent
> tree's AG entry untagged properly.
> 
> Since the tags in the per-mount tree are not cleared, the inode
> shrinker iterates over all AGs that have had reclaimable inodes at one
> point in time.
> 
> The counters on the other hand signal an increasing amount of slab
> objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
> per-filesystem context" this is not a real issue anymore because the
> shrinker bails out after one iteration.
> 
> But the problem was observable on a machine running v2.6.34, where the
> reclaimable work increased and each process going into direct reclaim
> eventually got stuck on the xfs inode shrinking path, trying to scan
> several million objects.
> 
> Fix this by properly unwinding the reclaimable-state tracking of an
> inode when it is reclaimed.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@kernel.org

Looks OK to me, and has run through a few hours of testing without
problems.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

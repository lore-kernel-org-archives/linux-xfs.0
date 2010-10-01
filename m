Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91HH7QV100479 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 12:17:07 -0500
Subject: Re: [patch] xfs: properly account for reclaimed inodes
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101001074354.GF2618@cmpxchg.org>
References: <20101001074354.GF2618@cmpxchg.org>
Date: Fri, 01 Oct 2010 12:17:23 -0500
Message-ID: <1285953443.2422.4.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
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

Yes, this looks right to me.  The state was correctly
adjusted in xfs_iget_cache_hit() when a RECLAIMABLE
inode is found in the cache, but it was not done when
reclaim completes.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

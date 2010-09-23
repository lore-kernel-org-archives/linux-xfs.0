Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NHnhFu139322 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 12:49:44 -0500
Subject: Re: [PATCH 14/16] xfs: serialise inode reclaim within an AG
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-15-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-15-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 12:50:38 -0500
Message-ID: <1285264238.1973.68.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Memory reclaim via shrinkers has a terrible habit of having N+M
> concurrent shrinker executions (N = num CPUs, M = num kswapds) all
> trying to shrink the same cache. When the cache they are all working
> on is protected by a single spinlock, massive contention an
> slowdowns occur.
> 
> Wrap the per-ag inode caches with a reclaim mutex to serialise
> reclaim access to the AG. This will block concurrent reclaim in each
> AG but still allow reclaim to scan multiple AGs concurrently. Allow
> shrinkers to move on to the next AG if it can't get the lock, and if
> we can't get any AG, then start blocking on locks.
> 
> To prevent reclaimers from continually scanning the same inodes in
> each AG, add a cursor that tracks where the last reclaim got up to
> and start from that point on the next reclaim. This should avoid
> only ever scanning a small number of inodes at the satart of each AG
> and not making progress. If we have a non-shrinker based reclaim
> pass, ignore the cursor and reset it to zero once we are done.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

One small comment about the implied meaning of "trylock"
below.  But not a big deal, so...

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_sync.c |   24 ++++++++++++++++++++++++
>  fs/xfs/xfs_ag.h             |    2 ++
>  fs/xfs/xfs_mount.c          |    1 +
>  3 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index ea44b1d..7b06399 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c

. . .

> @@ -840,6 +842,17 @@ xfs_reclaim_inodes_ag(
>  
>  		ag = pag->pag_agno + 1;
>  
> +		if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
> +			if (trylock) {
> +				trylock++;
> +				continue;
> +			}
> +			mutex_lock(&pag->pag_ici_reclaim_lock);
> +		}
> +

It isn't all that obvious here that "trylock" also
carries the meaning "called via the inode shrinker",
which is why we're using the cursor in this case.

> +		if (trylock)
> +			first_index = pag->pag_ici_reclaim_cursor;
> +
>  		do {
>  			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
>  			int	i;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

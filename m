Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FLRdCK212045 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 16:27:39 -0500
Subject: Re: [PATCH 17/18] xfs: add a lru to the XFS buffer cache
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-18-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-18-git-send-email-david@fromorbit.com>
Date: Wed, 15 Sep 2010 16:28:25 -0500
Message-ID: <1284586105.2452.50.camel@doink>
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

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce a per-buftarg LRU for memory reclaim to operate on. This
> is the last piece we need to put in place so that we can fully
> control the buffer lifecycle. This allows XFS to be responsibile for
> maintaining the working set of buffers under memory pressure instead
> of relying on the VM reclaim not to take pages we need out from
> underneath us.
> 
> The implementation is currently a bit naive - it does not rotate
> buffers on the LRU when they are accessed multiple times. Solving
> this problem is for a later patch series that re-introduces the
> buffer type specific reclaim reference counts to prioritise reclaim
> more effectively.

Two small comments below, otherwise looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |   91 ++++++++++++++++++++++++++++++++++---------
>  fs/xfs/linux-2.6/xfs_buf.h |    5 ++
>  2 files changed, 77 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 3b54fee..12b37c6 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c

. . .

> @@ -1446,27 +1466,29 @@ xfs_buf_iomove(
>   */
>  
>  /*
> - *	Wait for any bufs with callbacks that have been submitted but
> - *	have not yet returned... walk the hash list for the target.
> + * Wait for any bufs with callbacks that have been submitted but have not yet
> + * returned. These buffers will have an elevated hold count, so wait on those
> + * while freeing all the buffers only held by the LRU.
>   */
>  void
>  xfs_wait_buftarg(
>  	struct xfs_buftarg	*btp)
>  {
> -	struct xfs_perag	*pag;
> -	uint			i;
> -
> -	for (i = 0; i < btp->bt_mount->m_sb.sb_agcount; i++) {
> -		pag = xfs_perag_get(btp->bt_mount, i);
> -		spin_lock(&pag->pag_buf_lock);
> -		while (rb_first(&pag->pag_buf_tree)) {
> -			spin_unlock(&pag->pag_buf_lock);
> +	struct xfs_buf		*bp;

(Insert blank line here.)

> +restart:
> +	spin_lock(&btp->bt_lru_lock);
> +	while (!list_empty(&btp->bt_lru)) {
> +		bp = list_first_entry(&btp->bt_lru, struct xfs_buf, b_lru);
> +		if (atomic_read(&bp->b_hold) > 1) {
> +			spin_unlock(&btp->bt_lru_lock);
>  			delay(100);
> -			spin_lock(&pag->pag_buf_lock);
> +			goto restart;
>  		}
> -		spin_unlock(&pag->pag_buf_lock);
> -		xfs_perag_put(pag);
> +		spin_unlock(&btp->bt_lru_lock);
> +		xfs_buf_rele(bp);
> +		spin_lock(&btp->bt_lru_lock);
>  	}
> +	spin_unlock(&btp->bt_lru_lock);
>  }
>  
>  int
> @@ -1477,15 +1499,44 @@ xfs_buftarg_shrink(
>  {
>  	struct xfs_buftarg	*btp = container_of(shrink,
>  					struct xfs_buftarg, bt_shrinker);
> -	if (nr_to_scan) {
> -		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
> -			return -1;
> -		if (list_empty(&btp->bt_delwrite_queue))
> -			return -1;
> +	struct xfs_buf		*bp, *n;
> +
> +	if (!nr_to_scan)
> +		return btp->bt_lru_nr;
> +
> +	spin_lock(&btp->bt_lru_lock);
> +	if (test_and_set_bit(XBT_SHRINKER_ACTIVE, &btp->bt_flags)) {

Since test_and_set_bit() and clear_bit() are already atomic
you don't need to be under protection of bt_lru_lock to
manipulate the flags.  Get the spinlock after you've set
XBT_SHRINKER_ACTIVE (and clear it outside the spinlock
also).

> +		/* LRU walk already in progress */
> +		spin_unlock(&btp->bt_lru_lock);
> +		return -1;
> +	}
> +
> +	list_for_each_entry_safe(bp, n, &btp->bt_lru, b_lru) {
> +		if (nr_to_scan-- <= 0)
> +			break;

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

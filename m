Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HImBUK171683 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 12:48:11 -0600
Message-ID: <4F15C26A.30408@sgi.com>
Date: Tue, 17 Jan 2012 12:48:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 01/12] xfs: split tail_lsn assignments from log space
	wakeups
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141433.542846138@bombadil.infradead.org>
In-Reply-To: <20111212141433.542846138@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Currently xfs_log_move_tail has a tail_lsn argument that is horribly
> overloaded: it may contain either an actual lsn to assign to the log tail,
> 0 as a special case to use the last sync LSN, or 1 to indicate that no tail
> LSN assignment should be performed, and we should opportunisticly wake up
> at least one task waiting for log space.

I read the code as opportunistically waking at MOST one task per call.

> Remove the tail lsn assigned from xfs_log_move_tail and make the two callers
> use xlog_assign_tail_lsn instead of the current variant of partially using
> the code in xfs_log_move_tail and partially opencoding it.  Note that means
> we grow an addition lock roundtrip on the AIL lock for each bulk update
> or delete, which is still far less than what we had before introducing the
> bulk operations.  If this proves to be a problem we can still add a variant
> of xlog_assign_tail_lsn that expects the lock to be held already.
>

Just looking at it the additional unlock/lock sequence did not appear 
too major.

> Also rename the remainder of xfs_log_move_tail to xfs_log_space_wake as
> that name describes its functionality much better.
>

...

> Index: xfs/fs/xfs/xfs_trans_ail.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-11-29 08:38:46.870067201 +0100
> +++ xfs/fs/xfs/xfs_trans_ail.c	2011-11-29 08:38:48.580057936 +0100
> @@ -643,15 +643,15 @@ xfs_trans_unlocked_item(
>   	 * at the tail, it doesn't matter what result we get back.  This
>   	 * is slightly racy because since we were just unlocked, we could
>   	 * go to sleep between the call to xfs_ail_min and the call to
> -	 * xfs_log_move_tail, have someone else lock us, commit to us disk,
> +	 * xfs_log_space_wake, have someone else lock us, commit to us disk,
>   	 * move us out of the tail of the AIL, and then we wake up.  However,
> -	 * the call to xfs_log_move_tail() doesn't do anything if there's
> +	 * the call to xfs_log_space_wake() doesn't do anything if there's
>   	 * not enough free space to wake people up so we're safe calling it.
>   	 */
>   	min_lip = xfs_ail_min(ailp);
>
>   	if (min_lip == lip)
> -		xfs_log_move_tail(ailp->xa_mount, 1);
> +		xfs_log_space_wake(ailp->xa_mount, 1);
>   }	/* xfs_trans_unlocked_item */

Looks great. Just to be consistent, you could call the above as:

+		xfs_log_space_wake(ailp->xa_mount, true);


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

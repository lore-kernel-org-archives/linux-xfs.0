Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NIr4O6142089 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 13:53:04 -0500
Subject: Re: [PATCH] xfs: force background CIL push under sustained load
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285208863-31489-1-git-send-email-david@fromorbit.com>
References: <1285208863-31489-1-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 13:53:55 -0500
Message-ID: <1285268035.1973.109.camel@doink>
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

On Thu, 2010-09-23 at 12:27 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I have been seeing relatively frequent pauses in transaction throughput up to
> 30s long under heavy parallel workloads. The only thing that seemed strange
> about them was that the xfsaild was active during the pauses, but making no
> progress. It was running exactly 20 times a second (on the 50ms no-progress
> backoff), and the number of pushbuf events was constant across this time as
> well.  IOWs, the xfsaild appeared to be stuck on buffers that it could not push
> out.
> 
> Further investigation indicated that it was trying to push out inode buffers
> that were pinned and/or locked. The xfsbufd was also getting woken at the same
> frequency (by the xfsaild, no doubt) to push out delayed write buffers. The
> xfsbufd was not making any progress because all the buffers in the delwri queue
> were pinned. This scan and make no progress dance went one in the trace for
> some seconds, before the xfssyncd came along an issued a log force, and then
> things started going again.
> 
> However, I noticed something strange about the log force - there were way too
> many IO's issued. 516 log buffers were written, to be exact. That added up to
> 129MB of log IO, which got me very interested because it's almost exactly 25%
> of the size of the log. That "25% of the log" is actually very important - it's
> the distance that tail-pushing tries to keep free in the log; i.e. where it
> pushes to. Further, the delayed logging code is suppose to aggregate the
> minimum of 25% of the log or 8MB worth of changes before flushing. That's what
> really puzzled me - why did a log force write 129MB instead of only 8MB?
> 
> Essentially what has happened is that no CIL pushes had occurred since the
> previous tail push which cleared out 25% of the log space. That caused all the
> new transactions to block because there wasn't log space for them, but they
> kick the xfsaild to push the tail. However, the xfsaild was not making
> progress because there were buffers it could not lock and flush, and the
> xfsbufd could not flush them because they were pinned. As a result, both
> the xfsaild and the xfsbufd could not move the tail of the log forward without
> the CIL first committing.
> 
> The cause of the problem was that the background CIL push, which should happen
> when 8MB of aggregated changes have been committed, is being held off by the
> concurrent transaction commit load. The background push does a
> down_write_trylock() which will fail if there is a concurrent transaction
> commit holding the push lock in read mode. With 8 CPUs all doing transactions
> as fast as they can, there was enough concurrent transaction commits to hold
> off the background push until tail-pushing could no longer free log space,
> and the halt would occur.
> 
> It should be noted that there is no reason why it would halt at 25% of log
> space used by a single CIL checkpoint. This bug could definitely violate the
> "no transaction should be larger than half the log" requirement and hence
> result in corruption if the system crashed under heavy load. This sort of
> bug is exactly the reason why delayed logging was tagged as experimental....
> 
> The fix is to start blocking background pushes once the threshold has been
> exceeded by 50%. This is still only 37.5% of log space at worst, so keeps us
> well short of the limit a transaction must not exceed.

This looks good.  You're making the CIL push be controlled by
low/high water marks, basically, with a "best effort" at the
low water mark (XLOG_CIL_SPACE_LIMIT()) and forced once
XLOG_CIL_HARD_SPACE_LIMIT() has been reached.  And the
important bug fix is that previously there was no point at
which the forced push would occur.

As usual I have a bit of gratuitous commentary below,
but this change looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  |   12 +++++++++---
>  fs/xfs/xfs_log_priv.h |   28 ++++++++++++++++++++--------
>  2 files changed, 29 insertions(+), 11 deletions(-)

. . .

> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ced52b9..9776956 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -460,15 +460,27 @@ struct xfs_cil {
>   * than the CIL itself.
>   *
>   * With dynamic reservations, we can basically make up arbitrary limits for the
> - * checkpoint size so long as they don't violate any other size rules.  Hence
> - * the initial maximum size for the checkpoint transaction will be set to a
> - * quarter of the log or 8MB, which ever is smaller. 8MB is an arbitrary limit
> - * right now based on the latency of writing out a large amount of data through
> - * the circular iclog buffers.
> + * checkpoint size so long as they don't violate any other size rules. A key
> + * size we should try to keep below is the AIL push threshold which is 25% of
> + * the log. That is how much empty space in the log the transaction reservation
> + * subsystem tries to keep free. If we make transactions larger than that, then
> + * we risk requiring more space for the transaction commit than the AIL will
> + * try to free for us. Hence the maximum size we should allow is under 25% of
> + * the log. This will also keep us below the "no transaction shoul dbe more

s/shoul dbe/should be/

> + * than half the log" rule that recovery requires us to keep.
> + *
> + * Further, we need to make sure the background CIL push is efficient, which
> + * means we need to give the background push a chance to commit without
> + * blocking all the current transaction commits. Hence we need some space
> + * between the threshold and the 25% limit to allow background pushes to be
> + * tried, but not enforced. To make this simple and fast to calculate, set
> + * the background push threshold to 1/8th (12.5%) the size of the log, and then start
> + * enforcing the background push at 50% above this. i.e. at 3/16th or 18.75% of
> + * the log size. This should keep us well under the limits of the AIL pushing
> + * threshold, yet give us plenty of space for aggregation on large logs.
>   */

I think the above explanation is pretty good but I don't know that it's
as clear or concise as it could be.  I don't claim this is better but
I'll take a shot (I don't like offering criticism without suggesting
an alternative).

 * With dynamic reservations, we can basically make up arbitrary
 * limits for the checkpoint size so long as they don't violate any
 * other size rules.  Recovery imposes a rule that no transaction
 * exceed half the log, so we are limited by that.  Furthermore, the
 * log transaction reservation subsystem tries to keep 25% of the
 * log free, so we should keep below that limit or we risk not being
 * able to get the space we need.
 *
 * In order to keep background CIL push efficient, we will set a
 * lower threshold at which background pushing is attempted without
 * blocking current transaction commits.  A separate, higher bound
 * defines when CIL pushes are forced in order to ensure we stay
 * within our transaction size limits.

> -
> -#define XLOG_CIL_SPACE_LIMIT(log)	\
> -	(min((log->l_logsize >> 2), (8 * 1024 * 1024)))
> +#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
> +#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))

Maybe "LIMIT" isn't quite the right name for these two.
(But I have no better suggestion.)

I don't really care much about this, but I'll take this
opportunity for a small rant.

The difference in calculation cost/speed between "x >> 3" and
"x / 8" is vanishingly small.  I think it is meaningful to use
a shift in places where a power-of-two is mandated, but in places
like this it suggests there is a constraint that simply doesn't
exist.  So for example, you could have chosen (log->logsize / 10)
as the "try pushing" value, and (log->logsize / 4 - 1) as the
"must push" value.

Anyway, this is all fine as-is, it just surprises me that
people still use this idiom when it makes such a negligible
actual difference in execution.

>  
>  /*
>   * The reservation head lsn is not made up of a cycle number and block number.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

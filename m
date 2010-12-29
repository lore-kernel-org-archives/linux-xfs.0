Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBTFmOMr083802 for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 09:48:24 -0600
Subject: Re: [PATCH 30/34] xfs: convert l_tail_lsn to an atomic variable.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1292916570-25015-31-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-31-git-send-email-david@fromorbit.com>
Date: Wed, 29 Dec 2010 09:49:24 -0600
Message-ID: <1293637764.1961.44.camel@doink>
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

On Tue, 2010-12-21 at 18:29 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> log->l_tail_lsn is currently protected by the log grant lock. The
> lock is only needed for serialising readers against writers, so we
> don't really need the lock if we make the l_tail_lsn variable an
> atomic. Converting the l_tail_lsn variable to an atomic64_t means we
> can start to peel back the grant lock from various operations.
> 
> Also, provide functions to safely crack an atomic LSN variable into
> it's component pieces and to recombined the components into an
> atomic variable. Use them where appropriate.
> 
> This also removes the need for explicitly holding a spinlock to read
> the l_tail_lsn on 32 bit platforms.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  A few things to consider, below.

Reviewed by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_trace.h |    2 +-
>  fs/xfs/xfs_log.c             |   56 ++++++++++++++++++-----------------------
>  fs/xfs/xfs_log_priv.h        |   37 +++++++++++++++++++++++----
>  fs/xfs/xfs_log_recover.c     |   14 ++++------
>  4 files changed, 63 insertions(+), 46 deletions(-)

. . .

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 70790eb..d118bf8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c

. . .

> @@ -2828,11 +2821,11 @@ xlog_state_release_iclog(
>  
>  	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
>  		/* update tail before writing to iclog */

I personally don't like comments above local variable
definitions.  So I ask that you rearrange this.

> -		xlog_assign_tail_lsn(log->l_mp);
> +		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);

Insert a blank line here too.

>  		sync++;
>  		iclog->ic_state = XLOG_STATE_SYNCING;
> -		iclog->ic_header.h_tail_lsn = cpu_to_be64(log->l_tail_lsn);
> -		xlog_verify_tail_lsn(log, iclog, log->l_tail_lsn);
> +		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +		xlog_verify_tail_lsn(log, iclog, tail_lsn);
>  		/* cycle incremented when incrementing curr_block */
>  	}
>  	spin_unlock(&log->l_icloglock);

. . .

> @@ -3445,9 +3438,10 @@ xlog_verify_grant_tail(
>  	 * check the byte count.
>  	 */


Do you suppose the compiler optimizes all of
the following out with a non-debug build?  If not
maybe it could be put into a debug-only helper
function.

>  	xlog_crack_grant_head(&log->l_grant_write_head, &cycle, &space);
> -	if (CYCLE_LSN(tail_lsn) != cycle) {
> -		ASSERT(cycle - 1 == CYCLE_LSN(tail_lsn));
> -		ASSERT(space <= BBTOB(BLOCK_LSN(tail_lsn)));
> +	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
> +	if (tail_cycle != cycle) {
> +		ASSERT(cycle - 1 == tail_cycle);
> +		ASSERT(space <= BBTOB(tail_blocks));
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 958f356..d34af1c 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -53,7 +53,6 @@ struct xfs_mount;
>  	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
>  	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
>  
> -

Kill this hunk.

>  static inline xfs_lsn_t xlog_assign_lsn(uint cycle, uint block)
>  {
>  	return ((xfs_lsn_t)cycle << 32) | block;

. . .

> @@ -566,6 +566,31 @@ int	xlog_write(struct log *log, struct xfs_log_vec *log_vector,
>  				xlog_in_core_t **commit_iclog, uint flags);
>  
>  /*
> + * When we crack an atomic LSN, we sample it first so that the value will not
> + * change while we are cracking it into the component values. This means we
> + * will always get consistent component values to work from. This should always
> + * be used to smaple and crack LSNs taht are stored and updated in atomic

                sample                 that

> + * variables.
> + */
> +static inline void
> +xlog_crack_atomic_lsn(atomic64_t *lsn, uint *cycle, uint *block)

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q271HQ3T252236 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 19:17:27 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	56E4FSaWZDSQBXlO for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 17:17:24 -0800 (PST)
Date: Wed, 7 Mar 2012 12:17:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix oops on IO error during
	xlog_recover_process_iunlinks()
Message-ID: <20120307011716.GI3592@dastard>
References: <1331031616-31692-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1331031616-31692-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On Tue, Mar 06, 2012 at 12:00:16PM +0100, Jan Kara wrote:
> When an IO error happens during inode deletion run from
> xlog_recover_process_iunlinks() filesystem gets shutdown. Thus any subsequent
> attempt to read buffers fails. Code in xlog_recover_process_iunlinks() does not
> count with the fact that read of a buffer which was read a while ago can
> really fail which results in the oops on
>   agi = XFS_BUF_TO_AGI(agibp);
> 
> Fix the problem by handling error from xfs_read_agi() in all cases.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_log_recover.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0ed9ee7..3899264 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3178,11 +3178,17 @@ xlog_recover_process_iunlinks(
>  
>  				/*
>  				 * Reacquire the agibuffer and continue around
> -				 * the loop. This should never fail as we know
> -				 * the buffer was good earlier on.
> +				 * the loop.
>  				 */
>  				error = xfs_read_agi(mp, NULL, agno, &agibp);
> -				ASSERT(error == 0);
> +				/*
> +				 * We failed to read a buffer we succeeded
> +				 * reading just a while ago. Likely because the
> +				 * filesystem is shutdown now. Just try the
> +				 * next AG.
> +				 */
> +				if (error)
> +					goto next_ag;
>  				agi = XFS_BUF_TO_AGI(agibp);
>  			}
>  		}

That function is full of ugly code. We don't need to continually
lock and unlock the AGI in the inner loop. Indeed, we probably don't
even need to lock the buffer to read the AGI bucket entries because
we aren't going to be racing with anyone here. Hence all we really
need is an extra hold on the agi buffer to make sure it doesn't go
away once we've dropped the lock via xfs_buf_relse(). i.e.


	/*
	 * take an extra reference to the buffer and then release it
	 * to drop the lock so that it can be acquired in the normal
	 * course of the transaction to truncate and free each
	 * inode.  Because we are not racing with anyone else here
	 * for the AGI buffer, we don't even need to hold it locked
	 * to read the initial unlinked bucket entries out of the
	 * buffer.
	 */
	agi = XFS_BUF_TO_AGI(agibp);
	xfs_buf_hold(agibp);
	xfs_buf_relse(agibp);
	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
		while (agino != NULLAGINO) {
			agino = xlog_recover_process_one_iunlink(mp,
					agno, agino, bucket);
		}
	}
	xfs_buf_rele(agibp)


Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

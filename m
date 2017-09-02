Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbdIBNT7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 Sep 2017 09:19:59 -0400
Date: Sat, 2 Sep 2017 09:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170902131955.GB36492@bfoster.bfoster>
References: <1504280365-25354-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504280365-25354-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org

On Fri, Sep 01, 2017 at 06:39:25PM +0300, Amir Goldstein wrote:
> When calling into _xfs_log_force{,_lsn}() with a pointer
> to log_flushed variable, log_flushed will be set to 1 if:
> 1. xlog_sync() is called to flush the active log buffer
> AND/OR
> 2. xlog_wait() is called to wait on a syncing log buffers
> 
> xfs_file_fsync() checks the value of log_flushed after
> _xfs_log_force_lsn() call to optimize away an explicit
> PREFLUSH request to the data block device after writing
> out all the file's pages to disk.
> 
> This optimization is incorrect in the following sequence of events:
> 
>  Task A                    Task B
>  -------------------------------------------------------
>  xfs_file_fsync()
>    _xfs_log_force_lsn()
>      xlog_sync()
>         [submit PREFLUSH]
>                            xfs_file_fsync()
>                              file_write_and_wait_range()
>                                [submit WRITE X]
>                                [endio  WRITE X]
>                              _xfs_log_force_lsn()
>                                xlog_wait()
>         [endio  PREFLUSH]
> 
> The write X is not guarantied to be on persistent storage
> when PREFLUSH request in completed, because write A was submitted
> after the PREFLUSH request, but xfs_file_fsync() of task A will
> be notified of log_flushed=1 and will skip explicit flush.
> 
> If the system crashes after fsync of task A, write X may not be
> present on disk after reboot.
> 
> This bug was discovered and demonstrated using Josef Bacik's
> dm-log-writes target, which can be used to record block io operations
> and then replay a subset of these operations onto the target device.
> The test goes something like this:
> - Use fsx to execute ops of a file and record ops on log device
> - Every now and then fsync the file, store md5 of file and mark

>   md5 of file to stored value
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Christoph,
> 
> Here is another, more subtle, version of the fix.
> It keeps a lot more use cases optimized (e.g. many threads doing fsync
> and setting WANT_SYNC may still be optimized).
> It also addresses your concern that xlog_state_release_iclog()
> may not actually start the buffer sync.
> 
> I tried to keep the logic as simple as possible:
> If we see a buffer who is not yet SYNCING and we later
> see that l_last_sync_lsn is >= to the lsn of that buffer,
> we can safely say log_flushed.
> 
> I only tested this patch through a few crash test runs, not even full
> xfstests cycle, so I am not sure it is correct, just posting to get
> your feedback.
> 
> Is it worth something over the simpler v1 patch?
> I can't really say.
> 

This looks like it has a couple potential problems on a very quick look
(so I could definitely be mistaken). E.g., the lsn could be zero at the
time we set log_flushed in _xfs_log_force(). It also looks like waiting
on an iclog that is waiting to run callbacks due to out of order
completion could be interpreted as a log flush having occurred, but I
haven't stared at this long enough to say whether that is actually
possible.

Stepping back from the details.. this seems like it could be done
correctly in general. IIUC what you want to know is whether any iclog
went from a pre-SYNCING state to a post-SYNCING state during the log
force, right? The drawbacks to this are that the log states do not by
design tell us whether devices have been flushed (landmine alert).
AFAICS, the last tail lsn isn't necessarily updated on every I/O
completion either.

I'm really confused by the preoccupation with finding a way to keep this
fix localized to xfs_log_force(), as if that provides some inherent
advantage over fundamentally more simple code. If anything, the fact
that this has been broken for so long suggests that is not the case.

I'll reiterate my previous comment.. if we want to track device flush
submits+completes, please just track them directly in the buftarg using
the existing buffer flush flag and the common buffer
submission/completion paths that we already use for this kind of generic
mechanism (e.g., in-flight async I/O accounting, read/write verifiers).
I don't really see any benefit to this, at least until/unless we find
some reason to rule out the other approach.

Brian

> Amir.
> 
>  fs/xfs/xfs_log.c | 76 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 58 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0053bcf2b10a..65e867ec00f9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3246,7 +3246,7 @@ _xfs_log_force(
>  {
>  	struct xlog		*log = mp->m_log;
>  	struct xlog_in_core	*iclog;
> -	xfs_lsn_t		lsn;
> +	xfs_lsn_t		lsn_flushed = 0;
>  
>  	XFS_STATS_INC(mp, xs_log_force);
>  
> @@ -3290,17 +3290,22 @@ _xfs_log_force(
>  				 * the previous sync.
>  				 */
>  				atomic_inc(&iclog->ic_refcnt);
> -				lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +				lsn_flushed = be64_to_cpu(iclog->ic_header.h_lsn);
>  				xlog_state_switch_iclogs(log, iclog, 0);
>  				spin_unlock(&log->l_icloglock);
>  
>  				if (xlog_state_release_iclog(log, iclog))
>  					return -EIO;
>  
> -				if (log_flushed)
> -					*log_flushed = 1;
>  				spin_lock(&log->l_icloglock);
> -				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn &&
> +				/*
> +				 * By the time we come around again, the iclog
> +				 * could've been filled which would give it
> +				 * another lsn.  If we have a new lsn, just
> +				 * return because the relevant data has been
> +				 * flushed.
> +				 */
> +				if (be64_to_cpu(iclog->ic_header.h_lsn) == lsn_flushed &&
>  				    iclog->ic_state != XLOG_STATE_DIRTY)
>  					goto maybe_sleep;
>  				else
> @@ -3317,10 +3322,6 @@ _xfs_log_force(
>  		}
>  	}
>  
> -	/* By the time we come around again, the iclog could've been filled
> -	 * which would give it another lsn.  If we have a new lsn, just
> -	 * return because the relevant data has been flushed.
> -	 */
>  maybe_sleep:
>  	if (flags & XFS_LOG_SYNC) {
>  		/*
> @@ -3333,6 +3334,15 @@ _xfs_log_force(
>  			spin_unlock(&log->l_icloglock);
>  			return -EIO;
>  		}
> +		/*
> +		 * Snapshot lsn of iclog if there is no risk that flush has been
> +		 * issued already for that iclog.
> +		 */
> +		if (!lsn_flushed &&
> +		    !(iclog->ic_state &
> +		      (XLOG_STATE_DONE_SYNC | XLOG_STATE_SYNCING)))
> +			lsn_flushed = be64_to_cpu(iclog->ic_header.h_lsn);
> +
>  		XFS_STATS_INC(mp, xs_log_force_sleep);
>  		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
>  		/*
> @@ -3342,13 +3352,22 @@ _xfs_log_force(
>  		 */
>  		if (iclog->ic_state & XLOG_STATE_IOERROR)
>  			return -EIO;
> -		if (log_flushed)
> -			*log_flushed = 1;
>  	} else {
>  
>  no_sleep:
>  		spin_unlock(&log->l_icloglock);
>  	}
> +
> +	if (log_flushed) {
> +		/*
> +		 * We only report log_flushed if flush has been issued after
> +		 * entering this function (for lsn) and has already completed.
> +		 * It could be that we issued the flush or another thread, as
> +		 * long as we have seen this lsn in pre SYNCING state.
> +		 */
> +		if (XFS_LSN_CMP(lsn_flushed, atomic64_read(&log->l_last_sync_lsn)) <= 0)
> +			*log_flushed = 1;
> +	}
>  	return 0;
>  }
>  
> @@ -3391,6 +3410,7 @@ _xfs_log_force_lsn(
>  	struct xlog		*log = mp->m_log;
>  	struct xlog_in_core	*iclog;
>  	int			already_slept = 0;
> +	xfs_lsn_t		lsn_flushed = 0;
>  
>  	ASSERT(lsn != 0);
>  
> @@ -3445,10 +3465,15 @@ _xfs_log_force_lsn(
>  
>  				XFS_STATS_INC(mp, xs_log_force_sleep);
>  
> +				/*
> +				 * prev iclog is not SYNCING so flush is going
> +				 * to be issued.
> +				 */
> +				if (iclog->ic_prev->ic_state & XLOG_STATE_WANT_SYNC)
> +					lsn_flushed = be64_to_cpu(iclog->ic_prev->ic_header.h_lsn);
> +
>  				xlog_wait(&iclog->ic_prev->ic_write_wait,
>  							&log->l_icloglock);
> -				if (log_flushed)
> -					*log_flushed = 1;
>  				already_slept = 1;
>  				goto try_again;
>  			}
> @@ -3457,8 +3482,6 @@ _xfs_log_force_lsn(
>  			spin_unlock(&log->l_icloglock);
>  			if (xlog_state_release_iclog(log, iclog))
>  				return -EIO;
> -			if (log_flushed)
> -				*log_flushed = 1;
>  			spin_lock(&log->l_icloglock);
>  		}
>  
> @@ -3473,6 +3496,15 @@ _xfs_log_force_lsn(
>  				spin_unlock(&log->l_icloglock);
>  				return -EIO;
>  			}
> +			/*
> +			 * Snapshot lsn of iclog if there is no risk that flush
> +			 * has been issued already for that iclog.
> +			 */
> +			if (!lsn_flushed &&
> +			    !(iclog->ic_state &
> +			      (XLOG_STATE_DONE_SYNC | XLOG_STATE_SYNCING)))
> +			lsn_flushed = be64_to_cpu(iclog->ic_header.h_lsn);
> +
>  			XFS_STATS_INC(mp, xs_log_force_sleep);
>  			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
>  			/*
> @@ -3482,9 +3514,6 @@ _xfs_log_force_lsn(
>  			 */
>  			if (iclog->ic_state & XLOG_STATE_IOERROR)
>  				return -EIO;
> -
> -			if (log_flushed)
> -				*log_flushed = 1;
>  		} else {		/* just return */
>  			spin_unlock(&log->l_icloglock);
>  		}
> @@ -3493,6 +3522,17 @@ _xfs_log_force_lsn(
>  	} while (iclog != log->l_iclog);
>  
>  	spin_unlock(&log->l_icloglock);
> +
> +	if (log_flushed) {
> +		/*
> +		 * We only report log_flushed if flush has been issued after
> +		 * entering this function (for lsn) and has already completed.
> +		 * It could be that we issued the flush or another thread, as
> +		 * long as we have seen this lsn in pre SYNCING state.
> +		 */
> +		if (XFS_LSN_CMP(lsn_flushed, atomic64_read(&log->l_last_sync_lsn)) <= 0)
> +			*log_flushed = 1;
> +	}
>  	return 0;
>  }
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

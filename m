Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 03:41:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3UAeuCq030647
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 03:41:01 -0700
Date: Wed, 30 Apr 2008 20:41:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430104125.GM108924158@sgi.com>
References: <20080430090502.GH14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430090502.GH14976@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 30, 2008 at 03:05:03AM -0600, Matthew Wilcox wrote:
> 
> The l_flushsema doesn't exactly have completion semantics, nor mutex
> semantics.  It's used as a list of tasks which are waiting to be notified
> that a flush has completed.  It was also being used in a way that was
> potentially racy, depending on the semaphore implementation.
> 
> By using a waitqueue instead of a semaphore we avoid the need for a
> separate counter, since we know we just need to wake everything on the
> queue.

Looks good at first glance. thanks for doing this, Matthew.
I've been swamped the last couple of days so I haven't had
a chance to do this myself....

> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> -- 
> 
> I've only given this light testing, it could use some more.

Yeah, I've pulled it into my qa tree so it'll get some shaking down.
If it survives for a while, I'll push it into the xfs tree.
One comment, though:

> @@ -2278,14 +2277,9 @@ xlog_state_do_callback(
>  	}
>  #endif
>  
> -	flushcnt = 0;
> -	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) {
> -		flushcnt = log->l_flushcnt;
> -		log->l_flushcnt = 0;
> -	}
> +	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) 
> +		wake_up_all(&log->l_flush_wq);
>  	spin_unlock(&log->l_icloglock);
> -	while (flushcnt--)
> -		vsema(&log->l_flushsema);

The only thing that I'm concerned about here is that this will
substantially increase the time the l_icloglock is held. This is
a severely contended lock on large cpu count machines and putting
the wakeup inside this lock will increase the hold time.

I guess I can address this by adding a new lock for the waitqueue
in a separate patch set.

Hmmm - CONFIG_XFS_DEBUG builds break in the xfs-dev tree with
this patch (in the xfs kdb module). I'll fix this up as well.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

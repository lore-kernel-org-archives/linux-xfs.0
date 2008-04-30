Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 03:23:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UANZC5028913
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 03:23:43 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F23A710E7518
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 03:24:18 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id DVB0S9axUFB2kqeL for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 03:24:18 -0700 (PDT)
Date: Wed, 30 Apr 2008 04:24:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430102417.GK14976@parisc-linux.org>
References: <20080430090502.GH14976@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430090502.GH14976@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 30, 2008 at 03:05:03AM -0600, Matthew Wilcox wrote:
> @@ -2385,12 +2379,13 @@ restart:
>  
>  	iclog = log->l_iclog;
>  	if (! (iclog->ic_state == XLOG_STATE_ACTIVE)) {
> -		log->l_flushcnt++;
> +		DEFINE_WAIT(wait);
> +		prepare_to_wait(&log->l_flush_wq, &wait, TASK_UNINTERRUPTIBLE);
>  		spin_unlock(&log->l_icloglock);
>  		xlog_trace_iclog(iclog, XLOG_TRACE_SLEEP_FLUSH);
>  		XFS_STATS_INC(xs_log_noiclogs);
> -		/* Ensure that log writes happen */
> -		psema(&log->l_flushsema, PINOD);
> +		/* Wait for log writes to have flushed */
> +		schedule();
>  		goto restart;
>  	}
>  	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);

Christoph points out that this is missing a call to finish_wait() after
schedule() and he's absolutely right.  It only matters if the task was
woken up by something other than being on this wait queue, so my testing
didn't notice it missing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:16:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B4GV7j013865
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:16:33 -0700
Date: Fri, 11 Jul 2008 00:17:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: deadlocked xfs
Message-ID: <20080711041736.GA29688@infradead.org>
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <4876D1C3.4000006@sgi.com> <20080711040447.GC11558@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711040447.GC11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 11, 2008 at 02:04:47PM +1000, Dave Chinner wrote:
>  		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
>  
> -		/* If I'm the only one writing to this iclog, sync it to disk */
> -		if (atomic_read(&iclog->ic_refcnt) == 1) {
> +		/*
> +		 * If I'm the only one writing to this iclog, sync it to disk.
> +		 * We need to do an atomic compare and decrement here to avoid
> +		 * racing with concurrent atomic_dec_and_lock() calls in
> +		 * xlog_state_release_iclog() when there is more than one
> +		 * reference to the iclog.
> +		 */
> +		if (atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
>  			spin_unlock(&log->l_icloglock);
> -			if ((error = xlog_state_release_iclog(log, iclog)))
> +			error = xlog_state_release_iclog(log, iclog);
> +			if (error)
>  				return error;
>  		} else {
> -			atomic_dec(&iclog->ic_refcnt);
>  			spin_unlock(&log->l_icloglock);
>  		}
>  		goto restart;

Independent ofwether it actually fixes the bug (which I think it will)
this looks good.  Doing anything with the return value from atomic_read
except for printing it is most likely bogus, and this one clearly is.

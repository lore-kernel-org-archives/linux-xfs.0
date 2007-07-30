Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jul 2007 22:06:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6U56sbm021857
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 22:06:55 -0700
Date: Mon, 30 Jul 2007 15:06:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: demand reaping of filestreams objects
Message-ID: <20070730050651.GH31489@sgi.com>
References: <20070723021051.GV12413810@sgi.com> <46AD6DE9.5090806@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AD6DE9.5090806@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 30, 2007 at 02:49:45PM +1000, Donald Douwsma wrote:
> David Chinner wrote:
> > Now that the problems with cancel_rearming_delayed_workqueue()
> > deadlocks have been fixed, we can go back to only running
> > the reaping when we have objects to time out. This prevents
> > the reaper from running when there is nothing to do.
> 
> You probably meant to remove the printk's,

*nod*

> @@ -206,8 +206,12 @@ _xfs_mru_cache_list_insert(
> ...
> +		if (!mru->queued) {
> +			printk("reaper started\n");
> 
> @@ -271,29 +275,27 @@ _xfs_mru_cache_reap(
> +	} else
> +	printk("reaper stopped\n");
> 
> Apart from that it looks good, much simpler.

Ok, thanks.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

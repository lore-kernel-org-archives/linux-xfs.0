Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 21:53:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1K5r05I019969
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 21:53:03 -0800
Date: Wed, 20 Feb 2008 16:53:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Prevent excessive xfsaild wakeups
Message-ID: <20080220055318.GO155407@sgi.com>
References: <20080218225906.GS155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218225906.GS155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

ping?

This is needed for 2.6.25-rcX....

On Tue, Feb 19, 2008 at 09:59:06AM +1100, David Chinner wrote:
> Idle state is not being detected properly by the xfsaild push
> code. The current idle state is detected by an empty list
> which may never happen with mostly idle filesystem or one
> using lazy superblock counters. A single dirty item in the
> list will result repeated looping to push everything past
> the target when everything because it fails to check if we
> managed to push anything.
> 
> Fix by considering a dirty list with everything past the target
> as an idle state and set the timeout appropriately.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfs_trans_ail.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2008-02-18 09:14:34.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2008-02-18 09:18:52.070682570 +1100
> @@ -261,14 +261,17 @@ xfsaild_push(
>  		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
>  	}
>  
> -	/*
> -	 * We reached the target so wait a bit longer for I/O to complete and
> -	 * remove pushed items from the AIL before we start the next scan from
> -	 * the start of the AIL.
> -	 */
> -	if ((XFS_LSN_CMP(lsn, target) >= 0)) {
> +	if (count && (XFS_LSN_CMP(lsn, target) >= 0)) {
> +		/*
> +		 * We reached the target so wait a bit longer for I/O to
> +		 * complete and remove pushed items from the AIL before we
> +		 * start the next scan from the start of the AIL.
> +		 */
>  		tout += 20;
>  		last_pushed_lsn = 0;
> +	} else if (!count) {
> +		/* We're past our target or empty, so idle */
> +		tout = 1000;
>  	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
>  		   (count && ((stuck * 100) / count > 90))) {
>  		/*

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

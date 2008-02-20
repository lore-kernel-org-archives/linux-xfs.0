Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 11:09:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1KJ9c2G007537
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 11:09:42 -0800
Date: Wed, 20 Feb 2008 14:10:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] Prevent excessive xfsaild wakeups
Message-ID: <20080220191000.GA24257@infradead.org>
References: <20080218225906.GS155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218225906.GS155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 19, 2008 at 09:59:06AM +1100, David Chinner wrote:
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

When looking at this conditions it confuses the hell out of me.  Having
count checked in each of three nested conditionals simply isn't readable
:)

Also some checks seem to be superflous, so how about:


	if (!count) {
		/*
		 * We're past our target or empty, so idle.
		 */
		 tout = 1000;
	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
		/*
		 * We reached the target so wait a bit longer for I/O to
		 * complete and remove pushed items from the AIL before we
		 * start the next scan from the start of the AIL.
		 */
 		tout += 20;
 		last_pushed_lsn = 0;
	} else (restarts > XFS_TRANS_PUSH_AIL_RESTARTS ||
	        ((stuck * 100) / count > 90)) {
		...
	}

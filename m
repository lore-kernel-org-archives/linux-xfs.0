Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D7A87F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 22:25:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12126304032
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 20:25:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PkLm2tgp7i2jTHuP for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 20:25:52 -0700 (PDT)
Date: Wed, 23 Sep 2015 13:25:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/14] xfsprogs: Add a timer implementation for OS X
Message-ID: <20150923032550.GO3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-11-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442311164-12921-11-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 15, 2015 at 11:59:20AM +0200, Jan Tulak wrote:
> OS X does not have the timer used in xfs_repair.
> Add a simple implementation providing the required
> capabilities.
....
>  #endif	/* __XFS_DARWIN_H__ */
> diff --git a/repair/progress.c b/repair/progress.c
> index 27cbaef..0fee7dc 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -184,10 +184,22 @@ progress_rpt_thread (void *p)
>  	 */
>  
>  	timespec.it_value.tv_sec = msgp->interval;
> -	timespec.it_value.tv_nsec = 0;
>  	timespec.it_interval.tv_sec = msgp->interval;
> +	/*
> +	 * On some platforms (like OS X), timers and time things are slightly
> +	 * different: itimerspec is replaced with itimerval and timeval struct
> +	 * has no tv_nsec, but just tv_usec member.
> +	 * For compatibility, itimerspec is a macro defined to the existing
> +	 * itimerval on these platforms, and in such case, use usec instead
> +	 * of nsec.
> +	 */
> +#ifndef itimerspec
> +	timespec.it_value.tv_nsec = 0;
>  	timespec.it_interval.tv_nsec = 0;
> -
> +#else
> +	timespec.it_value.tv_usec = 0;
> +	timespec.it_interval.tv_usec = 0;
> +#endif

That's pretty nasty. How about this:

	memset(&timespec, 0, sizeof(timespec));
	timespec.it_value.tv_sec = msgp->interval;
	timespec.it_interval.tv_sec = msgp->interval;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

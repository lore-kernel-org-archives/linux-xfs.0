Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 18:54:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7C1rsvl003089
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 18:53:56 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 042A0384054
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 18:55:11 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 0p8jNVL6RBMr7oBf for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 18:55:11 -0700 (PDT)
Date: Tue, 12 Aug 2008 11:55:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ooops in Kernel 2.6.26.2
Message-ID: <20080812015508.GM6119@disturbed>
References: <20080808180938.GA3760@diesel.geggus.net> <489FECCD.6050703@sgi.com> <489FF0EE.5040607@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489FF0EE.5040607@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Sven Geggus <lists@fuchsschwanzdomain.de>, xfs@oss.sgi.com

On Mon, Aug 11, 2008 at 05:57:34PM +1000, Lachlan McIlroy wrote:
> The ticket allocation code got reworked in 2.6.26 and we now free
> tickets whereas before we used to cache them so the use-after-free
> went undetected.
>
> This patch should do the trick.
>
> --- a/fs/xfs/xfs_log.c	2008-08-11 17:47:18.000000000 +1000
> +++ b/fs/xfs/xfs_log.c	2008-08-11 17:53:24.000000000 +1000
> @@ -336,15 +364,12 @@ xfs_log_done(xfs_mount_t	*mp,
> 	} else {
> 		xlog_trace_loggrant(log, ticket, "xfs_log_done: (permanent)");
> 		xlog_regrant_reserve_log_space(log, ticket);
> -	}
> -
> -	/* If this ticket was a permanent reservation and we aren't
> -	 * trying to release it, reset the inited flags; so next time
> -	 * we write, a start record will be written out.
> -	 */
> -	if ((ticket->t_flags & XLOG_TIC_PERM_RESERV) &&
> -	    (flags & XFS_LOG_REL_PERM_RESERV) == 0)
> +		/* If this ticket was a permanent reservation and we aren't
> +		 * trying to release it, reset the inited flags; so next time
> +		 * we write, a start record will be written out.
> +		 */
> 		ticket->t_flags |= XLOG_TIC_INITED;
> +	}
>
> 	return lsn;
> }	/* xfs_log_done */

Looks sane, Lachlan. Good catch, though it makes me wonder how we
didn't hit it in debug builds with memory poisoning turned on.
Compiler optimisation, perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

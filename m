Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 22:29:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O5TYVM008956
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:29:34 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E225A1B167E2
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:29:33 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id wNHTxStWCJ0VJk0F for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 22:29:33 -0700 (PDT)
Date: Fri, 24 Oct 2008 16:29:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/2] delalloc support for xfs fiemap
Message-ID: <20081024052930.GI18495@disturbed>
References: <49014887.6050309@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49014887.6050309@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 11:01:11PM -0500, Eric Sandeen wrote:
> Ok, got the kinks worked out of the delalloc portion of the
> fiemap hookup I think.
> 
> This introduces a new input flag (BMV_IF_DELALLOC) and output
> flag (BMV_OF_DELALLOC) to request & show the delayed allocation
> segments.
....
> @@ -5827,6 +5827,7 @@ xfs_getbmap(
>  						 * preallocated data space */
>  	int			sh_unwritten;	/* true, if unwritten */
>  						/* extents listed separately */
> +	int			sh_delalloc;	/* show delayed extents */
>  	int			iflags;		/* interface flags */
>  	int			bmapi_flags;	/* flags for xfs_bmapi */

Do we really need this "sh_delalloc" flag? Checking for
(iflags & BMV_IF_DELALLOC) is fine by me, same for replacing
sh_unwritten. I've never really liked the "sh" abbreviation for
"show"....

Otherwise it looks ok. Perhaps we should also add delalloc extent
display to xfs_bmap....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

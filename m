Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51532 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbeHBLYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 07:24:43 -0400
Received: by mail-wm0-f67.google.com with SMTP id y2-v6so1722225wma.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 02:34:23 -0700 (PDT)
Date: Thu, 2 Aug 2018 11:34:20 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] mkfs: avoid divide-by-zero when hardware reports
 optimal i/o size as 0
Message-ID: <20180802093420.tljr77jlyulnwv6p@odin.usersys.redhat.com>
References: <c347c3d7-2181-d114-7547-2649bb2f1022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c347c3d7-2181-d114-7547-2649bb2f1022@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>

On Wed, Aug 01, 2018 at 03:49:45PM -0500, Eric Sandeen wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
> AG alignment code into a separate function.  It got rid of
> redundant checks for dswidth != 0 since calc_stripe_factors was
> supposed to guarantee that if dsunit is non-zero dswidth will be
> as well.  Unfortunately, there's hardware out there that reports its
> optimal i/o size as larger than the maximum i/o size, which the kernel
> treats as broken and zeros out the optimal i/o size.
> 
> To resolve this we can check the topology before consuming it, and
> ignore the bad stripe geometry.
> 
> [sandeen: remove guessing heuristic, just warn and ignore bad data.]
> 
> Fixes: 051b4e37f5e (mkfs: factor AG alignment)
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 

I'm ok with it, but I'm starting to think calc_stripe_factors() is growing more
than it should, so, I'm thinking if we shouldn't factor out all these validation
paths into different functions, I'm ok doing that if you guys think it's not a
waste of time?

For the patch itself:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> so, I rewrote this a bit.  I'm not a fan of guessing what the kernel
> really must have meant, becaue next time the root cause may be differnt.
> In other cases we ignore bad geometry, I think we should in this case as
> well.  This will also let me go forward with a factored-out geometry checker,
> and for user-specified badness we'll warn and exit, for kernel-provided
> badness we'll warn and ignore.
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1074886..2e53c1e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2281,11 +2281,20 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		dsunit = ft->dsunit;
> -		dswidth = ft->dswidth;
> -		use_dev = true;
> +		/* Ignore nonsense from device.  XXX add more validation */
> +		if (ft->dsunit && ft->dswidth == 0) {
> +			fprintf(stderr,
> +_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> +				progname, BBTOB(ft->dsunit));
> +			ft->dsunit = 0;
> +			ft->dswidth = 0;
> +		} else {
> +			dsunit = ft->dsunit;
> +			dswidth = ft->dswidth;
> +			use_dev = true;
> +		}
>  	} else {
> -		/* check and warn is alignment is sub-optimal */
> +		/* check and warn if user-specified alignment is sub-optimal */
>  		if (ft->dsunit && ft->dsunit != dsunit) {
>  			fprintf(stderr,
>  _("%s: Specified data stripe unit %d is not the same as the volume stripe unit %d\n"),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732117AbeHAWnK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 18:43:10 -0400
Subject: Re: [PATCH V2] mkfs: avoid divide-by-zero when hardware reports
 optimal i/o size as 0
References: <c347c3d7-2181-d114-7547-2649bb2f1022@redhat.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <68c5d2e3-f491-b028-134a-0bc6770338bc@suse.com>
Date: Wed, 1 Aug 2018 16:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <c347c3d7-2181-d114-7547-2649bb2f1022@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Looks good to me.  I'm fine falling back to zeroed values.  Thanks for 
following up on this.

Reviewed-by: Jeff Mahoney <jeffm@suse.com>

-Jeff


On 8/1/18 4:49 PM, Eric Sandeen wrote:
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
>   	/* if no stripe config set, use the device default */
>   	if (!dsunit) {
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
>   	} else {
> -		/* check and warn is alignment is sub-optimal */
> +		/* check and warn if user-specified alignment is sub-optimal */
>   		if (ft->dsunit && ft->dsunit != dsunit) {
>   			fprintf(stderr,
>   _("%s: Specified data stripe unit %d is not the same as the volume stripe unit %d\n"),
> 
> 

-- 
Jeff Mahoney
SUSE Labs


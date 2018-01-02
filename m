Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36431 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeABRsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 12:48:47 -0500
Date: Tue, 2 Jan 2018 09:44:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] mkfs: do not allow both "dev" and "name" subopts for
 log or realtime
Message-ID: <20180102174414.GC4857@magnolia>
References: <529c056a-a40c-06b8-a37e-3b1b7e664303@sandeen.net>
 <6ea46cfb-357b-17c4-fc5f-65598431526f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ea46cfb-357b-17c4-fc5f-65598431526f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Dec 24, 2017 at 11:12:13AM -0800, Eric Sandeen wrote:
> Today we can specify i.e. both logdev= and name= ;
> it works, with last-parsed-wins behavior:
> 
> mkfs.xfs -f -l logdev=/dev/sda1,name=/dev/sda2 /dev/sda3
> 
> Make these conflict to resolve ambiguity; do the same for
> the realtime subvol.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 035af03..5ae67d5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -507,6 +507,7 @@ struct opt_params lopts = {
>  		},
>  		{ .index = L_DEV,
>  		  .conflicts = { { &lopts, L_AGNUM },
> +				 { &lopts, L_NAME },
>  				 { &lopts, L_INTERNAL },
>  				 { &lopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -529,6 +530,7 @@ struct opt_params lopts = {
>  		},
>  		{ .index = L_NAME,
>  		  .conflicts = { { &lopts, L_AGNUM },
> +				 { &lopts, L_DEV },
>  				 { &lopts, L_INTERNAL },
>  				 { &lopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -599,7 +601,8 @@ struct opt_params ropts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_DEV,
> -		  .conflicts = { { &ropts, LAST_CONFLICT } },
> +		  .conflicts = { { &ropts, R_NAME },
> +			         { &ropts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_FILE,
> @@ -609,7 +612,8 @@ struct opt_params ropts = {
>  		  .conflicts = { { &ropts, LAST_CONFLICT } },
>  		},
>  		{ .index = R_NAME,
> -		  .conflicts = { { &ropts, LAST_CONFLICT } },
> +		  .conflicts = { { &ropts, R_DEV },
> +			         { &ropts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_NOALIGN,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

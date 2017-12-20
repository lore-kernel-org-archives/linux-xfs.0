Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56241 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdLTDAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 22:00:04 -0500
Date: Tue, 19 Dec 2017 18:59:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/7] mkfs: resolve sector size CLI conflicts
Message-ID: <20171220025958.GN12613@magnolia>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218091158.14537-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 08:11:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have a two dimensional conflict array, convert the sector
> size CLI option conflict determination to use it. To get the error
> specification just right, we also need to tweak how we store
> and validate the sector size CLI parameter state in the options
> table.
> 
> Old:
> 
> $ mkfs.xfs -N -s size=4k -d sectsize=512 /dev/pmem0
> Cannot specify both -d sectsize and -d sectlog
> .....
> 
> New:
> 
> $ mkfs.xfs -N -s size=4k -d sectsize=512 /dev/pmem0
> Cannot specify both -s size and -d sectsize
> .....
> 
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 43 +++++++++++++++++++++++++++++++------------
>  1 file changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4b79c03e442b..b8752965c6d7 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -230,6 +230,13 @@ struct opt_params {
>  	}		subopt_params[MAX_SUBOPTS];
>  };
>  
> +/*
> + * The two dimensional conflict array requires some initialisations to know
> + * about tables that haven't yet been defined. Work around this ordering
> + * issue with extern definitions here.
> + */
> +extern struct opt_params sopts;
> +
>  struct opt_params bopts = {
>  	.name = 'b',
>  	.subopts = {
> @@ -348,6 +355,10 @@ struct opt_params dopts = {
>  		},
>  		{ .index = D_SECTLOG,
>  		  .conflicts = { { &dopts, D_SECTSIZE },
> +				 { &sopts, S_SIZE },
> +				 { &sopts, S_SECTSIZE },
> +				 { &sopts, S_LOG },
> +				 { &sopts, S_SECTLOG },
>  				 { &dopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> @@ -355,6 +366,10 @@ struct opt_params dopts = {
>  		},
>  		{ .index = D_SECTSIZE,
>  		  .conflicts = { { &dopts, D_SECTLOG },
> +				 { &sopts, S_SIZE },
> +				 { &sopts, S_SECTSIZE },
> +				 { &sopts, S_LOG },
> +				 { &sopts, S_SECTLOG },
>  				 { &dopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -680,6 +695,9 @@ struct opt_params sopts = {
>  		{ .index = S_LOG,
>  		  .conflicts = { { &sopts, S_SIZE },
>  				 { &sopts, S_SECTSIZE },
> +				 { &sopts, S_SECTLOG },
> +				 { &dopts, D_SECTSIZE },
> +				 { &dopts, D_SECTLOG },
>  				 { &sopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> @@ -688,6 +706,9 @@ struct opt_params sopts = {
>  		{ .index = S_SECTLOG,
>  		  .conflicts = { { &sopts, S_SIZE },
>  				 { &sopts, S_SECTSIZE },
> +				 { &sopts, S_LOG },
> +				 { &dopts, D_SECTSIZE },
> +				 { &dopts, D_SECTLOG },
>  				 { &sopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> @@ -696,6 +717,9 @@ struct opt_params sopts = {
>  		{ .index = S_SIZE,
>  		  .conflicts = { { &sopts, S_LOG },
>  				 { &sopts, S_SECTLOG },
> +				 { &sopts, S_SECTSIZE },
> +				 { &dopts, D_SECTSIZE },
> +				 { &dopts, D_SECTLOG },
>  				 { &sopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -706,6 +730,9 @@ struct opt_params sopts = {
>  		{ .index = S_SECTSIZE,
>  		  .conflicts = { { &sopts, S_LOG },
>  				 { &sopts, S_SECTLOG },
> +				 { &sopts, S_SIZE },
> +				 { &dopts, D_SECTSIZE },
> +				 { &dopts, D_SECTLOG },
>  				 { &sopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -964,8 +991,8 @@ conflict(
>  	int			conflict)
>  {
>  	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
> -			opts->name, opts->subopts[option],
> -			con_opts->name, con_opts->subopts[conflict]);
> +			con_opts->name, con_opts->subopts[conflict],
> +			opts->name, opts->subopts[option]);

Why is it necessary to change this around?  Surely

	Cannot specify both -s barfu and -d fubar

and

	Cannot specify both -d fubar and -s barfu

aren't /that/ much different?

Or is this one of those things that fixes up an xfstest or something?

(Not opposed, just wondering...)

--D

>  	usage();
>  }
>  
> @@ -1523,14 +1550,10 @@ data_opts_parser(
>  		cli->sb_feat.nodalign = getnum(value, opts, D_NOALIGN);
>  		break;
>  	case D_SECTLOG:
> -		if (cli->sectorsize)
> -			conflict(opts, D_SECTSIZE, opts, D_SECTLOG);
>  		sectorlog = getnum(value, opts, D_SECTLOG);
>  		cli->sectorsize = 1 << sectorlog;
>  		break;
>  	case D_SECTSIZE:
> -		if (cli->sectorsize)
> -			conflict(opts, D_SECTSIZE, opts, D_SECTLOG);
>  		cli->sectorsize = getnum(value, opts, D_SECTSIZE);
>  		break;
>  	case D_RTINHERIT:
> @@ -1756,17 +1779,13 @@ sector_opts_parser(
>  	switch (subopt) {
>  	case S_LOG:
>  	case S_SECTLOG:
> -		if (cli->sectorsize)
> -			conflict(opts, S_SECTSIZE, opts, S_SECTLOG);
> -		sectorlog = getnum(value, opts, S_SECTLOG);
> +		sectorlog = getnum(value, opts, subopt);
>  		cli->sectorsize = 1 << sectorlog;
>  		cli->lsectorsize = cli->sectorsize;
>  		break;
>  	case S_SIZE:
>  	case S_SECTSIZE:
> -		if (cli->sectorsize)
> -			conflict(opts, S_SECTSIZE, opts, S_SECTLOG);
> -		cli->sectorsize = getnum(value, opts, S_SECTSIZE);
> +		cli->sectorsize = getnum(value, opts, subopt);
>  		cli->lsectorsize = cli->sectorsize;
>  		break;
>  	default:
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

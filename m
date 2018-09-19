Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731847AbeISU1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 16:27:21 -0400
Date: Wed, 19 Sep 2018 07:48:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] mkfs: move 'mounted' check before 'existing fs' check
Message-ID: <20180919144853.GI20086@magnolia>
References: <20180919125617.28048-1-jtulak@redhat.com>
 <20180919125617.28048-2-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180919125617.28048-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Wed, Sep 19, 2018 at 02:56:17PM +0200, Jan Tulak wrote:
> Check if a device is mounted (and issue an error about that) before
> asking for -f flag.
> 
> Example of the old behaviour I'm changing:
> $ mkfs.xfs /dev/sda1
> mkfs.xfs: /dev/sda1 appears to contain an existing filesystem (xfs).
> mkfs.xfs: Use the -f option to force overwrite.
> 
> $ mkfs.xfs -f /dev/sda1
> mkfs.xfs: /dev/sda1 contains a mounted filesystem

I'm confused by the commit message -- what is the new behavior?

Is it this?

$ mkfs.xfs /dev/sda1
mkfs.xfs: /dev/sda1 contains a mounted filesystem

$ mkfs.xfs -f /dev/sda1
mkfs.xfs: /dev/sda1 contains a mounted filesystem

--D

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 81d9859a..97e78647 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1012,7 +1012,6 @@ check_device_type(
>  	bool		no_size,
>  	bool		no_name,
>  	int		*create,
> -	bool		force_overwrite,
>  	const char	*optname)
>  {
>  	struct stat statbuf;
> @@ -1043,13 +1042,6 @@ check_device_type(
>  		return;
>  	}
> 
> -	if (!force_overwrite && check_overwrite(name)) {
> -		fprintf(stderr,
> -	_("%s: Use the -f option to force overwrite.\n"),
> -			progname);
> -		exit(1);
> -	}
> -
>  	/*
>  	 * We only want to completely truncate and recreate an existing file if
>  	 * we were specifically told it was a file. Set the create flag only in
> @@ -1079,6 +1071,20 @@ check_device_type(
>  	usage();
>  }
> 
> +static void
> +validate_overwrite(
> +	const char	*name,
> +	bool		force_overwrite)
> +{
> +	if (!force_overwrite && check_overwrite(name)) {
> +		fprintf(stderr,
> +	_("%s: Use the -f option to force overwrite.\n"),
> +			progname);
> +		exit(1);
> +	}
> +
> +}
> +
>  static void
>  validate_ag_geometry(
>  	int		blocklog,
> @@ -1731,18 +1737,15 @@ validate_sectorsize(
>  	 * files or block devices and set the control parameters correctly.
>  	 */
>  	check_device_type(dfile, &cli->xi->disfile, !cli->dsize, !dfile,
> -			  dry_run ? NULL : &cli->xi->dcreat,
> -			  force_overwrite, "d");
> +			  dry_run ? NULL : &cli->xi->dcreat, "d");
>  	if (!cli->loginternal)
>  		check_device_type(cli->xi->logname, &cli->xi->lisfile,
>  				  !cli->logsize, !cli->xi->logname,
> -				  dry_run ? NULL : &cli->xi->lcreat,
> -				  force_overwrite, "l");
> +				  dry_run ? NULL : &cli->xi->lcreat, "l");
>  	if (cli->xi->rtname)
>  		check_device_type(cli->xi->rtname, &cli->xi->risfile,
>  				  !cli->rtsize, !cli->xi->rtname,
> -				  dry_run ? NULL : &cli->xi->rcreat,
> -				  force_overwrite, "r");
> +				  dry_run ? NULL : &cli->xi->rcreat, "r");
> 
>  	/*
>  	 * Explicitly disable direct IO for image files so we don't error out on
> @@ -3909,6 +3912,7 @@ main(
>  	 * Open and validate the device configurations
>  	 */
>  	open_devices(&cfg, &xi);
> +	validate_overwrite(dfile, force_overwrite);
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> --
> 2.18.0

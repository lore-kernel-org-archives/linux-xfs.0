Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388212AbeIUBsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 21:48:43 -0400
Date: Thu, 20 Sep 2018 13:03:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2 v2] mkfs: discard only after all validations
Message-ID: <20180920200329.GK20086@magnolia>
References: <20180919125617.28048-1-jtulak@redhat.com>
 <20180920092006.37596-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180920092006.37596-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 11:20:06AM +0200, Jan Tulak wrote:
> Discard should happen only when everything has been validated, just
> before we start writing to the device. If it happens earlier, it is
> possible that mkfs will abort, but managed to already wipe data. This
> patch moves the discard to the latest possible moment.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> CHANGES:
> v2
> * discard_data -> discard_devices
> * move the discard condition outside of the function
> 
> ---
>  mkfs/xfs_mkfs.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e53c1e8..c97c69e8 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2389,8 +2389,7 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
>  static void
>  open_devices(
>  	struct mkfs_params	*cfg,
> -	struct libxfs_xinit	*xi,
> -	bool			discard)
> +	struct libxfs_xinit	*xi)
>  {
>  	uint64_t		sector_mask;
>  
> @@ -2419,10 +2418,15 @@ open_devices(
>  	xi->dsize &= sector_mask;
>  	xi->rtsize &= sector_mask;
>  	xi->logBBsize &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
> +}
>  
> -
> -	if (!discard)
> -		return;
> +static void
> +discard_devices(
> +	struct libxfs_xinit	*xi)
> +{
> +	/*
> +	 * This function has to be called after libxfs has been initialized.
> +	 */
>  
>  	if (!xi->disfile)
>  		discard_blocks(xi->ddev, xi->dsize);
> @@ -3901,7 +3905,7 @@ main(
>  	/*
>  	 * Open and validate the device configurations
>  	 */
> -	open_devices(&cfg, &xi, (discard && !dry_run));
> +	open_devices(&cfg, &xi);
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> @@ -3952,6 +3956,12 @@ main(
>  			exit(0);
>  	}
>  
> +	/*
> +	 * All values have been validated, discard the old device layout.
> +	 */
> +	if (discard && !dry_run)
> +		discard_devices(&xi);
> +
>  	/*
>  	 * we need the libxfs buffer cache from here on in.
>  	 */
> -- 
> 2.18.0
> 

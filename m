Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731311AbeISUWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 16:22:33 -0400
Date: Wed, 19 Sep 2018 07:44:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] mkfs: discard only after all validations
Message-ID: <20180919144405.GH20086@magnolia>
References: <20180919125617.28048-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180919125617.28048-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Wed, Sep 19, 2018 at 02:56:16PM +0200, Jan Tulak wrote:
> Discard should happen only when everything has been validated, just
> before we start writing to the device. If it happens earlier, it is
> possible that mkfs will abort, but managed to already wipe data. This
> patch moves the discard to the latest possible moment.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e53c1e8..81d9859a 100644
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
> @@ -2419,8 +2418,16 @@ open_devices(
>  	xi->dsize &= sector_mask;
>  	xi->rtsize &= sector_mask;
>  	xi->logBBsize &= (uint64_t)-1 << (max(cfg->lsectorlog, 10) - BBSHIFT);
> +}
>  
> -
> +static void
> +discard_data(

Perhaps discard_devices(), since this function can DISCARD more than
just the data device.

> +	struct libxfs_xinit	*xi,
> +	bool			discard)
> +{
> +	/*
> +	 * This function has to be called after libxfs has been initialized.
> +	 */
>  	if (!discard)
>  		return;
>  

While we're on the topic, I notice that we skip discard for any device
that's actually a file.  Seeing as fallocate(PUNCH_HOLE) works on files
(and block devices), is there a reason why we avoid punching out fs
image files?

> @@ -3901,7 +3908,7 @@ main(
>  	/*
>  	 * Open and validate the device configurations
>  	 */
> -	open_devices(&cfg, &xi, (discard && !dry_run));
> +	open_devices(&cfg, &xi);
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> @@ -3952,6 +3959,11 @@ main(
>  			exit(0);
>  	}
>  
> +	/*
> +	 * All values have been validated, discard the old device layout.
> +	 */
> +	discard_data(&xi, (discard && !dry_run));

if (discard && !dry_run)
	discard_devices(&xi);

?

--D

> +
>  	/*
>  	 * we need the libxfs buffer cache from here on in.
>  	 */
> -- 
> 2.18.0
> 

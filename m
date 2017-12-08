Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44574 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdLHE05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:26:57 -0500
Date: Thu, 7 Dec 2017 20:21:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] mkfs: Don't emit default config message yet
Message-ID: <20171208042153.GI19219@magnolia>
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
 <62f67117-150d-e456-d9dd-3a19938cb03a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62f67117-150d-e456-d9dd-3a19938cb03a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 07, 2017 at 10:13:15PM -0600, Eric Sandeen wrote:
> Until we have more than one possible source of configuration,
> there is no need to emit the only possibility and clutter
> the output.  We can decide how it should all look when we
> get more than one source.
> 
> Apply some i18n to the config description, though.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, I guess,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I wonder why Dave put the printf in there, but I'll let him answer that.)

> ---
> 
>  mkfs/xfs_mkfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e38810f..0f7dd92 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3845,7 +3845,7 @@ main(
>  
>  	/* build time defaults */
>  	struct mkfs_default_params	dft = {
> -		.source = "package build definitions",
> +		.source = _("package build definitions"),
>  		.sectorsize = XFS_MIN_SECTORSIZE,
>  		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
>  		.sb_feat = {
> @@ -3881,10 +3881,12 @@ main(
>  	 * defaults. If a file exists in <package location>, read in the new
>  	 * default values and overwrite them in the &dft structure. This way the
>  	 * new defaults will apply before we parse the CLI, and the CLI will
> -	 * still be able to override them. Emit a message to indicate where the
> -	 * defaults being used came from.
> +	 * still be able to override them. When more than one source is
> +	 * implemented, emit a message to indicate where the defaults being
> +	 * used came from.
> +	 *
> +	 * printf(_("Default configuration sourced from %s\n"), dft.source);
>  	 */
> -	printf(_("Default configuration sourced from %s\n"), dft.source);
>  
>  	/* copy new defaults into CLI parsing structure */
>  	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:43519 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751879AbeEQWtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 18:49:09 -0400
Date: Fri, 18 May 2018 08:48:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/5] mkfs: replace defaults source with an enum
Message-ID: <20180517224849.GD23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517192700.23457-4-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 12:26:58PM -0700, Luis R. Rodriguez wrote:
> Using an enum will let us later just use a switch statement to print
> out the source, this makes sources easier to document, update and
> manage.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

This is incomplete. :(

> ---
>  mkfs/xfs_mkfs.c        |  5 +++--
>  mkfs/xfs_mkfs_common.h | 13 ++++++++++++-
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ac97039abc34..de0eab3f68e0 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3697,7 +3697,7 @@ main(
>  
>  	/* build time defaults */
>  	struct mkfs_default_params	dft = {
> -		.source = _("package build definitions"),
> +		.type = DEFAULTS_BUILTIN,
>  		.sectorsize = XFS_MIN_SECTORSIZE,
>  		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
>  		.sb_feat = {
> @@ -3737,7 +3737,8 @@ main(
>  	 * implemented, emit a message to indicate where the defaults being
>  	 * used came from.
>  	 *
> -	 * printf(_("Default configuration sourced from %s\n"), dft.source);
> +	 * printf(_("Default configuration sourced from %s\n"),
> +	 *	  default_type_str(dft.type));

This function does not exist in the patch. If you are going to add
functionality, first turn on that functionality so you can test the
patch actually works...

>  	 */
>  
>  	/* copy new defaults into CLI parsing structure */
> diff --git a/mkfs/xfs_mkfs_common.h b/mkfs/xfs_mkfs_common.h
> index 9b0f67b70cf1..d867ab377185 100644
> --- a/mkfs/xfs_mkfs_common.h
> +++ b/mkfs/xfs_mkfs_common.h
> @@ -40,6 +40,17 @@ struct sb_feat_args {
>  	bool	nortalign;
>  };
>  
> +/*
> + * File configuration type settings
> + *
> + * These are the different possibilities by which you can end up parsing
> + * default settings with. DEFAULTS_BUILTIN indicates there was no configuration
> + * file parsed and we are using the built-in defaults on this code.
> + */
> +enum default_params_type {
> +	DEFAULTS_BUILTIN = 0,
> +};

Please add all the new types here, the functions to print the names,
etc.

>  /*
>   * Default filesystem features and configuration values
>   *
> @@ -49,7 +60,7 @@ struct sb_feat_args {
>   * calculations.
>   */
>  struct mkfs_default_params {
> -	char	*source;	/* where the defaults came from */
> +	enum default_params_type type; /* where the defaults came from */
>  
>  	int	sectorsize;
>  	int	blocksize;

As it is, I don't see why this change it necessary - you can just
store the appropriate string (as the code currently does) into the
structure once the source is known. Why do we need infrastructure to
abstract printing a string when we set it directly, anyway?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

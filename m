Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:5670 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751958AbeEQWxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 18:53:32 -0400
Date: Fri, 18 May 2018 08:53:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 4/5] mkfs: add helpers to process defaults
Message-ID: <20180517225329.GE23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517192700.23457-5-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 12:26:59PM -0700, Luis R. Rodriguez wrote:
> Move the built-in defaults globally and add helpers to reset and
> process the defaults. This will be expanded on later. The commented
> out print of the defaults source is moved below CLI processing to
> acknowledge that one will later want to be able to specify a
> different configuration file to be used through the CLI.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  mkfs/xfs_mkfs.c | 93 ++++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 63 insertions(+), 30 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index de0eab3f68e0..cb549be89835 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3662,6 +3662,61 @@ rewrite_secondary_superblocks(
>  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  }
>  
> +/* build time defaults */
> +struct mkfs_default_params	built_in_dft = {
> +	.type = DEFAULTS_BUILTIN,
> +	.sectorsize = XFS_MIN_SECTORSIZE,
> +	.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> +	.sb_feat = {
> +		.log_version = 2,
> +		.attr_version = 2,
> +		.dir_version = 2,
> +		.inode_align = true,
> +		.nci = false,
> +		.lazy_sb_counters = true,
> +		.projid32bit = true,
> +		.crcs_enabled = true,
> +		.dirftype = true,
> +		.finobt = true,
> +		.spinodes = true,
> +		.rmapbt = false,
> +		.reflink = false,
> +		.parent_pointers = false,
> +		.nodalign = false,
> +		.nortalign = false,
> +	},
> +};

Why? We've already got a perfectly good structure initialiser for
the default settings in the main() function. Why do we need to
create a new structure and a bunch of infrastructure to update
it?

> +/* installs new defaults into the CLI parsing structure */
> +static void install_defaults(
> +	struct mkfs_default_params	*dft,
> +	struct cli_params		*cli)
> +{
> +	memcpy(&cli->sb_feat, &dft->sb_feat, sizeof(cli->sb_feat));
> +	memcpy(&cli->fsx, &dft->fsx, sizeof(cli->fsx));
> +}
> +
> +/*
> + * Reset defaults first to built-in defaults. Then resets cli opts to start
> + * with these built-in defaults. All previously set CLI options will be ignored.
> + */
> +static void reset_defaults_and_cli(
> +	struct mkfs_default_params	*dft,
> +	struct cli_params		*cli)
> +{
> +	*dft = built_in_dft;
> +
> +	install_defaults(dft, cli);
> +}
> +
> +/* Does the required work to process a new set of defaults */
> +static void process_defaults(
> +	struct mkfs_default_params	*dft,
> +	struct cli_params		*cli)
> +{
> +	install_defaults(dft, cli);
> +}
> +
>  int
>  main(
>  	int			argc,
> @@ -3694,31 +3749,9 @@ main(
>  		.loginternal = 1,
>  	};
>  	struct mkfs_params	cfg = {};
> +	struct mkfs_default_params	dft;
>  
> -	/* build time defaults */
> -	struct mkfs_default_params	dft = {
> -		.type = DEFAULTS_BUILTIN,
> -		.sectorsize = XFS_MIN_SECTORSIZE,
> -		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> -		.sb_feat = {
> -			.log_version = 2,
> -			.attr_version = 2,
> -			.dir_version = 2,
> -			.inode_align = true,
> -			.nci = false,
> -			.lazy_sb_counters = true,
> -			.projid32bit = true,
> -			.crcs_enabled = true,
> -			.dirftype = true,
> -			.finobt = true,
> -			.spinodes = true,
> -			.rmapbt = false,
> -			.reflink = false,
> -			.parent_pointers = false,
> -			.nodalign = false,
> -			.nortalign = false,
> -		},
> -	};
> +	reset_defaults_and_cli(&dft, &cli);

I just don't seee what this abstraction improves over just declaring
dft directly like this. It's also not explained why the CLI
structure needs to be initialised here, because we're going to
overwrite it again as soon as we've selected the default value
source....

>  
>  	platform_uuid_generate(&cli.uuid);
>  	progname = basename(argv[0]);
> @@ -3736,14 +3769,9 @@ main(
>  	 * still be able to override them. When more than one source is
>  	 * implemented, emit a message to indicate where the defaults being
>  	 * used came from.
> -	 *
> -	 * printf(_("Default configuration sourced from %s\n"),
> -	 *	  default_type_str(dft.type));
>  	 */
>  
> -	/* copy new defaults into CLI parsing structure */
> -	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
> -	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
> +	process_defaults(&dft, &cli);

i.e. here.

>  
>  	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
>  		switch (c) {
> @@ -3795,6 +3823,11 @@ main(
>  	} else
>  		dfile = xi.dname;
>  
> +	/*
> +	 * printf(_("Default configuration sourced from %s\n"),
> +	 *	  default_type_str(dft.type));
> +	 */

What does moving this acheive?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

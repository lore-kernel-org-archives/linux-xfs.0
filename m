Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63312 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751595AbeCMVj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 17:39:59 -0400
Date: Wed, 14 Mar 2018 08:39:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Message-ID: <20180313213916.GD18129@dastard>
References: <20180313205911.26082-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313205911.26082-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On Tue, Mar 13, 2018 at 01:59:11PM -0700, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> This adds support for parsing a configuration file to override defaults
> parameters to be used for mkfs.xfs.
> 
> We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> different types of configuration files, if none is specified we look for
> the default type, /etc/mkfs.xfs.d/default, and you can override with -T.
> For instance, if you specify:
> 
> 	mkfs.xfs -T experimental -f /dev/loop0

Just one obvious comment from a brief glance - you changed this from
"-t" to "-T", but ....

>  are equivalent.
>  .PP
> +An optional XFS configuration type file directory
> +.B mkfs.xfs.d (5)
> +exists to help fine tune default parameters which can be used when calling
> +.B mkfs.xfs (8), by default type will be used by default, /etc/mkfs.xfs.d/default.
> +Command line arguments directly passed to
> +.B mkfs.xfs (8)
> +will always override parameters set it the configuration type file.
> +You can override configuration file type on the
> +.B mkfs.xfs.d (5)
> +directory by using the -t parameter and secifying the type. Alternatively

Not here, or ....

> +you can set and use the MKFS_XFS_CONFIG environment variable to override
> +the default full path of the first file
> +.B mkfs.xfs (8)
> +looks for.
> +If you use -t the type configuration file must be present under

here, or ....

> +#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
> +#define CONFIG_MAX_KEY		1024
> +#define CONFIG_MAX_VALUE	PATH_MAX
> +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> +#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"

[ Please don't obfuscate parsing options like this ]

> @@ -3827,25 +4198,47 @@ main(
>  	textdomain(PACKAGE);
>  
>  	/*
> -	 * TODO: Sourcing defaults from a config file
> -	 *
>  	 * Before anything else, see if there's a config file with different
> -	 * defaults. If a file exists in <package location>, read in the new
> +	 * defaults. If a file exists in MKFS_XFS_CONF_DIR/default, read the new
>  	 * default values and overwrite them in the &dft structure. This way the
>  	 * new defaults will apply before we parse the CLI, and the CLI will
>  	 * still be able to override them. When more than one source is
>  	 * implemented, emit a message to indicate where the defaults being
>  	 * used came from.
> -	 *
> -	 * printf(_("Default configuration sourced from %s\n"), dft.source);
>  	 */
> +	tmp_config = getenv("MKFS_XFS_CONFIG");
> +	if (tmp_config != NULL) {
> +		dft.config_file = tmp_config;
> +		dft.type = DEFAULTS_ENVIRONMENT_CONFIG;
> +	}
> +
> +	c = getopt(argc, argv, PARAM_OPTS);
> +	if (c != EOF && c == 't') {

Here. Did you test this?

And, well, I have my doubts about this method of option parsing.
Where does it say in the getopt(3) man page that CLI options are
always parsed and returned in order of the option string rather than
the order the appear on the CLI?

I'll spend some more time looking at it, but my initial impression
is that there's a bit of work to be done yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

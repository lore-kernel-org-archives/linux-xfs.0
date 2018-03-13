Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35789 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752885AbeCMXw2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Mar 2018 19:52:28 -0400
Date: Tue, 13 Mar 2018 23:52:27 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs.xfs: add configuration file parsing support using
 our own parser
Message-ID: <20180313235227.GH4449@wotan.suse.de>
References: <20180313205911.26082-1-mcgrof@kernel.org>
 <20180313213916.GD18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180313213916.GD18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu

On Wed, Mar 14, 2018 at 08:39:16AM +1100, Dave Chinner wrote:
> Just one obvious comment from a brief glance - you changed this from
> "-t" to "-T", but ....
> > +directory by using the -t parameter and secifying the type. Alternatively
> 
> Not here, or ....
>
> > +If you use -t the type configuration file must be present under
> 
> here, or ....
> 
> > +#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
> > +#define CONFIG_MAX_KEY		1024
> > +#define CONFIG_MAX_VALUE	PATH_MAX
> > +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> > +#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"
> 
> [ Please don't obfuscate parsing options like this ]

The reason was we use them twice.

> > @@ -3827,25 +4198,47 @@ main(
> >  	textdomain(PACKAGE);
> >  
> >  	/*
> > -	 * TODO: Sourcing defaults from a config file
> > -	 *
> >  	 * Before anything else, see if there's a config file with different
> > -	 * defaults. If a file exists in <package location>, read in the new
> > +	 * defaults. If a file exists in MKFS_XFS_CONF_DIR/default, read the new
> >  	 * default values and overwrite them in the &dft structure. This way the
> >  	 * new defaults will apply before we parse the CLI, and the CLI will
> >  	 * still be able to override them. When more than one source is
> >  	 * implemented, emit a message to indicate where the defaults being
> >  	 * used came from.
> > -	 *
> > -	 * printf(_("Default configuration sourced from %s\n"), dft.source);
> >  	 */
> > +	tmp_config = getenv("MKFS_XFS_CONFIG");
> > +	if (tmp_config != NULL) {
> > +		dft.config_file = tmp_config;
> > +		dft.type = DEFAULTS_ENVIRONMENT_CONFIG;
> > +	}
> > +
> > +	c = getopt(argc, argv, PARAM_OPTS);
> > +	if (c != EOF && c == 't') {
> 
> Here. Did you test this?

I forgot to test -T after we bike-shed from -t to -T, sorry. Will fix.
I had however tested -t for sure.

> And, well, I have my doubts about this method of option parsing.
> Where does it say in the getopt(3) man page that CLI options are
> always parsed and returned in order of the option string rather than
> the order the appear on the CLI?

You are right. Its rather unclear. If -t is passed at the end this may
not work.

> I'll spend some more time looking at it, but my initial impression
> is that there's a bit of work to be done yet...

You're right, we should decide if we want to allow for -T to be used
only in the beginning or if we want to allow for it anywhere on the
command line. If we allow for it only at the beginning of the command
line it may be easier and cleaner to support: we'd just check argv[1]
for -T manually and if passed just bump argv down two slots. So we
leave getopt() usage only for the other stuff.

Thoughts?

  Luis

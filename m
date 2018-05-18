Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46635 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbeERAG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 20:06:57 -0400
Received: by mail-pg0-f68.google.com with SMTP id u8-v6so2498428pgp.13
        for <linux-xfs@vger.kernel.org>; Thu, 17 May 2018 17:06:57 -0700 (PDT)
Date: Thu, 17 May 2018 17:06:53 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 4/5] mkfs: add helpers to process defaults
Message-ID: <20180518000653.GC24680@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-5-mcgrof@kernel.org>
 <20180517225329.GE23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517225329.GE23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Fri, May 18, 2018 at 08:53:29AM +1000, Dave Chinner wrote:
> On Thu, May 17, 2018 at 12:26:59PM -0700, Luis R. Rodriguez wrote:
> > Move the built-in defaults globally and add helpers to reset and
> > process the defaults. This will be expanded on later. The commented
> > out print of the defaults source is moved below CLI processing to
> > acknowledge that one will later want to be able to specify a
> > different configuration file to be used through the CLI.
> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c | 93 ++++++++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 63 insertions(+), 30 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index de0eab3f68e0..cb549be89835 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3662,6 +3662,61 @@ rewrite_secondary_superblocks(
> >  	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> >  }
> >  
> > +/* build time defaults */
> > +struct mkfs_default_params	built_in_dft = {
> > +	.type = DEFAULTS_BUILTIN,
> > +	.sectorsize = XFS_MIN_SECTORSIZE,
> > +	.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> > +	.sb_feat = {
> > +		.log_version = 2,
> > +		.attr_version = 2,
> > +		.dir_version = 2,
> > +		.inode_align = true,
> > +		.nci = false,
> > +		.lazy_sb_counters = true,
> > +		.projid32bit = true,
> > +		.crcs_enabled = true,
> > +		.dirftype = true,
> > +		.finobt = true,
> > +		.spinodes = true,
> > +		.rmapbt = false,
> > +		.reflink = false,
> > +		.parent_pointers = false,
> > +		.nodalign = false,
> > +		.nortalign = false,
> > +	},
> > +};
> 
> Why? We've already got a perfectly good structure initialiser for
> the default settings in the main() function. Why do we need to
> create a new structure 

Its the same structure. No changes were made to it, so really the
question is why make it global. The answer is there is only one
built-in default. I found it odd passing built-in as an argument to
a function.

> and a bunch of infrastructure to update it?

This is not easy to see from the patch, I'll explain. In short, this was
the cleanest solution to allowing us to not have to re-implement and
duplicate a lot of conflict checker/value checkers on the config parsing
code.

You have to consider that we can use the built-in defaults on the CLI
as we do today. That's easy to grasp... But when we add configuration
file support, we now have to consider cases such as -- what to do if
you have /etc/mkfs.xfs.d/default present, but actually use -c foo. In
terms of top down functionality of the code -- since you said we *don't*
want to process the parameters in the beginning and then again later,
a clean way to deal with this is to have a:

	a) built-in --> default resetter
	c) CLI reseter

The later would also neext to be extended eventually with the option
to use defaults from a configuration file instead. So instead we end
up with:

	a) built-in --> default resetter
	b) config parser --> config default structure builder
	c) CLI reseter

Where b) is optional. And when the CLI is used, it can work off of
b) and c) -- essentially *resetting* all values. Ie, when -c is used
we'd reset all values previously set on the CLI. Arguments *after* -c
would be parsed and apply.

So although it looks a bit odd, this patch does not implement b), it is
left to the next patch. But since resettting to built-in and doing a CLI
reset with a defaults structure passed are two separate tasks, I've
decided its cleaner to make two functions which make this crystal
clear.

> > +/* installs new defaults into the CLI parsing structure */
> > +static void install_defaults(
> > +	struct mkfs_default_params	*dft,
> > +	struct cli_params		*cli)
> > +{
> > +	memcpy(&cli->sb_feat, &dft->sb_feat, sizeof(cli->sb_feat));
> > +	memcpy(&cli->fsx, &dft->fsx, sizeof(cli->fsx));
> > +}
> > +
> > +/*
> > + * Reset defaults first to built-in defaults. Then resets cli opts to start
> > + * with these built-in defaults. All previously set CLI options will be ignored.
> > + */
> > +static void reset_defaults_and_cli(
> > +	struct mkfs_default_params	*dft,
> > +	struct cli_params		*cli)
> > +{
> > +	*dft = built_in_dft;
> > +
> > +	install_defaults(dft, cli);
> > +}
> > +
> > +/* Does the required work to process a new set of defaults */
> > +static void process_defaults(
> > +	struct mkfs_default_params	*dft,
> > +	struct cli_params		*cli)
> > +{
> > +	install_defaults(dft, cli);
> > +}
> > +
> >  int
> >  main(
> >  	int			argc,
> > @@ -3694,31 +3749,9 @@ main(
> >  		.loginternal = 1,
> >  	};
> >  	struct mkfs_params	cfg = {};
> > +	struct mkfs_default_params	dft;
> >  
> > -	/* build time defaults */
> > -	struct mkfs_default_params	dft = {
> > -		.type = DEFAULTS_BUILTIN,
> > -		.sectorsize = XFS_MIN_SECTORSIZE,
> > -		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> > -		.sb_feat = {
> > -			.log_version = 2,
> > -			.attr_version = 2,
> > -			.dir_version = 2,
> > -			.inode_align = true,
> > -			.nci = false,
> > -			.lazy_sb_counters = true,
> > -			.projid32bit = true,
> > -			.crcs_enabled = true,
> > -			.dirftype = true,
> > -			.finobt = true,
> > -			.spinodes = true,
> > -			.rmapbt = false,
> > -			.reflink = false,
> > -			.parent_pointers = false,
> > -			.nodalign = false,
> > -			.nortalign = false,
> > -		},
> > -	};
> > +	reset_defaults_and_cli(&dft, &cli);
> 
> I just don't seee what this abstraction improves over just declaring
> dft directly like this. 

Right now it doesn't buy us anything. It is until the next patch which
hopefully the reasoning to this would become evident.

> It's also not explained why the CLI
> structure needs to be initialised here, because we're going to
> overwrite it again as soon as we've selected the default value
> source....

We are -- but these two are actually separate tasks. They are *now*
functionally the same, but after the next patch it becomes clear that
they are two separate tasks.

And since resetting a default structure to use built-in values is *one*
task which I have to re-use in the net patch, I decided to add a helper
here.

> >  
> >  	platform_uuid_generate(&cli.uuid);
> >  	progname = basename(argv[0]);
> > @@ -3736,14 +3769,9 @@ main(
> >  	 * still be able to override them. When more than one source is
> >  	 * implemented, emit a message to indicate where the defaults being
> >  	 * used came from.
> > -	 *
> > -	 * printf(_("Default configuration sourced from %s\n"),
> > -	 *	  default_type_str(dft.type));
> >  	 */
> >  
> > -	/* copy new defaults into CLI parsing structure */
> > -	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
> > -	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
> > +	process_defaults(&dft, &cli);
> 
> i.e. here.
> 
> >  
> >  	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> >  		switch (c) {
> > @@ -3795,6 +3823,11 @@ main(
> >  	} else
> >  		dfile = xi.dname;
> >  
> > +	/*
> > +	 * printf(_("Default configuration sourced from %s\n"),
> > +	 *	  default_type_str(dft.type));
> > +	 */
> 
> What does moving this acheive?

My hope was that this would make it clear to the reader that the source
of the configuration can only be known *after* CLI processing since we
want to support -c.

  Luis

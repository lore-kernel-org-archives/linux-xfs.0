Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:34058 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751773AbeEUAOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 May 2018 20:14:38 -0400
Date: Mon, 21 May 2018 10:14:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180521001434.GO23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <20180518004404.GF23861@dastard>
 <20180519013224.GG27875@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180519013224.GG27875@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Sat, May 19, 2018 at 03:32:24AM +0200, Luis R. Rodriguez wrote:
> On Fri, May 18, 2018 at 10:44:04AM +1000, Dave Chinner wrote:
> > On Thu, May 17, 2018 at 12:27:00PM -0700, Luis R. Rodriguez wrote:
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -3077,11 +3078,13 @@ print_mkfs_cfg(
> > >  	struct mkfs_params	*cfg,
> > >  	char			*dfile,
> > >  	char			*logfile,
> > > -	char			*rtfile)
> > > +	char			*rtfile,
> > > +	struct mkfs_default_params *dft)
> > >  {
> > >  	struct sb_feat_args	*fp = &cfg->sb_feat;
> > >  
> > >  	printf(_(
> > > +"config-file=%-22s\n"
> > >  "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
> > >  "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
> > >  "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
> > > @@ -3091,6 +3094,7 @@ print_mkfs_cfg(
> > >  "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
> > >  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
> > >  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> > > +		dft->type != DEFAULTS_BUILTIN ? dft->config_file : "empty",
> > >  		dfile, cfg->inodesize, (long long)cfg->agcount,
> > >  			(long long)cfg->agsize,
> > >  		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
> > 
> > Haven't we already printed where the config was sourced from? Why do
> > we need to print it again here?
> 
> The other print describes the enum, this print prints out the *used*
> config file path if a config file was actually used. Without the other
> print this would just print either the config file or empty.

If you look at the changes I proposed, I suggested we change the
initial print out the path of the source file, not how the user
specified the source file. So this becomes redundant. And given this
code is now shared with xfs_info, it has no idea about mkfs config
files, so it's not ideal to be adding mkfs-specific stuff to this
output.

Further....

> Since we are going to remove the environment variable option, then
> I think the other print is now not needed anymore and my preference
> is to keep it here.
> 
> Thoughts?

.... this printout only happens after al input has been validated
and we're about to make the filesystem.  If there's a validation
problem, nobody knows what file the defaults were sourced from.
IOWs, the file the default are sourced from needs to be printed even
before the file is read...

> > >  	.sectorsize = XFS_MIN_SECTORSIZE,
> > >  	.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> > >  	.sb_feat = {
> > > @@ -3714,6 +3719,13 @@ static void process_defaults(
> > >  	struct mkfs_default_params	*dft,
> > >  	struct cli_params		*cli)
> > >  {
> > > +	int ret;
> > > +
> > > +	ret = parse_config_init(dft);
> > > +
> > > +	if (ret && dft->type != DEFAULTS_BUILTIN)
> > > +		usage();
> > 
> > That doesn't make any sense in isolation.
> 
> Not sure what you meant at first, but I see that you prefer this
> to be hidden from the caller. Will change.

I meant I have no idea what this is checking and why there's a usage
call there because usage() is for CLI input, not setting up
defaults before CLI processing. Explanation in comments are needed.

> > >  	install_defaults(dft, cli);
> > >  }
> > >  
> > > @@ -3750,6 +3762,8 @@ main(
> > >  	};
> > >  	struct mkfs_params	cfg = {};
> > >  	struct mkfs_default_params	dft;
> > > +	char *tmp_config;
> > > +	char custom_config[PATH_MAX];
> > >  
> > >  	reset_defaults_and_cli(&dft, &cli);
> > >  
> > > @@ -3760,21 +3774,36 @@ main(
> > >  	textdomain(PACKAGE);
> > >  
> > >  	/*
> > > -	 * TODO: Sourcing defaults from a config file
> > > -	 *
> > >  	 * Before anything else, see if there's a config file with different
> > > -	 * defaults. If a file exists in <package location>, read in the new
> > > +	 * defaults. If a file exists in MKFS_XFS_CONF_DIR/default, read the new
> > >  	 * default values and overwrite them in the &dft structure. This way the
> > >  	 * new defaults will apply before we parse the CLI, and the CLI will
> > >  	 * still be able to override them. When more than one source is
> > >  	 * implemented, emit a message to indicate where the defaults being
> > >  	 * used came from.
> > >  	 */
> > 
> > This comment makes no mention of environment variables, or how they
> > interact with other sources of config files.
> 
> As per Eric's request, We're getting rid of the environment variable option, so
> mentioning it is no longer needed.

I thought Darrick wanted it kept?

> > > +	tmp_config = getenv("MKFS_XFS_CONFIG");
> > > +	if (tmp_config != NULL) {
> > > +		dft.config_file = tmp_config;
> > > +		dft.type = DEFAULTS_ENVIRONMENT_CONFIG;
> > > +	}
> > >  
> > >  	process_defaults(&dft, &cli);
> > 
> > So why are we processing the defaults before we've checked if a
> > default file is specified on the command line? All this should do is
> > set up the config file to be read, and set the dft.source =
> > _("Environment Variable");
> 
> This was being done *here* since I previously has setup to process the
> arguments *early* and check if a -c was specified, and if so use the config
> file for the defaults, otherwise the environment variable if set. But since
> the way I had implemented processing the arguments early relied on not well
> guaranteed mechanisms I resorted to avoid that approach.
> 
> This was the alternative I came up with.
> 
> The environment variable stuff is going away so this should be much simpler
> now, however the question of argument processing early still remains.
> 
> > >  
> > > -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> > > +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> > >  		switch (c) {
> > > +		case 'c':
> > > +			reset_defaults_and_cli(&dft, &cli);
> > 
> > This will trash the existing CLI inputs that have already been
> > parsed. 
> 
> Exactly.
> 
> > All this code here should do is set up the config file
> > to be read.
> 
> Consider the case of /etc/mkfs.d/default existing and it having
> 
> [metadata]
> crc = 1
> [naming]
> ftype=1
> 
> And suppose the user passed -c foo which had:
> 
> [metadata]
> crc = 0
> 
> Without the reset we'd make /etc/mkfs.d/default the system wide defaults onto
> which -c parameters overlay on top of. I figured that was not desirable.

It's not desirable. If the user specified a config file, then
/etc/mkfs.d/default *is never read*. The user config file is used
instead. If the user supplied file does not exist (even after
searching) then we fail, not use some other set of defaults.

> > Again, what happens if the user specifies multiple config files?
> 
> The reset strategy lets the user set -c as many times as they wish and also
> starts from a clean base always.

multiple "-c" options is a user error and should error out.

> > The second config file will trash everything from the first, as well
> > as any other options between them.
> 
> Yes! By design as we couldn't easily parse arguments early first and then
> choose just one strategy.
>
> I liked the simplicity that this brings.
> 
> Would you really want multiple -c options to work as overlays, one on top of
> the other?

I don't want multiple -c option to be supported at all. We source
defaults from a single file only - either the user specified file,
or the default if it exists. Not both, not multiple user specified
files. One file.

> > I think that we need to pull the "-c <file>" option from the command
> > line and process all the defaults /before/ we enter the main command
> > line processing loop.
> 
> That is what I had done originally but ran into that snag of processing
> arguments twice and the undocumented functionality I found that worked.

Multiple pass option parsing is documented as supported and has been
for a long, long time. And to make that clear, we even have a
wrapper in xfsprogs for it:

$ git grep platform_getoptreset
db/command.c:   platform_getoptreset();
include/darwin.h:static __inline__ void platform_getoptreset(void)
include/freebsd.h:static __inline__ void platform_getoptreset(void)
include/gnukfreebsd.h:static __inline__ void platform_getoptreset(void)
include/linux.h:static __inline__ void platform_getoptreset(void)
libxcmd/command.c:      platform_getoptreset();

And we use it in libxcmd so that each function in xfs_io, xfs_db,
xfs_quota, etc can run their own sub-command getopt calls correctly.
It was in the initial commits for xfs_db back in 2001, so we've been
using multiple pass CLI option parsing in xfsprogs since 2001....

> > IOWs:
> > 	config_file = getenv("MKFS_XFS_CONFIG");
> > 	if (config_file)
> > 		dft.source = _("Environment Variable");
> > 
> > 	/*
> > 	 * Pull config line options from command line
> > 	 */
> > 	while ((c = getopt(argc, argv, "c:")) != EOF) {
> > 		switch (c) {
> > 		case 'c':
> > 			/* XXX: fail if already seen a CLI option */
> 
> BTW isn't my enum here sufficient to check for this easily in a clean
> short and easy way?

A local boolean variable is all that is ncessary for this....

[....]

> > 	memcpy(/* sb_feats */);
> > 	memcpy(/* fsxattr */);
> > 	optind = 1;
> 
> My getopt(3) *does* not make mention of any of this. This man page however does:

It's been there as long as I can remember. 2nd paragraph of the
description:

$man 3 getopt
[...]
DESCRIPTION
[...]
       The variable optind is the index of the next element to be
       processed in argv.  The system initializes this value to  1.
       The  caller  can reset it to 1 to restart scanning of the
       same argv, or when scanning a new argument vector.


> optind = 1;
> 
> However perhaps a big fat NOTE is worthy?

Why? It's documented, well known behaviour....

> > [...]
> > 
> > > +const char *default_type_str(enum default_params_type type)
> > > +{
> > > +	switch (type) {
> > > +	case DEFAULTS_BUILTIN:
> > > +		return _("package built-in definitions");
> > > +	case DEFAULTS_CONFIG:
> > > +		return _("default configuration system file");
> > > +	case DEFAULTS_ENVIRONMENT_CONFIG:
> > > +		return _("custom configuration file set by environment");
> > > +	case DEFAULTS_TYPE_CONFIG:
> > > +		return _("custom configuration type file");
> > > +	}
> > > +	return _("Unkown\n");
> > > +}
> > 
> > This function can go away.
> 
> Well depends, if we keep the enum the no ?

That enum needs to die. It's unnecssary abstraction.

> > > +	if (strlen(line) < 2)
> > > +		return PARSE_INVALID;
> > 
> > So empty lines return PARSE_INVALID?
> 
> Yes, but that's not fatal, we just discard it.

That's "ignore", like comments, not "invalid".

> 
> > > +
> > > +	if (line[0] == '#')
> > > +		return PARSE_COMMENT;
> > 
> > What about lines starting with whitespace? e.g. " # comment"
> 
> parse_line_section() below would not return 1 and its ignored
> in the end as its also not a proper tag/value pair and the
> section is not set.

So it silently ignores a valid sections/{tag/value pair} if there's
trailing stuff on the line? Shouldn't that throw an error?

> > > +{
> > > +	int ret;
> > > +	FILE *fp;
> > > +	struct stat sp;
> > > +	unsigned int num_subopts_sections = sizeof(config_subopt_tab) /
> > > +					    sizeof(struct config_subopts) - 1;
> > > +	char *p;
> > > +	char line[80], tag[80];
> > > +	bool value;
> > > +	enum parse_line_type parse_type;
> > > +	enum mkfs_config_section section = MKFS_CONFIG_SECTION_INVALID;
> > > +
> > > +	fp = fopen(dft->config_file, "r");
> > > +	if (!fp) {
> > > +		if (dft->type != DEFAULTS_BUILTIN) {
> > > +			fprintf(stderr, _("could not open config file: %s\n"),
> > > +				dft->config_file);
> > > +			ret = -ENOENT;
> > > +		} else
> > > +			ret = 0;
> > > +		return ret;
> > > +	}
> > 
> > This should be split out into a separate function that takes the
> > config file and tries to open it. If it's a relative path that was
> > supplied, then this function can also try all the configured search
> > paths for config files.
> 
> Eric asked to support 3 cases:
> 
>  a) ./ -- current working directory
>  b) /  -- full path
>  c) no prefix - we use the sysconfigdir/mkfs.d/

That's pretty much what I just suggested. :)

> > > +		return ret;
> > > +
> > > +	while (!feof(fp)) {
> > > +		p = fgets(line, sizeof(line), fp);
> > 
> > What if the line is longer than 80 characters? e.g. a long comment
> 
> If its a comment or spaces with a comment, we still only care for
> the first 80 characters, no?

What does fgets() do with the remaining characters on the line? They
are still parked in the input stream, so won't the next fgets() call
read them? And then we parse those bytes as if they are a new config
line?

IOWs, shouldn't we be using a line-based input function here? Say,
getline(3)?

> > > +		if (!p)
> > > +			continue;
> > > +
> > > +		parse_type = parse_get_line_type(line, tag, &value);
> > > +
> > > +		switch (parse_type) {
> > > +		case PARSE_COMMENT:
> > > +		case PARSE_INVALID:
> > > +		case PARSE_EOF:
> > > +			break;
> > > +		case PARSE_SECTION:
> > > +			section = get_config_section(tag);
> > > +			if (!section) {
> > > +				fprintf(stderr, _("Invalid section: %s\n"),
> > > +						tag);
> > > +				return -EINVAL;
> > > +			}
> > > +			break;
> > > +		case PARSE_TAG_VALUE:
> > > +			/* Trims white spaces */
> > > +			snprintf(line, sizeof(line), "%s=%u", tag, value);
> > > +			ret = parse_config_subopts(section, value, line, dft);
> > 
> > We've already got the tag and value as discrete variables - why put
> > them back into an ascii string to pass to another function for it to
> > split them back into discrete variables?
> 
> The comment above it explains, "Trims white spaces"

Why do we need to do that? Doesn't the token parser trim away excess
whitespace around each token it returns?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

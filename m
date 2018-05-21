Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38423 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbeEUScL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 14:32:11 -0400
Received: by mail-pf0-f196.google.com with SMTP id o76-v6so7489918pfi.5
        for <linux-xfs@vger.kernel.org>; Mon, 21 May 2018 11:32:11 -0700 (PDT)
Date: Mon, 21 May 2018 11:32:06 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180521183206.GI24680@garbanzo.do-not-panic.com>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <20180517205845.GV23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517205845.GV23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 02:31:21PM -0700, Darrick J. Wong wrote:
> On Thu, May 17, 2018 at 12:27:00PM -0700, Luis R. Rodriguez wrote:
> > If you used the
> > +.B -c
> > +parameter or if you set the
> > +.I MKFS_XFS_CONFIG
> > +environment variable the configuration file must be present and should parse
> 
> "...must parse..."

Fixed and dropped the MKFS_XFS_CONFIG environment variable reference.

> > +correctly.
> > +.PP
> > +Parameters passed to to the
> 
> "...passed to the..."

Fixed.

> > diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> > index 4b8c78c37806..fadc4c589a8c 100644
> > --- a/man/man8/mkfs.xfs.8
> > +++ b/man/man8/mkfs.xfs.8
> > @@ -83,6 +83,26 @@ and
> >  .B \-l internal \-l size=10m
> >  are equivalent.
> >  .PP
> > +An optional XFS configuration file directory
> > +.B mkfs.xfs.d (5)
> 
> %sysconfigdir%/mkfs.xfs.d ?

I rather refer to the man page using the short name. When referring to
the full path though I will add the %sysconfigdir%/mkfs.xfs.d and have
this parse.

> > @@ -3077,11 +3078,13 @@ print_mkfs_cfg(
> >  	struct mkfs_params	*cfg,
> >  	char			*dfile,
> >  	char			*logfile,
> > -	char			*rtfile)
> > +	char			*rtfile,
> > +	struct mkfs_default_params *dft)
> >  {
> >  	struct sb_feat_args	*fp = &cfg->sb_feat;
> >  
> >  	printf(_(
> > +"config-file=%-22s\n"
> >  "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
> >  "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
> >  "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
> > @@ -3091,6 +3094,7 @@ print_mkfs_cfg(
> >  "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
> >  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
> >  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> > +		dft->type != DEFAULTS_BUILTIN ? dft->config_file : "empty",
> >  		dfile, cfg->inodesize, (long long)cfg->agcount,
> >  			(long long)cfg->agsize,
> >  		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
> 
> FWIW all this geometry printing was refactored into libfrog.
> 
> Though, you already print where we got the configuration data, so just
> print dft->config_file there.

True, will do.

> > -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> > +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> >  		switch (c) {
> > +		case 'c':
> > +			reset_defaults_and_cli(&dft, &cli);
> > +
> > +			memset(custom_config, 0, sizeof(custom_config));
> > +			snprintf(custom_config, sizeof(custom_config), "%s%s",
> > +				 MKFS_XFS_CONF_DIR, optarg);
> > +			dft.config_file = custom_config;
> > +			dft.type = DEFAULTS_TYPE_CONFIG;
> 
> Ok, so we parse $MKFS_XFS_CONFIG but then if the user specifies -c we
> reset all that and parse that config file.

Right.

> Just for fun I decided to run:
> 
> $ cat > /tmp/butts.lol
> [gugugugug]
> bye = 1
> [metadata]
> hork = 1
> $ ./build-x64/mkfs/mkfs.xfs -c ../../../../../../../tmp/butts.lol -N /dev/sda
> Error parsine line: bye=1
> 
> I think we need to error out on unrecognized section names:
> 
> "Unrecognized section name 'gugugugug'."

Will fix.

> And probably report the section name for unrecognized keys:
> 
> "Unrecognized name 'metadata.hork"."

Alright.

> > +#define CONFIG_MAX_KEY		1024
> > +#define CONFIG_MAX_VALUE	PATH_MAX
> 
> That's a pretty big size considering we only allow 0 and 1...

Heh true, as per Chinner will just check for a single max file size for
about 1MiB or so, so we won't need these as it was just used to compute
a max theoretical file size. By using a simple reasonable file size we
remove the need for the above.

> > +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> > +
> > +/*
> > + * Enums for each configuration option. All these currently match the CLI
> > + * parameters for now but this may change later, so we keep all this code
> > + * and definitions separate. The rules for configuration parameters may also
> > + * differ.
> > + */
> 
> So... I think these enums should be shared between cli and config file
> processing, 

As per Chinner's request we'd duplicate for now as we may want to
support alternative config options which would differ from the CLI
options. This is why the comment above it notes this.

> or if the config file parser retains its own private
> definitions then it should only have the options that we support in the
> config file.  It's weird how things like data.sunit are specified here
> but the config file doesn't actually do anything with it?

The enum is defined for it, the parser however lacks a switch entry for
it. I'll just trim the enums to what we currently parse only then.

> $ cat > /tmp/butts.lol
> [data]
> sunit = 5
> $ ./build-x64/mkfs/mkfs.xfs -c ../../../tmp/butts.lol -N /dev/sda | grep sunit
>          =                       sunit=0      swidth=0 blks
> 
> That really ought to error out, since we don't support setting sunit?

Will verify and fix.

> > +const char *default_type_str(enum default_params_type type)
> 
> const char *
> default_type_str(
> 	enum default_params_type	type)
> {
> 	...
> }
> 
> Please follow regular xfs formatting conventions.

Will do.

> > +{
> > +	switch (type) {
> > +	case DEFAULTS_BUILTIN:
> > +		return _("package built-in definitions");
> > +	case DEFAULTS_CONFIG:
> > +		return _("default configuration system file");
> > +	case DEFAULTS_ENVIRONMENT_CONFIG:
> > +		return _("custom configuration file set by environment");
> > +	case DEFAULTS_TYPE_CONFIG:
> > +		return _("custom configuration type file");
> > +	}
> > +	return _("Unkown\n");
> 
> "Unknown"

This call is being removed as per Chinner's request.

> > +static int mkfs_check_config_file_limits(const char *filename,
> > +					 const struct stat *sb,
> > +					 unsigned int max_entries)
> > +{
> > +	unsigned long long size_limit;
> > +
> > +	size_limit = CONFIG_MAX_BUFFER * max_entries;
> > +
> > +	/*
> > +	 * Detect wrap around -- if max_entries * size_limit goves over
> > +	 * unsigned long long we detect that there. Note some libraries,
> > +	 * like libiniconfig, only groks max INT_MAX entries anyway, so
> > +	 * if we ever use a library for parsing we'd be restricted to that
> > +	 * limit.
> > +	 */
> > +	if (size_limit < max_entries || max_entries > INT_MAX)
> > +		return -E2BIG;
> > +
> > +	if (sb->st_size > size_limit) {
> > +		fprintf(stderr,
> > +			"File %s is too big! File size limit: %llu\n",
> > +			filename, size_limit);
> > +		return -E2BIG;
> > +	}
> 
> Not sure why we care about the file size?  If the config file
> respecifies options a trillion times then let it.

I'll simplify the check to 1MiB file size alone.

Chinner requested we actually don't allow respecification on the
configuration file. Let me know what you two decide.

> > +
> > +	return 0;
> > +}
> > +
> > +enum parse_line_type {
> > +	PARSE_COMMENT = 0,
> > +	PARSE_SECTION,
> > +	PARSE_TAG_VALUE,
> > +	PARSE_INVALID,
> > +	PARSE_EOF,
> > +};
> > +
> > +static int parse_line_section(const char *line, char *tag)
> > +{
> > +	return sscanf(line, " [%[^]]s]", tag);
> > +}
> > +
> > +static int parse_line_tag_value(const char *line, char *tag,
> > +				unsigned int *value)
> > +{
> > +	return sscanf(line, " %[^ \t=]"
> > +		      " = "
> > +		      "%u ",
> > +		      tag, value);
> > +}
> > +
> > +static enum parse_line_type parse_get_line_type(const char *line, char *tag,
> > +						bool *value)
> > +{
> > +	int ret;
> > +	unsigned int uint_value;
> > +
> > +	memset(tag, 0, 80);
> > +
> > +	if (strlen(line) < 2)
> > +		return PARSE_INVALID;
> > +
> > +	if (line[0] == '#')
> > +		return PARSE_COMMENT;
> > +
> > +	ret = parse_line_section(line, tag);
> > +	if (ret == 1)
> > +		return  PARSE_SECTION;
> > +
> > +	if (ret == EOF)
> > +		return PARSE_EOF;
> > +
> > +	ret = parse_line_tag_value(line, tag, &uint_value);
> > +	if (ret == 2) {
> > +		if (uint_value != 1 && uint_value != 0)
> > +			return -EINVAL;
> 
> If I set data.sunit = 5 this will return -EINVAL to the switch in
> parse_config_init.  However, the switch lacks a default clause so it
> silently drops invalid values and proceeds with the format.

Odd, in this case sunit is a valid tag, so it shoudl have errored out,
but will re-test and also ensure invalid tags fail accordingly.

> > +
> > +		*value = !!uint_value;
> > +
> > +		return PARSE_TAG_VALUE;
> > +	}
> > +
> > +	if (ret == EOF)
> > +		return PARSE_EOF;
> > +
> > +	return PARSE_INVALID;
> > +}
> > +
> > +int parse_config_init(struct mkfs_default_params *dft)
> > +{
> > +	int ret;
> > +	FILE *fp;
> > +	struct stat sp;
> > +	unsigned int num_subopts_sections = sizeof(config_subopt_tab) /
> > +					    sizeof(struct config_subopts) - 1;
> > +	char *p;
> > +	char line[80], tag[80];
> 
> Waitaminute, didn't we set CONFIG_MAX_KEY = 1024 and CONFIG_MAX_VALUE
> to PATH_MAX?

Heh yeah, I'll just drop those and keep 80.

> > +	bool value;
> > +	enum parse_line_type parse_type;
> > +	enum mkfs_config_section section = MKFS_CONFIG_SECTION_INVALID;
> > +
> > +	fp = fopen(dft->config_file, "r");
> > +	if (!fp) {
> > +		if (dft->type != DEFAULTS_BUILTIN) {
> 
> Why would we be parsing a config file if dft->type == DEFAULTS_BUILTIN?

If the user specified an environment variable thent he error should be
fatal, otherwise, if the type is built-in then the default is being
picked up, and in such case an error on the file not existing is
non-fatal.

But all this will be simplified now that we'll just deal with *one*
choice of parsing early.

> > +			fprintf(stderr, _("could not open config file: %s\n"),
> > +				dft->config_file);
> > +			ret = -ENOENT;
> > +		} else
> > +			ret = 0;
> > +		return ret;
> > +	}
> > +
> > +	/*
> > +	 * If we found a file without it being specified on the command line,
> > +	 * it would be the default configuration file.
> > +	 */
> > +	if (dft->type == DEFAULTS_BUILTIN)
> > +		dft->type = DEFAULTS_CONFIG;
> 
> Oh, I see, type == _BUILTIN really means "we picked up
> /etc/mkfs.xfs.d/defaults"... shouldn't the caller set this?

No, it means the built-in defaults were used, but since the config file
exists, it means either the deault config file was found or the user
specified one.

But again, this will all be simplified further.

> > +
> > +	ret = stat(dft->config_file, &sp);
> 
> fstat(fileno(fp), &sp); ?

Sure!

> > +	if (ret) {
> > +		if (dft->type != DEFAULTS_BUILTIN)
> 
> Didn't we just set this to _CONFIG?

Only if it was not built-in, ie, if the environment variable was used
nope.

> > +			fprintf(stderr, _("could not stat() config file: %s: %s\n"),
> > +				dft->config_file, strerror(ret));
> > +		return ret;
> 
> We just leaked fp...

I've sprinkled goto outs, thanks.

> > +	}
> > +
> > +	if (!sp.st_size)
> > +		return 0;
> 
> Can't we just keep going?  If the file size is zero we never execute the
> loop.

Either way is fine, less code is better, so will remove this.

> > +	ret = mkfs_check_config_file_limits(dft->config_file, &sp,
> > +					    num_subopts_sections);
> > +	if (ret)
> > +		return ret;
> > +
> > +	while (!feof(fp)) {
> > +		p = fgets(line, sizeof(line), fp);
> > +		if (!p)
> > +			continue;
> > +
> > +		parse_type = parse_get_line_type(line, tag, &value);
> > +
> > +		switch (parse_type) {
> > +		case PARSE_COMMENT:
> > +		case PARSE_INVALID:
> > +		case PARSE_EOF:
> > +			break;
> > +		case PARSE_SECTION:
> > +			section = get_config_section(tag);
> > +			if (!section) {
> > +				fprintf(stderr, _("Invalid section: %s\n"),
> > +						tag);
> > +				return -EINVAL;
> > +			}
> > +			break;
> > +		case PARSE_TAG_VALUE:
> > +			/* Trims white spaces */
> > +			snprintf(line, sizeof(line), "%s=%u", tag, value);
> 
> So we reconstruct the line (without the whitespaces) so that we can use
> getsubopt to map the tag to an integer value (e.g. D_AGCOUNT)... 

Right.

> we already isolated *tag, so can't we map it directly?

What do you mean by map it directly?

> > +			ret = parse_config_subopts(section, value, line, dft);
> > +			if (ret) {
> > +				fprintf(stderr, _("Error parsine line: %s\n"),
> > +						line);
> > +				return ret;
> > +			}
> > +			break;
> 
> case -EINVAL?

I take it you meant case default: return -EINVAL? Since I use enums on
the return value from parse_get_line_type() and on the switch statement,
the compiler checks for any known enums which were not on the switch and
complains if one is found.

So long as parse_get_line_type() returns an PARSE_INVALID or
PARSE_IGNORE (which I'll have to add) then we're OK without it, and
are better off without a default case to ensure we cover all parse
type conditions we add.

  Luis

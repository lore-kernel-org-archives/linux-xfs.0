Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbeFAVNk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 17:13:40 -0400
Date: Fri, 1 Jun 2018 23:13:38 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v4 3/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180601211338.GS4511@wotan.suse.de>
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-4-mcgrof@kernel.org>
 <20180530033329.GU10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530033329.GU10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Wed, May 30, 2018 at 01:33:29PM +1000, Dave Chinner wrote:
> On Tue, May 29, 2018 at 03:06:02PM -0700, Luis R. Rodriguez wrote:
> > You may want to stick to specific set of configuration options when
> > creating filesystems with mkfs.xfs -- sometimes due to pure technical
> > reasons, but some other times to ensure systems remain compatible as
> > new features are introduced with older kernels, or if you always want
> > to take advantage of some new feature which would otherwise typically
> > be disruptive.
> > 
> > This adds support for parsing a configuration file to override defaults
> > parameters to be used for mkfs.xfs.
> .....
> > +static int
> > +data_config_parser(
> > +	struct mkfs_default_params	*dft,
> > +	int				psubopt,
> > +	uint64_t			value)
> > +{
> > +	enum data_subopts	subopt = psubopt;
> 
> This is unnecessary. enums and ints are the same thing when it comes
> to comparisons.

Yes but I have a reason to use enum: if you expand on an enum entry
for a subopt, the compiler will warn if the respective subopt parser
fails to have an entry for it. This is possible when and if you have
no default.

This believe this is purely a bikeshed coding preference style, but its what I
prefer. Let me know what you prefer.

> > +
> > +	switch (subopt) {
> > +	case D_NOALIGN:
> > +		dft->sb_feat.nodalign = value;
> > +		return 0;
> > +	}
> > +	return EINVAL;
> 
> Negative errors, please. All xfsprogs use negative error numbers
> like the kernel now, so please don't take us back to the bad old
> days of having to change error signs depending on where the error
> came from....

OK! I used positive values as we want these errors then to be described
later with strerror(ret) but right now this return value comes from
what parse_defaults_file() returns, I suppose I can just set errno to the
positive values and return -1 or whatever. So the caller as Darrick
suggests:

if (parse_defaults_file()) {
	fprintf(stderr, _(fError parsing %s config file: %s : %s\n")
		        dft.source, config_file, strerror(ret));
	...
}

> Actually, I'm surprised that the compiler isn't complaining about
> not having a default statement in the switch statement.

Its not complaining as *all* the enums for each type are addressed :)

> Can they be
> structured like the cli options to avoid this in future?
> 
> 	switch (subopt) {
> 	case D_NOALIGN:
> 		.....
> 		break;
> 	default:
> 		return -EINVAL;
> 	}
> 	return 0;

If we do that we'd loose out on the compiler feature I described above.
Let me know your preference.

> > +enum parse_line_type {
> > +	PARSE_COMMENT = 0,
> > +	PARSE_EMPTY,
> > +	PARSE_SECTION,
> > +	PARSE_TAG_VALUE,
> > +	PARSE_INVALID,
> > +	PARSE_EOF,
> > +};
> > +
> > +static bool
> > +isempty(
> > +	const char	*line,
> > +	ssize_t		linelen)
> > +{
> > +	ssize_t		i = 0;
> > +	char		p;
> > +
> > +	while (i != linelen) {
> 
> 	while (i < linelen) {

amended

> 
> > +		p = line[i];
> > +		i++;
> 
> 		p = line[i++];

amended

> 
> > +
> > +		/* tab or space */
> > +		if (isblank(p))
> > +			continue;
> > +		else
> > +			return false;
> > +	}
> 
> 		if (!isblank(p))
> 			return false;

amended

> 	}
> > +
> > +	return true;
> > +}
> > +
> > +static bool
> > +iscomment(
> > +	const char	*line,
> > +	ssize_t		linelen)
> > +{
> > +	ssize_t		i = 0;
> > +	char		p;
> > +
> > +	while (i != linelen) {
> > +		p = line[i];
> > +		i++;
> > +
> > +		/* tab or space */
> > +		if (isblank(p))
> > +			continue;
> > +
> > +		if (p == '#')
> > +			return true;
> > +
> > +		return false;
> > +	}
> > +
> > +	return false;
> > +}
> > +
> > +static int
> > +parse_line_section(
> > +	const char	*line,
> > +	char		**tag)
> > +{
> > +	return sscanf(line, " [%m[^]]]", tag);
> > +}
> > +
> > +static int
> > +parse_line_tag_value(
> > +	const char	*line,
> > +	char		**tag,
> > +	uint64_t	*value)
> > +{
> > +	return sscanf(line, " %m[^ \t=]"
> > +		      " = "
> > +		      "%lu ",
> > +		      tag, value);
> > +}
> 
> %lu won't match uint64_t on 32 bit builds. Doesn't this need to be
> PRIu64 to be correct?

PRIu64 indeed seems to be the right thing to use for uint64_t for c99.

> Hmmm, I thought the compiler checked this
> format stuff and threw warnings when you get it wrong?

I get no compiler errors.

> Also, I'm not sure there's any value to these single line functions.
> Why not just call them directly in the next function?

Because they are descriptive and saves us the comment. You seem to prefer
to have the comment so I will use that.

> > +
> > +static enum parse_line_type
> > +parse_get_line_type(
> > +	const char	*line,
> > +	ssize_t		linelen,
> > +	char		**tag,
> > +	uint64_t	*value)
> > +{
> > +	int		ret;
> > +	uint64_t	u64_value;
> > +
> > +	if (isempty(line, linelen))
> > +		return PARSE_EMPTY;
> > +
> > +	if (iscomment(line, linelen))
> > +		return PARSE_COMMENT;
> > +
> > +	ret = parse_line_section(line, tag);
> > +	if (ret == 1)
> > +		return  PARSE_SECTION;
> 
> i.e.
> 	/* check if we have a section header */
> 	ret = sscanf(line, " [%m[^]]]", tag);
> 	if (ret == 1)
> 		return  PARSE_SECTION;

OK

> > +
> > +	if (ret == EOF)
> > +		return PARSE_EOF;
> > +
> > +	ret = parse_line_tag_value(line, tag, &u64_value);
> > +	if (ret == 2) {
> > +		*value = u64_value;
> > +
> > +		return PARSE_TAG_VALUE;
> > +	}
> 
> 	/* should be a "tag = value" config option */
> 	ret = sscanf(line, " %m[^ \t=] = %" PRIu64 " ", tag, value);
> 	if (ret == 2)
> 		return PARSE_TAG_VALUE;

Sure.

> > +
> > +	if (ret == EOF)
> > +		return PARSE_EOF;
> > +
> > +	return PARSE_INVALID;
> > +}
> > +
> > +static int
> > +parse_config_stream(
> > +	struct mkfs_default_params	*dft,
> > +	const char 			*config_file,
> > +	FILE				*fp)
> > +{
> > +	int				ret;
> > +	char				*line = NULL;
> > +	ssize_t				linelen;
> > +	size_t				len = 0, lineno = 0;
> > +	uint64_t			value;
> > +	enum parse_line_type		parse_type;
> > +	struct confopts			*confopt = NULL;
> > +	int				subopt;
> > +
> > +	while ((linelen = getline(&line, &len, fp)) != -1) {
> > +		char *ignore_value;
> > +		char *p, *tag = NULL;
> > +
> > +		lineno++;
> > +
> > +		/*
> > +		 * tag is allocated for us by scanf(), it must freed only on any
> > +		 * successful parse of a section or tag-value pair.
> > +		 */
> > +		parse_type = parse_get_line_type(line, linelen, &tag, &value);
> > +
> > +		switch (parse_type) {
> > +		case PARSE_EMPTY:
> > +		case PARSE_COMMENT:
> > +			/* Nothing tag to free for these */
> > +			continue;
> > +		case PARSE_EOF:
> > +			break;
> > +		case PARSE_INVALID:
> > +			ret = EINVAL;
> 
> Negative errors.

Alright.

> > +			fprintf(stderr, _("Invalid line %s:%zu : %s\n"),
> > +					  config_file, lineno, line);
> > +			goto out;
> > +		case PARSE_SECTION:
> > +			confopt = get_confopts(tag);
> > +			if (!confopt) {
> > +				ret = EINVAL;
> > +				fprintf(stderr, _("Invalid section on line %s:%zu : %s\n"),
> > +						config_file, lineno, tag);
> > +				free(tag);
> > +				goto out;
> 
> 				goto out_free_tag;
> ....
> out_free_tag:
> 	free(tag);
> 	ret = -EINVAL;
> 	goto out;
> 
> Same for all thers others.

OK.

> > +			}
> > +			if (!confopt->subopts) {
> > +				ret = EINVAL;
> > +				fprintf(stderr, _("Section not yet supported on line %s:%zu : %s\n"),
> > +						config_file, lineno, tag);
> > +				free(tag);
> > +				goto out;
> > +			}
> > +			if (confopt->seen) {
> > +				ret = EINVAL;
> > +				fprintf(stderr, _("Section '%s' respecified\n"),
> > +						tag);
> > +				free(tag);
> > +				goto out;
> > +			}
> > +			confopt->seen = true;
> > +			free(tag);
> > +			break;
> > +		case PARSE_TAG_VALUE:
> > +			if (!confopt) {
> > +				ret = EINVAL;
> > +				fprintf(stderr, _("No section specified yet on line %s:%zu : %s\n"),
> > +						config_file, lineno, line);
> > +				free(tag);
> > +				goto out;
> > +			}
> > +
> > +			/*
> > +			 * We re-use the line buffer allocated by getline(),
> > +			 * however line must be kept pointing to its original
> > +			 * value to free it later. A separate pointer is needed
> > +			 * as getsubopt() will otherwise muck with the value
> > +			 * passed.
> > +			 */
> > +			p = line;
> > +
> > +			/*
> > +			 * Trims white spaces. getsubopt() does not grok
> > +			 * white space, it would fail otherwise.
> > +			 */
> > +			snprintf(p, len, "%s=%lu", tag, value);
> > +
> > +			/* Not needed anymore */
> > +			free(tag);
> > +
> > +			/*
> > +			 * We only use getsubopt() to validate the possible
> > +			 * subopt, we already parsed the value and its already
> > +			 * in a more preferred data type.
> > +			 */
> > +			subopt = getsubopt(&p, (char **) confopt->subopts,
> > +					   &ignore_value);
> 
> This hoop-jumping cruft can all be replaced with a simple loop that
> just compares the tag to the subopts array:
> 
> 			for (i = 0; i < MAX_SUBOPTS; i++) {
> 				if (!confopt->subopts[i]) {

On the kernel it would be but on userspace this could be uninitialized?

> 					/* option not found, error out */
> 					goto out_free_tag;
> 				}
> 
> 				if (strcmp(confopt->subopts[i], tag) == 0)
> 					break;
> 			}
> 			free(tag);
> 
> 			ret = confopt->parser(dft, i, value);
> > +			if (ret) {
> > +				fprintf(stderr, _("Error parsine line %s:%zu : %s\n"),
> > +						config_file, lineno, line);
> > +				goto out;
> > +			}
> > +
> > +			break;
> > +		}
> > +	}
> > +out:
> > +	/* We must free even if getline() failed */
> > +	free(line);
> > +	return ret;
> > +}
> > +
> > +static const char *conf_paths[] = {
> > +	".",
> > +	MKFS_XFS_CONF_DIR,
> > +};
> > +
> > +/*
> > + * If the file is not found -1 is returned and errno set. Otherwise
> > + * the file descriptor is returned.
> > + */
> > +int
> > +open_cli_config(
> > +	char			*cli_config_file,
> > +	char			**fpath)
> > +{
> > +	int			fd, len;
> > +	char			*final_path = NULL;
> > +	char			*relative_path= NULL;
> > +	unsigned int		i;
> > +
> > +	if (strlen(cli_config_file) > 2) {
> > +		if (cli_config_file[0] == '.' && cli_config_file[1] == '/')
> > +			final_path = cli_config_file;
> > +		else if (cli_config_file[0] == '.' && cli_config_file[1] == '.')
> > +			final_path = cli_config_file;
> > +		else if (cli_config_file[0] == '/')
> > +			final_path = cli_config_file;
> > +		else
> > +			relative_path = cli_config_file;
> > +	} else if (strlen(cli_config_file) == 1) {
> > +		if (cli_config_file[0] == '.' || cli_config_file[0] == '/') {
> > +			errno = EINVAL;
> > +			return -1;
> > +		} else
> > +			relative_path = cli_config_file;
> > +	}
> 
> This seems somewhat complex, and it doesn't check what the target of
> the path is.
> 
> 	fstatat(AT_FDCWD, fpath, &st, AT_SYMLINK_NOFOLLOW);
> 
> will tell us if the file exists, it doesn't end in a symlink
> and it will resolve both both relative and absolute paths correctly.
> 
> If it succeeds, then we can check that the path points to a regular
> file (and not, say, a block device) so that this sort of thing:
> 
> [30/5/18 12:08] <sandeen> mkfs/mkfs.xfs -c  /dev/sdb1 
> [30/5/18 12:08] <sandeen> Invalid line /dev/sdb1:1 : XFSB
> 
> Gives a sensible error before we get to parsing.
> 
> If the file is found and isn't a regular file, then abort.
> 
> If the file isn't found, then we need to ensure that we have been
> passed a name without any directory component as we are going to
> search the sysconf dir for that file. That's where basename(3) comes
> in - if the name returned by basename(3) doesn't match fpath, then
> there was a directory component in fpath, and we reject it and
> abort.
> 
> Then we can open the sysconf directory w/ O_PATH|O_DIRECTORY, then
> do the same fstatat check and open it w/ openat():
> 
> 	fstatat(dirfd, fpath, &st, AT_SYMLINK_NOFOLLOW);
> 	/* check return */
> 	openat(dirfd, fpath, O_NOFOLLOW, O_RDONLY);
> 
> IOWs, I don't think we should be looking at just the first two
> characters of the supplied filename to determine the action to take,
> nor do i think we shoul dbe trying to resolve relative paths under
> the sysconf dir.

Alright, I'll give this a shot.

> > +/*
> > + * This is only called *iff* there is a configuration file which we know we
> > + * *must* parse.
> > + *
> > + * If default_fd is set and is a valid file descriptor then the configuration
> > + * file passed is the system default configuraiton file, and we already know
> > + * it exists. If default_fd is not set we assume we've been passed a
> > + * configuration file from the command line and must it must exist, otherwise
> > + * we have to error out.
> > + */
> > +int
> > +parse_defaults_file(
> > +	struct mkfs_default_params		*dft,
> > +	int					default_fd,
> > +	char					*config_file)
> > +{
> > +	char			*fpath;
> > +	int			fd;
> > +	FILE			*fp;
> > +	int			ret;
> > +	struct stat		sp;
> > +
> > +	if (strlen(config_file) > PATH_MAX)
> > +		return ENAMETOOLONG;
> > +
> > +	fpath = malloc(PATH_MAX);
> > +	if (!fpath)
> > +		return ENOMEM;
> > +	memset(fpath, 0, PATH_MAX);
> > +
> > +	if (default_fd < 0) {
> > +		fd = open_cli_config(config_file, &fpath);
> > +		if (fd < 0) {
> > +			free(fpath);
> > +			return errno;
> > +		}
> > +	} else {
> > +		fd = default_fd;
> > +		memcpy(fpath, config_file, strlen(config_file));
> > +	}
> 
> This is messy - opening the file shoul dbe split from parsing the
> config file. I make more comments about the reason below. But I
> think this should end up as:
> 
> int
> open_config_file(
> 	const char	*config_file,
> 	char		**source)
> {
> 	/*
> 	 * XXX: should asprintf the source string

OK
>          so it's got the
> 	 * config_file opened in it.

Not sure what you mean by this though, can you clarify?

> 	 */
> 	dft.source = _("Built in defaults");

This was already set, and dft is not a global, are you suggesting
to remove the global setting you had and *always* make source now an
allocated string?

> 	dirfd = open(sysconfdir, O_PATH|O_NOFOLLOW);
> 
> 	if (config_file) {
> 		fd = open_cli_config(dirfd, config_file)
> 		if (fd > 0)

		    fd >= 0

> 			*source = _("CLI supplied file");
> 		goto out;
> 	}
> 
> 	fd = openat(dirfd, "default")
> 	if (fd > 0)

	    fd >= 0

> 		*source = ("Package default config file")

I take it you mean to use asprintf(source, _("Package default config file")
but this can also fail... and adds more error paths to check for...

> out:
> 	close(dirfd);
> 	return fd;
> }

I think this asprintf() source approach add more complexity as well, which is
why I had used an enum for it a while ago. Think about it and let me know.

> and so be completely separated from the act of parsing the config
> file.
> 
> > +
> > +	/*
> > +	 * At this point we know we have a valid file descriptor and have
> > +	 * figured out the path to the file used on fpath. Get the file stream
> > +	 * and do a bit of sanity checks before parsing the file.
> > +	 */
> > +
> > +	fp = fdopen(fd, "r");
> > +	if (!fp) {
> > +		perror(fpath);
> > +		ret = errno;
> > +		goto out_close_fd;
> > +	}
> > +
> > +	ret = fstat(fd, &sp);
> > +	if (ret) {
> > +		ret = errno;
> > +		fprintf(stderr, _("Could not fstat() config file: %s: %s\n"),
> > +			fpath, strerror(errno));
> > +		goto out;
> > +	}
> > +
> > +	if (S_ISDIR(sp.st_mode)) {
> > +		ret = EBADF;
> 
> 	if (!S_ISREG(sp.st_mode)) {
> 		ret = -EINVAL;

Amended.

> 
> > +		fprintf(stderr, _("Config file is a directory: %s\n"), fpath);
> > +		goto out;
> > +	}
> > +
> > +	/* Anything beyond 1 MiB is kind of silly right now */
> > +	if (sp.st_size > 1 * 1024 * 1024) {
> > +		ret = E2BIG;
> > +		goto out;
> > +	}
> 
> As mentioned about, these checks should be done before we even open
> the file.

OK

> > +
> > +	/*
> > +	 * Pull config line options from command line
> >  	 */
> > +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> 
> Why specify all the parameters? We're only interested in the "c:"
> parameter here, so that's the only one we need to specify, right?

Have you tried? I didn't work for me, its why I added the full set of
parameters again.

> Otherwise we've got two config option strings we need to keep i
> check...

Right, which is why I had a macro for it a while ago.

> > +		switch (c) {
> > +		case 'c':
> > +			if (cli_config_file) {
> > +				fprintf(stderr, _("respecification of configuration not allowed\n"));
> > +				exit(1);
> > +			}
> > +			cli_config_file = optarg;
> > +			dft.source = _("command line");
> > +			break;
> > +		default:
> > +			continue;
> > +		}
> > +	}
> > +
> > +	if (cli_config_file)
> > +		config_file = cli_config_file;
> > +	else {
> > +		default_fd = open(default_config, O_RDONLY);
> > +		if (default_fd >= 0) {
> > +			dft.source = _("system default configuration file");
> > +			config_file = default_config;
> > +		}
> > +	}
> > +
> > +	if (config_file) {
> > +		/* If default_fd is set it will be closed for us */
> > +		ret = parse_defaults_file(&dft, default_fd, config_file);
> > +		if (ret) {
> > +			fprintf(stderr, _("Error parsing %s config file: %s : %s\n"),
> > +					dft.source, config_file,
> > +					strerror(ret));
> > +			exit(1);
> > +		}
> > +	}
> 
> It doesn't make sense to me to open the default config file here
> before we know if it going to be needed. I would suggest that this
> get split into two parts - one to find and open the config file, the
> other to parse the opened file. i.e.:
> 
> 	fd = open_config_file(cli_config_file, &dft.source);
> 	if (fd >= 0) {
> 		ret = parse_defaults_file(fd, &dft);
> 		....
> 		close(fd);
> 	}

Let me know what you think of the other things first too.

  Luis

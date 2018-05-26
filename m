Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030723AbeEZAF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 20:05:58 -0400
Date: Fri, 25 May 2018 17:05:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 3/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180526000537.GT12940@magnolia>
References: <20180525031943.29440-1-mcgrof@kernel.org>
 <20180525031943.29440-4-mcgrof@kernel.org>
 <20180525040143.GR14384@magnolia>
 <20180525233307.GE24593@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525233307.GE24593@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: g@garbanzo.do-not-panic.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Fri, May 25, 2018 at 04:33:07PM -0700, Luis R. Rodriguez wrote:
> I've applied all the recommendations for the man page updates you
> provided. More below on the code questions.
> 
> On Thu, May 24, 2018 at 09:01:43PM -0700, Darrick J. Wong wrote:
> > On Thu, May 24, 2018 at 08:19:42PM -0700, Luis R. Rodriguez wrote:
> > > +static struct confopts *
> > > +get_confopts(
> > > +	const char	*section)
> > > +{
> > > +	unsigned int	i;
> > > +	struct confopts	*opts;
> > > +
> > > +	for (i=0; i < ARRAY_SIZE(confopts_tab); i++) {
> > > +		opts = &confopts_tab[i];
> > > +		if (!opts)
> > > +			return NULL;
> > > +		if (strcmp(opts->name, section) == 0) {
> > > +			if (opts->seen) {
> > > +				fprintf(stderr, _("Section '%s' respecified\n"),
> > > +						section);
> > 
> > If I have two [data] sections, will this resuilt in:
> > 
> > # mkfs.xfs -c foo /dev/sda1
> > Section 'data' respecified
> > Invalid section on line foo:1 [data]
> > 
> > ?
> 
> Yeah.
> 
> > The section isn't invalid, it's just double-specified, so...
> 
> I've fixed this, now we get:
> 
> ergon:~ # mkfs.xfs -f /dev/loop5 -c bar 
> Section 'metadata' respecified
> Error parsing command line config file: bar : Invalid argument

Ok, thanks!

> > > +				return NULL;
> > > +			}
> > > +			opts->seen = true;
> > > +			return opts;
> > > +		}
> > > +	}
> > 
> > ...I'd print the 'Invalid section' error message here.
> 
> Or move the respecification error message check to the switch
> statement handlig the section. I went with the later.
> 
> > > +static const char *conf_paths[] = {
> > > +	".",
> > > +	MKFS_XFS_CONF_DIR,
> > > +};
> > > +
> > > +/*
> > > + * If the file is not found -1 is returned and errno set. Otherwise
> > > + * the file descriptor is returned.
> > > + */
> > > +int
> > > +open_cli_config(
> > > +	char			*cli_config_file,
> > > +	char			**fpath)
> > > +{
> > > +	int			fd, len;
> > > +	char			*final_path = NULL;
> > > +	char			*relative_path= NULL;
> > > +	unsigned int		i;
> > > +
> > > +	if (strlen(cli_config_file) > 2) {
> > > +		if (cli_config_file[0] == '.' && cli_config_file[1] == '/')
> > > +			final_path = cli_config_file;
> > > +		else if (cli_config_file[0] == '.' && cli_config_file[1] == '.')
> > > +			final_path = cli_config_file;
> > > +		else if (cli_config_file[0] == '/')
> > > +			final_path = cli_config_file;
> > > +		else
> > > +			relative_path = cli_config_file;
> > > +	} else if (strlen(cli_config_file) == 1) {
> > > +		if (cli_config_file[0] == '.' || cli_config_file[0] == '/') {
> > > +			errno = EINVAL;
> > > +			return -1;
> > > +		} else
> > > +			relative_path = cli_config_file;
> > > +	}
> > > +
> > > +	if (final_path) {
> > > +		fd = open(final_path, O_RDONLY);
> > > +		if (fd >= 0)
> > > +			memcpy(*fpath, final_path, strlen(final_path));
> > > +		return fd;
> > > +	}
> > > +
> > > +	/* We finally know the path is relative but just to be sure */
> > > +	if (!relative_path) {
> > > +		errno = ENXIO;
> > > +		return -1;
> > > +	}
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(conf_paths); i++) {
> > > +		memset(*fpath, 0, PATH_MAX);
> > > +		/*
> > > +		 * For current directory evaluation, skip concatenating the
> > > +		 * ./ from the file passed. We only concatenate for the other
> > > +		 * paths we look up on.
> > 
> > If conf_paths[0] was "./" then you wouldn't have to special case this,
> > I think.
> 
> No, I had tried it, it looks odd still, if the user specified -c foo,
> the output should show ./foo, not just foo.

Ah.  Good point.

> > > +	fp = fdopen(fd, "r");
> > > +	if (!fp) {
> > > +		ret = errno;
> > > +		fprintf(stderr, _("Unable to open stream for config file: %s : %s\n"),
> > > +				fpath, strerror(errno));
> > 
> > perror(fpath); ?
> 
> Sure.
> 
> > Looks good otherwise.
> 
> Groovy. I'll wait for others to comment otherwise I can spin up 4th
> iteration after the weekend.

<nod>

--D

>   Luis

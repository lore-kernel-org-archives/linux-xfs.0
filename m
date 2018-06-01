Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48681 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750964AbeFAV42 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Jun 2018 17:56:28 -0400
Date: Fri, 1 Jun 2018 23:56:27 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v4 3/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180601215627.GT4511@wotan.suse.de>
References: <20180529220603.29420-1-mcgrof@kernel.org>
 <20180529220603.29420-4-mcgrof@kernel.org>
 <20180529233146.GM30110@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529233146.GM30110@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Tue, May 29, 2018 at 04:31:46PM -0700, Darrick J. Wong wrote:
> On Tue, May 29, 2018 at 03:06:02PM -0700, Luis R. Rodriguez wrote:
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
> 
> It occurred to me just now (sorry...) that the caller of this function
> prints out a string with strerror() contents, so the perror here is
> unnecessary 

Alright.

> since the caller will cough up an error anyway.  Then all of
> these constructions here become:
> 
> 	fp = fdopen(...);
> 	if (!fp)
> 		return -1;
> 
> 	ret = fstat(...);
> 	if (ret)
> 		goto out;
> 
> 	if (S_ISDIR(...)) {
> 		errno = EISDIR;
> 		goto out;
> 	}
> 	...
> 	return 0;
> out:
> 	return -1;

Sure.

> 
> and the call site now becomes:
> 
> if (parse_defaults_file(...)) {
> 	fprintf(stderr, "%s: file is bad: %s\n", path, strerror(errno));
> 	...
> }

Works with me.

> Granted maybe we should just merge this and do all those cleanups
> separately.

;)

> > +	if (S_ISDIR(sp.st_mode)) {
> > +		ret = EBADF;
> 
> ret = EISDIR?

Chinner asked we always make a regular file out of the config,
so now a regular file check will suffice, and EISDIR would not
be as descriptive.

So I'll wait to hear back on some other minor things, hopefully next
week we can wrap up this series for good.

-- 
Do not panic

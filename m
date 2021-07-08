Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5435C07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 22:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9562617ED
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 22:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGHWnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 18:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHWnk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jul 2021 18:43:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E726162B;
        Thu,  8 Jul 2021 22:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625784057;
        bh=XGu4F4ntWNLuZhg5LBs2SkaUthccfBFtNFmp80j/Iws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8hn1MghShHOp+xImbHsGF+fzWYS5ylRD3OWNLLpIWcXn3iGZ3bzba0PjPBzIBNZb
         abnnTt6YbIR8RpzDYxTAPKYWJBEdcgZJO3JuJfdz6IXe4qhK7lXRAQ4YqrMx/9/n1z
         O9ca4OGyDSvhOo7O383ThY42vlyDCojoO4HkQM3LAmLu/IWg+h64ipt94RBgx4hm1L
         GRD4deQNac/0feqCYAgX3fBtirFKtBYDT/vBEgp0I9jbMiK8p0EONKJGCugF8/EkMR
         D1dqthIixiEVm14w+WNW5SGKVnU/4Av71mmmtogBKctI0HGY9iwoUlTikXBSGEcyvl
         wUHqbpFoIc0kw==
Date:   Thu, 8 Jul 2021 15:40:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_io: allow callers to dump fs stats individually
Message-ID: <20210708224057.GK11588@locust>
References: <162528110197.38907.6647015481710886949.stgit@locust>
 <162528110744.38907.9770913472348824425.stgit@locust>
 <b85719a6-ffd0-dfcd-431d-12cf4987bcf7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b85719a6-ffd0-dfcd-431d-12cf4987bcf7@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 03:58:47PM -0500, Eric Sandeen wrote:
> On 7/2/21 9:58 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Enable callers to decide if they want to see statfs, fscounts, or
> > geometry information (or any combination) from the xfs_io statfs
> > command.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  io/stat.c         |  149 +++++++++++++++++++++++++++++++++++++++--------------
> >  man/man8/xfs_io.8 |   17 ++++++
> >  2 files changed, 127 insertions(+), 39 deletions(-)
> > 
> > 
> > diff --git a/io/stat.c b/io/stat.c
> > index 49c4c27c..1993247c 100644
> > --- a/io/stat.c
> > +++ b/io/stat.c
> > @@ -171,6 +171,26 @@ stat_f(
> >  	return 0;
> >  }
> >  
> > +static void
> > +statfs_help(void)
> > +{
> > +        printf(_(
> > +"\n"
> > +" Display file system status.\n"
> > +"\n"
> > +" Options:\n"
> > +" -a -- Print statfs, geometry, and fs summary count data.\n"
> > +" -c -- Print fs summary count data.\n"
> > +" -g -- Print fs geometry data.\n"
> > +" -s -- Print statfs data.\n"
> > +"\n"));
> > +}
> > +
> > +#define REPORT_STATFS		(1 << 0)
> > +#define REPORT_GEOMETRY		(1 << 1)
> > +#define REPORT_FSCOUNTS		(1 << 2)
> > +#define REPORT_DEFAULT		(1 << 31)
> > +
> >  static int
> >  statfs_f(
> >  	int			argc,
> > @@ -179,55 +199,102 @@ statfs_f(
> >  	struct xfs_fsop_counts	fscounts;
> >  	struct xfs_fsop_geom	fsgeo;
> >  	struct statfs		st;
> > +	unsigned int		flags = REPORT_DEFAULT;
> 
> Nitpicking this only because the patch will need to be resent anyway ;)
> Why not just "flags = 0" and "if !flags flags = ALL|THREE|FLAGS;" ?

Changed.

> (OTOH I don't really care, just wasn't sure about the need for it)
> 
> > +	int			c;
> >  	int			ret;
> >  
> > +	while ((c = getopt(argc, argv, "acgs")) != EOF) {
> > +		switch (c) {
> > +		case 'a':
> > +			flags = REPORT_STATFS | REPORT_GEOMETRY |
> > +				REPORT_FSCOUNTS;
> > +			break;
> > +		case 'c':
> > +			flags &= ~REPORT_DEFAULT;
> > +			flags |= REPORT_FSCOUNTS;
> > +			break;
> > +		case 'g':
> > +			flags &= ~REPORT_GEOMETRY;
> > +			flags |= REPORT_FSCOUNTS;
> 
> this looks ... wrong. ITYM:
> 
> +		case 'g':
> +			flags &= ~REPORT_DEFAULT;
> +			flags |= REPORT_GEOMETRY;
> 
> ?
> 
> > +			break;
> > +		case 's':
> > +			flags &= ~REPORT_STATFS;
> > +			flags |= REPORT_FSCOUNTS;
> 
> similar here

URkk, wow.  Fixed.

> 
> > +			break;
> > +		default:
> > +			exitcode = 1;
> > +			return command_usage(&statfs_cmd);
> > +		}
> > +	}
> > +
> > +	if (flags & REPORT_DEFAULT)
> > +		flags = REPORT_STATFS | REPORT_GEOMETRY | REPORT_FSCOUNTS;
> > +
> >  	printf(_("fd.path = \"%s\"\n"), file->name);
> > -	if (platform_fstatfs(file->fd, &st) < 0) {
> > -		perror("fstatfs");
> > -		exitcode = 1;
> > -	} else {
> > -		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
> > -		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
> > -		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
> > -		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
> > -		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
> > +	if (flags & REPORT_STATFS) {
> > +		ret = platform_fstatfs(file->fd, &st);
> > +		if (ret < 0) {
> > +			perror("fstatfs");
> > +			exitcode = 1;
> > +		} else {
> > +			printf(_("statfs.f_bsize = %lld\n"),
> > +					(long long) st.f_bsize);
> > +			printf(_("statfs.f_blocks = %lld\n"),
> > +					(long long) st.f_blocks);
> > +			printf(_("statfs.f_bavail = %lld\n"),
> > +					(long long) st.f_bavail);
> > +			printf(_("statfs.f_files = %lld\n"),
> > +					(long long) st.f_files);
> > +			printf(_("statfs.f_ffree = %lld\n"),
> > +					(long long) st.f_ffree);
> >  #ifdef HAVE_STATFS_FLAGS
> > -		printf(_("statfs.f_flags = 0x%llx\n"), (long long) st.f_flags);
> > +			printf(_("statfs.f_flags = 0x%llx\n"),
> > +					(long long) st.f_flags);
> >  #endif
> > +		}
> >  	}
> > +
> >  	if (file->flags & IO_FOREIGN)
> >  		return 0;
> > -	ret = -xfrog_geometry(file->fd, &fsgeo);
> > -	if (ret) {
> > -		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> > -		exitcode = 1;
> > -	} else {
> > -		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
> > -		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> > -		printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
> > -		printf(_("geom.datablocks = %llu\n"),
> > -			(unsigned long long) fsgeo.datablocks);
> > -		printf(_("geom.rtblocks = %llu\n"),
> > -			(unsigned long long) fsgeo.rtblocks);
> > -		printf(_("geom.rtextents = %llu\n"),
> > -			(unsigned long long) fsgeo.rtextents);
> > -		printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
> > -		printf(_("geom.sunit = %u\n"), fsgeo.sunit);
> > -		printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> > +
> > +	if (flags & REPORT_GEOMETRY) {
> > +		ret = -xfrog_geometry(file->fd, &fsgeo);
> > +		if (ret) {
> > +			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> > +			exitcode = 1;
> > +		} else {
> > +			printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
> > +			printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> > +			printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
> > +			printf(_("geom.datablocks = %llu\n"),
> > +				(unsigned long long) fsgeo.datablocks);
> > +			printf(_("geom.rtblocks = %llu\n"),
> > +				(unsigned long long) fsgeo.rtblocks);
> > +			printf(_("geom.rtextents = %llu\n"),
> > +				(unsigned long long) fsgeo.rtextents);
> > +			printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
> > +			printf(_("geom.sunit = %u\n"), fsgeo.sunit);
> > +			printf(_("geom.swidth = %u\n"), fsgeo.swidth);
> > +		}
> >  	}
> > -	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
> > -		perror("XFS_IOC_FSCOUNTS");
> > -		exitcode = 1;
> > -	} else {
> > -		printf(_("counts.freedata = %llu\n"),
> > -			(unsigned long long) fscounts.freedata);
> > -		printf(_("counts.freertx = %llu\n"),
> > -			(unsigned long long) fscounts.freertx);
> > -		printf(_("counts.freeino = %llu\n"),
> > -			(unsigned long long) fscounts.freeino);
> > -		printf(_("counts.allocino = %llu\n"),
> > -			(unsigned long long) fscounts.allocino);
> > +
> > +	if (flags & REPORT_FSCOUNTS) {
> > +		ret = ioctl(file->fd, XFS_IOC_FSCOUNTS, &fscounts);
> > +		if (ret < 0) {
> > +			perror("XFS_IOC_FSCOUNTS");
> > +			exitcode = 1;
> > +		} else {
> > +			printf(_("counts.freedata = %llu\n"),
> > +				(unsigned long long) fscounts.freedata);
> > +			printf(_("counts.freertx = %llu\n"),
> > +				(unsigned long long) fscounts.freertx);
> > +			printf(_("counts.freeino = %llu\n"),
> > +				(unsigned long long) fscounts.freeino);
> > +			printf(_("counts.allocino = %llu\n"),
> > +				(unsigned long long) fscounts.allocino);
> > +		}
> >  	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -407,9 +474,13 @@ stat_init(void)
> >  
> >  	statfs_cmd.name = "statfs";
> >  	statfs_cmd.cfunc = statfs_f;
> > +	statfs_cmd.argmin = 0;
> > +	statfs_cmd.argmax = -1;
> 
> Eh, I guess you can do "stats -a -a -a -c -c -c -s -a -a -c -c -c -g -g -g ...." and it works fine, so sure, "-1" ;)
> 
> > +	statfs_cmd.args = _("[-a] [-c] [-g] [-s]");
> >  	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> >  	statfs_cmd.oneline =
> >  		_("statistics on the filesystem of the currently open file");
> > +	statfs_cmd.help = statfs_help;
> >  
> >  	add_command(&stat_cmd);
> >  	add_command(&statx_cmd);
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index 1103dc42..32bdd866 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> 
> Probably want to turn this into:
> 
> statfs [-a] [-c] [-g] [-s]
> 	<description, probably updated to add XFS_IOC_FSCOUNTS to the list of $STUFF>
> 
> > @@ -1240,6 +1240,23 @@ Selected statistics from
> >  .BR statfs (2)
> >  and the XFS_IOC_FSGEOMETRY
> >  system call on the filesystem where the current file resides.
> > +.RS 1.0i
> > +.PD 0
> > +.TP
> > +.BI \-a
> > +Display statfs, geometry, and fs summary counter data.
> 
> Perhaps note that this is the default if no options are specified?

I'll change it to:

       statfs [ -c ] [ -g ] [ -s ]
              Report selected statistics on the filesystem  where  the
              current file resides.  The default behavior is to enable
              all three reporting options:
                 -c     Display  XFS_IOC_FSCOUNTERS  summary   counter
                        data.
                 -g     Display XFS_IOC_FSGEOMETRY filesystem geometry
                        data.
                 -s     Display statfs(2) data.

If that's ok.  I got rid of -a because it's redundant.

--D

> 
> > +.TP
> > +.BI \-c
> > +Display fs summary counter data.
> > +.TP
> > +.BI \-g
> > +Display geometry data.
> > +.TP
> > +.BI \-s
> > +Display statfs data.
> > +.TP
> > +.RE
> > +.PD
> >  .TP
> >  .BI "inode  [ [ -n ] " number " ] [ -v ]"
> >  The inode command queries physical information about an inode. With
> > 

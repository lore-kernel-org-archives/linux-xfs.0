Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6E7C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 06:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C96AA2224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 06:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgJOGJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 02:09:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45984 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbgJOGJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 02:09:06 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 012C258B994;
        Thu, 15 Oct 2020 17:09:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSwRj-000gvw-6J; Thu, 15 Oct 2020 17:09:03 +1100
Date:   Thu, 15 Oct 2020 17:09:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] mkfs: add initial ini format config file parsing
 support
Message-ID: <20201015060903.GF7391@dread.disaster.area>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015032925.1574739-3-david@fromorbit.com>
 <20201015054633.GS9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015054633.GS9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=T_JSNJb71W7BeGBo3IwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 10:46:33PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 15, 2020 at 02:29:22PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add the framework that will allow the config file to be supplied on
> > the CLI and passed to the library that will parse it. This does not
> > yet do any option parsing from the config file.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  mkfs/Makefile   |   2 +-
> >  mkfs/xfs_mkfs.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 115 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mkfs/Makefile b/mkfs/Makefile
> > index 31482b08d559..b8805f7e1ea1 100644
> > --- a/mkfs/Makefile
> > +++ b/mkfs/Makefile
> > @@ -11,7 +11,7 @@ HFILES =
> >  CFILES = proto.c xfs_mkfs.c
> >  
> >  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
> > -	$(LIBUUID)
> > +	$(LIBUUID) $(LIBINIH)
> >  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
> >  LLDFLAGS = -static-libtool-libs
> >  
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 8fe149d74b0a..e84be74fb100 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -11,6 +11,7 @@
> >  #include "libfrog/fsgeom.h"
> >  #include "libfrog/topology.h"
> >  #include "libfrog/convert.h"
> > +#include <ini.h>
> >  
> >  #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
> >  #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
> > @@ -44,6 +45,11 @@ enum {
> >  	B_MAX_OPTS,
> >  };
> >  
> > +enum {
> > +	C_OPTFILE = 0,
> > +	C_MAX_OPTS,
> > +};
> > +
> >  enum {
> >  	D_AGCOUNT = 0,
> >  	D_FILE,
> > @@ -237,6 +243,28 @@ static struct opt_params bopts = {
> >  	},
> >  };
> >  
> > +/*
> > + * Config file specification. Usage is:
> > + *
> > + * mkfs.xfs -c file=<name>
> 
> I thought it was -c options=/dev/random ?

I fixed that, refreshed the patch and updated the change log! How
the hell did I lose that change?

> >  	{ 'd', &dopts, data_opts_parser },
> >  	{ 'i', &iopts, inode_opts_parser },
> >  	{ 'l', &lopts, log_opts_parser },
> > @@ -3562,6 +3611,61 @@ check_root_ino(
> >  	}
> >  }
> >  
> > +/*
> > + * INI file format option parser.
> > + *
> > + * This is called by the file parser library for every valid option it finds in
> > + * the config file. The option is already broken down into a
> > + * {section,name,value} tuple, so all we need to do is feed it to the correct
> 
> XFS, SAX style.
> 
> > + * suboption parser function and translate the return value.
> > + *
> > + * Returns 0 on failure, 1 for success.
> > + */
> > +static int
> > +cfgfile_parse_ini(
> > +	void			*user,
> > +	const char		*section,
> > +	const char		*name,
> > +	const char		*value)
> > +{
> > +	struct cli_params	*cli = user;
> > +
> > +	fprintf(stderr, "Ini debug: file %s, section %s, name %s, value %s\n",
> > +		cli->cfgfile, section, name, value);
> > +
> > +	return 1;
> > +}
> > +
> > +void
> > +cfgfile_parse(
> > +	struct cli_params	*cli)
> > +{
> > +	int			error;
> > +
> > +	if (!cli->cfgfile)
> > +		return;
> > +
> > +	error = ini_parse(cli->cfgfile, cfgfile_parse_ini, cli);
> > +	if (error) {
> > +		if (error > 0) {
> > +			fprintf(stderr,
> > +		_("%s: Unrecognised input on line %d. Aborting.\n"),
> > +				cli->cfgfile, error);
> > +		} else if (error == -2) {
> > +			fprintf(stderr,
> > +		_("Memory allocation failure parsing %s. Aborting.\n"),
> > +				cli->cfgfile);
> > +		} else {
> > +			fprintf(stderr,
> > +		_("Unable to open config file %s. Aborting.\n"),
> > +				cli->cfgfile);
> 
> I worry about libinih someday defining more negative error codes.  -1 is
> "open failed", -2 is OOM, and positive is the line number of a parsing
> error, at least according to the documentation.
> 
> Maybe we should handle -1 specifically and use the else as a catchall
> for unrecognized error codes?

Makes sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

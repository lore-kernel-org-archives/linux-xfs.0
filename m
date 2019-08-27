Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB4FC3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 06:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6981E20828
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 06:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfH0GbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 02:31:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43244 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbfH0GbA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 02:31:00 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0038743CDA9;
        Tue, 27 Aug 2019 16:30:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2V0I-0003VR-Os; Tue, 27 Aug 2019 16:30:54 +1000
Date:   Tue, 27 Aug 2019 16:30:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] libfrog: refactor online geometry queries
Message-ID: <20190827063054.GA1119@dread.disaster.area>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633303850.1215733.18439177963581003053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633303850.1215733.18439177963581003053.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=lR75Ynq5BuUuQbJBLGoA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:30:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
> helper that we can use to standardize behaviors across mixed xfslibs
> versions.  This is the prelude to introducing a new FSGEOMETRY version
> in 5.2 and needing to fix the (relatively few) client programs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  Makefile            |    1 +
>  fsr/xfs_fsr.c       |   26 ++++----------------------

Ok.

>  growfs/xfs_growfs.c |   25 +++++++++----------------

Nit.

>  include/xfrog.h     |   22 ++++++++++++++++++++++

Copyright issue.

>  io/bmap.c           |    3 ++-
>  io/fsmap.c          |    3 ++-
>  io/open.c           |    3 ++-
>  io/stat.c           |    5 +++--

ok.

>  libfrog/fsgeom.c    |   18 ++++++++++++++++++

fallback question.

>  quota/free.c        |    6 +++---
>  repair/xfs_repair.c |    5 +++--
>  rtcp/Makefile       |    3 +++

Linker question

>  rtcp/xfs_rtcp.c     |    7 ++++---
>  scrub/phase1.c      |    5 +++--
>  spaceman/file.c     |    3 ++-
>  spaceman/info.c     |   27 +++++++++------------------

OK.


> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 20089d2b..86b1d542 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -7,6 +7,7 @@
>  #include "libxfs.h"
>  #include "path.h"
>  #include "fsgeom.h"
> +#include "xfrog.h"
>  
>  static void
>  usage(void)
> @@ -165,22 +166,14 @@ main(int argc, char **argv)
>  	}
>  
>  	/* get the current filesystem size & geometry */
> -	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY, &geo) < 0) {
> -		/*
> -		 * OK, new xfsctl barfed - back off and try earlier version
> -		 * as we're probably running an older kernel version.
> -		 * Only field added in the v2 geometry xfsctl is "logsunit"
> -		 * so we'll zero that out for later display (as zero).
> -		 */
> -		geo.logsunit = 0;
> -		if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &geo) < 0) {
> -			fprintf(stderr, _(
> -				"%s: cannot determine geometry of filesystem"
> -				" mounted at %s: %s\n"),
> -				progname, fname, strerror(errno));
> -			exit(1);
> -		}
> +	if (xfrog_geometry(ffd, &geo) < 0) {
> +		fprintf(stderr, _(
> +			"%s: cannot determine geometry of filesystem"
> +			" mounted at %s: %s\n"),
> +			progname, fname, strerror(errno));
> +		exit(1);

Can you run the format string into a single line?

> diff --git a/include/xfrog.h b/include/xfrog.h
> new file mode 100644
> index 00000000..5420b47c
> --- /dev/null
> +++ b/include/xfrog.h
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2002 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */

I don't think that copyright is valid/appropriate for a new header
file with new contents.

...

> @@ -67,3 +68,20 @@ xfs_report_geom(
>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents);
>  }
> +
> +/* Try to obtain the xfs geometry. */
> +int
> +xfrog_geometry(
> +	int			fd,
> +	struct xfs_fsop_geom	*fsgeo)
> +{
> +	int			ret;
> +
> +	memset(fsgeo, 0, sizeof(*fsgeo));
> +
> +	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, fsgeo);
> +	if (!ret)
> +		return 0;
> +
> +	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
> +}

Should this fall back to XFS_IOC_FSGEOMETRY_V4, then V1 if that
fails (which it shouldn't on any supported kernel)?


> diff --git a/rtcp/Makefile b/rtcp/Makefile
> index 808b5378..264b4f27 100644
> --- a/rtcp/Makefile
> +++ b/rtcp/Makefile
> @@ -9,6 +9,9 @@ LTCOMMAND = xfs_rtcp
>  CFILES = xfs_rtcp.c
>  LLDFLAGS = -static
>  
> +LLDLIBS = $(LIBFROG)
> +LTDEPENDENCIES = $(LIBFROG)

Does this work correctly given LLDFLAGS sets -static and not
-libtools-static-libs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

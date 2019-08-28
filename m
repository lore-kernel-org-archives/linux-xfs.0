Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE63BC3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 17:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8CF62064A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 17:09:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BAMsMfut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfH1RJN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 13:09:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1RJN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 13:09:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SH99uL057902;
        Wed, 28 Aug 2019 17:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=TfVOFWrEOqZftzU0V5aX0Ce9a/GjZ89Qr2jaK8UKSO8=;
 b=BAMsMfutxa4fWAJ8II5hnr5gNGV67qc5+pe+fldy/4cMkKaBAu6Ye9mm86qGheoRCnmG
 6IdO22mNMHxXqrLX53UTj2zLLZhicbzE8KDJKpLqNwL+O6Eos/tHpVa5Xj78pbwFWda7
 z4EFBjSTJraE5EHCtT1rWgHxjuvgq+A9zY6fSB/0LQvpRGUEQJCFo4VubqQ6JLzpwoFY
 BUqVE7L83J3u2+M5nP40Z2JSOyLElAhvhbeqLfHwnIV5R4Z+9+jS23suqbGga7Sm2E6T
 Dynq3iuG7Dcp+qagXI2pezeZGEAhxv+hHHwALM0Sm9zzNtexXdq9ge3v3IocyYbIAcuu lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2unvvurdmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 17:09:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SH7wXD095833;
        Wed, 28 Aug 2019 17:09:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2unduq6qv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 17:09:01 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SH90WI025229;
        Wed, 28 Aug 2019 17:09:00 GMT
Received: from localhost (/10.159.146.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 10:08:59 -0700
Date:   Wed, 28 Aug 2019 10:08:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] libfrog: refactor online geometry queries
Message-ID: <20190828170858.GE1037350@magnolia>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633303850.1215733.18439177963581003053.stgit@magnolia>
 <20190827063054.GA1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827063054.GA1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 04:30:54PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:30:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
> > helper that we can use to standardize behaviors across mixed xfslibs
> > versions.  This is the prelude to introducing a new FSGEOMETRY version
> > in 5.2 and needing to fix the (relatively few) client programs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  Makefile            |    1 +
> >  fsr/xfs_fsr.c       |   26 ++++----------------------
> 
> Ok.
> 
> >  growfs/xfs_growfs.c |   25 +++++++++----------------
> 
> Nit.
> 
> >  include/xfrog.h     |   22 ++++++++++++++++++++++
> 
> Copyright issue.
> 
> >  io/bmap.c           |    3 ++-
> >  io/fsmap.c          |    3 ++-
> >  io/open.c           |    3 ++-
> >  io/stat.c           |    5 +++--
> 
> ok.
> 
> >  libfrog/fsgeom.c    |   18 ++++++++++++++++++
> 
> fallback question.
> 
> >  quota/free.c        |    6 +++---
> >  repair/xfs_repair.c |    5 +++--
> >  rtcp/Makefile       |    3 +++
> 
> Linker question
> 
> >  rtcp/xfs_rtcp.c     |    7 ++++---
> >  scrub/phase1.c      |    5 +++--
> >  spaceman/file.c     |    3 ++-
> >  spaceman/info.c     |   27 +++++++++------------------
> 
> OK.
> 
> 
> > diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> > index 20089d2b..86b1d542 100644
> > --- a/growfs/xfs_growfs.c
> > +++ b/growfs/xfs_growfs.c
> > @@ -7,6 +7,7 @@
> >  #include "libxfs.h"
> >  #include "path.h"
> >  #include "fsgeom.h"
> > +#include "xfrog.h"
> >  
> >  static void
> >  usage(void)
> > @@ -165,22 +166,14 @@ main(int argc, char **argv)
> >  	}
> >  
> >  	/* get the current filesystem size & geometry */
> > -	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY, &geo) < 0) {
> > -		/*
> > -		 * OK, new xfsctl barfed - back off and try earlier version
> > -		 * as we're probably running an older kernel version.
> > -		 * Only field added in the v2 geometry xfsctl is "logsunit"
> > -		 * so we'll zero that out for later display (as zero).
> > -		 */
> > -		geo.logsunit = 0;
> > -		if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &geo) < 0) {
> > -			fprintf(stderr, _(
> > -				"%s: cannot determine geometry of filesystem"
> > -				" mounted at %s: %s\n"),
> > -				progname, fname, strerror(errno));
> > -			exit(1);
> > -		}
> > +	if (xfrog_geometry(ffd, &geo) < 0) {
> > +		fprintf(stderr, _(
> > +			"%s: cannot determine geometry of filesystem"
> > +			" mounted at %s: %s\n"),
> > +			progname, fname, strerror(errno));
> > +		exit(1);
> 
> Can you run the format string into a single line?

ok.

> > diff --git a/include/xfrog.h b/include/xfrog.h
> > new file mode 100644
> > index 00000000..5420b47c
> > --- /dev/null
> > +++ b/include/xfrog.h
> > @@ -0,0 +1,22 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2000-2002 Silicon Graphics, Inc.
> > + * All Rights Reserved.
> > + */
> 
> I don't think that copyright is valid/appropriate for a new header
> file with new contents.

Hrmmm ok I'll uhh fix it.

> ...
> 
> > @@ -67,3 +68,20 @@ xfs_report_geom(
> >  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
> >  			(unsigned long long)geo->rtextents);
> >  }
> > +
> > +/* Try to obtain the xfs geometry. */
> > +int
> > +xfrog_geometry(
> > +	int			fd,
> > +	struct xfs_fsop_geom	*fsgeo)
> > +{
> > +	int			ret;
> > +
> > +	memset(fsgeo, 0, sizeof(*fsgeo));
> > +
> > +	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, fsgeo);
> > +	if (!ret)
> > +		return 0;
> > +
> > +	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
> > +}
> 
> Should this fall back to XFS_IOC_FSGEOMETRY_V4, then V1 if that
> fails (which it shouldn't on any supported kernel)?

It should; there's a patch in the next series to do that, but I might as
well merge them (this series was originally targeting 5.1).

> 
> > diff --git a/rtcp/Makefile b/rtcp/Makefile
> > index 808b5378..264b4f27 100644
> > --- a/rtcp/Makefile
> > +++ b/rtcp/Makefile
> > @@ -9,6 +9,9 @@ LTCOMMAND = xfs_rtcp
> >  CFILES = xfs_rtcp.c
> >  LLDFLAGS = -static
> >  
> > +LLDLIBS = $(LIBFROG)
> > +LTDEPENDENCIES = $(LIBFROG)
> 
> Does this work correctly given LLDFLAGS sets -static and not
> -libtools-static-libs?

It seems to, at least on Ubuntu 18.04.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

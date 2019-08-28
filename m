Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB41EC3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 17:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F70E22DA7
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 17:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBsF2KK2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfH1RQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 13:16:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1RQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 13:16:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SHEuVS062418;
        Wed, 28 Aug 2019 17:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=cjB4gZOYPDuWsTel+mY7HWahbDyMDiMXhigaJpPR84w=;
 b=EBsF2KK2uhU2k75mQN981xKz++f7GNcCGKhhIXU4zkeRpw9MR2eJ7LdKOrnZsMoCgIzl
 rvSphfP5edUA/OYKIUh5Sbg2EnHrbtrb6eEFbUdrVPdhJJKE/24uZiLDVhjE+8mwNxcr
 f3lQO+PqBoEQND41NPJvMXh3rLzV8x36GKD+cyhj6xzOGQCnPHhwmyUhvDPt6TQSHjDY
 viGcJHx2NQ5kZCfbAfcKuvFBNzy2BGcrvA8F7cBHqVG9Ax9TncAoqAtbcgUjRG56jVTJ
 oCC7Z3fjjlAQTAyH2ujcWBxaciDMH+s6h3g5xO45PJC/dD52tB3nPMYzFQpTyRrm2aMT /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2unwuf004k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 17:15:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SHDfqO109347;
        Wed, 28 Aug 2019 17:15:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2unduq6xjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 17:15:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SHFtCX029945;
        Wed, 28 Aug 2019 17:15:55 GMT
Received: from localhost (/10.159.146.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 10:15:54 -0700
Date:   Wed, 28 Aug 2019 10:15:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] libfrog: introduce xfs_fd to wrap an fd to a file on
 an xfs filesystem
Message-ID: <20190828171553.GF1037350@magnolia>
References: <156633303230.1215733.4447734852671168748.stgit@magnolia>
 <156633304473.1215733.8975368605160374407.stgit@magnolia>
 <20190827064157.GB1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827064157.GB1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 04:41:57PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:30:44PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Introduce a new "xfs_fd" context structure where we can store a file
> > descriptor and all the runtime fs context (geometry, which ioctls work,
> > etc.) that goes with it.  We're going to create wrappers for the
> > bulkstat and inumbers ioctls in subsequent patches; and when we
> > introduce the v5 bulkstat/inumbers ioctls we'll need all that context to
> > downgrade gracefully on old kernels.  Start the transition by adopting
> > xfs_fd natively in scrub.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/xfrog.h    |   20 ++++++++++++++++++++
> 
> naming.
> 
> >  libfrog/fsgeom.c   |   25 +++++++++++++++++++++++++
> >  scrub/fscounters.c |   22 ++++++++++++----------
> >  scrub/inodes.c     |   10 +++++-----
> >  scrub/phase1.c     |   41 ++++++++++++++++++++---------------------
> >  scrub/phase2.c     |    2 +-
> >  scrub/phase3.c     |    4 ++--
> >  scrub/phase4.c     |    8 ++++----
> >  scrub/phase5.c     |    2 +-
> >  scrub/phase6.c     |    6 +++---
> >  scrub/phase7.c     |    2 +-
> >  scrub/repair.c     |    4 ++--
> >  scrub/scrub.c      |   12 ++++++------
> >  scrub/spacemap.c   |   12 ++++++------
> >  scrub/vfs.c        |    2 +-
> >  scrub/xfs_scrub.h  |    7 ++++---
> >  16 files changed, 113 insertions(+), 66 deletions(-)
> > 
> > 
> > diff --git a/include/xfrog.h b/include/xfrog.h
> > index 5420b47c..f3808911 100644
> > --- a/include/xfrog.h
> > +++ b/include/xfrog.h
> > @@ -19,4 +19,24 @@
> >  struct xfs_fsop_geom;
> >  int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
> >  
> > +/*
> > + * Structure for recording whatever observations we want about the level of
> > + * xfs runtime support for this fd.  Right now we only store the fd and fs
> > + * geometry.
> > + */
> > +struct xfs_fd {
> > +	/* ioctl file descriptor */
> > +	int			fd;
> > +
> > +	/* filesystem geometry */
> > +	struct xfs_fsop_geom	fsgeom;
> > +};
> > +
> > +/* Static initializers */
> > +#define XFS_FD_INIT(_fd)	{ .fd = (_fd), }
> > +#define XFS_FD_INIT_EMPTY	XFS_FD_INIT(-1)
> > +
> > +int xfrog_prepare_geometry(struct xfs_fd *xfd);
> > +int xfrog_close(struct xfs_fd *xfd);
> 
> I'd much prefer to see these named xfd_prepare_geometry() and
> xfd_close()...

Done.

> >  	ci = calloc(1, sizeof(struct xfs_count_inodes) +
> > -			(ctx->geo.agcount * sizeof(uint64_t)));
> > +			(ctx->mnt.fsgeom.agcount * sizeof(uint64_t)));
> 
> This gets a bit verbose, but.... <shrug> .... doesn't make that much
> of a mess...
> 
> Ok, apart from the naming thing, this looks ok.

Ok.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

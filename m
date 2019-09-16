Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F77EC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 22:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14B2206C2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 22:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VjACsyG2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfIPWEJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 18:04:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37190 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730425AbfIPWEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 18:04:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GLxDkO070982;
        Mon, 16 Sep 2019 22:04:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FhqDg/8q5m1eK44UFs39k5vGeU1UHgnOuLPtlkUNn2M=;
 b=VjACsyG2Agsg3bPkwxXYWHBk7WoAXsPSFtz2qEld6P9GqlJEyfFlzUXUVEiE4aWPnZ03
 Hpf780IHlwb9/8ASfWaI+kDYZvHJI8ugjH7E6EHIsjp+R1jBUtCQ5BBOyidIUqJ3ngv6
 bubZFUIllPhfbay1I2AyImXTvW09ysXz2j/c8v/eEb9YS4Bw4sfCrBC+F5pXM/Q5pmoz
 vzOPRNCpglDdk95Dv9DsJF/FfyhuDwfcL8Tf49jegWCl4l2bc1GNfrO8mOMhcAPPs5/L
 fyiObz4tGdG7RAKmGufaEDNbKsa2ExCqJYTn7Ig9zo1rXhoSsoCkOYaCH5YWsZwrYAB0 Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v2bx2tgts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 22:04:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GM40Eu083671;
        Mon, 16 Sep 2019 22:04:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v0nb5f7ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 22:04:02 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8GM2rQE011611;
        Mon, 16 Sep 2019 22:02:54 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 15:02:53 -0700
Date:   Mon, 16 Sep 2019 15:02:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] misc: convert to v5 bulkstat_single call
Message-ID: <20190916220249.GP2229799@magnolia>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774092210.2643497.7118033849671297049.stgit@magnolia>
 <20190913010237.GW16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913010237.GW16973@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160209
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 13, 2019 at 11:02:37AM +1000, Dave Chinner wrote:
> On Thu, Sep 05, 2019 at 08:35:22PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  spaceman/health.c  |    4 +-
> >  7 files changed, 105 insertions(+), 32 deletions(-)
> > 
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index cc3cc93a..e8fa39ab 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -724,6 +724,7 @@ fsrfile(
> >  	xfs_ino_t		ino)
> >  {
> >  	struct xfs_fd		fsxfd = XFS_FD_INIT_EMPTY;
> > +	struct xfs_bulkstat	bulkstat;
> >  	struct xfs_bstat	statbuf;
> >  	jdm_fshandle_t		*fshandlep;
> >  	int			fd = -1;
> > @@ -748,12 +749,13 @@ fsrfile(
> >  		goto out;
> >  	}
> >  
> > -	error = xfrog_bulkstat_single(&fsxfd, ino, &statbuf);
> > +	error = xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
> >  	if (error) {
> >  		fsrprintf(_("unable to get bstat on %s: %s\n"),
> >  			fname, strerror(error));
> >  		goto out;
> >  	}
> > +	xfrog_bulkstat_to_bstat(&fsxfd, &statbuf, &bulkstat);
> 
> So this is so none of the rest of fsr needs to be converted to use
> the new structure versions? When will this go away?
> 
> >  	do {
> > -		struct xfs_bstat tbstat;
> > +		struct xfs_bulkstat	tbstat;
> >  		char		name[64];
> >  		int		ret;
> >  
> > @@ -983,7 +985,7 @@ fsr_setup_attr_fork(
> >  		 * this to compare against the target and determine what we
> >  		 * need to do.
> >  		 */
> > -		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, &tbstat);
> > +		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0, &tbstat);
> >  		if (ret) {
> >  			fsrprintf(_("unable to get bstat on temp file: %s\n"),
> >  						strerror(ret));
> 
> Because this looks like we now have a combination of v1 and v5
> structures being used...
> 
> >  
> > diff --git a/io/swapext.c b/io/swapext.c
> > index 2b4918f8..ca024b93 100644
> > --- a/io/swapext.c
> > +++ b/io/swapext.c
> > @@ -28,6 +28,7 @@ swapext_f(
> >  	char			**argv)
> >  {
> >  	struct xfs_fd		fxfd = XFS_FD_INIT(file->fd);
> > +	struct xfs_bulkstat	bulkstat;
> >  	int			fd;
> >  	int			error;
> >  	struct xfs_swapext	sx;
> > @@ -48,12 +49,13 @@ swapext_f(
> >  		goto out;
> >  	}
> >  
> > -	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, &sx.sx_stat);
> > +	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
> >  	if (error) {
> >  		errno = error;
> >  		perror("bulkstat");
> >  		goto out;
> >  	}
> > +	xfrog_bulkstat_to_bstat(&fxfd, &sx.sx_stat, &bulkstat);
> 
> and this is required because bstat is part of the swapext ioctl ABI?

Yes.  I think a lof of the retained bulkstat weirdness in fsr could go
away if (a) we maintained an open xfs_fd to the filesystem and (b)
wrapped the swapext ioctl... but there's already too much here so I
stopped short of refactoring fsr.

> >  	sx.sx_version = XFS_SX_VERSION;
> >  	sx.sx_fdtarget = file->fd;
> >  	sx.sx_fdtmp = fd;
> > diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> > index b4468243..2a70824e 100644
> > --- a/libfrog/bulkstat.c
> > +++ b/libfrog/bulkstat.c
> > @@ -20,26 +20,99 @@ xfrog_bulkstat_prep_v1_emulation(
> >  	return xfd_prepare_geometry(xfd);
> >  }
> >  
> > +/* Bulkstat a single inode using v5 ioctl. */
> > +static int
> > +xfrog_bulkstat_single5(
> > +	struct xfs_fd			*xfd,
> > +	uint64_t			ino,
> > +	unsigned int			flags,
> > +	struct xfs_bulkstat		*bulkstat)
> > +{
> > +	struct xfs_bulkstat_req		*req;
> > +	int				ret;
> > +
> > +	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
> > +		return EINVAL;
> 
> negative error returns, please.
> 
> > @@ -57,8 +57,6 @@ xfs_iterate_inodes_range_check(
> >  	int			error;
> >  
> >  	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
> > -		struct xfs_bstat bs1;
> > -
> >  		if (!(inogrp->xi_allocmask & (1ULL << i)))
> >  			continue;
> >  		if (bs->bs_ino == inogrp->xi_startino + i) {
> > @@ -68,13 +66,11 @@ xfs_iterate_inodes_range_check(
> >  
> >  		/* Load the one inode. */
> >  		error = xfrog_bulkstat_single(&ctx->mnt,
> > -				inogrp->xi_startino + i, &bs1);
> > -		if (error || bs1.bs_ino != inogrp->xi_startino + i) {
> > +				inogrp->xi_startino + i, 0, bs);
> > +		if (error || bs->bs_ino != inogrp->xi_startino + i) {
> >  			memset(bs, 0, sizeof(struct xfs_bulkstat));
> >  			bs->bs_ino = inogrp->xi_startino + i;
> >  			bs->bs_blksize = ctx->mnt_sv.f_frsize;
> > -		} else {
> > -			xfrog_bstat_to_bulkstat(&ctx->mnt, bs, &bs1);
> >  		}
> >  		bs++;
> >  	}
> 
> So this immediately tears down the confusing stuff that was set up
> in the previous patch. Perhaps separate out the scrub changes and do
> both bulkstat and bulkstat_single conversions in one patch?

Ok.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com

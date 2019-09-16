Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5BEC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 22:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D805D206C2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 22:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ugt6/fAx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbfIPWFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 18:05:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732642AbfIPWFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 18:05:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GM4QQ2058433;
        Mon, 16 Sep 2019 22:05:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FSjJz5RHqGN78rwX3/MzdDOvfjJE+SIvXahEid8+l4M=;
 b=Ugt6/fAxDEkWiINsWCZ2ali2MScC/SyNZK2GsQCdED1lNNimQmlHY0APB7z5JgclAa4k
 UUD5m4eCQNdz/SgnEYxZOPZuz+30/XN+R/B9JEhTHlzQGrhcyegD1BdI4ufs2ALXWKXd
 44WEdqQI1Mg2r+VnOSL746mHjfRYnmDd6ia0SDhkWLEfVho1Bzx9GVMlHBOpF1r5EM6x
 CE+x5WEIUVd2To534xh8Nkjtmx+KkVXXTYjfuopdlMw5EfXxyD3I34/zQCku1t2NNaZ9
 lHvxyIDHF8DHT6jVDD+L7iGDsrYB+lFlgdtaYBbFMlR7P6U4QqAf6ECZGRnWD2UDefMJ 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v0ruqj975-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 22:05:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GM2pSt195038;
        Mon, 16 Sep 2019 22:05:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v2jjs8hqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 22:05:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GM5OYV032604;
        Mon, 16 Sep 2019 22:05:24 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 15:05:24 -0700
Date:   Mon, 16 Sep 2019 15:05:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] misc: convert from XFS_IOC_FSINUMBERS to
 XFS_IOC_INUMBERS
Message-ID: <20190916220523.GQ2229799@magnolia>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774092832.2643497.11735239040494298471.stgit@magnolia>
 <20190913011036.GX16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913011036.GX16973@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 13, 2019 at 11:10:36AM +1000, Dave Chinner wrote:
> On Thu, Sep 05, 2019 at 08:35:28PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert all programs to use the v5 inumbers ioctl.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  io/imap.c          |   26 +++++-----
> >  io/open.c          |   27 +++++++----
> >  libfrog/bulkstat.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++------
> >  libfrog/bulkstat.h |   10 +++-
> >  scrub/fscounters.c |   21 +++++---
> >  scrub/inodes.c     |   36 ++++++++------
> >  6 files changed, 189 insertions(+), 63 deletions(-)
> 
> ....
> > diff --git a/io/open.c b/io/open.c
> > index e1979501..e198bcd8 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -681,39 +681,46 @@ static __u64
> >  get_last_inode(void)
> >  {
> >  	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> > -	uint64_t		lastip = 0;
> > +	struct xfs_inumbers_req	*ireq;
> >  	uint32_t		lastgrp = 0;
> > -	uint32_t		ocount = 0;
> >  	__u64			last_ino;
> 
> 	__u64			last_ino = 0;
> 
> > -	struct xfs_inogrp	igroup[IGROUP_NR];
> > +
> > +	ireq = xfrog_inumbers_alloc_req(IGROUP_NR, 0);
> > +	if (!ireq) {
> > +		perror("alloc req");
> > +		return 0;
> > +	}
> >  
> >  	for (;;) {
> >  		int		ret;
> >  
> > -		ret = xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
> > -				&ocount);
> > +		ret = xfrog_inumbers(&xfd, ireq);
> >  		if (ret) {
> >  			errno = ret;
> >  			perror("XFS_IOC_FSINUMBERS");
> > +			free(ireq);
> >  			return 0;
> 
> 			goto out;
> >  		}
> >  
> >  		/* Did we reach the last inode? */
> > -		if (ocount == 0)
> > +		if (ireq->hdr.ocount == 0)
> >  			break;
> >  
> >  		/* last inode in igroup table */
> > -		lastgrp = ocount;
> > +		lastgrp = ireq->hdr.ocount;
> >  	}
> >  
> > -	if (lastgrp == 0)
> > +	if (lastgrp == 0) {
> > +		free(ireq);
> >  		return 0;
> 
> 		goto out;
> > +	}
> >  
> >  	lastgrp--;
> >  
> >  	/* The last inode number in use */
> > -	last_ino = igroup[lastgrp].xi_startino +
> > -		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
> > +	last_ino = ireq->inumbers[lastgrp].xi_startino +
> > +		  libxfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);
> 
> out:

Ok, fixed.

> > +	free(ireq);
> >  
> >  	return last_ino;
> >  }
> > diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> > index 2a70824e..748d0f32 100644
> > --- a/libfrog/bulkstat.c
> > +++ b/libfrog/bulkstat.c
> > @@ -387,6 +387,86 @@ xfrog_bulkstat_alloc_req(
> >  	return breq;
> >  }
> >  
> > +/* Convert an inumbers (v5) struct to a inogrp (v1) struct. */
> > +void
> > +xfrog_inumbers_to_inogrp(
> > +	struct xfs_inogrp		*ig1,
> > +	const struct xfs_inumbers	*ig)
> > +{
> > +	ig1->xi_startino = ig->xi_startino;
> > +	ig1->xi_alloccount = ig->xi_alloccount;
> > +	ig1->xi_allocmask = ig->xi_allocmask;
> 
> Same thing - inumbers_v5_to_v1(from, to);
> 
> > +}
> > +
> > +/* Convert an inogrp (v1) struct to a inumbers (v5) struct. */
> > +void
> > +xfrog_inogrp_to_inumbers(
> > +	struct xfs_inumbers		*ig,
> > +	const struct xfs_inogrp		*ig1)
> 
> ditto.

Fixed too.

> > +{
> > +	memset(ig, 0, sizeof(*ig));
> > +	ig->xi_version = XFS_INUMBERS_VERSION_V1;
> > +
> > +	ig->xi_startino = ig1->xi_startino;
> > +	ig->xi_alloccount = ig1->xi_alloccount;
> > +	ig->xi_allocmask = ig1->xi_allocmask;
> > +}
> > +
> > +static uint64_t xfrog_inum_ino(void *v1_rec)
> > +{
> > +	return ((struct xfs_inogrp *)v1_rec)->xi_startino;
> > +}
> > +
> > +static void xfrog_inum_cvt(struct xfs_fd *xfd, void *v5, void *v1)
> > +{
> > +	xfrog_inogrp_to_inumbers(v5, v1);
> > +}
> 
> what's the point of this wrapper?

Function adapter so we can use xfrog_bulk_req_teardown as part of using
the V1 inumbers ioctl to emulate the V5 inumbers ioctl.

> > +
> > +/* Query inode allocation bitmask information using v5 ioctl. */
> > +static int
> > +xfrog_inumbers5(
> > +	struct xfs_fd		*xfd,
> > +	struct xfs_inumbers_req	*req)
> > +{
> > +	int			ret;
> > +
> > +	ret = ioctl(xfd->fd, XFS_IOC_INUMBERS, req);
> > +	if (ret)
> > +		return errno;
> > +	return 0;
> 
> negative errors.
> 
> > +}
> > +
> > +/* Query inode allocation bitmask information using v1 ioctl. */
> > +static int
> > +xfrog_inumbers1(
> > +	struct xfs_fd		*xfd,
> > +	struct xfs_inumbers_req	*req)
> > +{
> > +	struct xfs_fsop_bulkreq	bulkreq = { 0 };
> > +	int			error;
> > +
> > +	error = xfrog_bulkstat_prep_v1_emulation(xfd);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfrog_bulk_req_setup(xfd, &req->hdr, &bulkreq,
> > +			sizeof(struct xfs_inogrp));
> > +	if (error == ECANCELED)
> > +		goto out_teardown;
> > +	if (error)
> > +		return error;
> > +
> > +	error = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
> > +	if (error)
> > +		error = errno;
> 
> negative errors.
> 
> > +
> > +out_teardown:
> > +	return xfrog_bulk_req_teardown(xfd, &req->hdr, &bulkreq,
> > +			sizeof(struct xfs_inogrp), xfrog_inum_ino,
> > +			&req->inumbers, sizeof(struct xfs_inumbers),
> > +			xfrog_inum_cvt, 64, error);
> > +}
> ....
> 
> >  	struct xfs_bulkstat	*bs;
> > -	uint64_t		igrp_ino;
> > -	uint32_t		igrplen = 0;
> > +	struct xfs_inumbers	*inogrp;
> 
> Isn't that mixing v1 structure names with v5 operations? Aren't we
> pulling infomration out in inode records?

Yeah, I'll fix the names too.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

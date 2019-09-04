Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB5CC3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 14:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B00D208E4
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 14:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="csEM7PqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfIDOvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 10:51:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730067AbfIDOvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 10:51:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84Emnjn187705;
        Wed, 4 Sep 2019 14:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=H+ZKVhHX0FPa+ZhrP2F5KoNBH0Blfl4rbVrA14/nNOU=;
 b=csEM7PqWGUfVsnBdygOuJ4ao07YrF0LZz6Ov9++SQ/eNkEiA0u/aI6PCrn3WIUCazIk5
 tCuuYs4T73KiiNoyI/ZwQBLgtxJ8LMKPvdIUg5i+XrQHSxpq+JCNPd6NaNNOeGiqFfuW
 dNvJNrgu8k9ZXDWHIEZoV9lqkS/P49c+fXb6qWQTWeUwjzORcl5fDOYEuYLJLOOzvgXp
 JRWgl3zcOp1Pz1J1b6xkj/lAFtxdpAq1r4v2UxQsFCH1vWtJ2xjiOYMT8JjzOHahsrwC
 MnIZGZPmyB+7JgfYMdgym4xmT3gCWBhukJVeJYwC0UbeqeLUd2KDCDsV6aZKcGDpAndN gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2utf01r6m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 14:51:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84EnAQZ068592;
        Wed, 4 Sep 2019 14:51:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2utepg1gjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 14:51:27 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x84EpQr2021113;
        Wed, 4 Sep 2019 14:51:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 07:51:26 -0700
Date:   Wed, 4 Sep 2019 07:51:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_spaceman: report health problems
Message-ID: <20190904145125.GB5354@magnolia>
References: <156685444816.2839912.12432359726352663923.stgit@magnolia>
 <156685445446.2839912.426160608673674011.stgit@magnolia>
 <20190904045240.GB1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904045240.GB1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 02:52:40PM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2019 at 02:20:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the fs and ag geometry ioctls to report health problems to users.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/xfrog.h         |    2 
> >  libfrog/fsgeom.c        |   11 +
> >  man/man8/xfs_spaceman.8 |   28 +++
> >  spaceman/Makefile       |    2 
> >  spaceman/health.c       |  432 +++++++++++++++++++++++++++++++++++++++++++++++
> >  spaceman/init.c         |    1 
> >  spaceman/space.h        |    1 
> >  7 files changed, 476 insertions(+), 1 deletion(-)
> >  create mode 100644 spaceman/health.c
> > 
> > 
> > diff --git a/include/xfrog.h b/include/xfrog.h
> > index 5748e967..3a43a403 100644
> > --- a/include/xfrog.h
> > +++ b/include/xfrog.h
> > @@ -177,4 +177,6 @@ struct xfs_inogrp;
> >  int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
> >  		struct xfs_inogrp *ubuffer, uint32_t *ocount);
> >  
> > +int xfrog_ag_geometry(int fd, unsigned int agno, struct xfs_ag_geometry *ageo);
> > +
> >  #endif	/* __XFROG_H__ */
> > diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> > index 17479e4a..cddb5a39 100644
> > --- a/libfrog/fsgeom.c
> > +++ b/libfrog/fsgeom.c
> > @@ -131,3 +131,14 @@ xfrog_close(
> >  	xfd->fd = -1;
> >  	return ret;
> >  }
> > +
> > +/* Try to obtain an AG's geometry. */
> > +int
> > +xfrog_ag_geometry(
> > +	int			fd,
> > +	unsigned int		agno,
> > +	struct xfs_ag_geometry	*ageo)
> > +{
> > +	ageo->ag_number = agno;
> > +	return ioctl(fd, XFS_IOC_AG_GEOMETRY, ageo);
> 
> Does it need this first:
> 
> 	memset(ageo, 0, sizeof(*ageo));
> 
> Because I don't think the callers zero it....

Yep, and the caller was fixed up when I, er, twiddled the AG geometry
ioctl definition last week.

> > +static const struct flag_map inode_flags[] = {
> > +	{
> > +		.mask = XFS_BS_SICK_INODE,
> > +		.descr = "inode core",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_BMBTD,
> > +		.descr = "data fork",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_BMBTA,
> > +		.descr = "extended attribute fork",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_BMBTC,
> > +		.descr = "copy on write fork",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_DIR,
> > +		.descr = "directory",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_XATTR,
> > +		.descr = "extended attributes",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_SYMLINK,
> > +		.descr = "symbolic link target",
> > +	},
> > +	{
> > +		.mask = XFS_BS_SICK_PARENT,
> > +		.descr = "parent pointers",
> 
> This needs a "has_parent_pointers" feature check function,
> doesn't it? Or is this already a valid status for directory inodes?

It's already a valid status for directories, since xscrub checks that
a directory's '..' points to another valid directory that points back.

> > +static int
> > +report_bulkstat_health(
> > +	xfs_agnumber_t		agno)
> > +{
> > +	struct xfs_bstat	bstat[128];
> > +	char			descr[256];
> > +	uint64_t		startino = 0;
> > +	uint64_t		lastino = -1ULL;
> > +	uint32_t		ocount;
> > +	uint32_t		i;
> > +	int			error;
> > +
> > +	if (agno != NULLAGNUMBER) {
> > +		startino = xfrog_agino_to_ino(&file->xfd, agno, 0);
> > +		lastino = xfrog_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
> > +	}
> > +
> > +	while ((error = xfrog_bulkstat(&file->xfd, &startino, 128, bstat,
> 
> Nit: use a define for the number of inodes to bulkstat.

Ok.  IIRC the xfrog_bulkstat conversion later on will zap most of this.

> > +health_f(
> > +	int			argc,
> > +	char			**argv)
> > +{
> > +	unsigned long long	x;
> > +	xfs_agnumber_t		agno;
> > +	bool			default_report = true;
> > +	int			c;
> > +	int			ret;
> > +
> > +	reported = 0;
> > +
> > +	if (file->xfd.fsgeom.version != XFS_FSOP_GEOM_VERSION_V5) {
> > +		perror("health");
> > +		return 1;
> > +	}
> > +
> > +	while ((c = getopt(argc, argv, "a:cfi:q")) != EOF) {
> > +		switch (c) {
> > +		case 'a':
> > +			default_report = false;
> > +			errno = 0;
> > +			x = strtoll(optarg, NULL, 10);
> > +			if (!errno && x >= NULLAGNUMBER)
> > +				errno = ERANGE;
> > +			if (errno) {
> > +				perror("ag health");
> > +				return 1;
> > +			}
> > +			agno = x;
> > +			ret = report_ag_sick(agno);
> > +			if (!ret && comprehensive)
> > +				ret = report_bulkstat_health(agno);
> > +			if (ret)
> > +				return 1;
> > +			break;
> > +		case 'c':
> > +			comprehensive = true;
> > +			break;
> 
> There's a command line ordering problem here - - "-a" and "-f" 
> check the comprehensive flag and do additional stuff based on it.
> 
> So I think the -a and -f processing need to be done outside
> the args processing loop, or we need two loops to extract the
> -c first...
> 
> Otherwise looks OK.

Ok, will do.  Thanks for the review. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

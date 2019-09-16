Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFAEC49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDA52206C2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 21:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qQMneLbe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfIPV7W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 17:59:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37798 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbfIPV7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 17:59:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GLxDC9017281;
        Mon, 16 Sep 2019 21:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+Lwcewr0i6J5jb1IGS4VxFXi9LIsG4D34nqJDMHQ/0o=;
 b=qQMneLbeVLE3Pl9QLJ+oiWjprDyN6wI7T7b+aj2ddRjUlstK+mVRooK8ygKZEzejntHP
 FvbKmDzite1h1/O1goCvFiiuqQNQV4rrSVAunyXkGAxyC+bGA6ru+2udlvGu+l8xB0YI
 lIu6uVJaW1zIxkvGZv3NA+h39g1f4gPZg/kISa8a3r6HsGrxKJsU38XfJFjOwhgmZika
 ngngVE3eGtlB0jzfRGl60J+MUgXJjYKB5Dv9/vuNJPYdgKLKDiZ6UQWQJjZz4h58XznN
 txS2yp7V1iAbokIreDsr/Ijh8CAp1lXVJVyZc4Loao1CK0hAWWnbVE1cZUYLPzEJJFnr UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v0r5paa03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 21:59:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GLx95B183294;
        Mon, 16 Sep 2019 21:59:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v2jjs8b3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 21:59:14 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GLwuI4028675;
        Mon, 16 Sep 2019 21:58:56 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 14:58:54 -0700
Date:   Mon, 16 Sep 2019 14:58:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] misc: convert XFS_IOC_FSBULKSTAT to XFS_IOC_BULKSTAT
Message-ID: <20190916215853.GU568270@magnolia>
References: <156774089024.2643497.2754524603021685770.stgit@magnolia>
 <156774091553.2643497.13127754211857633238.stgit@magnolia>
 <20190913005426.GV16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913005426.GV16973@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160209
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 13, 2019 at 10:54:26AM +1000, Dave Chinner wrote:
> On Thu, Sep 05, 2019 at 08:35:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the v1 calls to v5 calls.

This really should have been more descriptive, sorry...

"Convert xfrog_bulkstat() to take arguments using v5 bulkstat semantics
and return bulkstat information in v5 structures.  If the v5 ioctl is
not available, xfrog_bulkstat() will emulate the v5 ioctl using the v1
ioctl."

> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fsr/xfs_fsr.c      |   45 ++++++--
> >  io/open.c          |   17 ++-
> >  libfrog/bulkstat.c |  290 +++++++++++++++++++++++++++++++++++++++++++++++++---
> >  libfrog/bulkstat.h |   10 +-
> >  libfrog/fsgeom.h   |    9 ++
> >  quota/quot.c       |   29 ++---
> >  scrub/inodes.c     |   45 +++++---
> >  scrub/inodes.h     |    2 
> >  scrub/phase3.c     |    6 +
> >  scrub/phase5.c     |    8 +
> >  scrub/phase6.c     |    2 
> >  scrub/unicrash.c   |    6 +
> >  scrub/unicrash.h   |    4 -
> >  spaceman/health.c  |   28 +++--
> >  14 files changed, 411 insertions(+), 90 deletions(-)
> > 
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index a53eb924..cc3cc93a 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -466,6 +466,17 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
> >  				ptr = strchr(ptr, ' ');
> >  				if (ptr) {
> >  					startino = strtoull(++ptr, NULL, 10);
> > +					/*
> > +					 * NOTE: The inode number read in from
> > +					 * the leftoff file is the last inode
> > +					 * to have been fsr'd.  Since the new
> > +					 * xfrog_bulkstat function wants to be
> > +					 * passed the first inode that we want
> > +					 * to examine, increment the value that
> > +					 * we read in.  The debug message below
> > +					 * prints the lastoff value.
> > +					 */
> > +					startino++;
> >  				}
> >  			}
> >  			if (startpass < 0)
> > @@ -484,7 +495,7 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
> >  
> >  	if (vflag) {
> >  		fsrprintf(_("START: pass=%d ino=%llu %s %s\n"),
> > -			  fs->npass, (unsigned long long)startino,
> > +			  fs->npass, (unsigned long long)startino - 1,
> >  			  fs->dev, fs->mnt);
> >  	}
> 
> This could probably go in a spearate patch....

It can't, because we're changing the meaning of the xfrog_bulkstat
arguments to match the ioctls.

> > @@ -724,7 +724,6 @@ inode_f(
> >  	char			**argv)
> >  {
> >  	struct xfs_bstat	bstat;
> > -	uint32_t		count = 0;
> >  	uint64_t		result_ino = 0;
> >  	uint64_t		userino = NULLFSINO;
> >  	char			*p;
> > @@ -775,21 +774,31 @@ inode_f(
> >  		}
> >  	} else if (ret_next) {
> >  		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
> > +		struct xfs_bulkstat_req	*breq;
> > +
> > +		breq = xfrog_bulkstat_alloc_req(1, userino + 1);
> > +		if (!breq) {
> > +			perror("alloc bulkstat");
> > +			exitcode = 1;
> > +			return 0;
> > +		}
> >  
> >  		/* get next inode */
> > -		ret = xfrog_bulkstat(&xfd, &userino, 1, &bstat, &count);
> 
> Why the "+ 1" on userino setup for the new interface?

The inode parameter to bulkstat changes between v1 and v5:

FSBULKSTAT (i.e. v1) takes a *lastino pointer that's supposed to point
to the inode number before the one you want.  If you want to bulkstat
starting with inode 100, you set *lastino = 99.

FSBULKSTAT_SINGLE (v1) takes a *lastino pointer that points to the inode
you want.  If you want to B_S inode 100, you set *lastino = 100.

BULKSTAT (v5) takes a startino number in the request header that should
be the inode you want.  If you want to bulkstat starting with inode 100,
you set breq->startino = 100.

In fsr's case, it traditionally used FSBULKSTAT (v1) and records the
last inode number that it defragged, so in order to use BULKSTAT (v5) we
have to increment the startino value here.  If v5 bulkstat is available
then we pass that number straight to the kernel.  If not, the
xfrog_bulk_req_setup function decrements the inode number so that it can
use the v1 ioctl to emulate the v5 behavior.

> 
> > @@ -29,29 +42,278 @@ xfrog_bulkstat_single(
> >  	return 0;
> >  }
> >  
> > -/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
> > -int
> > -xfrog_bulkstat(
> > +/*
> > + * Set up emulation of a v5 bulk request ioctl with a v1 bulk request ioctl.
> > + * Returns 0 if the emulation should proceed; ECANCELED if there are no
> > + * records; or a positive error code.

/*
 * Given a v5 BULKSTAT request, set up a v1 FSBULKSTAT control structure
 * so that we can emulate the v5 request using the old v1 code as best
 * we can.  This enables callers to run on older kernels.
 *
 * Returns 0 if the emulation should succeed, -ECANCELED if there won't
 * be any records; or a negative error code.
 */

How about that?

> > + */
> > +static int
> > +xfrog_bulk_req_setup(
> >  	struct xfs_fd		*xfd,
> > -	uint64_t		*lastino,
> > -	uint32_t		icount,
> > -	struct xfs_bstat	*ubuffer,
> > -	uint32_t		*ocount)
> > +	struct xfs_bulk_ireq	*hdr,
> > +	struct xfs_fsop_bulkreq	*bulkreq,
> > +	size_t			rec_size)
> > +{
> > +	void			*buf;
> > +
> > +	if (hdr->flags & XFS_BULK_IREQ_AGNO) {
> > +		uint32_t	agno = cvt_ino_to_agno(xfd, hdr->ino);
> > +
> > +		if (hdr->ino == 0)
> > +			hdr->ino = cvt_agino_to_ino(xfd, hdr->agno, 0);
> > +		else if (agno < hdr->agno)
> > +			return EINVAL;
> > +		else if (agno > hdr->agno)
> > +			goto no_results;
> > +	}
> > +
> > +	if (cvt_ino_to_agno(xfd, hdr->ino) > xfd->fsgeom.agcount)
> > +		goto no_results;
> > +
> > +	buf = malloc(hdr->icount * rec_size);
> > +	if (!buf)
> > +		return errno;
> > +
> > +	if (hdr->ino)
> > +		hdr->ino--;
> 
> This goes with my last question: why?

(See above)

> > +	bulkreq->lastip = (__u64 *)&hdr->ino,
> > +	bulkreq->icount = hdr->icount,
> > +	bulkreq->ocount = (__s32 *)&hdr->ocount,
> > +	bulkreq->ubuffer = buf;
> > +	return 0;
> > +
> > +no_results:
> > +	hdr->ocount = 0;
> > +	return ECANCELED;
> 
> We should be returning negative errors for everything.

Heh, that's going to be a lengthy overhaul of everything that comes
after this.

> 
> > +}
> > +
> > +/*
> > + * Convert records and free resources used to do a v1 emulation of v5 bulk
> > + * request.
> > + */

/*
 * If we have used the v1 FSBULKSTAT ioctl to emulate the v5 BULKSTAT
 * ioctl for a caller, migrate the v1 bulkstat data into the caller's
 * v5 bulkstat buffer and tear down the emulation control structures.
 */

> > +static int
> > +xfrog_bulk_req_teardown(
> 
> What's "teardown" got to do with converting results to a v1 format?
> 
> Indeed, why is there even emulation of v1 calls in the first place?
> why don't callers that need v1 format just use the existing v1
> ioctls directly?

This code emulates v5 bulkstat using old v1 bulkstat, but we've covered
this above.

> 
> >  
> > +/* Bulkstat a bunch of inodes using the v1 interface. */
> > +static int
> > +xfrog_bulkstat1(
> > +	struct xfs_fd		*xfd,
> > +	struct xfs_bulkstat_req	*req)
> > +{
> > +	struct xfs_fsop_bulkreq	bulkreq = { 0 };
> > +	int			error;
> > +
> > +	error = xfrog_bulkstat_prep_v1_emulation(xfd);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfrog_bulk_req_setup(xfd, &req->hdr, &bulkreq,
> > +			sizeof(struct xfs_bstat));
> > +	if (error == ECANCELED)
> > +		goto out_teardown;
> > +	if (error)
> > +		return error;
> > +
> > +	error = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
> > +	if (error)
> > +		error = errno;
> 
> negative errors, please.
> 
> > +
> > +out_teardown:
> > +	return xfrog_bulk_req_teardown(xfd, &req->hdr, &bulkreq,
> > +			sizeof(struct xfs_bstat), xfrog_bstat_ino,
> > +			&req->bulkstat, sizeof(struct xfs_bulkstat),
> > +			xfrog_bstat_cvt, 1, error);
> > +}
> 
> What conversion is necessary here given we've done a v1 format
> bulkstat?
> 
> > +/* Bulkstat a bunch of inodes.  Returns zero or a positive error code. */
> > +int
> > +xfrog_bulkstat(
> > +	struct xfs_fd		*xfd,
> > +	struct xfs_bulkstat_req	*req)
> > +{
> > +	int			error;
> > +
> > +	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
> > +		goto try_v1;
> > +
> > +	error = xfrog_bulkstat5(xfd, req);
> > +	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
> > +		return error;
> > +
> > +	/* If the v5 ioctl wasn't found, we punt to v1. */
> > +	switch (error) {
> > +	case EOPNOTSUPP:
> > +	case ENOTTY:
> > +		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
> > +		break;
> > +	}
> > +
> > +try_v1:
> > +	return xfrog_bulkstat1(xfd, req);
> > +}
> 
> Oh, wait, "v1 emulation" is supposed to mean "use a v1 call to
> return v5 format structures"? That's emulation of the _v5_ ioctl,
> which kinda says to me there's some naming problems here...

Yes.

> 
> > +/* Convert bulkstat (v5) to bstat (v1). */
> > +void
> > +xfrog_bulkstat_to_bstat(
> > +	struct xfs_fd			*xfd,
> > +	struct xfs_bstat		*bs1,
> > +	const struct xfs_bulkstat	*bstat)
> 
> Which I read as "convert bulkstat to bulkstat" and it doesn't tell
> me what is actually going on.  xfrog_bulkstat_v5_to_v1() indicates
> what format conversion is actually taking place...
> 
> and um, naming the v5 field bstat, and the struct xfs_bstat field
> bs1 is entirely confusing.

Indeed.  I'll change it as you suggest.

> void
> xfrog_bulkstat_v5_to_v1(
> 	struct xfs_fd		*xfd
> 	const struct xfs_bulkstat *from,
> 	struct xfs_bstat	*to)
> {
> 	to->bs_ino = from->bs_ino;
> ....
> 
> > +{
> > +	bs1->bs_ino = bstat->bs_ino;
> > +	bs1->bs_mode = bstat->bs_mode;
> > +	bs1->bs_nlink = bstat->bs_nlink;
> > +	bs1->bs_uid = bstat->bs_uid;
> > +	bs1->bs_gid = bstat->bs_gid;
> > +	bs1->bs_rdev = bstat->bs_rdev;
> > +	bs1->bs_blksize = bstat->bs_blksize;
> > +	bs1->bs_size = bstat->bs_size;
> > +	bs1->bs_atime.tv_sec = bstat->bs_atime;
> > +	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
> > +	bs1->bs_ctime.tv_sec = bstat->bs_ctime;
> 
> What about 32 bit overflows here?

Oops.  Ok.

> > +/* Convert bstat (v1) to bulkstat (v5). */
> > +void
> > +xfrog_bstat_to_bulkstat(
> > +	struct xfs_fd			*xfd,
> > +	struct xfs_bulkstat		*bstat,
> > +	const struct xfs_bstat		*bs1)
> > +{
> 
> same comments about names here.
> >  
> > +/* Only use v1 bulkstat/inumbers ioctls. */
> > +#define XFROG_FLAG_BULKSTAT_FORCE_V1	(1 << 0)
> > +
> > +/* Only use v5 bulkstat/inumbers ioctls. */
> > +#define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)
> 
> These don't actually define what format the results are presented
> in. What happens if the user wants v1 format structures but wants
> the V5 ioctl to be used?
> 
> > --- a/scrub/inodes.c
> > +++ b/scrub/inodes.c
> > @@ -50,13 +50,15 @@ static void
> >  xfs_iterate_inodes_range_check(
> >  	struct scrub_ctx	*ctx,
> >  	struct xfs_inogrp	*inogrp,
> > -	struct xfs_bstat	*bstat)
> > +	struct xfs_bulkstat	*bstat)
> >  {
> > -	struct xfs_bstat	*bs;
> > +	struct xfs_bulkstat	*bs;
> >  	int			i;
> >  	int			error;
> >  
> >  	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
> > +		struct xfs_bstat bs1;
> > +
> >  		if (!(inogrp->xi_allocmask & (1ULL << i)))
> >  			continue;
> >  		if (bs->bs_ino == inogrp->xi_startino + i) {
> > @@ -66,11 +68,13 @@ xfs_iterate_inodes_range_check(
> >  
> >  		/* Load the one inode. */
> >  		error = xfrog_bulkstat_single(&ctx->mnt,
> > -				inogrp->xi_startino + i, bs);
> > -		if (error || bs->bs_ino != inogrp->xi_startino + i) {
> > -			memset(bs, 0, sizeof(struct xfs_bstat));
> > +				inogrp->xi_startino + i, &bs1);
> > +		if (error || bs1.bs_ino != inogrp->xi_startino + i) {
> > +			memset(bs, 0, sizeof(struct xfs_bulkstat));
> >  			bs->bs_ino = inogrp->xi_startino + i;
> >  			bs->bs_blksize = ctx->mnt_sv.f_frsize;
> > +		} else {
> > +			xfrog_bstat_to_bulkstat(&ctx->mnt, bs, &bs1);
> 
> I'm confused - why is xfrog_bulkstat_single() returning a v1 format
> structure here and not using v5 format for everything?

Because I probably should have converted both at the same time. :/

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707D5C4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 03:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36840207FF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 03:54:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EAf9vsQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfI0Dy3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 23:54:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfI0Dy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 23:54:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R3dLtx108575;
        Fri, 27 Sep 2019 03:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ErhaVAyDMIriSspStmhlmqRS9fBxg0DI1xluIauedbc=;
 b=EAf9vsQ+AJTjEPK3MwboAEgwKToYi0cai5WEol97rAuqdNeyzZ6SyTTbUaadqMD0J5tX
 SykQVCu+paNrlUEzwCX7DQz9U1Lk7JjqGRCrXacxA1+k5T99ttRmuOUyzfr2q1APtKKH
 tM26qB2i1qy1ezimUxt7sBbGp/X2doNzPfGkIub1HQvEv38yOrOoOwuwhczeIt48fDle
 qqR19bA/dQG7vW7ASudLc0tc9Hj3uQJedmWraCryqOwO5N163NYWmyesdhmHaghLtpRQ
 5ySlmV1pAr/9iEk/QDlWINpP3E/94VyzMGk3LjlhgBUAlv6DUdFC4f/yjh53A2ZduL/V 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgrffr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 03:54:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R3i0PU016485;
        Fri, 27 Sep 2019 03:54:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v8yjy8dju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 03:54:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8R3sPBf012096;
        Fri, 27 Sep 2019 03:54:25 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 20:54:25 -0700
Date:   Thu, 26 Sep 2019 20:54:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] misc: convert from XFS_IOC_FSINUMBERS to
 XFS_IOC_INUMBERS
Message-ID: <20190927035424.GO9916@magnolia>
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
 <156944717162.297379.1042436133617221738.stgit@magnolia>
 <b76458e8-820c-1c0d-486e-53ef2b3a0680@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b76458e8-820c-1c0d-486e-53ef2b3a0680@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909270034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909270034
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 04:48:37PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:32 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert all programs to use the v5 inumbers ioctl.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  io/imap.c          |   26 +++++-----
> >  io/open.c          |   34 ++++++++-----
> >  libfrog/bulkstat.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++------
> >  libfrog/bulkstat.h |   10 +++-
> >  scrub/fscounters.c |   21 +++++---
> >  scrub/inodes.c     |   46 ++++++++++--------
> >  6 files changed, 198 insertions(+), 71 deletions(-)
> 
> ...
> 
> > diff --git a/io/open.c b/io/open.c
> > index e0e7fb3e..3c6113a1 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -681,39 +681,47 @@ static __u64
> >  get_last_inode(void)
> >  {
> >  	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
> > -	uint64_t		lastip = 0;
> > +	struct xfs_inumbers_req	*ireq;
> >  	uint32_t		lastgrp = 0;
> > -	uint32_t		ocount = 0;
> > -	__u64			last_ino;
> > -	struct xfs_inogrp	igroup[IGROUP_NR];
> > +	__u64			last_ino = 0;
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
> > -			return 0;
> > +			free(ireq);
> 
> no need to free here

Fixed.

> > +			goto out;
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
> > -		return 0;
> > +	if (lastgrp == 0) {
> > +		free(ireq);
> 
> or here
> 
> > +		goto out;
> > +	}
> >  
> >  	lastgrp--;
> >  
> >  	/* The last inode number in use */
> > -	last_ino = igroup[lastgrp].xi_startino +
> > -		  libxfs_highbit64(igroup[lastgrp].xi_allocmask);
> > +	last_ino = ireq->inumbers[lastgrp].xi_startino +
> > +		  libxfs_highbit64(ireq->inumbers[lastgrp].xi_allocmask);
> > +out:
> > +	free(ireq);
> 
> since you do it here

Thanks for catching that. <sigh> :)

> >  
> >  	return last_ino;
> >  }
> > diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> > index 300963f1..85594e5e 100644
> > --- a/libfrog/bulkstat.c
> > +++ b/libfrog/bulkstat.c
> > @@ -435,6 +435,86 @@ xfrog_bulkstat_alloc_req(
> >  	return breq;
> >  }
> >  
> > +/* Convert a inumbers data from v5 format to v1 format. */
> > +void
> > +xfrog_inumbers_v5_to_v1(
> > +	struct xfs_inogrp		*ig1,
> > +	const struct xfs_inumbers	*ig5)
> > +{
> > +	ig1->xi_startino = ig5->xi_startino;
> > +	ig1->xi_alloccount = ig5->xi_alloccount;
> > +	ig1->xi_allocmask = ig5->xi_allocmask;
> > +}
> 
> nobody uses this?

Right, it is (for now) an unused helper function.

> ...
> 
> > diff --git a/scrub/inodes.c b/scrub/inodes.c
> > index 2112c9d1..964647ce 100644
> > --- a/scrub/inodes.c
> > +++ b/scrub/inodes.c
> > @@ -49,7 +49,7 @@
> >  static void
> >  xfs_iterate_inodes_range_check(
> >  	struct scrub_ctx	*ctx,
> > -	struct xfs_inogrp	*inogrp,
> > +	struct xfs_inumbers	*inumbers,
> >  	struct xfs_bulkstat	*bstat)
> >  {
> >  	struct xfs_bulkstat	*bs;
> > @@ -57,19 +57,19 @@ xfs_iterate_inodes_range_check(
> >  	int			error;
> >  
> >  	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
> > -		if (!(inogrp->xi_allocmask & (1ULL << i)))
> > +		if (!(inumbers->xi_allocmask & (1ULL << i)))
> >  			continue;
> > -		if (bs->bs_ino == inogrp->xi_startino + i) {
> > +		if (bs->bs_ino == inumbers->xi_startino + i) {
> >  			bs++;
> >  			continue;
> >  		}
> >  
> >  		/* Load the one inode. */
> >  		error = xfrog_bulkstat_single(&ctx->mnt,
> > -				inogrp->xi_startino + i, 0, bs);
> > -		if (error || bs->bs_ino != inogrp->xi_startino + i) {
> > +				inumbers->xi_startino + i, 0, bs);
> > +		if (error || bs->bs_ino != inumbers->xi_startino + i) {
> >  			memset(bs, 0, sizeof(struct xfs_bulkstat));
> > -			bs->bs_ino = inogrp->xi_startino + i;
> > +			bs->bs_ino = inumbers->xi_startino + i;
> >  			bs->bs_blksize = ctx->mnt_sv.f_frsize;
> >  		}
> >  		bs++;
> > @@ -92,12 +92,11 @@ xfs_iterate_inodes_range(
> >  	void			*arg)
> >  {
> >  	struct xfs_handle	handle;
> > -	struct xfs_inogrp	inogrp;
> > +	struct xfs_inumbers_req	*ireq;
> >  	struct xfs_bulkstat_req	*breq;
> >  	char			idescr[DESCR_BUFSZ];
> >  	struct xfs_bulkstat	*bs;
> > -	uint64_t		igrp_ino;
> > -	uint32_t		igrplen = 0;
> > +	struct xfs_inumbers	*inumbers;
> >  	bool			moveon = true;
> >  	int			i;
> >  	int			error;
> > @@ -114,19 +113,26 @@ xfs_iterate_inodes_range(
> >  		return false;
> >  	}
> >  
> > +	ireq = xfrog_inumbers_alloc_req(1, first_ino);
> > +	if (!ireq) {
> > +		str_info(ctx, descr, _("Insufficient memory; giving up."));
> > +		free(breq);
> > +		return false;
> > +	}
> > +	inumbers = &ireq->inumbers[0];
> > +
> >  	/* Find the inode chunk & alloc mask */
> > -	igrp_ino = first_ino;
> > -	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
> > -	while (!error && igrplen) {
> > +	error = xfrog_inumbers(&ctx->mnt, ireq);
> > +	while (!error && ireq->hdr.ocount > 0) {
> >  		/*
> >  		 * We can have totally empty inode chunks on filesystems where
> >  		 * there are more than 64 inodes per block.  Skip these.
> >  		 */
> > -		if (inogrp.xi_alloccount == 0)
> > +		if (inumbers->xi_alloccount == 0)
> >  			goto igrp_retry;
> >  
> > -		breq->hdr.ino = inogrp.xi_startino;
> > -		breq->hdr.icount = inogrp.xi_alloccount;
> > +		breq->hdr.ino = inumbers->xi_startino;
> > +		breq->hdr.icount = inumbers->xi_alloccount;
> >  		error = xfrog_bulkstat(&ctx->mnt, breq);
> >  		if (error) {
> >  			char	errbuf[DESCR_BUFSZ];
> > @@ -135,11 +141,11 @@ xfs_iterate_inodes_range(
> >  						errbuf, DESCR_BUFSZ));
> >  		}
> >  
> > -		xfs_iterate_inodes_range_check(ctx, &inogrp, breq->bulkstat);
> > +		xfs_iterate_inodes_range_check(ctx, inumbers, breq->bulkstat);
> >  
> >  		/* Iterate all the inodes. */
> >  		for (i = 0, bs = breq->bulkstat;
> > -		     i < inogrp.xi_alloccount;
> > +		     i < inumbers->xi_alloccount;
> >  		     i++, bs++) {
> >  			if (bs->bs_ino > last_ino)
> >  				goto out;
> 
> same deal w/ leaking here
> 
> > @@ -153,7 +159,7 @@ xfs_iterate_inodes_range(
> >  			case ESTALE:
> >  				stale_count++;
> >  				if (stale_count < 30) {
> > -					igrp_ino = inogrp.xi_startino;
> > +					ireq->hdr.ino = inumbers->xi_startino;
> >  					goto igrp_retry;
> >  				}
> >  				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
> > @@ -177,8 +183,7 @@ _("Changed too many times during scan; giving up."));
> >  
> >  		stale_count = 0;
> >  igrp_retry:
> > -		error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
> > -				&igrplen);
> > +		error = xfrog_inumbers(&ctx->mnt, ireq);
> >  	}
> >  
> >  err:
> > @@ -186,6 +191,7 @@ _("Changed too many times during scan; giving up."));
> >  		str_liberror(ctx, error, descr);
> >  		moveon = false;
> >  	}
> > +	free(ireq);
> 
> since the free isn't under out:

Fixed that too.  Thanks for the review!

--D

> >  	free(breq);
> >  out:
> >  	return moveon;
> > 

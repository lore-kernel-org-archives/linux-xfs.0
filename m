Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D489C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBF852088F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 16:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WFDatK+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfKTQ5y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:57:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbfKTQ5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 11:57:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKGuClS120103;
        Wed, 20 Nov 2019 16:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bcMvvAe3xVpebey6hGmQDehUa6ju/esTSs1OreEePL4=;
 b=WFDatK+dy/v+5BzLu9ASU2EAAo408k0PqCFcEhtSwAeqBmRB+Kif9OvvJzzc7v65eFCB
 q/Iz+KasLcaWXCo8T0U0WJuIRG+bvRhcxX/fVTDz9JpmGGpJvy8fF5+sbFBbZLj9ceyg
 cVz6KAtYjvI6Dv8ICHwXGDNrhgZ5C5PS8+RXd9smzAXusk1JhNBnk5bBD0cs9TYjV5rP
 aPgfQOEsAQ7g6U/8p3Ux7ZxgzC9hdkVHTWv/2QHQgP5CqntfsLUaz6aJn1W51uitY/L7
 eYh9HdEtu8sYfeZTna108CtHfhdC3OEonMbpYxeT+idSTgIsA3y/RLwvjh6oEhir95a2 gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wa8htxw81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:57:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKGrwwq180038;
        Wed, 20 Nov 2019 16:57:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wcemgry1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:57:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKGvktq016291;
        Wed, 20 Nov 2019 16:57:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 08:57:46 -0800
Date:   Wed, 20 Nov 2019 08:57:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: report block map corruption errors to the
 health tracking system
Message-ID: <20191120165745.GL6219@magnolia>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375557349.3692735.15868119551132443897.stgit@magnolia>
 <20191120142119.GD15542@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120142119.GD15542@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 09:21:19AM -0500, Brian Foster wrote:
> On Thu, Nov 14, 2019 at 10:19:33AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Whenever we encounter a corrupt block mapping, we should report that to
> > the health monitoring system for later reporting.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c   |   39 +++++++++++++++++++++++++++++++++------
> >  fs/xfs/libxfs/xfs_health.h |    1 +
> >  fs/xfs/xfs_health.c        |   26 ++++++++++++++++++++++++++
> >  fs/xfs/xfs_iomap.c         |   15 +++++++++++----
> >  4 files changed, 71 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 4acc6e37c31d..c4674fb0bfb4 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -35,7 +35,7 @@
> >  #include "xfs_refcount.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_iomap.h"
> > -
> > +#include "xfs_health.h"
> >  
> >  kmem_zone_t		*xfs_bmap_free_item_zone;
> >  
> > @@ -732,6 +732,7 @@ xfs_bmap_extents_to_btree(
> >  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> >  	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
> >  	if (XFS_IS_CORRUPT(mp, !abp)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		error = -EFSCORRUPTED;
> >  		goto out_unreserve_dquot;
> >  	}
> > @@ -1021,6 +1022,7 @@ xfs_bmap_add_attrfork_local(
> >  
> >  	/* should only be called for types that support local format data */
> >  	ASSERT(0);
> > +	xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
> >  	return -EFSCORRUPTED;
> >  }
> 
> Is it really the attr fork that's corrupt if we get here?
> 
> >  
> > @@ -1090,6 +1092,7 @@ xfs_bmap_add_attrfork(
> >  	if (XFS_IFORK_Q(ip))
> >  		goto trans_cancel;
> >  	if (XFS_IS_CORRUPT(mp, ip->i_d.di_anextents != 0)) {
> > +		xfs_bmap_mark_sick(ip, XFS_ATTR_FORK);
> 
> Similar question here given we haven't added the fork yet. di_anextents
> is at least related I suppose, but it's not clear that
> scrubbing/repairing the attr fork is what needs to happen.

Hm, you're right, it's scrub/inode*.c that deal with anextents and
aformat, so these ought to mark the inode core sick, not the attr fork.

> >  		error = -EFSCORRUPTED;
> >  		goto trans_cancel;
> >  	}
> ...
> > @@ -1239,6 +1244,7 @@ xfs_iread_extents(
> >  	if (XFS_IS_CORRUPT(mp,
> >  			   XFS_IFORK_FORMAT(ip, whichfork) !=
> >  			   XFS_DINODE_FMT_BTREE)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		error = -EFSCORRUPTED;
> >  		goto out;
> >  	}
> > @@ -1254,6 +1260,7 @@ xfs_iread_extents(
> >  
> >  	if (XFS_IS_CORRUPT(mp,
> >  			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		error = -EFSCORRUPTED;
> >  		goto out;
> >  	}
> > @@ -1262,6 +1269,8 @@ xfs_iread_extents(
> >  	ifp->if_flags |= XFS_IFEXTENTS;
> >  	return 0;
> >  out:
> > +	if (xfs_metadata_is_sick(error))
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  	xfs_iext_destroy(ifp);
> >  	return error;
> >  }
> 
> Duplicate calls in xfs_iread_extents()?

Oops, yeah.

> Brian
> 
> > @@ -1344,6 +1353,7 @@ xfs_bmap_last_before(
> >  		break;
> >  	default:
> >  		ASSERT(0);
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -1443,8 +1453,11 @@ xfs_bmap_last_offset(
> >  	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL)
> >  		return 0;
> >  
> > -	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ip, whichfork)))
> > +	if (XFS_IS_CORRUPT(ip->i_mount,
> > +	    !xfs_ifork_has_extents(ip, whichfork))) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> > +	}
> >  
> >  	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
> >  	if (error || is_empty)
> > @@ -3905,6 +3918,7 @@ xfs_bmapi_read(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -3935,6 +3949,7 @@ xfs_bmapi_read(
> >  		xfs_alert(mp, "%s: inode %llu missing fork %d",
> >  				__func__, ip->i_ino, whichfork);
> >  #endif /* DEBUG */
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -4414,6 +4429,7 @@ xfs_bmapi_write(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -4621,9 +4637,11 @@ xfs_bmapi_convert_delalloc(
> >  	error = -ENOSPC;
> >  	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
> >  		goto out_finish;
> > -	error = -EFSCORRUPTED;
> > -	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
> > +	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> > +		error = -EFSCORRUPTED;
> >  		goto out_finish;
> > +	}
> >  
> >  	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
> >  	XFS_STATS_INC(mp, xs_xstrat_quick);
> > @@ -4681,6 +4699,7 @@ xfs_bmapi_remap(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -5319,8 +5338,10 @@ __xfs_bunmapi(
> >  	whichfork = xfs_bmapi_whichfork(flags);
> >  	ASSERT(whichfork != XFS_COW_FORK);
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> > -	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)))
> > +	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork))) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> > +	}
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> >  		return -EIO;
> >  
> > @@ -5815,6 +5836,7 @@ xfs_bmap_collapse_extents(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -5932,6 +5954,7 @@ xfs_bmap_insert_extents(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -6038,6 +6061,7 @@ xfs_bmap_split_extent_at(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > @@ -6253,8 +6277,10 @@ xfs_bmap_finish_one(
> >  			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
> >  			ip->i_ino, whichfork, startoff, *blockcount, state);
> >  
> > -	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
> > +	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK)) {
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		return -EFSCORRUPTED;
> > +	}
> >  
> >  	if (XFS_TEST_ERROR(false, tp->t_mountp,
> >  			XFS_ERRTAG_BMAP_FINISH_ONE))
> > @@ -6272,6 +6298,7 @@ xfs_bmap_finish_one(
> >  		break;
> >  	default:
> >  		ASSERT(0);
> > +		xfs_bmap_mark_sick(ip, whichfork);
> >  		error = -EFSCORRUPTED;
> >  	}
> >  
> > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > index ce8954a10c66..25b61180b562 100644
> > --- a/fs/xfs/libxfs/xfs_health.h
> > +++ b/fs/xfs/libxfs/xfs_health.h
> > @@ -138,6 +138,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
> >  		unsigned int *checked);
> >  
> >  void xfs_health_unmount(struct xfs_mount *mp);
> > +void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
> >  
> >  /* Now some helpers. */
> >  
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 36c32b108b39..5e5de5338476 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -452,3 +452,29 @@ xfs_bulkstat_health(
> >  			bs->bs_sick |= m->ioctl_mask;
> >  	}
> >  }
> > +
> > +/* Mark a block mapping sick. */
> > +void
> > +xfs_bmap_mark_sick(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork)
> > +{
> > +	unsigned int		mask;
> > +
> > +	switch (whichfork) {
> > +	case XFS_DATA_FORK:
> > +		mask = XFS_SICK_INO_BMBTD;
> > +		break;
> > +	case XFS_ATTR_FORK:
> > +		mask = XFS_SICK_INO_BMBTA;
> > +		break;
> > +	case XFS_COW_FORK:
> > +		mask = XFS_SICK_INO_BMBTC;
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +		return;
> > +	}
> > +
> > +	xfs_inode_mark_sick(ip, mask);
> > +}
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index 28e2d1f37267..c1befb899911 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -27,7 +27,7 @@
> >  #include "xfs_dquot_item.h"
> >  #include "xfs_dquot.h"
> >  #include "xfs_reflink.h"
> > -
> > +#include "xfs_health.h"
> >  
> >  #define XFS_ALLOC_ALIGN(mp, off) \
> >  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> > @@ -59,8 +59,10 @@ xfs_bmbt_to_iomap(
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> >  
> > -	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
> > +	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
> > +		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
> >  		return xfs_alert_fsblock_zero(ip, imap);
> > +	}
> >  
> >  	if (imap->br_startblock == HOLESTARTBLOCK) {
> >  		iomap->addr = IOMAP_NULL_ADDR;
> > @@ -277,8 +279,10 @@ xfs_iomap_write_direct(
> >  		goto out_unlock;
> >  	}
> >  
> > -	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
> > +	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
> > +		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
> >  		error = xfs_alert_fsblock_zero(ip, imap);
> > +	}
> >  
> >  out_unlock:
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > @@ -598,8 +602,10 @@ xfs_iomap_write_unwritten(
> >  		if (error)
> >  			return error;
> >  
> > -		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock)))
> > +		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
> > +			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
> >  			return xfs_alert_fsblock_zero(ip, &imap);
> > +		}
> >  
> >  		if ((numblks_fsb = imap.br_blockcount) == 0) {
> >  			/*
> > @@ -858,6 +864,7 @@ xfs_buffered_write_iomap_begin(
> >  
> >  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, XFS_DATA_FORK)) ||
> >  	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
> > +		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
> >  		error = -EFSCORRUPTED;
> >  		goto out_unlock;
> >  	}
> > 
> 

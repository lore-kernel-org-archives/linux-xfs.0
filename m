Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C83C32765
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA0D2469B
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IvuurWCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfLMUrY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:47:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMUrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 15:47:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKdRns096965;
        Fri, 13 Dec 2019 20:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=f1z8i1bOsPvnv8fncGQMCeTZoh0rsFYALlp17JNX36o=;
 b=IvuurWCyo37It1oeHE2mzV2J7Ea4QwVk9DU0N69QDrpImbAPvKNhVENyY+FXq7tszkkK
 R4IrhVMMGYQe3xg5jFmOA5Oo4Nn0+GQqb4v78QCxdz0zsGvQwfRSyz4vUlByyeyf/57I
 wMwTHrCEA3RwDKKThHAz/0pu/kYSBhT47o4gtSy4asPx6LCzeagN/MEqVDgQVbZqnKE7
 YWW+PVMqiyb5jn5Fs/UiTvW1bDMvirisXY875dJe9DLR5juYQxuSLVlGCr07FwtVK4Wx
 ixtDuJAX+Tk/VACM0hpWkxzGv3VGX/z48O1iCd2Megi05HYk4Yth+57lu/6M1WArkDI7 wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4nr56h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:47:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKiJLG046148;
        Fri, 13 Dec 2019 20:47:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wvdtvcf5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:47:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBDKlHVb026893;
        Fri, 13 Dec 2019 20:47:17 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 12:47:16 -0800
Date:   Fri, 13 Dec 2019 12:47:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191213204715.GJ99875@magnolia>
References: <20191213161349.GH99875@magnolia>
 <20191213174526.GH43376@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213174526.GH43376@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 12:45:26PM -0500, Brian Foster wrote:
> On Fri, Dec 13, 2019 at 08:13:49AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> > and swidth values could cause xfs_repair to fail loudly.  The problem
> > here is that repair calculates the where mkfs should have allocated the
> > root inode, based on the superblock geometry.  The allocation decisions
> > depend on sunit, which means that we really can't go updating sunit if
> > it would lead to a subsequent repair failure on an otherwise correct
> > filesystem.
> > 
> > Port from xfs_repair some code that computes the location of the root
> > inode and teach mount to skip the ondisk update if it would cause
> > problems for repair.  Along the way we'll update the documentation,
> > provide a function for computing the minimum AGFL size instead of
> > open-coding it, and cut down some indenting in the mount code.
> > 
> > Note that we allow the mount to proceed (and new allocations will
> > reflect this new geometry) because we've never screened this kind of
> > thing before.  We'll have to wait for a new future incompat feature to
> > enforce correct behavior, alas.
> > 
> > Note that the geometry reporting always uses the superblock values, not
> > the incore ones, so that is what xfs_info and xfs_growfs will report.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> > 
> > Reported-by: Alex Lyakas <alex@zadara.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: refactor the agfl length calculations, clarify the fsgeometry ioctl
> > behavior, fix a bunch of the comments and make it clearer how we compute
> > the rootino location
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c  |   18 ++++++---
> >  fs/xfs/libxfs/xfs_ialloc.c |   70 ++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_ialloc.h |    1 
> >  fs/xfs/xfs_mount.c         |   90 ++++++++++++++++++++++++++++++--------------
> >  fs/xfs/xfs_trace.h         |   21 ++++++++++
> >  5 files changed, 166 insertions(+), 34 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> > index 323592d563d5..72b3468b97b1 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.h
> > +++ b/fs/xfs/libxfs/xfs_ialloc.h
> ...
> > @@ -398,28 +431,26 @@ xfs_update_alignment(xfs_mount_t *mp)
> >  			}
> >  		}
> >  
> > -		/*
> > -		 * Update superblock with new values
> > -		 * and log changes
> > -		 */
> > -		if (xfs_sb_version_hasdalign(sbp)) {
> > -			if (sbp->sb_unit != mp->m_dalign) {
> > -				sbp->sb_unit = mp->m_dalign;
> > -				mp->m_update_sb = true;
> > -			}
> > -			if (sbp->sb_width != mp->m_swidth) {
> > -				sbp->sb_width = mp->m_swidth;
> > -				mp->m_update_sb = true;
> > -			}
> > -		} else {
> > +		/* Update superblock with new values and log changes. */
> > +		if (!xfs_sb_version_hasdalign(sbp)) {
> >  			xfs_warn(mp,
> >  	"cannot change alignment: superblock does not support data alignment");
> >  			return -EINVAL;
> >  		}
> > +
> > +		if (sbp->sb_unit == mp->m_dalign &&
> > +		    sbp->sb_width == mp->m_swidth)
> > +			return 0;
> > +
> > +		xfs_check_new_dalign(mp, mp->m_dalign);
> > +
> > +		sbp->sb_unit = mp->m_dalign;
> > +		sbp->sb_width = mp->m_swidth;
> > +		mp->m_update_sb = true;
> 
> Isn't this supposed to conditionally update the superblock based on the
> rootino calculation?

D'oh.  V3 it is then. :(

--D

> Brian
> 
> >  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
> >  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> > -			mp->m_dalign = sbp->sb_unit;
> > -			mp->m_swidth = sbp->sb_width;
> > +		mp->m_dalign = sbp->sb_unit;
> > +		mp->m_swidth = sbp->sb_width;
> >  	}
> >  
> >  	return 0;
> > @@ -647,16 +678,6 @@ xfs_mountfs(
> >  		mp->m_update_sb = true;
> >  	}
> >  
> > -	/*
> > -	 * Check if sb_agblocks is aligned at stripe boundary
> > -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> > -	 * allocator alignment is within an ag, therefore ag has
> > -	 * to be aligned at stripe boundary.
> > -	 */
> > -	error = xfs_update_alignment(mp);
> > -	if (error)
> > -		goto out;
> > -
> >  	xfs_alloc_compute_maxlevels(mp);
> >  	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> >  	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> > @@ -664,6 +685,17 @@ xfs_mountfs(
> >  	xfs_rmapbt_compute_maxlevels(mp);
> >  	xfs_refcountbt_compute_maxlevels(mp);
> >  
> > +	/*
> > +	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
> > +	 * is NOT aligned turn off m_dalign since allocator alignment is within
> > +	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
> > +	 * we must compute the free space and rmap btree geometry before doing
> > +	 * this.
> > +	 */
> > +	error = xfs_update_alignment(mp);
> > +	if (error)
> > +		goto out;
> > +
> >  	/* enable fail_at_unmount as default */
> >  	mp->m_fail_unmount = true;
> >  
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index c13bb3655e48..a86be7f807ee 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
> >  DEFINE_KMEM_EVENT(kmem_realloc);
> >  DEFINE_KMEM_EVENT(kmem_zone_alloc);
> >  
> > +TRACE_EVENT(xfs_check_new_dalign,
> > +	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> > +	TP_ARGS(mp, new_dalign, calc_rootino),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(int, new_dalign)
> > +		__field(xfs_ino_t, sb_rootino)
> > +		__field(xfs_ino_t, calc_rootino)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->new_dalign = new_dalign;
> > +		__entry->sb_rootino = mp->m_sb.sb_rootino;
> > +		__entry->calc_rootino = calc_rootino;
> > +	),
> > +	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->new_dalign, __entry->sb_rootino,
> > +		  __entry->calc_rootino)
> > +)
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
> 

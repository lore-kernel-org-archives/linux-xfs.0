Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F547C46466
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED8E0207BC
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 17:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tIj9IWJK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgJERCI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 13:02:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgJERCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 13:02:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095Gxswq065759;
        Mon, 5 Oct 2020 17:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=64HO/SxFlQOwLg4cq9T7eJmGOvbQs1wrXP0y1FiXOhA=;
 b=tIj9IWJK2RgInneSpe8V98ApyG7SKRsW4eE5z8ikztaZxFhtJrJmYKe0WkZYY0VlHIKZ
 gAumokRuLA+hM9jn5WXoxii+iKPrnVtNEIdWVi49Fb9XP32e7tx+I1p+dxM7MSqi0HgO
 dw4MARY5GZhXDWa1zJVPjjOF7htsJg3AHTTpHwRPQU+LErPEAGG/Ih7x61zYYZHwQyZV
 4sJLN4Dmt8/+etmIMO30h30ArxxIfCfQ13k7bTBi6J6mTuHAGT1mPPuZs08Gr4F9hGnr
 +EqLgA6NDWkMpYjGbKBM097fDaZL2ZfClsXxjjrVPmEU7f8p+DpOBmMh+HmtBXC2Uhgn zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34bs8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 17:02:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095GtDH3034851;
        Mon, 5 Oct 2020 17:02:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vkrtwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 17:02:01 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095H1xFI017595;
        Mon, 5 Oct 2020 17:01:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 10:01:59 -0700
Date:   Mon, 5 Oct 2020 10:01:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v3.3 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20201005170158.GF49547@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144660.830434.10498291551366134327.stgit@magnolia>
 <20201004191127.GC49547@magnolia>
 <20201005162014.GB6539@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005162014.GB6539@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=5 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=5 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 12:20:14PM -0400, Brian Foster wrote:
> On Sun, Oct 04, 2020 at 12:11:27PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_bui_item_recover, there exists a use-after-free bug with regards
> > to the inode that is involved in the bmap replay operation.  If the
> > mapping operation does not complete, we call xfs_bmap_unmap_extent to
> > create a deferred op to finish the unmapping work, and we retain a
> > pointer to the incore inode.
> > 
> > Unfortunately, the very next thing we do is commit the transaction and
> > drop the inode.  If reclaim tears down the inode before we try to finish
> > the defer ops, we dereference garbage and blow up.  Therefore, create a
> > way to join inodes to the defer ops freezer so that we can maintain the
> > xfs_inode reference until we're done with the inode.
> > 
> > Note: This imposes the requirement that there be enough memory to keep
> > every incore inode in memory throughout recovery.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v3.3: ihold the captured inode and let callers iunlock/irele their own
> > reference
> > v3.2: rebase on updated defer capture patches
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   43 ++++++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/libxfs/xfs_defer.h  |   11 +++++++++--
> >  fs/xfs/xfs_bmap_item.c     |    7 +++++--
> >  fs/xfs/xfs_extfree_item.c  |    2 +-
> >  fs/xfs/xfs_inode.c         |    8 ++++++++
> >  fs/xfs/xfs_inode.h         |    2 ++
> >  fs/xfs/xfs_log_recover.c   |    7 ++++++-
> >  fs/xfs/xfs_refcount_item.c |    2 +-
> >  fs/xfs/xfs_rmap_item.c     |    2 +-
> >  9 files changed, 71 insertions(+), 13 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 2bfbcf28b1bd..24b1e2244905 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3813,3 +3813,11 @@ xfs_iunlock2_io_mmap(
> >  	if (!same_inode)
> >  		inode_unlock(VFS_I(ip1));
> >  }
> > +
> > +/* Grab an extra reference to the VFS inode. */
> > +void
> > +xfs_ihold(
> > +	struct xfs_inode	*ip)
> > +{
> > +	ihold(VFS_I(ip));
> > +}
> 
> It looks to me that the only reason xfs_irele() exists is for a
> tracepoint. We don't have that here, so what's the purpose of the
> helper?

Wellll... ihold() is a VFS inode function, and I didn't want to force
libxfs to have yet another direct dependency on a VFS function that we'd
then have to port to userspace.

OTOH, userspace totally lacks the concept of refcounting the incore
inodes (and indeed it even seems to allow for aliasing inodes!) so maybe
I'll just do it...

> Otherwise the patch looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 751a3d1d7d84..e9b0186b594c 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -476,4 +476,6 @@ void xfs_end_io(struct work_struct *work);
> >  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> >  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> >  
> > +void xfs_ihold(struct xfs_inode *ip);
> > +
> >  #endif	/* __XFS_INODE_H__ */
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 001e1585ddc6..a8289adc1b29 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2439,6 +2439,7 @@ xlog_finish_defer_ops(
> >  {
> >  	struct xfs_defer_capture *dfc, *next;
> >  	struct xfs_trans	*tp;
> > +	struct xfs_inode	*ip;
> >  	int			error = 0;
> >  
> >  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> > @@ -2464,9 +2465,13 @@ xlog_finish_defer_ops(
> >  		 * from recovering a single intent item.
> >  		 */
> >  		list_del_init(&dfc->dfc_list);
> > -		xfs_defer_ops_continue(dfc, tp);
> > +		xfs_defer_ops_continue(dfc, tp, &ip);
> >  
> >  		error = xfs_trans_commit(tp);
> > +		if (ip) {
> > +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +			xfs_irele(ip);
> > +		}
> >  		if (error)
> >  			return error;
> >  	}
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index 0478374add64..ad895b48f365 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -544,7 +544,7 @@ xfs_cui_item_recover(
> >  	}
> >  
> >  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > -	return xfs_defer_ops_capture_and_commit(tp, capture_list);
> > +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> >  
> >  abort_error:
> >  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index 0d8fa707f079..1163f32c3e62 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -567,7 +567,7 @@ xfs_rui_item_recover(
> >  	}
> >  
> >  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > -	return xfs_defer_ops_capture_and_commit(tp, capture_list);
> > +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> >  
> >  abort_error:
> >  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > 
> 

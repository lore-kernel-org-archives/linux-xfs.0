Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33930C4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34D620758
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uRae2bxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJBQaK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 12:30:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgJBQaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 12:30:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092GJgqJ129666;
        Fri, 2 Oct 2020 16:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TjOtt+n5c2ATnKpiaT0OozC7HIZwVWvNSpshkuTsuig=;
 b=uRae2bxYuVhtsc33ixKYay4wF8suVaG4JFuEW9MS5brUPvE8FzR77L9wu4cJPnlce+cc
 dvuloNAOG9eRCfSSK4xMb1VZxv8H2TmNiFvsxSzsqnJVzfKlmrdWaLhKEx6UG5WlnZAZ
 m5jGUDzLJhswk62vhuCPnV97xDUQ9lWQglDtyrpXFVHjidmCpw9wMw8tLdN5+q2BuOSu
 SPtCi62WcAZd3Vx2ISvJFtlVMTluTt0nAyrLc+qv4DgCx/4ocm5zufrzFkglIwDt3i97
 LVUFx80016XTe5lLT2yZNlb7xgSGRk47L4oJqxaJft477Mir7HsFx4zFqB0Ya1UNDRPT 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9nkrtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 16:30:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092GKZ7d004702;
        Fri, 2 Oct 2020 16:30:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfj3a2ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 16:30:01 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 092GTxUD012245;
        Fri, 2 Oct 2020 16:29:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 09:29:59 -0700
Date:   Fri, 2 Oct 2020 09:29:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5.2 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20201002162958.GX49547@magnolia>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144660.830434.10498291551366134327.stgit@magnolia>
 <20201002042236.GV49547@magnolia>
 <20201002073006.GE9900@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002073006.GE9900@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=5 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 09:30:06AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 01, 2020 at 09:22:36PM -0700, Darrick J. Wong wrote:
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
> > v5.2: rebase on updated defer capture patches
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   55 ++++++++++++++++++++++++++++++++++++++------
> >  fs/xfs/libxfs/xfs_defer.h  |   11 +++++++--
> >  fs/xfs/xfs_bmap_item.c     |    8 ++----
> >  fs/xfs/xfs_extfree_item.c  |    2 +-
> >  fs/xfs/xfs_log_recover.c   |    7 +++++-
> >  fs/xfs/xfs_refcount_item.c |    2 +-
> >  fs/xfs/xfs_rmap_item.c     |    2 +-
> >  7 files changed, 67 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index e19dc1ced7e6..4af5752f9830 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -16,6 +16,7 @@
> >  #include "xfs_inode.h"
> >  #include "xfs_inode_item.h"
> >  #include "xfs_trace.h"
> > +#include "xfs_icache.h"
> >  
> >  /*
> >   * Deferred Operations in XFS
> > @@ -553,10 +554,14 @@ xfs_defer_move(
> >   * deferred ops state is transferred to the capture structure and the
> >   * transaction is then ready for the caller to commit it.  If there are no
> >   * intent items to capture, this function returns NULL.
> > + *
> > + * If inodes are passed in and this function returns a capture structure, the
> > + * inodes are now owned by the capture structure.
> >   */
> >  static struct xfs_defer_capture *
> >  xfs_defer_ops_capture(
> > -	struct xfs_trans		*tp)
> > +	struct xfs_trans		*tp,
> > +	struct xfs_inode		*ip)
> >  {
> >  	struct xfs_defer_capture	*dfc;
> >  
> > @@ -582,6 +587,12 @@ xfs_defer_ops_capture(
> >  	/* Preserve the log reservation size. */
> >  	dfc->dfc_logres = tp->t_log_res;
> >  
> > +	/*
> > +	 * Transfer responsibility for unlocking and releasing the inodes to
> > +	 * the capture structure.
> > +	 */
> > +	dfc->dfc_ip = ip;
> > +
> 
> Maybe rename ip to capture_ip?

Ok.

> > +	ASSERT(ip == NULL || xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +
> >  	/* If we don't capture anything, commit transaction and exit. */
> > +	dfc = xfs_defer_ops_capture(tp, ip);
> > +	if (!dfc) {
> > +		error = xfs_trans_commit(tp);
> > +		if (ip) {
> > +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +			xfs_irele(ip);
> > +		}
> > +		return error;
> > +	}
> 
> Instead of coming up with our own inode unlocking and release schemes,
> can't we just require that the inode is joinged by passing the lock
> flags to xfs_trans_ijoin, and piggy back on xfs_trans_commit unlocking
> it in that case?

Yes, and let's also xfs_iget(capture_ip->i_ino) to increase the incore
inode's refcount, which would make it so that the caller would still
unlock and rele the reference that they got.

--D

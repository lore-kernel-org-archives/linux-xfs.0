Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BACC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 06:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D072076D
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 06:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725294AbgI1GKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 02:10:54 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34135 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgI1GKy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 02:10:54 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 643333A75C3;
        Mon, 28 Sep 2020 16:10:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMmN4-0004ox-Vy; Mon, 28 Sep 2020 16:10:46 +1000
Date:   Mon, 28 Sep 2020 16:10:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
Message-ID: <20200928061046.GG14422@dread.disaster.area>
References: <160125009588.174612.13196702491335373645.stgit@magnolia>
 <160125011691.174612.13255814016601281607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160125011691.174612.13255814016601281607.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=H4XyqQWFdXiamJ3JR5QA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:41:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bui_item_recover, there exists a use-after-free bug with regards
> to the inode that is involved in the bmap replay operation.  If the
> mapping operation does not complete, we call xfs_bmap_unmap_extent to
> create a deferred op to finish the unmapping work, and we retain a
> pointer to the incore inode.
> 
> Unfortunately, the very next thing we do is commit the transaction and
> drop the inode.  If reclaim tears down the inode before we try to finish
> the defer ops, we dereference garbage and blow up.  Therefore, create a
> way to join inodes to the defer ops freezer so that we can maintain the
> xfs_inode reference until we're done with the inode.

Honest first reaction now I understand what the capture stuff is
doing: Ewww! Gross!

We only need to store a single inode, so the whole "2 inodes for
symmetry with defer_ops" greatly overcomplicates the code. This
could be *much* simpler.

> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index deb99300d171..c7f65e16534f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -12,6 +12,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_defer.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> @@ -1689,3 +1690,43 @@ xfs_start_block_reaping(
>  	xfs_queue_eofblocks(mp);
>  	xfs_queue_cowblocks(mp);
>  }
> +
> +/*
> + * Prepare the inodes to participate in further log intent item recovery.
> + * For now, that means attaching dquots and locking them, since libxfs doesn't
> + * know how to do that.
> + */
> +void
> +xfs_defer_continue_inodes(
> +	struct xfs_defer_capture	*dfc,
> +	struct xfs_trans		*tp)
> +{
> +	int				i;
> +	int				error;
> +
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++) {
> +		error = xfs_qm_dqattach(dfc->dfc_inodes[i]);
> +		if (error)
> +			tp->t_mountp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
> +	}
> +
> +	if (dfc->dfc_inodes[1])
> +		xfs_lock_two_inodes(dfc->dfc_inodes[0], XFS_ILOCK_EXCL,
> +				    dfc->dfc_inodes[1], XFS_ILOCK_EXCL);
> +	else if (dfc->dfc_inodes[0])
> +		xfs_ilock(dfc->dfc_inodes[0], XFS_ILOCK_EXCL);
> +	dfc->dfc_ilocked = true;
> +}
> +
> +/* Release all the inodes attached to this dfops capture device. */
> +void
> +xfs_defer_capture_irele(
> +	struct xfs_defer_capture	*dfc)
> +{
> +	unsigned int			i;
> +
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES && dfc->dfc_inodes[i]; i++) {
> +		xfs_irele(dfc->dfc_inodes[i]);
> +		dfc->dfc_inodes[i] = NULL;
> +	}
> +}

None of this belongs in xfs_icache.c. The function namespace tells
me where it should be...

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 0d899ab7df2e..1463c3097240 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1755,23 +1755,43 @@ xlog_recover_release_intent(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +static inline void
> +xlog_recover_irele(
> +	struct xfs_inode	*ip)
> +{
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_irele(ip);
> +}

Just open code it, please.

>  int
> -xlog_recover_trans_commit(
> +xlog_recover_trans_commit_inodes(
>  	struct xfs_trans		*tp,
> -	struct list_head		*capture_list)
> +	struct list_head		*capture_list,
> +	struct xfs_inode		*ip1,
> +	struct xfs_inode		*ip2)

So are these inodes supposed to be locked, referenced and/or ???

>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
> +	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp, ip1, ip2);
>  	int				error;

That's the second time putting this logic up in the declaration list
has made me wonder where something in this function is initilaised.
Please move it into the code so that it is obvious.

>  
>  	/* If we don't capture anything, commit tp and exit. */
> -	if (!dfc)
> -		return xfs_trans_commit(tp);
> +	if (!dfc) {

i.e. before this line.

	dfc = xfs_defer_capture(tp, ip1, ip2);
	if (!dfc) {

> +		error = xfs_trans_commit(tp);
> +
> +		/* We still own the inodes, so unlock and release them. */
> +		if (ip2 && ip2 != ip1)
> +			xlog_recover_irele(ip2);
> +		if (ip1)
> +			xlog_recover_irele(ip1);
> +		return error;
> +	}

Not a fan of the unnecessary complexity of this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

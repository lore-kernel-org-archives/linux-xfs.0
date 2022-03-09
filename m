Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FC7C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 21:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiCIVtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiCIVtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 16:49:24 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 858BC48E4D
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 13:48:23 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6505753168E;
        Thu, 10 Mar 2022 08:48:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nS4AP-003Xfr-RU; Thu, 10 Mar 2022 08:48:21 +1100
Date:   Thu, 10 Mar 2022 08:48:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: reserve quota for dir expansion when
 linking/unlinking files
Message-ID: <20220309214821.GH661808@dread.disaster.area>
References: <164685374120.495923.2523387358442198692.stgit@magnolia>
 <164685374682.495923.2923492909223420951.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164685374682.495923.2923492909223420951.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=622920a6
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=VRkXK53dqWtryug5LAwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 11:22:26AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> XFS does not reserve quota for directory expansion when linking or
> unlinking children from a directory.  This means that we don't reject
> the expansion with EDQUOT when we're at or near a hard limit, which
> means that unprivileged userspace can use link()/unlink() to exceed
> quota.
> 
> The fix for this is nuanced -- link operations don't always expand the
> directory, and we allow a link to proceed with no space reservation if
> we don't need to add a block to the directory to handle the addition.
> Unlink operations generally do not expand the directory (you'd have to
> free a block and then cause a btree split) and we can defer the
> directory block freeing if there is no space reservation.
> 
> Moreover, there is a further bug in that we do not trigger the blockgc
> workers to try to clear space when we're out of quota.
> 
> To fix both cases, create a new xfs_trans_alloc_dir function that
> allocates the transaction, locks and joins the inodes, and reserves
> quota for the directory.  If there isn't sufficient space or quota,
> we'll switch the caller to reservationless mode.  This should prevent
> quota usage overruns with the least restriction in functionality.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   30 +++++-------------
>  fs/xfs/xfs_trans.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h |    3 ++
>  3 files changed, 97 insertions(+), 22 deletions(-)

Overall looks good, minor nits below:

> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 04bf467b1090..a131bbfe74e4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1217,7 +1217,7 @@ xfs_link(
>  {
>  	xfs_mount_t		*mp = tdp->i_mount;
>  	xfs_trans_t		*tp;
> -	int			error;
> +	int			error, space_error;
>  	int			resblks;
>  
>  	trace_xfs_link(tdp, target_name);
> @@ -1236,19 +1236,11 @@ xfs_link(
>  		goto std_return;
>  
>  	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
> -	if (error == -ENOSPC) {
> -		resblks = 0;
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &tp);
> -	}
> +	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
> +			&tp, &space_error);

It's the nospace_error, isn't it? The code reads a lot better when
it's called that, too.


>  	if (error)
>  		goto std_return;
>  
> -	xfs_lock_two_inodes(sip, XFS_ILOCK_EXCL, tdp, XFS_ILOCK_EXCL);
> -
> -	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> -
>  	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
>  			XFS_IEXT_DIR_MANIP_CNT(mp));
>  	if (error)
> @@ -1267,6 +1259,8 @@ xfs_link(
>  
>  	if (!resblks) {
>  		error = xfs_dir_canenter(tp, tdp, target_name);
> +		if (error == -ENOSPC && space_error)
> +			error = space_error;

This  would be better in the error_return stack, I think. That way
the transformation only has to be done once, and it will be done for
all functions that can potentially return ENOSPC.

>  		if (error)
>  			goto error_return;
>  	}
> @@ -2755,6 +2749,7 @@ xfs_remove(
>  	xfs_mount_t		*mp = dp->i_mount;
>  	xfs_trans_t             *tp = NULL;
>  	int			is_dir = S_ISDIR(VFS_I(ip)->i_mode);
> +	int			dontcare;
>  	int                     error = 0;
>  	uint			resblks;
>  
> @@ -2781,22 +2776,13 @@ xfs_remove(
>  	 * block from the directory.
>  	 */
>  	resblks = XFS_REMOVE_SPACE_RES(mp);
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0, &tp);
> -	if (error == -ENOSPC) {
> -		resblks = 0;
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_remove, 0, 0, 0,
> -				&tp);
> -	}
> +	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip, &resblks,
> +			&tp, &dontcare);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
>  		goto std_return;
>  	}

So we just ignore -EDQUOT when it is returned in @dontcare? I'd like
a comment to explain why we don't care about EDQUOT here, because
the next time I look at this I will have forgotten all about this...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

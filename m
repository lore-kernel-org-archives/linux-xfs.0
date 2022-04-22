Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D18C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 23:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiDVXSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 19:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiDVXRM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 19:17:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79BB4139769
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 15:51:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 83A5E53463A;
        Sat, 23 Apr 2022 08:51:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ni280-003LWK-U5; Sat, 23 Apr 2022 08:51:52 +1000
Date:   Sat, 23 Apr 2022 08:51:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: reduce the absurdly large log reservations
Message-ID: <20220422225152.GD1544202@dread.disaster.area>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688838.383881.2386659608282052005.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997688838.383881.2386659608282052005.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6263318a
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=9zMtEVnHMi6nksp9Ft4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 03:54:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in the early days of reflink and rmap development I set the
> transaction reservation sizes to be overly generous for rmap+reflink
> filesystems, and a little under-generous for rmap-only filesystems.
> 
> Since we don't need *eight* transaction rolls to handle three new log
> intent items, decrease the logcounts to what we actually need, and amend
> the shadow reservation computation function to reflect what we used to
> do so that the minimum log size doesn't change.

Yup, this will make a huge difference to the number of transactions
we can have in flight on reflink/rmap enabled filesystems.

Mostly looks good, some comments about code and comments below.

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |   88 +++++++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_trans_resv.h |    6 ++-
>  2 files changed, 64 insertions(+), 30 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 12d4e451e70e..8d2f04dddb65 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -814,36 +814,16 @@ xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_resv	*resp)
>  {
> -	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> -
> -	/*
> -	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> -	 * to 9 even if the AG was small enough that it would never grow to
> -	 * that height.  Transaction reservation sizes influence the minimum
> -	 * log size calculation, which influences the size of the log that mkfs
> -	 * creates.  Use the old value here to ensure that newly formatted
> -	 * small filesystems will mount on older kernels.
> -	 */
> -	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> -		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> -
>  	/*
>  	 * The following transactions are logged in physical format and
>  	 * require a permanent reservation on space.
>  	 */
>  	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
> -	if (xfs_has_reflink(mp))
> -		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> -	else
> -		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
>  	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
> -	if (xfs_has_reflink(mp))
> -		resp->tr_itruncate.tr_logcount =
> -				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
> -	else
> -		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
>  	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
> @@ -900,10 +880,7 @@ xfs_trans_resv_calc(
>  	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
> -	if (xfs_has_reflink(mp))
> -		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> -	else
> -		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
>  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
>  	/*
> @@ -930,8 +907,26 @@ xfs_trans_resv_calc(
>  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
>  
> -	/* Put everything back the way it was.  This goes at the end. */
> -	mp->m_rmap_maxlevels = rmap_maxlevels;
> +	/* Add one logcount for BUI items that appear with rmap or reflink. */
> +	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
> +		resp->tr_itruncate.tr_logcount++;
> +		resp->tr_write.tr_logcount++;
> +		resp->tr_qm_dqalloc.tr_logcount++;
> +	}
> +
> +	/* Add one logcount for refcount intent items. */
> +	if (xfs_has_reflink(mp)) {
> +		resp->tr_itruncate.tr_logcount++;
> +		resp->tr_write.tr_logcount++;
> +		resp->tr_qm_dqalloc.tr_logcount++;
> +	}
> +
> +	/* Add one logcount for rmap intent items. */
> +	if (xfs_has_rmapbt(mp)) {
> +		resp->tr_itruncate.tr_logcount++;
> +		resp->tr_write.tr_logcount++;
> +		resp->tr_qm_dqalloc.tr_logcount++;
> +	}

This would be much more concisely written as

	count = 0;
	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
		count = 2;
		if (xfs_has_reflink(mp) && xfs_has_rmapbt(mp))
			count++;
	}

	resp->tr_itruncate.tr_logcount += count;
	resp->tr_write.tr_logcount += count;
	resp->tr_qm_dqalloc.tr_logcount += count;

>  }
>  
>  /*
> @@ -943,5 +938,42 @@ xfs_trans_resv_calc_logsize(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_resv	*resp)
>  {
> +	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> +
> +	ASSERT(resp != M_RES(mp));
> +
> +	/*
> +	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> +	 * to 9 even if the AG was small enough that it would never grow to
> +	 * that height.  Transaction reservation sizes influence the minimum
> +	 * log size calculation, which influences the size of the log that mkfs
> +	 * creates.  Use the old value here to ensure that newly formatted
> +	 * small filesystems will mount on older kernels.
> +	 */
> +	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> +		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> +
>  	xfs_trans_resv_calc(mp, resp);
> +
> +	if (xfs_has_reflink(mp)) {
> +		/*
> +		 * In the early days of reflink we set the logcounts absurdly
> +		 * high.

"In the early days of reflink, typical operation log counts were
greatly overestimated"

> +		 */
> +		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> +		resp->tr_itruncate.tr_logcount =
> +				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
> +		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> +	} else if (xfs_has_rmapbt(mp)) {
> +		/*
> +		 * In the early days of non-reflink rmap we set the logcount
> +		 * too low.

"In the early days of non-reflink rmap the impact of rmap btree
updates on log counts was not taken into account at all."

> +		 */
> +		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> +		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> +		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	}
> +
> +	/* Put everything back the way it was.  This goes at the end. */
> +	mp->m_rmap_maxlevels = rmap_maxlevels;
>  }

Yeah, so I think this should all go in xfs_log_rlimit.c as it is
specific to the minimum log size calculation.

> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 9fa4863f72a4..461859f4a745 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -73,7 +73,6 @@ struct xfs_trans_resv {
>  #define	XFS_DEFAULT_LOG_COUNT		1
>  #define	XFS_DEFAULT_PERM_LOG_COUNT	2
>  #define	XFS_ITRUNCATE_LOG_COUNT		2
> -#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
>  #define XFS_INACTIVE_LOG_COUNT		2
>  #define	XFS_CREATE_LOG_COUNT		2
>  #define	XFS_CREATE_TMPFILE_LOG_COUNT	2
> @@ -83,12 +82,15 @@ struct xfs_trans_resv {
>  #define	XFS_LINK_LOG_COUNT		2
>  #define	XFS_RENAME_LOG_COUNT		2
>  #define	XFS_WRITE_LOG_COUNT		2
> -#define	XFS_WRITE_LOG_COUNT_REFLINK	8
>  #define	XFS_ADDAFORK_LOG_COUNT		2
>  #define	XFS_ATTRINVAL_LOG_COUNT		1
>  #define	XFS_ATTRSET_LOG_COUNT		3
>  #define	XFS_ATTRRM_LOG_COUNT		3
>  
> +/* Absurdly high log counts from the early days of reflink.  Do not use. */
> +#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
> +#define	XFS_WRITE_LOG_COUNT_REFLINK	8

/*
 * Original log counts were overestimated in the early days of
 * reflink. These are retained here purely for minimum log size
 * calculations and are not to be used for runtime reservations.
 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

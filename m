Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A645BC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 23:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiDYXu7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 19:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDYXu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 19:50:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A55205FC
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEC12B81A2F
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 23:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B7CC385A7;
        Mon, 25 Apr 2022 23:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650930470;
        bh=FSbxZp5wkbaBQXFJLmXD/U3MpG+qYufU+1VoxM4hXz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZPvL+S0bOT+VgH4r1syUUtHGto97uIZAGPXol3ZRXHEvrmRcO3BLD153DLo8FyqKP
         biBBRv67ZXlPTWJofLdz1EmO/TqrWQj2YXChQa9gQeAuGiIXlXNwUXVgcirSFCm/Nt
         Ft2qFNnU3859qZ+i6Ke/uWK19ZuaVXqwhtt3CayI3rgSjGGCtoUwuexP+JjGC7XJe8
         copiFTnLrgy5BZxsikv4IBTdN+e/MpUrZ5n4kT00GFJOeOM4emrTThPXQGc95Uvqlm
         UTh3tMIzbmfkL0N7ly4lAYlyRxWlXXBXKnSINWLTtiWUeafNvrXXpRlmfh9SgvcYyr
         26QA/U3JeTX5g==
Date:   Mon, 25 Apr 2022 16:47:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: reduce the absurdly large log reservations
Message-ID: <20220425234749.GO17025@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688838.383881.2386659608282052005.stgit@magnolia>
 <20220422225152.GD1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422225152.GD1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 23, 2022 at 08:51:52AM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2022 at 03:54:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Back in the early days of reflink and rmap development I set the
> > transaction reservation sizes to be overly generous for rmap+reflink
> > filesystems, and a little under-generous for rmap-only filesystems.
> > 
> > Since we don't need *eight* transaction rolls to handle three new log
> > intent items, decrease the logcounts to what we actually need, and amend
> > the shadow reservation computation function to reflect what we used to
> > do so that the minimum log size doesn't change.
> 
> Yup, this will make a huge difference to the number of transactions
> we can have in flight on reflink/rmap enabled filesystems.
> 
> Mostly looks good, some comments about code and comments below.

Yay!

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_trans_resv.c |   88 +++++++++++++++++++++++++++-------------
> >  fs/xfs/libxfs/xfs_trans_resv.h |    6 ++-
> >  2 files changed, 64 insertions(+), 30 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 12d4e451e70e..8d2f04dddb65 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -814,36 +814,16 @@ xfs_trans_resv_calc(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_trans_resv	*resp)
> >  {
> > -	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> > -
> > -	/*
> > -	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> > -	 * to 9 even if the AG was small enough that it would never grow to
> > -	 * that height.  Transaction reservation sizes influence the minimum
> > -	 * log size calculation, which influences the size of the log that mkfs
> > -	 * creates.  Use the old value here to ensure that newly formatted
> > -	 * small filesystems will mount on older kernels.
> > -	 */
> > -	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> > -		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> > -
> >  	/*
> >  	 * The following transactions are logged in physical format and
> >  	 * require a permanent reservation on space.
> >  	 */
> >  	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
> > -	if (xfs_has_reflink(mp))
> > -		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> > -	else
> > -		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> >  	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> >  	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
> > -	if (xfs_has_reflink(mp))
> > -		resp->tr_itruncate.tr_logcount =
> > -				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
> > -	else
> > -		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> >  	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> >  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
> > @@ -900,10 +880,7 @@ xfs_trans_resv_calc(
> >  	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> >  	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
> > -	if (xfs_has_reflink(mp))
> > -		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> > -	else
> > -		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> >  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> >  	/*
> > @@ -930,8 +907,26 @@ xfs_trans_resv_calc(
> >  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
> >  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> >  
> > -	/* Put everything back the way it was.  This goes at the end. */
> > -	mp->m_rmap_maxlevels = rmap_maxlevels;
> > +	/* Add one logcount for BUI items that appear with rmap or reflink. */
> > +	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
> > +		resp->tr_itruncate.tr_logcount++;
> > +		resp->tr_write.tr_logcount++;
> > +		resp->tr_qm_dqalloc.tr_logcount++;
> > +	}
> > +
> > +	/* Add one logcount for refcount intent items. */
> > +	if (xfs_has_reflink(mp)) {
> > +		resp->tr_itruncate.tr_logcount++;
> > +		resp->tr_write.tr_logcount++;
> > +		resp->tr_qm_dqalloc.tr_logcount++;
> > +	}
> > +
> > +	/* Add one logcount for rmap intent items. */
> > +	if (xfs_has_rmapbt(mp)) {
> > +		resp->tr_itruncate.tr_logcount++;
> > +		resp->tr_write.tr_logcount++;
> > +		resp->tr_qm_dqalloc.tr_logcount++;
> > +	}
> 
> This would be much more concisely written as
> 
> 	count = 0;
> 	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) {
> 		count = 2;
> 		if (xfs_has_reflink(mp) && xfs_has_rmapbt(mp))
> 			count++;
> 	}
> 
> 	resp->tr_itruncate.tr_logcount += count;
> 	resp->tr_write.tr_logcount += count;
> 	resp->tr_qm_dqalloc.tr_logcount += count;

I think I'd rather do:

	/*
	 * Add one logcount for BUI items that appear with rmap or reflink,
	 * one logcount for refcount intent items, and one logcount for rmap
	 * intent items.
	 */
	if (xfs_has_reflink(mp) || xfs_has_rmapbt(mp))
		logcount_adj++;
	if (xfs_has_reflink(mp))
		logcount_adj++;
	if (xfs_has_rmapbt(mp))
		logcount_adj++;

	resp->tr_itruncate.tr_logcount += logcount_adj;
	resp->tr_write.tr_logcount += logcount_adj;
	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;

If you don't mind?

> 
> >  }
> >  
> >  /*
> > @@ -943,5 +938,42 @@ xfs_trans_resv_calc_logsize(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_trans_resv	*resp)
> >  {
> > +	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> > +
> > +	ASSERT(resp != M_RES(mp));
> > +
> > +	/*
> > +	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> > +	 * to 9 even if the AG was small enough that it would never grow to
> > +	 * that height.  Transaction reservation sizes influence the minimum
> > +	 * log size calculation, which influences the size of the log that mkfs
> > +	 * creates.  Use the old value here to ensure that newly formatted
> > +	 * small filesystems will mount on older kernels.
> > +	 */
> > +	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> > +		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> > +
> >  	xfs_trans_resv_calc(mp, resp);
> > +
> > +	if (xfs_has_reflink(mp)) {
> > +		/*
> > +		 * In the early days of reflink we set the logcounts absurdly
> > +		 * high.
> 
> "In the early days of reflink, typical operation log counts were
> greatly overestimated"

Fixed.

> > +		 */
> > +		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> > +		resp->tr_itruncate.tr_logcount =
> > +				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
> > +		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> > +	} else if (xfs_has_rmapbt(mp)) {
> > +		/*
> > +		 * In the early days of non-reflink rmap we set the logcount
> > +		 * too low.
> 
> "In the early days of non-reflink rmap the impact of rmap btree
> updates on log counts was not taken into account at all."

Fixed.

> > +		 */
> > +		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > +		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +	}
> > +
> > +	/* Put everything back the way it was.  This goes at the end. */
> > +	mp->m_rmap_maxlevels = rmap_maxlevels;
> >  }
> 
> Yeah, so I think this should all go in xfs_log_rlimit.c as it is
> specific to the minimum log size calculation.

Moved.

> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> > index 9fa4863f72a4..461859f4a745 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > @@ -73,7 +73,6 @@ struct xfs_trans_resv {
> >  #define	XFS_DEFAULT_LOG_COUNT		1
> >  #define	XFS_DEFAULT_PERM_LOG_COUNT	2
> >  #define	XFS_ITRUNCATE_LOG_COUNT		2
> > -#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
> >  #define XFS_INACTIVE_LOG_COUNT		2
> >  #define	XFS_CREATE_LOG_COUNT		2
> >  #define	XFS_CREATE_TMPFILE_LOG_COUNT	2
> > @@ -83,12 +82,15 @@ struct xfs_trans_resv {
> >  #define	XFS_LINK_LOG_COUNT		2
> >  #define	XFS_RENAME_LOG_COUNT		2
> >  #define	XFS_WRITE_LOG_COUNT		2
> > -#define	XFS_WRITE_LOG_COUNT_REFLINK	8
> >  #define	XFS_ADDAFORK_LOG_COUNT		2
> >  #define	XFS_ATTRINVAL_LOG_COUNT		1
> >  #define	XFS_ATTRSET_LOG_COUNT		3
> >  #define	XFS_ATTRRM_LOG_COUNT		3
> >  
> > +/* Absurdly high log counts from the early days of reflink.  Do not use. */
> > +#define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
> > +#define	XFS_WRITE_LOG_COUNT_REFLINK	8
> 
> /*
>  * Original log counts were overestimated in the early days of
>  * reflink. These are retained here purely for minimum log size
>  * calculations and are not to be used for runtime reservations.
>  */

Fixed, thanks. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

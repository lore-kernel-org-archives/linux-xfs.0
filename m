Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85F5C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 17:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A16A864E0C
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 17:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhA2Rtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 12:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhA2Rr5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Jan 2021 12:47:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3CDF64DFD;
        Fri, 29 Jan 2021 17:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611942436;
        bh=JrrEDvd/r7NVk0wLK49fSaYkQ2JWFxqLLcioOPaQIis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/J9uBYeZcdr7aWjNmmTJHHYBxIEfV4aORH6KBvdUPtNh95ZdGv2izL1o8R6g1mLC
         0iZJRlwdAt/RrPOrNXcxIv8hNrOyEusSVqOYhLH6f5vmBmGLGuCS9yrjUJX1VqgaXd
         AZ2+Eqgg9S3LtiCSQPLpk98MjXZlSKDAt3NiwoGO0DTtjZ2ns8jWJ57yICkjyf+A4J
         CYUfhx35T+z83JIn336OgyS/adddFGnzw6CUSb5vMDv/zuYh9l8sj54XaRgaVdZtVc
         uxgbNybnsVb9K1kIZaftSDW6GBKXp3QDErdkrN8LGRYrENG5K9FGroVsUDMKekUz/D
         sS0zmJeD2NfUg==
Date:   Fri, 29 Jan 2021 09:47:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210129174716.GI7695@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
 <161188670620.1943978.10940674429363795194.stgit@magnolia>
 <20210129160944.GE2665284@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129160944.GE2665284@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 29, 2021 at 11:09:44AM -0500, Brian Foster wrote:
> On Thu, Jan 28, 2021 at 06:18:26PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a fs modification (data write, reflink, xattr set, fallocate, etc.)
> > is unable to reserve enough quota to handle the modification, try
> > clearing whatever space the filesystem might have been hanging onto in
> > the hopes of speeding up the filesystem.  The flushing behavior will
> > become particularly important when we add deferred inode inactivation
> > because that will increase the amount of space that isn't actively tied
> > to user data.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_quota.h       |    7 +++--
> >  fs/xfs/xfs_reflink.c     |    7 ++++-
> >  fs/xfs/xfs_trans.c       |   12 +++++++-
> >  fs/xfs/xfs_trans_dquot.c |   69 ++++++++++++++++++++++++++++++++++++++++++----
> >  4 files changed, 84 insertions(+), 11 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 6c68635cc6ac..1217e6c41aa5 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> ...
> > @@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
> >  {
> >  	struct xfs_trans	*tp;
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	unsigned int		qretry = 0;
> >  	int			error;
> >  
> > +retry:
> >  	error = xfs_trans_alloc(mp, resv, dblocks,
> >  			rblocks / mp->m_sb.sb_rextsize,
> >  			force ? XFS_TRANS_RESERVE : 0, &tp);
> > @@ -1064,9 +1067,16 @@ xfs_trans_alloc_inode(
> >  		goto out_cancel;
> >  	}
> >  
> > -	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> > +	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force,
> > +			&qretry);
> >  	if (error)
> >  		goto out_cancel;
> > +	if (qretry) {
> > +		xfs_trans_cancel(tp);
> > +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +		xfs_blockgc_free_quota(ip, 0);
> > +		goto retry;
> > +	}
> 
> I'm not following why we need to plumb this retry logic down through the
> quota code and then down into a separate helper (which makes the whole
> thing rather circuitous at first glance). Can't we check for
> EDQUOT/ENOSPC here and retry using a local boolean?

Well now that I've rewritten the entry functions I guess this seems
obvious in retrospect.  Forest through the trees, etc. :)

Will change.

--D

> Brian
> 
> >  
> >  	*tpp = tp;
> >  	return 0;
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 73ef5994d09d..cb1fa4b047d6 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -770,11 +770,67 @@ xfs_trans_reserve_quota_bydquots(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Decide what to do after an attempt to reserve some quota.  This will set
> > + * the retry and error parameters as needed, and returns true if the quota
> > + * reservation succeeded.
> > + */
> > +static inline bool
> > +reservation_success(
> > +	unsigned int		qflag,
> > +	unsigned int		*retry,
> > +	int			*error)
> > +{
> > +	/*
> > +	 * The caller is not interested in retries.  Return whether or not we
> > +	 * got an error code.
> > +	 */
> > +	if (retry == NULL)
> > +		return *error == 0;
> > +
> > +	if (*error == -EDQUOT || *error == -ENOSPC) {
> > +		/*
> > +		 * There isn't enough quota left to allow the reservation.
> > +		 *
> > +		 * If none of the retry bits are set, this is the first time
> > +		 * that we failed a quota reservation.  Zero the error code and
> > +		 * set the appropriate quota flag in *retry to encourage the
> > +		 * xfs_trans_reserve_quota_nblks caller to clear some space and
> > +		 * call back.
> > +		 *
> > +		 * If any of the retry bits are set, this means that we failed
> > +		 * the quota reservation once before, tried to free some quota,
> > +		 * and have now failed the second quota reservation attempt.
> > +		 * Pass the error back to the caller; we're done.
> > +		 */
> > +		if (!(*retry))
> > +			*error = 0;
> > +
> > +		*retry |= qflag;
> > +		return false;
> > +	}
> > +
> > +	/* A non-quota error occurred; there is no retry. */
> > +	if (*error)
> > +		return false;
> > +
> > +	/*
> > +	 * The reservation succeeded.  Clear the quota flag from the retry
> > +	 * state because there is nothing to retry.
> > +	 */
> > +	*retry &= ~qflag;
> > +	return true;
> > +}
> >  
> >  /*
> > - * Lock the dquot and change the reservation if we can.
> > - * This doesn't change the actual usage, just the reservation.
> > - * The inode sent in is locked.
> > + * Lock the dquot and change the reservation if we can.  This doesn't change
> > + * the actual usage, just the reservation.  The caller must hold ILOCK_EXCL on
> > + * the inode.  If @retry is not a NULL pointer, the caller must ensure that
> > + * *retry is set to 0 before the first time this function is called.
> > + *
> > + * If the quota reservation fails because we hit a quota limit (and retry is
> > + * not a NULL pointer, and *retry is zero), this function will set *retry to
> > + * nonzero and return zero.
> >   */
> >  int
> >  xfs_trans_reserve_quota_nblks(
> > @@ -782,7 +838,8 @@ xfs_trans_reserve_quota_nblks(
> >  	struct xfs_inode	*ip,
> >  	int64_t			dblocks,
> >  	int64_t			rblocks,
> > -	bool			force)
> > +	bool			force,
> > +	unsigned int		*retry)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	unsigned int		qflags = 0;
> > @@ -801,14 +858,14 @@ xfs_trans_reserve_quota_nblks(
> >  	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> >  			ip->i_gdquot, ip->i_pdquot, dblocks, 0,
> >  			XFS_QMOPT_RES_REGBLKS | qflags);
> > -	if (error)
> > +	if (!reservation_success(XFS_QMOPT_RES_REGBLKS, retry, &error))
> >  		return error;
> >  
> >  	/* Do the same but for realtime blocks. */
> >  	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> >  			ip->i_gdquot, ip->i_pdquot, rblocks, 0,
> >  			XFS_QMOPT_RES_RTBLKS | qflags);
> > -	if (error) {
> > +	if (!reservation_success(XFS_QMOPT_RES_RTBLKS, retry, &error)) {
> >  		xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
> >  				ip->i_gdquot, ip->i_pdquot, -dblocks, 0,
> >  				XFS_QMOPT_RES_REGBLKS);
> > 
> 

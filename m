Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA898C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 17:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8206964DCC
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 17:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhBBRuI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237893AbhBBRsH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 12:48:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 789E764DCC;
        Tue,  2 Feb 2021 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612288046;
        bh=YFIR1EdG4Nzg3bjyh/l5VuicO2tjqC91d1183HWfT0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ctipVz52oQRaSljz8wz6+Fp9IDl/nLQvcd4islsLrYBFXiO3UZrhbJtR59Ty3wd2E
         5YyFW+ljxwywIcPL2UonEGr9OeEbqe24i7jDzXUfgmXSJpvA8ajyQGKWfNafefb9sv
         K3nBldUH1n4SA8p/lO293Y+pNpf+bouFAFA8q5yOh/EGMxoEfe+NqkwcVUcdQiODAa
         SBa+q0DK2FMqGhfqtnMyLND34ThKT/gHHVXb6L7UOdvq7aXfnVm3a6w2XAa01P59yw
         2bxhh9/jBP1Ybz1O42qC9nEtjAZYaikR2+03jYG0a9gasBBaO0m8Oz5wX1kGCtBdff
         cuu7g2P5BqfCA==
Date:   Tue, 2 Feb 2021 09:47:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 01/16] xfs: fix chown leaking delalloc quota blocks when
 fssetxattr fails
Message-ID: <20210202174726.GM7193@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223140369.491593.14536007914189520446.stgit@magnolia>
 <20210202131315.GB3336100@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202131315.GB3336100@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 08:13:15AM -0500, Brian Foster wrote:
> On Mon, Feb 01, 2021 at 06:03:23PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While refactoring the quota code to create a function to allocate inode
> > change transactions, I noticed that xfs_qm_vop_chown_reserve does more
> > than just make reservations: it also *modifies* the incore counts
> > directly to handle the owner id change for the delalloc blocks.
> > 
> > I then observed that the fssetxattr code continues validating input
> > arguments after making the quota reservation but before dirtying the
> > transaction.  If the routine decides to error out, it fails to undo the
> > accounting switch!  This leads to incorrect quota reservation and
> > failure down the line.
> > 
> > We can fix this by making the reservation function do only that -- for
> > the new dquot, it reserves ondisk and delalloc blocks to the
> > transaction, and the old dquot hangs on to its incore reservation for
> > now.  Once we actually switch the dquots, we can then update the incore
> > reservations because we've dirtied the transaction and it's too late to
> > turn back now.
> > 
> > No fixes tag because this has been broken since the start of git.
> > 
> 
> Do we have any test coverage for this problem?

Working on it, yeah.  The tricky part is finding a combination of
FSSETXATTR values that will reliably trigger an error return.  I think
it can be done by allocating delalloc blocks and then trying to set an
extent size hint and change the project id in a single call.

> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_qm.c |   91 +++++++++++++++++++++----------------------------------
> >  1 file changed, 34 insertions(+), 57 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index c134eb4aeaa8..322d337b5dca 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1785,6 +1785,28 @@ xfs_qm_vop_chown(
> >  	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
> >  	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
> >  
> > +	/*
> > +	 * Back when we made quota reservations for the chown, we reserved the
> > +	 * ondisk blocks + delalloc blocks with the new dquot.  Now that we've
> > +	 * switched the dquots, decrease the new dquot's block reservation
> > +	 * (having already bumped up the real counter) so that we don't have
> > +	 * any reservation to give back when we commit.
> > +	 */
> > +	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
> > +			-ip->i_delayed_blks);
> > +
> 
> Ok, so the reservation code code below continues to reserve di_blocks
> and delalloc blocks as it did before, but associates it with the
> transaction and no longer reduces delalloc reservation from the old
> dquots. Instead, this function increases the consumption of reserved
> blocks for di_blocks and then removes the additional quota reservation
> from the transaction, but not the new dquots. Thus when the transaction
> commits, this has the side effect of leaving additional reservation on
> the new dquots that correspond to the delalloc blocks on the inode. Am I
> following that correctly?

Correct.

> > +	/*
> > +	 * Give the incore reservation for delalloc blocks back to the old
> > +	 * dquot.  We don't normally handle delalloc quota reservations
> > +	 * transactionally, so just lock the dquot and subtract from the
> > +	 * reservation.  We've dirtied the transaction, so it's too late to
> > +	 * turn back now.
> > +	 */
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	xfs_dqlock(prevdq);
> > +	prevdq->q_blk.reserved -= ip->i_delayed_blks;
> > +	xfs_dqunlock(prevdq);
> > +
> 
> What's the reason for not using xfs_trans_reserve_quota_bydquots(NULL,
> ...) here like the original code?

xfs_trans_reserve_quota_bydquots() makes the caller pass in user, group,
and project dquots.  It's not difficult to add more code to declare and
route parameters, but that just felt overdone.

Given that this is the only place in the codebase where we want to
change the incore quota reservation on a single dquot, I also didn't
think it was worth making a whole new function.

FWIW I don't really mind doing it, it just seemed like more work.
Alternately I suppose I could expose xfs_trans_dqresv.

--D

> Brian
> 
> >  	/*
> >  	 * Take an extra reference, because the inode is going to keep
> >  	 * this dquot pointer even after the trans_commit.
> > @@ -1807,84 +1829,39 @@ xfs_qm_vop_chown_reserve(
> >  	uint			flags)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > -	uint64_t		delblks;
> >  	unsigned int		blkflags;
> > -	struct xfs_dquot	*udq_unres = NULL;
> > -	struct xfs_dquot	*gdq_unres = NULL;
> > -	struct xfs_dquot	*pdq_unres = NULL;
> >  	struct xfs_dquot	*udq_delblks = NULL;
> >  	struct xfs_dquot	*gdq_delblks = NULL;
> >  	struct xfs_dquot	*pdq_delblks = NULL;
> > -	int			error;
> > -
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> >  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> >  
> > -	delblks = ip->i_delayed_blks;
> >  	blkflags = XFS_IS_REALTIME_INODE(ip) ?
> >  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
> >  
> >  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> > -	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
> > +	    i_uid_read(VFS_I(ip)) != udqp->q_id)
> >  		udq_delblks = udqp;
> > -		/*
> > -		 * If there are delayed allocation blocks, then we have to
> > -		 * unreserve those from the old dquot, and add them to the
> > -		 * new dquot.
> > -		 */
> > -		if (delblks) {
> > -			ASSERT(ip->i_udquot);
> > -			udq_unres = ip->i_udquot;
> > -		}
> > -	}
> > +
> >  	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
> > -	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
> > +	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
> >  		gdq_delblks = gdqp;
> > -		if (delblks) {
> > -			ASSERT(ip->i_gdquot);
> > -			gdq_unres = ip->i_gdquot;
> > -		}
> > -	}
> >  
> >  	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
> > -	    ip->i_d.di_projid != pdqp->q_id) {
> > +	    ip->i_d.di_projid != pdqp->q_id)
> >  		pdq_delblks = pdqp;
> > -		if (delblks) {
> > -			ASSERT(ip->i_pdquot);
> > -			pdq_unres = ip->i_pdquot;
> > -		}
> > -	}
> > -
> > -	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
> > -				udq_delblks, gdq_delblks, pdq_delblks,
> > -				ip->i_d.di_nblocks, 1, flags | blkflags);
> > -	if (error)
> > -		return error;
> >  
> >  	/*
> > -	 * Do the delayed blks reservations/unreservations now. Since, these
> > -	 * are done without the help of a transaction, if a reservation fails
> > -	 * its previous reservations won't be automatically undone by trans
> > -	 * code. So, we have to do it manually here.
> > +	 * Reserve enough quota to handle blocks on disk and reserved for a
> > +	 * delayed allocation.  We'll actually transfer the delalloc
> > +	 * reservation between dquots at chown time, even though that part is
> > +	 * only semi-transactional.
> >  	 */
> > -	if (delblks) {
> > -		/*
> > -		 * Do the reservations first. Unreservation can't fail.
> > -		 */
> > -		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
> > -		ASSERT(udq_unres || gdq_unres || pdq_unres);
> > -		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> > -			    udq_delblks, gdq_delblks, pdq_delblks,
> > -			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
> > -		if (error)
> > -			return error;
> > -		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
> > -				udq_unres, gdq_unres, pdq_unres,
> > -				-((xfs_qcnt_t)delblks), 0, blkflags);
> > -	}
> > -
> > -	return 0;
> > +	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
> > +			gdq_delblks, pdq_delblks,
> > +			ip->i_d.di_nblocks + ip->i_delayed_blks,
> > +			1, blkflags | flags);
> >  }
> >  
> >  int
> > 
> 

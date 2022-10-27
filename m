Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6862ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbiJ0VmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiJ0VmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:42:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B8D79EFD
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CA1DB827B3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 21:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC34FC433D7;
        Thu, 27 Oct 2022 21:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666906934;
        bh=AE+KK6UbcSxR0dFLx9tO3R1mNu2TfVkkndSL3jfefvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GXpZZNmk5/KcD8iYrWhDVI2w9xOqm3om3hXcJyqdbirRbCLWxBHvctZUGPNbPj/iu
         9BP0FWpEO9Vl/Cyj8+STFSWuwk+0l/NWTOC3Fb0xsaQQR/oRMvQSJuQ3LlNE8jmKop
         yhyH8RH+csQ9WKmNOuUN2EXpnGOu3+Fack+whHYJhPTFqIwwa88C4kXw/nLa0yfUF4
         5T0TXv+Equq9xMJXbHaiFAqGLUuBA7nzZVAHbdUcjsiAM5/kGKvt4F/gDjDNrINEy3
         0q4D1BH1izxRIA7NQjH13wEbIvkNbwicwKKj7CKI7v1qiYysz953UT7RxM3mfO3bGr
         TKXt0aiGIxMfw==
Date:   Thu, 27 Oct 2022 14:42:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: check deferred refcount op continuation
 parameters
Message-ID: <Y1r7NkJqvoWPAsAs@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689085464.3788582.2756559047908250104.stgit@magnolia>
 <20221027204957.GR3600936@dread.disaster.area>
 <Y1r4+k5uKQBySEta@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1r4+k5uKQBySEta@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 02:32:42PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 28, 2022 at 07:49:57AM +1100, Dave Chinner wrote:
> > On Thu, Oct 27, 2022 at 10:14:14AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If we're in the middle of a deferred refcount operation and decide to
> > > roll the transaction to avoid overflowing the transaction space, we need
> > > to check the new agbno/aglen parameters that we're about to record in
> > > the new intent.  Specifically, we need to check that the new extent is
> > > completely within the filesystem, and that continuation does not put us
> > > into a different AG.
> > > 
> > > If the keys of a node block are wrong, the lookup to resume an
> > > xfs_refcount_adjust_extents operation can put us into the wrong record
> > > block.  If this happens, we might not find that we run out of aglen at
> > > an exact record boundary, which will cause the loop control to do the
> > > wrong thing.
> > > 
> > > The previous patch should take care of that problem, but let's add this
> > > extra sanity check to stop corruption problems sooner than later.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_refcount.c |   48 ++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 46 insertions(+), 2 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > index 831353ba96dc..c6aa832a8713 100644
> > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > @@ -1138,6 +1138,44 @@ xfs_refcount_finish_one_cleanup(
> > >  		xfs_trans_brelse(tp, agbp);
> > >  }
> > >  
> > > +/*
> > > + * Set up a continuation a deferred refcount operation by updating the intent.
> > > + * Checks to make sure we're not going to run off the end of the AG.
> > > + */
> > > +static inline int
> > > +xfs_refcount_continue_op(
> > > +	struct xfs_btree_cur		*cur,
> > > +	xfs_fsblock_t			startblock,
> > > +	xfs_agblock_t			new_agbno,
> > > +	xfs_extlen_t			new_len,
> > > +	xfs_fsblock_t			*fsbp)
> > > +{
> > > +	struct xfs_mount		*mp = cur->bc_mp;
> > > +	struct xfs_perag		*pag = cur->bc_ag.pag;
> > > +	xfs_fsblock_t			new_fsbno;
> > > +	xfs_agnumber_t			old_agno;
> > > +
> > > +	old_agno = XFS_FSB_TO_AGNO(mp, startblock);
> > > +	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
> > > +
> > > +	/*
> > > +	 * If we don't have any work left to do, then there's no need
> > > +	 * to perform the validation of the new parameters.
> > > +	 */
> > > +	if (!new_len)
> > > +		goto done;
> > 
> > Shouldn't we be validating new_fsbno rather than just returning
> > whatever we calculated here?

Thinking further about this, let's elide the call if there isn't any
work to continue.

IOWs, the function shortens to:

static inline int
xfs_refcount_continue_op(
	struct xfs_btree_cur		*cur,
	xfs_fsblock_t			startblock,
	xfs_agblock_t			new_agbno,
	xfs_extlen_t			new_len,
	xfs_fsblock_t			*fsbp)
{
	struct xfs_mount		*mp = cur->bc_mp;
	struct xfs_perag		*pag = cur->bc_ag.pag;
	xfs_fsblock_t			new_fsbno;

	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);

	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
		return -EFSCORRUPTED;

	if (XFS_IS_CORRUPT(mp, pag->pag_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
		return -EFSCORRUPTED;

	*fsbp = new_fsbno;
	return 0;
}

and the call sites now look like:

	error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
			new_len, XFS_REFCOUNT_ADJUST_INCREASE);
	if (error)
		goto out_drop;
	if (*new_len > 0)
		error = xfs_refcount_continue_op(rcur, startblock,
				new_agbno, *new_len, new_fsb);

--D

> No.  Imagine that the deferred work is performed against the last 30
> blocks of the last AG in the filesystem.  Let's say that the last AG is
> AG 3 and the AG has 100 blocks.  fsblock 3:99 is the last fsblock in the
> filesystem.
> 
> Before we start the deferred work, startblock == 3:70 and
> blockcount == 30.  We adjust the refcount of those 30 blocks, so we're
> done now.  The adjust function passes out new_agbno == 70 + 30 and
> new_len == 30 - 30.
> 
> The agbno to fsbno conversion sets new_fsbno to 3:100 and new_len is 0.
> However, fsblock 3/100 is one block past the end of both AG 3 and the
> filesystem, so the check below will fail:
> 
> > > +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
> > > +		return -EFSCORRUPTED;
> > > +
> > > +	if (XFS_IS_CORRUPT(mp, old_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
> > > +		return -EFSCORRUPTED;
> > 
> > We already know what agno new_fsbno sits in - we calculated it
> > directly from pag->pag_agno above, so this can jsut check against
> > pag->pag_agno directly, right?
> 
> We don't actually know what agno new_fsbno sits in because of the way
> that the agblock -> fsblock conversion works:
> 
> #define XFS_AGB_TO_FSB(mp,agno,agbno)	\
> 	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
> 
> Notice how we don't mask off the bits of agbno above sb_agblklog?  If
> sb_agblklog is (say) 20 but agbno has bit 31 set, that bit 31 will bump
> the AG number by 2^11 AGs.
> 
> The genesis of this patch was from the old days when rc_startblock had
> bit 31 set on COW staging extents.  Splitting out the cow/shared domain
> later in the series makes this patch sort of redundant, but I still want
> to catch the cases where agbno has some bit set above agblklog due to
> corruption/bitflips/shenanigans.
> 
> > i.e.
> > 
> > 	if (XFS_IS_CORRUPT(mp,
> > 			XFS_FSB_TO_AGNO(mp, startblock) != pag->pag_agno))
> > 		return -EFSCORRUPTED;
> > 
> > and we don't need the local variable for it....
> 
> Not quite -- we need to compare new_fsbno's agnumber against the perag
> structure.  But you're right that @old_agno isn't necessary.
> 
> 	if (XFS_IS_CORRUPT(mp,
> 			XFS_FSB_TO_AGNO(mp, new_fsbno) != pag->pag_agno))
> 		/* fail */
> 
> I'll change it to the above.
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com

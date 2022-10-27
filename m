Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9E2ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 23:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiJ0XZ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 19:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiJ0XZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 19:25:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF9482868
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 16:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 602E8CE24CE
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 23:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815DBC433C1;
        Thu, 27 Oct 2022 23:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666913136;
        bh=5UPsOwUR/AAKA3LF+WJoVOiPRvvvQiiVZ/GQOtKz+V4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ElbcDh9dUMDYZjlwOw1AvMhBFS68gTw9k5GPTk8rCIg3+BjESAzcGSl08KnekIpYH
         5aggbvyoOO4r8Fq1J/C/GBbd/2eiLWKg11LBaV9568H97Vaha5hQWISaafg6VppFIv
         8yIFYAezLchQyNKEbHcra+0fMN7rAnz0PJaz2pLPVFD5J3Whqb/xidd8qHaC7RwlYP
         6beoIvNs6VuRR4M5+AOFSq52BIquzh91VtnH0fThdkSIQhHFcsfpN88CbdZ/5tIbPE
         3LnDeEP/70ba10Y1KsDYB2PeRZhNUMaanpD/yLB1WOiGcADO1QxTk6ixHHCxeC9jzi
         NWloj67owLuww==
Date:   Thu, 27 Oct 2022 16:25:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: check deferred refcount op continuation
 parameters
Message-ID: <Y1sTcJx4qCdZ6MkF@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689085464.3788582.2756559047908250104.stgit@magnolia>
 <20221027204957.GR3600936@dread.disaster.area>
 <Y1r4+k5uKQBySEta@magnolia>
 <20221027222403.GB3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027222403.GB3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 09:24:03AM +1100, Dave Chinner wrote:
> On Thu, Oct 27, 2022 at 02:32:42PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 28, 2022 at 07:49:57AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 27, 2022 at 10:14:14AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > If we're in the middle of a deferred refcount operation and decide to
> > > > roll the transaction to avoid overflowing the transaction space, we need
> > > > to check the new agbno/aglen parameters that we're about to record in
> > > > the new intent.  Specifically, we need to check that the new extent is
> > > > completely within the filesystem, and that continuation does not put us
> > > > into a different AG.
> > > > 
> > > > If the keys of a node block are wrong, the lookup to resume an
> > > > xfs_refcount_adjust_extents operation can put us into the wrong record
> > > > block.  If this happens, we might not find that we run out of aglen at
> > > > an exact record boundary, which will cause the loop control to do the
> > > > wrong thing.
> > > > 
> > > > The previous patch should take care of that problem, but let's add this
> > > > extra sanity check to stop corruption problems sooner than later.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_refcount.c |   48 ++++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 46 insertions(+), 2 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > > index 831353ba96dc..c6aa832a8713 100644
> > > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > > @@ -1138,6 +1138,44 @@ xfs_refcount_finish_one_cleanup(
> > > >  		xfs_trans_brelse(tp, agbp);
> > > >  }
> > > >  
> > > > +/*
> > > > + * Set up a continuation a deferred refcount operation by updating the intent.
> > > > + * Checks to make sure we're not going to run off the end of the AG.
> > > > + */
> > > > +static inline int
> > > > +xfs_refcount_continue_op(
> > > > +	struct xfs_btree_cur		*cur,
> > > > +	xfs_fsblock_t			startblock,
> > > > +	xfs_agblock_t			new_agbno,
> > > > +	xfs_extlen_t			new_len,
> > > > +	xfs_fsblock_t			*fsbp)
> > > > +{
> > > > +	struct xfs_mount		*mp = cur->bc_mp;
> > > > +	struct xfs_perag		*pag = cur->bc_ag.pag;
> > > > +	xfs_fsblock_t			new_fsbno;
> > > > +	xfs_agnumber_t			old_agno;
> > > > +
> > > > +	old_agno = XFS_FSB_TO_AGNO(mp, startblock);
> > > > +	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
> > > > +
> > > > +	/*
> > > > +	 * If we don't have any work left to do, then there's no need
> > > > +	 * to perform the validation of the new parameters.
> > > > +	 */
> > > > +	if (!new_len)
> > > > +		goto done;
> > > 
> > > Shouldn't we be validating new_fsbno rather than just returning
> > > whatever we calculated here?
> > 
> > No.  Imagine that the deferred work is performed against the last 30
> > blocks of the last AG in the filesystem.  Let's say that the last AG is
> > AG 3 and the AG has 100 blocks.  fsblock 3:99 is the last fsblock in the
> > filesystem.
> > 
> > Before we start the deferred work, startblock == 3:70 and
> > blockcount == 30.  We adjust the refcount of those 30 blocks, so we're
> > done now.  The adjust function passes out new_agbno == 70 + 30 and
> > new_len == 30 - 30.
> > 
> > The agbno to fsbno conversion sets new_fsbno to 3:100 and new_len is 0.
> > However, fsblock 3/100 is one block past the end of both AG 3 and the
> > filesystem, so the check below will fail:
> 
> Sure, but my point here is that the function returns this invalid
> fsbno in *fsbp and assumes that the caller will handle it correctly.
> 
> If the caller knows that we aren't going to continue past the
> "new_len == 0" condition, then why is it even calling this function?
> i.e. this isn't a "decide if we are going to continue" function,
> it's a "calculate and validate next fsbno" function...
> 
> i.e. the intent doesn't match the name of the function.

<nod> Well I've already moved the if test to the callsite, so I hope
that'll be less confusing.

> 
> > > > +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
> > > > +		return -EFSCORRUPTED;
> > > > +
> > > > +	if (XFS_IS_CORRUPT(mp, old_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
> > > > +		return -EFSCORRUPTED;
> > > 
> > > We already know what agno new_fsbno sits in - we calculated it
> > > directly from pag->pag_agno above, so this can jsut check against
> > > pag->pag_agno directly, right?
> > 
> > We don't actually know what agno new_fsbno sits in because of the way
> > that the agblock -> fsblock conversion works:
> > 
> > #define XFS_AGB_TO_FSB(mp,agno,agbno)	\
> > 	(((xfs_fsblock_t)(agno) << (mp)->m_sb.sb_agblklog) | (agbno))
> 
> Sure, but FSBs are *sparse* and there is unused, unchecked address
> space between the AGs that agbno overruns can fall into. And when we
> look at XFS_FSB_TO_AGNO():
> 
> #define XFS_FSB_TO_AGNO(mp,fsbno)       \
>         ((xfs_agnumber_t)((fsbno) >> (mp)->m_sb.sb_agblklog))
> 
> we can see that it simply truncates away the agbno portion to get
> back to the agno.
> 
> IOWs:
> 
> 	0			sb_agblocks
> 	+--------------------------+------------+
> 					(1 << sb_agblklog)
> 				   +------------+
> 				   invalid agbnos!
> 
> Hence the agbno needs to be checked agains sb_agblocks to capture AG
> overruns, not converted to a FSB and back to an AGNO as this will
> claim agbnos in the inaccessible address space region between AGs
> are valid....
> 
> > Notice how we don't mask off the bits of agbno above sb_agblklog?  If
> > sb_agblklog is (say) 20 but agbno has bit 31 set, that bit 31 will bump
> > the AG number by 2^11 AGs.
> 
> Yes, but that's only a side effect of the agbno having the high bit
> set - it could have many other bits set and still be out of range.
> i.e. coverting to fsb and back to agno doesn't actually capture all
> cases of the next calculated agbno/fsbno could be invalid.
> 
> xfs_verify_fsbext() may capture this by chance because it checks
> the entire agbno portion of the fsb (via XFS_FSB_TO_AGBNO) against
> xfs_ag_block_count(agno), but it won't capture the overruns that
> only bump the AGNO portion of the FSB.
> 
> Hence I really think we should be checking new_agbno for validity
> here, not relying on side effects of coverting to/from FSBs and
> verifying fsb extents to capture ag block count overruns in the
> supplied agbno....

Oh, ok.  So you want to check the new agbno and new aglen to make sure
that both are within the filesystem and whatnot *before* we call
XFS_AGB_TO_FSBNO, rather than checking the fsblock after the conversion?

I can do that.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

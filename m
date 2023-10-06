Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBFEE92FE6
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 05:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjJFFSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 01:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjJFFSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 01:18:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02594BF
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 22:18:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9179AC433C7;
        Fri,  6 Oct 2023 05:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696569494;
        bh=OhNybaIKUUmEv1o6GRzmpmfUSrwsxxOx5mUxO7Gq+1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iw92ao2b/FVPzsz6l/+GIhUkK+BfEN4eQficqG42Xi/ALrKp1w5pkVixooDr8oIdh
         RfN4ad75ua5UMSsECK2yy4PmwULgYhh6jt2ZPs3irk1vT4sbcR2VBfoCgvhy06wJCD
         XLQorF3V1QT1nVhwurdlKHaK6UEl2JfOW4I4cxsmdF1YsPMVnVLrOXyaUwyN1gSt7N
         tgtSFvtZDm8DJ06AX2PZ1MGQbo7z1Hkn5bM9zOkyEKVTxoYurRfdYH9PjJbL+uPzeu
         BDSqT9n2Am7jZkW9VRfDBedzsb4DV0zaWfZS/nHSD64zKzUoblpskUhDF9o9ZxZK2f
         Yo34crQ9yeT4A==
Date:   Thu, 5 Oct 2023 22:18:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <20231006051813.GS21298@frogsfrogsfrogs>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059224.3312911.3596538645136769266.stgit@frogsfrogsfrogs>
 <ZR5BNt6BfBcpp1c+@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR5BNt6BfBcpp1c+@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2023 at 03:53:10PM +1100, Dave Chinner wrote:
> On Tue, Sep 26, 2023 at 04:32:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new xrep_newbt structure to encapsulate a fake root for
> > creating a staged btree cursor as well as to track all the blocks that
> > we need to reserve in order to build that btree.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/Makefile                   |    1 
> >  fs/xfs/libxfs/xfs_btree_staging.h |    7 -
> >  fs/xfs/scrub/agheader_repair.c    |    1 
> >  fs/xfs/scrub/common.c             |    1 
> >  fs/xfs/scrub/newbt.c              |  492 +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/newbt.h              |   62 +++++
> >  fs/xfs/scrub/scrub.c              |    2 
> >  fs/xfs/scrub/trace.h              |   37 +++
> >  8 files changed, 598 insertions(+), 5 deletions(-)
> >  create mode 100644 fs/xfs/scrub/newbt.c
> >  create mode 100644 fs/xfs/scrub/newbt.h
> 
> Looks reasonable to me. It all makes sense and nothing is obviously
> wrong.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

> 
> Some notes on the extent allocation API bits - the rework of the
> high level allocation primitives I just posted intersects with this
> code in some interesting ways....
> 
> > +
> > +/* Allocate disk space for a new per-AG btree. */
> > +STATIC int
> > +xrep_newbt_alloc_ag_blocks(
> > +	struct xrep_newbt	*xnr,
> > +	uint64_t		nr_blocks)
> > +{
> > +	struct xfs_scrub	*sc = xnr->sc;
> > +	struct xfs_mount	*mp = sc->mp;
> > +	int			error = 0;
> > +
> > +	ASSERT(sc->sa.pag != NULL);
> > +
> > +	while (nr_blocks > 0) {
> > +		struct xfs_alloc_arg	args = {
> > +			.tp		= sc->tp,
> > +			.mp		= mp,
> > +			.oinfo		= xnr->oinfo,
> > +			.minlen		= 1,
> > +			.maxlen		= nr_blocks,
> > +			.prod		= 1,
> > +			.resv		= xnr->resv,
> > +		};
> > +		xfs_agnumber_t		agno;
> > +
> > +		xrep_newbt_validate_ag_alloc_hint(xnr);
> > +
> > +		error = xfs_alloc_vextent_near_bno(&args, xnr->alloc_hint);
> 
> This would require a perag to be held by the caller (sc->sa.pag)
> and attached to the args. The target also changes to an agbno
> (IIRC).

<nod> Pretty straightforward.

> > +		if (error)
> > +			return error;
> > +		if (args.fsbno == NULLFSBLOCK)
> > +			return -ENOSPC;
> 
> This will need to change to handling ENOSPC as the error directly on
> failure.

<nod>

> > +
> > +		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
> > +
> > +		trace_xrep_newbt_alloc_ag_blocks(mp, agno,
> > +				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
> > +				xnr->oinfo.oi_owner);
> > +
> > +		if (agno != sc->sa.pag->pag_agno) {
> > +			ASSERT(agno == sc->sa.pag->pag_agno);
> > +			return -EFSCORRUPTED;
> > +		}
> 
> This can go away, because it simply isn't possible - it will
> allocate a block in sc->sa.pag or fail with ENOSPC.
> 
> Hence this will probably simplify down a bit.

Yessssssss

> > +
> > +		error = xrep_newbt_add_blocks(xnr, sc->sa.pag, &args);
> > +		if (error)
> > +			return error;
> > +
> > +		nr_blocks -= args.len;
> > +		xnr->alloc_hint = args.fsbno + args.len;
> > +
> > +		error = xrep_defer_finish(sc);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Don't let our allocation hint take us beyond EOFS */
> > +static inline void
> > +xrep_newbt_validate_file_alloc_hint(
> > +	struct xrep_newbt	*xnr)
> > +{
> > +	struct xfs_scrub	*sc = xnr->sc;
> > +
> > +	if (xfs_verify_fsbno(sc->mp, xnr->alloc_hint))
> > +		return;
> > +
> > +	xnr->alloc_hint = XFS_AGB_TO_FSB(sc->mp, 0, XFS_AGFL_BLOCK(sc->mp) + 1);
> > +}
> > +
> > +/* Allocate disk space for our new file-based btree. */
> > +STATIC int
> > +xrep_newbt_alloc_file_blocks(
> > +	struct xrep_newbt	*xnr,
> > +	uint64_t		nr_blocks)
> > +{
> > +	struct xfs_scrub	*sc = xnr->sc;
> > +	struct xfs_mount	*mp = sc->mp;
> > +	int			error = 0;
> > +
> > +	while (nr_blocks > 0) {
> > +		struct xfs_alloc_arg	args = {
> > +			.tp		= sc->tp,
> > +			.mp		= mp,
> > +			.oinfo		= xnr->oinfo,
> > +			.minlen		= 1,
> > +			.maxlen		= nr_blocks,
> > +			.prod		= 1,
> > +			.resv		= xnr->resv,
> > +		};
> > +		struct xfs_perag	*pag;
> > +		xfs_agnumber_t		agno;
> > +
> > +		xrep_newbt_validate_file_alloc_hint(xnr);
> > +
> > +		error = xfs_alloc_vextent_start_ag(&args, xnr->alloc_hint);
> > +		if (error)
> > +			return error;
> > +		if (args.fsbno == NULLFSBLOCK)
> > +			return -ENOSPC;
> 
> Similar target/errno changes will be needed here, and ....
> > +
> > +		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
> > +
> > +		trace_xrep_newbt_alloc_file_blocks(mp, agno,
> > +				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
> > +				xnr->oinfo.oi_owner);
> > +
> > +		pag = xfs_perag_get(mp, agno);
> > +		if (!pag) {
> > +			ASSERT(0);
> > +			return -EFSCORRUPTED;
> > +		}
> > +
> > +		error = xrep_newbt_add_blocks(xnr, pag, &args);
> > +		xfs_perag_put(pag);
> > +		if (error)
> > +			return error;
> 
> I suspect it might be useful to have xfs_alloc_vextent_start_ag() be
> able to return the referenced perag that the allocation occurred in
> rather than having to split the result and look it up again....

Yeah, I think it's reasonable to return an active(?) reference to the
perag that we picked and the space allocated from that AG.

> Hust a heads up for now, thought, we can deal with these issues when
> merging for one or the other happens...

Ok.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

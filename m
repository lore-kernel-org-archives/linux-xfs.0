Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB10C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 23:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiDYXwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 19:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDYXwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 19:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C63D1102AC
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 16:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C08F4B81A2F
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 23:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56083C385A4;
        Mon, 25 Apr 2022 23:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650930578;
        bh=4QIrPKIPdODqxmfX+26GuiG1TCq7G+Ld7OhuYspGngU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwd36TKVB7vYzvY+Dr9UBtcnWUpCmrvCXj70Tqh/xAG7ZlcAfDIbJpzps3YaYCjV1
         DEhyPBBppVQfE7YFXjyMxnLr0Yz0MofICPxogsHWZQuMUrjMQqjeqqvcGhVzyA3Ov9
         m3NBYM5I9ng0uxV9kaEU27VO+DeQcHeHrFX0QlNcuoJwOxiD82bmr/qWwfnYYwYsC4
         gJjNjxsmv9cNaWRy3qgs2HtShiEyX7AIcCxCkshcjtpxIsNRMY3VmYprsT8OBjnxG1
         egVPH3PhgFBHWxN4l+K2I87O5sgaEaj+J3yEtgrCh80MxyeoNwdjhXmYlqw1H008NM
         iI6yekklPt7zQ==
Date:   Mon, 25 Apr 2022 16:49:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: reduce transaction reservations with reflink
Message-ID: <20220425234937.GP17025@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997689398.383881.16693790752445073096.stgit@magnolia>
 <20220422234238.GE1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422234238.GE1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 23, 2022 at 09:42:38AM +1000, Dave Chinner wrote:
> On Thu, Apr 14, 2022 at 03:54:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Before to the introduction of deferred refcount operations, reflink
> > would try to cram refcount btree updates into the same transaction as an
> > allocation or a free event.  Mainline XFS has never actually done that,
> > but we never refactored the transaction reservations to reflect that we
> > now do all refcount updates in separate transactions.  Fix this to
> > reduce the transaction reservation size even farther, so that between
> > this patch and the previous one, we reduce the tr_write and tr_itruncate
> > sizes by 66%.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_refcount.c   |    9 +++-
> >  fs/xfs/libxfs/xfs_trans_resv.c |   97 ++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 98 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index a07ebaecba73..e53544d52ee2 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -886,8 +886,13 @@ xfs_refcount_still_have_space(
> >  {
> >  	unsigned long			overhead;
> >  
> > -	overhead = cur->bc_ag.refc.shape_changes *
> > -			xfs_allocfree_log_count(cur->bc_mp, 1);
> > +	/*
> > +	 * Worst case estimate: full splits of the free space and rmap btrees
> > +	 * to handle each of the shape changes to the refcount btree.
> > +	 */
> > +	overhead = xfs_allocfree_log_count(cur->bc_mp,
> > +				cur->bc_ag.refc.shape_changes);
> > +	overhead += cur->bc_mp->m_refc_maxlevels;
> >  	overhead *= cur->bc_mp->m_sb.sb_blocksize;
> >  
> >  	/*
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 8d2f04dddb65..e5c3fcc2ab15 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -56,8 +56,7 @@ xfs_calc_buf_res(
> >   * Per-extent log reservation for the btree changes involved in freeing or
> >   * allocating an extent.  In classic XFS there were two trees that will be
> >   * modified (bnobt + cntbt).  With rmap enabled, there are three trees
> > - * (rmapbt).  With reflink, there are four trees (refcountbt).  The number of
> > - * blocks reserved is based on the formula:
> > + * (rmapbt).  The number of blocks reserved is based on the formula:
> >   *
> >   * num trees * ((2 blocks/level * max depth) - 1)
> >   *
> > @@ -73,12 +72,23 @@ xfs_allocfree_log_count(
> >  	blocks = num_ops * 2 * (2 * mp->m_alloc_maxlevels - 1);
> >  	if (xfs_has_rmapbt(mp))
> >  		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
> > -	if (xfs_has_reflink(mp))
> > -		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
> >  
> >  	return blocks;
> >  }
> >  
> > +/*
> > + * Per-extent log reservation for refcount btree changes.  These are never done
> > + * in the same transaction as an allocation or a free, so we compute them
> > + * separately.
> > + */
> > +static unsigned int
> > +xfs_refcount_log_count(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		num_ops)
> > +{
> > +	return num_ops * (2 * mp->m_refc_maxlevels - 1);
> > +}
> 
> This is a block count, right? My brain just went "spoing!" because I
> was just looking at transaction reservation log counts, and here we
> have a "log count" reservation that isn't a reservation log count
> but a block count used to calculate the transaction unit
> reservation...
> 
> Yeah, I know, that's my fault for naming xfs_allocfree_log_count()
> the way I did way back when, but I think this really should tell the
> reader it is returning a block count for the refcount btree mods.
> 
> Maybe xfs_refcountbt_block_count(), perhaps?

Ok.  I'll add in another patch to rename xfs_allocfree_log_count at the
end.

> > + * Compute the log reservation required to handle the refcount update
> > + * transaction.  Refcount updates are always done via deferred log items.
> > + *
> > + * This is calculated as:
> > + * Data device refcount updates (t1):
> > + *    the agfs of the ags containing the blocks: nr_ops * sector size
> > + *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
> > + */
> > +static unsigned int
> > +xfs_refcount_log_reservation(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		nr_ops)
> > +{
> > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > +
> > +	if (!xfs_has_reflink(mp))
> > +		return 0;
> > +
> > +	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
> > +	       xfs_calc_buf_res(xfs_refcount_log_count(mp, nr_ops), blksz);
> > +}
> 
> To follow convention, this calculates a reservation in bytes, so
> xfs_calc_refcountbt_reservation() would match all the other
> functions that do similar things...

Fixed.

> .....
> 
> > @@ -303,10 +338,42 @@ xfs_calc_write_reservation(
> >   *    the realtime summary: 2 exts * 1 block
> >   *    worst case split in allocation btrees per extent assuming 2 extents:
> >   *		2 exts * 2 trees * (2 * max depth - 1) * block size
> > + * And any refcount updates that happen in a separate transaction (t4).
> >   */
> >  STATIC uint
> >  xfs_calc_itruncate_reservation(
> >  	struct xfs_mount	*mp)
> > +{
> > +	unsigned int		t1, t2, t3, t4;
> > +	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > +
> > +	t1 = xfs_calc_inode_res(mp, 1) +
> > +	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> > +
> > +	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> > +	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> > +
> > +	if (xfs_has_realtime(mp)) {
> > +		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> > +		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> > +		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> > +	} else {
> > +		t3 = 0;
> > +	}
> > +
> > +	t4 = xfs_refcount_log_reservation(mp, 2);
> > +
> > +	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
> > +}
> > +
> > +/*
> > + * For log size calculation, this is the same as above except that we used to
> > + * include refcount updates in the allocfree computation even though we've
> > + * always run them as a separate transaction.
> > + */
> > +STATIC uint
> > +xfs_calc_itruncate_reservation_logsize(
> > +	struct xfs_mount	*mp)
> >  {
> >  	unsigned int		t1, t2, t3;
> >  	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> > @@ -317,6 +384,9 @@ xfs_calc_itruncate_reservation(
> >  	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> >  	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> >  
> > +	if (xfs_has_reflink(mp))
> > +	     t2 += xfs_calc_buf_res(xfs_refcount_log_count(mp, 4), blksz);
> > +
> 
> Ok, so the legacy code gets 4 extra refcount ops accounted here
> because we removed it from xfs_allocfree_log_count(), and we keep
> this function around because the new code might select t4 as
> the maximum reservation it needs and so we can't just add these
> blocks to the newly calculated reservation. Correct?
> 
> If so, I'm not a great fan of duplicating this code when this is all
> that differs between the two case. Can we pass in a "bool
> for_minlogsize" variable and do:
> 
> uint
> xfs_calc_itruncate_reservation(
> 	struct xfs_mount	*mp,
> 	bool			for_minlogsize)
> {
> 	unsigned int		t1, t2, t3, t4;
> 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
> 
> 	t1 = xfs_calc_inode_res(mp, 1) +
> 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
> 
> 	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> 	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> 
> 	if (xfs_has_realtime(mp)) {
> 		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> 		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> 		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> 	} else {
> 		t3 = 0;
> 	}
> 
> 	if (!for_minlogsize) {
> 		t4 = xfs_refcount_log_reservation(mp, 2);
> 		return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
> 	}
> 
> 	/*
> 	 * add reason for minlogsize calculation differences here
> 	 */
> 	if (xfs_has_reflink(mp))
> 		t2 += xfs_calc_buf_res(xfs_refcount_log_count(mp, 4), blksz);
> 
> 	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
> }
> 
> And now we can call xfs_calc_itruncate_reservation(mp, true)
> directly from xfs_log_rlimits.c to get the correct reservation for
> the logsize code with minimal extra code.

Yep.  This is an improvement, in terms of being able to compare before
and after.  I"ll make sure to document exactly why the for_minlogsize
case does what it does.

> >  	if (xfs_has_realtime(mp)) {
> >  		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> >  		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> > @@ -956,6 +1026,9 @@ xfs_trans_resv_calc_logsize(
> >  	xfs_trans_resv_calc(mp, resp);
> >  
> >  	if (xfs_has_reflink(mp)) {
> > +		unsigned int	t4;
> > +		unsigned int	blksz = XFS_FSB_TO_B(mp, 1);
> > +
> >  		/*
> >  		 * In the early days of reflink we set the logcounts absurdly
> >  		 * high.
> > @@ -964,6 +1037,18 @@ xfs_trans_resv_calc_logsize(
> >  		resp->tr_itruncate.tr_logcount =
> >  				XFS_ITRUNCATE_LOG_COUNT_REFLINK;
> >  		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
> > +
> > +		/*
> > +		 * We also used to account two refcount updates per extent into
> > +		 * the alloc/free step of write and truncate calls, even though
> > +		 * those are run in separate transactions.
> > +		 */
> > +		t4 = xfs_calc_buf_res(xfs_refcount_log_count(mp, 2), blksz);
> > +		resp->tr_write.tr_logres += t4;
> > +		resp->tr_qm_dqalloc.tr_logres += t4;
> 
> I think these have the same problem as itruncate - the write
> reservation is conditional on the maximum reservation of several
> different operations, and so dropping the refcountbt from that
> comparison means it could select a different max reservation. Then
> if we unconditionally add the refcount blocks to that, then we end
> up with a different size to what the original code calculated.
> 
> Hence I think these also need to be treated like I outline for
> itruncate above.

Yup.  Thanks for the comments!

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

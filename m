Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AF8C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF58664E39
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhBCSP3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:15:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231674AbhBCSPH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 13:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D9B664E39;
        Wed,  3 Feb 2021 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612376064;
        bh=mSeFi/RxlJVUbcDlycFslTCYmYxuuCv/xX9U2rnjN5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q6DT6KW+nXvK+vMifxRh8mnPXNm5mSmSs8lBoQxUeqcvTSNIfydAaqvGwLaCke71o
         My6Dw1pIJhlQkzRVP/cFvVH1WjQk51xaiLpf6CEofGuw/FBlcsUg6LRk/v0RJZYZ9o
         koZepwNKxQ2tqG2/G603Xiwz4FzDlm3U8vS6KBFLdD49CtCTFjZiis/hIiQb9HK8Oe
         nCjCFpRQ0EXS1Ro1zasqRh9gaYCLE96LNywWBpzigfVbucnFoG8wWR0VBqckzyAf39
         s3DboWC2ZaZeiSyo+0hLgvn/9BgzaeWl7nS1QF7d1iKzFMaq0/4lF9nyrp1PaxN14E
         /lHlhWG92xHNg==
Date:   Wed, 3 Feb 2021 10:14:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210203181423.GA7193@magnolia>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203181211.GZ7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203181211.GZ7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 10:12:11AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:
> > Hi Brian,
> > 
> > On Wed, Feb 03, 2021 at 09:23:37AM -0500, Brian Foster wrote:
> > > On Tue, Jan 26, 2021 at 08:56:20PM +0800, Gao Xiang wrote:
> > > > As the first step of shrinking, this attempts to enable shrinking
> > > > unused space in the last allocation group by fixing up freespace
> > > > btree, agi, agf and adjusting super block and use a helper
> > > > xfs_ag_shrink_space() to fixup the last AG.
> > > > 
> > > > This can be all done in one transaction for now, so I think no
> > > > additional protection is needed.
> > > > 
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_fsops.c | 64 ++++++++++++++++++++++++++++++----------------
> > > >  fs/xfs/xfs_trans.c |  1 -
> > > >  2 files changed, 42 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > index 6c4ab5e31054..4bcea22f7b3f 100644
> > > > --- a/fs/xfs/xfs_fsops.c
> > > > +++ b/fs/xfs/xfs_fsops.c
> > > > @@ -38,7 +38,7 @@ xfs_resizefs_init_new_ags(
> > > >  	struct aghdr_init_data	*id,
> > > >  	xfs_agnumber_t		oagcount,
> > > >  	xfs_agnumber_t		nagcount,
> > > > -	xfs_rfsblock_t		*delta)
> > > > +	int64_t			*delta)
> > > >  {
> > > >  	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
> > > >  	int			error;
> > > > @@ -76,33 +76,41 @@ xfs_growfs_data_private(
> > > >  	xfs_agnumber_t		nagcount;
> > > >  	xfs_agnumber_t		nagimax = 0;
> > > >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> > > > -	xfs_rfsblock_t		delta;
> > > > +	int64_t			delta;
> > > >  	xfs_agnumber_t		oagcount;
> > > >  	struct xfs_trans	*tp;
> > > > +	bool			extend;
> > > >  	struct aghdr_init_data	id = {};
> > > >  
> > > >  	nb = in->newblocks;
> > > > -	if (nb < mp->m_sb.sb_dblocks)
> > > > -		return -EINVAL;
> > > > -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> > > > +	if (nb == mp->m_sb.sb_dblocks)
> > > > +		return 0;
> > > > +
> > > > +	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> > > > +	if (error)
> > > >  		return error;
> > > > -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > > > +
> > > > +	if (nb > mp->m_sb.sb_dblocks) {
> > > > +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > > >  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> > > >  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> > > > -	if (error)
> > > > -		return error;
> > > > -	xfs_buf_relse(bp);
> > > > +		if (error)
> > > > +			return error;
> > > > +		xfs_buf_relse(bp);
> > > > +	}
> > > >  
> > > >  	nb_div = nb;
> > > >  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > > >  	nagcount = nb_div + (nb_mod != 0);
> > > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > > >  		nagcount--;
> > > > -		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > > -		if (nb < mp->m_sb.sb_dblocks)
> > > > +		if (nagcount < 2)
> > > >  			return -EINVAL;
> > > 
> > > What's the reason for the nagcount < 2 check? IIRC we warn about this
> > > configuration at mkfs time, but allow it to proceed. Is it just that we
> > > don't want to accidentally put the fs into an agcount == 1 state that
> > > was originally formatted with >1 AGs?
> > 
> > Darrick once asked for avoiding shrinking the filesystem which has
> > only 1 AG.
> 
> It's worth mentioning why in a comment though:
> 
> 	/*
> 	 * XFS doesn't really support single-AG filesystems, so do not
> 	 * permit callers to remove the filesystem's second and last AG.
> 	 */
> 	if (shrink && new_agcount < 2)
> 		return -EHAHANOYOUDONT;
> 
> But as Brian points out, we /do/ allow adding a second AG to a single-AG
> fs.
> 
> > > 
> > > What about the case where we attempt to grow an agcount == 1 fs but
> > > don't enlarge enough to add the second AG? Does this change error
> > > behavior in that case?
> > 
> > Yeah, thanks for catching this! If growfs allows 1 AG case before,
> > I think it needs to be refined. Let me update this in the next version!
> > 
> > > 
> > > > +		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > >  	}
> > > > +
> > > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > > +	extend = (delta > 0);
> > > >  	oagcount = mp->m_sb.sb_agcount;
> > > >  
> > > >  	/* allocate the new per-ag structures */
> > > > @@ -110,22 +118,34 @@ xfs_growfs_data_private(
> > > >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > > >  		if (error)
> > > >  			return error;
> > > > +	} else if (nagcount < oagcount) {
> > > > +		/* TODO: shrinking the entire AGs hasn't yet completed */
> > > > +		return -EINVAL;
> > > >  	}
> > > >  
> > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > > > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > > > +			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > > > +			XFS_TRANS_RESERVE, &tp);
> > > >  	if (error)
> > > >  		return error;
> > > >  
> > > > -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> > > > -	if (error)
> > > > -		goto out_trans_cancel;
> > > > -
> > > > +	if (extend) {
> > > > +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> > > > +						  nagcount, &delta);
> > > > +		if (error)
> > > > +			goto out_trans_cancel;
> > > > +	}
> > > >  	xfs_trans_agblocks_delta(tp, id.nfree);
> > > 
> > > It looks like id isn't used until the resize call above. Is this call
> > > relevant for the shrink case?
> > 
> > I think it has nothing to do for the shrink the last AG case as well
> > (id.nfree == 0 here) but maybe use for the later shrinking the whole
> > AGs patchset. I can move into if (extend) in the next version.
> > 
> > > 
> > > >  
> > > > -	/* If there are new blocks in the old last AG, extend it. */
> > > > +	/* If there are some blocks in the last AG, resize it. */
> > > >  	if (delta) {
> > > 
> > > This patch added a (nb == mp->m_sb.sb_dblocks) shortcut check at the top
> > > of the function. Should we ever get to this point with delta == 0? (If
> > > not, maybe convert it to an assert just to be safe.)
> > 
> > delta would be changed after xfs_resizefs_init_new_ags() (the original
> > growfs design is that, I don't want to touch the original logic). that
> > is why `delta' reflects the last AG delta now...
> 
> I've never liked how the meaning of "delta" changes through the
> function, and it clearly trips up reviewers.  This variable isn't the
> delta between the old dblocks and the new dblocks, it's really a
> resizefs cursor that tells us how much work we still have to do.
> 
> > > 
> > > > -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > > +		if (extend) {
> > > > +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > > +		} else {
> > > > +			id.agno = nagcount - 1;
> > > > +			error = xfs_ag_shrink_space(mp, &tp, &id, -delta);
> > > 
> > > xfs_ag_shrink_space() looks like it only accesses id->agno. Perhaps just
> > > pass in agno for now..?
> > 
> > Both way are ok, yet in my incomplete shrink whole empty AGs patchset,
> > it seems more natural to pass in &id rather than agno (since
> > id.agno = nagcount - 1 will be stayed in some new helper
> > e.g. xfs_shrink_ags())
> 
> @id is struct aghdr_init_data, but shrinking shouldn't initialize any AG
> headers.  Are you planning to make use of it in shrink, either now or
> later on?
> 
> > 
> > > 
> > > > +		}
> > > > +
> > > >  		if (error)
> > > >  			goto out_trans_cancel;
> > > >  	}
> > > > @@ -137,15 +157,15 @@ xfs_growfs_data_private(
> > > >  	 */
> > > >  	if (nagcount > oagcount)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > > -	if (nb > mp->m_sb.sb_dblocks)
> > > > +	if (nb != mp->m_sb.sb_dblocks)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > > >  				 nb - mp->m_sb.sb_dblocks);
> > > 
> > > Maybe use delta here?
> > 
> > The reason is the same as above, `delta' here was changed due to 
> > xfs_resizefs_init_new_ags(), which is not nb - mp->m_sb.sb_dblocks
> > anymore. so `extend` boolean is used (rather than just use delta > 0)
> 
> Long question:
> 
> The reason why we use (nb - dblocks) is because growfs is an all or
> nothing operation -- either we succeed in writing new empty AGs and
> inflating the (former) last AG of the fs, or we don't do anything at
> all.  We don't allow partial growing; if we did, then delta would be
> relevant here.  I think we get away with not needing to run transactions
> for each AG because those new AGs are inaccessible until we commit the
> new agcount/dblocks, right?
> 
> In your design for the fs shrinker, do you anticipate being able to
> eliminate all the eligible AGs in a single transaction?  Or do you
> envision only tackling one AG at a time?  And can we be partially
> successful with a shrink?  e.g. we succeed at eliminating the last AG,
> but then the one before that isn't empty and so we bail out, but by that
> point we did actually make the fs a little bit smaller.
> 
> There's this comment at the bottom of xfs_growfs_data() that says that
> we can return error codes if the secondary sb update fails, even if the
> new size is already live.  This convinces me that it's always been the
> case that callers of the growfs ioctl are supposed to re-query the fs
> geometry afterwards to find out if the fs size changed, even if the
> ioctl itself returns an error... which implies that partial grow/shrink
> are a possibility.

And of course I got so buried in building up to my long question that I
forgot to ask it:

If the design of the shrinker requires incremental shrinking, should we
support incremental growfs too?

--D

> > 
> > > 
> > > >  	if (id.nfree)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > > >  
> > > 
> > > id.nfree tracks newly added free space in the growfs space. Is it not
> > > used in the shrink case because the allocation handles this for us?
> > 
> > Yeah, I'm afraid so. This is some common code, and also used in my
> > shrinking the whole AGs patchset.
> > 
> > > 
> > > >  	/*
> > > > -	 * update in-core counters now to reflect the real numbers
> > > > -	 * (especially sb_fdblocks)
> > > > +	 * update in-core counters now to reflect the real numbers (especially
> > > > +	 * sb_fdblocks). And xfs_validate_sb_write() can pass for shrinkfs.
> > > >  	 */
> > > >  	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > >  		xfs_log_sb(tp);
> > > > @@ -165,7 +185,7 @@ xfs_growfs_data_private(
> > > >  	 * If we expanded the last AG, free the per-AG reservation
> > > >  	 * so we can reinitialize it with the new size.
> > > >  	 */
> > > > -	if (delta) {
> > > > +	if (extend && delta) {
> > > >  		struct xfs_perag	*pag;
> > > >  
> > > >  		pag = xfs_perag_get(mp, id.agno);
> > > 
> > > We call xfs_fs_reserve_ag_blocks() a bit further down before we exit
> > > this function. xfs_ag_shrink_space() from the previous patch is intended
> > > to deal with perag reservation changes for shrink, but it looks like the
> > > reserve call further down could potentially reset mp->m_finobt_nores to
> > > false if it previously might have been set to true.
> > 
> > Yeah, if my understanding is correct, I might need to call
> > xfs_fs_reserve_ag_blocks() only for growfs case as well for
> > mp->m_finobt_nores = true case.
> 
> I suppose it's worth trying in the finobt_nores==true case. :)
> 
> --D
> 
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Brian
> > > 
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index e72730f85af1..fd2cbf414b80 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
> > > >  		tp->t_res_frextents_delta += delta;
> > > >  		break;
> > > >  	case XFS_TRANS_SB_DBLOCKS:
> > > > -		ASSERT(delta > 0);
> > > >  		tp->t_dblocks_delta += delta;
> > > >  		break;
> > > >  	case XFS_TRANS_SB_AGCOUNT:
> > > > -- 
> > > > 2.27.0
> > > > 
> > > 
> > 

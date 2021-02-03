Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E81C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D25D64F8C
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhBCSDO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232619AbhBCSDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 13:03:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612375296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EPYOOcZ+CWUu0xTxu7DsuvCDVFVx3PuUQzHtuPqL26U=;
        b=JD1t+L+TbqoewqHKfcg2DlxO7/Eg55vhRRgfEAmCexQTpzOaShAYnyqu/islym64chArZh
        kcwLiKeD8bz0M3oNIWCR4cb6zvMBLO+N113Q2aSvl02946C+XckRHRN9lw0d053OPLP0Ey
        j2hiXAqtLAUA1pczpemT7fhQttwDJnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-yG9ntQ-7PSuQM42-tWb7Yg-1; Wed, 03 Feb 2021 13:01:34 -0500
X-MC-Unique: yG9ntQ-7PSuQM42-tWb7Yg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46222193411E;
        Wed,  3 Feb 2021 18:01:33 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 457CA100AE4E;
        Wed,  3 Feb 2021 18:01:28 +0000 (UTC)
Date:   Wed, 3 Feb 2021 13:01:26 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210203180126.GH3647012@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203145146.GA935062@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Wed, Feb 03, 2021 at 09:23:37AM -0500, Brian Foster wrote:
> > On Tue, Jan 26, 2021 at 08:56:20PM +0800, Gao Xiang wrote:
> > > As the first step of shrinking, this attempts to enable shrinking
> > > unused space in the last allocation group by fixing up freespace
> > > btree, agi, agf and adjusting super block and use a helper
> > > xfs_ag_shrink_space() to fixup the last AG.
> > > 
> > > This can be all done in one transaction for now, so I think no
> > > additional protection is needed.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  fs/xfs/xfs_fsops.c | 64 ++++++++++++++++++++++++++++++----------------
> > >  fs/xfs/xfs_trans.c |  1 -
> > >  2 files changed, 42 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 6c4ab5e31054..4bcea22f7b3f 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > > @@ -38,7 +38,7 @@ xfs_resizefs_init_new_ags(
> > >  	struct aghdr_init_data	*id,
> > >  	xfs_agnumber_t		oagcount,
> > >  	xfs_agnumber_t		nagcount,
> > > -	xfs_rfsblock_t		*delta)
> > > +	int64_t			*delta)
> > >  {
> > >  	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
> > >  	int			error;
> > > @@ -76,33 +76,41 @@ xfs_growfs_data_private(
> > >  	xfs_agnumber_t		nagcount;
> > >  	xfs_agnumber_t		nagimax = 0;
> > >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> > > -	xfs_rfsblock_t		delta;
> > > +	int64_t			delta;
> > >  	xfs_agnumber_t		oagcount;
> > >  	struct xfs_trans	*tp;
> > > +	bool			extend;
> > >  	struct aghdr_init_data	id = {};
> > >  
> > >  	nb = in->newblocks;
> > > -	if (nb < mp->m_sb.sb_dblocks)
> > > -		return -EINVAL;
> > > -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> > > +	if (nb == mp->m_sb.sb_dblocks)
> > > +		return 0;
> > > +
> > > +	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> > > +	if (error)
> > >  		return error;
> > > -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > > +
> > > +	if (nb > mp->m_sb.sb_dblocks) {
> > > +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > >  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> > >  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> > > -	if (error)
> > > -		return error;
> > > -	xfs_buf_relse(bp);
> > > +		if (error)
> > > +			return error;
> > > +		xfs_buf_relse(bp);
> > > +	}
> > >  
> > >  	nb_div = nb;
> > >  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > >  	nagcount = nb_div + (nb_mod != 0);
> > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > >  		nagcount--;
> > > -		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > -		if (nb < mp->m_sb.sb_dblocks)
> > > +		if (nagcount < 2)
> > >  			return -EINVAL;
> > 
> > What's the reason for the nagcount < 2 check? IIRC we warn about this
> > configuration at mkfs time, but allow it to proceed. Is it just that we
> > don't want to accidentally put the fs into an agcount == 1 state that
> > was originally formatted with >1 AGs?
> 
> Darrick once asked for avoiding shrinking the filesystem which has
> only 1 AG.
> 
> > 
> > What about the case where we attempt to grow an agcount == 1 fs but
> > don't enlarge enough to add the second AG? Does this change error
> > behavior in that case?
> 
> Yeah, thanks for catching this! If growfs allows 1 AG case before,
> I think it needs to be refined. Let me update this in the next version!
> 
> > 
> > > +		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > >  	}
> > > +
> > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > +	extend = (delta > 0);
> > >  	oagcount = mp->m_sb.sb_agcount;
> > >  
> > >  	/* allocate the new per-ag structures */
> > > @@ -110,22 +118,34 @@ xfs_growfs_data_private(
> > >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > >  		if (error)
> > >  			return error;
> > > +	} else if (nagcount < oagcount) {
> > > +		/* TODO: shrinking the entire AGs hasn't yet completed */
> > > +		return -EINVAL;
> > >  	}
> > >  
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > > +			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > > +			XFS_TRANS_RESERVE, &tp);
> > >  	if (error)
> > >  		return error;
> > >  
> > > -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> > > -	if (error)
> > > -		goto out_trans_cancel;
> > > -
> > > +	if (extend) {
> > > +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> > > +						  nagcount, &delta);
> > > +		if (error)
> > > +			goto out_trans_cancel;
> > > +	}
> > >  	xfs_trans_agblocks_delta(tp, id.nfree);
> > 
> > It looks like id isn't used until the resize call above. Is this call
> > relevant for the shrink case?
> 
> I think it has nothing to do for the shrink the last AG case as well
> (id.nfree == 0 here) but maybe use for the later shrinking the whole
> AGs patchset. I can move into if (extend) in the next version.
> 
> > 
> > >  
> > > -	/* If there are new blocks in the old last AG, extend it. */
> > > +	/* If there are some blocks in the last AG, resize it. */
> > >  	if (delta) {
> > 
> > This patch added a (nb == mp->m_sb.sb_dblocks) shortcut check at the top
> > of the function. Should we ever get to this point with delta == 0? (If
> > not, maybe convert it to an assert just to be safe.)
> 
> delta would be changed after xfs_resizefs_init_new_ags() (the original
> growfs design is that, I don't want to touch the original logic). that
> is why `delta' reflects the last AG delta now...
> 

Oh, I see. Hmm... that's a bit obfuscated and easy to miss. Perhaps the
new helper should also include the extend_space() call below to do all
of the AG updates in one place. It's not clear to me if we need to keep
the growfs perag reservation code where it is. If so, the new helper
could take a boolean pointer (instead of delta) that it can set to true
if it had to extend the size of the old last AG because the perag res
bits don't actually use the delta value. IOW, I think this hunk could
look something like the following:

	bool	resetagres = false;

	if (extend)
		error = xfs_resizefs_init_new_ags(..., delta, &resetagres);
	else
		error = xfs_ag_shrink_space(... -delta);
	...

	if (resetagres) {
		<do perag res fixups>
	}
	...

Hm?

Brian

> > 
> > > -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > +		if (extend) {
> > > +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > +		} else {
> > > +			id.agno = nagcount - 1;
> > > +			error = xfs_ag_shrink_space(mp, &tp, &id, -delta);
> > 
> > xfs_ag_shrink_space() looks like it only accesses id->agno. Perhaps just
> > pass in agno for now..?
> 
> Both way are ok, yet in my incomplete shrink whole empty AGs patchset,
> it seems more natural to pass in &id rather than agno (since
> id.agno = nagcount - 1 will be stayed in some new helper
> e.g. xfs_shrink_ags())
> 
> > 
> > > +		}
> > > +
> > >  		if (error)
> > >  			goto out_trans_cancel;
> > >  	}
> > > @@ -137,15 +157,15 @@ xfs_growfs_data_private(
> > >  	 */
> > >  	if (nagcount > oagcount)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > -	if (nb > mp->m_sb.sb_dblocks)
> > > +	if (nb != mp->m_sb.sb_dblocks)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> > >  				 nb - mp->m_sb.sb_dblocks);
> > 
> > Maybe use delta here?
> 
> The reason is the same as above, `delta' here was changed due to 
> xfs_resizefs_init_new_ags(), which is not nb - mp->m_sb.sb_dblocks
> anymore. so `extend` boolean is used (rather than just use delta > 0)
> 
> > 
> > >  	if (id.nfree)
> > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > >  
> > 
> > id.nfree tracks newly added free space in the growfs space. Is it not
> > used in the shrink case because the allocation handles this for us?
> 
> Yeah, I'm afraid so. This is some common code, and also used in my
> shrinking the whole AGs patchset.
> 
> > 
> > >  	/*
> > > -	 * update in-core counters now to reflect the real numbers
> > > -	 * (especially sb_fdblocks)
> > > +	 * update in-core counters now to reflect the real numbers (especially
> > > +	 * sb_fdblocks). And xfs_validate_sb_write() can pass for shrinkfs.
> > >  	 */
> > >  	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > >  		xfs_log_sb(tp);
> > > @@ -165,7 +185,7 @@ xfs_growfs_data_private(
> > >  	 * If we expanded the last AG, free the per-AG reservation
> > >  	 * so we can reinitialize it with the new size.
> > >  	 */
> > > -	if (delta) {
> > > +	if (extend && delta) {
> > >  		struct xfs_perag	*pag;
> > >  
> > >  		pag = xfs_perag_get(mp, id.agno);
> > 
> > We call xfs_fs_reserve_ag_blocks() a bit further down before we exit
> > this function. xfs_ag_shrink_space() from the previous patch is intended
> > to deal with perag reservation changes for shrink, but it looks like the
> > reserve call further down could potentially reset mp->m_finobt_nores to
> > false if it previously might have been set to true.
> 
> Yeah, if my understanding is correct, I might need to call
> xfs_fs_reserve_ag_blocks() only for growfs case as well for
> mp->m_finobt_nores = true case.
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index e72730f85af1..fd2cbf414b80 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
> > >  		tp->t_res_frextents_delta += delta;
> > >  		break;
> > >  	case XFS_TRANS_SB_DBLOCKS:
> > > -		ASSERT(delta > 0);
> > >  		tp->t_dblocks_delta += delta;
> > >  		break;
> > >  	case XFS_TRANS_SB_AGCOUNT:
> > > -- 
> > > 2.27.0
> > > 
> > 
> 


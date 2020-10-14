Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0110CC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 17:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6747821D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 17:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T6E2ROnB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgJNRBw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 13:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730119AbgJNRBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 13:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602694909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B09R1udJTl12fDA9dCpEZCUVRZUcc7cOgxJ8vWyhQ+I=;
        b=T6E2ROnBmawQzCYhHoke/GVGLlQwL5hmYe8NLEoLYjHBOeNBWSlq2rDK3do56Fyy+iwCr/
        n+zUQkGuld6c0BtQWbcgI1wE2VI7pOgag6IYN4mFhiiJDdK9MMEJtm/TQHFmTXbUxCHZ+X
        JcAH4DnSGN5PqYXKsAJZQqcdTxV8ULg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-at0jtVTlMI2c0rb60emVlQ-1; Wed, 14 Oct 2020 13:01:46 -0400
X-MC-Unique: at0jtVTlMI2c0rb60emVlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1878E18C89C5;
        Wed, 14 Oct 2020 17:01:45 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35F0060C07;
        Wed, 14 Oct 2020 17:01:41 +0000 (UTC)
Date:   Wed, 14 Oct 2020 13:01:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201014170139.GC1109375@bfoster>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014005809.6619-1-hsiangkao@aol.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 08:58:09AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> At the first step of shrinking, this attempts to enable shrinking
> unused space in the last allocation group by fixing up freespace
> btree, agi, agf and adjusting super block.
> 
> This can be all done in one transaction for now, so I think no
> additional protection is needed.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> Honestly, I've got headache about shrinking entire AGs
> since the codebase doesn't expect agcount can be decreased
> suddenly, I got some ideas from people but the modification
> seems all over the codebase, I will keep on this at least
> to learn more about XFS internals.
> 
> It might be worth sending out shrinking the last AG first
> since users might need to shrink a little unused space
> occasionally, yet I'm not quite sure the log space reservation
> calculation in this patch and other details are correct.
> I've done some manual test and it seems work. Yeah, as a
> formal patch it needs more test to be done but I'd like
> to hear more ideas about this first since I'm not quite
> familiar with XFS for now and this topic involves a lot
> new XFS-specific implementation details.
> 
> Kindly point out all strange places and what I'm missing
> so I can revise it. It would be of great help for me to
> learn more about XFS. At least just as a record on this
> topic for further discussion.
> 

Interesting... this seems fundamentally sane when narrowing the scope
down to tail AG shrinking. Does xfs_repair flag any issues in the simple
tail AG shrink case?

Some random initial thoughts..

> Thanks,
> Gao Xiang
> 
>  fs/xfs/libxfs/xfs_ag.c    | 46 ++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h    |  2 ++
>  fs/xfs/libxfs/xfs_alloc.c | 55 +++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h | 10 +++++++
>  fs/xfs/xfs_fsops.c        | 49 ++++++++++++++++++++++++----------
>  fs/xfs/xfs_trans.c        |  1 -
>  6 files changed, 148 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..cac7b715e90b 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -485,6 +485,52 @@ xfs_ag_init_headers(
>  	return error;
>  }
>  
> +int
> +xfs_ag_shrink_space(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct aghdr_init_data	*id,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_buf		*agibp, *agfbp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	int			error;
> +
> +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	agi = agibp->b_addr;
> +
> +	/* Cannot touch the log space */
> +	if (is_log_ag(mp, id) &&
> +	    XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart) +
> +	    mp->m_sb.sb_logblocks > be32_to_cpu(agi->agi_length) - len)
> +		return -EINVAL;
> +
> +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_alloc_vextent_shrink(tp, agfbp,
> +			be32_to_cpu(agi->agi_length) - len, len);
> +	if (error)
> +		return error;
> +
> +	/* Change the agi length */
> +	be32_add_cpu(&agi->agi_length, -len);
> +	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
> +
> +	/* Change agf length */
> +	agf = agfbp->b_addr;
> +	be32_add_cpu(&agf->agf_length, -len);
> +	ASSERT(agf->agf_length == agi->agi_length);
> +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
> +	return 0;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in
>   */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 5166322807e7..f3b5bbfeadce 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -24,6 +24,8 @@ struct aghdr_init_data {
>  };
>  
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
> +			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
>  			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..681357bb2701 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1118,6 +1118,61 @@ xfs_alloc_ag_vextent_small(
>  	return error;
>  }
>  
> +/*
> + * Allocate an extent for shrinking the last allocation group
> + * to fix the freespace btree.
> + * agfl fix is avoided in order to keep from dirtying the
> + * transaction unnecessarily compared with xfs_alloc_vextent().
> + */
> +int
> +xfs_alloc_vextent_shrink(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
> +	struct xfs_alloc_arg	args = {
> +		.tp = tp,
> +		.mp = mp,
> +		.type = XFS_ALLOCTYPE_THIS_BNO,
> +		.agbp = agbp,
> +		.agno = agno,
> +		.agbno = agbno,
> +		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),
> +		.minlen = len,
> +		.maxlen = len,
> +		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
> +		.resv = XFS_AG_RESV_NONE,
> +		.prod = 1,
> +		.alignment = 1,
> +		.pag = agbp->b_pag
> +	};
> +	int			error;
> +
> +	error = xfs_alloc_ag_vextent_exact(&args);
> +	if (error || args.agbno == NULLAGBLOCK)
> +		return -EBUSY;

I think it's generally better to call into the top-level allocator API
(xfs_alloc_vextent()) because it will handle internal allocator business
like fixing up the AGFL and whatnot. Then you probably don't have to
specify as much in the args structure as well. The allocation mode
you've specified (THIS_BNO) will fall into the exact allocation codepath
and should enforce the semantics we need here (i.e. grant the exact
allocation or fail).

I also wonder if we'll eventually have to be more intelligent here in
scenarios where ag metadata (i.e., free space root blocks, etc.) or the
agfl holds blocks in a range we're asked to shrink. I think those are
scenarios where such an allocation request would fail even though the
blocks are internal or technically free. Have you explored such
scenarios so far? I know we're trying to be opportunistic here, but if
the AG (or subset) is otherwise empty it seems a bit random to fail.
Hmm, maybe scrub/repair could help to reinit/defrag such an AG if we
could otherwise determine that blocks beyond a certain range are unused
externally.

> +
> +	ASSERT(args.agbno == agbno);
> +	ASSERT(args.len == len);
> +	ASSERT(!args.wasfromfl || args.resv != XFS_AG_RESV_AGFL);
> +
> +	if (!args.wasfromfl) {
> +		error = xfs_alloc_update_counters(tp, agbp, -(long)len);
> +		if (error)
> +			return error;
> +
> +		ASSERT(!xfs_extent_busy_search(mp, args.agno, agbno, args.len));
> +	}
> +	xfs_ag_resv_alloc_extent(args.pag, args.resv, &args);
> +
> +	XFS_STATS_INC(mp, xs_allocx);
> +	XFS_STATS_ADD(mp, xs_allocb, args.len);
> +	return 0;
> +}
> +
>  /*
>   * Allocate a variable extent in the allocation group agno.
>   * Type and bno are used to determine where in the allocation group the
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..6080140bcb56 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -160,6 +160,16 @@ int				/* error */
>  xfs_alloc_vextent(
>  	xfs_alloc_arg_t	*args);	/* allocation argument structure */
>  
> +/*
> + * Allocate an extent for shrinking the last AG
> + */
> +int
> +xfs_alloc_vextent_shrink(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agblock_t		agbno,
> +	xfs_extlen_t		len);	/* length of extent */
> +
>  /*
>   * Free an extent.
>   */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index ef1d5bb88b93..80927d323939 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -36,19 +36,21 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		new;
>  	xfs_agnumber_t		oagcount;
>  	xfs_trans_t		*tp;
> +	bool			extend;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> -	if (nb < mp->m_sb.sb_dblocks)
> -		return -EINVAL;
>  	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
>  		return error;
> -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> +
> +	if (nb > mp->m_sb.sb_dblocks) {
> +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
>  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> -	if (error)
> -		return error;
> -	xfs_buf_relse(bp);
> +		if (error)
> +			return error;
> +		xfs_buf_relse(bp);
> +	}
>  
>  	new = nb;	/* use new as a temporary here */
>  	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> @@ -56,10 +58,18 @@ xfs_growfs_data_private(
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -		if (nb < mp->m_sb.sb_dblocks)
> +		if (!nagcount)
>  			return -EINVAL;
>  	}

We probably need to rethink the bit of logic above this check for
shrinking. It looks like the current code checks for the minimum
supported AG size and if not satisfied, reduces the size the grow to the
next smaller AG count. That would actually increase the size of the
shrink from what the user requested, so we'd probably want to do the
opposite and reduce the size of the requested shrink. For now it
probably doesn't matter much since we fail to shrink the agcount.

That said, if I'm following the growfs behavior correctly it might be
worth considering analogous behavior for shrink. E.g., if the user asks
to trim 10GB off the last AG but only the last 4GB are free, then shrink
the fs by 4GB and report the new size to the user.

> -	new = nb - mp->m_sb.sb_dblocks;
> +
> +	if (nb > mp->m_sb.sb_dblocks) {
> +		new = nb - mp->m_sb.sb_dblocks;
> +		extend = true;
> +	} else {
> +		new = mp->m_sb.sb_dblocks - nb;
> +		extend = false;
> +	}
> +

s/new/delta (or something along those lines) might be more readable if
we go this route.

>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -67,10 +77,14 @@ xfs_growfs_data_private(
>  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
>  		if (error)
>  			return error;
> +	} else if (nagcount != oagcount) {
> +		/* TODO: shrinking a whole AG hasn't yet implemented */
> +		return -EINVAL;
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,
> +			XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
>  
> @@ -103,15 +117,22 @@ xfs_growfs_data_private(
>  			goto out_trans_cancel;
>  		}
>  	}
> -	error = xfs_buf_delwri_submit(&id.buffer_list);
> -	if (error)
> -		goto out_trans_cancel;
> +
> +	if (!list_empty(&id.buffer_list)) {
> +		error = xfs_buf_delwri_submit(&id.buffer_list);
> +		if (error)
> +			goto out_trans_cancel;
> +	}

The list check seems somewhat superfluous since we won't do anything
with an empty list anyways. Presumably it would be incorrect to ever
init a new AG on shrink so it might be cleaner to eventually refactor
this bit of logic out into a helper that we only call on extend since
this is a new AG initialization mechanism.

Brian

>  
>  	xfs_trans_agblocks_delta(tp, id.nfree);
>  
>  	/* If there are new blocks in the old last AG, extend it. */
>  	if (new) {
> -		error = xfs_ag_extend_space(mp, tp, &id, new);
> +		if (extend)
> +			error = xfs_ag_extend_space(mp, tp, &id, new);
> +		else
> +			error = xfs_ag_shrink_space(mp, tp, &id, new);
> +
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -123,7 +144,7 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (nb > mp->m_sb.sb_dblocks)
> +	if (nb != mp->m_sb.sb_dblocks)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c94e71f741b6..81b9c32f9bef 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
>  		tp->t_res_frextents_delta += delta;
>  		break;
>  	case XFS_TRANS_SB_DBLOCKS:
> -		ASSERT(delta > 0);
>  		tp->t_dblocks_delta += delta;
>  		break;
>  	case XFS_TRANS_SB_AGCOUNT:
> -- 
> 2.24.0
> 


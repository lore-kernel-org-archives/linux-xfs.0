Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4420C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 01:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358F322275
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 01:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="pB5PTdoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgJOBMR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 21:12:17 -0400
Received: from sonic315-55.consmr.mail.gq1.yahoo.com ([98.137.65.31]:38606
        "EHLO sonic315-55.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727379AbgJOBLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 21:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602724298; bh=5Lh+ZUdH4grIzS3DNj6kBCT2hQFRkzXOavly3eVooxY=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject; b=pB5PTdociK3rIoOOKpARv4+4cxATsVDh1XZ5+9KLcLA1CUszabT6toPc5Ig661E96ASpzhFiIrrjJF2LKy6upLfwuKqgPZE5WQsuGnrzmAOChXCOp1Tf0wnfjwh0CS5PHobLY5mny6nL9Wo5ubkYGD3bi9GxFfH3c6o1pQzUg6YyFSqgJ8ECjx8q0i3xS5rn4InnCBoZM67jQBHYX+3IBXt1AcSnOG0WB+xj2N9+oeX3wL94T7c9NZD6MIGQTGvr+ytvHyd5qTPNpxLXQ+tMzlGKSlK7mPpwQVGPPYgTJsBUjFhOBEJ+U2gwkvgVtHBaE+CWonUU+3oogiW1V75V8w==
X-YMail-OSG: csbu4GsVM1nsC0OmQuIw5tS6gAtqgLWpM.lsmwr2Ru0SSrQ5vpZIG2eCZ01wlch
 1TaDyJ5yZ1Hc197nbKI8mcU5X2HNxirKMaxwJYeNLihxfsYRLNFRU7ifjr1l1ZcyRBZ0jF3BijLP
 lGAr13.wsg7YZs912XVXT8.uqQRSFLOZNkiIb.ulM0ioQC3Rjoiuuf3C19iilebfn1HcFa6o77LV
 marZrLd8oZ4h_i4UeOxjIe2GLxyXoCE0sbm9LVUdTDkysFVX49pICGh6nimUbv_YvJKos9IdNitZ
 l9ryavTcCuHfgExB6gw32lZP_gZ7BpHK1XmnpVTS9d5dyd4DJXpMCtbDNHMMHdEi4ZKXaFRGHYVg
 sDM3fXEmpUQdSO3uZ8UHMOtYYfDVteDXRcPBEvlg_TgxeIk3ZSiE2jgdB0PPmO9xu54ajN94AAh5
 AsP7yD_AHWI_Ur6NSOy_kRFg4YfcXcFGSagRMABmH46cLjoXf0Tb2VEA454_i4hnFNP7nApVZWDC
 lOHsmLWMLq66IevQl9gICn37SaOfw_X41BQ_V8Zg8zxjIBHvuCVouehQcEENSJOSk_T4Ai3I4T3I
 rx6Q7u7bdKiT0fdX5BVDrWMudnFdQEO2zlnO9r3F4GtA8hNp1Vx.lj4c82xb92Du10WIqYyghWwI
 1TSU9rnD3fUKM22b7.C.kCSXGjphB1GkOPT1Rr7aVAn4KXXdwLNVeVci7KMdcXMGW8yMm5s_nZPp
 Wa4MVYUENzoQerp.QrFIPFBI6tCw0ohu7Nm_hqgyVEY34d7r8k_E3gap6by6pnkuSXtcjftC2ILL
 6sNl7jrjD3Cfp0NqIB6oFEp249fUPQNMmloSaud3.qEaW1L9ZchumMgFmt.80TkNI6baE61CLzwQ
 wVuc0cdX.JNNS9_nVm4zRZejZHx.fTzrIgfpEoF4BKaEIjOJiEbDsX7jniPDy0VasBq8UHQXtJ1I
 ImRgxvp9M8aFh4e60nFYbSbM9eaFuSBa.LV3PrQdbUgS_DGnO_r.goRs9fl8oRrc_yb6FfBmoiEg
 qqkk5HK6ymOrLBy6A8RrUH9GXFRpQtpTQrqsIBWTETh8JYBiXGccfq17caFEQQn7gNBPk7pnAQB6
 HPXHE41KBxkZtm5rvDd5hcpRgjPAEKKjKGQlbbpOYxw27fUiiQkdqgtNLhF1d2coHgMJpvUta3AD
 8FhvMN8M.YX_MrTrDVPZdAB2to5NAFSoFJQb5auCKR1xru8DQ6MRwQyAoJcMbYMEfAF1YxmMP11v
 qQgUTVcX7Eky1iMGhPNGgQVC0qTuUiVsa51_sVKh3EAesKYFF924hky15npbLIF5DfY7okEXShOf
 AJeSnGn5hsR5coDQGnEf4.vj3dHvj8s2ZT9KaDzRRolXB1OfklVV8kikn.mx6QxhRm21ha_KU61h
 srtlcyIzZaLFKYeu9b8MgbDgH1bBuKWTehYmDrYIN6F6eQTZnbH7Vg4ydXxNRJknNptilfhhEr5A
 Pc1k.U5ypajAu5qTduGrG2PsXz0wDcovu7XCLGeNhXr4mnkSyMkUP6JBYSrj1Wq7CUsd_EugkW8F
 RBthWk5vIwn4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Thu, 15 Oct 2020 01:11:38 +0000
Received: by smtp411.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 740164d210fc0f2ebf8256aabf95ea5d;
          Thu, 15 Oct 2020 01:11:33 +0000 (UTC)
Date:   Thu, 15 Oct 2020 09:11:24 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201015011116.GB7037@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
 <20201014160633.GD9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014160633.GD9832@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.16845 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Oct 14, 2020 at 09:06:33AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 14, 2020 at 08:58:09AM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 

...

> > +xfs_ag_shrink_space(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	struct aghdr_init_data	*id,
> > +	xfs_extlen_t		len)
> > +{
> > +	struct xfs_buf		*agibp, *agfbp;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_agf		*agf;
> > +	int			error;
> > +
> > +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> > +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> > +	if (error)
> > +		return error;
> > +
> > +	agi = agibp->b_addr;
> > +
> > +	/* Cannot touch the log space */
> > +	if (is_log_ag(mp, id) &&
> > +	    XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart) +
> > +	    mp->m_sb.sb_logblocks > be32_to_cpu(agi->agi_length) - len)
> > +		return -EINVAL;
> 
> The space used by the internal log shouldn't also show up in the free
> space btrees, so I think you could rely on the _alloc_vextent_shrink
> call to return ENOSPC, right?

Yeah, it makes sense since freespace btree doesn't have log space
at all. I will drop this and make a comment on this.

> 
> > +
> > +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_alloc_vextent_shrink(tp, agfbp,
> > +			be32_to_cpu(agi->agi_length) - len, len);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Change the agi length */
> > +	be32_add_cpu(&agi->agi_length, -len);
> > +	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
> > +
> > +	/* Change agf length */
> > +	agf = agfbp->b_addr;
> > +	be32_add_cpu(&agf->agf_length, -len);
> > +	ASSERT(agf->agf_length == agi->agi_length);
> > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Extent the AG indicated by the @id by the length passed in
> 
> "Extend..." ?

Yeah, yet not related to this patch, I could fix it independently
(maybe together with other typos)...

> 
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 5166322807e7..f3b5bbfeadce 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -24,6 +24,8 @@ struct aghdr_init_data {
> >  };
> >  
> >  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> > +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans *tp,
> > +			struct aghdr_init_data *id, xfs_extlen_t len);
> >  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> >  			struct aghdr_init_data *id, xfs_extlen_t len);
> >  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 852b536551b5..681357bb2701 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -1118,6 +1118,61 @@ xfs_alloc_ag_vextent_small(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Allocate an extent for shrinking the last allocation group
> > + * to fix the freespace btree.
> > + * agfl fix is avoided in order to keep from dirtying the
> > + * transaction unnecessarily compared with xfs_alloc_vextent().
> > + */
> > +int
> > +xfs_alloc_vextent_shrink(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agbp,
> > +	xfs_agblock_t		agbno,
> > +	xfs_extlen_t		len)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
> > +	struct xfs_alloc_arg	args = {
> > +		.tp = tp,
> > +		.mp = mp,
> > +		.type = XFS_ALLOCTYPE_THIS_BNO,
> > +		.agbp = agbp,
> > +		.agno = agno,
> > +		.agbno = agbno,
> > +		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),
> 
> /me would have thought you could compute agbno from the AGF buffer
> passed in and the length parameter.

Yeah, that would be fine since agfbp has been passed in here. will update.

> 
> > +		.minlen = len,
> > +		.maxlen = len,
> > +		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
> > +		.resv = XFS_AG_RESV_NONE,
> 
> Hmm.  Using AG_RESV_NONE here means that the allocation can fail because
> there won't be enough free space left to satisfy the AG metadata
> preallocations.  I think you have to call xfs_ag_resv_free before
> calling this allocation function to remove the preallocations, and then
> call xfs_ag_resv_init afterwards (regardless of whether the shrink
> succeeds) to re-establish the preallocations to fit the new AG size.

Ok, currently I'm not quite familiar with code in libxfs/xfs_ag_resv.c.
will look into that and try to follow your suggestion.

> 
> > +		.prod = 1,
> > +		.alignment = 1,
> > +		.pag = agbp->b_pag
> > +	};
> > +	int			error;
> > +
> > +	error = xfs_alloc_ag_vextent_exact(&args);
> > +	if (error || args.agbno == NULLAGBLOCK)
> > +		return -EBUSY;
> > +
> > +	ASSERT(args.agbno == agbno);
> > +	ASSERT(args.len == len);
> > +	ASSERT(!args.wasfromfl || args.resv != XFS_AG_RESV_AGFL);
> 
> Can wasfromfl==true actually happen?  I think for this shrink case we
> need to prevent that from ever happening.

I think it won't happen as well, since my idea currently is to avoid
any reduntant step, e.g. to adjust agfl or move/defrag metadata. I think
laterly userspace could do that with another ioctl (?) and if it fails
(e.g. change concurrently....) to try some process again.

> 
> > +
> > +	if (!args.wasfromfl) {
> > +		error = xfs_alloc_update_counters(tp, agbp, -(long)len);
> > +		if (error)
> > +			return error;
> > +
> > +		ASSERT(!xfs_extent_busy_search(mp, args.agno, agbno, args.len));
> > +	}
> > +	xfs_ag_resv_alloc_extent(args.pag, args.resv, &args);
> 
> (I think you can skip this call if you free the AG's preallocations
> before allocating the last freespace.)

Ok, will look into that as well. Currently the logic is mostly taken from
xfs_alloc_vextent() but without agfl fix, so the entriance seems more
straight-forward than shrinking stuffs are deep into a large
xfs_alloc_vextent() details...

> 
> > +
> > +	XFS_STATS_INC(mp, xs_allocx);
> > +	XFS_STATS_ADD(mp, xs_allocb, args.len);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Allocate a variable extent in the allocation group agno.
> >   * Type and bno are used to determine where in the allocation group the
> > diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> > index 6c22b12176b8..6080140bcb56 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.h
> > +++ b/fs/xfs/libxfs/xfs_alloc.h
> > @@ -160,6 +160,16 @@ int				/* error */
> >  xfs_alloc_vextent(
> >  	xfs_alloc_arg_t	*args);	/* allocation argument structure */
> >  
> > +/*
> > + * Allocate an extent for shrinking the last AG
> > + */
> > +int
> > +xfs_alloc_vextent_shrink(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agbp,
> > +	xfs_agblock_t		agbno,
> > +	xfs_extlen_t		len);	/* length of extent */
> > +
> >  /*
> >   * Free an extent.
> >   */
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index ef1d5bb88b93..80927d323939 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -36,19 +36,21 @@ xfs_growfs_data_private(
> >  	xfs_rfsblock_t		new;
> >  	xfs_agnumber_t		oagcount;
> >  	xfs_trans_t		*tp;
> > +	bool			extend;
> >  	struct aghdr_init_data	id = {};
> >  
> >  	nb = in->newblocks;
> > -	if (nb < mp->m_sb.sb_dblocks)
> > -		return -EINVAL;
> >  	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> >  		return error;
> 
> Please convert this to the more normal format:
> 
> error = xfs_sb_validate...();
> if (error)
> 	return error;

Ok, will update it with this patch.

> 
> > -	error = xfs_buf_read_uncached(mp->m_ddev_targp,
> > +
> > +	if (nb > mp->m_sb.sb_dblocks) {
> > +		error = xfs_buf_read_uncached(mp->m_ddev_targp,
> >  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
> >  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> > -	if (error)
> > -		return error;
> > -	xfs_buf_relse(bp);
> > +		if (error)
> > +			return error;
> > +		xfs_buf_relse(bp);
> > +	}
> >  
> >  	new = nb;	/* use new as a temporary here */
> >  	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> > @@ -56,10 +58,18 @@ xfs_growfs_data_private(
> >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> >  		nagcount--;
> >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > -		if (nb < mp->m_sb.sb_dblocks)
> > +		if (!nagcount)
> >  			return -EINVAL;
> 
> Realistically, we don't ever want fewer than 2 AGs since that would
> leave us with no superblock redundancy.  Repair doesn't really support
> the 1 AG case.

yeah, I notice that userspace warning, will update it.

> 
> >  	}
> > -	new = nb - mp->m_sb.sb_dblocks;
> > +
> > +	if (nb > mp->m_sb.sb_dblocks) {
> > +		new = nb - mp->m_sb.sb_dblocks;
> > +		extend = true;
> > +	} else {
> > +		new = mp->m_sb.sb_dblocks - nb;
> > +		extend = false;
> > +	}
> 
> Er... maybe you should start by hoisting all the "make data device
> larger" code into a separate function so that you can add the "make data
> device smaller" code as a second function.  Then xfs_growfs_data_private
> can decide which of the two to call based on the new size.

Yeah, that is fine, I will try to do in the next version.

> 
> > +
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > @@ -67,10 +77,14 @@ xfs_growfs_data_private(
> >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> >  		if (error)
> >  			return error;
> > +	} else if (nagcount != oagcount) {
> > +		/* TODO: shrinking a whole AG hasn't yet implemented */
> > +		return -EINVAL;
> >  	}
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > +			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,
> 
> XFS_GROWFS_SPACE_RES is defined as twice m_ag_maxlevels, which I think
> means (in the grow case) that it's reserving space for one full split
> for each free space btree.
> 
> Shrink, by contrast, is removing the rightmost record from the bnobt and
> some arbitrary record from the cntbt.  Can removing 1 record from each
> btree actually cause a split?

Yeah, I don't think so from btree implementation itself since it
removes/adjusts the record, will think it deeper later.

> 
> > +			XFS_TRANS_RESERVE, &tp);
> >  	if (error)
> >  		return error;
> >  
> > @@ -103,15 +117,22 @@ xfs_growfs_data_private(
> >  			goto out_trans_cancel;
> >  		}
> >  	}
> > -	error = xfs_buf_delwri_submit(&id.buffer_list);
> > -	if (error)
> > -		goto out_trans_cancel;
> > +
> > +	if (!list_empty(&id.buffer_list)) {
> > +		error = xfs_buf_delwri_submit(&id.buffer_list);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> >  
> >  	xfs_trans_agblocks_delta(tp, id.nfree);
> >  
> >  	/* If there are new blocks in the old last AG, extend it. */
> >  	if (new) {
> > -		error = xfs_ag_extend_space(mp, tp, &id, new);
> > +		if (extend)
> > +			error = xfs_ag_extend_space(mp, tp, &id, new);
> > +		else
> > +			error = xfs_ag_shrink_space(mp, tp, &id, new);
> 
> This logic is getting harder for me to track because the patch combines
> grow and shrink logic in the same function....

Yeah, currently it shares almost the same logic, I will try to seperate them
in the next version.


It's rough a preliminary version for now, if this direction is roughly
acceptable for upstream, will look into it further...

Thanks,
Gao Xiang


> 
> --D
> 


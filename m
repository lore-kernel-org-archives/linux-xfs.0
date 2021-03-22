Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E99C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029CA60240
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229467AbhCVMDZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:03:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhCVMDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 08:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616414604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4vI9ZCgKBIr7Q39No8heoHj+ULhG2uQY+gQJa5Kzeno=;
        b=cAnTV9kFKjQ1x1qDNflzTYibQiEFIw3Dp42qbY5HSf1ULO96MNwZC8E+9Omx/L4YJ7zS3V
        fMJxzdsoOk67dC1UZizePMEplczwxj7RB2aITVT4BBNt8zjn0cmo/tDR2MtJtCF0MqSAnK
        HnLZustTj0JKEik389K//Sj5gZVARys=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-L-5-mVjSMLCRNxhip1mw1A-1; Mon, 22 Mar 2021 08:03:23 -0400
X-MC-Unique: L-5-mVjSMLCRNxhip1mw1A-1
Received: by mail-pj1-f70.google.com with SMTP id oc10so28825857pjb.8
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 05:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4vI9ZCgKBIr7Q39No8heoHj+ULhG2uQY+gQJa5Kzeno=;
        b=URTeeYTQv8Clo/HairLxUGGt4/VUpmxWHsSfEHK+VBjIBLxTW4bJuUD/qTWwwt4OJa
         /WcL0G5Kgl8GypErWSf7F+iAgzpqNyXUPMGGf6AqTc7/4Wgj65slk9oMcSNGiYwYZVLN
         bZe8HJv1TsMiExrqTVJVvPhsIgNrpsI800QnObPrIho2dKoFdV19fYct3JPBeh8agxDm
         t/o3ZDwtlO2xk9GJeqfhu5pVF6mxJWatj8hUzZubVjmjGnRi+xcGh31ZMcR9qtr3GNYg
         ivhDqHI+ialrNLUUaHzfRjwiaaBhkLqyCb7BccaeZFaeWR/zcRUb6fe4s8AnfUUu78cm
         cHrw==
X-Gm-Message-State: AOAM531x5MwxoZ+DmV+To63h6i/RPSHRIS17+m0lLGOQfMAQfPy5q4l0
        OC4lr4nEOpdmUJ09lVDRyoXF8Tz7XcYMp8r4NP/Mo+pD/SROCVTSCTwgKehfQ3RiSgWN8WJZASK
        eI34EsfhxU9tbkjFL5bSv
X-Received: by 2002:a63:5b57:: with SMTP id l23mr22501361pgm.445.1616414601516;
        Mon, 22 Mar 2021 05:03:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb4tcyHyzoZAXNSHXYMyNrFDrvg7jr1o2dJ9H5HNRS8cKt45t/ez1yQyh/+WrM5nSdvONHMw==
X-Received: by 2002:a63:5b57:: with SMTP id l23mr22501333pgm.445.1616414601074;
        Mon, 22 Mar 2021 05:03:21 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w8sm11940784pgk.46.2021.03.22.05.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 05:03:20 -0700 (PDT)
Date:   Mon, 22 Mar 2021 20:03:10 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 3/5] xfs: introduce xfs_ag_shrink_space()
Message-ID: <20210322120310.GB2000812@xiangao.remote.csb>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-4-hsiangkao@redhat.com>
 <YFh/u86JO4Pzmk8i@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFh/u86JO4Pzmk8i@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Mon, Mar 22, 2021 at 07:30:03AM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 10:57:01AM +0800, Gao Xiang wrote:
> > This patch introduces a helper to shrink unused space in the last AG
> > by fixing up the freespace btree.
> > 
> > Also make sure that the per-AG reservation works under the new AG
> > size. If such per-AG reservation or extent allocation fails, roll
> > the transaction so the new transaction could cancel without any side
> > effects.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> 
> Looks mostly good to me. Some nits..
> 
> >  fs/xfs/libxfs/xfs_ag.c | 111 +++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_ag.h |   4 +-
> >  2 files changed, 114 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 9331f3516afa..1f6f9e70e1cb 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> ...
> > @@ -485,6 +490,112 @@ xfs_ag_init_headers(
> >  	return error;
> >  }
> >  
> > +int
> > +xfs_ag_shrink_space(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	**tpp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_extlen_t		delta)
> > +{
> > +	struct xfs_alloc_arg	args = {
> > +		.tp	= *tpp,
> > +		.mp	= mp,
> > +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> > +		.minlen = delta,
> > +		.maxlen = delta,
> > +		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
> > +		.resv	= XFS_AG_RESV_NONE,
> > +		.prod	= 1
> > +	};
> > +	struct xfs_buf		*agibp, *agfbp;
> > +	struct xfs_agi		*agi;
> > +	struct xfs_agf		*agf;
> > +	int			error, err2;
> > +
> > +	ASSERT(agno == mp->m_sb.sb_agcount - 1);
> > +	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
> > +	if (error)
> > +		return error;
> > +
> > +	agi = agibp->b_addr;
> > +
> > +	error = xfs_alloc_read_agf(mp, *tpp, agno, 0, &agfbp);
> > +	if (error)
> > +		return error;
> > +
> > +	agf = agfbp->b_addr;
> > +	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
> > +		return -EFSCORRUPTED;
> 
> Is this check here for a reason? It seems a bit random, so I wonder if
> we should just leave the extra verification to buffer verifiers.

It came from Darrick's thought. I'm fine with either way, but I feel
confused if different conflict opinions here:
https://lore.kernel.org/linux-xfs/20210303181931.GB3419940@magnolia/

> 
> > +
> > +	if (delta >= agi->agi_length)
> > +		return -EINVAL;
> > +
> > +	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> > +				    be32_to_cpu(agi->agi_length) - delta);
> > +
> > +	/* remove the preallocations before allocation and re-establish then */
> 
> The comment is a little confusing. Perhaps something like the following,
> if accurate..?
> 
> /*
>  * Disable perag reservations so it doesn't cause the allocation request
>  * to fail. We'll reestablish reservation before we return.
>  */

ok, will update in the next version.

> 
> > +	error = xfs_ag_resv_free(agibp->b_pag);
> > +	if (error)
> > +		return error;
> > +
> > +	/* internal log shouldn't also show up in the free space btrees */
> > +	error = xfs_alloc_vextent(&args);
> > +	if (!error && args.agbno == NULLAGBLOCK)
> > +		error = -ENOSPC;
> > +
> > +	if (error) {
> > +		/*
> > +		 * if extent allocation fails, need to roll the transaction to
> > +		 * ensure that the AGFL fixup has been committed anyway.
> > +		 */
> > +		err2 = xfs_trans_roll(tpp);
> > +		if (err2)
> > +			return err2;
> > +		goto resv_init_out;
> 
> So if this fails and the transaction rolls, do we still hold the agi/agf
> buffers here? If not, there might be a window of time where it's
> possible for some other task to come in and alloc out of the AG without
> the perag res being active.

Yeah, I might need to bhold this, will update.

> 
> > +	}
> > +
> > +	/*
> > +	 * if successfully deleted from freespace btrees, need to confirm
> > +	 * per-AG reservation works as expected.
> > +	 */
> > +	be32_add_cpu(&agi->agi_length, -delta);
> > +	be32_add_cpu(&agf->agf_length, -delta);
> > +
> > +	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> > +	if (err2) {
> > +		be32_add_cpu(&agi->agi_length, delta);
> > +		be32_add_cpu(&agf->agf_length, delta);
> > +		if (err2 != -ENOSPC)
> > +			goto resv_err;
> > +
> > +		__xfs_bmap_add_free(*tpp, args.fsbno, delta, NULL, true);
> > +
> > +		/*
> > +		 * Roll the transaction before trying to re-init the per-ag
> > +		 * reservation. The new transaction is clean so it will cancel
> > +		 * without any side effects.
> > +		 */
> > +		error = xfs_defer_finish(tpp);
> > +		if (error)
> > +			return error;
> > +
> > +		error = -ENOSPC;
> > +		goto resv_init_out;
> > +	}
> > +	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
> > +	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
> > +	return 0;
> > +
> > +resv_init_out:
> > +	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> > +	if (!err2)
> > +		return error;
> > +resv_err:
> > +	xfs_warn(mp, "Error %d reserving per-AG metadata reserve pool.", err2);
> > +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +	return err2;
> > +}
> > +
> >  /*
> >   * Extent the AG indicated by the @id by the length passed in
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 5166322807e7..41293ebde8da 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -24,8 +24,10 @@ struct aghdr_init_data {
> >  };
> >  
> >  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> > +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
> > +			xfs_agnumber_t agno, xfs_extlen_t len);
> >  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> > -			struct aghdr_init_data *id, xfs_extlen_t len);
> > +			struct aghdr_init_data *id, xfs_extlen_t delta);
> 
> This looks misplaced..?
> 
> Or maybe this is trying to make the APIs consistent, but the function
> definition still uses len as well as the declaration for
> _ag_shrink_space() (while the definition of that function uses delta).
> 
> FWIW, the name delta tends to suggest a signed value to me based on our
> pattern of usage, whereas here it seems like these helpers always want a
> positive value (i.e. a length).

Yeah, it's just misplaced, thanks for pointing out, sorry about that.
`delta' name came from, `len' is confusing to Darrick.
https://lore.kernel.org/r/20210303182527.GC3419940@magnolia/

Thanks,
Gao Xiang

> 
> Brian
> 
> >  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> >  			struct xfs_ag_geometry *ageo);
> >  
> > -- 
> > 2.27.0
> > 
> 


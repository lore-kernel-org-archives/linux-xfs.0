Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5A9C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3D96198B
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhCVMHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:07:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230448AbhCVMHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 08:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616414856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mK6PoynYjM3Ef7+LOVECBS6a0Gf+Y5RM6PyUJy22BTw=;
        b=VNOY5KEZLfPJUMi2EjLm3TQj5HxnmzY7wJs8y5RGuLq/dIUdDE3Q/Qd1FTGmIO7F8v243y
        6l7sILetSxBo3ZcBWIt77Bx5oGjW8bsKtKRkUoSu7tzFSSGpgS48N08s/OhxMQUgi4gmWJ
        8TK6rIuOjPDKm02yLQGOURm1qoOvck4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-msSFlYihO5CYdVnt1NIWtA-1; Mon, 22 Mar 2021 08:07:35 -0400
X-MC-Unique: msSFlYihO5CYdVnt1NIWtA-1
Received: by mail-pj1-f70.google.com with SMTP id dw22so20031703pjb.6
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 05:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mK6PoynYjM3Ef7+LOVECBS6a0Gf+Y5RM6PyUJy22BTw=;
        b=R2GcjAsRiSn6Ik8r+NocVrtLhpsFzaOatqo/6DJNX+MXitA2Yl4CpO1u4xwBjjMwm0
         vvVmDd5Y4xXP0PtZ0Uc4/dUYZ+o+ApeFIUm+8XcXSOH+2nsYcYY/ATLw7tJTwHyWqj2X
         9v4uODAShVRdvfg53AZcVCG3xFtBxus+G/YEUJ2YemHDDhan/1LWIDExTtyNLnPrI/If
         wItvUW+o9YepKpFFzzBHcJOh3UNEm/m++ZpyjeolQX+Oe0ec7axxnApiOzUCxztHBWaa
         xoOx9sUOJc4gSjL/lZYjmXw02L3wI/4I2RRf86tohPn36krA1RM6KHP0k38iwSebahca
         kV0Q==
X-Gm-Message-State: AOAM530ur5xsPGczji31wGRCR+QuUr0lqwcDiatBRIgy97FqIpDJOc1W
        7e3wlXXwW9JrF/PVdkHAdJL3TBxc0Kh1F/At9WZwenIdd95Fr7F3684cOmPF3regmCZgzCvnDr0
        avEnPetfs3jUjKiM7PuqG
X-Received: by 2002:a63:2345:: with SMTP id u5mr23122401pgm.326.1616414854133;
        Mon, 22 Mar 2021 05:07:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylRSVYu8qyGoy3CZcrJt3/ikaYjtq9jSWvwqXOMk+RclwBt87joAYzjYj2Oos5KEK5zyvvig==
X-Received: by 2002:a63:2345:: with SMTP id u5mr23122373pgm.326.1616414853779;
        Mon, 22 Mar 2021 05:07:33 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kk6sm13627287pjb.51.2021.03.22.05.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 05:07:33 -0700 (PDT)
Date:   Mon, 22 Mar 2021 20:07:22 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210322120722.GC2000812@xiangao.remote.csb>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-5-hsiangkao@redhat.com>
 <YFh/4A/9OPzHJ2pi@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFh/4A/9OPzHJ2pi@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 07:30:40AM -0400, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 10:57:02AM +0800, Gao Xiang wrote:
> > As the first step of shrinking, this attempts to enable shrinking
> > unused space in the last allocation group by fixing up freespace
> > btree, agi, agf and adjusting super block and use a helper
> > xfs_ag_shrink_space() to fixup the last AG.
> > 
> > This can be all done in one transaction for now, so I think no
> > additional protection is needed.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 88 ++++++++++++++++++++++++++++------------------
> >  fs/xfs/xfs_trans.c |  1 -
> >  2 files changed, 53 insertions(+), 36 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index fc9e799b2ae3..71cba61a451c 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -91,23 +91,28 @@ xfs_growfs_data_private(
> >  	xfs_agnumber_t		nagcount;
> >  	xfs_agnumber_t		nagimax = 0;
> >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> > -	xfs_rfsblock_t		delta;
> > +	int64_t			delta;
> >  	bool			lastag_resetagres;
> >  	xfs_agnumber_t		oagcount;
> >  	struct xfs_trans	*tp;
> >  	struct aghdr_init_data	id = {};
> >  
> >  	nb = in->newblocks;
> > -	if (nb < mp->m_sb.sb_dblocks)
> > -		return -EINVAL;
> > -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
> > +	if (nb == mp->m_sb.sb_dblocks)
> > +		return 0;
> 
> It looks like the caller already does this check.

yeah, will remove it. Thanks for pointing out.

> 
> > +
> > +	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
> > +	if (error)
> >  		return error;
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
> >  	nb_div = nb;
> >  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > @@ -115,10 +120,15 @@ xfs_growfs_data_private(
> >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> >  		nagcount--;
> >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > -		if (nb < mp->m_sb.sb_dblocks)
> > -			return -EINVAL;
> >  	}
> >  	delta = nb - mp->m_sb.sb_dblocks;
> > +	/*
> > +	 * XFS doesn't really support single-AG filesystems, so do not
> > +	 * permit callers to remove the filesystem's second and last AG.
> > +	 */
> > +	if (delta < 0 && nagcount < 2)
> > +		return -EINVAL;
> > +
> 
> What if the filesystem is already single AG? Unless I'm missing
> something, we already have a check a bit further down that prevents
> removal of AGs in the first place.

I think it tends to forbid (return -EINVAL) shrinking the filesystem with
a single AG only? Am I missing something?

Thanks,
Gao Xiang

> 
> Otherwise looks reasonable..
> 
> Brian
> 
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > @@ -126,15 +136,22 @@ xfs_growfs_data_private(
> >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> >  		if (error)
> >  			return error;
> > +	} else if (nagcount < oagcount) {
> > +		/* TODO: shrinking the entire AGs hasn't yet completed */
> > +		return -EINVAL;
> >  	}
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > +			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > +			XFS_TRANS_RESERVE, &tp);
> >  	if (error)
> >  		return error;
> >  
> > -	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > -					  delta, &lastag_resetagres);
> > +	if (delta > 0)
> > +		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > +						  delta, &lastag_resetagres);
> > +	else
> > +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -145,7 +162,7 @@ xfs_growfs_data_private(
> >  	 */
> >  	if (nagcount > oagcount)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > -	if (delta > 0)
> > +	if (delta)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> >  	if (id.nfree)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > @@ -169,28 +186,29 @@ xfs_growfs_data_private(
> >  	xfs_set_low_space_thresholds(mp);
> >  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> >  
> > -	/*
> > -	 * If we expanded the last AG, free the per-AG reservation
> > -	 * so we can reinitialize it with the new size.
> > -	 */
> > -	if (lastag_resetagres) {
> > -		struct xfs_perag	*pag;
> > -
> > -		pag = xfs_perag_get(mp, id.agno);
> > -		error = xfs_ag_resv_free(pag);
> > -		xfs_perag_put(pag);
> > -		if (error)
> > -			return error;
> > +	if (delta > 0) {
> > +		/*
> > +		 * If we expanded the last AG, free the per-AG reservation
> > +		 * so we can reinitialize it with the new size.
> > +		 */
> > +		if (lastag_resetagres) {
> > +			struct xfs_perag	*pag;
> > +
> > +			pag = xfs_perag_get(mp, id.agno);
> > +			error = xfs_ag_resv_free(pag);
> > +			xfs_perag_put(pag);
> > +			if (error)
> > +				return error;
> > +		}
> > +		/*
> > +		 * Reserve AG metadata blocks. ENOSPC here does not mean there
> > +		 * was a growfs failure, just that there still isn't space for
> > +		 * new user data after the grow has been run.
> > +		 */
> > +		error = xfs_fs_reserve_ag_blocks(mp);
> > +		if (error == -ENOSPC)
> > +			error = 0;
> >  	}
> > -
> > -	/*
> > -	 * Reserve AG metadata blocks. ENOSPC here does not mean there was a
> > -	 * growfs failure, just that there still isn't space for new user data
> > -	 * after the grow has been run.
> > -	 */
> > -	error = xfs_fs_reserve_ag_blocks(mp);
> > -	if (error == -ENOSPC)
> > -		error = 0;
> >  	return error;
> >  
> >  out_trans_cancel:
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 44f72c09c203..d047f5f26cc0 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -434,7 +434,6 @@ xfs_trans_mod_sb(
> >  		tp->t_res_frextents_delta += delta;
> >  		break;
> >  	case XFS_TRANS_SB_DBLOCKS:
> > -		ASSERT(delta > 0);
> >  		tp->t_dblocks_delta += delta;
> >  		break;
> >  	case XFS_TRANS_SB_AGCOUNT:
> > -- 
> > 2.27.0
> > 
> 


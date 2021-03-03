Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7EB5C433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 01:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7599D64E99
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 01:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhCDBCk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:02:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355299AbhCDAWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 19:22:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614817243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MYBCVWHvbTxt12nb4+86cSYxDBRPg+AQisj/2YmyfKI=;
        b=XdB4yP9lv51uXjgqLkcp+tBZqJsbPFTal62JQ4p5VAji9K8Mq3FOesfLVfai1fsH2ubuq9
        8+pAJIWjiOSKUmlNd8qEZUGMgYawt+mg4UkqvYjn8ig+piPYpWI7TFY1hK5tkFMPjiRtKe
        PxplB8zvSkJ5MQDtKdAd1pUKCwrTNCI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Tcr8q9YyNWuHPe3iSy-lPg-1; Wed, 03 Mar 2021 18:19:54 -0500
X-MC-Unique: Tcr8q9YyNWuHPe3iSy-lPg-1
Received: by mail-pf1-f200.google.com with SMTP id u188so16771116pfu.23
        for <linux-xfs@vger.kernel.org>; Wed, 03 Mar 2021 15:19:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MYBCVWHvbTxt12nb4+86cSYxDBRPg+AQisj/2YmyfKI=;
        b=Z0ho3hwDcQeCpGcYzOEmvelEOiUdfFFy4mZMUYkKkYdLCjvJIt7SdYqrpPDQ6Fdv8S
         bwmknzthn/hi6Dr0eX+UXAqxJsUo0j+pFQ0X42RWGJyPTe6jvAPS6O+r0eAp+n08cqP3
         n5/atD8DRAZwtyOjFePi1bS3X5Rlouze2xqSpN4komAP+Yli+CaHOVyw7Y3i72JA0rcF
         l2qFsG3lxGjG4/KElm2Nw2ANZPCFsrfOEUKVBPaCVTXjgeANhi8jMXcJPkrdY2SLbtiy
         iQ96H7/e5ipteEA73Vo1Ed3Kxe6JEV0ySCLWXz5wzZmw4t5aXJvJhruIeybyUvvoz9y+
         HJqg==
X-Gm-Message-State: AOAM533EYSPxIAQX/InkDZ9p1KUrm+V8unVd1Mztll4xjf9oy/lFtAM+
        Xs4xoPN/mcJaTbO4VK7lKLp667qjo2Wskp5byS8R8SbJAkivQjJEh0+jC/8zr9at7bkvy3UfAR1
        uHosQERQKHr7kABD6ALHs
X-Received: by 2002:a63:580d:: with SMTP id m13mr1139217pgb.342.1614813593559;
        Wed, 03 Mar 2021 15:19:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0fZriF7pTjhc6+FbDU4ndkusbaVeDkWn0+e3IT56Tp+OMPslACZ8BzQ73rZfjMEs53KKR9A==
X-Received: by 2002:a63:580d:: with SMTP id m13mr1139201pgb.342.1614813593302;
        Wed, 03 Mar 2021 15:19:53 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g8sm27107900pfu.13.2021.03.03.15.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 15:19:51 -0800 (PST)
Date:   Thu, 4 Mar 2021 07:19:40 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210303231940.GD2843084@xiangao.remote.csb>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-5-hsiangkao@redhat.com>
 <20210303182527.GC3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303182527.GC3419940@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 10:25:27AM -0800, Darrick J. Wong wrote:
> On Tue, Mar 02, 2021 at 10:48:15AM +0800, Gao Xiang wrote:
> > As the first step of shrinking, this attempts to enable shrinking
> > unused space in the last allocation group by fixing up freespace
> > btree, agi, agf and adjusting super block and use a helper
> > xfs_ag_shrink_space() to fixup the last AG.
> > 
> > This can be all done in one transaction for now, so I think no
> > additional protection is needed.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 90 ++++++++++++++++++++++++++++------------------
> >  fs/xfs/xfs_trans.c |  1 -
> >  2 files changed, 55 insertions(+), 36 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 494f9354e3fb..204c96d0010f 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -90,23 +90,29 @@ xfs_growfs_data_private(
> >  	int			error;
> >  	xfs_agnumber_t		nagcount;
> >  	xfs_agnumber_t		nagimax = 0;
> > -	xfs_rfsblock_t		nb, nb_div, nb_mod, delta;
> > +	xfs_rfsblock_t		nb, nb_div, nb_mod;
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
> > @@ -114,10 +120,15 @@ xfs_growfs_data_private(
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
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > @@ -125,15 +136,23 @@ xfs_growfs_data_private(
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
> 
> Hm, looking back at the previous patch, I think the last argument to
> this function should be named "shrink_len" (or maybe just delta?) so
> that future readers don't confuse it for the new (shorter) AG length.
> 

Ok, will update in the next version.

> > +
> 
> Nit: no blank line needed here.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

Thanks,
Gao Xiang

> 
> --D
> 
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -144,7 +163,7 @@ xfs_growfs_data_private(
> >  	 */
> >  	if (nagcount > oagcount)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > -	if (delta > 0)
> > +	if (delta)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> >  	if (id.nfree)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > @@ -168,28 +187,29 @@ xfs_growfs_data_private(
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


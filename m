Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78606C433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30A4261A2D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 00:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhCYAvE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 20:51:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232384AbhCYAud (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 20:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616633432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X5ZZ+uH0814yueQ8/fBokGZe4KqHeK0i1gNyysbCqWA=;
        b=OvxIBZGLb2oLK0W2u2VTd2KsrHjdkGjQ51YRDwQNFzsgYUTjNGtn7eBWBM+VFAfe0QO6b3
        j9dj5RVvM4OdGY+eJ99F62HQIwXWwgwmwThYgDY/mg5Q9jZCjrzEt5TbQHqDwNdRQ7X31f
        X8e0sQ1VbX0xorgkMCQGGEXxYuE6UxI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-wEBfzgE3Pl-1h_L2dDtTug-1; Wed, 24 Mar 2021 20:50:31 -0400
X-MC-Unique: wEBfzgE3Pl-1h_L2dDtTug-1
Received: by mail-pf1-f197.google.com with SMTP id z11so2505847pfe.12
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 17:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X5ZZ+uH0814yueQ8/fBokGZe4KqHeK0i1gNyysbCqWA=;
        b=q6NeIKNRuforxfJ7PUgHXlwY3tCI99N8AjsNjwScusLsPXw5UJQFpn5WAL7vvZQmd7
         //LY/hGnz7bkPJWaZWBHuyGyanjlEHOpXHY3QU59IudntozuvYbUH2Na8TB/O8oLWNfh
         SonF6wWjBs4EmhlFAWPqcNPlGQuUIi54lkSXETnwgdC7uVHO18lowVvpSeWG3B34lVpU
         1DMk7hKWkSS0jt+89sUejvBQi7nVE8GLLPWgGwPzrwbQ/9gWRBHI1WujwoyCUsm+HEN5
         ISvkRtltbkLjA5QeFioW2xBmXPdJ5WB8w1w9vzsdfSR3bFppP3uXBEyimrWDFrabm3i+
         6USg==
X-Gm-Message-State: AOAM533rsLCBLgVaPxc7i95zHrPdYUfCwvkLGDMgmhyGBCCeW+OsFVSe
        YFzdHmR1TUP/uMKgdikfPINNyOplT6BxHkJ7d7LpLmpJxW0P+PhK9SZnWJO/71IBTj2st+KHm/g
        bDvCvRvkHnN9t8dwZyBzX
X-Received: by 2002:aa7:908c:0:b029:209:aacd:d8b with SMTP id i12-20020aa7908c0000b0290209aacd0d8bmr5450367pfa.74.1616633429909;
        Wed, 24 Mar 2021 17:50:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9jq030EsIfiHVQ1qhAa8/xswXX17e+eFYyJ93k7nDHEpqsE4KrfblrQo3VosnRhMFICtOcQ==
X-Received: by 2002:aa7:908c:0:b029:209:aacd:d8b with SMTP id i12-20020aa7908c0000b0290209aacd0d8bmr5450329pfa.74.1616633429420;
        Wed, 24 Mar 2021 17:50:29 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm3786206pfl.1.2021.03.24.17.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 17:50:29 -0700 (PDT)
Date:   Thu, 25 Mar 2021 08:50:18 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v9 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210325005018.GB2421109@xiangao.remote.csb>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
 <20210324010621.2244671-5-hsiangkao@redhat.com>
 <20210324173438.GV22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324173438.GV22100@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Mar 24, 2021 at 10:34:38AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 24, 2021 at 09:06:20AM +0800, Gao Xiang wrote:
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
> >  fs/xfs/xfs_fsops.c | 84 +++++++++++++++++++++++++++-------------------
> >  fs/xfs/xfs_trans.c |  1 -
> >  2 files changed, 50 insertions(+), 35 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index d1ba04124c28..9457b0691ece 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -91,23 +91,25 @@ xfs_growfs_data_private(
> >  	xfs_agnumber_t		nagcount;
> >  	xfs_agnumber_t		nagimax = 0;
> >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> > -	xfs_rfsblock_t		delta;
> > +	int64_t			delta;
> >  	bool			lastag_extended;
> >  	xfs_agnumber_t		oagcount;
> >  	struct xfs_trans	*tp;
> >  	struct aghdr_init_data	id = {};
> >  
> >  	nb = in->newblocks;
> > -	if (nb < mp->m_sb.sb_dblocks)
> > -		return -EINVAL;
> > -	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
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
> > @@ -115,10 +117,16 @@ xfs_growfs_data_private(
> >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> >  		nagcount--;
> >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > -		if (nb < mp->m_sb.sb_dblocks)
> > -			return -EINVAL;
> >  	}
> >  	delta = nb - mp->m_sb.sb_dblocks;
> > +	/*
> > +	 * Reject filesystems with a single AG because they are not
> > +	 * supported, and reject a shrink operation that would cause a
> > +	 * filesystem to become unsupported.
> > +	 */
> > +	if (delta < 0 && nagcount < 2)
> > +		return -EINVAL;
> > +
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > @@ -126,15 +134,22 @@ xfs_growfs_data_private(
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
> > -					  delta, &lastag_extended);
> > +	if (delta > 0)
> > +		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > +						  delta, &lastag_extended);
> > +	else
> > +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> 
> Assuming I don't hear anyone yelling NAK in the next day or so, I think
> I'll stage this for 5.13 with the following change to warn that the
> shrink feature is still EXPERIMENTAL:
> 
> By the way, are you going to send a patch to shrink the realtime device
> too?

My first priority will form the formal shrink-whole-AG patchset after this
is finalized.
I have little experience about rt device, maybe leave it later.

> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 9457b0691ece..b33c894b6cf3 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -145,11 +145,20 @@ xfs_growfs_data_private(
>  	if (error)
>  		return error;
>  
> -	if (delta > 0)
> +	if (delta > 0) {
>  		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
>  						  delta, &lastag_extended);
> -	else
> +	} else {
> +		static struct ratelimit_state shrink_warning = \
> +			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
> +		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
> +
> +		if (__ratelimit(&shrink_warning))
> +			xfs_alert(mp,
> +	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
> +
>  		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> +	}
>  	if (error)
>  		goto out_trans_cancel;

I'm fine with that, thanks for updating. :)

Thanks,
Gao Xiang

>  
> --D
> 
> >  	if (error)
> >  		goto out_trans_cancel;
> >  
> > @@ -169,28 +184,29 @@ xfs_growfs_data_private(
> >  	xfs_set_low_space_thresholds(mp);
> >  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> >  
> > -	/*
> > -	 * If we expanded the last AG, free the per-AG reservation
> > -	 * so we can reinitialize it with the new size.
> > -	 */
> > -	if (lastag_extended) {
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
> > +		if (lastag_extended) {
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
> > index b22a09e9daee..052274321993 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -436,7 +436,6 @@ xfs_trans_mod_sb(
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


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8800AC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61EC5619CA
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhCVMin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:38:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231895AbhCVMhH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 08:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616416626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t29JGDIz+L1MEJqLIWyuHwyXdE++p9eWUOra1IqcDhI=;
        b=FL8TGa9KB7Obl5RCetdJUImTRxvgofB/bx0auXXf5wzDdbF97mTBi+4v6wEtwd2kBaBJ3Y
        luhS5uqDAiTWjykExcs1Rg2FgZC/SInHUmC3TicphQqhsyjMpm5WKNb57Yrt0DamPbAvco
        qvkZKujQDq1lgEvYGsDVCAveNelRvQA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-DlzgI_64P6e1dg8oy80M4A-1; Mon, 22 Mar 2021 08:37:04 -0400
X-MC-Unique: DlzgI_64P6e1dg8oy80M4A-1
Received: by mail-pl1-f199.google.com with SMTP id d11so26968715plc.19
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 05:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t29JGDIz+L1MEJqLIWyuHwyXdE++p9eWUOra1IqcDhI=;
        b=hizY47pkdITVaxAriIqQpPASB31zvgRJG6aRf3WQUSyvKJEJfTXPvgI7JrTHDs5tSX
         2KMy1eO7sZEfMc0wmOkdPbUv9u8eV3pvEAPsyjfSjC9OankV0vOeeDxCnRhkQ4hgISXg
         6N64BsO3VoBQRw+HcTfrdmEClu3f9Q6uET5/N37x5T1qO8DwsRc+Os1C/qRWs9bvrLcb
         Vo3ZyrmwIFP1XzJICRyEu1X/pFjQ6MxpVMEfTxiZ6lTzMuoRGprnQcKjpzwK5JxvVGJ9
         CoDU6Rkcmwr2rJawwWODr7WfpdbfvfzWgW6gxkOcrSjZ3TSalHVbP78bZvV7Z9DKGsGj
         4YFw==
X-Gm-Message-State: AOAM531zuz0fNdfqxTagsOdqaDzxSd0VcZeF45LcDXy6bFsltjfDo0gn
        L876Z9u+2LmCNm0VglRCeAEP4+tkthceqOZIrgkm3EHDkMFMIuOxEuByL3cT967sFfOurz4RpaL
        IaigH1FGFl0yuB5crruNJ
X-Received: by 2002:a63:2d45:: with SMTP id t66mr21852908pgt.449.1616416623682;
        Mon, 22 Mar 2021 05:37:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLhzuS4dhsqGftMiVA4yvu/YBSaF5XTSEk8gv5pV/RMiOjogE7AbhODQkeVtiOI6XBEwlTCQ==
X-Received: by 2002:a63:2d45:: with SMTP id t66mr21852895pgt.449.1616416623418;
        Mon, 22 Mar 2021 05:37:03 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t1sm13903972pfc.173.2021.03.22.05.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 05:37:02 -0700 (PDT)
Date:   Mon, 22 Mar 2021 20:36:52 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210322123652.GB2007006@xiangao.remote.csb>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-5-hsiangkao@redhat.com>
 <YFh/4A/9OPzHJ2pi@bfoster>
 <20210322120722.GC2000812@xiangao.remote.csb>
 <YFiNATNnkFNAM7MR@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFiNATNnkFNAM7MR@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 08:26:41AM -0400, Brian Foster wrote:
> On Mon, Mar 22, 2021 at 08:07:22PM +0800, Gao Xiang wrote:
> > On Mon, Mar 22, 2021 at 07:30:40AM -0400, Brian Foster wrote:
> > > On Fri, Mar 05, 2021 at 10:57:02AM +0800, Gao Xiang wrote:
> > > > As the first step of shrinking, this attempts to enable shrinking
> > > > unused space in the last allocation group by fixing up freespace
> > > > btree, agi, agf and adjusting super block and use a helper
> > > > xfs_ag_shrink_space() to fixup the last AG.
> > > > 
> > > > This can be all done in one transaction for now, so I think no
> > > > additional protection is needed.
> > > > 
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_fsops.c | 88 ++++++++++++++++++++++++++++------------------
> > > >  fs/xfs/xfs_trans.c |  1 -
> > > >  2 files changed, 53 insertions(+), 36 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > index fc9e799b2ae3..71cba61a451c 100644
> > > > --- a/fs/xfs/xfs_fsops.c
> > > > +++ b/fs/xfs/xfs_fsops.c
> ...
> > > > @@ -115,10 +120,15 @@ xfs_growfs_data_private(
> > > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > > >  		nagcount--;
> > > >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > > -		if (nb < mp->m_sb.sb_dblocks)
> > > > -			return -EINVAL;
> > > >  	}
> > > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > > +	/*
> > > > +	 * XFS doesn't really support single-AG filesystems, so do not
> > > > +	 * permit callers to remove the filesystem's second and last AG.
> > > > +	 */
> > > > +	if (delta < 0 && nagcount < 2)
> > > > +		return -EINVAL;
> > > > +
> > > 
> > > What if the filesystem is already single AG? Unless I'm missing
> > > something, we already have a check a bit further down that prevents
> > > removal of AGs in the first place.
> > 
> > I think it tends to forbid (return -EINVAL) shrinking the filesystem with
> > a single AG only? Am I missing something?
> > 
> 
> My assumption was this check means one can't shrink a filesystem that is
> already agcount == 1. The comment refers to preventing shrink from
> causing an agcount == 1 fs. What is the intent?

I think it means the latter -- preventing shrink from causing an agcount == 1
fs. since nagcount (new agcount) <= 1?

Actually, I'm not good at English, if comments need to be improved, please
kindly point out. Thank you very much!

Thanks,
Gao Xiang

> 
> Brian
> 
> > Thanks,
> > Gao Xiang
> > 
> > > 
> > > Otherwise looks reasonable..
> > > 
> > > Brian
> > > 
> > > >  	oagcount = mp->m_sb.sb_agcount;
> > > >  
> > > >  	/* allocate the new per-ag structures */
> > > > @@ -126,15 +136,22 @@ xfs_growfs_data_private(
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
> > > > +			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > > > +			XFS_TRANS_RESERVE, &tp);
> > > >  	if (error)
> > > >  		return error;
> > > >  
> > > > -	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > > > -					  delta, &lastag_resetagres);
> > > > +	if (delta > 0)
> > > > +		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > > > +						  delta, &lastag_resetagres);
> > > > +	else
> > > > +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> > > >  	if (error)
> > > >  		goto out_trans_cancel;
> > > >  
> > > > @@ -145,7 +162,7 @@ xfs_growfs_data_private(
> > > >  	 */
> > > >  	if (nagcount > oagcount)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > > -	if (delta > 0)
> > > > +	if (delta)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> > > >  	if (id.nfree)
> > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > > > @@ -169,28 +186,29 @@ xfs_growfs_data_private(
> > > >  	xfs_set_low_space_thresholds(mp);
> > > >  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> > > >  
> > > > -	/*
> > > > -	 * If we expanded the last AG, free the per-AG reservation
> > > > -	 * so we can reinitialize it with the new size.
> > > > -	 */
> > > > -	if (lastag_resetagres) {
> > > > -		struct xfs_perag	*pag;
> > > > -
> > > > -		pag = xfs_perag_get(mp, id.agno);
> > > > -		error = xfs_ag_resv_free(pag);
> > > > -		xfs_perag_put(pag);
> > > > -		if (error)
> > > > -			return error;
> > > > +	if (delta > 0) {
> > > > +		/*
> > > > +		 * If we expanded the last AG, free the per-AG reservation
> > > > +		 * so we can reinitialize it with the new size.
> > > > +		 */
> > > > +		if (lastag_resetagres) {
> > > > +			struct xfs_perag	*pag;
> > > > +
> > > > +			pag = xfs_perag_get(mp, id.agno);
> > > > +			error = xfs_ag_resv_free(pag);
> > > > +			xfs_perag_put(pag);
> > > > +			if (error)
> > > > +				return error;
> > > > +		}
> > > > +		/*
> > > > +		 * Reserve AG metadata blocks. ENOSPC here does not mean there
> > > > +		 * was a growfs failure, just that there still isn't space for
> > > > +		 * new user data after the grow has been run.
> > > > +		 */
> > > > +		error = xfs_fs_reserve_ag_blocks(mp);
> > > > +		if (error == -ENOSPC)
> > > > +			error = 0;
> > > >  	}
> > > > -
> > > > -	/*
> > > > -	 * Reserve AG metadata blocks. ENOSPC here does not mean there was a
> > > > -	 * growfs failure, just that there still isn't space for new user data
> > > > -	 * after the grow has been run.
> > > > -	 */
> > > > -	error = xfs_fs_reserve_ag_blocks(mp);
> > > > -	if (error == -ENOSPC)
> > > > -		error = 0;
> > > >  	return error;
> > > >  
> > > >  out_trans_cancel:
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 44f72c09c203..d047f5f26cc0 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -434,7 +434,6 @@ xfs_trans_mod_sb(
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
> 


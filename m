Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CFDC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94C561931
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhCVQnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhCVQm4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Mar 2021 12:42:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4456198D;
        Mon, 22 Mar 2021 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616431376;
        bh=eiLBm6C4ky4iMXhrWyw9o6JspRAiQS5Yd9YT0Jh1pEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TydDahE+qFG8Cfp61pFWt4VFHy3k3bT8WBivqXoDj6FBRokKuI6ge7MkU1skkQjBC
         663oexos5ub9OWqpwgJz9OrvPuHyntBQlO6ufS3ZisYG4uscsPXE9HqDflVWW9T8u9
         iJXIAINcmFMFymjH53moRgMAfoP6gUxWaFK4HpgQX5uAXAiwIX0XHVZJaY/6+rLqe7
         XQg1K5yurxX3H361ensW7L1Kvv2qqV+dgqIN9JO3m5Z48eDIWeT/G+jS6K+CTR0ZXl
         a//yZ9HXVqepFEeeg2f7QXfQ/dTB67NVDt6iKvOBT7xdJmUq1mfSNi3rKBUvft2r5u
         62C7ON8n74xmg==
Date:   Mon, 22 Mar 2021 09:42:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210322164255.GE22100@magnolia>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-5-hsiangkao@redhat.com>
 <YFh/4A/9OPzHJ2pi@bfoster>
 <20210322120722.GC2000812@xiangao.remote.csb>
 <YFiNATNnkFNAM7MR@bfoster>
 <20210322123652.GB2007006@xiangao.remote.csb>
 <YFiQ5zkOiDHx5YzY@bfoster>
 <20210322125028.GC2007006@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322125028.GC2007006@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 08:50:28PM +0800, Gao Xiang wrote:
> On Mon, Mar 22, 2021 at 08:43:19AM -0400, Brian Foster wrote:
> > On Mon, Mar 22, 2021 at 08:36:52PM +0800, Gao Xiang wrote:
> > > On Mon, Mar 22, 2021 at 08:26:41AM -0400, Brian Foster wrote:
> > > > On Mon, Mar 22, 2021 at 08:07:22PM +0800, Gao Xiang wrote:
> > > > > On Mon, Mar 22, 2021 at 07:30:40AM -0400, Brian Foster wrote:
> > > > > > On Fri, Mar 05, 2021 at 10:57:02AM +0800, Gao Xiang wrote:
> > > > > > > As the first step of shrinking, this attempts to enable shrinking
> > > > > > > unused space in the last allocation group by fixing up freespace
> > > > > > > btree, agi, agf and adjusting super block and use a helper
> > > > > > > xfs_ag_shrink_space() to fixup the last AG.
> > > > > > > 
> > > > > > > This can be all done in one transaction for now, so I think no
> > > > > > > additional protection is needed.
> > > > > > > 
> > > > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > > > > ---
> > > > > > >  fs/xfs/xfs_fsops.c | 88 ++++++++++++++++++++++++++++------------------
> > > > > > >  fs/xfs/xfs_trans.c |  1 -
> > > > > > >  2 files changed, 53 insertions(+), 36 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > > > > index fc9e799b2ae3..71cba61a451c 100644
> > > > > > > --- a/fs/xfs/xfs_fsops.c
> > > > > > > +++ b/fs/xfs/xfs_fsops.c
> > > > ...
> > > > > > > @@ -115,10 +120,15 @@ xfs_growfs_data_private(
> > > > > > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > > > > > >  		nagcount--;
> > > > > > >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > > > > > -		if (nb < mp->m_sb.sb_dblocks)
> > > > > > > -			return -EINVAL;
> > > > > > >  	}
> > > > > > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > > > > > +	/*
> > > > > > > +	 * XFS doesn't really support single-AG filesystems, so do not
> > > > > > > +	 * permit callers to remove the filesystem's second and last AG.
> > > > > > > +	 */
> > > > > > > +	if (delta < 0 && nagcount < 2)
> > > > > > > +		return -EINVAL;
> > > > > > > +
> > > > > > 
> > > > > > What if the filesystem is already single AG? Unless I'm missing
> > > > > > something, we already have a check a bit further down that prevents
> > > > > > removal of AGs in the first place.
> > > > > 
> > > > > I think it tends to forbid (return -EINVAL) shrinking the filesystem with
> > > > > a single AG only? Am I missing something?
> > > > > 
> > > > 
> > > > My assumption was this check means one can't shrink a filesystem that is
> > > > already agcount == 1. The comment refers to preventing shrink from
> > > > causing an agcount == 1 fs. What is the intent?

Both of those things.

> > > 
> > > I think it means the latter -- preventing shrink from causing an agcount == 1
> > > fs. since nagcount (new agcount) <= 1?
> > > 
> > 
> > Right, so that leads to my question... does this check also fail a
> > shrink on an fs that is already agcount == 1? If so, why? I know
> > technically it's not a supported configuration, but mkfs allows it.
> 
> Ah, I'm not sure if Darrick would like to forbid agcount == 1 shrinking
> functionitity completely, see the previous comment:
> https://lore.kernel.org/r/20201014160633.GD9832@magnolia/
> 
> (please ignore the modification at that time, since it was buggy...)

Given the confusion I propose a new comment:

	/*
	 * Reject filesystems with a single AG because they are not
	 * supported, and reject a shrink operation that would cause a
	 * filesystem to become unsupported.
	 */
	if (delta < 0 && nagcount < 2)
		return -EINVAL;

--D

> 
> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> > 
> > > Actually, I'm not good at English, if comments need to be improved, please
> > > kindly point out. Thank you very much!
> > > 
> > > Thanks,
> > > Gao Xiang
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > > Thanks,
> > > > > Gao Xiang
> > > > > 
> > > > > > 
> > > > > > Otherwise looks reasonable..
> > > > > > 
> > > > > > Brian
> > > > > > 
> > > > > > >  	oagcount = mp->m_sb.sb_agcount;
> > > > > > >  
> > > > > > >  	/* allocate the new per-ag structures */
> > > > > > > @@ -126,15 +136,22 @@ xfs_growfs_data_private(
> > > > > > >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > > > > > >  		if (error)
> > > > > > >  			return error;
> > > > > > > +	} else if (nagcount < oagcount) {
> > > > > > > +		/* TODO: shrinking the entire AGs hasn't yet completed */
> > > > > > > +		return -EINVAL;
> > > > > > >  	}
> > > > > > >  
> > > > > > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > > > > > > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > > > > > > +			(delta > 0 ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > > > > > > +			XFS_TRANS_RESERVE, &tp);
> > > > > > >  	if (error)
> > > > > > >  		return error;
> > > > > > >  
> > > > > > > -	error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > > > > > > -					  delta, &lastag_resetagres);
> > > > > > > +	if (delta > 0)
> > > > > > > +		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
> > > > > > > +						  delta, &lastag_resetagres);
> > > > > > > +	else
> > > > > > > +		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
> > > > > > >  	if (error)
> > > > > > >  		goto out_trans_cancel;
> > > > > > >  
> > > > > > > @@ -145,7 +162,7 @@ xfs_growfs_data_private(
> > > > > > >  	 */
> > > > > > >  	if (nagcount > oagcount)
> > > > > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > > > > > > -	if (delta > 0)
> > > > > > > +	if (delta)
> > > > > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);
> > > > > > >  	if (id.nfree)
> > > > > > >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > > > > > > @@ -169,28 +186,29 @@ xfs_growfs_data_private(
> > > > > > >  	xfs_set_low_space_thresholds(mp);
> > > > > > >  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> > > > > > >  
> > > > > > > -	/*
> > > > > > > -	 * If we expanded the last AG, free the per-AG reservation
> > > > > > > -	 * so we can reinitialize it with the new size.
> > > > > > > -	 */
> > > > > > > -	if (lastag_resetagres) {
> > > > > > > -		struct xfs_perag	*pag;
> > > > > > > -
> > > > > > > -		pag = xfs_perag_get(mp, id.agno);
> > > > > > > -		error = xfs_ag_resv_free(pag);
> > > > > > > -		xfs_perag_put(pag);
> > > > > > > -		if (error)
> > > > > > > -			return error;
> > > > > > > +	if (delta > 0) {
> > > > > > > +		/*
> > > > > > > +		 * If we expanded the last AG, free the per-AG reservation
> > > > > > > +		 * so we can reinitialize it with the new size.
> > > > > > > +		 */
> > > > > > > +		if (lastag_resetagres) {
> > > > > > > +			struct xfs_perag	*pag;
> > > > > > > +
> > > > > > > +			pag = xfs_perag_get(mp, id.agno);
> > > > > > > +			error = xfs_ag_resv_free(pag);
> > > > > > > +			xfs_perag_put(pag);
> > > > > > > +			if (error)
> > > > > > > +				return error;
> > > > > > > +		}
> > > > > > > +		/*
> > > > > > > +		 * Reserve AG metadata blocks. ENOSPC here does not mean there
> > > > > > > +		 * was a growfs failure, just that there still isn't space for
> > > > > > > +		 * new user data after the grow has been run.
> > > > > > > +		 */
> > > > > > > +		error = xfs_fs_reserve_ag_blocks(mp);
> > > > > > > +		if (error == -ENOSPC)
> > > > > > > +			error = 0;
> > > > > > >  	}
> > > > > > > -
> > > > > > > -	/*
> > > > > > > -	 * Reserve AG metadata blocks. ENOSPC here does not mean there was a
> > > > > > > -	 * growfs failure, just that there still isn't space for new user data
> > > > > > > -	 * after the grow has been run.
> > > > > > > -	 */
> > > > > > > -	error = xfs_fs_reserve_ag_blocks(mp);
> > > > > > > -	if (error == -ENOSPC)
> > > > > > > -		error = 0;
> > > > > > >  	return error;
> > > > > > >  
> > > > > > >  out_trans_cancel:
> > > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > > index 44f72c09c203..d047f5f26cc0 100644
> > > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > > @@ -434,7 +434,6 @@ xfs_trans_mod_sb(
> > > > > > >  		tp->t_res_frextents_delta += delta;
> > > > > > >  		break;
> > > > > > >  	case XFS_TRANS_SB_DBLOCKS:
> > > > > > > -		ASSERT(delta > 0);
> > > > > > >  		tp->t_dblocks_delta += delta;
> > > > > > >  		break;
> > > > > > >  	case XFS_TRANS_SB_AGCOUNT:
> > > > > > > -- 
> > > > > > > 2.27.0
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 

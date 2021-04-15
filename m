Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A996C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 04:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E797D61132
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 04:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhDOEfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 00:35:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhDOEfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 00:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618461283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xJHvf5jN6Cywr4EZEaj24iWZca52klUQP7r+ynBlQ54=;
        b=Hsa86W95asSUJH2730cdzP5PacjZJvJMFsknVNTAkpNX6Cq95CG8SIApmGniYWIVBzYKFe
        orZjJwSzfobET4F1hnw0s1s1Gdps9gIvhxfcz+gTkfZ+Spn53mqQi21SHaW5TLoTi1ZPIh
        t2tjhEXVv7fD2tuoW8B6LNtYB8AxAF4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-J4FongfEPra3DeJHx0nTmA-1; Thu, 15 Apr 2021 00:34:42 -0400
X-MC-Unique: J4FongfEPra3DeJHx0nTmA-1
Received: by mail-pj1-f69.google.com with SMTP id p14-20020a17090a428eb02900fc9e178ef3so9744546pjg.5
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 21:34:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xJHvf5jN6Cywr4EZEaj24iWZca52klUQP7r+ynBlQ54=;
        b=PTi9oc5lh5cRXmK0wg0g+sV+C2jGpd5CNfLqDvzblTTOH8OJLNOz7QWHicGn5NIYQO
         WtsSuWtYb9xM8np02PFnQWZc9iyn8gwJFsd7KgBQFbSjcm8P2+zsGCFepwb3iNh2ptUq
         rJEm4O72sMaxeHoElNAMl4mLC8WjPrlHmDIMf2zFrEnE8kxy6lBCz7IeLxRa04qc25bb
         edIIjcirufwM7pdiRwBujStX7Bddh9zkF59kJTRACvD1769n1nL1qm1wHTTmAuJ6t2Ro
         vzcLCuSMnq4yUAG63Ey115AnvpDD4fkV0yIUusV92BDP1Cy9b4j1GmMCqnomSpnna+Jk
         wRSg==
X-Gm-Message-State: AOAM530SuhTSICW0smd6XozdfWqyNc9ymWt+oM4q2PoSOUgARuGQVaHo
        P6Uuxf13qmvzrVnPjKJLO11u5K/bv7bKy4qWdfUuavGAQceb/rdJ7QZO8MKmDmnjYXEPg4Dyt1p
        TvDkY2JATKK54s7dCyfvD
X-Received: by 2002:a63:1e4d:: with SMTP id p13mr1768607pgm.238.1618461280659;
        Wed, 14 Apr 2021 21:34:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpTKnfdxsjzqpIVMKzSJtd2MaJJ0qem88tNFuNAmkLC6Wlq7kJmA8DdYwKXLB8MX3IB3sDWw==
X-Received: by 2002:a63:1e4d:: with SMTP id p13mr1768597pgm.238.1618461280420;
        Wed, 14 Apr 2021 21:34:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g12sm774926pfo.114.2021.04.14.21.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 21:34:40 -0700 (PDT)
Date:   Thu, 15 Apr 2021 12:34:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] xfs: check ag is empty
Message-ID: <20210415043430.GB1864610@xiangao.remote.csb>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-3-hsiangkao@redhat.com>
 <20210415035252.GK63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210415035252.GK63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Apr 15, 2021 at 01:52:52PM +1000, Dave Chinner wrote:
> On Thu, Apr 15, 2021 at 03:52:38AM +0800, Gao Xiang wrote:
> > After a perag is stableized as inactive, we could check if such ag
> > is empty. In order to achieve that, AGFL is also needed to be
> > emptified in advance to make sure that only one freespace extent
> > will exist here.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 97 +++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc.h |  4 ++
> >  2 files changed, 101 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 01d4e4d4c1d6..60a8c134c00e 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2474,6 +2474,103 @@ xfs_defer_agfl_block(
> >  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
> >  }
> >  
> > +int
> > +xfs_ag_emptify_agfl(
> > +	struct xfs_buf		*agfbp)
> > +{
> > +	struct xfs_mount	*mp = agfbp->b_mount;
> > +	struct xfs_perag	*pag = agfbp->b_pag;
> > +	struct xfs_trans	*tp;
> > +	int			error;
> > +	struct xfs_owner_info	oinfo = XFS_RMAP_OINFO_AG;
> > +
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, 0, 0,
> > +				XFS_TRANS_RESERVE, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	/* attach to the transaction and keep it from unlocked */
> > +	xfs_trans_bjoin(tp, agfbp);
> > +	xfs_trans_bhold(tp, agfbp);
> > +
> > +	while (pag->pagf_flcount) {
> > +		xfs_agblock_t	bno;
> > +		int		error;
> > +
> > +		error = xfs_alloc_get_freelist(tp, agfbp, &bno, 0);
> > +		if (error)
> > +			break;
> > +
> > +		ASSERT(bno != NULLAGBLOCK);
> > +		xfs_defer_agfl_block(tp, pag->pag_agno, bno, &oinfo);
> > +	}
> > +	xfs_trans_set_sync(tp);
> > +	xfs_trans_commit(tp);
> > +	return error;
> > +}
> 
> Why do we need to empty the agfl to determine the AG is empty?
> 
> > +int
> > +xfs_ag_is_empty(
> > +	struct xfs_buf		*agfbp)
> > +{
> > +	struct xfs_mount	*mp = agfbp->b_mount;
> > +	struct xfs_perag	*pag = agfbp->b_pag;
> > +	struct xfs_agf		*agf = agfbp->b_addr;
> > +	struct xfs_btree_cur	*cnt_cur;
> > +	xfs_agblock_t		nfbno;
> > +	xfs_extlen_t		nflen;
> > +	int			error, i;
> > +
> > +	if (!pag->pag_inactive)
> > +		return -EINVAL;
> > +
> > +	if (pag->pagf_freeblks + pag->pagf_flcount !=
> > +	    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
> > +		return -ENOTEMPTY;
> 
> This is the empty check right here, yes?
> 
> Hmmm - this has to fail if the log is in this AG, right? Because we
> can't move the log (yet), so we should explicitly be checking that
> the log is in this AG before check the amount of free space...

Ok.

> 
> > +
> > +	if (pag->pagf_flcount) {
> > +		error = xfs_ag_emptify_agfl(agfbp);
> > +		if (error)
> > +			return error;
> > +
> > +		if (pag->pagf_freeblks !=
> > +		    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
> > +			return -ENOTEMPTY;
> > +	}
> > +
> > +	if (pag->pagi_count > 0 || pag->pagi_freecount > 0)
> > +		return -ENOTEMPTY;
> > +
> > +	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > 1 ||
> > +	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > 1)
> > +		return -ENOTEMPTY;
> > +
> > +	cnt_cur = xfs_allocbt_init_cursor(mp, NULL, agfbp,
> > +					  pag->pag_agno, XFS_BTNUM_CNT);
> > +	ASSERT(cnt_cur->bc_nlevels == 1);
> > +	error = xfs_alloc_lookup_ge(cnt_cur, 0,
> > +				    be32_to_cpu(agf->agf_longest), &i);
> > +	if (error || !i)
> > +		goto out;
> > +
> > +	error = xfs_alloc_get_rec(cnt_cur, &nfbno, &nflen, &i);
> > +	if (error)
> > +		goto out;
> > +
> > +	if (XFS_IS_CORRUPT(mp, i != 1)) {
> > +		error = -EFSCORRUPTED;
> > +		goto out;
> > +	}
> > +
> > +	error = -ENOTEMPTY;
> > +	if (nfbno == mp->m_ag_prealloc_blocks &&
> > +	    nflen == pag->pagf_freeblks)
> > +		error = 0;
> 
> Ah, that's why you are trying to empty the AGFL.
> 
> This won't work because the AG btree roots can be anywhere in the AG
> once the tree has grown beyond a single block. Hence when the AG is
> fully empty, the btree root blocks can still break up free space
> into multiple extents that are each less than a maximally sized
> single extent. e.g. from my workstation:
> 
> $ xfs_db -r -c "agf 0" -c "p" /dev/mapper/base-main 
> magicnum = 0x58414746
> versionnum = 1
> seqno = 0
> length = 13732864
> bnoroot = 29039
> cntroot = 922363
> rmaproot = 8461704
> refcntroot = 6
> bnolevel = 2
> cntlevel = 2
> rmaplevel = 3
> ....
> 
> none of the root blocks are inside the m_ag_prealloc_blocks region
> of the AG. m_ag_prealloc_blocks is just for space accounting and
> does not imply physical location of the btree root blocks...
> 
> Hence I think the only checks that need to be done here are whether
> the number of free blocks equals the maximal number of blocks
> available in the given AG.

Yeah, I forgot about it, thanks for reminder. Yet I vaguely remembered
you mentioned to check the freespace btree integrity before shrinking
months ago. If that is completely needed, I tend to kill such check
and leave the following check only,

	if (pag->pagf_freeblks + pag->pagf_flcount !=
	    be32_to_cpu(agf->agf_length) - mp->m_ag_prealloc_blocks)
		return -ENOTEMPTY;

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


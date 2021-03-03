Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF831C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 01:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7529B64F1B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 01:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbhCDBCj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:02:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442817AbhCDATj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Mar 2021 19:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614817086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m63C17+o5i9yTalNJxWr8p03y3CaZMLSZ8jgGbi+9zk=;
        b=Fidz9M98MpBsR0/dRq9FrFIB6mpdNp/IzmLh57Mhm7016nzbJK9VVg3tIfFWeODy5XMAwd
        DG9ZXAsnjbzi6g7d0UCU+/zDanye+sdis3b9bZoosoyFlG/asiYkIMe7jdpOWx4ypAF3oc
        eHhWCd5h2i6eh8HtyEgOJpqheLphBus=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-kPyxL6PrP5m5mgrDs7vWWw-1; Wed, 03 Mar 2021 18:16:21 -0500
X-MC-Unique: kPyxL6PrP5m5mgrDs7vWWw-1
Received: by mail-pf1-f199.google.com with SMTP id j7so16716458pfa.14
        for <linux-xfs@vger.kernel.org>; Wed, 03 Mar 2021 15:16:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m63C17+o5i9yTalNJxWr8p03y3CaZMLSZ8jgGbi+9zk=;
        b=S0Whe+vYGw5OxPOerCBZVNxFh27A6sLur9bjL7kVH0syR+q7lcATw1wXATkRrIJHSk
         GV5zgHwrvbgKcf/ovj11+VUwrHhoz5vgNyOe/y6IXkgyjEqn/72U+ImMOkl/gDBYraII
         mTIYQF5dGrZqvIYfh7lmiXkOWi5FSyUAFldBKOBAQkUpMTETLsK2n+D2b+cRxkZD+jQ6
         jph6E0Eyz48ZRePUWI4qYp/XYl8uHMvyCRRGQw+rUuViUupzK5CLwIjG7CZ3tga6Kz7o
         qaLdj6LRRwAEMgufPtzAJMrhlT40yfBN5y+ERa+zp04+5mmGwmvRJaVvTReqa7kXg4xB
         mbkQ==
X-Gm-Message-State: AOAM53294Jz4STEKbedfbeSi/qJHHb5JF9o9hG6jOrIyQCV+lOe5c4vI
        k62qnrGtTpmY90phbftjdiDKCJG/zp4SJ752z3R9Er+hl3wX723dbEhcKQuUWLhCAYXLFoXWV91
        vbGrVi1/4Gx0DlVzD3Cgz
X-Received: by 2002:a17:90a:ba16:: with SMTP id s22mr1491858pjr.88.1614813379719;
        Wed, 03 Mar 2021 15:16:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwM9UMYGq/eliVDQNrSByAnNHJL8gVbxs0oPLC2FwbP/FnloDm52Peoh9NLM4rUwJ+NRBZV0g==
X-Received: by 2002:a17:90a:ba16:: with SMTP id s22mr1491842pjr.88.1614813379443;
        Wed, 03 Mar 2021 15:16:19 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m12sm7496179pjk.47.2021.03.03.15.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 15:16:19 -0800 (PST)
Date:   Thu, 4 Mar 2021 07:16:08 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 3/5] xfs: introduce xfs_ag_shrink_space()
Message-ID: <20210303231608.GC2843084@xiangao.remote.csb>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-4-hsiangkao@redhat.com>
 <20210303181931.GB3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210303181931.GB3419940@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 10:19:31AM -0800, Darrick J. Wong wrote:
> On Tue, Mar 02, 2021 at 10:48:14AM +0800, Gao Xiang wrote:
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
> >  fs/xfs/libxfs/xfs_ag.c | 108 +++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_ag.h |   2 +
> >  2 files changed, 110 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index 9331f3516afa..a1128814630a 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -22,6 +22,11 @@
> >  #include "xfs_ag.h"
> >  #include "xfs_ag_resv.h"
> >  #include "xfs_health.h"
> > +#include "xfs_error.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans.h"
> >  
> >  static int
> >  xfs_get_aghdr_buf(
> > @@ -485,6 +490,109 @@ xfs_ag_init_headers(
> >  	return error;
> >  }
> >  
> > +int
> > +xfs_ag_shrink_space(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	**tpp,
> > +	xfs_agnumber_t		agno,
> > +	xfs_extlen_t		len)
> > +{
> > +	struct xfs_alloc_arg	args = {
> > +		.tp	= *tpp,
> > +		.mp	= mp,
> > +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> > +		.minlen = len,
> > +		.maxlen = len,
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
> > +
> > +	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> > +				    be32_to_cpu(agi->agi_length) - len);
> 
> Paranoia nit: Should we check that len < agi_length?

Ok, although (I think) that's impossible for the current only caller,
I could add some check in the next version.

> 
> > +
> > +	/* remove the preallocations before allocation and re-establish then */
> > +	error = xfs_ag_resv_free(agibp->b_pag);
> > +	if (error)
> > +		return error;
> > +
> > +	/* internal log shouldn't also show up in the free space btrees */
> > +	error = xfs_alloc_vextent(&args);
> 
> I forget, does xfs_alloc_vextent ever roll args.tp?

I think xfs_alloc_vextent will return a dirty transaction without
rolling instead.

Thanks,
Gao Xiang

> 
> Other than those two things this looks good to me.
> 
> --D
> 
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
> > +	}
> > +
> > +	/*
> > +	 * if successfully deleted from freespace btrees, need to confirm
> > +	 * per-AG reservation works as expected.
> > +	 */
> > +	be32_add_cpu(&agi->agi_length, -len);
> > +	be32_add_cpu(&agf->agf_length, -len);
> > +
> > +	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> > +	if (err2) {
> > +		be32_add_cpu(&agi->agi_length, len);
> > +		be32_add_cpu(&agf->agf_length, len);
> > +		if (err2 != -ENOSPC)
> > +			goto resv_err;
> > +
> > +		__xfs_bmap_add_free(*tpp, args.fsbno, len, NULL, true);
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
> > index 5166322807e7..f33388eb130a 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -24,6 +24,8 @@ struct aghdr_init_data {
> >  };
> >  
> >  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> > +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
> > +			xfs_agnumber_t agno, xfs_extlen_t len);
> >  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> >  			struct aghdr_init_data *id, xfs_extlen_t len);
> >  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> > -- 
> > 2.27.0
> > 
> 


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE10C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FCBB233FC
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 20:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731410AbhATU0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 15:26:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55519 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733157AbhATUYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 15:24:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611174194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SERfspaCkmR02mZ4AKIJJTvCgVeSQY3UWc9V6gHiJN0=;
        b=EKchlC2TK7u+lx8jNj90zZT+Hcm/i+SCTjUQyz6XMjDdVVuiafPdhYHG6YTCGOcK+JCsep
        5boVwP82QCz7eDf6a+yUb6FM8YYLSz6lKwlYxksbpzk3Xmmy72+o0NmGJct1RaMcCJRKmD
        tZEUaa2gRiOcAUMZzvpN5DJQ/zjtF5Q=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-ayI1oXGJNDuS8eMSdbUwIg-1; Wed, 20 Jan 2021 15:23:12 -0500
X-MC-Unique: ayI1oXGJNDuS8eMSdbUwIg-1
Received: by mail-pf1-f200.google.com with SMTP id l3so3044306pfl.12
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 12:23:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SERfspaCkmR02mZ4AKIJJTvCgVeSQY3UWc9V6gHiJN0=;
        b=KcwVTRBf4/mxz+cjnVvqwvcO4hCouK5BR6/YRuKIr0ECtuchV38WjU0P9vlC/+Kk5L
         0XAJs/Rk/hpPP/mtbUbJMopkY+1//Kvw0xXDZUmzdmaD/bHx2J/TSHRZpIFOOebiWf9j
         5Z2v8sTPvD5IaRY7jzP6qOemm5+4q+bUQ2b1fxSTuCzs9RlPIQvBGkGSDlWENnFs//nX
         WHzUAWUqihTyBGKWkvjoy28C4HV5KsGIBU3ZCF42PFn/YhiLOhQHjIqOdUtF7qAhSvRm
         c5d3iv+VMmKdHXFIWCy/UbcqGShIONcarLmln833zDKqbP069ATga7VUVpphQ66dXPZG
         hUFg==
X-Gm-Message-State: AOAM532wDaUJ91DKHY6/Slx77ve7lfMnmsXA+p+Vfu6T00ALyb1gKH7X
        dgv7N0L1Fm7WSQgeEkqfe0IZeXtH7bRHYuWlmVpjzO+ijvAAoOrwmhRjRdTQCDOO8EISj9Zi2Cy
        f5oEAkSfCX0zY7kDDMuTn
X-Received: by 2002:a63:fb49:: with SMTP id w9mr11017239pgj.403.1611174191365;
        Wed, 20 Jan 2021 12:23:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhOyH98J4cFcpy8RII/T9vwgnDOWG29WVIHpc1tBQJ8Ph8ZF2bJX6CqHiuhssVYMehaVQDCw==
X-Received: by 2002:a63:fb49:: with SMTP id w9mr11017218pgj.403.1611174191100;
        Wed, 20 Jan 2021 12:23:11 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k6sm3193786pgk.36.2021.01.20.12.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 12:23:10 -0800 (PST)
Date:   Thu, 21 Jan 2021 04:22:59 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210120202259.GA2800037@xiangao.remote.csb>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
 <20210118083700.2384277-5-hsiangkao@redhat.com>
 <20210120192506.GL3134581@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210120192506.GL3134581@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Jan 20, 2021 at 11:25:06AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 04:36:59PM +0800, Gao Xiang wrote:

...

> >  
> > +int
> > +xfs_ag_shrink_space(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	struct aghdr_init_data	*id,
> > +	xfs_extlen_t		len)
> > +{
> > +	struct xfs_alloc_arg	args = {
> > +		.tp	= tp,
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
> > +	ASSERT(id->agno == mp->m_sb.sb_agcount - 1);
> > +	error = xfs_ialloc_read_agi(mp, tp, id->agno, &agibp);
> > +	if (error)
> > +		return error;
> > +
> > +	agi = agibp->b_addr;
> > +
> > +	error = xfs_alloc_read_agf(mp, tp, id->agno, 0, &agfbp);
> > +	if (error)
> > +		return error;
> > +
> > +	agf = agfbp->b_addr;
> > +	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
> > +		return -EFSCORRUPTED;
> > +
> > +	args.fsbno = XFS_AGB_TO_FSB(mp, id->agno,
> > +				    be32_to_cpu(agi->agi_length) - len);
> > +
> > +	/* remove the preallocations before allocation and re-establish then */
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
> 
> Aha, now I see why this bit:
> 
> 	if (!extend && ((tp->t_flags & XFS_TRANS_DIRTY) ||
> 			!list_empty(&tp->t_dfops)))
> 		xfs_trans_commit(tp);
> 
> is needed below -- we could have refilled the AGFL here but failed the
> allocation.  At this point we have a dirty transaction /and/ an error
> code.  We need to commit the AGFL refill changes and return to userspace
> with that error code, but calling xfs_trans_cancel on the dirty
> transaction causes an (unnecessary) shutdown.
> 
> What if you rolled the transaction here and passed the new tp and the
> error code back to the caller?  The new transaction is clean so it will
> cancel without any side effects, and then you can send the ENOSPC up to
> userspace.
> 
> Granted, you could just as easily commit the transaction here and make
> the caller smart enough to know that it no longer has a transaction.  I
> wonder if the transaction allocation and disposal ought to be part of
> the _ag_grow_space and _ag_shrink_space functions.
> 
> Also fwiw I would make sure the transaction is clean before I tried to
> re-initialize the per-ag reservation.

Thanks for your review!

Okay, will look into roll transaction way instead (at least for
the new _ag_shrink_space() since I don't touch _grow_space and
not sure if it has AGFL refill issue as well...)

> 
> > +		err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> > +		if (err2)
> > +			goto resv_err;
> > +		return error;
> > +	}
> > +
> > +	/*
> > +	 * if successfully deleted from freespace btrees, need to confirm
> > +	 * per-AG reservation works as expected.
> > +	 */
> > +	be32_add_cpu(&agi->agi_length, -len);
> > +	be32_add_cpu(&agf->agf_length, -len);
> > +
> > +	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> > +	if (err2) {
> > +		be32_add_cpu(&agi->agi_length, len);
> > +		be32_add_cpu(&agf->agf_length, len);
> > +		if (err2 != -ENOSPC)
> > +			goto resv_err;
> 
> If we've just undone reducing ag[if]_length, don't we need to call
> xfs_ag_resv_init here to (try to) recreate the former per-ag
> reservations?

If my understanding is correct, xfs_fs_reserve_ag_blocks() in
xfs_growfs_data_private() would do that for all AGs... Do we
need to xfs_ag_resv_init() in advance here?

I thought xfs_ag_resv_init() here is mainly used to guarantee the
per-AG reservation for resized size is fine... if ag{i,f}_length
don't change, leave such normal reservation to
xfs_fs_reserve_ag_blocks() would be okay?

> 
> Also, the comment above about cleaning the transaction before trying to
> reinit the per-ag reservation and returning ENOSPC applies here.

ok. that'd be here if rolling a new transaction is needed.
Thanks for the reminder!

Thanks,
Gao Xiang

> 
> > +
> > +		__xfs_bmap_add_free(tp, args.fsbno, len,
> > +				    &XFS_RMAP_OINFO_SKIP_UPDATE, true);
> > +		return err2;
> > +	}
> > +	xfs_ialloc_log_agi(tp, agibp, XFS_AGI_LENGTH);
> > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_LENGTH);
> > +	return 0;
> > +
> > +resv_err:
> > +	xfs_warn(mp,
> > +"Error %d reserving per-AG metadata reserve pool.", err2);
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +	return err2;
> > +}


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740DFC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 03:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6A3238EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 03:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbhAUDwv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:52:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392943AbhAUBxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 20:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611193904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e2wCbKXaWQrn5kRexFPts7PraEeKH0Wk4VS1x8TjUO0=;
        b=O4AYkxuI4rnWMp7lg1pewo5QPx9nYlw74KhpmYlx/AtMT9TV1jlcmB9iX6JD9a5m0k3U8Y
        sECaPlAmyM97YMFU+tULS35GRkwEF/AdTGKHJs4vqX8CW6gDvyWaKG+JDIX/6A87JmZQuA
        4Bj5WqIFnI0JEdVbvf7yxOEsiO+WpCs=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-wi5MDVkCPvmWDeA_8w6HEA-1; Wed, 20 Jan 2021 20:51:42 -0500
X-MC-Unique: wi5MDVkCPvmWDeA_8w6HEA-1
Received: by mail-pf1-f198.google.com with SMTP id x6so291705pfo.3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 17:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e2wCbKXaWQrn5kRexFPts7PraEeKH0Wk4VS1x8TjUO0=;
        b=LdcjuN8ibwrIxVk0bCj/cxD97DbpO3+zHlEYdBDvU+gfRA+fKaye0SgRfwaxVBWdr8
         +8RWk7OJjHEsjvsQL3hjxh3GwLKPqcCm0J7EaH5N4riHFG9pi5b1uF7483Ve9gKBzlwz
         b5Y3rFaT5LjwCnqDl1T8C5WaIWcNU9LA1B51EI8AaPJja02iprTlLktb1yzXxZ9mcOre
         xtiN20tW6vG2zU7xZKiUPEcs9TphrDnaUvlrG2udv6NDM1SsnQWNGrc50mnLEaqkKbiF
         NXAtbBpYmaLXBfZB4x1Ua8qCqUPogECSL9dQKL/YbvZc3f55Zsqo0vt36WEv8myatX45
         rMMg==
X-Gm-Message-State: AOAM530B7zBD5mQpGxHdf72wi5D1Sjrtgg7yzxhdbpvZtwrxktbeZltW
        oOdWMwR8mUq2CGI4njvIoAos/btpue9On/qfkgDdyHYF+ERpmTDbV0VQRlNVgOzSYG0bH0FwN36
        D2bG3Cm/3I0W0TWJEcUuR
X-Received: by 2002:a63:5453:: with SMTP id e19mr3963468pgm.439.1611193901744;
        Wed, 20 Jan 2021 17:51:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJylFsOerEkEWMe+szBmc/I62no2iVhjoxUEZSB+SeLCWkmbo68NoNV/9vNelXsg67q849s4Vg==
X-Received: by 2002:a63:5453:: with SMTP id e19mr3963451pgm.439.1611193901483;
        Wed, 20 Jan 2021 17:51:41 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c17sm3323740pfi.88.2021.01.20.17.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 17:51:40 -0800 (PST)
Date:   Thu, 21 Jan 2021 09:51:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 4/5] xfs: support shrinking unused space in the last AG
Message-ID: <20210121015130.GA2836386@xiangao.remote.csb>
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

(sorry, I was too sleepy at that time... so I didn't even realize if
 I replied them all...go on replying this.. at least for some record
 ... sorry for annoying)

On Wed, Jan 20, 2021 at 11:25:06AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 04:36:59PM +0800, Gao Xiang wrote:

...

> >  
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index db6ed354c465..2ae4f33b42c9 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -38,7 +38,7 @@ xfs_resizefs_init_new_ags(
> >  	struct aghdr_init_data	*id,
> >  	xfs_agnumber_t		oagcount,
> >  	xfs_agnumber_t		nagcount,
> > -	xfs_rfsblock_t		*delta)
> > +	int64_t			*delta)
> >  {
> >  	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
> >  	int			error;
> > @@ -76,33 +76,41 @@ xfs_growfs_data_private(
> >  	xfs_agnumber_t		nagcount;
> >  	xfs_agnumber_t		nagimax = 0;
> >  	xfs_rfsblock_t		nb, nb_div, nb_mod;
> > -	xfs_rfsblock_t		delta;
> > +	int64_t			delta;
> >  	xfs_agnumber_t		oagcount;
> >  	struct xfs_trans	*tp;
> > +	bool			extend;
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
> >  	nagcount = nb_div + (nb_mod != 0);
> >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> >  		nagcount--;
> > -		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > -		if (nb < mp->m_sb.sb_dblocks)
> > +		if (nagcount < 2)
> >  			return -EINVAL;
> > +		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> >  	}
> > +
> >  	delta = nb - mp->m_sb.sb_dblocks;
> > +	extend = (delta > 0);
> >  	oagcount = mp->m_sb.sb_agcount;
> >  
> >  	/* allocate the new per-ag structures */
> > @@ -110,22 +118,34 @@ xfs_growfs_data_private(
> >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> >  		if (error)
> >  			return error;
> > +	} else if (nagcount != oagcount) {
> 
> Nit: nagcount < oagcount ?

(cont..)

ok, that is equal.. will update this.

> 
> > +		/* TODO: shrinking the entire AGs hasn't yet completed */
> > +		return -EINVAL;
> >  	}
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > +			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > +			XFS_TRANS_RESERVE, &tp);
> >  	if (error)
> >  		return error;
> >  
> > -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> > -	if (error)
> > -		goto out_trans_cancel;
> > -
> > +	if (extend) {
> > +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> > +						  nagcount, &delta);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> >  	xfs_trans_agblocks_delta(tp, id.nfree);
> >  
> > -	/* If there are new blocks in the old last AG, extend it. */
> > +	/* If there are some blocks in the last AG, resize it. */
> >  	if (delta) {
> > -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> > +		if (extend) {
> > +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> > +		} else {
> > +			id.agno = nagcount - 1;
> > +			error = xfs_ag_shrink_space(mp, tp, &id, -delta);
> 
> This is a little nitpicky, but I wonder if the reorganization of
> xfs_growfs_data_private ought to be in a separate preparation patch,
> wherein you'd define xfs_ag_shrink_space as a stub that returns
> EOPNOSUPP, and make all the necessary adjustments to the caller.
> 
> That way, this second patch would concentrate on replacing the
> shrink_space stub an actual implementation.

I could have a try on this. Another thought you mentioned on IRC was
seperating shrinkfs into another function, e.g.
xfs_shrinkfs_data_private()... Although Brian once mentioned he liked
to use the shared way, I'm both fine with these. So the next version
I would like to seperate it as a try. And see if it looks ok to
people.

> 
> > +		}
> > +
> >  		if (error)
> >  			goto out_trans_cancel;
> >  	}
> > @@ -137,11 +157,19 @@ xfs_growfs_data_private(
> >  	 */
> >  	if (nagcount > oagcount)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> > -	if (nb > mp->m_sb.sb_dblocks)
> > +	if (nb != mp->m_sb.sb_dblocks)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> >  				 nb - mp->m_sb.sb_dblocks);
> >  	if (id.nfree)
> >  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> > +
> > +	/*
> > +	 * update in-core counters (especially sb_fdblocks) now
> > +	 * so xfs_validate_sb_write() can pass.
> > +	 */
> > +	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > +		xfs_log_sb(tp);
> 
> How do we get a failure in xfs_validate_sb_write?  We're changing
> fdblocks and dblocks in the same transaction, which means that both
> counters should have changed by the number of blocks we took out of
> the filesystem, right?
> 
> Is the problem that the TRANS_SB_DBLOCKS change above makes the primary
> super's sb_dblocks decrease immediately, but since we're in lazycounters
> mode we defer updating sb_fdblocks until unmount, so in the meantime
> we fail the sb write verifier because fdblocks > dblocks?

Yeah, this was mainly to deal with some sb write verifier at that time,
otherwise sb verifier would complain about this:
https://lore.kernel.org/r/20201021142230.GA30714@xiangao.remote.csb/

> 
> Or: is it` the general case that we ought to be forcing fdblocks to get
> logged here even for fs grow operations?  In which case this (minor)
> behavior change probably should go in a separate patch.

I think it's also needed to apply for growfs case as well, yet I didn't
observe some strange about this on growfs, but I think generally lazy
sb counters (including sb_dblocks and sb_fdblocks) might be better to be
updated immediately for all resizing cases. ok, will add another patch
to handle this...

Thanks,
Gao Xiang

> 
> --D
> 


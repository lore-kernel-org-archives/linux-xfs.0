Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C77C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12A3D64F55
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhBDJmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:42:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25221 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234315AbhBDJmh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 04:42:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612431670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fXX94d7W8UbLXsV87gsz3+3/310Avk1lDaPP503ED4Q=;
        b=Y/ZVvhqXtREtudzFSWoycCGx0gkUWG0N8aDUBSWKWmctJ64mnB3QW4F0lseyuJvg2xcRyd
        aboZXbgscNHWGKU6TIuJ8HxJ+F2EArAJ5jqe9XDy7EHMhJUIhr1Mssk30TdDHVzaECv5yi
        43VNP5R+gQy7PNJ0KercYrmMbLTYXUA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-ObYVTONwNFe6sUl2L0SpGw-1; Thu, 04 Feb 2021 04:41:08 -0500
X-MC-Unique: ObYVTONwNFe6sUl2L0SpGw-1
Received: by mail-pg1-f200.google.com with SMTP id f16so1857126pgh.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 01:41:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fXX94d7W8UbLXsV87gsz3+3/310Avk1lDaPP503ED4Q=;
        b=XWurjHKaOjrjAZZnxQHLXIUAlvGU9wRWoPnNIvr3otWRD9ZDnF7u2anFxdrAM6jfXa
         vlyouEpRjuAXRiFi+6MPZAbpDvfUh8MPK8XhXm+bYZCEHKqLWOUf3Y9ovON/NqDssu44
         EbG7T7s9+1y10ZlM7tYxJYB9DAL21wAlfhX4z3Go2FF3w1NAIwH97H+m6bnq4SqNBuXM
         662MkyRvOK6h3ZPnaJJIf/dFBdHc5w7gI7CMeSXAWax78Za++OR3XADFKnotRROaarvh
         3i/UJm4LqYmGE58elnw1fE+zDi8no2omE8PCu8fMZitDEGDYvdZYmkgV9GduY4BD7sHQ
         w4Tg==
X-Gm-Message-State: AOAM5314WnhIHzCAtrPzX21Rm2nfC2zWf1m46VmS3EwN8Iv93og2HbW2
        jhHxNfEt4vMo0BNXd4oR48Kjk135OzfPGseHROZEKT4qUljFULVE0Vgkb32G0eo+l7JasYm4tPU
        rJ/mgW/z8AB5DyhdwOkqX
X-Received: by 2002:a17:90a:4611:: with SMTP id w17mr7798140pjg.18.1612431667513;
        Thu, 04 Feb 2021 01:41:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCZ23MBfX/b1ECMe6nYfPq0q475moL+ioSxU+3tRUJ3BhfbhP+MM7W1RdG9CJfoeZa7PZHbA==
X-Received: by 2002:a17:90a:4611:: with SMTP id w17mr7798118pjg.18.1612431667233;
        Thu, 04 Feb 2021 01:41:07 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z21sm5551524pgk.15.2021.02.04.01.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 01:41:06 -0800 (PST)
Date:   Thu, 4 Feb 2021 17:40:56 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210204094056.GC149518@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203181211.GZ7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203181211.GZ7193@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Feb 03, 2021 at 10:12:11AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:

...

> > > >  	nb_div = nb;
> > > >  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> > > >  	nagcount = nb_div + (nb_mod != 0);
> > > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > > >  		nagcount--;
> > > > -		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > > -		if (nb < mp->m_sb.sb_dblocks)
> > > > +		if (nagcount < 2)
> > > >  			return -EINVAL;
> > > 
> > > What's the reason for the nagcount < 2 check? IIRC we warn about this
> > > configuration at mkfs time, but allow it to proceed. Is it just that we
> > > don't want to accidentally put the fs into an agcount == 1 state that
> > > was originally formatted with >1 AGs?
> > 
> > Darrick once asked for avoiding shrinking the filesystem which has
> > only 1 AG.
> 
> It's worth mentioning why in a comment though:
> 
> 	/*
> 	 * XFS doesn't really support single-AG filesystems, so do not
> 	 * permit callers to remove the filesystem's second and last AG.
> 	 */
> 	if (shrink && new_agcount < 2)
> 		return -EHAHANOYOUDONT;
> 
> But as Brian points out, we /do/ allow adding a second AG to a single-AG
> fs.

(cont.)

ok, thanks for this. anyway, I will cover such case in the next version.

> 
> > > 
> > > What about the case where we attempt to grow an agcount == 1 fs but
> > > don't enlarge enough to add the second AG? Does this change error
> > > behavior in that case?
> > 
> > Yeah, thanks for catching this! If growfs allows 1 AG case before,
> > I think it needs to be refined. Let me update this in the next version!
> > 
> > > 
> > > > +		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > >  	}
> > > > +
> > > >  	delta = nb - mp->m_sb.sb_dblocks;
> > > > +	extend = (delta > 0);
> > > >  	oagcount = mp->m_sb.sb_agcount;
> > > >  
> > > >  	/* allocate the new per-ag structures */
> > > > @@ -110,22 +118,34 @@ xfs_growfs_data_private(
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
> > > > +			(extend ? XFS_GROWFS_SPACE_RES(mp) : -delta), 0,
> > > > +			XFS_TRANS_RESERVE, &tp);
> > > >  	if (error)
> > > >  		return error;
> > > >  
> > > > -	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
> > > > -	if (error)
> > > > -		goto out_trans_cancel;
> > > > -
> > > > +	if (extend) {
> > > > +		error = xfs_resizefs_init_new_ags(mp, &id, oagcount,
> > > > +						  nagcount, &delta);
> > > > +		if (error)
> > > > +			goto out_trans_cancel;
> > > > +	}
> > > >  	xfs_trans_agblocks_delta(tp, id.nfree);
> > > 
> > > It looks like id isn't used until the resize call above. Is this call
> > > relevant for the shrink case?
> > 
> > I think it has nothing to do for the shrink the last AG case as well
> > (id.nfree == 0 here) but maybe use for the later shrinking the whole
> > AGs patchset. I can move into if (extend) in the next version.
> > 
> > > 
> > > >  
> > > > -	/* If there are new blocks in the old last AG, extend it. */
> > > > +	/* If there are some blocks in the last AG, resize it. */
> > > >  	if (delta) {
> > > 
> > > This patch added a (nb == mp->m_sb.sb_dblocks) shortcut check at the top
> > > of the function. Should we ever get to this point with delta == 0? (If
> > > not, maybe convert it to an assert just to be safe.)
> > 
> > delta would be changed after xfs_resizefs_init_new_ags() (the original
> > growfs design is that, I don't want to touch the original logic). that
> > is why `delta' reflects the last AG delta now...
> 
> I've never liked how the meaning of "delta" changes through the
> function, and it clearly trips up reviewers.  This variable isn't the
> delta between the old dblocks and the new dblocks, it's really a
> resizefs cursor that tells us how much work we still have to do.

I found the first patch of this patchset has been merged into for-next,
so some new idea about this? (split delta into 2 variables or some else
way you'd prefer? so I could update in the next version as a whole...)

> 
> > > 
> > > > -		error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > > +		if (extend) {
> > > > +			error = xfs_ag_extend_space(mp, tp, &id, delta);
> > > > +		} else {
> > > > +			id.agno = nagcount - 1;
> > > > +			error = xfs_ag_shrink_space(mp, &tp, &id, -delta);
> > > 
> > > xfs_ag_shrink_space() looks like it only accesses id->agno. Perhaps just
> > > pass in agno for now..?
> > 
> > Both way are ok, yet in my incomplete shrink whole empty AGs patchset,
> > it seems more natural to pass in &id rather than agno (since
> > id.agno = nagcount - 1 will be stayed in some new helper
> > e.g. xfs_shrink_ags())
> 
> @id is struct aghdr_init_data, but shrinking shouldn't initialize any AG
> headers.  Are you planning to make use of it in shrink, either now or
> later on?

I tried to use it as a global context structure for shrinking the whole AGs
and the tail AG since I'm not sure we need to introduce another new structure
to make it more complex, but yeah the naming is somewhat confusing now.

> 

...

> > > 
> > > >  	/*
> > > > -	 * update in-core counters now to reflect the real numbers
> > > > -	 * (especially sb_fdblocks)
> > > > +	 * update in-core counters now to reflect the real numbers (especially
> > > > +	 * sb_fdblocks). And xfs_validate_sb_write() can pass for shrinkfs.
> > > >  	 */
> > > >  	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> > > >  		xfs_log_sb(tp);
> > > > @@ -165,7 +185,7 @@ xfs_growfs_data_private(
> > > >  	 * If we expanded the last AG, free the per-AG reservation
> > > >  	 * so we can reinitialize it with the new size.
> > > >  	 */
> > > > -	if (delta) {
> > > > +	if (extend && delta) {
> > > >  		struct xfs_perag	*pag;
> > > >  
> > > >  		pag = xfs_perag_get(mp, id.agno);
> > > 
> > > We call xfs_fs_reserve_ag_blocks() a bit further down before we exit
> > > this function. xfs_ag_shrink_space() from the previous patch is intended
> > > to deal with perag reservation changes for shrink, but it looks like the
> > > reserve call further down could potentially reset mp->m_finobt_nores to
> > > false if it previously might have been set to true.
> > 
> > Yeah, if my understanding is correct, I might need to call
> > xfs_fs_reserve_ag_blocks() only for growfs case as well for
> > mp->m_finobt_nores = true case.
> 
> I suppose it's worth trying in the finobt_nores==true case. :)
> 

I didn't notice such trick before, will find some clue about this as well.

Also as Brian mentioned, I'm not sure why xfs_ag_resv_free() the last AG
and xfs_fs_reserve_ag_blocks() after AGF/AGI are unlocked for growfs...
I think there could be some race window if some other fs allocation
operations in parellel?

Thanks,
Gao Xiang

> --D


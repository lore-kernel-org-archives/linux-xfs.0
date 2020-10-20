Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF7BC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 14:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2B022224B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 14:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJSuciem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgJTOuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:50:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730866AbgJTOuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Oct 2020 10:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603205420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bvfa7/27txb0dnuEYwTTIZLtfuJ8P4ErFdIwvI61Sck=;
        b=TJSuciemu0jgyUCGtS7dKU8RnD8WUvhEFa5OhQVZx01F0o9aX9XO9CshpSO7c4232qTnoB
        MUGflramO5jSv84G00eAMmsw3NHVnjqLzRGdh/15wrVLjgOoF4PyjXAo/UgSBtRkoVgjtI
        kOWlEBYI23He3swy2hECjY+SWZku1Lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-OM_83ApWMV-Avfw9cO4Skg-1; Tue, 20 Oct 2020 10:50:18 -0400
X-MC-Unique: OM_83ApWMV-Avfw9cO4Skg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F2C780362F;
        Tue, 20 Oct 2020 14:50:17 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F2E627BDC;
        Tue, 20 Oct 2020 14:50:13 +0000 (UTC)
Date:   Tue, 20 Oct 2020 10:50:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201020145012.GA1272590@bfoster>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
 <20201014170139.GC1109375@bfoster>
 <20201015014908.GC7037@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015014908.GC7037@hsiangkao-HP-ZHAN-66-Pro-G1>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 09:49:15AM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Wed, Oct 14, 2020 at 01:01:39PM -0400, Brian Foster wrote:
> > On Wed, Oct 14, 2020 at 08:58:09AM +0800, Gao Xiang wrote:
> > > From: Gao Xiang <hsiangkao@redhat.com>
> > > 
> > > At the first step of shrinking, this attempts to enable shrinking
> > > unused space in the last allocation group by fixing up freespace
> > > btree, agi, agf and adjusting super block.
> > > 
> > > This can be all done in one transaction for now, so I think no
> > > additional protection is needed.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > 
> > > Honestly, I've got headache about shrinking entire AGs
> > > since the codebase doesn't expect agcount can be decreased
> > > suddenly, I got some ideas from people but the modification
> > > seems all over the codebase, I will keep on this at least
> > > to learn more about XFS internals.
> > > 
> > > It might be worth sending out shrinking the last AG first
> > > since users might need to shrink a little unused space
> > > occasionally, yet I'm not quite sure the log space reservation
> > > calculation in this patch and other details are correct.
> > > I've done some manual test and it seems work. Yeah, as a
> > > formal patch it needs more test to be done but I'd like
> > > to hear more ideas about this first since I'm not quite
> > > familiar with XFS for now and this topic involves a lot
> > > new XFS-specific implementation details.
> > > 
> > > Kindly point out all strange places and what I'm missing
> > > so I can revise it. It would be of great help for me to
> > > learn more about XFS. At least just as a record on this
> > > topic for further discussion.
> > > 
> > 
> > Interesting... this seems fundamentally sane when narrowing the scope
> > down to tail AG shrinking. Does xfs_repair flag any issues in the simple
> > tail AG shrink case?
> 
> Yeah, I ran xfs_repair together as well, For smaller sizes, it seems
> all fine, but I did observe some failure when much larger values
> passed in, so as a formal patch, it really needs to be solved later.
> 

I'm curious to see what xfs_repair complained about if you have a record
of it. That might call out some other things we could be overlooking.

> Anyway, this patch tries to show if the overall direction is acceptable
> for further development / upstream. And I could get some more
> suggestion from it..
> 

Sure.

> > 
> > Some random initial thoughts..
> > 
> 
> ...
> 
> > > +int
> > > +xfs_alloc_vextent_shrink(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_buf		*agbp,
> > > +	xfs_agblock_t		agbno,
> > > +	xfs_extlen_t		len)
> > > +{
> > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > +	xfs_agnumber_t		agno = agbp->b_pag->pag_agno;
> > > +	struct xfs_alloc_arg	args = {
> > > +		.tp = tp,
> > > +		.mp = mp,
> > > +		.type = XFS_ALLOCTYPE_THIS_BNO,
> > > +		.agbp = agbp,
> > > +		.agno = agno,
> > > +		.agbno = agbno,
> > > +		.fsbno = XFS_AGB_TO_FSB(mp, agno, agbno),
> > > +		.minlen = len,
> > > +		.maxlen = len,
> > > +		.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
> > > +		.resv = XFS_AG_RESV_NONE,
> > > +		.prod = 1,
> > > +		.alignment = 1,
> > > +		.pag = agbp->b_pag
> > > +	};
> > > +	int			error;
> > > +
> > > +	error = xfs_alloc_ag_vextent_exact(&args);
> > > +	if (error || args.agbno == NULLAGBLOCK)
> > > +		return -EBUSY;
> > 
> > I think it's generally better to call into the top-level allocator API
> > (xfs_alloc_vextent()) because it will handle internal allocator business
> > like fixing up the AGFL and whatnot. Then you probably don't have to
> > specify as much in the args structure as well. The allocation mode
> > you've specified (THIS_BNO) will fall into the exact allocation codepath
> > and should enforce the semantics we need here (i.e. grant the exact
> > allocation or fail).
> 
> Actually, I did in the same way (use xfs_alloc_vextent()) in my previous
> hack version
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?id=65d87d223a4d984441453659f1baeca560f07de4
> 
> yet Dave pointed out in private agfl fix could dirty the transaction
> and if the later allocation fails, it would be unsafe to cancel
> the dirty transaction. So as far as my current XFS knowledge, I think
> that makes sense so I introduce a separate helper
> xfs_alloc_vextent_shrink()...
> 

Yeah, I could see that being an issue. I'm curious if we're exposed to
that problem with exact allocation requests in other places.  We only
use it in a couple places that look like they have fallback allocation
requests. Combine that with the pre-allocation space checks and perhaps
this isn't something we'd currently hit in practice.

That said, I don't think this justifies diving directly into the lower
levels of the allocator (or branching any of the code, etc.). I suspect
not doing the agfl fixups and whatnot could cause other problems if they
are ultimately required for the subsequent allocation. The easiest
workaround is to just commit the transaction instead of cancelling it
once the allocation call is made. A more involved followon fix might be
to improve the early checks for exact allocations, but it's not clear at
this stage if that's really worth the extra code. We might also
eventually want to handle that another way to ensure that the agfl fixup
doesn't actually do an allocation that conflicts with the shrink itself.

> I tend to avoid bury all shrinking specfic logic too deep in the large
> xfs_alloc_vextent() logic by using another new bool or something
> since it's rather complicated for now.
> 
> Intoduce a new helper would make this process more straight-forward
> and bug less in the future IMO... Just my own current thought about
> this...
> 

I'd just work around it as above for now. It's a fairly minor
distraction with respect to the feature.

> > 
> > I also wonder if we'll eventually have to be more intelligent here in
> > scenarios where ag metadata (i.e., free space root blocks, etc.) or the
> > agfl holds blocks in a range we're asked to shrink. I think those are
> > scenarios where such an allocation request would fail even though the
> > blocks are internal or technically free. Have you explored such
> > scenarios so far? I know we're trying to be opportunistic here, but if
> > the AG (or subset) is otherwise empty it seems a bit random to fail.
> > Hmm, maybe scrub/repair could help to reinit/defrag such an AG if we
> > could otherwise determine that blocks beyond a certain range are unused
> > externally.
> 
> Yeah, currently I don't tend to defrag or fix agfl in the process but rather
> on shrinking unused space (not in AGFL) and make the kernel side simplier,
> since I think for the long term we could have 2 options by some combination
> with the userspace prog:
>  - lock the AG, defrag / move the AG, shrinking, unlock the AG;
>  - defrag / move the AG, shrinking, retry.
> 
> > > +
> 
> ...
> 
> > >  	new = nb;	/* use new as a temporary here */
> > >  	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> > > @@ -56,10 +58,18 @@ xfs_growfs_data_private(
> > >  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
> > >  		nagcount--;
> > >  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> > > -		if (nb < mp->m_sb.sb_dblocks)
> > > +		if (!nagcount)
> > >  			return -EINVAL;
> > >  	}
> > 
> > We probably need to rethink the bit of logic above this check for
> > shrinking. It looks like the current code checks for the minimum
> > supported AG size and if not satisfied, reduces the size the grow to the
> > next smaller AG count. That would actually increase the size of the
> > shrink from what the user requested, so we'd probably want to do the
> > opposite and reduce the size of the requested shrink. For now it
> > probably doesn't matter much since we fail to shrink the agcount.
> > 
> > That said, if I'm following the growfs behavior correctly it might be
> > worth considering analogous behavior for shrink. E.g., if the user asks
> > to trim 10GB off the last AG but only the last 4GB are free, then shrink
> > the fs by 4GB and report the new size to the user.
> 
> I thought about this topic as well, yeah, anyway, I think it needs
> some clearer documented words about the behavior (round down or round
> up). My original idea is to unify them. But yeah, increase the size
> of the shrink might cause unexpected fail.
> 

It's probably debatable as to whether we should reduce the size of the
shrink or just fail the operation, but I think to increase the size of
the shrink from what the user requested (even if it occurs "by accident"
due to the AG size rules) is inappropriate. With regard to the former,
have you looked into how shrink behaves on other filesystems (ext4)? I
think one advantage of shrinking what's available is to at least give
the user an opportunity to make incremental progress.

> > 
> > > -	new = nb - mp->m_sb.sb_dblocks;
> > > +
> > > +	if (nb > mp->m_sb.sb_dblocks) {
> > > +		new = nb - mp->m_sb.sb_dblocks;
> > > +		extend = true;
> > > +	} else {
> > > +		new = mp->m_sb.sb_dblocks - nb;
> > > +		extend = false;
> > > +	}
> > > +
> > 
> > s/new/delta (or something along those lines) might be more readable if
> > we go this route.
> 
> In my previous random version, I once renamed it to bdelta, but I found
> the modification is large, I might need to clean up growfs naming first.
> 
> > 
> > >  	oagcount = mp->m_sb.sb_agcount;
> > >  
> > >  	/* allocate the new per-ag structures */
> > > @@ -67,10 +77,14 @@ xfs_growfs_data_private(
> > >  		error = xfs_initialize_perag(mp, nagcount, &nagimax);
> > >  		if (error)
> > >  			return error;
> > > +	} else if (nagcount != oagcount) {
> > > +		/* TODO: shrinking a whole AG hasn't yet implemented */
> > > +		return -EINVAL;
> > >  	}
> > >  
> > >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> > > -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> > > +			(extend ? 0 : new) + XFS_GROWFS_SPACE_RES(mp), 0,
> > > +			XFS_TRANS_RESERVE, &tp);
> > >  	if (error)
> > >  		return error;
> > >  
> > > @@ -103,15 +117,22 @@ xfs_growfs_data_private(
> > >  			goto out_trans_cancel;
> > >  		}
> > >  	}
> > > -	error = xfs_buf_delwri_submit(&id.buffer_list);
> > > -	if (error)
> > > -		goto out_trans_cancel;
> > > +
> > > +	if (!list_empty(&id.buffer_list)) {
> > > +		error = xfs_buf_delwri_submit(&id.buffer_list);
> > > +		if (error)
> > > +			goto out_trans_cancel;
> > > +	}
> > 
> > The list check seems somewhat superfluous since we won't do anything
> > with an empty list anyways. Presumably it would be incorrect to ever
> > init a new AG on shrink so it might be cleaner to eventually refactor
> > this bit of logic out into a helper that we only call on extend since
> > this is a new AG initialization mechanism.
> 
> Yeah, actually my previous hack version
> https://git.kernel.org/pub/scm/linux/kernel/git/xiang/linux.git/commit/?id=65d87d223a4d984441453659f1baeca560f07de4
> 
> did like this, but in this version I'd like to avoid touching unrelated
> topic as much as possible.
> 
> xfs_buf_delwri_submit() is not no-op for empty lists. Anyway, I will
> use 2 independent logic for entire extend / shrink seperately.
> 

I'm not sure we need to split out the entire function. It just might
make some sense to refactor the existing code a bit so the common code
is clearly readable for shrink/grow and that any larger hunks of code
specific to either grow or shrink are factored out into separate
functions.

Brian

> Thanks for your suggestion!
> 
> Thanks,
> Gao Xiang
> 
> > 
> > Brian
> 


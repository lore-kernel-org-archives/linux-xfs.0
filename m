Return-Path: <SRS0=YpFG=EF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045E3C00A89
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 17:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D8C20A8B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Oct 2020 17:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZW4SFYBJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgJ3Rxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 13:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgJ3Rxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Oct 2020 13:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604080411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6wTaNBtuNbvR5Cmh4+Xmk4cscAfSSmNMTlk4Q3b0kYw=;
        b=ZW4SFYBJMN6njkfW/ePfrrFJvLCbrLEZD414OjXFFa4Jd4k/Ngzs7g6LH1cCRUP12b74rX
        vAyPADOvptPbqefzIsXgJwZPi29m4gH22PBm8/lKHT0iHyreC8K4YJpt7Co8Hv6AbyJIBJ
        87bwvrOtkVNz6iTtPzqhw3E05k/PGTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-vm9jAtY2NZ-RY9kVIteNtQ-1; Fri, 30 Oct 2020 13:51:22 -0400
X-MC-Unique: vm9jAtY2NZ-RY9kVIteNtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE511084D77;
        Fri, 30 Oct 2020 17:51:21 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B8F655761;
        Fri, 30 Oct 2020 17:51:16 +0000 (UTC)
Date:   Fri, 30 Oct 2020 13:51:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v2] xfs: support shrinking unused space in the last AG
Message-ID: <20201030175114.GF1794672@bfoster>
References: <20201028231353.640969-1-hsiangkao@redhat.com>
 <20201030144740.GD1794672@bfoster>
 <20201030150259.GA156387@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030150259.GA156387@xiangao.remote.csb>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 30, 2020 at 11:02:59PM +0800, Gao Xiang wrote:
> Hi Brian,
> 
> On Fri, Oct 30, 2020 at 10:47:40AM -0400, Brian Foster wrote:
> > On Thu, Oct 29, 2020 at 07:13:53AM +0800, Gao Xiang wrote:
> 
> ...
> 
> > >  out_trans_cancel:
> > > +	if (extend && (tp->t_flags & XFS_TRANS_DIRTY)) {
> > > +		xfs_trans_commit(tp);
> > > +		return error;
> > > +	}
> > 
> > Do you mean this to be if (!extend && ...)?
> 
> Yeah, you are right.
> 
> > 
> > Otherwise on a quick read through this seems mostly sane to me. Before
> > getting into the implementation details, my comments are mostly around
> > patch organization and general development approach. On the former, I
> > think this patch could be split up into multiple smaller patches to
> > separate refactoring, logic cleanups, and new functionality. E.g.,
> > factoring out the existing growfs code into a helper, tweaking existing
> > logic to prepare the shared grow/shrink path, adding the shrinkfs
> > functionality, could all be independent patches. We probably want to
> > pull the other patch you sent for the experimental warning into the same
> > series as well.
> 
> ok.
> 
> > 
> > On development approach, I'm a little curious what folks think about
> > including these opportunistic shrink bits in the kernel and evolving
> > this into a more complete feature over time. Personally, I think that's
> > a reasonable approach since shrink has sort of been a feature that's
> > been stuck at the starting line due to being something that would be
> > nice to have for some folks but too complex/involved to fully implement,
> > all at once at least. Perhaps if we start making incremental and/or
> > opportunistic progress, we might find a happy medium where common/simple
> > use cases work well enough for users who want it, without having to
> > support arbitrary shrink sizes, moving the log, etc.
> 
> My personal thought is also incremental approach. since I'm currently
> looking at shrinking a whole unused AG, but such whole modification
> is all over the codebase, so the whole shrink function would be better
> to be built step by step.
> 
> > 
> > That said, this is still quite incomplete in that we can only reduce the
> > size of the tail AG, and if any of that space is in use, we don't
> > currently do anything to try and rectify that. Given that, I'd be a
> > little hesitant to expose this feature as is to production users. IMO,
> > the current kernel feature state could be mergeable but should probably
> > also be buried under XFS_DEBUG until things are more polished. To me,
> > the ideal level of completeness to expose something in production
> > kernels might be something that can 1. relocate used blocks out of the
> > target range and then possibly 2. figure out how to chop off entire AGs.
> > My thinking is that if we never get to that point for whatever
> > reason(s), at least DEBUG mode allows us the flexibility to drop the
> > thing entirely without breaking real users.
> 
> Yeah, I also think XFS_DEBUG or another experimential build config
> is needed.
> 
> Considering that, I think it would better to seperate into 2 functions
> as Darrick suggested in the next version to avoid too many
> #ifdef XFS_DEBUG #endif hunks.
> 

Another option could be to just retain the existing error checking logic
and wrap it in an ifdef. I.e.:

#ifndef DEBUG
	/* shrink only allowed in debug mode for now ... */
	if (nb < mp->m_sb.sb_dblocks)
		return -EINVAL;
#endif

Then the rest of the function doesn't have to be factored differently
just because of the ifdef.

Brian

> Thanks,
> Gao Xiang
> 
> > 
> > Anyways, just some high level thoughts on my part. I'm curious if others
> > have thoughts on that topic, particularly since this might be a decent
> > point to decide whether to put effort into polishing this up or to
> > continue with the RFC work and try to prove out more functionality...
> > 
> > Brian
> > 
> > >  	xfs_trans_cancel(tp);
> > >  	return error;
> > >  }
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index c94e71f741b6..81b9c32f9bef 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -419,7 +419,6 @@ xfs_trans_mod_sb(
> > >  		tp->t_res_frextents_delta += delta;
> > >  		break;
> > >  	case XFS_TRANS_SB_DBLOCKS:
> > > -		ASSERT(delta > 0);
> > >  		tp->t_dblocks_delta += delta;
> > >  		break;
> > >  	case XFS_TRANS_SB_AGCOUNT:
> > > -- 
> > > 2.18.1
> > > 
> > 
> 


Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14974C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 08:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01CF20708
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 08:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hqlsWXMv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgGIIzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:55:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41703 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgGIIzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 04:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594284906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qN+KLnCmDSkKrB+58nfcQSefPFuCBcORRXghMsvhxGI=;
        b=hqlsWXMvtmrZiq9TyP4PdKRjyf7OmnEtpwGfX11SLAL4d/CxR+FnPq7mXvqT6Z6tFcgpL6
        FRjT6AGvyA4IPHM5AdLq47FPbuAaj89JT7MIlza5FqgNiXTJV0q4/cmVguxaPrzoO3CA/N
        B0VBd3/NgA1+eTYNDaBn4lildhwRn3E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-DSO41anoOeCBmjYoZco2Kw-1; Thu, 09 Jul 2020 04:55:05 -0400
X-MC-Unique: DSO41anoOeCBmjYoZco2Kw-1
Received: by mail-wm1-f71.google.com with SMTP id c81so1721113wmd.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jul 2020 01:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=qN+KLnCmDSkKrB+58nfcQSefPFuCBcORRXghMsvhxGI=;
        b=K00WlMfd/NC2e9MwLBBqBr4o4CAF8uwBHfyJZBlkizq8VB0lb+QB0tMn3EF/nbjBqp
         jihMy6Hker4L/Hp5ng6pA9uUPu1YLcOljy2Tn7n+oDhmDTAZLHPy+bSzAPUTVSpTXiLM
         /BgHXdkmIY11v74KOdWsOdL5aCmUJI1eLkJLPjvdw80I9idttY8IYirosr6nO+HqLbm6
         PAU+h3bCb2G5ljZnSPfWo42bGRSfuenmCSueu+5vfbg/iLH8RZcp9lsvfhj6P/ZEC2Yy
         DMnBRk9qNw/3iKWOgqfAaaqMGsEqCz864RFxu1qqonWFTrZBLkcL8GBj+jw0kRwvrsNM
         1iJA==
X-Gm-Message-State: AOAM532das6KLkAU/674SyNqcfbb6XW6ApGRAFhbRHzt69nOfqLLGZ4Y
        Aiq28rWmZvjzYwbyKGQjpnvOAm/h3xx6LldAl4ufWx3heFgFme3HykHL0sZI6icRiZlj6YMLcVm
        SZCw14UzW/9tsri+igEqR
X-Received: by 2002:a1c:9cd4:: with SMTP id f203mr13749555wme.155.1594284903194;
        Thu, 09 Jul 2020 01:55:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJya9CiulWfeDay5eR1IKkAiu0nHLYE4Jyk1SFgolVBCbDrGqSVYLrQVRLJ35kEBJ97Sj9rwJw==
X-Received: by 2002:a1c:9cd4:: with SMTP id f203mr13749538wme.155.1594284902973;
        Thu, 09 Jul 2020 01:55:02 -0700 (PDT)
Received: from eorzea (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id j6sm3896307wma.25.2020.07.09.01.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 01:55:02 -0700 (PDT)
Date:   Thu, 9 Jul 2020 10:55:00 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: Remove kmem_zone_zalloc() usage
Message-ID: <20200709085500.fkdn26ia4c4ffipt@eorzea>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20200708125608.155645-1-cmaiolino@redhat.com>
 <20200708125608.155645-3-cmaiolino@redhat.com>
 <20200709025523.GT2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709025523.GT2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 12:55:23PM +1000, Dave Chinner wrote:
> On Wed, Jul 08, 2020 at 02:56:06PM +0200, Carlos Maiolino wrote:
> > Use kmem_cache_zalloc() directly.
> > 
> > With the exception of xlog_ticket_alloc() which will be dealt on the
> > next patch for readability.
> > 
> > Most users of kmem_zone_zalloc() were converted to either
> > "GFP_KERNEL | __GFP_NOFAIL" or "GFP_NOFS | __GFP_NOFAIL", with the
> > exception of _xfs_buf_alloc(), which is allowed to fail, so __GFP_NOFAIL
> > is not used there.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc_btree.c    | 3 ++-
> >  fs/xfs/libxfs/xfs_bmap.c           | 5 ++++-
> >  fs/xfs/libxfs/xfs_bmap_btree.c     | 3 ++-
> >  fs/xfs/libxfs/xfs_da_btree.c       | 4 +++-
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
> >  fs/xfs/libxfs/xfs_inode_fork.c     | 6 +++---
> >  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
> >  fs/xfs/libxfs/xfs_rmap_btree.c     | 2 +-
> >  fs/xfs/xfs_bmap_item.c             | 4 ++--
> >  fs/xfs/xfs_buf.c                   | 2 +-
> >  fs/xfs/xfs_buf_item.c              | 2 +-
> >  fs/xfs/xfs_dquot.c                 | 2 +-
> >  fs/xfs/xfs_extfree_item.c          | 6 ++++--
> >  fs/xfs/xfs_icreate_item.c          | 2 +-
> >  fs/xfs/xfs_inode_item.c            | 3 ++-
> >  fs/xfs/xfs_refcount_item.c         | 5 +++--
> >  fs/xfs/xfs_rmap_item.c             | 6 ++++--
> >  fs/xfs/xfs_trans.c                 | 5 +++--
> >  fs/xfs/xfs_trans_dquot.c           | 3 ++-
> >  19 files changed, 41 insertions(+), 26 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index 60c453cb3ee37..9cc1a4af40180 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -484,7 +484,8 @@ xfs_allocbt_init_common(
> >  
> >  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
> >  
> > -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> > +	cur = kmem_cache_zalloc(xfs_btree_cur_zone,
> > +				GFP_NOFS | __GFP_NOFAIL);
> 
> This still fits on one line....
> 
> Hmmm - many of the other conversions are similar, but not all of
> them. Any particular reason why these are split over multiple lines
> and not kept as a single line of code? My preference is that they
> are a single line if it doesn't overrun 80 columns....

Hmmm, I have my vim set to warn me on 80 column limit, and it warned me here (or
maybe I just went in auto mode), I'll double check it, thanks.

> 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 897749c41f36e..325c0ae2033d8 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -77,11 +77,13 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
> >  /*
> >   * Allocate a dir-state structure.
> >   * We don't put them on the stack since they're large.
> > + *
> > + * We can remove this wrapper
> >   */
> >  xfs_da_state_t *
> >  xfs_da_state_alloc(void)
> >  {
> > -	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
> > +	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
> >  }
> 
> Rather than add a comment that everyone will promptly forget about,
> add another patch to the end of the patchset that removes the
> wrapper.

That comment was supposed to be removed before sending the patches, but looks
like the author forgot about it.

> >  	*bpp = NULL;
> > -	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
> > +	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS);
> >  	if (unlikely(!bp))
> >  		return -ENOMEM;
> 
> That's a change of behaviour. The existing call does not set
> KM_MAYFAIL so this allocation will never fail, even though the code
> is set up to handle a failure. This probably should retain
> __GFP_NOFAIL semantics and the -ENOMEM handling removed in this
> patch as the failure code path here has most likely never been
> tested.

Thanks, I thought we could attempt an allocation here without NOFAIL, but the
testability of the fail path here really didn't come to my mind.

Thanks for the comments, I"ll update the patches and submit a V2.

Cheers

-- 
Carlos


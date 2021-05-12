Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67320C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17E34613CD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhELMuo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:50:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELMun (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620823775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTzjgTx4DPrb6tO+auJlBvH9H2Gaydu5lTJ7UAXuUCA=;
        b=JsfQhiKSYAGYS6If915GxYPoVwNpyPWNv4H+BEE/1/3LRluDIqZ8SodsM4jZ/1SkzU339V
        aa+BjqM9MPoOYiAftS89p/4PZHYJM3Wis+Yk/nMq+tm2hLR06DQ1qHJusHgPumprNyyL/w
        WGLkbMYQe5Dy1yqBG+gcC5/tn+ciHBQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-m15QZM4yOhCZ9xX_c5sXEA-1; Wed, 12 May 2021 08:49:31 -0400
X-MC-Unique: m15QZM4yOhCZ9xX_c5sXEA-1
Received: by mail-qv1-f72.google.com with SMTP id l61-20020a0c84430000b02901a9a7e363edso18751263qva.16
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hTzjgTx4DPrb6tO+auJlBvH9H2Gaydu5lTJ7UAXuUCA=;
        b=h/a2mSf1s++qAL4B6c0ekBSaFro4f4OyxKG7FClv3CpOyEn/KxuUtV6MzkFnfW1HS+
         JN2z6yV46MVeEKieuiXg8r3RldbB4VixuL/W0LbcvS3GCZv6ZLI5+meboKvPZKjSNOYB
         WnlTROSEiFQrud5TbrIB3zZ/sxhR8x/P+mVLxsztVjiCOnmoqUoy1bMcsfGHkJpn3A0O
         hWB8yvnyI0gKFtJYj5UDqruhNGPWkWADzbQ3U2fDkMe1TOSx+hP5RyljG+VineQsgLwK
         sGqDL0HjO7SKQfWsWymKsuMQwguN4y01UY0YJe4wOqKZeYJjs1RJ0S1SdFRbD6xrSr0b
         5XTA==
X-Gm-Message-State: AOAM531G+xgnkanjV/qlO3vvZPXc0Wx/aJtLQHTjDQFHsnuNBt7VrkOh
        JShgRFGhgPR/c6bwMf3sp8RK3VgDbEy/xyM51jhjZTW0WiDRUrJp3UTVnhF1R/uWYNxAW4oFdoi
        2y08g128RqU2lQNvVGibV
X-Received: by 2002:ac8:5314:: with SMTP id t20mr32623979qtn.68.1620823771015;
        Wed, 12 May 2021 05:49:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgteWG1GY21H+GEOq9DCkREUNInaHw4VQzXB/Bc/1pmShAkGXVxrTQNGOdUIUoBj8coMxPog==
X-Received: by 2002:ac8:5314:: with SMTP id t20mr32623960qtn.68.1620823770725;
        Wed, 12 May 2021 05:49:30 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id x25sm3865784qkn.92.2021.05.12.05.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:49:30 -0700 (PDT)
Date:   Wed, 12 May 2021 08:49:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs: add a perag to the btree cursor
Message-ID: <YJvO2KK4cBj2dh6a@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-12-david@fromorbit.com>
 <YJp43sNHyTkk+SDU@bfoster>
 <20210511205152.GP8582@magnolia>
 <20210511215250.GU63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511215250.GU63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 07:52:50AM +1000, Dave Chinner wrote:
> On Tue, May 11, 2021 at 01:51:52PM -0700, Darrick J. Wong wrote:
> > On Tue, May 11, 2021 at 08:30:22AM -0400, Brian Foster wrote:
> > > On Thu, May 06, 2021 at 05:20:43PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Which will eventually completely replace the agno in it.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_alloc.c          | 25 +++++++++++++++----------
> > > >  fs/xfs/libxfs/xfs_alloc_btree.c    | 13 ++++++++++---
> > > >  fs/xfs/libxfs/xfs_alloc_btree.h    |  3 ++-
> > > >  fs/xfs/libxfs/xfs_btree.c          |  2 ++
> > > >  fs/xfs/libxfs/xfs_btree.h          |  4 +++-
> > > >  fs/xfs/libxfs/xfs_ialloc.c         | 16 ++++++++--------
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.c   | 15 +++++++++++----
> > > >  fs/xfs/libxfs/xfs_ialloc_btree.h   |  7 ++++---
> > > >  fs/xfs/libxfs/xfs_refcount.c       |  4 ++--
> > > >  fs/xfs/libxfs/xfs_refcount_btree.c | 17 ++++++++++++-----
> > > >  fs/xfs/libxfs/xfs_refcount_btree.h |  2 +-
> > > >  fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
> > > >  fs/xfs/libxfs/xfs_rmap_btree.c     | 17 ++++++++++++-----
> > > >  fs/xfs/libxfs/xfs_rmap_btree.h     |  2 +-
> > > >  fs/xfs/scrub/agheader_repair.c     | 20 +++++++++++---------
> > > >  fs/xfs/scrub/bmap.c                |  2 +-
> > > >  fs/xfs/scrub/common.c              | 12 ++++++------
> > > >  fs/xfs/scrub/repair.c              |  5 +++--
> > > >  fs/xfs/xfs_discard.c               |  2 +-
> > > >  fs/xfs/xfs_fsmap.c                 |  6 +++---
> > > >  fs/xfs/xfs_reflink.c               |  2 +-
> > > >  21 files changed, 112 insertions(+), 70 deletions(-)
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > > index 0f12b885600d..44044317c0fb 100644
> > > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > > @@ -377,6 +377,8 @@ xfs_btree_del_cursor(
> > > >  	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
> > > >  	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> > > >  		kmem_free(cur->bc_ops);
> > > > +	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> > > > +		xfs_perag_put(cur->bc_ag.pag);
> > > 
> > > What's the correlation with BTREE_LONG_PTRS?
> 
> Only the btrees that index agbnos within a specific AG use the
> cur->bc_ag structure to store the agno the btree is rooted in.
> These are all btrees that use short pointers.
> 
> IOWs, we need an agno to turn the agbno into a full fsbno, daddr,
> inum or anything else with global scope. Translation of short
> pointers to physical location is necessary just to walk the tree,
> while long pointer trees already record physical location of the
> blocks within the tree and hence do not need an agno for
> translation.
> 
> Hence needing the agno is specific, at this point in
> time, to a btree containing short pointers.
> 
> > maybe this should be:
> > 
> > 	if (!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> > 		xfs_perag_put(cur->bc_ag.pag);
> 
> Given that the only long pointer btree we have is also the only
> btree we have rooted in an inode, this is just another way of saying
> !BTREE_LONG_PTRS. But "root in inode" is less obvious, because then we
> lose the context taht "short pointers need translation via agno to
> calculate their physical location in the wider filesystem"...
> 

Got it, thanks. The bc_ag field is unioned with bc_ino, the latter of
which is used by XFS_BTREE_ROOT_IN_INODE trees to track inode
information rather than AG information. I think the flag usage just
threw me off at a glance. With that cleared up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> If we are going to put short ptrs in an inode, then at that point
> we need to change the btree cursor, anyway, because then we are
> going to need both an inode pointer and something else to turn those
> short pointers into global scope pointers for IO....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


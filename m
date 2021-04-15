Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DA0C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 07:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D40F5611AC
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 07:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhDOHJJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 03:09:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230481AbhDOHJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 03:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618470526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sBV0DjUiYmT7ChO4CDe3ixGFCO20z5jEkkIL7B7e5NA=;
        b=GndnwtVM0Fw3DMhHX/qWkGsJhyaKWTG9sdgVdpZ8JMOlnwHDMlz8nQnsek0mLKpM6K44Ef
        pseG/ixvt5ZwEsAnfLuoCfJHWgyF9CJeAYP9NFRhxPGGo1d3QzQnyLd8g2BfKDUPdP8/MV
        x4mV6EwKZ9egxhEFqBGkjkAs3il1PD4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-DIfyfKHBNECyY0-2B0eeEw-1; Thu, 15 Apr 2021 03:08:44 -0400
X-MC-Unique: DIfyfKHBNECyY0-2B0eeEw-1
Received: by mail-pf1-f197.google.com with SMTP id i25-20020aa787d90000b029024ba2eb5930so2278080pfo.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Apr 2021 00:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sBV0DjUiYmT7ChO4CDe3ixGFCO20z5jEkkIL7B7e5NA=;
        b=Q/8cym9W3dtftB2W1rWUGdEM4Ww5U1wDhiYdIQzRnqUDXuvl9slpW9KQlnSaPyGJLp
         aK7CF6KJ7asUt+xlFjXsXkwlgmH2F7ZhFJQLLBGNCSWi8WSkDH9AT11qrb4yfTI/tYh/
         mrEVjdBgyvsqE37cDSMe7fXIG8vCG/T7nhVLvV7yy4bcApGkKPj18LR4cyfKQ0nWz5v6
         +Lt+vYVInfbjrX5cka03QfSNBuSTGZrQtHkcCTZzDJiPd+X2ynQtatBSJVbEa+ZQX8D/
         zkideuL9Pu8RUEGrtBpmGUiv4vwxkAt52UM75Hz1bgYejm58+TTDzV25qj4v0Y6BG6Hm
         rETw==
X-Gm-Message-State: AOAM533/iUdOMmB3+C7gIO/fEzuGTjKXKJApMosqxJ+rVbMJLkY+beA0
        jKR4rQpxSXp2F1VC5NtohfNUPc8zzpHJcFp7csRgShoCzr6Oay2gnF/tcLXgz90rbd89CaeFNtm
        VSkFQZvFzx8f4lX9wvY+G
X-Received: by 2002:a17:90b:ed8:: with SMTP id gz24mr2257224pjb.98.1618470523270;
        Thu, 15 Apr 2021 00:08:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxrdopZvv8MZZ18g2xQ8+eQlIuJzmk1DGSpnsru3Td8+jC7HQodj+toSlwhKyjx7FLjBCS0g==
X-Received: by 2002:a17:90b:ed8:: with SMTP id gz24mr2257203pjb.98.1618470522976;
        Thu, 15 Apr 2021 00:08:42 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o18sm1300410pji.10.2021.04.15.00.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 00:08:42 -0700 (PDT)
Date:   Thu, 15 Apr 2021 15:08:33 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: support deactivating AGs
Message-ID: <20210415070833.GD1864610@xiangao.remote.csb>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-2-hsiangkao@redhat.com>
 <20210415034255.GJ63242@dread.disaster.area>
 <20210415042837.GA1864610@xiangao.remote.csb>
 <20210415062824.GN63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210415062824.GN63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Apr 15, 2021 at 04:28:24PM +1000, Dave Chinner wrote:
> On Thu, Apr 15, 2021 at 12:28:37PM +0800, Gao Xiang wrote:
> > Hi Dave,
> > 
> > On Thu, Apr 15, 2021 at 01:42:55PM +1000, Dave Chinner wrote:
> > > On Thu, Apr 15, 2021 at 03:52:37AM +0800, Gao Xiang wrote:
> > > > To get rid of paralleled requests related to AGs which are pending
> > > > for shrinking, mark these perags as inactive rather than playing
> > > > with per-ag structures theirselves.
> > > > 
> > > > Since in that way, a per-ag lock can be used to stablize the inactive
> > > > status together with agi/agf buffer lock (which is much easier than
> > > > adding more complicated perag_{get, put} pairs..) Also, Such per-ags
> > > > can be released / reused when unmountfs / growfs.
> > > > 
> > > > On the read side, pag_inactive_rwsem can be unlocked immediately after
> > > > the agf or agi buffer lock is acquired. However, pag_inactive_rwsem
> > > > can only be unlocked after the agf/agi buffer locks are all acquired
> > > > with the inactive status on the write side.
> > > > 
> > > > XXX: maybe there are some missing cases.
> > > > 
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_ag.c     | 16 +++++++++++++---
> > > >  fs/xfs/libxfs/xfs_alloc.c  | 12 +++++++++++-
> > > >  fs/xfs/libxfs/xfs_ialloc.c | 26 +++++++++++++++++++++++++-
> > > >  fs/xfs/xfs_mount.c         |  2 ++
> > > >  fs/xfs/xfs_mount.h         |  6 ++++++
> > > >  5 files changed, 57 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > > > index c68a36688474..ba5702e5c9ad 100644
> > > > --- a/fs/xfs/libxfs/xfs_ag.c
> > > > +++ b/fs/xfs/libxfs/xfs_ag.c
> > > > @@ -676,16 +676,24 @@ xfs_ag_get_geometry(
> > > >  	if (agno >= mp->m_sb.sb_agcount)
> > > >  		return -EINVAL;
> > > >  
> > > > +	pag = xfs_perag_get(mp, agno);
> > > > +	down_read(&pag->pag_inactive_rwsem);
> > > 
> > > No need to encode the lock type in the lock name. We know it's a
> > > rwsem from the lock API functions...
> > > 
> > > > +
> > > > +	if (pag->pag_inactive) {
> > > > +		error = -EBUSY;
> > > > +		up_read(&pag->pag_inactive_rwsem);
> > > > +		goto out;
> > > > +	}
> > > 
> > > This looks kinda heavyweight. Having to take a rwsem whenever we do
> > > a perag lookup to determine if we can access the perag completely
> > > defeats the purpose of xfs_perag_get() being a lightweight, lockless
> > > operation.
> > 
> > I'm not sure if it has some regression since write lock will be only
> > taken when shrinking (shrinking is a rare operation), for most cases
> > which is much similiar to perag radix root I think.
> 
> It's still an extra pair of atomic operation per xfs_perag_get/put()
> call pairs. pag_inactive being true is the slow/rare path, so we
> should be trying to keep the overhead of detecting that path out of
> all our fast paths...
> 
> Indeed, xfs_perag_get() already shows up on profiles because of the
> number of calls we make to it, so adding an extra atomic operation
> for this operation is going to be noticable in terms of CPU usage,
> if nothing else.
> 
> > The locking logic is that, when pag->pag_inactive = false -> true,
> > the write lock, AGF/AGI locks all have to be taken in advance.
> > 
> > > 
> > > I suspect what we really want here is active/passive references like
> > > are used for the superblock, and an API that hides the
> > > implementation from all the callers.
> > 
> > If my understanding is correct, my own observation these months is
> > that the current XFS codebase is not well suitable to accept !pag
> > (due to many logic assumes pag structure won't go away, since some
> >  are indexed/passed by agno rather than some pag reference count).
> 
> Maybe so, but that's exactly what this patch is addressing - it's
> adding a way to detect that perag has "gone away"i and should not be
> referenced any more.
> 
> It wasn't until I saw this patch that I realised that there is a way
> that we can, in fact, safely handle perags being freed by ensuring
> that the RCU lookup fails for these "active" references....
> 
> > Even I think we could introduce some active references, but handle
> > the cover range is still a big project. The current approach assumes
> > pag won't go away except for umounting and blocks allocation / imap/
> > ... paths to access that.
> 
> The way I described should work just fine - nobody should be
> accessing the per-ag without a reference gained through a lookup in
> some way.  Buffers carry a passive reference, because the per-ag
> teardown will do the teardown of those references before the perag
> is freed.  Everything else carries an active reference and so
> teardown cannot begin until all active references go away.
> 
> > My current thought is that we could implement it in that way as the
> > first step (in order to land the shrinking functionality to let
> > end-users benefit of this), and by the codebase evolves, it can be
> > transformed to a more gentle way.
> 
> I think converting this patchset to active/passive references ias
> I've described solves the problem entirely - there's no "evolving"
> needed as we can solve it with this one structural change...

Since currently even xfs_perag_put() reaches zero, it won't free
the per-ag anyway (it may just use to mark the pointer is no longer
used in the context? not sure what's the exact use of the such pairs),
so in practice I think after active/passive references are introduced,
there is still the only one real reference count that works for the
per-ag lifetime management and currently it doesn't manage whole
lifetime at all...

So (my own understanding is) I think in practice, that approachs
would be somewhat equal to relocate/rearrange xfs_perag_get()/put()
pair to manage the perag lifetime instead. and maybe use xfs_perag_ptr()
to access perag when some reference count is available.

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


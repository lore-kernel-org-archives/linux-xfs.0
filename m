Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD98FC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 04:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9628C61131
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 04:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhDOE3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 00:29:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229462AbhDOE3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 00:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618460931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eDoTMPOr7BX6ejJI/537S7EzpK4Aoaiynk/SpxNulh4=;
        b=K/jt136iwXV//qcl+1BMlh0zySsSGtX1MdUSE+4zFzpE/+e9OCLJzqPRHxM8uN7HNlkD8q
        Y6L037sqVcsBo+sIVWDfKxSnuGPIg0tr5hYxc8LMvpZOKbdWScXDpITF6/ASEzxmPQIgt0
        YahH2AUlRGgO6/iVn40+5l3bpxQwufI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-y7VXQ4osNRy4aPGSdgk9Bw-1; Thu, 15 Apr 2021 00:28:49 -0400
X-MC-Unique: y7VXQ4osNRy4aPGSdgk9Bw-1
Received: by mail-pj1-f70.google.com with SMTP id e2-20020a17090a7c42b029014d9d6b18afso11503725pjl.8
        for <linux-xfs@vger.kernel.org>; Wed, 14 Apr 2021 21:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eDoTMPOr7BX6ejJI/537S7EzpK4Aoaiynk/SpxNulh4=;
        b=k+bjM36kjYd0ivkRvOGTDQBhphIkZLmFN8ygf2cgX2ljjGEILmj8W2t4N0tNJwC+WB
         64/xvAJ7LUjX+mPNIxQ95hvBf2U04NlBpo/mStfS0Yx9OgHtKF9LZXPQ9NvtkWbufRlW
         actWevyNLkp+GIEqvNeU2pPnfxe2388hcGmiV6dR+u1tOz0A8GOSCDTVzspfGu5URe/b
         stYBeVwCDMmIXggUB1u0LwZTu6j7sfctPe/3gqjTfpruC76skbP2vFGd6O+Ih66EjE6W
         +GWWH/MtdJAKJnZQbJWU1cUvMDHFy93LUht+hD6QyQ3GWM0hMmrQivllNmdh2m+amCrR
         1GoA==
X-Gm-Message-State: AOAM530j4AvRZJhqzB6kXyL3F9D4QGnt5q3kgLQxq5QQ71UXo+hg/Lic
        /e1JyVHJB24xfd4s1nGOuSzDbdWz57GIXii/piUD1oq/BcMPjsX1yTsQNYjbPZMB8GZBvh8HQTA
        eJizfzyXfeW4+kjy5iecm
X-Received: by 2002:a17:90a:bf17:: with SMTP id c23mr1745315pjs.12.1618460927675;
        Wed, 14 Apr 2021 21:28:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+/G8SwcXjCSPhnE/zjktyNR2ZUYi9nYr7Zxgv08cqvDlVf4/rYssrNioCU6G+IMVL1g2k4Q==
X-Received: by 2002:a17:90a:bf17:: with SMTP id c23mr1745291pjs.12.1618460927417;
        Wed, 14 Apr 2021 21:28:47 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d5sm757376pfq.182.2021.04.14.21.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 21:28:47 -0700 (PDT)
Date:   Thu, 15 Apr 2021 12:28:37 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: support deactivating AGs
Message-ID: <20210415042837.GA1864610@xiangao.remote.csb>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-2-hsiangkao@redhat.com>
 <20210415034255.GJ63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210415034255.GJ63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Apr 15, 2021 at 01:42:55PM +1000, Dave Chinner wrote:
> On Thu, Apr 15, 2021 at 03:52:37AM +0800, Gao Xiang wrote:
> > To get rid of paralleled requests related to AGs which are pending
> > for shrinking, mark these perags as inactive rather than playing
> > with per-ag structures theirselves.
> > 
> > Since in that way, a per-ag lock can be used to stablize the inactive
> > status together with agi/agf buffer lock (which is much easier than
> > adding more complicated perag_{get, put} pairs..) Also, Such per-ags
> > can be released / reused when unmountfs / growfs.
> > 
> > On the read side, pag_inactive_rwsem can be unlocked immediately after
> > the agf or agi buffer lock is acquired. However, pag_inactive_rwsem
> > can only be unlocked after the agf/agi buffer locks are all acquired
> > with the inactive status on the write side.
> > 
> > XXX: maybe there are some missing cases.
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.c     | 16 +++++++++++++---
> >  fs/xfs/libxfs/xfs_alloc.c  | 12 +++++++++++-
> >  fs/xfs/libxfs/xfs_ialloc.c | 26 +++++++++++++++++++++++++-
> >  fs/xfs/xfs_mount.c         |  2 ++
> >  fs/xfs/xfs_mount.h         |  6 ++++++
> >  5 files changed, 57 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> > index c68a36688474..ba5702e5c9ad 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -676,16 +676,24 @@ xfs_ag_get_geometry(
> >  	if (agno >= mp->m_sb.sb_agcount)
> >  		return -EINVAL;
> >  
> > +	pag = xfs_perag_get(mp, agno);
> > +	down_read(&pag->pag_inactive_rwsem);
> 
> No need to encode the lock type in the lock name. We know it's a
> rwsem from the lock API functions...
> 
> > +
> > +	if (pag->pag_inactive) {
> > +		error = -EBUSY;
> > +		up_read(&pag->pag_inactive_rwsem);
> > +		goto out;
> > +	}
> 
> This looks kinda heavyweight. Having to take a rwsem whenever we do
> a perag lookup to determine if we can access the perag completely
> defeats the purpose of xfs_perag_get() being a lightweight, lockless
> operation.

I'm not sure if it has some regression since write lock will be only
taken when shrinking (shrinking is a rare operation), for most cases
which is much similiar to perag radix root I think.

The locking logic is that, when pag->pag_inactive = false -> true,
the write lock, AGF/AGI locks all have to be taken in advance.

> 
> I suspect what we really want here is active/passive references like
> are used for the superblock, and an API that hides the
> implementation from all the callers.

If my understanding is correct, my own observation these months is
that the current XFS codebase is not well suitable to accept !pag
(due to many logic assumes pag structure won't go away, since some
 are indexed/passed by agno rather than some pag reference count).

Even I think we could introduce some active references, but handle
the cover range is still a big project. The current approach assumes
pag won't go away except for umounting and blocks allocation / imap/
... paths to access that.

My current thought is that we could implement it in that way as the
first step (in order to land the shrinking functionality to let
end-users benefit of this), and by the codebase evolves, it can be
transformed to a more gentle way.

Thanks,
Gao Xiang


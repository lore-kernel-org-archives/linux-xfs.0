Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0885C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 15:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiCAPGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 10:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiCAPGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 10:06:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA1E2A6468
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 07:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646147164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HU29EcJS9bb1T/sVHCb9NrPaqb1GFgZ9kGoKptb8tSk=;
        b=ZCn8mLtR71iPYpKiyWQ35pRv2h1gBu7Mes1WqaLxldXrBqZHhAz2o9RtMPvyZKW9oR/T1c
        b0H5vM1dlUfbvQfP994vfdrIsZWZNujulEfNQ9P7+ZYgKkha2lW1n4hU/J1MF36AjM0S8r
        V2XoA7NJ9+08dTZhrSksFzqb5+8QGO8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-74B8i-A_Ogqaa1QElI6abw-1; Tue, 01 Mar 2022 10:06:03 -0500
X-MC-Unique: 74B8i-A_Ogqaa1QElI6abw-1
Received: by mail-qk1-f200.google.com with SMTP id w4-20020a05620a094400b0060dd52a1445so14150857qkw.3
        for <linux-xfs@vger.kernel.org>; Tue, 01 Mar 2022 07:06:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HU29EcJS9bb1T/sVHCb9NrPaqb1GFgZ9kGoKptb8tSk=;
        b=nWf2gTHENAN4Pkz2GIEB21sUKlGw/HaoaIi70TgvtrXDi/RBIbQTHiT6BDxqOS6lYg
         LDX6MgBE0GbgKviBVTXbSD1QEmyn8xHAdx/DswyYgQaJ7gJ8QDQuTr8PLEZQ0BFu2nUz
         aRzJuLAxUp5BnsCZ9RolouJNuNe+2OAoI5Mw7QqgL2UJpWeHx9VnwaBY+3jJzzJhLHnK
         s8MLs4J3TRg9MAgpzE0Adm6LhuPHuk4rTavzXmAtvsy73jXTCsfHHTuIIA2lvXxirNyz
         Dphphq143nB66LQeJH3sjlQTiiTTyO0HmZDg37i/NTH2PvCYn6mAUQL/cDgnC+uAbQN7
         kWTw==
X-Gm-Message-State: AOAM531Eng5AaPDFf9kiisTaU+9trhfo1UDJcgWzamcaT6MkIjmhUU1N
        5qlXil1/dQIRZMBTpQyYIHMCFkoDfD9XqPJ5/QfkijsBLjh1OYUy2lLdqcE0axc4wtylmHP9AUH
        UGDJHDGRiGRlNWTI3IGDM
X-Received: by 2002:a05:622a:199f:b0:2de:606:9a7a with SMTP id u31-20020a05622a199f00b002de06069a7amr20421004qtc.440.1646147162737;
        Tue, 01 Mar 2022 07:06:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfzTRwHEb4UJ7sqyrxjsmxGlzpzlUPm81tos7s/9w65/TxP+aPdDm/RAWs0T4yboeyX9VYrw==
X-Received: by 2002:a05:622a:199f:b0:2de:606:9a7a with SMTP id u31-20020a05622a199f00b002de06069a7amr20420952qtc.440.1646147162276;
        Tue, 01 Mar 2022 07:06:02 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id r2-20020a05620a03c200b00477981c7129sm6603112qkm.17.2022.03.01.07.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 07:06:01 -0800 (PST)
Date:   Tue, 1 Mar 2022 10:05:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <Yh42VxJQgC4foQdK@bfoster>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
 <Yg+rdFRpvra8U25D@bfoster>
 <20220218225440.GE59715@dread.disaster.area>
 <YhKM6u3yuF1Ek4/w@bfoster>
 <20220223070058.GK59715@dread.disaster.area>
 <Yh1CjRONamUG0k1C@bfoster>
 <20220228225556.GS59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228225556.GS59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 09:55:56AM +1100, Dave Chinner wrote:
> On Mon, Feb 28, 2022 at 04:45:49PM -0500, Brian Foster wrote:
> > On Wed, Feb 23, 2022 at 06:00:58PM +1100, Dave Chinner wrote:
> > > i.e. as long as we track whether we've allocated a new inode chunk
> > > or not, we can bound the finobt search to a single retry. If we
> > > allocated a new chunk before entering the finobt search, then all we
> > > need is a log force because the busy inodes, by definition, are
> > > XFS_ISTALE at this point and waiting for a CIL push before they can
> > > be reclaimed. At this point an retry of the finobt scan will find
> > > those inodes that were busy now available for allocation.
> > 
> > Remind me what aspect of the prospective VFS changes prevents inode
> > allocation from seeing a free inode with not-yet-elapsed RCU grace
> > period..? Will this delay freeing (or evicting) the inode until a grace
> > period elapses from when the last reference was dropped?
> 
> It will delay it until the inode has been reclaimed, in which case
> reallocating it will result in a new struct xfs_inode being
> allocated from slab, and we're all good. Any lookup that finds the
> old inode will see either I_WILL_FREE, I_FREEING, I_CLEAR,
> XFS_NEED_INACTIVE, XFS_IRECLAIM or ip->i_ino == 0 depending on what
> point the lookup occurs. Hence the lookup will be unable to take a
> new reference to the unlinked inode, and the lookup retry should
> then get the newly allocated xfs_inode once it has been inserted
> into the radix tree...
> 
> IOWs, it gets rid of recycling altogether, and that's how we avoid
> the RCU grace period issues with recycled inodes.
> 
> > > > Perhaps a simple enough short term option is to use the existing block
> > > > alloc min/max range mechanisms (as mentioned on IRC). For example:
> > > > 
> > > > - Use the existing min/max_agbno allocation arg input values to attempt
> > > >   one or two chunk allocs outside of the known range of busy inodes for
> > > >   the AG (i.e., allocate blocks higher than the max busy agino or lower
> > > >   than the min busy agino).
> > > > - If success, then we know we've got a chunk w/o busy inodes.
> > > > - If failure, fall back to the existing chunk alloc calls, take whatever
> > > >   we get and retry the finobt scan (perhaps more aggressively checking
> > > >   each record) hoping we got a usable new record.
> > > > - If that still fails, then fall back to synchronize_rcu() as a last
> > > >   resort and grab one of the previously busy inodes.
> > > > 
> > > > I couldn't say for sure if that would be effective enough without
> > > > playing with it a bit, but that would sort of emulate an algorithm that
> > > > filtered chunk block allocations with at least one busy inode without
> > > > having to modify block allocation code. If it avoids an RCU sync in the
> > > > majority of cases it might be effective enough as a stopgap until
> > > > background freeing exists. Thoughts?
> > > 
> > > It might work, but I'm not a fan of how many hoops we are considering
> > > jumping through to avoid getting tangled up in the RCU requirements
> > > for VFS inode life cycles. I'd much prefer just being able to say
> > > "all inodes busy, log force, try again" like we do with busy extent
> > > limited block allocation...
> > > 
> > 
> > Well presumably that works fine for your implementation of busy inodes,
> > but not so much for the variant intended to work around the RCU inode
> > reuse problem. ISTM this all just depends on the goals and plan here,
> > and I'm not seeing clear enough reasoning to grok what that is. A
> > summary of the options discussed so far:
> > 
> > - deferred inode freeing - ideal but too involved, want something sooner
> >   and more simple
> > - hinted non-busy chunk allocation - simple but jumping through too many
> >   RCU requirement hoops
> > - sync RCU and retry - most analogous to longer term busy inode
> >   allocation handling (i.e. just replace rcu sync w/ log force and
> >   retry), but RCU sync is too performance costly as a direct fallback
> > 
> > ISTM the options here range from simple and slow, to moderately simple
> > and effective (TBD), to complex and ideal. So what is the goal for this
> > series?
> 
> To find out if we can do something fast and effective (and without
> hacks that might bite us unexepectedly) with RCU grace periods that
> is less intrusive than changing inode life cycles. If it turns out
> that we can change the inode life cycle faster than we can come up
> with a RCU grace period based solution, then we should just go with
> inode life cycle changes and forget about the interim RCU grace
> period detection changes...
> 
> > My understanding to this point is that VFS changes are a ways
> > out, so the first step was busy inodes == inodes with pending grace
> > periods and a rework of the busy inode definition comes later with the
> > associated VFS changes. That essentially means this series gets fixed up
> > and posted as a mergeable component in the meantime, albeit with a
> > "general direction" that is compatible with longer term changes.
> 
> It seems to me that the RCU detection code is also a ways out,
> so I'm trying to keep our options open and not have us duplicate
> work unnecessarily.
> 

It depends..? All discussions to this point around the "proper" fix to
the RCU inode recycle / lifecycle issue suggested a timeline of a year
or longer. Hence my initial thought process around the busy inode +
deferred inode freeing being a reasonable strategy. If the chunk
allocation hint thing is effective, then with that it's really just a
matter of factoring that in along with some allocation cleanups (i.e.
one chunk alloc retry limit, refining the !busy inode selection logic,
etc.) and then perhaps a few weeks or so of review/test/dev cycles on
top of that.

I've no real sense of where the lifecycle stuff is at or how invasive it
is, so have no real reference to compare against. In any event, my
attempts to progress this have kind of tripped my early wack-a-mole
detector so I'll leave this alone for now and we can come back to it as
an incremental step if the need arises.

Brian

> > However, every RCU requirement/characteristic that this series has to
> > deal with is never going to be 100% perfectly aligned with the longer
> > term busy inode requirements because the implementations/definitions
> > will differ, particularly if the RCU handling is pushed up into the VFS.
> > So if we're concerned about that, the alternative approach is to skip
> > incrementally addressing the RCU inode reuse problem and just fold
> > whatever bits of useful logic from here into your inode lifecycle work
> > as needed and drop this as a mergeable component.
> 
> *nod*
> 
> The signs are pointing somewhat that way, but I'm still finding
> the occasional unexpected gotcha in the code that I have to work
> around. I think I've got them all, but until I've got it working it
> pays to keep our options open....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


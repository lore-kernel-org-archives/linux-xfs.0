Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C66C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 21:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiB1Vqg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiB1Vqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 16:46:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3067F85959
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646084754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dyyhh0Y8bWUnHcCLKKZ+FPEPykWx2HFHVPLFmRBNTJI=;
        b=IbogNahTuRNBn9z+9clp+ofNzzizWCdvYjBy/rAyqpyo3J1LPc7cJzeRCthhT0tZrf8Ofb
        dpBaKqhAWkKLHwmeHlGgXlBS1Z3fekKC0J821MsMFKRml5Aqkh2BHg99xDfEOp2YF9M2sg
        QiW+4rhCFst7o5bSFqHL78YgSu+ijBA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-mbsdWWXBOQC_3_qZWWcNJw-1; Mon, 28 Feb 2022 16:45:52 -0500
X-MC-Unique: mbsdWWXBOQC_3_qZWWcNJw-1
Received: by mail-qk1-f199.google.com with SMTP id u17-20020a05620a431100b004765c0dc33cso12489196qko.14
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:45:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dyyhh0Y8bWUnHcCLKKZ+FPEPykWx2HFHVPLFmRBNTJI=;
        b=B7duy6OJ/ysPoF6qkT1TA5570EwpILJs27Ir2yZ4KyupTW6eNs68r0sSceapmc9mcL
         ycX7Ratq+qSu34BcTajBBYgmNO0ercHxNG4CeeO/FFBkSB7mLe9zDfHq9ancDnngadG9
         jnDKFYu7tGRnEijPXTcZdk7zJdYvYZgYXdZkwUB8zjTnwqOEr16xxegiHWgwa48py2e8
         pssmbNFB7yF3TRNIvkB2gQXUEJfdd8eJAmxmFcqr4E2s5cuScKl0wOs/SXukc6Ofb77U
         lEgExQ+mU/wxibdykyGWmAWi8kNIX64/J3+rA9E+OHFIoGYanSJQ0zmAGnwx3uCZ8VhF
         ni4g==
X-Gm-Message-State: AOAM530MPwVBCVJJxfkxEm0566aK0Buon9X4yy+0lwcBcJ8V0X8LNex+
        6SXtrxru/k8JK/TD4aeAnw0i5gh8AKRPR3W/z91c10pEwN1l4tkGUc5QqUfyJOEBA5u0k//+YG6
        4VjrwEhtyyqO7K6Iq97YU
X-Received: by 2002:a37:9d91:0:b0:47a:520b:e7d8 with SMTP id g139-20020a379d91000000b0047a520be7d8mr12087207qke.26.1646084752126;
        Mon, 28 Feb 2022 13:45:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyv573QVjLmSqbNs71baGn75h8ywSvmE6ahcy2o9yIavPR/4xmlr4012yNLjJgPSlACz9LMeg==
X-Received: by 2002:a37:9d91:0:b0:47a:520b:e7d8 with SMTP id g139-20020a379d91000000b0047a520be7d8mr12087194qke.26.1646084751720;
        Mon, 28 Feb 2022 13:45:51 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id w13-20020a05622a190d00b002dd2600afc2sm7896975qtc.62.2022.02.28.13.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 13:45:51 -0800 (PST)
Date:   Mon, 28 Feb 2022 16:45:49 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <Yh1CjRONamUG0k1C@bfoster>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
 <Yg+rdFRpvra8U25D@bfoster>
 <20220218225440.GE59715@dread.disaster.area>
 <YhKM6u3yuF1Ek4/w@bfoster>
 <20220223070058.GK59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223070058.GK59715@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 23, 2022 at 06:00:58PM +1100, Dave Chinner wrote:
> On Sun, Feb 20, 2022 at 01:48:10PM -0500, Brian Foster wrote:
> > On Sat, Feb 19, 2022 at 09:54:40AM +1100, Dave Chinner wrote:
> > > On Fri, Feb 18, 2022 at 09:21:40AM -0500, Brian Foster wrote:
> > > > The point of background freeing inode chunks was that it makes this
> > > > problem go away because then we ensure that inode chunks aren't freed
> > > > until all associated busy inodes are cleared, and so we preserve the
> > > > historical behavior that an inode chunk allocation guarantees immediate
> > > > ability to allocate an inode. I thought we agreed in the previous
> > > > discussion that this was the right approach since it seemed to be in the
> > > > long term direction for XFS anyways.. hm?
> > > 
> > > Long term, yes, but we need something that works effectively and
> > > efficiently now, with minimal additional overhead, because we're
> > > going to have to live with this code in the allocation fast path for
> > > some time yet.
> > > 
> > 
> > Right, but I thought this is why we were only going to do the background
> > freeing part of the whole "background inode management" thing?
> > 
> > Short of that, I'm not aware of a really great option atm. IMO, pushing
> > explicit busy inode state/checking down into the block allocator is kind
> > of a gross layering violation. The approach this series currently uses
> > is simple and effective, but it's an unbound retry mechanism that just
> > continues to allocate chunks until we get one we can use, which is too
> > crude for production.
> 
> *nod*
> 
> Right, that's why I want to get this whole mechanism completely
> detached from the VFS inode RCU life cycle rules and instead
> synchronised by internal IO operations such as log forces.
> 
> The code I currently have is based on your changes, just without the
> fallback chunk allocation. I'm not really even scanning the irecs;
> I just look at the number of free inodes and count the number of
> busy inodes over the range of the record. If they aren't the same,
> we've got inodes in that record we can allocate from. I only do a
> free inode-by-free inode busy check once the irec we are going to
> allocate from has been selected.
> 
> Essentially, I'm just scanning records in the finobt to find the
> first with a non-busy inode. If we fall off the end of the finobt,
> it issues a log force and kicks the AIL and then retries the
> allocation from the finobt. There isn't any attempt to allocate new
> inode chunks in the case, but it may end up being necessary and can
> be done without falling back to the outer loops.
> 

Sure, that was just done for expediency to test the approach. That said,
as a first step I wouldn't be opposed to something that similarly falls
back to the outer loop so long as it incorporates a check like described
below to restrict the retry attempt(s). The logic is simple enough that
more extensive cleanups could come separately..

> i.e. as long as we track whether we've allocated a new inode chunk
> or not, we can bound the finobt search to a single retry. If we
> allocated a new chunk before entering the finobt search, then all we
> need is a log force because the busy inodes, by definition, are
> XFS_ISTALE at this point and waiting for a CIL push before they can
> be reclaimed. At this point an retry of the finobt scan will find
> those inodes that were busy now available for allocation.
> 

Remind me what aspect of the prospective VFS changes prevents inode
allocation from seeing a free inode with not-yet-elapsed RCU grace
period..? Will this delay freeing (or evicting) the inode until a grace
period elapses from when the last reference was dropped?

> If we haven't allocated a new chunk, then we can do so immediately
> and retry the allocation. If we still find them all busy, we force
> the log...
> 
> IOWs, once we isolate this busy inode tracking from the VFS inode
> RCU requirements, we can bound the allocation behaviour because
> chunk allocation and log forces provide us with a guarantee that the
> newly allocated inode chunks contain inodes that can be immediately
> reallocated without having to care about where the new inode chunk
> is located....
> 
> > Perhaps a simple enough short term option is to use the existing block
> > alloc min/max range mechanisms (as mentioned on IRC). For example:
> > 
> > - Use the existing min/max_agbno allocation arg input values to attempt
> >   one or two chunk allocs outside of the known range of busy inodes for
> >   the AG (i.e., allocate blocks higher than the max busy agino or lower
> >   than the min busy agino).
> > - If success, then we know we've got a chunk w/o busy inodes.
> > - If failure, fall back to the existing chunk alloc calls, take whatever
> >   we get and retry the finobt scan (perhaps more aggressively checking
> >   each record) hoping we got a usable new record.
> > - If that still fails, then fall back to synchronize_rcu() as a last
> >   resort and grab one of the previously busy inodes.
> > 
> > I couldn't say for sure if that would be effective enough without
> > playing with it a bit, but that would sort of emulate an algorithm that
> > filtered chunk block allocations with at least one busy inode without
> > having to modify block allocation code. If it avoids an RCU sync in the
> > majority of cases it might be effective enough as a stopgap until
> > background freeing exists. Thoughts?
> 
> It might work, but I'm not a fan of how many hoops we are considering
> jumping through to avoid getting tangled up in the RCU requirements
> for VFS inode life cycles. I'd much prefer just being able to say
> "all inodes busy, log force, try again" like we do with busy extent
> limited block allocation...
> 

Well presumably that works fine for your implementation of busy inodes,
but not so much for the variant intended to work around the RCU inode
reuse problem. ISTM this all just depends on the goals and plan here,
and I'm not seeing clear enough reasoning to grok what that is. A
summary of the options discussed so far:

- deferred inode freeing - ideal but too involved, want something sooner
  and more simple
- hinted non-busy chunk allocation - simple but jumping through too many
  RCU requirement hoops
- sync RCU and retry - most analogous to longer term busy inode
  allocation handling (i.e. just replace rcu sync w/ log force and
  retry), but RCU sync is too performance costly as a direct fallback

ISTM the options here range from simple and slow, to moderately simple
and effective (TBD), to complex and ideal. So what is the goal for this
series? My understanding to this point is that VFS changes are a ways
out, so the first step was busy inodes == inodes with pending grace
periods and a rework of the busy inode definition comes later with the
associated VFS changes. That essentially means this series gets fixed up
and posted as a mergeable component in the meantime, albeit with a
"general direction" that is compatible with longer term changes.

However, every RCU requirement/characteristic that this series has to
deal with is never going to be 100% perfectly aligned with the longer
term busy inode requirements because the implementations/definitions
will differ, particularly if the RCU handling is pushed up into the VFS.
So if we're concerned about that, the alternative approach is to skip
incrementally addressing the RCU inode reuse problem and just fold
whatever bits of useful logic from here into your inode lifecycle work
as needed and drop this as a mergeable component.

Brian

> That said, the complexity gets moved elsewhere (the VFS inode
> lifecycle management) rather than into the inode allocator, but I
> think that's a valid trade-off because the RCU requirements for
> inode reallocation come from the VFS inode lifecycle constraints.
> 
> > > Really, I want foreground inode allocation to know nothing about
> > > inode chunk allocation. If there are no inodes available for
> > > allocation, it kicks background inode chunk management and sleeps
> > > waiting for to be given an allocated inode it can use. It shouldn't
> > > even have to know about busy inodes - just work from an in-memory
> > > per-ag free list of inode numbers that can be immediately allocated.
> > > 
> > > In this situation, inodes that have been recently unlinked don't
> > > show up on that list until they can be reallocated safely. This
> > > is all managed asynchronously in the background by the inodegc state
> > > machine (what I'm currently working on) and when the inode is
> > > finally reclaimed it is moved into the free list and allowed to be
> > > reallocated.
> > > 
> > 
> > I think that makes a lot of sense. That's quite similar to another
> > experiment I was playing with that essentially populated a capped size
> > pool of background inactivated inodes that the allocation side could
> > pull directly from (i.e., so allocation actually becomes a radix tree
> > lookup instead of a filtered btree scan), but so far I was kind of
> > fighting with the existing mechanisms, trying not to peturb sustained
> > remove performance, etc., and hadn't been able to produce a performance
> > benefit yet. Perhaps this will work out better with the bigger picture
> > changes to inode lifecycle and background inode management in place..
> 
> *nod*
> 
> The "don't have a perf impact" side of thigns is generally why I
> test all my new code with fsmark and other scalability tests before
> I go anywhere near fstests. If it doesn't perform, it's not worth
> trying to make work correctly...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


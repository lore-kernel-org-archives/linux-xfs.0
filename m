Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31149C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 18:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiKDSXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 14:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiKDSXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 14:23:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19A4748DE
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667586124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zwDZ9Rd41r6Pb11KP2XktH3+UcmJcR73juvmRix9gFE=;
        b=JKSKSOQqCoQQgrAJj60/Woz7ZM4g+nRqzhPQ5+3X+yo+40wAOyVnG4p++DZO0HMnHX0CJN
        BfIOEK9gUZ0Yz0zGnQnFIaKT4B+c/rVqn8JMgthlCRKuytVoCG0tpeZrs7X3N1N7ISTbZD
        bE2c2+jSs4RAijQec99M3kDWoPhZ6Vw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-22-1NJJvOtXPWCnicNIUMZOSg-1; Fri, 04 Nov 2022 14:22:03 -0400
X-MC-Unique: 1NJJvOtXPWCnicNIUMZOSg-1
Received: by mail-qt1-f197.google.com with SMTP id z11-20020a05622a028b00b003a550fa8989so4113188qtw.12
        for <linux-xfs@vger.kernel.org>; Fri, 04 Nov 2022 11:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwDZ9Rd41r6Pb11KP2XktH3+UcmJcR73juvmRix9gFE=;
        b=Hxa6yARdNMfzEo/g5BCIWHLwcFIYsHs1vB7Kp5/TjxinlBOmv3/D0cZ+hCDHhFOWHU
         MZ1pgR0Ixx1X8CU6MKEF86fseQPnuF+XBcnDdWstH2WeCnOVf+Y+lC0dw3YudyiEqY1N
         pEDEx/IIAIXzm89IYpkTvyd0c97YcR64rhpZLvilqLtHTpuldZP3FCBnlRQA3ND7+ItS
         5lm43xoCWA1MjKu/OAO50VIcvQPukRBhWP3a/YT2EacbYeQ8rgIAoDlgLQrsxLs1Cxq9
         0Jvp19rTetDOOK4dyR+3UNe6Uu0IXfAIIY4YOz0z9MhhSZBEDeXWeUjL6yjcvW7bU0oo
         xmVw==
X-Gm-Message-State: ACrzQf0I6h/T6MkqehcXEHKfxjEIKL0mrGuIxRkADXQdIn28sVVbXcsF
        wXNwUqzZykxi2iRyO9dgDPEIunOtbQ9+sphrxpJcL7JAhQTsJwFFme96punVhZa5kV2QaVOoLk+
        cAm/+Fr7K7XlbAKsWS8cc
X-Received: by 2002:a05:6214:19ef:b0:4c1:a621:9ae6 with SMTP id q15-20020a05621419ef00b004c1a6219ae6mr4788399qvc.9.1667586122798;
        Fri, 04 Nov 2022 11:22:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5skxFWdFqXkrGRtbuNAcN2PH1Fe1D/DoZunUkHGdlMssHJBbChlaS7y2Dpk/+8bj2IpIAgMg==
X-Received: by 2002:a05:6214:19ef:b0:4c1:a621:9ae6 with SMTP id q15-20020a05621419ef00b004c1a6219ae6mr4788379qvc.9.1667586122457;
        Fri, 04 Nov 2022 11:22:02 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id az12-20020a05620a170c00b006bb87c4833asm39519qkb.109.2022.11.04.11.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 11:22:01 -0700 (PDT)
Date:   Fri, 4 Nov 2022 14:22:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: redirty eof folio on truncate to avoid filemap flush
Message-ID: <Y2VYTq0DlzCIepf2@bfoster>
References: <20221028130411.977076-1-bfoster@redhat.com>
 <20221028131109.977581-1-bfoster@redhat.com>
 <Y1we59XylviZs+Ry@bfoster>
 <20221028213014.GD3600936@dread.disaster.area>
 <Y2PV3KQ9K2l+65Eu@bfoster>
 <20221103222541.GJ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103222541.GJ3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 04, 2022 at 09:25:41AM +1100, Dave Chinner wrote:
> On Thu, Nov 03, 2022 at 10:53:16AM -0400, Brian Foster wrote:
> > On Sat, Oct 29, 2022 at 08:30:14AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 28, 2022 at 02:26:47PM -0400, Brian Foster wrote:
> > > > On Fri, Oct 28, 2022 at 09:11:09AM -0400, Brian Foster wrote:
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > > 
> > > > > Here's a quick prototype of "option 3" described in my previous mail.
> > > > > This has been spot tested and confirmed to prevent the original stale
> > > > > data exposure problem. More thorough regression testing is still
> > > > > required. Barring unforeseen issues with that, however, I think this is
> > > > > tentatively my new preferred option. The primary reason for that is it
> > > > > avoids looking at extent state and is more in line with what iomap based
> > > > > zeroing should be doing more generically.
> > > > > 
> > > > > Because of that, I think this provides a bit more opportunity for follow
> > > > > on fixes (there are other truncate/zeroing problems I've come across
> > > > > during this investigation that still need fixing), cleanup and
> > > > > consolidation of the zeroing code. For example, I think the trajectory
> > > > > of this could look something like:
> > > > > 
> > > > > - Genericize a bit more to handle all truncates.
> > > > > - Repurpose iomap_truncate_page() (currently only used by XFS) into a
> > > > >   unique implementation from zero range that does explicit zeroing
> > > > >   instead of relying on pagecache truncate.
> > > > > - Refactor XFS ranged zeroing to an abstraction that uses a combination
> > > > >   of iomap_zero_range() and the new iomap_truncate_page().
> > > > > 
> > > > 
> > > > After playing with this and thinking a bit more about the above, I think
> > > > I managed to come up with an iomap_truncate_page() prototype that DTRT
> > > > based on this. Only spot tested so far, needs to pass iomap_flags to the
> > > > other bmbt_to_iomap() calls to handle the cow fork, undoubtedly has
> > > > other bugs/warts, etc. etc. This is just a quick prototype to
> > > > demonstrate the idea, which is essentially to check dirty state along
> > > > with extent state while under lock and transfer that state back to iomap
> > > > so it can decide whether it can shortcut or forcibly perform the zero.
> > > > 
> > > > In a nutshell, IOMAP_TRUNC_PAGE asks the fs to check dirty state while
> > > > under lock and implies that the range is sub-block (single page).
> > > > IOMAP_F_TRUNC_PAGE on the imap informs iomap that the range was in fact
> > > > dirty, so perform the zero via buffered write regardless of extent
> > > > state.
> > > 
> > > I'd much prefer we fix this in the iomap infrastructure - failing to
> > > zero dirty data in memory over an unwritten extent isn't an XFS bug,
> > > so we shouldn't be working around it in XFS like we did previously.
> > > 
> > 
> > I agree, but that was the original goal from the start. It's easier said
> > than done to just have iomap accurately write/skip the appropriate
> > ranges..
> > 
> > > I don't think this should be call "IOMAP_TRUNC_PAGE", though,
> > > because that indicates the caller context, not what we are asking
> > > the internal iomap code to do. What we are really asking is for
> > > iomap_zero_iter() to do is zero the page cache if it exists in
> > > memory, otherwise ignore unwritten/hole pages.  Hence I think a name
> > > like IOMAP_ZERO_PAGECACHE is more appropriate,
> > > 
> > 
> > That was kind of the point for this prototype. The flag isn't just
> > asking iomap to perform some generic write behavior. It also indicates
> > this is a special snowflake mode with assumptions from the caller (i.e.,
> > unflushed, sub-block/partial range) that facilitate forced zeroing
> > internally.
> > 
> > I've since come to the conclusion that this approach is just premature.
> > It really only does the right thing in this very particular case,
> > otherwise there is potential for odd/unexpected behavior in sub-page
> > blocksize scenarios. It could be made to work more appropriately
> > eventually, but more thought and work is required and there's a jump in
> > complexity that isn't required to fix the immediate performance problem
> > and additional stale data exposure problems.
> > 
> > > > 
> > > > Brian
> > > > 
> > > > --- 8< ---
> > > > 
> > > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > > index 91ee0b308e13..14a9734b2838 100644
> > > > --- a/fs/iomap/buffered-io.c
> > > > +++ b/fs/iomap/buffered-io.c
> > > > @@ -899,7 +899,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> > > >  	loff_t written = 0;
> > > >  
> > > >  	/* already zeroed?  we're done. */
> > > > -	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> > > > +	if ((srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) &&
> > > > +	    !(srcmap->flags & IOMAP_F_TRUNC_PAGE))
> > > >  		return length;
> > > 
> > > Why even involve the filesystem in this? We can do this directly
> > > in iomap_zero_iter() with:
> > > 
> > > 	if ((srcmap->type == IOMAP_HOLE)
> > > 		return;
> > > 	if (srcmap->type == IOMAP_UNWRITTEN) {
> > > 		if (!(iter->flags & IOMAP_ZERO_PAGECACHE))
> > > 			return;
> > > 		if (!filemap_range_needs_writeback(inode->i_mapping,
> > > 			    iomap->offset, iomap->offset + iomap->length))
> > > 			return;
> > > 	}
> > > 
> > 
> > This reintroduces the same stale data exposure race fixed by the
> > original patch. folio writeback can complete and convert an extent
> > reported as unwritten such that zeroing will not occur when it should.
> 
> That sounds the exact data corruption bug that is being fixed in
> this xfs/iomap series here:
> 
> https://lore.kernel.org/linux-xfs/20221101003412.3842572-1-david@fromorbit.com/
> 
> > The writeback check either needs to be in the fs code where it can
> > prevent writeback completion from converting extents (under ilock), or
> > earlier in iomap such that we're guaranteed to see either writeback
> > state or the converted extent.
> 
> Or we catch stale iomaps once we've locked the page we are going to
> modify and remap the extent before continuing the modification
> operation.
> 

I wasn't planning to modify pages for reasons mentioned earlier. It's a
non-trivial jump in complexity for the problem I'm trying to address.

> > Given the above, I'm currently putting the prototype shown below through
> > some regression testing. It lifts the writeback check into iomap and
> > issues a flush and retry of the current iteration from iomap_zero_iter()
> > when necessary.
> 
> Hmmm. It looks exactly like you are trying to reinvent the patchset
> I've been working on for the past few weeks...
> 

Possibly.. I've not looked at it. First and foremost what I'm really
trying to do here is find a better way to deal with the truncate flush
problem that moves things closer to the long term goal of being handled
by iomap.

> [...]
> 
> > I have some patches around that demonstrate such things, but given the
> > current behavior of an unconditional flush and so far only seeing one
> > user report from an oddball pattern, I don't see much need for
> > additional hacks at the moment.
> > 
> > Thoughts? IMO, the iter retry and writeback check are both wonky and
> > this is something that should first go into ->iomap_begin(), and only
> > lift into iomap after a period of time. That's just my .02. I do plan to
> > clean up with a retry helper and add comments and whatnot if this
> > survives testing and/or any functional issues are worked out.
> 
> I think I've already solved all these problems with the above
> IOMAP_F_STALE infrastructure in the above patchset. If that's the
> case, then it seems like a no-brainer to me to base the fix for this
> problem on the IOMAP_F_STALE capability we will soon have in this
> code...
> 

I'd have to take a closer look. If the IOMAP_F_STALE thing is
essentially a superset of what I was trying to do wrt to the retry thing
(which is what it sounds like), then I agree it makes sense to reuse
that.

> > index 91ee0b308e13..649d94ad3808 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -894,17 +894,28 @@ EXPORT_SYMBOL_GPL(iomap_file_unshare);
> >  static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  {
> >  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> > +	struct inode *inode = iter->inode;
> >  	loff_t pos = iter->pos;
> >  	loff_t length = iomap_length(iter);
> >  	loff_t written = 0;
> > +	int status;
> >  
> >  	/* already zeroed?  we're done. */
> > -	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
> > -		return length;
> > +	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) {
> > +		if (!(srcmap->flags & IOMAP_F_DIRTY_CACHE))
> > +			return length;
> > +
> > +		status = filemap_write_and_wait_range(inode->i_mapping, pos,
> > +						      pos + length - 1);
> > +		if (status)
> > +			return status;
> > +		/* XXX: hacked up iter retry */
> > +		iter->iomap.length = 0;
> > +		return 1;
> 
> Yup, the IOMAP_F_STALE detection in iomap_write_begin() will detect
> writeback races w/ unwritten extents that change the extent state
> without needing to actually do physical writeback here.
> 
> IOWs, I think the fix here is not to skip IOMAP_UNWRITTEN extents up
> front, but to allow zeroing to detect data in the page cache over
> unwritten extents naturally.
> 
> i.e. if the iomap type is unwritten and we are zeroing, then
> iomap_write_begin() drops the FGP_CREAT flag. This means the folio
> lookup will only returns a folio if there was already a cached folio
> in the page cache. If there is a cached folio, it will do iomap
> validation and detect writeback races, marking the iomap stale. If
> there is no folio or the folio returned is not dirty, then
> iomap_zero_iter just moves on to checking the next folio in the
> range...
> 

The problem I have is that I've got three or four additional different
prototypes trying to do such things that haven't even been worth posting
because they all produce tricky to diagnose issues, including one that
literally does exactly what you note above regarding dropping FGP_CREAT
for mappings trimmed down based on sub-extent dirty state. It probably
has its own bugs, but I suspect aspects of iomap zeroing as well as
extent reporting in XFS (related to zeroing) need to change to make this
all function correctly, but I don't have it characterized enough to say
for sure.

> > @@ -71,10 +76,16 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> >  	if (ret <= 0)
> >  		return ret;
> >  
> > +	if ((iter->flags & IOMAP_ZERO) &&
> > +	    filemap_range_needs_writeback(iter->inode->i_mapping, iter->pos,
> > +					  iter->pos + iter->len - 1)) {
> > +		iomap_flags |= IOMAP_F_DIRTY_CACHE;
> > +	}
> 
> I really don't think we need this - I think we can do the page cache
> state check and the iomap stale check directly in the
> iomap_zero_iter() loop as per above...
> 

Ok, this may be a reasonable end goal, but there's a clear jump in
complexity, dependency requirements, and test scope between the targeted
fix I proposed and ultimate iomap zeroing perfection. I'm not trying to
achieve the latter. I'm trying to address a performance escalation that
moves things more in that direction to the degree possible.

I agree that if IOMAP_F_STALE overlaps with the approach in this patch,
it makes no sense to try and duplicate that here or create code
conflicts or dependencies. I have another version of this patch that
implements the same dirty check, flush, retry logic within
xfs_iomap_buffered_write_iomap_begin() such that it never returns a
"dirty," hole/unwritten mapping. It's a bit more code, but effective
from a functional and performance standpoint and logically simple enough
to backport as far back as needed with minimal risk and dependencies.
IMO, that's a fairly reasonable intermediate step to get from the
currently broken state to a more ideal iomap-based implementation. I'll
post it shortly and run some more testing against it.

Brian


Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274AFC3F2D8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 14:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58A220838
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 14:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1SwS+fE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbgCDODy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 09:03:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725795AbgCDODy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 09:03:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583330632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wWqnc6sf3X6s4KfKnwqfKvbvmj/4tuQcGHkeRp68JFM=;
        b=d1SwS+fEzntZDRYf/sRuWSkb3AXH+3dVNXCI8YQwgNyluwjFUA2gLPcPOSa3uDYM8FKtxU
        yYGtWPIGdl0gxOUrH9OWwCxGK4MzAxjJByogw6AUcBUNTkrLbA+4+gibPUwhCXCFJAXJdd
        DMFGIG2uU/IHU5MCphaGm9TZS64KtkI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-1Mvx8g-gNoGA8Rz5Ver8tg-1; Wed, 04 Mar 2020 09:03:50 -0500
X-MC-Unique: 1Mvx8g-gNoGA8Rz5Ver8tg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40F811005510;
        Wed,  4 Mar 2020 14:03:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAD6F5DA76;
        Wed,  4 Mar 2020 14:03:48 +0000 (UTC)
Date:   Wed, 4 Mar 2020 09:03:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200304140347.GA22037@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
 <20200302180650.GB10946@bfoster>
 <20200302232529.GN10776@dread.disaster.area>
 <20200303141316.GA15955@bfoster>
 <20200303212626.GS10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303212626.GS10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 08:26:26AM +1100, Dave Chinner wrote:
> On Tue, Mar 03, 2020 at 09:13:16AM -0500, Brian Foster wrote:
> > On Tue, Mar 03, 2020 at 10:25:29AM +1100, Dave Chinner wrote:
> > > On Mon, Mar 02, 2020 at 01:06:50PM -0500, Brian Foster wrote:
> > > > <thinking out loud from here on..>
> > > > 
> > > > One thing that comes to mind thinking about this is dealing with
> > > > batching (relog multiple items per roll). This code doesn't handle that
> > > > yet, but I anticipate it being a requirement and it's fairly easy to
> > > > update the current scheme to support a fixed item count per relog-roll.
> > > > 
> > > > A stealing approach potentially complicates things when it comes to
> > > > batching because we have per-item reservation granularity to consider.
> > > > For example, consider if we had a variety of different relog item types
> > > > active at once, a subset are being relogged while another subset are
> > > > being disabled (before ever needing to be relogged).
> > > 
> > > So concurrent "active relogging" + "start relogging" + "stop
> > > relogging"?
> > > 
> > 
> > Yeah..
> > 
> > > > For one, we'd have
> > > > to be careful to not release reservation while it might be accounted to
> > > > an active relog transaction that is currently rolling with some other
> > > > items, etc. There's also a potential quirk in handling reservation of a
> > > > relogged item that is cancelled while it's being relogged, but that
> > > > might be more of an implementation detail.
> > > 
> > > Right, did you notice the ail->ail_relog_lock rwsem that I wrapped
> > > my example relog transaction item add loop + commit function in?
> > > 
> > 
> > Yes, but the side effects didn't quite register..
> > 
> > > i.e. while we are building and committing a relog transaction, we
> > > hold off the transactions that are trying to add/remove their items
> > > to/from the relog list. Hence the reservation stealing accounting in
> > > the ticket can be be serialised against the transactional use of the
> > > ticket.
> > > 
> > 
> > Hmm, so this changes relog item/state management as well as the
> > reservation management. That's probably why it wasn't clear to me from
> > the code example.
> 
> Yeah, I left a lot out :P
> 
> > > It's basically the same method we use for serialising addition to
> > > the CIL in transaction commit against CIL pushes draining the
> > > current list for log writes (rwsem for add/push serialisation, spin
> > > lock for concurrent add serialisation under the rwsem).
> > > 
> > 
> > Ok. The difference with the CIL is that in that context we're processing
> > a single, constantly maintained list of items. As of right now, there is
> > no such list for relog enabled items. If I'm following correctly, that's
> > still not necessary here, we're just talking about wrapping a rw lock
> > around the state management (+ res accounting) and the actual res
> > consumption such that a relog cancel doesn't steal reservation from an
> > active relog transaction, for example.
> 
> That is correct. I don't think it actually matters because we can't
> remove an item that is locked and being relogged (so it's
> reservation is in use). Except for the fact we can't serialise
> internal itcket accounting updates the transaction might be doing
> with external tciket accounting modifications any other way.
> 

We do still need some form of serialization for objects that aren't
currently lockable, like certain intents. I suppose we could add locks
where necessary, but right now I'm thinking of a slight alteration of
the res accounting strategy to distinguish relog enabled items currently
resident in the relog transaction (i.e. awaiting the AIL processing to
complete and commit/roll the transaction) from all other relog enabled
items might be good enough.

Without something like that (or IOW if the relog transaction is the
central holder of all outstanding relog reservation), then we always
have to serialize relog cancel on an item against xfsaild populating a
relog transaction, regardless of whether the affected item is being
relogged at the time. That's again probably not something that's a huge
deal for the current use case, but it also _seems_ like something that
can be addressed via implementation tweaks without changing the
fundamental design. I guess we'll see once I have a chance to actually
play around with it... :P

> > > > I don't think that's a show stopper, but rather just something I'd like
> > > > to have factored into the design from the start. One option could be to
> > > 
> > > *nod*
> > > 
> > > > maintain a separate counter of active relog reservation aside from the
> > > > actual relog ticket. That way the relog ticket could just pull from this
> > > > relog reservation pool based on the current item(s) being relogged
> > > > asynchronously from different tasks that might add or remove reservation
> > > > from the pool for separate items. That might get a little wonky when we
> > > > consider the relog ticket needs to pull from the pool and then put
> > > > something back if the item is still reloggable after the relog
> > > > transaction rolls.
> > > 
> > > RIght, that's the whole problem that we solve via a) stealing the
> > > initial reserve/write grant space at commit time and b) serialising
> > > stealing vs transactional use of the ticket.
> > > 
> > > That is, after the roll, the ticket has a full reserve and grant
> > > space reservation for all the items accounted to the relog ticket.
> > > Every new relog item added to the ticket (or is relogged in the CIL
> > > and uses more space) adds the full required reserve/write grant
> > > space to the the relog ticket. Hence the relog ticket always has
> > > current log space reserved to commit the entire set of items tagged
> > > as reloggable. And by avoiding modifying the ticket while we are
> > > actively processing the relog transaction, we don't screw up the
> > > ticket accounting in the middle of the transaction....
> > > 
> > 
> > Yep, Ok.
> > 
> > > > Another problem is that reloggable items are still otherwise usable once
> > > > they are unlocked. So for example we'd have to account for a situation
> > > > where one transaction dirties a buffer, enables relogging, commits and
> > > > then some other transaction dirties more of the buffer and commits
> > > > without caring whether the buffer was relog enabled or not.
> > > 
> > > yup, that's the delta size updates from the CIL commit. i.e. if we
> > > relog an item to the CIL that has the XFS_LI_RELOG flag already set
> > > on it, the change in size that we steal for the CIL ticket also
> > > needs to be stolen for the AIL ticket. i.e. we already do almost all
> > > the work we need to handle this.
> > > 
> > > > Unless
> > > > runtime relog reservation is always worst case, that's a subtle path to
> > > > reservation overrun in the relog transaction.
> > > 
> > > Yes, but it's a problem the CIL already solves for us :P
> > 
> > Ok, I think we're pretty close to the same page here. I was thinking
> > about the worst case relog reservation being pulled off the committing
> > transaction unconditionally, where I think you're thinking about it as
> > the transaction (i.e. reservation calculation) would have the worst case
> > reservation, but we'd only pull off the delta as needed at commit time
> > (i.e. exactly how the CIL works wrt to transaction reservation
> > consumption). Let me work through a simple example to try and
> > (in)validate my concern:
> > 
> > - Transaction A is relog enabled, dirties 50% of a buffer and enables
> >   auto relogging. On commit, the CIL takes buffer/2 reservation for the
> >   log vector and the relog mechanism takes the same amount for
> >   subsequent relogs.
> > - Transaction B is not relog enabled (so no extra relog reservation),
> >   dirties another 40% of the (already relog enabled) buffer and commits.
> >   The CIL takes 90% of the transaction buffer reservation. The relog
> >   ticket now needs an additional 40% (since the original 50% is
> >   maintained by the relog system), but afaict there is no guarantee that
> >   res is available if trans B is not relog enabled.
> 
> Yes, I can see that would be an issue - very well spotted, Brian.
> 
> Without reading your further comments: off the top of my head that
> means we would probably have to declare particular types of objects
> as reloggable, and explicitly include that object in each
> reservation rather than use a generic "buffer" or "inode"
> reservation for it. We are likely to only be relogging "container"
> objects such as intents or high level structures such as,
> inodes, AG headers, etc, so this probably isn't a huge increase
> in transaction size or complexity, and it will be largely self
> documenting.
> 
> But cwit still adds more complexity, and we're trying to avoid that
> ....
> 
> .....
> 
> Oh, I'm a bit stupid only half way through my first coffee: just get
> rid of delta updates altogether and steal the entire relog
> reservation for the object up front.  We really don't need delta
> updates, it was just something the CIL does so I didn't think past
> "we can use that because it is already there"....
> 
> /me reads on...
> 
> > So IIUC, the CIL scheme works because every transaction automatically
> > includes worst case reservation for every possible item supported by the
> > transaction. Relog transactions are presumably more selective, however,
> > so we need to either have some rule where only relog enabled
> > transactions can touch relog enabled items (it's not clear to me how
> > realistic that is for things like buffers etc., but it sounds
> > potentially delicate) or we simplify the relog reservation consumption
> > calculation to consume worst case reservation for the relog ticket in
> > anticipation of unrelated transactions dirtying more of the associated
> > object since it was originally committed for relog. Thoughts?
> 
> Yep, I think we've both come to the same conclusion :)
> 

Indeed. Account for the max res. size of the associated object that the
relog enabled transaction already acquired for us anyways and we
shouldn't have to worry about further modifications of the object.

> > Note that carrying worst case reservation also potentially simplifies
> > accounting between multiple dirty+relog increments and a single relog
> > cancel, particularly if a relog cancelling transaction also happens to
> > dirty more of a buffer before it commits. I'd prefer to avoid subtle
> > usage landmines like that as much as possible. Hmm.. even if we do
> > ultimately want a more granular and dynamic relog res accounting, I
> > might start with the simple worst-case approach since 1.) it probably
> > doesn't matter for intents, 2.) it's easier to reason about the isolated
> > reservation calculation changes in an independent patch from the rest of
> > the mechanism and 3.) I'd rather get the basics nailed down and solid
> > before potentially fighting with granular reservation accounting
> > accuracy bugs. ;)
> 
> Absolutely. I don't think we'll ever need anything more dynamic
> or complex. And I think just taking the whole reservation will scale
> a lot better if we are constantly modifying the object - we only
> need to take the relog lock when we add or remove a relog
> reservation now, not on every delta change to the object....
> 

Yep, Ok. I think there's still some potential quirks to work through
with this approach (re: the per-item granularity
accounting/serialization bits mentioned above), but at this point it's
easier for me to reason about it by hacking on it a bit. If there are
still any issues to work out, best to have something concrete on the
list to guide discussion. Thanks Dave, appreciate the design input!

Brian

> Again, well spotted and good thinking!
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 


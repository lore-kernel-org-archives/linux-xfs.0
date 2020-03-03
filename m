Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844B6C3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 21:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C1AF214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 21:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgCCV0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 16:26:31 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58002 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732541AbgCCV0b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 16:26:31 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1B5157E9A9E;
        Wed,  4 Mar 2020 08:26:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9F3a-00045K-Kk; Wed, 04 Mar 2020 08:26:26 +1100
Date:   Wed, 4 Mar 2020 08:26:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200303212626.GS10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
 <20200302030750.GH10776@dread.disaster.area>
 <20200302180650.GB10946@bfoster>
 <20200302232529.GN10776@dread.disaster.area>
 <20200303141316.GA15955@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303141316.GA15955@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=yoCsdlSJI8vArdwUAX0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 09:13:16AM -0500, Brian Foster wrote:
> On Tue, Mar 03, 2020 at 10:25:29AM +1100, Dave Chinner wrote:
> > On Mon, Mar 02, 2020 at 01:06:50PM -0500, Brian Foster wrote:
> > > <thinking out loud from here on..>
> > > 
> > > One thing that comes to mind thinking about this is dealing with
> > > batching (relog multiple items per roll). This code doesn't handle that
> > > yet, but I anticipate it being a requirement and it's fairly easy to
> > > update the current scheme to support a fixed item count per relog-roll.
> > > 
> > > A stealing approach potentially complicates things when it comes to
> > > batching because we have per-item reservation granularity to consider.
> > > For example, consider if we had a variety of different relog item types
> > > active at once, a subset are being relogged while another subset are
> > > being disabled (before ever needing to be relogged).
> > 
> > So concurrent "active relogging" + "start relogging" + "stop
> > relogging"?
> > 
> 
> Yeah..
> 
> > > For one, we'd have
> > > to be careful to not release reservation while it might be accounted to
> > > an active relog transaction that is currently rolling with some other
> > > items, etc. There's also a potential quirk in handling reservation of a
> > > relogged item that is cancelled while it's being relogged, but that
> > > might be more of an implementation detail.
> > 
> > Right, did you notice the ail->ail_relog_lock rwsem that I wrapped
> > my example relog transaction item add loop + commit function in?
> > 
> 
> Yes, but the side effects didn't quite register..
> 
> > i.e. while we are building and committing a relog transaction, we
> > hold off the transactions that are trying to add/remove their items
> > to/from the relog list. Hence the reservation stealing accounting in
> > the ticket can be be serialised against the transactional use of the
> > ticket.
> > 
> 
> Hmm, so this changes relog item/state management as well as the
> reservation management. That's probably why it wasn't clear to me from
> the code example.

Yeah, I left a lot out :P

> > It's basically the same method we use for serialising addition to
> > the CIL in transaction commit against CIL pushes draining the
> > current list for log writes (rwsem for add/push serialisation, spin
> > lock for concurrent add serialisation under the rwsem).
> > 
> 
> Ok. The difference with the CIL is that in that context we're processing
> a single, constantly maintained list of items. As of right now, there is
> no such list for relog enabled items. If I'm following correctly, that's
> still not necessary here, we're just talking about wrapping a rw lock
> around the state management (+ res accounting) and the actual res
> consumption such that a relog cancel doesn't steal reservation from an
> active relog transaction, for example.

That is correct. I don't think it actually matters because we can't
remove an item that is locked and being relogged (so it's
reservation is in use). Except for the fact we can't serialise
internal itcket accounting updates the transaction might be doing
with external tciket accounting modifications any other way.

> > > I don't think that's a show stopper, but rather just something I'd like
> > > to have factored into the design from the start. One option could be to
> > 
> > *nod*
> > 
> > > maintain a separate counter of active relog reservation aside from the
> > > actual relog ticket. That way the relog ticket could just pull from this
> > > relog reservation pool based on the current item(s) being relogged
> > > asynchronously from different tasks that might add or remove reservation
> > > from the pool for separate items. That might get a little wonky when we
> > > consider the relog ticket needs to pull from the pool and then put
> > > something back if the item is still reloggable after the relog
> > > transaction rolls.
> > 
> > RIght, that's the whole problem that we solve via a) stealing the
> > initial reserve/write grant space at commit time and b) serialising
> > stealing vs transactional use of the ticket.
> > 
> > That is, after the roll, the ticket has a full reserve and grant
> > space reservation for all the items accounted to the relog ticket.
> > Every new relog item added to the ticket (or is relogged in the CIL
> > and uses more space) adds the full required reserve/write grant
> > space to the the relog ticket. Hence the relog ticket always has
> > current log space reserved to commit the entire set of items tagged
> > as reloggable. And by avoiding modifying the ticket while we are
> > actively processing the relog transaction, we don't screw up the
> > ticket accounting in the middle of the transaction....
> > 
> 
> Yep, Ok.
> 
> > > Another problem is that reloggable items are still otherwise usable once
> > > they are unlocked. So for example we'd have to account for a situation
> > > where one transaction dirties a buffer, enables relogging, commits and
> > > then some other transaction dirties more of the buffer and commits
> > > without caring whether the buffer was relog enabled or not.
> > 
> > yup, that's the delta size updates from the CIL commit. i.e. if we
> > relog an item to the CIL that has the XFS_LI_RELOG flag already set
> > on it, the change in size that we steal for the CIL ticket also
> > needs to be stolen for the AIL ticket. i.e. we already do almost all
> > the work we need to handle this.
> > 
> > > Unless
> > > runtime relog reservation is always worst case, that's a subtle path to
> > > reservation overrun in the relog transaction.
> > 
> > Yes, but it's a problem the CIL already solves for us :P
> 
> Ok, I think we're pretty close to the same page here. I was thinking
> about the worst case relog reservation being pulled off the committing
> transaction unconditionally, where I think you're thinking about it as
> the transaction (i.e. reservation calculation) would have the worst case
> reservation, but we'd only pull off the delta as needed at commit time
> (i.e. exactly how the CIL works wrt to transaction reservation
> consumption). Let me work through a simple example to try and
> (in)validate my concern:
> 
> - Transaction A is relog enabled, dirties 50% of a buffer and enables
>   auto relogging. On commit, the CIL takes buffer/2 reservation for the
>   log vector and the relog mechanism takes the same amount for
>   subsequent relogs.
> - Transaction B is not relog enabled (so no extra relog reservation),
>   dirties another 40% of the (already relog enabled) buffer and commits.
>   The CIL takes 90% of the transaction buffer reservation. The relog
>   ticket now needs an additional 40% (since the original 50% is
>   maintained by the relog system), but afaict there is no guarantee that
>   res is available if trans B is not relog enabled.

Yes, I can see that would be an issue - very well spotted, Brian.

Without reading your further comments: off the top of my head that
means we would probably have to declare particular types of objects
as reloggable, and explicitly include that object in each
reservation rather than use a generic "buffer" or "inode"
reservation for it. We are likely to only be relogging "container"
objects such as intents or high level structures such as,
inodes, AG headers, etc, so this probably isn't a huge increase
in transaction size or complexity, and it will be largely self
documenting.

But cwit still adds more complexity, and we're trying to avoid that
....

.....

Oh, I'm a bit stupid only half way through my first coffee: just get
rid of delta updates altogether and steal the entire relog
reservation for the object up front.  We really don't need delta
updates, it was just something the CIL does so I didn't think past
"we can use that because it is already there"....

/me reads on...

> So IIUC, the CIL scheme works because every transaction automatically
> includes worst case reservation for every possible item supported by the
> transaction. Relog transactions are presumably more selective, however,
> so we need to either have some rule where only relog enabled
> transactions can touch relog enabled items (it's not clear to me how
> realistic that is for things like buffers etc., but it sounds
> potentially delicate) or we simplify the relog reservation consumption
> calculation to consume worst case reservation for the relog ticket in
> anticipation of unrelated transactions dirtying more of the associated
> object since it was originally committed for relog. Thoughts?

Yep, I think we've both come to the same conclusion :)

> Note that carrying worst case reservation also potentially simplifies
> accounting between multiple dirty+relog increments and a single relog
> cancel, particularly if a relog cancelling transaction also happens to
> dirty more of a buffer before it commits. I'd prefer to avoid subtle
> usage landmines like that as much as possible. Hmm.. even if we do
> ultimately want a more granular and dynamic relog res accounting, I
> might start with the simple worst-case approach since 1.) it probably
> doesn't matter for intents, 2.) it's easier to reason about the isolated
> reservation calculation changes in an independent patch from the rest of
> the mechanism and 3.) I'd rather get the basics nailed down and solid
> before potentially fighting with granular reservation accounting
> accuracy bugs. ;)

Absolutely. I don't think we'll ever need anything more dynamic
or complex. And I think just taking the whole reservation will scale
a lot better if we are constantly modifying the object - we only
need to take the relog lock when we add or remove a relog
reservation now, not on every delta change to the object....

Again, well spotted and good thinking!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

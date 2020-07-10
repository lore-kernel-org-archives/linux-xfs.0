Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212C4C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 04:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA5A62065C
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 04:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgGJEJZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 00:09:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45110 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbgGJEJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 00:09:25 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DBD103A4744;
        Fri, 10 Jul 2020 14:09:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtkLd-0002qm-OS; Fri, 10 Jul 2020 14:09:17 +1000
Date:   Fri, 10 Jul 2020 14:09:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/10] xfs: automatic relogging
Message-ID: <20200710040917.GA2005@dread.disaster.area>
References: <20200701165116.47344-1-bfoster@redhat.com>
 <20200702115144.GH2005@dread.disaster.area>
 <20200702185209.GA58137@bfoster>
 <20200703004940.GI2005@dread.disaster.area>
 <20200706160306.GA21048@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706160306.GA21048@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=d_atrYzq1Ch0o4EZalEA:9 a=dt-Svyb5aq1rHgKi:21 a=AuVArrWjmpLYP9aO:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 06, 2020 at 12:03:06PM -0400, Brian Foster wrote:
> On Fri, Jul 03, 2020 at 10:49:40AM +1000, Dave Chinner wrote:
> > On Thu, Jul 02, 2020 at 02:52:09PM -0400, Brian Foster wrote:
> > > On Thu, Jul 02, 2020 at 09:51:44PM +1000, Dave Chinner wrote:
> > > > On Wed, Jul 01, 2020 at 12:51:06PM -0400, Brian Foster wrote:

[....]
> > > how it works, etc., so that suggests there are still concerns around the
> > > mechanism itself independent from quotaoff. I've sent 5 or so RFCs to
> > > try and elicit general feedback and address fundamental concerns before
> > > putting in the effort to solidify the implementation, which was notably
> > > more time consuming than reworking the RFC. It's quite frustrating to
> > > see negative feedback broaden at this stage in a manner/pattern that
> > > suggests the mechanism is not generally acceptable.
> > 
> > Well, my initial reponse to the very first RFC was:
> > 
> > | [...] I can see how appealing the concept of automatically
> > | relogging is, but I'm unconvinced that we can make it work,
> > | especially when there aren't sufficient reservations to relog
> > | the items that need relogging.
> > 
> > https://lore.kernel.org/linux-xfs/20191024224308.GD4614@dread.disaster.area/
> > 
> > To RFC v4, which was the next version I had time to look at:
> > 
> > | [long list of potential issues]
> > |
> > | Given this, I'm skeptical this can be made into a useful, reliable
> > | generic async relogging mechanism.
> > 
> > https://lore.kernel.org/linux-xfs/20191205210211.GP2695@dread.disaster.area/
> > 
> > Maybe general comments that "I remain unconvinced this will work"
> > got drowned out by all the other comments I made trying to help you
> > understand the code and hence make it work.
> 
> I explicitly worked through those issues to the point where to the best
> that I can tell, the mechanism works.

Yes, but that didn't remove my underlying concern that requiring
the subsystem that guarantees transactions can make forwards
progress to require the use of transactions to guarantee forwards
progress of transactions...

That layering inversion/catch-22 is the structure I am deeply
uncomfortable with. That's what I want to run away from screaming -
so much is reliant on the AIL making forwards progress (e.g. memory
reclaim!) that requiring something as complex as a CIL commit for
flushing to make progress is just a step to far for me.

[....]

> If the approach of some feature is generally not acceptable (as in "I'm
> not comfortable with the approach" or "I think it should be done another
> way"), that is potentially subjective but certainly valid feedback. I
> might or might not debate that feedback, but that's at least an honest
> debate where stances are clear. I'm certainly not going to try and
> stabilize something I know that one or more key upstream contributers do
> not agree with (unless I can convince them otherwise). If the feedback
> is "I'm skeptical it works because of items 1, 2, 3," that means the
> developer is likely to look through those issues and try to prove or
> disprove whether the mechanism works based on that insight.

The reviewer might be looking for insight, too, and whether
addressing the issues they raise alleviates their concerns.

Which, in this case for me, it hasn't.

> > > All that being what it is, I'd obviously rather not expend even more
> > > time if this is going to be met with vague/general reluctance. Do we
> > > need to go back to the drawing board on the repair use case? If so,
> > > should we reconsider the approach repair is using to release blocks?
> > > Perhaps alter this mechanism to address some tangible concerns? Try and
> > > come up with something else entirely..?
> > 
> > Well, like I said originally: I think relogging really needs to be
> > done from the perspective of the owner of the logged item so that we
> > can avoid things like ordering violations in the journal and other
> > similar issues. i.e. relogging is designed around it being a
> > function of the high order change algorithms and not something that
> > can be used to work around high level change algorithms that don't
> > follow the rules properly...
> 
> I'm curious if you have thoughts around what that might look like.
> Perhaps using quotaoff just as an example..? (Obviously we'd not
> implement that over the current proposal..).

I gave you one with the EFI relogging exmaple below. The intents
need a permanent transaction context to be relogged in, and the high
level code treats the intents like we do inodes and buffers and
relogs them on each transaction roll to ensure they keep moving
forward in the log....

> > Consider that a single transaction that contains an EFD for the
> > original EFI, and a new EFI for the same extent is effectively
> > "relogging the EFI". It does so by atomically cancelling the
> > original EFI in the log and creating a new EFI.
> 
> Right. This is how dfops currently works IIRC.

Well, not really. dfops is currently a mechanism for maintaining
atomic operations via linked intent chains; it is not (currently)
used as a mechanism for relogging intents that are already part of
the linked intent chain. It can likely be made to do this, but only
if the intent recovery code in older kernels can handle cancelling
and relogging without breaking...

> > Now, and EFI is defined on disk as:
> > 
> > typedef struct xfs_efi_log_format {
> >         uint16_t                efi_type;       /* efi log item type */
> >         uint16_t                efi_size;       /* size of this item */
> >         uint32_t                efi_nextents;   /* # extents to free */
> >         uint64_t                efi_id;         /* efi identifier */
> >         xfs_extent_t            efi_extents[1]; /* array of extents to free */
> > } xfs_efi_log_format_t;
> > 
> > Which means it can hold up to 2^16-1 individual extents that we
> > intend to free. We currently only use one extent per EFI, but if we
> > go back in history, they were dynamically sized structures and
> > could track arbitrary numbers of extents.
> > 
> > So, repair needs to track mulitple nested EFIs?
> > 
> > We cancel the old EFI, log a new EFI with all the old extents and
> > the new extent in it. We now have a single EFI in the journal
> > containing N+1 extents in it.
> > 
> 
> That's an interesting optimization.

It's not really an optimisation, it's largely reflective of how
extent freeing used to work a couple of decades ago where
xfs_itruncate_extents could free up to 4 data extents per
transaction.

That was problematic, though - over time we found all sorts of data
integrity issues as a result of race conditions with the
multi-extent operations based on cached extent maps. To solve these
problems we effectively reduced all the extent modification
operations down to a single extent at a time and that meant the
extent freeing loops that were wrapped by EFI/EFDs effectively
collapsed to "single extent only" operations...

> > We might have, but I don't recall that. And it would appear nobody
> > looked at this code in any detail if we did discuss it, so I'd say
> > the discussion was largely uninformed...
> > 
> > > Log recovery processes the quotaoff intent in pass 1 and
> > > dquot updates in pass 2, which I thought was intended to handle this
> > > kind of problem.
> > 
> > Right, it does handle it, but only because there are two quota-off
> > items in the log. i.e.  There's two recovery situations in play here
> > - 1) quota off in progress and 2) quota off done.
> > 
> > In the first case, only the initial quota-off item is in the log, so
> > it is needed to be detect to stop replay of relevant dquots that
> > have been logged after the quota off was started.
> > 
> > The second case has to be broken down into two sitations: a) both quota-off items
> > are active in the log, or b) only the second item is active in the log
> > as the tail has moved forwards past the first item.
> > 
> > In the case of 2a), it doesn't matter which item recovery sees, it
> > will cancel the dquot updates correctly. In the case of 2b), the
> > second quota off item is absolutely necessary to prevent replay of
> > the dquots in the log before it.
> > 
> > Hence if dquot modifications can leak past the first quota-off item
> > in the log, then the second item is absolutely necessary to catch
> > the 2b) case to prevent incorrect replay of dquot buffers.
> > 
> 
> Ok, but we're talking specifically about log recovery after quotaoff has
> completed but before both intents have fallen off of the log. Relogging
> of the initial intent (re: the original comment above about incorrect
> recovery behavior) has no impact on this general ordering between the
> start/end intents or dquot changes and the end intent.

Sure, I'm trying to explain why the intents were considered
necessary in the first place, not what impact relogging has on this
algorithm (which is none!).

> > > If I follow correctly, the recovery issue that warrants pinning the
> > > quotaoff in the log is not so much an ordering issue, but if the latter
> > > happens to fall off the end of the log before the last of the dquot
> > > modifications, recovery could see dquot changes after having lost the
> > > fact that a quotaoff had occurred at all. The current implementation
> > > presumably handles this by pinning the quotaoff until all dquots are
> > > completely purged from existence. The relog mechanism just allows the
> > > item to move while it effectively remains pinned, so I don't see how it
> > > introduces recovery issues.
> > 
> > As I said, it may not affect the specific quota-off usage, but we
> > can't just change the order of items in the physical journal without
> > care because the journal is supposed to be -strictly ordered-.
> > 
> 
> The mechanism itself is intended to target specific instances of log
> items. Each use case should be evaluated for correctness on its own,
> just like one would with ordered buffers or some other internal low
> level construct that changes behavior.

Yes, I know this. It's one of the things about this approach that
concerns me - the level of knowledge encoded into the specific
operations that are critical for correct operation.

> > Reordering intents in the log automatically without regard to higher
> > level transactional ordering dependencies of the log items may
> > violate the ordering rules for journalling and recovery of metadata.
> > This is why I said automatic relogging may not be useful as generic
> > infrastructure - if there are dependent log items, then they need to
> > relogged as an atomic change set that maintains the ordering
> > dependencies between objects. That's where this automatic mechanism
> > completely falls down - the ordering dependencies are known only by
> > the code running the original transaction, not the log items...
> > 
> 
> This and the above sounds to me that you're treating automatic relogging
> like it would just be enabled by default on all intents, reordering
> things arbitrarily. That is not the case as things would certainly
> break, just like what would happen if ordered buffers were enabled by
> default. The mechanism is per log item and context specific. It is
> "generic" in the sense that there are (were) multiple use cases for it,
> not that it should be used arbitrarily or "without care."

No, I'm treating it as "generic infrastructure" that various
things will use if they need to, and then extrapolating the problems
I see from there. I don't expect this to be applied to everything,
because that -will break everything-.

> Use cases that have very particular ordering requirements across certain
> sets of items should probably not enable this mechanism on those items
> or otherwise verify that relogging a particular item is safe. The
> potential example of this ordering problem being cited is quotaoff, but
> we've already gone through this example multiple times and established
> that relogging the quotaoff start item is safe.

Yes, but I've already proven that quotaoff -does not need relogging
at all- so whether relogging is safe for it or not is irrelevant to
the discussion of automatic relogging...

But that's precisely my concerns about this: every reloggin use case
has it's own complex set of requirements that need to be proven to
be safe and every change to said code will have to repeat that proof
so that it doesn't get broken.

The repeated, ongoing validation requirement is what killed
soft-updates as a viable fielsystem technology.....

> > > > To make it even more robust, if we stop all the transactions that
> > > > may dirty dquots and drain the active ones before we log the first
> > > > quota-off item, we can log the second item immediately afterwards
> > > > because it is known that there are no dquot modifications in flight
> > > > when the first item is logged. We can probably even log both items
> > > > in the same transaction.
> > > > 
> > > 
> > > I was going to ask why we'd even need two items if this approach is
> > > generally viable.
> > 
> > Because I don't want to change the in-journal appearance of
> > quota-off to older kernels. Changing how things appear on disk is
> > dangerous and likely going to bite us in unexpected ways.
> > 
> 
> Well combining them into a single transaction doesn't guarantee ordering
> of the two, right?

Sure it does. If they are combined into the one transaction, we can
_combine them_ into a single log item and guarantee that the two
quota off records are always formatted into the log in the correct
order.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

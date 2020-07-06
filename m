Return-Path: <SRS0=eqR3=AR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96D2C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A50C20722
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="er3K408N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgGFQDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 12:03:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24971 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729293AbgGFQDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jul 2020 12:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594051392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F/vs+yt2yjss0uATOokNAPbPswfotGM53gFOMkff7Tc=;
        b=er3K408N6QHIMuasmbXGl5a3QFFIeRW1hLeC4KPIsNdKz0Uc4e2jp/xVs3/qZzRFXu4cT6
        v05AuNdFxSMG+W/pHbczGBJJRMV87Wrav8HaF603cXWijQMxqcFFYLR6F7cxBJxwh/M7W3
        DpWdn0eoVma+mWR2joFM0YzllHxX+1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-3QDvNMVhPSWg-2AKyt3IPw-1; Mon, 06 Jul 2020 12:03:09 -0400
X-MC-Unique: 3QDvNMVhPSWg-2AKyt3IPw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79307805EE6;
        Mon,  6 Jul 2020 16:03:08 +0000 (UTC)
Received: from bfoster (ovpn-112-122.rdu2.redhat.com [10.10.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4A78756AA;
        Mon,  6 Jul 2020 16:03:07 +0000 (UTC)
Date:   Mon, 6 Jul 2020 12:03:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/10] xfs: automatic relogging
Message-ID: <20200706160306.GA21048@bfoster>
References: <20200701165116.47344-1-bfoster@redhat.com>
 <20200702115144.GH2005@dread.disaster.area>
 <20200702185209.GA58137@bfoster>
 <20200703004940.GI2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703004940.GI2005@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 03, 2020 at 10:49:40AM +1000, Dave Chinner wrote:
> On Thu, Jul 02, 2020 at 02:52:09PM -0400, Brian Foster wrote:
> > On Thu, Jul 02, 2020 at 09:51:44PM +1000, Dave Chinner wrote:
> > > On Wed, Jul 01, 2020 at 12:51:06PM -0400, Brian Foster wrote:
> > > > Hi all,
> > > > 
> > > > Here's a v1 (non-RFC) version of the automatic relogging functionality.
> > > > Note that the buffer relogging bits (patches 8-10) are still RFC as I've
> > > > had to hack around some things to utilize it for testing. I include them
> > > > here mostly for reference/discussion. Most of the effort from the last
> > > > rfc post has gone into testing and solidifying the functionality. This
> > > > now survives a traditional fstests regression run as well as a test run
> > > > with random buffer relogging enabled on every test/scratch device mount
> > > > that occurs throughout the fstests cycle. The quotaoff use case is
> > > > additionally tested independently by artificially delaying completion of
> > > > the quotaoff in parallel with many fsstress worker threads.
> > > > 
> > > > The hacks/workarounds to support the random buffer relogging enabled
> > > > fstests run are not included here because they are not associated with
> > > > core functionality, but rather are side effects of randomly relogging
> > > > arbitrary buffers, etc. I can work them into the buffer relogging
> > > > patches if desired, but I'd like to get the core functionality and use
> > > > case worked out before getting too far into the testing code. I also
> > > > know Darrick was interested in the ->iop_relog() callback for some form
> > > > of generic feedback into active dfops processing, so it might be worth
> > > > exploring that further.
> > > > 
> > > > Thoughts, reviews, flames appreciated.
> > > 
> > > Ok I've looked through the code again, and again I've had to pause,
> > > stop and think hard about it because the feeling I've had right from
> > > the start about the automatic relogging concept is stronger than
> > > ever.
> > > 
> > > I think the most constructive way to say what I'm feeling is that I
> > > think this is the wrong approach to solve the quota off problem.
> > > However, I've never been able to come up with an alternative that
> > > also solved the quotaoff problem so I've tried to help make this
> > > relogging concept work.
> > > 
> > 
> > I actually agree that this mechanism is overkill for quotaoff. I
> > probably wouldn't have invested this much time in the first place if
> > that was the only use case. Note that the original relogging concept
> > came about around discussion with Darrick on online btree repair because
> > IIRC the technique we landed on required dropping EFIs (which still have
> > open issues wrt to relogging) in the log for a non-deterministic amount
> > of time on an otherwise active fs. We came up with the concept and I
> > remembered quotaoff had a similar unresolved problem, so simply decided
> > to use that as a vector for the POC because the use case is much
> > simpler.
> 
> Yes, I know the history. That didn't make it any easier for me to
> write what I did, because I know how much time you've put into this
> already.
> 
> w.r.t. EFIs, that comes back to the problem of the relogged items
> jumping over things that have been logged that should appear between
> the EFI and EFD - moving the EFI forward past such dependent items
> is going to be a problem - those changes are going to replayed
> regardless of whether the EFI needs replaying or not, and hence
> replaying the EFI that got relogged will be out of order with other
> operations that occurred after then EFI was orginally logged.
> 
> > > It's a very interesting experiment, but I've always had a nagging
> > > doubt about putting transaction reservations both above and below
> > > the AIL. In reading this version, I'm having trouble following and
> > > understanding the transaction reservation juggling and
> > > recalculation complexity that's been introduced to facilitate
> > > the stealing that is being done. Yes, I know that I suggested the
> > > dynamic stealing approach - it's certainly better than past
> > > versions, but it hasn't really addressed my underlying doubt about
> > > the relogging concept in general...
> > > 
> > 
> > I think we need to separate discussion around the best solution for the
> > quotaoff problem from general doubts about the relog mechanism here. In
> > my mind, changing how we address quotaoff doesn't really impact the
> > existence of this mechanism because it was never the primary use case.
> > It just changes the timeline/dependency/requirements a bit.
> > 
> > However, you're mentioning "nagging doubts" about the fundamentals of
> > how it works, etc., so that suggests there are still concerns around the
> > mechanism itself independent from quotaoff. I've sent 5 or so RFCs to
> > try and elicit general feedback and address fundamental concerns before
> > putting in the effort to solidify the implementation, which was notably
> > more time consuming than reworking the RFC. It's quite frustrating to
> > see negative feedback broaden at this stage in a manner/pattern that
> > suggests the mechanism is not generally acceptable.
> 
> Well, my initial reponse to the very first RFC was:
> 
> | [...] I can see how appealing the concept of automatically
> | relogging is, but I'm unconvinced that we can make it work,
> | especially when there aren't sufficient reservations to relog
> | the items that need relogging.
> 
> https://lore.kernel.org/linux-xfs/20191024224308.GD4614@dread.disaster.area/
> 
> To RFC v4, which was the next version I had time to look at:
> 
> | [long list of potential issues]
> |
> | Given this, I'm skeptical this can be made into a useful, reliable
> | generic async relogging mechanism.
> 
> https://lore.kernel.org/linux-xfs/20191205210211.GP2695@dread.disaster.area/
> 
> Maybe general comments that "I remain unconvinced this will work"
> got drowned out by all the other comments I made trying to help you
> understand the code and hence make it work.
> 

I explicitly worked through those issues to the point where to the best
that I can tell, the mechanism works.

> Don't get me wrong - I really like the idea, but everything I know
> is telling me that, as it stands, I don't think it's going to work.
> A large part of that doubt is the absence of application level code
> that needs it to work in anger....
> 
> This is the nature of XFS development, especially in the log. I did
> this three times with development of delayed logging - I threw away
> prototypes I'd put similar effort into when it became obvious that
> there was a fundamental assumption I'd missed deep in the guts of
> the code and so the approach I was taking just wouldn't work. At the
> time, I had nobody to tell me that my approach might have problems
> before I found them out myself - all the deep XFS knowledge and
> expertise had been lost over the previous 10 years of brain drain as
> SGI flamed out and crashed.
> 
> So I know all too well what it feels like to get this far and then
> have to start again from the point of having to come up with a
> completely different design premise....
> 

I think you're misinterpreting my response. I don't mind having to move
on from or reinvent a design premise of an RFC, even after six versions,
because those have intentionally avoided the productization effort
(i.e., broad testing, stabilization, considering error conditions, code
documentation, etc.) that is so time consuming. I don't want to get too
far into the weeds on this topic given that I'm going to table this
series, but I'll try to summarize my thoughts for the benefit of next
time...

If the approach of some feature is generally not acceptable (as in "I'm
not comfortable with the approach" or "I think it should be done another
way"), that is potentially subjective but certainly valid feedback. I
might or might not debate that feedback, but that's at least an honest
debate where stances are clear. I'm certainly not going to try and
stabilize something I know that one or more key upstream contributers do
not agree with (unless I can convince them otherwise). If the feedback
is "I'm skeptical it works because of items 1, 2, 3," that means the
developer is likely to look through those issues and try to prove or
disprove whether the mechanism works based on that insight.

It appears to me that the issue here is not really whether the mechanism
works or not, but rather for one reason or another, you aren't
comfortable with the approach. That's fair enough, but that feedback
would have been far more useful on the previous RFC. It's not really
different from this version from a design perspective. To be fair, I
could have pinged that version since there wasn't much feedback and I
know folks are busy. I'll probably request some kind of informal design
ack in the future to help avoid this miscommunication...

> > All that being what it is, I'd obviously rather not expend even more
> > time if this is going to be met with vague/general reluctance. Do we
> > need to go back to the drawing board on the repair use case? If so,
> > should we reconsider the approach repair is using to release blocks?
> > Perhaps alter this mechanism to address some tangible concerns? Try and
> > come up with something else entirely..?
> 
> Well, like I said originally: I think relogging really needs to be
> done from the perspective of the owner of the logged item so that we
> can avoid things like ordering violations in the journal and other
> similar issues. i.e. relogging is designed around it being a
> function of the high order change algorithms and not something that
> can be used to work around high level change algorithms that don't
> follow the rules properly...
> 

I'm curious if you have thoughts around what that might look like.
Perhaps using quotaoff just as an example..? (Obviously we'd not
implement that over the current proposal..).

> I really haven't put any thought into how to solve the online-repair
> issue. I simply don't have the time to dive into every problem and
> come up with potential solutions to them. However, given the context
> of this discussion, we can already relog EFIs in a way that
> online-repair can use.
> 

I wasn't necessarily asking for a solution, but rather trying to figure
out where things stand on both relogging and repair given a large part
of the original feedback was focused on quotaoff. It sounds like
relogging is still an option in general terms, but in a manner that is
more intertwined with the originating transaction context/reservation.

> Consider that a single transaction that contains an EFD for the
> original EFI, and a new EFI for the same extent is effectively
> "relogging the EFI". It does so by atomically cancelling the
> original EFI in the log and creating a new EFI.
> 

Right. This is how dfops currently works IIRC.

> Now, and EFI is defined on disk as:
> 
> typedef struct xfs_efi_log_format {
>         uint16_t                efi_type;       /* efi log item type */
>         uint16_t                efi_size;       /* size of this item */
>         uint32_t                efi_nextents;   /* # extents to free */
>         uint64_t                efi_id;         /* efi identifier */
>         xfs_extent_t            efi_extents[1]; /* array of extents to free */
> } xfs_efi_log_format_t;
> 
> Which means it can hold up to 2^16-1 individual extents that we
> intend to free. We currently only use one extent per EFI, but if we
> go back in history, they were dynamically sized structures and
> could track arbitrary numbers of extents.
> 
> So, repair needs to track mulitple nested EFIs?
> 
> We cancel the old EFI, log a new EFI with all the old extents and
> the new extent in it. We now have a single EFI in the journal
> containing N+1 extents in it.
> 

That's an interesting optimization.

> Further, an EFD with multiple extents in it is -intended to be
> relogged- multiple times. Every time we free an extent in the EFI,
> we remove it from the EFD and relog the EFD. THis tells log recovery
> that this extent has now been freed, and that it should not replay
> it, even though it is still in the EFI.
> 
> And to prevent the big EFI from pinning the tail of the log while
> EFDs are being processed, we can relog the EFI along with the EFD
> each time the EFD is updated, hence we drag the EFI forwards in
> every high level transaction roll when we are actually freeing the
> extents.
> 

Hmm.. I'm not sure that addresses the deadlock problem for repair. That
assumes that EFD updates come at regular enough intervals to keep the
tail moving, but IIRC the bulk loading infrastructure will essentially
log a bunch of EFIs, spend a non-deterministic amount of time doing
work, then log the associated EFDs. So there's still a period of time in
there where we might need to relog intents that aren't otherwise being
updated.

Darrick might want to chime in here in case I'm missing something...

> The key to this is that the EFI/EFD relogging must be done entirely
> under a single rolling transaction, so there is -always- space
> available in the log for both the EFI and the EFDs to be relogged as
> the long running operation is performed.
> 
> IOWs, the EFI/EFD structures support relogging of the intents at a
> design level, and it is intended that this process is entirely
> driven from a single rolling transaction context. I srtongly suspect
> that all the recent EFI/EFD and deferred ops reworking has lost a
> lot of this context from the historical EFI/EFD implementation...
> 
> So before we go down the path of implementing generic automatic
> relogging infrastructure, we first should have been writing the
> application code that needs to relog intents and use a mechanism
> like the above to cancel and reinsert intents further down the log.
> Once we have code that is using these techniques to do bulk
> operations, then we can look to optimise/genericise the
> infrastructure they use.
> 
> > Moving on to quotaoff...
> > 
> > > I have been spending some time recently in the quota code, so I have
> > > a better grip on what it is doing now than I did last time I looked
> > > at this relogging code. I never really questioned why the quota code
> > > needed two transactions for quota-off, and I'm guessing that nobody
> > > else has either. So I spent some time this morning understanding
> > > what problem it was actually solving and trying to find an alternate
> > > solution to that problem.
> > 
> > Indeed, I hadn't looked into that.
> > 
> > > The reason we have the two quota-off transactions is that active
> > > dquot modifications at the time quotaoff is started leak past the
> > > first quota off transaction that hits the journal. Hence to avoid
> > > incorrect replay of those modifications in the journal if we crash
> > > after the quota-off item passes out of the journal, we pin the
> > > quota-off item in the journal. It gets unpinned by the commit of the
> > > second quota-off transaction at completion time, hence defining the
> > > window in journal where quota-off is being processed and dquot
> > > modifications should be ignored. i.e. there is no window where
> > > recovery will replay dquot modifications incorrectly.
> > > 
> > 
> > Ok.
> > 
> > > However, if the second transaction is left too long, the reservation
> > > will fail to find journal space because of the pinned quota-off item.
> > > 
> > 
> > Right.
> > 
> > > The relogging infrastructure is designed to allow the inital
> > > quota-off intent to keep moving forward in the log so it never pins
> > > the tail of the log before the second quota-off transaction is run.
> > > This tries to avoid the recovery issue because there's always an
> > > active quota off item in the log, but I think there may be a flaw
> > > here.  When the quotaoff item gets relogged, it jumps all the dquots
> > > in the log that were modified after the quota-off started. Hence if
> > > we crash after the relogging but while the dquots are still in the
> > > log before the relogged quotaoff item, then they will be replayed,
> > > possibly incorrectly. i.e. the relogged quota-off item no longer
> > > prevents replay of those items.
> > > 
> > > So while relogging prevents the tail pinning deadlock, I think it
> > > may actually result in incorrect recovery behaviour in that items
> > > that should be cancelled and not replayed can end up getting
> > > replayed.  I'm not sure that this matters for dquots, but for a
> > > general mechanism I think the transactional ordering violations it
> > > can result in reduce it's usefulness significantly.
> > > 
> > 
> > Hmm.. I could be mistaken, but I thought we reasoned about this a bit on
> > the early RFCs.
> 
> We might have, but I don't recall that. And it would appear nobody
> looked at this code in any detail if we did discuss it, so I'd say
> the discussion was largely uninformed...
> 
> > Log recovery processes the quotaoff intent in pass 1 and
> > dquot updates in pass 2, which I thought was intended to handle this
> > kind of problem.
> 
> Right, it does handle it, but only because there are two quota-off
> items in the log. i.e.  There's two recovery situations in play here
> - 1) quota off in progress and 2) quota off done.
> 
> In the first case, only the initial quota-off item is in the log, so
> it is needed to be detect to stop replay of relevant dquots that
> have been logged after the quota off was started.
> 
> The second case has to be broken down into two sitations: a) both quota-off items
> are active in the log, or b) only the second item is active in the log
> as the tail has moved forwards past the first item.
> 
> In the case of 2a), it doesn't matter which item recovery sees, it
> will cancel the dquot updates correctly. In the case of 2b), the
> second quota off item is absolutely necessary to prevent replay of
> the dquots in the log before it.
> 
> Hence if dquot modifications can leak past the first quota-off item
> in the log, then the second item is absolutely necessary to catch
> the 2b) case to prevent incorrect replay of dquot buffers.
> 

Ok, but we're talking specifically about log recovery after quotaoff has
completed but before both intents have fallen off of the log. Relogging
of the initial intent (re: the original comment above about incorrect
recovery behavior) has no impact on this general ordering between the
start/end intents or dquot changes and the end intent.

> > If I follow correctly, the recovery issue that warrants pinning the
> > quotaoff in the log is not so much an ordering issue, but if the latter
> > happens to fall off the end of the log before the last of the dquot
> > modifications, recovery could see dquot changes after having lost the
> > fact that a quotaoff had occurred at all. The current implementation
> > presumably handles this by pinning the quotaoff until all dquots are
> > completely purged from existence. The relog mechanism just allows the
> > item to move while it effectively remains pinned, so I don't see how it
> > introduces recovery issues.
> 
> As I said, it may not affect the specific quota-off usage, but we
> can't just change the order of items in the physical journal without
> care because the journal is supposed to be -strictly ordered-.
> 

The mechanism itself is intended to target specific instances of log
items. Each use case should be evaluated for correctness on its own,
just like one would with ordered buffers or some other internal low
level construct that changes behavior.

> Reordering intents in the log automatically without regard to higher
> level transactional ordering dependencies of the log items may
> violate the ordering rules for journalling and recovery of metadata.
> This is why I said automatic relogging may not be useful as generic
> infrastructure - if there are dependent log items, then they need to
> relogged as an atomic change set that maintains the ordering
> dependencies between objects. That's where this automatic mechanism
> completely falls down - the ordering dependencies are known only by
> the code running the original transaction, not the log items...
> 

This and the above sounds to me that you're treating automatic relogging
like it would just be enabled by default on all intents, reordering
things arbitrarily. That is not the case as things would certainly
break, just like what would happen if ordered buffers were enabled by
default. The mechanism is per log item and context specific. It is
"generic" in the sense that there are (were) multiple use cases for it,
not that it should be used arbitrarily or "without care."

Use cases that have very particular ordering requirements across certain
sets of items should probably not enable this mechanism on those items
or otherwise verify that relogging a particular item is safe. The
potential example of this ordering problem being cited is quotaoff, but
we've already gone through this example multiple times and established
that relogging the quotaoff start item is safe.

All that said, extending a relogging notification somehow to a
particular context has always been a consideration because 1.) direct
EFI relogging would require log recovery changes and 2.) there was yet
another potential use case where dfops needed to know whether to relog a
particular intent in a long running chain to avoid some issue (the
details of which escape me). I think issue #1 is not complicated to
address, but creates a backwards incompatibility for log recovery. Issue
#2 would potentially separate out relogging as a notification mechanism
from the reservation management bits, but it's still not clear to me
what that notification mechanism would look like for a transaction that
has already been committed by some caller context.

I think Darrick was looking at repurposing ->iop_relog() for that one so
I'd be curious to know what that is looking like in general...

> > > But back to quota-off: What I've realised is that the only dquot
> > > modifications we need to protect against being recovered are the
> > > ones that are running at the time the first quota-off is committed
> > > to the journal. That is, once the DQACTIVE flags are clear,
> > > transactions will not modify those dquots anymore. Hence by the time
> > > that the quota off item pins the tail of the log, the transactions
> > > that were actively dirtying inodes when it was committed have also
> > > committed and are in the journal and there are no actively modified
> > > dquots left in memory.
> > > 
> > 
> > I'm not sure how the (sync) commit of the quotaoff guarantees some other
> > transaction running in parallel hadn't modified a dquot and committed
> > after the quotaoff, but I think I see where you're going in general...
> 
> We drained out all the transactions that can be modifying quotas
> before we log the quotaoff items. So, by definition, this cannot
> happen.
> 
> > > IOWs, we don't actually need to wait until we've released and purged
> > > all the dquots from memory before we log the second quota off item;
> > > all we need to wait for is for all the transactions with dirty
> > > dquots to have committed. These transactions already have log
> > > reservations, so completing them will free unused reservation space
> > > for the second quota off transaction. Once they are committed, then
> > > we can log the second item. i.e. we don't have to wait until we've
> > > cleaned up the dquots to close out the quota-off transaction in the
> > > journal.
> > > 
> > 
> > Ok, so we can deterministically shorten the window with a runtime
> > barrier (i.e. disable -> drain) on quota modifying transactions rather
> > than relying on the full dquot purge to provide this ordering.
> 
> Yup.
> 
> > > To make it even more robust, if we stop all the transactions that
> > > may dirty dquots and drain the active ones before we log the first
> > > quota-off item, we can log the second item immediately afterwards
> > > because it is known that there are no dquot modifications in flight
> > > when the first item is logged. We can probably even log both items
> > > in the same transaction.
> > > 
> > 
> > I was going to ask why we'd even need two items if this approach is
> > generally viable.
> 
> Because I don't want to change the in-journal appearance of
> quota-off to older kernels. Changing how things appear on disk is
> dangerous and likely going to bite us in unexpected ways.
> 

Well combining them into a single transaction doesn't guarantee ordering
of the two, right? So it might not be worth doing that either if we're
concerned about log appearance. Regardless, those potential steps can be
evaluated independently on top of the core runtime fixes.

> > > So, putting my money where my mouth is, the patch below does this.
> > > It's survived 100 cycles of xfs/305 (qoff vs fsstress) and 10 cycles
> > > of -g quota with all quotas enabled and is currently running a full
> > > auto cycle with all quotas enabled. It hasn't let the smoke out
> > > after about 4 hours of testing now....
> > > 
> > 
> > Thanks for the patch. First, I like the idea and agree that it's more
> > simple than the relogging approach. I do still need to stare at it some
> > more to grok it and convince myself it's safe.
> > 
> > The thing that sticks out to me is tagging all of the transactions that
> > modify quotas. Is there any reason we can't just quiesce the transaction
> > subsystem entirely as a first step? It's not like quotaoff is common or
> > performance sensitive. For example:
> >
> > 1. stop all transactions, wait to drain, force log
> > 2. log the sb/quotaoff synchronously (punching through via something
> >    like NO_WRITECOUNT)
> > 3. clear the xfs_mount quota active flags
> > 4. restart the transaction subsystem (no more dquot mods)
> > 5. complete quotaoff via the dquot release and purge sequence
> 
> Yup, as I said on #xfs a short while ago:
> 
> [3/7/20 01:15] <djwong> qi_active_trans?
> [3/7/20 01:15] <djwong> man, we just killed off m_active_trans
> [3/7/20 08:47] <dchinner> djwong: I know we just killed off that atomic counter, it was used for doing exactly what I needed for quota-off, but freeze didn't need it anymore
> [3/7/20 08:48] <dchinner> I mean, we could just make quota-off freeze the filesystem, do quota-off, then unfreeze....
> [3/7/20 08:48] <dchinner> that's a simple, brute force solution
> [3/7/20 08:49] <dchinner> but it's also overkill in that it forces lots of unnecessary data writeback...
> [3/7/20 08:52] * djwong sometimes wonders if we just need a "run XXXX with exclusive access" thing
> [3/7/20 08:58] <dchinner> djwong: that's kinda what xfs_quiesce_attr() was originally intended for
> [3/7/20 08:59] <dchinner> but as all the code slowly got moved up into the VFS freeze layers, it stopped being able to be used for that sort of operation....
> [3/7/20 09:01] <djwong> oh
> [3/7/20 09:03] <dchinner> and so just after we remove the last remaining fragment of that original functionality, we find that maybe we actually still need to be able to quiesce the filesytsem for internal synchronisation reasons
> 
> So, we used to have exactly the functionality I needed in XFS as
> general infrastructure, but we've removed it over the past few years
> as the VFS has slowly been brought up to feature parity with XFS. I
> just implemented what I needed to block/halt quota modifications
> because I didn't want to perturb anything else while exploring if my
> hypothesis was correct.
> 

Ok.

> The only outstanding thing I haven't checked out fully is the
> delayed allocation reservations that aren't done in transaction
> contexts. I -think- these are OK because they are in memory only,
> and they will serialised on the inode lock when detatching dquots
> (i.e. the existing dquot purging ordering mechanisms) after quotas
> are turned off. Hence I think these are fine, but more investigation
> will be needed there to confirm behaviour is correct.
> 

Yep.

> > I think it could be worth the tradeoff for the simplicity of not having
> > to maintain the transaction reservation tags or the special quota
> > waiting infrastructure vs. something like the more generic (recently
> > removed) transaction counter. We might even be able to abstract the
> > whole thing behind a transaction flag. E.g.:
> > 
> > 	/*
> > 	 * A barrier transaction locks out further transactions and waits on
> > 	 * outstanding transactions to drain (i.e. commit) before returning.
> > 	 * Everything unlocks when the transaction commits.
> > 	 */
> > 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
> > 			XFS_TRANS_BARRIER, &tp);
> > 	...
> 
> Yup, if we decide that we want to track all active transactions again
> rather than just when quota is active, it would make a lot of
> sense to make it a formal function of the xfs_trans_alloc() API.
> 
> Really, though, I've got so many other things on my plate right now
> I don't have the time to take on yet another infrastructure
> reworking. I spent the time to write the patch because if I was
> going to say I didn't like relogging then it was absolutely
> necessary for me to provide an alternative solution to the problem,
> but I'm ireally hoping that it is sufficient for someone else to be
> able to pick it up and run with it....
> 

Ok, I can take a look at this since I need to step back and rethink this
particular feature anyways.

Brian

> Cheers,
> 
> Dave.
> 
> PS. FWIW, if anyone wants to pick up any RFC patchset I've posted in
> the past and run with it, I'm more than happy for you to do so. I've
> got way more ideas and prototypes than I've got time to turn into
> full production features. I also don't care about "ownership" of the
> work; it's better to have someone actively working on the code than
> having it sit around waiting for me to find time to get back to
> it...
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 


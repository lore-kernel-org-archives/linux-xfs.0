Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D828BCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 866432087F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 13:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVQfsv1j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388852AbfJ2N6J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 09:58:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52233 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388849AbfJ2N6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 09:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572357486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o8VbRxrtNGoka2rKqjKzXuvL/jDU13xSO0bHCW4zdKQ=;
        b=VVQfsv1jq0lORYsLBj9P6SlsGxMsI0l6Ss5LtvVM95UBLlwfglsS4OYABivV8nx7F8du9Z
        jE+L/Cf4FB1h2RPRJvX87qaBtEJJE8dzz747pHpgra5TfQ6w+N7dglye1q+kYSQDi5TjWo
        d+Rwez+g8W/fUElefq6/bF5uNBP3xV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-u-YwkXCkMiCUkK-lCNR22Q-1; Tue, 29 Oct 2019 09:58:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6CD6107AD28;
        Tue, 29 Oct 2019 13:58:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3797A2632F;
        Tue, 29 Oct 2019 13:58:01 +0000 (UTC)
Date:   Tue, 29 Oct 2019 09:57:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: automatic log item relogging experiment
Message-ID: <20191029135759.GG41131@bfoster>
References: <20191024172850.7698-1-bfoster@redhat.com>
 <20191024224308.GD4614@dread.disaster.area>
 <20191025124117.GA10931@bfoster>
 <20191025231628.GH4614@dread.disaster.area>
 <20191028142612.GA25450@bfoster>
 <20191028182038.GV15222@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191028182038.GV15222@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: u-YwkXCkMiCUkK-lCNR22Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 11:20:38AM -0700, Darrick J. Wong wrote:
> [/me finally jumps in with his perspectives]
>=20
> On Mon, Oct 28, 2019 at 10:26:12AM -0400, Brian Foster wrote:
> > On Sat, Oct 26, 2019 at 10:16:28AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 25, 2019 at 08:41:17AM -0400, Brian Foster wrote:
> > > > On Fri, Oct 25, 2019 at 09:43:08AM +1100, Dave Chinner wrote:
> > > > > On Thu, Oct 24, 2019 at 01:28:50PM -0400, Brian Foster wrote:
> > > > > > An experimental mechanism to automatically relog specified log
> > > > > > items.  This is useful for long running operations, like quotao=
ff,
> > > > > > that otherwise risk deadlocking on log space usage.
> > > > > >=20
> > > > > > Not-signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > ---
> > > > > >=20
...
> >=20
> > > i.e. if the intent falls off the tail of the log, then we have the
> > > situation of having a partial operation already on stable storage
> > > but no way of tracking how much work has been done. Hence I think we
> > > must confine relogging of intents to a single permanent transaction
> > > context, and intents that can get relogged must have an intent done
> > > logged with them to indicate progress that has been made. And, of
> > > course, log recovery will need mods to handle this, too.
> > >=20
> >=20
> > I'm not quite following what you mean by an intent falling off the tail
> > of the log. This patch modifies quotaoff because it presents a simple
> > and preexisting example of the problem it attempts to solve. Does this
> > scenario apply to that use case, or are you considering a more involved
> > use case here (such as btree reconstruction)?
>=20
> /me wonders, for quotaoff we end up with a transaction sequence:
>=20
> [start quotaoff] <potentially large pile of transactions> [end quotaoff]
>=20
> And AFAICT the quotaoff item makes it so that the log recovery code
> doesn't bother recovering dquot items, right?  So I'm not sure what
> intermediate progress information we need to know about?  Either we've
> finished quotaoff and won't be logging more dquots, or we haven't.
>=20
> I might just be confused, but I think your worry here is that something
> like this will happen?
>=20
> Log an intent, start doing the work:
>=20
> [log intent][start doing work]..........................
>=20
> Then other threads log some other work and the head get close to the end:
>=20
> ............[start doing work][other work]..............
>=20
> So we relog the intent and the other threads continue logging more work.
> Then the log wraps, zapping the first intent:
>=20
> [new work]..[start doing work][other work][relog intent]
>=20
> Now we crash.  Log recovery recovers "start doing work", then it
> recovers "other work", then it notes "relog intent", and finally it
> recovers "new work".  Next, it decides to restart "relog intent", which
> then trips over the filesystem because the item recovery code is too
> dumb to realize that we already did some, but not all of, the intended
> work?
>=20

Hm, Ok.. that sort of makes sense in terms of a problem statement. I
don't see it how it necessarily applies to the mechanism in this patch
because the use case covers extents that don't carry partial progress as
such. For example, from a quotaoff recovery standpoint, there's no real
difference whether it sees the original intent or a relogged variant
(the issue of seeing both notwithstanding). My understanding was the
same thing sort of applies for the repair use case because even though
an EFI does support partial progress relogging (via EFD, as Dave points
out), the free operations would only ever occur in error scenarios.

> (Did I get that right?)
>=20
> At least for repair the transaction sequence looks roughly like this:
>=20
> [allocate, EFI0][allocate, EFI1] <long wait to write new btree> \
> =09[commit root, EFD0, EFD1, EFI2, EFI3][free, EFD2][free, EFD3]
>=20
> EFI[01] are for the new btree blocks, EFI[23] are to kill the old ones.
>=20

Yep, that's my understanding from your previous descriptions. So
relogging (at least as defined by this version of the rfc) only really
applies to EFI[01] and only for the duration of the btree
reconstruction. It obviously needs to cancel to commit the associated
EFDs on repair completion (success), but the same would probably hold
true if the repair failed and we actually wanted to return the blocks to
the free space trees instead of shutdown.

> So there's not really any intermediate progress that's going through the
> log -- either we're ready to commit the new root and mess around with
> our EFI set, or we're not.  There's no intermediate progress to trip
> over.
>=20

Indeed.

> (Also it occurs to me just now that since btree reconstruction uses
> delwri_submit before committing the new root, it really ought to force
> the blocks to media via an explicit flush at the end or something to
> make sure that we've really committed the new btree blocks to stable
> storage, right?)
>=20

IIRC btree block population are all unlogged changes (hence the delwri
queue), so a flush probably makes sense. Making the final root commit
transaction synchronous might be appropriate, since that eliminates risk
of losing the repair via a crash after xfs_scrub returns back from
kernel space but before the transaction actually commits to the physical
log. If that sync trans commit occurs after delwri queue I/O completion,
the REQ_PREFLUSH associated with log buffer I/O might be sufficient to
guarantee the new btree is persistent.

...
> > >=20
> >=20
> > Ok. The context provided above helps and I like the idea in general.
> > I'm still missing some pieces around how this would be used in somethin=
g
> > like the btree reconstruction case, however.
> >=20
> > Suppose the intents that need relogging are committed with associated
> > callbacks and context, the btree reconstruction is in progress and the
> > callback is invoked. Would the callback handler simply just roll the
> > transaction in this case and relog the attached items? (If the former,
> > isn't it eventually a deadlock vector to roll from log commit context
> > once the rolling transaction runs out of ticket counts?). Or are you
> > anticipating something more complex in terms of the callback notifying
> > the repair sequence (somehow) that it needs to relog its rolling contex=
t
> > transaction at the next opportunity?
>=20
> I was thinking (this morning, on IRC :P) that log items could have a
> "hey we're getting full, please relog" handler.  When the head gets more
> than (say) 75% of the log size past the tail, we call the handler, if
> one was supplied.
>=20
> Repair of course supplies a handle, so it just kicks off a workqueue
> item to allocate a new transaction (hah!) that logs an intent done for
> the existing intent, logs a new identical intent, stuffs that back into
> repair's bookkeeping, and commits the transaction...
>=20

Yep, I think that's what Dave was getting at with regard to resurrecting
the old transaction callback. That would invoke at roughly the same time
I hardcoded adding to the relog list in this patch (i.e. once per CIL
checkpoint) and would generally trigger the relog/roll event for tracked
items.

The question at that point is more of how to manage the transaction (and
associated reservation) and general communication between the original
intent committer context, the ongoing relog context (i.e. the relog
task/workqueue) and then the original context again in order to cancel
any further relogging of a particular intent that is about to complete.

In thinking more about it, I am starting to wonder whether the initial
transaction roll thing makes sense. For one, the initial context can't
hold a memory reference to a transaction that some other context is
going to roll in the first place because that trans just becomes freed
memory on the first roll event. It might make more sense for the initial
transaction context to roll internally and transfer the new tp to
another context, but that is slightly shady too in that rolled
transactions share a log ticket and the log ticket is explicitly tied to
the allocating task for reservation scheduling purposes (i.e. see
->t_ticket->t_task).

The more I think about that, the more it _seems_ a bit more logical to
do something analogous to the CIL itself where relog context holds a
reservation ticket and the transaction processing is abstracted slightly
from the reservation management. That might facilitate several
independent tasks to acquire and transfer relog reservation to a central
relog context/ticket that could potentially relog many (unrelated) items
in its own transaction(s). That gets a little hairy itself because we
essentially have a dynamic reservation ticket where various relogged
items might be coming and going after each roll, etc., so I'd definitely
need to think about that some more. Perhaps it's good enough for a POC
to just let the relog task allocate its own fixed size transaction for
the time being (as you suggest above) and worry out the proper
reservation management as a next step..

Brian

> > I also think it's worth distinguishing between quotaoff and the repair
> > use case at this point. As noted above, this doesn't really address the
> > former and if we do take this callback approach, I'd like to find a way
> > to apply it there if at all possible. Admittedly, quotaoff is a bit of =
a
> > hacky use case as it is, so I'd even be fine with something along the
> > lines of running it it two separate (but coordinated) tasks[1] (i.e., o=
ne
> > dedicated to rolling and relogging the start intent and another to do
> > the actual quotaoff work), as long as the approach is ultimately safe
> > and resolves the problem. Thoughts?
> >=20
> > [1] That could be anything from a specific quotaoff task to a more
> > generic background relog worker that could be shared across users and
> > batch to fewer transactions.
>=20
> ...like this, perhaps.
>=20
> > > > FWIW, I'm also wondering if this lends itself to some form of batch=
ing
> > > > for if we get to the point of relogging a large number of small ite=
ms.
> > > > For example, consider a single dedicated/relogging transaction for =
many
> > > > small (or related) intents vs. N independent transactions processin=
g in
> > > > the background. This is something that could came later once the
> > > > fundamentals are worked out, however.
> > >=20
> > > That's exactly the problem I see needing to be solved for the
> > > "rebuild btrees in free space" type of long running operation that
> > > repair will need to run.
> > >=20
> > > i.e. an out-of-line btree rebuild that involves allocating space
> > > that should be freed again if the rebuild fails or we crash during
> > > the rebuild. Hence an EFI needs to be held for each allocation we
> > > do until we get the tree rebuilt and do the atomic swap of the root
> > > block. That atomic swap transaction also needs to commit all the
> > > EFDs, as the space is now in use and we need to cancel the EFIs.(+)
> > >=20
> > > Hence the rolling transaction will need to relog the primary "btree
> > > rebuild in progress" intent/intent-done pair as well as all the all
> > > the EFI/EFD pairs it holds for the extents it has allocated so far.
> > > The subsystem will have to co-ordinate the intent commit callback
> > > notification with it's ongoing transactional work that is done under
> > > it's rolling transaction context.
> > >=20
> > > IOWs, there's a whole lot more work needed than just updating a
> > > single intent pair in "btree rebuild" situation like this. I also
> > > don't really see how a "log internal" relogging mechanism based on
> > > stealing reservations will be able to handle the complexity of
> > > atomic multiple intent state updates. That requires
> > > subsystem/application specific knowledge to understand the
> > > relationship between all the intents that need to be relogged....
> > >=20
> >=20
> > Yeah, though to be fair you're attributing more responsibility and thus
> > more complexity than I initially intended for this mechanism. This was
> > intended to be a "don't deadlock on this unchanged item" mechanism and
> > thus fairly isolated/limited in use. I'd compare it to something like
> > ordered buffers in terms of complexity level. I.e., a low level
> > mechanism for specific use cases and to be managed/understood properly
> > by associated users.
> >=20
> > I've no issue with moving in the direction discussed here to facilitate
> > more complex higher level mechanisms (like tracking operational progres=
s
> > of btree reconstruction, etc.), I'm just saying that the complexity
> > argument you make here changes as the requirements do.
> >=20
> > > (+) The deferops and/or EFI code probably needs modification to
> > > support non-freeing, delayed EFD processing like this - it needs to
> > > log and track the intents it holds and relog them, but not free them
> > > or run EFDs until a later point in time. i.e. it becomes 2-part
> > > deferred op mechanism, with separate control of the intent-done
> > > processing phase. I'd like to use this mechanism for DIO and
> > > buffered writeback allocation (so we don't need to use unwritten
> > > extents), but I haven't had time to dig into it yet...
>=20
> Heh, I suspected this was going to come up in this discussion. :)
>=20
> > I can definitely see opening up the dfops interface to drive/control
> > intent relogging vs. progress updates vs. completion. This is somewhat
> > complicated by tricks like reusing certain intents in non-traditional
> > ways, such as completing an EFI with an EFD without actually freeing
> > blocks. Regardless, my questions to this point are more around
> > usage/semantics of the log commit callback and using it to manage
> > transaction rolls. Once those building blocks are settled, I'm sure we
> > can work out a reasonable interface.
>=20
> <nod>
>=20
> --D
>=20
> >=20
> > Brian
> >=20
> > > > All in all this sounds interesting. I still need to grok the transa=
ction
> > > > reservation/ownership semantics you propose re: the questions above=
, but
> > > > I do like the prospect of reusing existing mechanisms and thus bein=
g
> > > > able to more easily handle generic log items. Thanks for the
> > > > feedback...
> > >=20
> > > Yeah, i'd much prefer to implement something that fits within the
> > > existing model, too :)
> > >=20
> > > Cheers,
> > >=20
> > > Dave.
> > > --=20
> > > Dave Chinner
> > > david@fromorbit.com
> >=20


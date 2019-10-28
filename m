Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A65DCA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 14:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E242920659
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 14:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P39sCiK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfJ1O0W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:26:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728330AbfJ1O0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 10:26:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572272779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDr851xAKoqnb5WKhXDOSLHZYk7dQmVKSEGud6ybKNI=;
        b=P39sCiK71pXliYvjrBgxmuFAxxWYJMlXe1GNL9cNq9ORIEwUfJjf7g5nBQ+gM7GyaMxwDc
        5kUWP/uccFloODuFCkSyE9/kZuwY/dR5j1f9tA7TdrjCuBw7XYFnvnRfXSZ2l3elUAjB61
        bT3j+7QbzLBTW9HmhiVzV3KWxXt64RQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-wL3DR4bbOgKg8-4y9jmPfA-1; Mon, 28 Oct 2019 10:26:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 062F6476;
        Mon, 28 Oct 2019 14:26:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A4695DA32;
        Mon, 28 Oct 2019 14:26:14 +0000 (UTC)
Date:   Mon, 28 Oct 2019 10:26:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: automatic log item relogging experiment
Message-ID: <20191028142612.GA25450@bfoster>
References: <20191024172850.7698-1-bfoster@redhat.com>
 <20191024224308.GD4614@dread.disaster.area>
 <20191025124117.GA10931@bfoster>
 <20191025231628.GH4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191025231628.GH4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: wL3DR4bbOgKg8-4y9jmPfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 26, 2019 at 10:16:28AM +1100, Dave Chinner wrote:
> On Fri, Oct 25, 2019 at 08:41:17AM -0400, Brian Foster wrote:
> > On Fri, Oct 25, 2019 at 09:43:08AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 24, 2019 at 01:28:50PM -0400, Brian Foster wrote:
> > > > An experimental mechanism to automatically relog specified log
> > > > items.  This is useful for long running operations, like quotaoff,
> > > > that otherwise risk deadlocking on log space usage.
> > > >=20
> > > > Not-signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >=20
> > > > Hi all,
> > > >=20
> > > > This is an experiment that came out of a discussion with Darrick[1]=
 on
> > > > some design bits of the latest online btree repair work. Specifical=
ly,
> > > > it logs free intents in the same transaction as block allocation to
> > > > guard against inconsistency in the event of a crash during the repa=
ir
> > > > sequence. These intents happen pin the log tail for an indeterminat=
e
> > > > amount of time. Darrick was looking for some form of auto relog
> > > > mechanism to facilitate this general approach. It occurred to us th=
at
> > > > this is the same problem we've had with quotaoff for some time, so =
I
> > > > figured it might be worth prototyping something against that to try=
 and
> > > > prove the concept.
> > >=20
> > > Interesting idea. :)
> > >=20
> > > >=20
> > > > Note that this is RFC because the code and interfaces are a complet=
e
> > > > mess and this is broken in certain ways. This occasionally triggers=
 log
> > > > reservation overrun shutdowns because transaction reservation check=
ing
> > > > has not yet been added, the cancellation path is overkill, etc. IOW=
, the
> > > > purpose of this patch is purely to test a concept.
> > >=20
> > > *nod*
> > >=20
> > > > The concept is essentially to flag a log item for relogging on firs=
t
> > > > transaction commit such that once it commits to the AIL, the next
> > > > transaction that happens to commit with sufficient unused reservati=
on
> > > > opportunistically relogs the item to the current CIL context. For t=
he
> > > > log intent case, the transaction that commits the done item is requ=
ired
> > > > to cancel the relog state of the original intent to prevent further
> > > > relogging.
> > >=20
> > > Makes sense, but it seems like we removed the hook that would be
> > > used by transactions to implement their own relogging on CIL commit
> > > some time ago because nothign had used it for 15+ years....
> > >=20
> >=20
> > Interesting, I'm not familiar with this...
> >=20
> > > > In practice, this allows a log item to automatically roll through C=
IL
> > > > checkpoints and not pin the tail of the log while something like a
> > > > quotaoff is running for a potentially long period of time. This is
> > > > applied to quotaoff and focused testing shows that it avoids the
> > > > associated deadlock.
> > >=20
> > > Hmmm. How do we deal with multiple identical intents being found in
> > > checkpoints with different LSNs in log recovery?
> > >=20
> >=20
> > Good question. I was kind of thinking they would be handled like
> > normally relogged items, but I hadn't got to recovery testing yet. For
> > quotaoff, no special handling is required because we simply turn off
> > quota flags (i.e. no filesystem changes are required) when the intent i=
s
> > seen and don't do anything else with the log item. FWIW, we don't even
> > seem to check for an associated quotaoff_end item.
> >=20
> > For something more involved like an EFI, it looks like we'd create a
> > duplicate log item for the intent and I suspect that would lead to a
> > double processing attempt. So this would require some further changes t=
o
> > handle generic intent relogging properly.
>=20
> Right, that's kinda what I was getting at, but most intents as
> currently implemented are somewhat special from a "relogging"
> perspective in that they don't track ongoing modifications that have
> been made since the intent was originally logged.
>=20
> > I don't think it's that
> > difficult of a problem; we do already allow for relogs of other things
> > obviously, we just don't currently do any tracking of already seen
> > intents. That said, this could probably be considered an ABI change if
> > older kernels don't know how to process the condition correctly, so we'=
d
> > have to guard against that with a feature bit or some such when a
> > filesystem isn't unmounted cleanly.
>=20
> I don't think tracking duplicate intents is a difficult problem,
> either. The problem I see is when the original intent drops a full
> log cycle behind (i.e. out of the active recovery window) before
> the log recovery terminates and fails to find the intent-done item,
> hence we are left in a situation where -some- of the work has been
> done, but we don't know exactly what...
>=20
> Intents were designed to work within a permanent (rolling)
> transaction sequence - the intent and the done intent are directly
> related and the work that is done is done within the context of that
> rolling transaction. Expanding an intent to span an unbound amount
> of work should be ok if this work is done in the context of a single
> rolling transaction and we can relog the intent safely. However,
> Allowing intents to cover multiple independent transactions is a big
> can of worms I really don't us want to open...
>=20

Oh, agreed... What I'm saying above is that automatic relogging as
defined here is not intended for tracking progress as such. It simply
moves along an intent that isn't ever modified. If it is modified, it's
the responsibility of the caller to relog/roll/whatever.

> > More broadly, this implies that we don't ever currently relog intents s=
o
> > this is something that will come along with any implementation that
> > intends to do so unless we adopt an alternative along the lines of what
> > dfops processing does. Dfops completes the original intent and creates =
a
> > new one on each internal transaction roll.
>=20
> Right - chaining intents gives us atomic transactions from a
> recovery perspective. This works because intents cover only a small
> operation, so individual intents will never pin the tail of the log
> over the scope of the larger modification being made. This avoids
> the can of worms that open-ended, transaction indepedent intents
> expose....
>=20
> > My early thought was that
> > would be overkill for relogs that are more intended to facilitate
> > unrelated progress (i.e. not pin the log tail) as opposed to track
> > progress in a particular operation (i.e. dfops freed 1 extent out of a =
2
> > extent EFI, roll, complete the original EFI and create a new EFI with 1
> > extent left). The item never really changes in the first case where it
> > does in the second.
>=20
> The EFI is probably a bad example here - they were designed to relog
> the EFD on partial completion, not the EFI. i.e. the EFI can log an
> aribtrary number of extents to free, the EFD gets relogged on each
> extent free completion until all extents in the EFI are freed. The
> EFI itself was never intended to be relogged in the situation you
> describe above.(*)
>=20
> So, essentially, the EFD is the reloggable object that tracks
> completion, and so to relog an EFI, we could just  we could just
> relog the original EFI with the current EFD state indicating how
> much of the EFI had been completed. We already have to roll the
> inode in each of the EFD committing transactions to prevent it from
> pinning the tail of the log, so the EFI/EFD pair could easily be
> relogged like this, too. (**)
>=20
> But for intent/intent done pairs that aren't designed for a rolling
> completion like the EFD are more problematic, especially if we
> aren't actually logging a completion state but just relogging the
> intent. If the work being done is not in the same transaction
> context as the intent (i.e. independent transactions rather than a
> rolling context), then the intent cannot be sanely relogged without
> modification as there is work that is in the journal between the two
> intents that cannot be tracked by the intent relogging.
>=20

Right.

> i.e. if the intent falls off the tail of the log, then we have the
> situation of having a partial operation already on stable storage
> but no way of tracking how much work has been done. Hence I think we
> must confine relogging of intents to a single permanent transaction
> context, and intents that can get relogged must have an intent done
> logged with them to indicate progress that has been made. And, of
> course, log recovery will need mods to handle this, too.
>=20

I'm not quite following what you mean by an intent falling off the tail
of the log. This patch modifies quotaoff because it presents a simple
and preexisting example of the problem it attempts to solve. Does this
scenario apply to that use case, or are you considering a more involved
use case here (such as btree reconstruction)?

> (*) That iterative partial EFD completion was never implemented in
> the original design - I don't know the reason as it's not in the
> commit history - but I can guess that it was because the EFI pinned
> the tail of the log and caused deadlocks when the log was small.
> Accounting for this in reservations made the reservation size blow
> out and so defeated the purpose of rolling transactions to keep the
> reservation size down.
>=20

Heh, Ok.. I was wondering why I hadn't seen code that actually does
anything like this. :P

> (**) We only ever log single extent EFIs even with defer ops because
> of XFS_BUI_MAX_FAST_EXTENTS =3D 1.
>=20
> > > commit d420e5c810bce5debce0238021b410d0ef99cf08
> > > Author: Dave Chinner <dchinner@redhat.com>
> > > Date:   Tue Oct 15 09:17:53 2013 +1100
> > >=20
> > >     xfs: remove unused transaction callback variables
> > >    =20
> > >     We don't do callbacks at transaction commit time, no do we have a=
ny
> > >     infrastructure to set up or run such callbacks, so remove the
> > >     variables and typedefs for these operations. If we ever need to a=
dd
> > >     callbacks, we can reintroduce the variables at that time.
> > >    =20
> > >     Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > >     Reviewed-by: Ben Myers <bpm@sgi.com>
> > >     Signed-off-by: Ben Myers <bpm@sgi.com>
> > >=20
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index 09cf40b89e8c..71c835e9e810 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -85,18 +85,11 @@ struct xfs_item_ops {
> > >  #define XFS_ITEM_LOCKED                2
> > >  #define XFS_ITEM_FLUSHING      3
> > > =20
> > > -/*
> > > - * This is the type of function which can be given to xfs_trans_call=
back()
> > > - * to be called upon the transaction's commit to disk.
> > > - */
> > > -typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
> > > -
> > >  /*
> > >   * This is the structure maintained for every active transaction.
> > >   */
> > >  typedef struct xfs_trans {
> > >         unsigned int            t_magic;        /* magic number */
> > > -       xfs_log_callback_t      t_logcb;        /* log callback struc=
t */
> > >         unsigned int            t_type;         /* transaction type *=
/
> > >         unsigned int            t_log_res;      /* amt of log space r=
esvd */
> > >         unsigned int            t_log_count;    /* count for perm log=
 res */
> > >=20
> > > That's basically the functionality we want here - when the log item
> > > hits the journal, we want a callback to tell us so we can relog it
> > > ourselves if deemed necessary. i.e. it's time to reintroduce the
> > > transaction/log commit callback infrastructure...
> > >=20
> >=20
> > As noted earlier, this old mechanism is new to me.. This commit just
> > appears to remove an unused hook and the surrounding commits don't look
> > related. Was this previously used for something in particular?
>=20
> This is how xfs_trans_committed() used to be attached to the
> iclogbuf and called on completion. It was added back in 1994, and
> only ever used to call xfs_trans_committed() in the XFS code. IIRC,
> there was also an intent to use it in the CXFS metadata server to
> co-ordinate internal server state with the on-disk filesystem state,
> but I don't think it ever happened as cluster-wide state recovery
> after a system/server crash was already huge problem for CXFS
> without adding custom logging interactions to it...
>=20
> The code, prior to it's removal as delayed logging didn't use it
> anymore, was:
>=20
>        /*
>         * Tell the LM to call the transaction completion routine
>         * when the log write with LSN commit_lsn completes (e.g.
>         * when the transaction commit really hits the on-disk log).
>         * After this call we cannot reference tp, because the call
>         * can happen at any time and the call will free the transaction
>         * structure pointed to by tp.  The only case where we call
>         * the completion routine (xfs_trans_committed) directly is
>         * if the log is turned off on a debug kernel or we're
>         * running in simulation mode (the log is explicitly turned
>         * off).
>         */
>        tp->t_logcb.cb_func =3D xfs_trans_committed;
>        tp->t_logcb.cb_arg =3D tp;
>=20
>        /*
>         * We need to pass the iclog buffer which was used for the
>         * transaction commit record into this function, and attach
>         * the callback to it. The callback must be attached before
>         * the items are unlocked to avoid racing with other threads
>         * waiting for an item to unlock.
>         */
>        shutdown =3D xfs_log_notify(mp, commit_iclog, &(tp->t_logcb));
>=20
> IOWs, we used to attach individual transactions directly to the
> iclog to be called back from iclog completion and processed
> directly. Essentially, it is a "commit is now stable" notification
> mechanism.
>=20

Ok, so the transaction memory lifecycle was slightly longer compared to
the current model. I take it this was ultimately replaced with the CIL
context.

> > > This would get used in conjunction with a permanent transaction
> > > reservation, allowing the owner of the object to keep it locked over
> > > transaction commit (while whatever work is running between intent
> > > and done), and the transaction commit turns into a trans_roll. Then
> > > we reserve space for the next relogging commit, and go about our
> > > business.
> > >=20
> >=20
> > Hmm.. IIUC the original intent committer rolls instead of commits to
> > reacquire relogging reservation, but what if the submitter needs to
> > allocate and commit unrelated transactions before it gets to the point
> > of completing the intent?
>=20
> Not allowed. The intent + intent done must be committed as part of
> the same rolling transaction sequence. Commiting an intent without a
> reservation for the intent-done is a deadlock vector. i.e. intent
> pins the tail of the log, can't reserve space for the intent-done to
> remove it from the log.
>=20

Right, but this is exactly why quotaoff doesn't use such a rolling
transaction. The quotaoff sequence itself can produce transaction
allocations from inaccessible contexts (i.e. inode inactivation), so it
can't hold an open transaction during the dquot scanning and whatnot.
Instead, it commits the start intent, performs the necessary work, and
allocates a new transaction for quotaoff_end once it is safe again to
reserve log space. This of course is a deadlock vector because the tail
was pinned from the start, the indirect transaction activity generated
by quotaoff is unknown and the filesystem is still open to unrelated
workloads.

The problem this patch attempts to resolve is simply to keep the start
intent moving in the log, explicitly because it is not modified in any
way that tracks progress of quotaoff.

> Fundamentally, it is the responsibility of the running transaction
> to ensure objects it logs do not pin the tail of the log and prevent
> forwards progress of the transaction. The whole subsystem is
> designed around this premise. Hence while I can see how automatic
> relogging of intents like you've proposed is appealing, but it
> doesn't follow the "forwards progress guarantee" rules that the
> transactional model is built around.
>=20

Yeah, that makes sense. This is how dfops is essentially designed, but
the purpose of this is to deal with the context issue described above.
It is explicitly intended only for items that have not made progress
updates, but otherwise might be the only object pinning the tail of the
log.

Based on your feedback to this point, it seems to me that you're
expecting that this kind of indirect transaction scenario shouldn't
apply to btree reconstruction. That's fine, it just means that perhaps
these two use cases (from a logging perspective) aren't quite as similar
as I anticipated.

> Hence I think that if we have a long running intent that requires
> relogging, it needs to be done under a single rolling transaction
> context, not indepednent, unrelated transactions. We can roll
> permanent transactions an unbound number of times (just think about
> freeing several million extents in truncate) without penalty if they
> follow the forwards progress rules, so the only thing we need to do
> here is consider how to relog an intent pair for a specific
> operation safely.
>=20

Yeah, I can see how rolling to maintain the forward progress guarantee
prevents log deadlocks. I could also see how that still leaves practical
issues for long running operations. For example, if the btree
reconstruction phase takes a relative long amount of time without any
transaction commits (and with outstanding intents), then we risk pinning
the log tail and blocking (though not deadlocking) any other unrelated
operations until the repair completes. I suspect this is where the
transaction notification thing comes in, because that provides us the
hook to notify the transaction that "it's time to move this thing
along," whether that be on CIL context checkpoint as I've done here or
something more intelligent down the line.

> > I was originally thinking about "pre-reserving
> > and donating" relogging reservation along these lines, but I thought
> > reserving transactions like this (first for the intent+relog, then for
> > whatever random transaction is next) was a potential deadlock vector.
>=20
> This is what rolling transactions do. The reservation for any
> specific transaction in a sequence is guaranteed to be enough to
> for the next transaction in the sequence to run to completion.
>=20
> > Perhaps it's not if the associated items have all been committed to the
> > log subsystem. It also seemed unnecessary given our current design of
> > worst case reservation sizes, but that's a separate topic and may only
> > apply to intents (which are small compared to metadata associated with
> > generic log items).
> >=20
> > So are you suggesting ownership of the committed transaction transfers
> > to the log subsystem somehow or another? For example, we internally rol=
l
> > and queue the _transaction_ (not the log item) for relogging while from
> > the caller's perspective the transaction has committed? Or the
> > additional reservation is pulled off and the transaction commits (i.e.
> > frees)? Or something else?
>=20
> Not internal. Subsystem adds a callback to the transaction it is
> about to commit, that gets moved to the CIL context, when
> the CIL commits and the iclog completion processing is done then
> the CIL commit callbacks are run with whatever context the caller
> attached to it.
>=20

Ok. The context provided above helps and I like the idea in general.
I'm still missing some pieces around how this would be used in something
like the btree reconstruction case, however.

Suppose the intents that need relogging are committed with associated
callbacks and context, the btree reconstruction is in progress and the
callback is invoked. Would the callback handler simply just roll the
transaction in this case and relog the attached items? (If the former,
isn't it eventually a deadlock vector to roll from log commit context
once the rolling transaction runs out of ticket counts?). Or are you
anticipating something more complex in terms of the callback notifying
the repair sequence (somehow) that it needs to relog its rolling context
transaction at the next opportunity?

I also think it's worth distinguishing between quotaoff and the repair
use case at this point. As noted above, this doesn't really address the
former and if we do take this callback approach, I'd like to find a way
to apply it there if at all possible. Admittedly, quotaoff is a bit of a
hacky use case as it is, so I'd even be fine with something along the
lines of running it it two separate (but coordinated) tasks[1] (i.e., one
dedicated to rolling and relogging the start intent and another to do
the actual quotaoff work), as long as the approach is ultimately safe
and resolves the problem. Thoughts?

[1] That could be anything from a specific quotaoff task to a more
generic background relog worker that could be shared across users and
batch to fewer transactions.

> > FWIW, I'm also wondering if this lends itself to some form of batching
> > for if we get to the point of relogging a large number of small items.
> > For example, consider a single dedicated/relogging transaction for many
> > small (or related) intents vs. N independent transactions processing in
> > the background. This is something that could came later once the
> > fundamentals are worked out, however.
>=20
> That's exactly the problem I see needing to be solved for the
> "rebuild btrees in free space" type of long running operation that
> repair will need to run.
>=20
> i.e. an out-of-line btree rebuild that involves allocating space
> that should be freed again if the rebuild fails or we crash during
> the rebuild. Hence an EFI needs to be held for each allocation we
> do until we get the tree rebuilt and do the atomic swap of the root
> block. That atomic swap transaction also needs to commit all the
> EFDs, as the space is now in use and we need to cancel the EFIs.(+)
>=20
> Hence the rolling transaction will need to relog the primary "btree
> rebuild in progress" intent/intent-done pair as well as all the all
> the EFI/EFD pairs it holds for the extents it has allocated so far.
> The subsystem will have to co-ordinate the intent commit callback
> notification with it's ongoing transactional work that is done under
> it's rolling transaction context.
>=20
> IOWs, there's a whole lot more work needed than just updating a
> single intent pair in "btree rebuild" situation like this. I also
> don't really see how a "log internal" relogging mechanism based on
> stealing reservations will be able to handle the complexity of
> atomic multiple intent state updates. That requires
> subsystem/application specific knowledge to understand the
> relationship between all the intents that need to be relogged....
>=20

Yeah, though to be fair you're attributing more responsibility and thus
more complexity than I initially intended for this mechanism. This was
intended to be a "don't deadlock on this unchanged item" mechanism and
thus fairly isolated/limited in use. I'd compare it to something like
ordered buffers in terms of complexity level. I.e., a low level
mechanism for specific use cases and to be managed/understood properly
by associated users.

I've no issue with moving in the direction discussed here to facilitate
more complex higher level mechanisms (like tracking operational progress
of btree reconstruction, etc.), I'm just saying that the complexity
argument you make here changes as the requirements do.

> (+) The deferops and/or EFI code probably needs modification to
> support non-freeing, delayed EFD processing like this - it needs to
> log and track the intents it holds and relog them, but not free them
> or run EFDs until a later point in time. i.e. it becomes 2-part
> deferred op mechanism, with separate control of the intent-done
> processing phase. I'd like to use this mechanism for DIO and
> buffered writeback allocation (so we don't need to use unwritten
> extents), but I haven't had time to dig into it yet...
>=20

I can definitely see opening up the dfops interface to drive/control
intent relogging vs. progress updates vs. completion. This is somewhat
complicated by tricks like reusing certain intents in non-traditional
ways, such as completing an EFI with an EFD without actually freeing
blocks. Regardless, my questions to this point are more around
usage/semantics of the log commit callback and using it to manage
transaction rolls. Once those building blocks are settled, I'm sure we
can work out a reasonable interface.

Brian

> > All in all this sounds interesting. I still need to grok the transactio=
n
> > reservation/ownership semantics you propose re: the questions above, bu=
t
> > I do like the prospect of reusing existing mechanisms and thus being
> > able to more easily handle generic log items. Thanks for the
> > feedback...
>=20
> Yeah, i'd much prefer to implement something that fits within the
> existing model, too :)
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com


Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F45ECA9EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 12:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 356F721D81
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 12:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hszkn6rz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504529AbfJYMl0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 08:41:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2504508AbfJYMl0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 08:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572007283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7gBXSVVUKGF0CkWJeKq2vN+j9aZS/vMCCv9X1x+Pn/E=;
        b=hszkn6rzezxdkJmN520EnrIrDYa9hjqjewGj716XvM7RgHYAJKiTWykO/Q2aw/ZB6k75md
        zZasDixbN4UjkEr4Akb0xcWQpg4n16yFnkErfdM3Cwht6MTSfbKBUrB4gqnPGmffGG/UNq
        Z9SlZaRPvdB88Sve7NKOQCEja0k+t6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-Haiyf8g-MzC1ACnGPZtEMw-1; Fri, 25 Oct 2019 08:41:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8897F800D41;
        Fri, 25 Oct 2019 12:41:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C279600CD;
        Fri, 25 Oct 2019 12:41:18 +0000 (UTC)
Date:   Fri, 25 Oct 2019 08:41:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: automatic log item relogging experiment
Message-ID: <20191025124117.GA10931@bfoster>
References: <20191024172850.7698-1-bfoster@redhat.com>
 <20191024224308.GD4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191024224308.GD4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Haiyf8g-MzC1ACnGPZtEMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 09:43:08AM +1100, Dave Chinner wrote:
> On Thu, Oct 24, 2019 at 01:28:50PM -0400, Brian Foster wrote:
> > An experimental mechanism to automatically relog specified log
> > items.  This is useful for long running operations, like quotaoff,
> > that otherwise risk deadlocking on log space usage.
> >=20
> > Not-signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >=20
> > Hi all,
> >=20
> > This is an experiment that came out of a discussion with Darrick[1] on
> > some design bits of the latest online btree repair work. Specifically,
> > it logs free intents in the same transaction as block allocation to
> > guard against inconsistency in the event of a crash during the repair
> > sequence. These intents happen pin the log tail for an indeterminate
> > amount of time. Darrick was looking for some form of auto relog
> > mechanism to facilitate this general approach. It occurred to us that
> > this is the same problem we've had with quotaoff for some time, so I
> > figured it might be worth prototyping something against that to try and
> > prove the concept.
>=20
> Interesting idea. :)
>=20
> >=20
> > Note that this is RFC because the code and interfaces are a complete
> > mess and this is broken in certain ways. This occasionally triggers log
> > reservation overrun shutdowns because transaction reservation checking
> > has not yet been added, the cancellation path is overkill, etc. IOW, th=
e
> > purpose of this patch is purely to test a concept.
>=20
> *nod*
>=20
> > The concept is essentially to flag a log item for relogging on first
> > transaction commit such that once it commits to the AIL, the next
> > transaction that happens to commit with sufficient unused reservation
> > opportunistically relogs the item to the current CIL context. For the
> > log intent case, the transaction that commits the done item is required
> > to cancel the relog state of the original intent to prevent further
> > relogging.
>=20
> Makes sense, but it seems like we removed the hook that would be
> used by transactions to implement their own relogging on CIL commit
> some time ago because nothign had used it for 15+ years....
>=20

Interesting, I'm not familiar with this...

> > In practice, this allows a log item to automatically roll through CIL
> > checkpoints and not pin the tail of the log while something like a
> > quotaoff is running for a potentially long period of time. This is
> > applied to quotaoff and focused testing shows that it avoids the
> > associated deadlock.
>=20
> Hmmm. How do we deal with multiple identical intents being found in
> checkpoints with different LSNs in log recovery?
>=20

Good question. I was kind of thinking they would be handled like
normally relogged items, but I hadn't got to recovery testing yet. For
quotaoff, no special handling is required because we simply turn off
quota flags (i.e. no filesystem changes are required) when the intent is
seen and don't do anything else with the log item. FWIW, we don't even
seem to check for an associated quotaoff_end item.

For something more involved like an EFI, it looks like we'd create a
duplicate log item for the intent and I suspect that would lead to a
double processing attempt. So this would require some further changes to
handle generic intent relogging properly. I don't think it's that
difficult of a problem; we do already allow for relogs of other things
obviously, we just don't currently do any tracking of already seen
intents. That said, this could probably be considered an ABI change if
older kernels don't know how to process the condition correctly, so we'd
have to guard against that with a feature bit or some such when a
filesystem isn't unmounted cleanly.

More broadly, this implies that we don't ever currently relog intents so
this is something that will come along with any implementation that
intends to do so unless we adopt an alternative along the lines of what
dfops processing does. Dfops completes the original intent and creates a
new one on each internal transaction roll. My early thought was that
would be overkill for relogs that are more intended to facilitate
unrelated progress (i.e. not pin the log tail) as opposed to track
progress in a particular operation (i.e. dfops freed 1 extent out of a 2
extent EFI, roll, complete the original EFI and create a new EFI with 1
extent left). The item never really changes in the first case where it
does in the second.

> > Thoughts, reviews, flames appreciated.
> >=20
> > [1] https://lore.kernel.org/linux-xfs/20191018143856.GA25763@bfoster/
> >=20
> >  fs/xfs/xfs_log_cil.c     | 69 ++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_log_priv.h    |  6 ++++
> >  fs/xfs/xfs_qm_syscalls.c | 13 ++++++++
> >  fs/xfs/xfs_trace.h       |  2 ++
> >  fs/xfs/xfs_trans.c       |  4 +++
> >  fs/xfs/xfs_trans.h       |  4 ++-
> >  6 files changed, 97 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index a1204424a938..b2d8b2d54df6 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -75,6 +75,33 @@ xlog_cil_iovec_space(
> >  =09=09=09sizeof(uint64_t));
> >  }
> > =20
> > +static void
> > +xlog_cil_relog_items(
> > +=09struct xlog=09=09*log,
> > +=09struct xfs_trans=09*tp)
> > +{
> > +=09struct xfs_cil=09=09*cil =3D log->l_cilp;
> > +=09struct xfs_log_item=09*lip;
> > +
> > +=09ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
> > +
> > +=09if (list_empty(&cil->xc_relog))
> > +=09=09return;
> > +
> > +=09/* XXX: need to check trans reservation, process multiple items, et=
c. */
> > +=09spin_lock(&cil->xc_relog_lock);
> > +=09lip =3D list_first_entry_or_null(&cil->xc_relog, struct xfs_log_ite=
m, li_cil);
> > +=09if (lip)
> > +=09=09list_del_init(&lip->li_cil);
> > +=09spin_unlock(&cil->xc_relog_lock);
> > +
> > +=09if (lip) {
> > +=09=09xfs_trans_add_item(tp, lip);
> > +=09=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > +=09=09trace_xfs_cil_relog(lip);
> > +=09}
>=20
> I don't think this is safe - the log item needs to be locked to be
> joined to a transaction. Hence this can race with whatever is
> committing the done intent on the object and removing it from the
> relog list and so the item could be clean (and potentially even
> freed) by the time we go to add it to this transaction and mark it
> dirty again...
>=20

This was targeted to intents for the time being, which AFAIA are
unshared structures in that there is no associated metadata object lock.
It's possible I've missed something by narrowly focusing on the quotaoff
case, however. I probably should have been more clear on that in the
commit log. For such intents, the item can't be dropped from the AIL (or
freed) until the done item commits, otherwise we'd have fs consistency
issues.

I was planning to eventually look into more generic log item relogging
if this basic experiment panned out. That would certainly be more
complicated in terms of having to transfer and manage lock/reference
state of the associated metadata objects, etc., as you point out.

> > +}
> > +
> >  /*
> >   * Allocate or pin log vector buffers for CIL insertion.
> >   *
> > @@ -1001,6 +1028,8 @@ xfs_log_commit_cil(
> >  =09struct xfs_log_item=09*lip, *next;
> >  =09xfs_lsn_t=09=09xc_commit_lsn;
> > =20
> > +=09xlog_cil_relog_items(log, tp);
>=20
> Hmmm. This means that when there are relog items on the list, all
> the transactional concurrency is going to be put onto the
> xc_relog_lock spin lock. THis is potentially a major lock contention
> point, especially if there are lots of items that need relogging.
>=20

Potentially, yes. The use cases I was considering were basically limited
to quotaoff and scrub, so I'm not sure performance is a huge concern for
now. The approach is opportunistic in general, so that also means this
could be implemented to avoid this contention without reducing the
effectiveness (once some actual reservation checking and whatnot is in
place).

> > +
> >  =09/*
> >  =09 * Do all necessary memory allocation before we lock the CIL.
> >  =09 * This ensures the allocation does not deadlock with a CIL
> > @@ -1196,6 +1225,8 @@ xlog_cil_init(
> >  =09spin_lock_init(&cil->xc_push_lock);
> >  =09init_rwsem(&cil->xc_ctx_lock);
> >  =09init_waitqueue_head(&cil->xc_commit_wait);
> > +=09INIT_LIST_HEAD(&cil->xc_relog);
> > +=09spin_lock_init(&cil->xc_relog_lock);
> > =20
> >  =09INIT_LIST_HEAD(&ctx->committing);
> >  =09INIT_LIST_HEAD(&ctx->busy_extents);
> > @@ -1223,3 +1254,41 @@ xlog_cil_destroy(
> >  =09kmem_free(log->l_cilp);
> >  }
> > =20
> > +void
> > +xfs_cil_relog_item(
> > +=09struct xlog=09=09*log,
> > +=09struct xfs_log_item=09*lip)
> > +{
> > +=09struct xfs_cil=09=09*cil =3D log->l_cilp;
> > +
> > +=09ASSERT(test_bit(XFS_LI_RELOG, &lip->li_flags));
> > +=09ASSERT(list_empty(&lip->li_cil));
>=20
> So this can't be used for things like inodes and buffers?
>=20

Not at this stage, but I think it's worth considering from a design
standpoint because I'd expect to be able to cover that case eventually.
If there are big picture issues/concerns, it's best to think about them
now. ;)

> > +=09spin_lock(&cil->xc_relog_lock);
> > +=09list_add_tail(&lip->li_cil, &cil->xc_relog);
> > +=09spin_unlock(&cil->xc_relog_lock);
> > +
> > +=09trace_xfs_cil_relog_queue(lip);
> > +}
> > +
> > +bool
> > +xfs_cil_relog_steal(
> > +=09struct xlog=09=09*log,
> > +=09struct xfs_log_item=09*lip)
> > +{
> > +=09struct xfs_cil=09=09*cil =3D log->l_cilp;
> > +=09struct xfs_log_item=09*pos, *ppos;
> > +=09bool=09=09=09ret =3D false;
> > +
> > +=09spin_lock(&cil->xc_relog_lock);
> > +=09list_for_each_entry_safe(pos, ppos, &cil->xc_relog, li_cil) {
> > +=09=09if (pos =3D=3D lip) {
> > +=09=09=09list_del_init(&pos->li_cil);
> > +=09=09=09ret =3D true;
> > +=09=09=09break;
> > +=09=09}
> > +=09}
> > +=09spin_unlock(&cil->xc_relog_lock);
>=20
> This is a remove operation, not a "steal" operation. But why are
> we walking the relog list to find it? It would be much better to use
> a flag to indicate what list the item is on, and then this just
> becomes
>=20

Er, yeah this is a mess. I was actually planning to do exactly this,
only with the dirty bit instead of a custom bit. The reason for the
current code is basically due to a combination of some bugs I had in the
code and things getting implemented out of order such that I already had
this function by the time I realized I could just use the dirty bit. I
didn't feel the need to rework it for the purpose of the POC. Of course
that depends on some of the same intent-only assumptions as discussed
above, so a relog specific bit is probably a more appropriate long term
solution.

> =09spin_lock(&cil->xc_relog_lock);
> =09if (test_and_clear_bit(XFS_LI_RELOG_LIST, &lip->li_flags))
> =09=09list_del_init(&pos->li_cil);
> =09spin_unlock(&cil->xc_relog_lock);
>=20
>=20
>=20
> > @@ -556,6 +558,16 @@ xfs_qm_log_quotaoff_end(
> >  =09=09=09=09=09flags & XFS_ALL_QUOTA_ACCT);
> >  =09xfs_trans_log_quotaoff_item(tp, qoffi);
> > =20
> > +=09/*
> > +=09 * XXX: partly open coded relog of the start item to ensure no relo=
gging
> > +=09 * after this point.
> > +=09 */
> > +=09clear_bit(XFS_LI_RELOG, &startqoff->qql_item.li_flags);
> > +=09if (xfs_cil_relog_steal(mp->m_log, &startqoff->qql_item)) {
> > +=09=09xfs_trans_add_item(tp, &startqoff->qql_item);
> > +=09=09xfs_trans_log_quotaoff_item(tp, startqoff);
> > +=09}
>=20
> Urk. :)
>=20
> > @@ -863,6 +864,9 @@ xfs_trans_committed_bulk(
> >  =09=09if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) =3D=3D 0)
> >  =09=09=09continue;
> > =20
> > +=09=09if (test_bit(XFS_LI_RELOG, &lip->li_flags))
> > +=09=09=09xfs_cil_relog_item(lip->li_mountp->m_log, lip);
>=20
> Ok, so this is moving the item from commit back onto the relog list.
> This is going to hammer the relog lock on workloads where there is a
> lot of transaction concurrency and a substantial number of items on
> the relog list....
>=20

Hmm.. so concurrency is somewhat limited on this end of things by this
being in log completion context. I suspect you are referring to the
broader concurrency between log completion and incoming transaction
commits, which I think is a fair point. I'd have to think more about
that when I got to polishing the relog processing stuff. This most
likely would require some balancing between reducing contention and
maintaining effectiveness.

> ----
>=20
> Ok, so I mentioned that we removed the hooks that could have been
> used for this some time ago.
>=20
> What we actually want here is a notification that an object needs
> relogging. I can see how appealing the concept of automatically
> relogging is, but I'm unconvinced that we can make it work,
> especially when there aren't sufficient reservations to relog
> the items that need relogging.
>=20

I'm not unconvinced it can be made to work, but I agree that more work
is required to demonstrate that. I'm open to ideas for cleaner
solutions. That's why I posted this in its current form. :)

> commit d420e5c810bce5debce0238021b410d0ef99cf08
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Oct 15 09:17:53 2013 +1100
>=20
>     xfs: remove unused transaction callback variables
>    =20
>     We don't do callbacks at transaction commit time, no do we have any
>     infrastructure to set up or run such callbacks, so remove the
>     variables and typedefs for these operations. If we ever need to add
>     callbacks, we can reintroduce the variables at that time.
>    =20
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Ben Myers <bpm@sgi.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>
>=20
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 09cf40b89e8c..71c835e9e810 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -85,18 +85,11 @@ struct xfs_item_ops {
>  #define XFS_ITEM_LOCKED                2
>  #define XFS_ITEM_FLUSHING      3
> =20
> -/*
> - * This is the type of function which can be given to xfs_trans_callback=
()
> - * to be called upon the transaction's commit to disk.
> - */
> -typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
> -
>  /*
>   * This is the structure maintained for every active transaction.
>   */
>  typedef struct xfs_trans {
>         unsigned int            t_magic;        /* magic number */
> -       xfs_log_callback_t      t_logcb;        /* log callback struct */
>         unsigned int            t_type;         /* transaction type */
>         unsigned int            t_log_res;      /* amt of log space resvd=
 */
>         unsigned int            t_log_count;    /* count for perm log res=
 */
>=20
> That's basically the functionality we want here - when the log item
> hits the journal, we want a callback to tell us so we can relog it
> ourselves if deemed necessary. i.e. it's time to reintroduce the
> transaction/log commit callback infrastructure...
>=20

As noted earlier, this old mechanism is new to me.. This commit just
appears to remove an unused hook and the surrounding commits don't look
related. Was this previously used for something in particular?

> This would get used in conjunction with a permanent transaction
> reservation, allowing the owner of the object to keep it locked over
> transaction commit (while whatever work is running between intent
> and done), and the transaction commit turns into a trans_roll. Then
> we reserve space for the next relogging commit, and go about our
> business.
>=20

Hmm.. IIUC the original intent committer rolls instead of commits to
reacquire relogging reservation, but what if the submitter needs to
allocate and commit unrelated transactions before it gets to the point
of completing the intent? I was originally thinking about "pre-reserving
and donating" relogging reservation along these lines, but I thought
reserving transactions like this (first for the intent+relog, then for
whatever random transaction is next) was a potential deadlock vector.
Perhaps it's not if the associated items have all been committed to the
log subsystem. It also seemed unnecessary given our current design of
worst case reservation sizes, but that's a separate topic and may only
apply to intents (which are small compared to metadata associated with
generic log items).

So are you suggesting ownership of the committed transaction transfers
to the log subsystem somehow or another? For example, we internally roll
and queue the _transaction_ (not the log item) for relogging while from
the caller's perspective the transaction has committed? Or the
additional reservation is pulled off and the transaction commits (i.e.
frees)? Or something else?

FWIW, I'm also wondering if this lends itself to some form of batching
for if we get to the point of relogging a large number of small items.
For example, consider a single dedicated/relogging transaction for many
small (or related) intents vs. N independent transactions processing in
the background. This is something that could came later once the
fundamentals are worked out, however.

> On notification of the intent being logged, the relogging work
> (which already has a transaction and a reservation) can be dumped to
> a workqueue (to get it out of iclog completion context) and the item
> relogged and the transaction rolled and re-reserved again.
>=20
> This would work with any type of log item, not just intents, and it
> doesn't have any reservation "stealing" requirements. ANd because
> we've pre-reserved the log space for the relogging transaction, the
> relogging callback will never get hung up on it's own items
> preventing it from getting more log space.
>=20
> i.e. we essentially make use of the existing relogging mechanism,
> just with callbacks to trigger periodic relogging of the items for
> long running transactions...
>=20
> Thoughts?
>=20

All in all this sounds interesting. I still need to grok the transaction
reservation/ownership semantics you propose re: the questions above, but
I do like the prospect of reusing existing mechanisms and thus being
able to more easily handle generic log items. Thanks for the
feedback...

Brian

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com


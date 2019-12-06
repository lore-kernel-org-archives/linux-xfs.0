Return-Path: <SRS0=r/Pz=Z4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C436AC2BD09
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 14:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 880AE24676
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 14:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcMsCSop"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfLFO5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 09:57:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbfLFO5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Dec 2019 09:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575644221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bp+opqytorzlW3XEikZ6KKAMfJjWioEbweEjIKXbumA=;
        b=VcMsCSop6JQKUCLDo1AiUFldiTmuhlk0EVHf1+1/jY/9rMCtbvrfcEufvIgTRUiXec+vmu
        4MDLeA9CuhkPEl71KjGujUJxqVIjvaUuvi+yB4uxjh0a9f7d6iRFTPDSoUE1vypkOxKlnz
        sbrtKARkWG5lJI5BS53N39qmhBXFDMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-jGGMvfqqNdSiXMbU4z_6Bw-1; Fri, 06 Dec 2019 09:57:00 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A85112A7E28;
        Fri,  6 Dec 2019 14:56:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E52C65D9E1;
        Fri,  6 Dec 2019 14:56:58 +0000 (UTC)
Date:   Fri, 6 Dec 2019 09:56:58 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v4 1/2] xfs: automatic log item relog mechanism
Message-ID: <20191206145658.GA56473@bfoster>
References: <20191205175037.52529-1-bfoster@redhat.com>
 <20191205175037.52529-2-bfoster@redhat.com>
 <20191205210211.GP2695@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191205210211.GP2695@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: jGGMvfqqNdSiXMbU4z_6Bw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 06, 2019 at 08:02:11AM +1100, Dave Chinner wrote:
> On Thu, Dec 05, 2019 at 12:50:36PM -0500, Brian Foster wrote:
> > This is an AIL based mechanism to enable automatic relogging of
> > selected log items. The use case is for particular operations that
> > commit an item known to pin the tail of the log for a potentially
> > long period of time and otherwise cannot use a rolling transaction.
> > While this does not provide the deadlock avoidance guarantees of a
> > rolling transaction, it ties the relog transaction into AIL pushing
> > pressure such that we should expect the transaction to reserve the
> > necessary log space long before deadlock becomes a problem.
> >=20
> > To enable relogging, a bit is set on the log item before it is first
> > committed to the log subsystem. Once the item commits to the on-disk
> > log and inserts to the AIL, AIL pushing dictates when the item is
> > ready for a relog. When that occurs, the item relogs in an
> > independent transaction to ensure the log tail keeps moving without
> > intervention from the original committer.  To disable relogging, the
> > original committer clears the log item bit and optionally waits on
> > relogging activity to cease if it needs to reuse the item before the
> > operation completes.
> >=20
> > While the current use case for automatic relogging is limited, the
> > mechanism is AIL based because it 1.) provides existing callbacks
> > into all possible log item types for future support and 2.) has
> > applicable context to determine when to relog particular items (such
> > as when an item pins the log tail). This provides enough flexibility
> > to support various log item types and future workloads without
> > introducing complexity up front for currently unknown use cases.
> > Further complexity, such as preallocated or regranted relog
> > transaction reservation or custom relog handlers can be considered
> > as the need arises.
>=20
> ....
>=20
> > +/*
> > + * Relog log items on the AIL relog queue.
> > + */
> > +static void
> > +xfs_ail_relog(
> > +=09struct work_struct=09*work)
> > +{
> > +=09struct xfs_ail=09=09*ailp =3D container_of(work, struct xfs_ail,
> > +=09=09=09=09=09=09     ail_relog_work);
> > +=09struct xfs_mount=09*mp =3D ailp->ail_mount;
> > +=09struct xfs_trans=09*tp;
> > +=09struct xfs_log_item=09*lip, *lipp;
> > +=09int=09=09=09error;
>=20
> Probably need PF_MEMALLOC here - this will need to make progress in
> low memory situations, just like the xfsaild.
>=20
> > +=09/* XXX: define a ->tr_relog reservation */
> > +=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, =
&tp);
> > +=09if (error)
> > +=09=09return;
>=20
> Also needs memalloc_nofs_save() around this whole function, because
> we most definitely don't want this recursing into the filesystem and
> running transactions when we are trying to ensure we don't pin the
> tail of the log...
>=20

Ok. Note that this will likely change to not allocate the transaction
here, but I'll revisit this when appropriate.

> > +
> > +=09spin_lock(&ailp->ail_lock);
> > +=09list_for_each_entry_safe(lip, lipp, &ailp->ail_relog_list, li_trans=
) {
> > +=09=09list_del_init(&lip->li_trans);
> > +=09=09xfs_trans_add_item(tp, lip);
> > +=09=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
> > +=09=09tp->t_flags |=3D XFS_TRANS_DIRTY;
> > +=09}
> > +=09spin_unlock(&ailp->ail_lock);
> > +
> > +=09error =3D xfs_trans_commit(tp);
> > +=09ASSERT(!error);
> > +}
>=20
> Simple, but I see several issues here regarding how generic this
> approach is.
>=20
> 1. Memory reclaim deadlock. Needs to be run under
> memalloc_nofs_save() context (and possibly PF_MEMALLOC) because
> transaction allocation can trigger reclaim and that can run
> filesystem transactions and can block waiting for log space. If we
> already pin the tail of the log, then we deadlock in memory
> reclaim...
>=20
> 2. Transaction reservation deadlock. If the item being relogged is
> already at the tail of the log, or if the item that pins the tail
> preventing further log reservations from finding space is in the
> relog list, we will effectively deadlock the filesystem here.
>=20

Yes, this was by design. There are a couple angles to this..

First, my testing to this point suggests that the current use case
doesn't require this level of guarantee. This deadlock can manifest in a
few seconds when combined with a parallel workload and small log. I've
been stalling the quotaoff completion for minutes under those same
conditions to this point without reproducing any sort of issues.

That said, I think there are other issues with this approach. This
hasn't been tested thoroughly yet, for one. :) I'm not sure the
practical behavior would apply to the scrub use case (more relogged
items) or non-intent items (with lock contention). Finally, I'm not sure
it's totally appropriate to lock items for relog before we acquire
reservation for the relog transaction. All in all, I'm still considering
changes in this area. It's just a matter of finding an approach that is
simple enough and isn't overkill in terms of overhead or complexity...

> 3. it's going to require a log reservation for every item on the
> relog list, in total. That cannot be known ahead of time as the
> reservation is dependent on the dirty size of the items being added
> to the transaction. Hence, if this is a generic mechanism, the
> required reservation could be quite large... If it's too large, see
> #1.
>=20

Yeah, I punted on the transaction management for this RFC because 1.)
it's independent from the mechanics of how to relog items and so not
necessary to demonstrate that concept and 2.) I can think of at least
three or four different ways to manage transaction reservation to
address this problem, with varying levels of complexity/flexibility.

See the previous RFCs for examples of what I mean. I've been thinking
about doing something similar for this variant, but a bit more simple:

- Original (i.e. quotaoff) transaction becomes a permanent transaction.
- Immediately after transaction allocation, explicitly charge the
  relogging subsystem with a certain amount of (fixed size) reservation
  and roll the transaction.
- The rolled transaction proceeds as the original would have, sets the
  relog bit on associated item(s) and commits. The relogged items are
  thus added to the log subsystem with an already charged relog system.

Note that the aforementioned relog reservation is undone in the event of
error/cancel before the final transaction commits.

On the backend/relog side of things:

- Establish a max item count for the relog transaction (probably 1 for
  now). When the max is hit, the relog worker instance rolls the
  transaction and repeats until it drains the current relog item list
  (similar to a truncate operation, for example).
- Keep a global count of the number of active relog items somewhere.
  Once this drops to zero, the relog transaction is free to be cancelled
  and the reservation returned to the grant heads.

The latter bit essentially means the first relog transaction is
responsible for charging the relog system and doing the little
transaction roll dance, while subsequent parallel users effectively
acquire a reference count on the existence of the permanent relog
transaction until there are zero active reloggable items in the
subsystem. The transaction itself probably starts out as a fixed
->tr_relog reservation defined to the maximum supported reloggable
transaction (i.e. quotaoff, for now).

ISTM this keeps things reasonably simple, doesn't introduce runtime
overhead unless relogging is active and guarantees deadlock avoidance.
Thoughts on that?

> 4. xfs_trans_commit() requires objects being logged to be locked
> against concurrent modification.  Locking in the AIL context is
> non-blocking, so the item needs to be locked against modification
> before it is added to the ail_relog_list, and won't get unlocked
> until it it committed again.
>=20

Yep..

> 5. Locking random items in random order into the ail_relog_list
> opens us up to ABBA deadlocks with locking in ongoing modifications.
>=20

This relies on locking behavior as already implemented by xfsaild. The
whole point is to tie into existing infrastructure rather than duplicate
it or introduce new access patterns. All this does is change how we
handle certain log items once they are locked. It doesn't introduce any
new locking patterns that don't already occur.

> 6. If the item is already dirty in a transaction (i.e. currently
> locked and joined to another transaction - being relogged) then then
> xfs_trans_add_item() is either going to fire asserts because
> XFS_LI_DIRTY is already set or it's going to corrupt the item list
> of that already running transaction.
>=20

As above, the item isn't processed unless it is locked or otherwise
exclusive. In a general sense, there are no new log item access patterns
here. Relogging follows the same log item access rules as the rest of
the code.

> Given this, I'm skeptical this can be made into a useful, reliable
> generic async relogging mechanism.
>=20

Fair, but that's also not the current goal. The goal is to address the
current use cases of quotaoff and scrub with consideration for similar,
basic handling of arbitrary log items in the future. It's fairly trivial
to implement relogging of a buffer or inode on top of this, for example.

If more complex use cases arise, we can build in more complexity as
needed or further genericize the mechanism, but I see no need to build
in complexity or introduce major abstractions given the current couple
of fairly quirky use cases and otherwise lack of further requirements. I
view the lack of infrastructure as an advantage so I'm intentionally
trying to keep things simple. IOW, worst case, the mechanism in this
approach is easy to repurpose because after the reservation management
bits, it's just a couple log item states, a list and a workqueue job.

The locking issues noted above strike me as a misunderstanding one way
or another (which is easy to misinterpret given the undefined use case).
Given that and with the transaction issues resolved I don't see the
remaining concerns as blockers. If you have thoughts on some future use
cases that obviously conflict or might warrant further
complexity/requirements right now, I'd be interested to hear more about
it. Otherwise I'm just kind of guessing at things in that regard; it's
hard to design a system around unknown requirements...

(I could also look into wiring up an arbitrary non-intent log item as a
canary, I suppose. That would be a final RFC patch that serves no real
purpose and wouldn't be merged, but would hook up the mechanism for
testing purposes, help prove sanity and provide some actual code to
reason about.)

> >  /*
> >   * The cursor keeps track of where our current traversal is up to by t=
racking
> >   * the next item in the list for us. However, for this to be safe, rem=
oving an
> > @@ -363,7 +395,7 @@ static long
> >  xfsaild_push(
> >  =09struct xfs_ail=09=09*ailp)
> >  {
> > -=09xfs_mount_t=09=09*mp =3D ailp->ail_mount;
> > +=09struct xfs_mount=09*mp =3D ailp->ail_mount;
> >  =09struct xfs_ail_cursor=09cur;
> >  =09struct xfs_log_item=09*lip;
> >  =09xfs_lsn_t=09=09lsn;
> > @@ -425,6 +457,13 @@ xfsaild_push(
> >  =09=09=09ailp->ail_last_pushed_lsn =3D lsn;
> >  =09=09=09break;
> > =20
> > +=09=09case XFS_ITEM_RELOG:
> > +=09=09=09trace_xfs_ail_relog(lip);
> > +=09=09=09ASSERT(list_empty(&lip->li_trans));
> > +=09=09=09list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
> > +=09=09=09set_bit(XFS_LI_RELOGGED, &lip->li_flags);
> > +=09=09=09break;
> > +
> >  =09=09case XFS_ITEM_FLUSHING:
> >  =09=09=09/*
> >  =09=09=09 * The item or its backing buffer is already being
> > @@ -491,6 +530,9 @@ xfsaild_push(
> >  =09if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
> >  =09=09ailp->ail_log_flush++;
> > =20
> > +=09if (!list_empty(&ailp->ail_relog_list))
> > +=09=09queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
> > +
>=20
> Hmmm. Nothing here appears to guarantee forwards progress of the
> relogged items? We just queue the items and move on? What if we scan
> the ail and trip over the item again before it's been processed by
> the relog worker function?
>=20

See the XFS_LI_RELOGGED bit (and specifically how it is used in the next
patch). This could be lifted up a layer if that is more clear.

> >  =09if (!count || XFS_LSN_CMP(lsn, target) >=3D 0) {
> >  out_done:
> >  =09=09/*
> > @@ -834,15 +876,24 @@ xfs_trans_ail_init(
> >  =09spin_lock_init(&ailp->ail_lock);
> >  =09INIT_LIST_HEAD(&ailp->ail_buf_list);
> >  =09init_waitqueue_head(&ailp->ail_empty);
> > +=09INIT_LIST_HEAD(&ailp->ail_relog_list);
> > +=09INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
> > +
> > +=09ailp->ail_relog_wq =3D alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE=
, 0,
> > +=09=09=09=09=09     mp->m_super->s_id);
>=20
> It'll need WQ_MEMRECLAIM so it has a rescuer thread (relogging has
> to work when we are low on memory), and possibly WQ_HIPRI so that it
> doesn't get stuck behind other workqueues that run transactions and
> run the log out of space before we try to reserve log space for the
> relogging....
>=20

Ok, I had dropped those for now because it wasn't immediately clear if
they were needed. I'll take another look at this. Thanks for the
feedback...

Brian

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20


Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAEBC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 11:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E992071F
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 11:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ic4logal"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKVL5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:57:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37617 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbfKVL5G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 06:57:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574423823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CEKsCRAUpgY1DmiQdDDli7+xE1qZNdjopw6Xxc5VyN8=;
        b=Ic4logalA2wZgSiAjl83HnSJu+Bw0vIXjZ3ffGk7eYR+pnWToHaIUz9BuTGAhuVnzA3C0c
        nw4Yx//+C9vt0a6o1943uLt4zURsGDgH3Wg5uMvypXDSKr3BDTwDoaXvm4/vl0cimYrSpF
        lQb+1DK6iNbGgZkL63HfJNylqpyxeuQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-L8KUnRIjNz6YHcK33KSkhQ-1; Fri, 22 Nov 2019 06:57:02 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59FD4184CAAA;
        Fri, 22 Nov 2019 11:57:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAA591036C8D;
        Fri, 22 Nov 2019 11:57:00 +0000 (UTC)
Date:   Fri, 22 Nov 2019 06:57:00 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: report ag header corruption errors to the
 health tracking system
Message-ID: <20191122115700.GA30710@bfoster>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556683.3692735.8136460417251028810.stgit@magnolia>
 <20191120142047.GC15542@bfoster>
 <20191120164323.GJ6219@magnolia>
 <20191121132603.GA20602@bfoster>
 <20191122005313.GB6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191122005313.GB6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: L8KUnRIjNz6YHcK33KSkhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 04:53:13PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 21, 2019 at 08:26:03AM -0500, Brian Foster wrote:
> > On Wed, Nov 20, 2019 at 08:43:23AM -0800, Darrick J. Wong wrote:
> > > On Wed, Nov 20, 2019 at 09:20:47AM -0500, Brian Foster wrote:
> > > > On Thu, Nov 14, 2019 at 10:19:26AM -0800, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > >=20
> > > > > Whenever we encounter a corrupt AG header, we should report that =
to the
> > > > > health monitoring system for later reporting.
> > > > >=20
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
> > > > >  fs/xfs/libxfs/xfs_health.h   |    6 ++++++
> > > > >  fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
> > > > >  fs/xfs/libxfs/xfs_refcount.c |    5 ++++-
> > > > >  fs/xfs/libxfs/xfs_rmap.c     |    5 ++++-
> > > > >  fs/xfs/libxfs/xfs_sb.c       |    2 ++
> > > > >  fs/xfs/xfs_health.c          |   17 +++++++++++++++++
> > > > >  fs/xfs/xfs_inode.c           |    9 +++++++++
> > > > >  8 files changed, 51 insertions(+), 2 deletions(-)
> > > > >=20
> > > > >=20
> > > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.=
c
> > > > > index c284e10af491..e75e3ae6c912 100644
> > > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > > @@ -26,6 +26,7 @@
> > > > >  #include "xfs_log.h"
> > > > >  #include "xfs_ag_resv.h"
> > > > >  #include "xfs_bmap.h"
> > > > > +#include "xfs_health.h"
> > > > > =20
> > > > >  extern kmem_zone_t=09*xfs_bmap_free_item_zone;
> > > > > =20
> > > > > @@ -699,6 +700,8 @@ xfs_alloc_read_agfl(
> > > > >  =09=09=09mp, tp, mp->m_ddev_targp,
> > > > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
> > > > >  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
> > > > > +=09if (xfs_metadata_is_sick(error))
> > > > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
> > > >=20
> > > > Any reason we couldn't do some of these in verifiers? I'm assuming =
we'd
> > > > still need calls in various external corruption checks, but at leas=
t we
> > > > wouldn't add a requirement to check all future buffer reads, etc.
> > >=20
> > > I thought about that.  It would be wonderful if C had a syntactically
> > > slick method to package a function + execution scope and pass that
> > > through other functions to be called later. :)
> > >=20
> > > For the per-AG stuff it wouldn't be hard to make the verifier functio=
ns
> > > derive the AG number and call xfs_agno_mark_sick directly in the
> > > verifier.  For per-inode metadata, we'd have to find a way to pass th=
e
> > > struct xfs_inode pointer to the verifier, which means that we'd have =
to
> > > add that to struct xfs_buf.
> > >=20
> > > xfs_buf is ~384 bytes so maybe adding another pointer for read contex=
t
> > > wouldn't be terrible?  That would add a fair amount of ugly special
> > > casing in the btree code to decide if we have an inode to pass throug=
h,
> > > though it would solve the problem of the bmbt verifier not being able=
 to
> > > check the owner field in the btree block header.
> > >=20
> > > OTOH that's 8 bytes of overhead that we can never get rid of even tho=
ugh
> > > we only really need it the first time the buffer gets read in from di=
sk.
> > >=20
> > > Thoughts?
> > >=20
> >=20
> > That doesn't seem too unreasonable, but I guess I'd have to think about
> > it some more. Maybe it's worth defining a private pointer in the buffer
> > that callers can use to pass specific context to verifiers for health
> > processing. I suppose such a field could also be conditionally defined
> > on scrub enabled kernels (at least initially), so the overhead would be
> > opt-in.
>=20
> Looking further into this, what if we could did something like the
> following:
>=20
> struct xfs_buf_verify {
> =09const struct xfs_buf_ops=09*ops;
> =09struct xfs_inode=09=09*ip;
> =09unsigned int=09=09=09sick_flags;
> =09/* whatever else */
> };
>=20
> ...then we change the _read_buf and _trans_read_buf functions to take as
> the final argument a (struct xfs_buf_verify *).  In the xfs_buf_reverify
> cases, we can pass this context straight through to the ->read_verify
> function.
>=20
> To handle the !DONE case where the buffer read completion can happen
> asynchronously, we change the b_ops field definition to:
>=20
> =09union {
> =09=09struct xfs_buf_ops=09*b_ops;
> =09=09struct xfs_buf_verify=09*b_vctx;
> =09};
>=20
> Next we define a new XBF_HAVE_VERIFY_CTX flag that means b_vctx is
> active and not ops.  xfs_buf_read_map can set the flag and b_vctx for
> any synchronous (!XBF_ASYNC) read because we know the caller will be
> asleep waiting for b_iowait and therefore cannot kill the verifier
> context structure.  Once we get to xfs_buf_ioend we can set b_ops, drop
> the XBF_H_V_C flag, and call ->verify_read.
>=20
> Now we actually /can/ pass the inode pointer into the verifier, along
> with pretty much anything else we can think of.
>=20
> Does that sound reasonable?  Or totally heinous? :)
>=20

That sounds reasonable to me and potentially a nice way to mitigate
additional overhead. I suppose we'd also need a means to abstract the
various contextual data fed into the type-specific verifiers (i.e., does
the verifier care about inode health state? perag? both?). Would you
plan to do that with higher level wrappers and/or perhaps use similar
union/flag magic in the xfs_buf_verify context to indicate which state
an instance happens to provide? It might be worth a quick and dirty RFC
to answer these questions with a couple examples and get any API
feedback before running through the full set of verifiers..

Brian

> > Anyways, I think for this series it might be reasonable to push things
> > down into verifiers opportunistically where we can do so without any
> > core mechanism changes. We can follow up with changes to do the rest if
> > we can come up with something elegant.
>=20
> Ok.  I think I will try to implement such a beast for 5.6 and then put
> this series after it.
>=20
> > > > >  =09if (error)
> > > > >  =09=09return error;
> > > > >  =09xfs_buf_set_ref(bp, XFS_AGFL_REF);
> > > > > @@ -722,6 +725,7 @@ xfs_alloc_update_counters(
> > > > >  =09if (unlikely(be32_to_cpu(agf->agf_freeblks) >
> > > > >  =09=09     be32_to_cpu(agf->agf_length))) {
> > > > >  =09=09xfs_buf_corruption_error(agbp);
> > > > > +=09=09xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
> > > > >  =09=09return -EFSCORRUPTED;
> > > > >  =09}
> > > > > =20
> > > > > @@ -2952,6 +2956,8 @@ xfs_read_agf(
> > > > >  =09=09=09mp, tp, mp->m_ddev_targp,
> > > > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> > > > >  =09=09=09XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> > > > > +=09if (xfs_metadata_is_sick(error))
> > > > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
> > > > >  =09if (error)
> > > > >  =09=09return error;
> > > > >  =09if (!*bpp)
> > > > > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_healt=
h.h
> > > > > index 3657a9cb8490..ce8954a10c66 100644
> > > > > --- a/fs/xfs/libxfs/xfs_health.h
> > > > > +++ b/fs/xfs/libxfs/xfs_health.h
> > > > > @@ -123,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp=
, unsigned int mask);
> > > > >  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int =
*sick,
> > > > >  =09=09unsigned int *checked);
> > > > > =20
> > > > > +void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agn=
o,
> > > > > +=09=09unsigned int mask);
> > > > >  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> > > > >  void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mas=
k);
> > > > >  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mas=
k);
> > > > > @@ -203,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *m=
p, struct xfs_fsop_geom *geo);
> > > > >  void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geo=
metry *ageo);
> > > > >  void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkst=
at *bs);
> > > > > =20
> > > > > +#define xfs_metadata_is_sick(error) \
> > > > > +=09(unlikely((error) =3D=3D -EFSCORRUPTED || (error) =3D=3D -EIO=
 || \
> > > > > +=09=09  (error) =3D=3D -EFSBADCRC))
> > > >=20
> > > > Why is -EIO considered sick? My understanding is that once somethin=
g is
> > > > marked sick, scrub is the only way to clear that state. -EIO can be
> > > > transient, so afaict that means we could mark a persistent in-core =
state
> > > > based on a transient/resolved issue.
> > >=20
> > > I think it sounds reasonable that if the fs hits a metadata IO error
> > > then the administrator should scrub that data structure to make sure
> > > it's ok, and if so, clear the sick state.
> > >=20
> >=20
> > I'm not totally convinced... I thought we had configurations where I/O
> > errors can be reasonably expected and recovered from. For example,
> > consider the thin provisioning + infinite metadata writeback error retr=
y
> > mechanism. IIRC, the whole purpose of that was to facilitate the use
> > case where the thin pool runs out of space, but the admin wants some
> > window of time to expand and keep the filesystem alive.
>=20
> Aha, I just realized that it's not clear from the macro definition that
> I was only intending it to be called from the read path.
>=20
> Though I guess there's always the possibility that the PFY trips over
> the PCIE cable in the datacenter and XFS hits an EIO, but the disk will
> be fine a moment later when he shoves it back in.  The disk media is
> fine, and by that point either we returned read error to userspace or
> the transaction got cancelled and it's too late to do anything anyway.
>=20
> I'll drop the EIO check for now and we'll see if I get around to
> revisiting it.
>=20
> > I don't necessarily think it's a bad thing to suggest a scrub any time
> > errors have occurred, but for something like the above where an
> > environment may have been thoroughly tested and verified through that
> > particular error->expand sequence, it seems that flagging bits as sick
> > might be unnecessarily ominous.
>=20
> <shrug> Yeah, (sick && !checked) is a weird passive-aggressive state
> like that.
>=20
> > > Though I realized just now that if scrub isn't enabled then it's an
> > > unfixable dead end so the EIO check should be gated on
> > > CONFIG_XFS_ONLINE_SCRUB=3Dy.
> > >=20
> >=20
> > Yeah, that was my initial concern..
> >=20
> > > > Along similar lines, what's the expected behavior in the event of a=
ny of
> > > > these errors for a kernel that might not support
> > > > CONFIG_XFS_ONLINE_[SCRUB|REPAIR]? Just set the states that are neve=
r
> > > > used for anything? If so, that seems Ok I suppose.. but it's a litt=
le
> > > > awkward if we'd see the tracepoints and such associated with the st=
ate
> > > > changes.
> > >=20
> > > Even if scrub is disabled, the kernel will still set the sick state, =
and
> > > later the administrator can query the filesystem with xfs_spaceman to
> > > observe that sick state.
> > >=20
> >=20
> > Ok, so it's intended to be a valid health state independent of scrub.
> > That seems reasonable in principle and can always be used to indicate
> > offline repair is necessary too.
>=20
> Yes.
>=20
> > > In the future, I will also use the per-AG sick states to steer
> > > allocations away from known problematic AGs to try to avoid
> > > unexpected shutdown in the middle of a transaction.
> > >=20
> >=20
> > Hmm.. I'm a little curious about how much we should steer away from
> > traditional behavior on kernels that might not support scrub. I suppose
> > I could see arguments for going either way, but this is getting a bit
> > ahead of this patch anyways. ;)
>=20
> Yeah.  I /do/ have prototype patches buried in my dev tree but they are
> too ugly not to let all the magic smoke out.  What really happens is
> that when we hit a corruption error, we mark the AG as offline.  Then
> the sysadmin can run xfs_scrub to fix it (which would set th AG back
> online) or I guess we could have a spaceman -x command to force it back
> online.
>=20
> I always build in /some/ kind of manual override somewhere... :)
>=20
> --D
>=20
> > Brian
> >=20
> > > --D
> > >=20
> > > >=20
> > > > Brian
> > > >=20
> > > > > +
> > > > >  #endif=09/* __XFS_HEALTH_H__ */
> > > > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_iallo=
c.c
> > > > > index 988cde7744e6..c401512a4350 100644
> > > > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > > > @@ -27,6 +27,7 @@
> > > > >  #include "xfs_trace.h"
> > > > >  #include "xfs_log.h"
> > > > >  #include "xfs_rmap.h"
> > > > > +#include "xfs_health.h"
> > > > > =20
> > > > >  /*
> > > > >   * Lookup a record by ino in the btree given by cur.
> > > > > @@ -2635,6 +2636,8 @@ xfs_read_agi(
> > > > >  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > > > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
> > > > >  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
> > > > > +=09if (xfs_metadata_is_sick(error))
> > > > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > > > >  =09if (error)
> > > > >  =09=09return error;
> > > > >  =09if (tp)
> > > > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_ref=
count.c
> > > > > index d7d702ee4d1a..25c87834e42a 100644
> > > > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > > > @@ -22,6 +22,7 @@
> > > > >  #include "xfs_bit.h"
> > > > >  #include "xfs_refcount.h"
> > > > >  #include "xfs_rmap.h"
> > > > > +#include "xfs_health.h"
> > > > > =20
> > > > >  /* Allowable refcount adjustment amounts. */
> > > > >  enum xfs_refc_adjust_op {
> > > > > @@ -1177,8 +1178,10 @@ xfs_refcount_finish_one(
> > > > >  =09=09=09=09XFS_ALLOC_FLAG_FREEING, &agbp);
> > > > >  =09=09if (error)
> > > > >  =09=09=09return error;
> > > > > -=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > > > > +=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > > > > +=09=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF)=
;
> > > > >  =09=09=09return -EFSCORRUPTED;
> > > > > +=09=09}
> > > > > =20
> > > > >  =09=09rcur =3D xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> > > > >  =09=09if (!rcur) {
> > > > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > > > index ff9412f113c4..a54a3c129cce 100644
> > > > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > > > @@ -21,6 +21,7 @@
> > > > >  #include "xfs_errortag.h"
> > > > >  #include "xfs_error.h"
> > > > >  #include "xfs_inode.h"
> > > > > +#include "xfs_health.h"
> > > > > =20
> > > > >  /*
> > > > >   * Lookup the first record less than or equal to [bno, len, owne=
r, offset]
> > > > > @@ -2400,8 +2401,10 @@ xfs_rmap_finish_one(
> > > > >  =09=09error =3D xfs_free_extent_fix_freelist(tp, agno, &agbp);
> > > > >  =09=09if (error)
> > > > >  =09=09=09return error;
> > > > > -=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > > > > +=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > > > > +=09=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF)=
;
> > > > >  =09=09=09return -EFSCORRUPTED;
> > > > > +=09=09}
> > > > > =20
> > > > >  =09=09rcur =3D xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> > > > >  =09=09if (!rcur) {
> > > > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > > > index 0ac69751fe85..4a923545465d 100644
> > > > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > > > @@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
> > > > >  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > > > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > > > >  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > > > > +=09if (xfs_metadata_is_sick(error))
> > > > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
> > > > >  =09if (error)
> > > > >  =09=09return error;
> > > > >  =09xfs_buf_set_ref(bp, XFS_SSB_REF);
> > > > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > > > index 860dc70c99e7..36c32b108b39 100644
> > > > > --- a/fs/xfs/xfs_health.c
> > > > > +++ b/fs/xfs/xfs_health.c
> > > > > @@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
> > > > >  =09spin_unlock(&mp->m_sb_lock);
> > > > >  }
> > > > > =20
> > > > > +/* Mark unhealthy per-ag metadata given a raw AG number. */
> > > > > +void
> > > > > +xfs_agno_mark_sick(
> > > > > +=09struct xfs_mount=09*mp,
> > > > > +=09xfs_agnumber_t=09=09agno,
> > > > > +=09unsigned int=09=09mask)
> > > > > +{
> > > > > +=09struct xfs_perag=09*pag =3D xfs_perag_get(mp, agno);
> > > > > +
> > > > > +=09/* per-ag structure not set up yet? */
> > > > > +=09if (!pag)
> > > > > +=09=09return;
> > > > > +
> > > > > +=09xfs_ag_mark_sick(pag, mask);
> > > > > +=09xfs_perag_put(pag);
> > > > > +}
> > > > > +
> > > > >  /* Mark unhealthy per-ag metadata. */
> > > > >  void
> > > > >  xfs_ag_mark_sick(
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index 401da197f012..a2812cea748d 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > @@ -35,6 +35,7 @@
> > > > >  #include "xfs_log.h"
> > > > >  #include "xfs_bmap_btree.h"
> > > > >  #include "xfs_reflink.h"
> > > > > +#include "xfs_health.h"
> > > > > =20
> > > > >  kmem_zone_t *xfs_inode_zone;
> > > > > =20
> > > > > @@ -787,6 +788,8 @@ xfs_ialloc(
> > > > >  =09 */
> > > > >  =09if ((pip && ino =3D=3D pip->i_ino) || !xfs_verify_dir_ino(mp,=
 ino)) {
> > > > >  =09=09xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", in=
o);
> > > > > +=09=09xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
> > > > > +=09=09=09=09XFS_SICK_AG_INOBT);
> > > > >  =09=09return -EFSCORRUPTED;
> > > > >  =09}
> > > > > =20
> > > > > @@ -2137,6 +2140,7 @@ xfs_iunlink_update_bucket(
> > > > >  =09 */
> > > > >  =09if (old_value =3D=3D new_agino) {
> > > > >  =09=09xfs_buf_corruption_error(agibp);
> > > > > +=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
> > > > >  =09=09return -EFSCORRUPTED;
> > > > >  =09}
> > > > > =20
> > > > > @@ -2203,6 +2207,7 @@ xfs_iunlink_update_inode(
> > > > >  =09if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> > > > >  =09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> > > > >  =09=09=09=09sizeof(*dip), __this_address);
> > > > > +=09=09xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> > > > >  =09=09error =3D -EFSCORRUPTED;
> > > > >  =09=09goto out;
> > > > >  =09}
> > > > > @@ -2217,6 +2222,7 @@ xfs_iunlink_update_inode(
> > > > >  =09=09if (next_agino !=3D NULLAGINO) {
> > > > >  =09=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> > > > >  =09=09=09=09=09dip, sizeof(*dip), __this_address);
> > > > > +=09=09=09xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> > > > >  =09=09=09error =3D -EFSCORRUPTED;
> > > > >  =09=09}
> > > > >  =09=09goto out;
> > > > > @@ -2271,6 +2277,7 @@ xfs_iunlink(
> > > > >  =09if (next_agino =3D=3D agino ||
> > > > >  =09    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> > > > >  =09=09xfs_buf_corruption_error(agibp);
> > > > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > > > >  =09=09return -EFSCORRUPTED;
> > > > >  =09}
> > > > > =20
> > > > > @@ -2408,6 +2415,7 @@ xfs_iunlink_map_prev(
> > > > >  =09=09=09XFS_CORRUPTION_ERROR(__func__,
> > > > >  =09=09=09=09=09XFS_ERRLEVEL_LOW, mp,
> > > > >  =09=09=09=09=09*dipp, sizeof(**dipp));
> > > > > +=09=09=09xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> > > > >  =09=09=09error =3D -EFSCORRUPTED;
> > > > >  =09=09=09return error;
> > > > >  =09=09}
> > > > > @@ -2454,6 +2462,7 @@ xfs_iunlink_remove(
> > > > >  =09if (!xfs_verify_agino(mp, agno, head_agino)) {
> > > > >  =09=09XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > > > >  =09=09=09=09agi, sizeof(*agi));
> > > > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > > > >  =09=09return -EFSCORRUPTED;
> > > > >  =09}
> > > > > =20
> > > > >=20
> > > >=20
> > >=20
> >=20
>=20


Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DCCC432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 13:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6B6120898
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 13:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhX4S1Mq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfKUN0L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 08:26:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37956 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726593AbfKUN0L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 08:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574342768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCGztwl1JgaT8vV8ZKnyLwu8SjSX3pT/1hT5YcWkqpY=;
        b=IhX4S1MqsLhXK09lV/mMJtJnqrav8traKhNHG3udw0p3FuMy1ttVb4QeJz6wEHCBQJXn8q
        tCTyMacl+8UV81BwzsNhulwigTofSBtxigIwtSsOLdmhRr9gN0vROJM9TaTLRw4/24x8NB
        jBa6KW9NhyXQDNCtgqvJzHvKctylBbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-D0Z2g1E0NpuYDP9mpNtc5w-1; Thu, 21 Nov 2019 08:26:05 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 757FD18B6409;
        Thu, 21 Nov 2019 13:26:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E12A469308;
        Thu, 21 Nov 2019 13:26:03 +0000 (UTC)
Date:   Thu, 21 Nov 2019 08:26:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: report ag header corruption errors to the
 health tracking system
Message-ID: <20191121132603.GA20602@bfoster>
References: <157375555426.3692735.1357467392517392169.stgit@magnolia>
 <157375556683.3692735.8136460417251028810.stgit@magnolia>
 <20191120142047.GC15542@bfoster>
 <20191120164323.GJ6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191120164323.GJ6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: D0Z2g1E0NpuYDP9mpNtc5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 08:43:23AM -0800, Darrick J. Wong wrote:
> On Wed, Nov 20, 2019 at 09:20:47AM -0500, Brian Foster wrote:
> > On Thu, Nov 14, 2019 at 10:19:26AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >=20
> > > Whenever we encounter a corrupt AG header, we should report that to t=
he
> > > health monitoring system for later reporting.
> > >=20
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
> > >  fs/xfs/libxfs/xfs_health.h   |    6 ++++++
> > >  fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
> > >  fs/xfs/libxfs/xfs_refcount.c |    5 ++++-
> > >  fs/xfs/libxfs/xfs_rmap.c     |    5 ++++-
> > >  fs/xfs/libxfs/xfs_sb.c       |    2 ++
> > >  fs/xfs/xfs_health.c          |   17 +++++++++++++++++
> > >  fs/xfs/xfs_inode.c           |    9 +++++++++
> > >  8 files changed, 51 insertions(+), 2 deletions(-)
> > >=20
> > >=20
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index c284e10af491..e75e3ae6c912 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -26,6 +26,7 @@
> > >  #include "xfs_log.h"
> > >  #include "xfs_ag_resv.h"
> > >  #include "xfs_bmap.h"
> > > +#include "xfs_health.h"
> > > =20
> > >  extern kmem_zone_t=09*xfs_bmap_free_item_zone;
> > > =20
> > > @@ -699,6 +700,8 @@ xfs_alloc_read_agfl(
> > >  =09=09=09mp, tp, mp->m_ddev_targp,
> > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
> > >  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
> > > +=09if (xfs_metadata_is_sick(error))
> > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
> >=20
> > Any reason we couldn't do some of these in verifiers? I'm assuming we'd
> > still need calls in various external corruption checks, but at least we
> > wouldn't add a requirement to check all future buffer reads, etc.
>=20
> I thought about that.  It would be wonderful if C had a syntactically
> slick method to package a function + execution scope and pass that
> through other functions to be called later. :)
>=20
> For the per-AG stuff it wouldn't be hard to make the verifier functions
> derive the AG number and call xfs_agno_mark_sick directly in the
> verifier.  For per-inode metadata, we'd have to find a way to pass the
> struct xfs_inode pointer to the verifier, which means that we'd have to
> add that to struct xfs_buf.
>=20
> xfs_buf is ~384 bytes so maybe adding another pointer for read context
> wouldn't be terrible?  That would add a fair amount of ugly special
> casing in the btree code to decide if we have an inode to pass through,
> though it would solve the problem of the bmbt verifier not being able to
> check the owner field in the btree block header.
>=20
> OTOH that's 8 bytes of overhead that we can never get rid of even though
> we only really need it the first time the buffer gets read in from disk.
>=20
> Thoughts?
>=20

That doesn't seem too unreasonable, but I guess I'd have to think about
it some more. Maybe it's worth defining a private pointer in the buffer
that callers can use to pass specific context to verifiers for health
processing. I suppose such a field could also be conditionally defined
on scrub enabled kernels (at least initially), so the overhead would be
opt-in.

Anyways, I think for this series it might be reasonable to push things
down into verifiers opportunistically where we can do so without any
core mechanism changes. We can follow up with changes to do the rest if
we can come up with something elegant.

> > >  =09if (error)
> > >  =09=09return error;
> > >  =09xfs_buf_set_ref(bp, XFS_AGFL_REF);
> > > @@ -722,6 +725,7 @@ xfs_alloc_update_counters(
> > >  =09if (unlikely(be32_to_cpu(agf->agf_freeblks) >
> > >  =09=09     be32_to_cpu(agf->agf_length))) {
> > >  =09=09xfs_buf_corruption_error(agbp);
> > > +=09=09xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
> > >  =09=09return -EFSCORRUPTED;
> > >  =09}
> > > =20
> > > @@ -2952,6 +2956,8 @@ xfs_read_agf(
> > >  =09=09=09mp, tp, mp->m_ddev_targp,
> > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
> > >  =09=09=09XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
> > > +=09if (xfs_metadata_is_sick(error))
> > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
> > >  =09if (error)
> > >  =09=09return error;
> > >  =09if (!*bpp)
> > > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > > index 3657a9cb8490..ce8954a10c66 100644
> > > --- a/fs/xfs/libxfs/xfs_health.h
> > > +++ b/fs/xfs/libxfs/xfs_health.h
> > > @@ -123,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, un=
signed int mask);
> > >  void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sic=
k,
> > >  =09=09unsigned int *checked);
> > > =20
> > > +void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
> > > +=09=09unsigned int mask);
> > >  void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> > >  void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
> > >  void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
> > > @@ -203,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, s=
truct xfs_fsop_geom *geo);
> > >  void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometr=
y *ageo);
> > >  void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *=
bs);
> > > =20
> > > +#define xfs_metadata_is_sick(error) \
> > > +=09(unlikely((error) =3D=3D -EFSCORRUPTED || (error) =3D=3D -EIO || =
\
> > > +=09=09  (error) =3D=3D -EFSBADCRC))
> >=20
> > Why is -EIO considered sick? My understanding is that once something is
> > marked sick, scrub is the only way to clear that state. -EIO can be
> > transient, so afaict that means we could mark a persistent in-core stat=
e
> > based on a transient/resolved issue.
>=20
> I think it sounds reasonable that if the fs hits a metadata IO error
> then the administrator should scrub that data structure to make sure
> it's ok, and if so, clear the sick state.
>=20

I'm not totally convinced... I thought we had configurations where I/O
errors can be reasonably expected and recovered from. For example,
consider the thin provisioning + infinite metadata writeback error retry
mechanism. IIRC, the whole purpose of that was to facilitate the use
case where the thin pool runs out of space, but the admin wants some
window of time to expand and keep the filesystem alive.

I don't necessarily think it's a bad thing to suggest a scrub any time
errors have occurred, but for something like the above where an
environment may have been thoroughly tested and verified through that
particular error->expand sequence, it seems that flagging bits as sick
might be unnecessarily ominous.

> Though I realized just now that if scrub isn't enabled then it's an
> unfixable dead end so the EIO check should be gated on
> CONFIG_XFS_ONLINE_SCRUB=3Dy.
>=20

Yeah, that was my initial concern..

> > Along similar lines, what's the expected behavior in the event of any o=
f
> > these errors for a kernel that might not support
> > CONFIG_XFS_ONLINE_[SCRUB|REPAIR]? Just set the states that are never
> > used for anything? If so, that seems Ok I suppose.. but it's a little
> > awkward if we'd see the tracepoints and such associated with the state
> > changes.
>=20
> Even if scrub is disabled, the kernel will still set the sick state, and
> later the administrator can query the filesystem with xfs_spaceman to
> observe that sick state.
>=20

Ok, so it's intended to be a valid health state independent of scrub.
That seems reasonable in principle and can always be used to indicate
offline repair is necessary too.

> In the future, I will also use the per-AG sick states to steer
> allocations away from known problematic AGs to try to avoid
> unexpected shutdown in the middle of a transaction.
>=20

Hmm.. I'm a little curious about how much we should steer away from
traditional behavior on kernels that might not support scrub. I suppose
I could see arguments for going either way, but this is getting a bit
ahead of this patch anyways. ;)

Brian

> --D
>=20
> >=20
> > Brian
> >=20
> > > +
> > >  #endif=09/* __XFS_HEALTH_H__ */
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > > index 988cde7744e6..c401512a4350 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > > @@ -27,6 +27,7 @@
> > >  #include "xfs_trace.h"
> > >  #include "xfs_log.h"
> > >  #include "xfs_rmap.h"
> > > +#include "xfs_health.h"
> > > =20
> > >  /*
> > >   * Lookup a record by ino in the btree given by cur.
> > > @@ -2635,6 +2636,8 @@ xfs_read_agi(
> > >  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
> > >  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
> > > +=09if (xfs_metadata_is_sick(error))
> > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > >  =09if (error)
> > >  =09=09return error;
> > >  =09if (tp)
> > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcoun=
t.c
> > > index d7d702ee4d1a..25c87834e42a 100644
> > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > @@ -22,6 +22,7 @@
> > >  #include "xfs_bit.h"
> > >  #include "xfs_refcount.h"
> > >  #include "xfs_rmap.h"
> > > +#include "xfs_health.h"
> > > =20
> > >  /* Allowable refcount adjustment amounts. */
> > >  enum xfs_refc_adjust_op {
> > > @@ -1177,8 +1178,10 @@ xfs_refcount_finish_one(
> > >  =09=09=09=09XFS_ALLOC_FLAG_FREEING, &agbp);
> > >  =09=09if (error)
> > >  =09=09=09return error;
> > > -=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > > +=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > > +=09=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
> > >  =09=09=09return -EFSCORRUPTED;
> > > +=09=09}
> > > =20
> > >  =09=09rcur =3D xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
> > >  =09=09if (!rcur) {
> > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > index ff9412f113c4..a54a3c129cce 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > @@ -21,6 +21,7 @@
> > >  #include "xfs_errortag.h"
> > >  #include "xfs_error.h"
> > >  #include "xfs_inode.h"
> > > +#include "xfs_health.h"
> > > =20
> > >  /*
> > >   * Lookup the first record less than or equal to [bno, len, owner, o=
ffset]
> > > @@ -2400,8 +2401,10 @@ xfs_rmap_finish_one(
> > >  =09=09error =3D xfs_free_extent_fix_freelist(tp, agno, &agbp);
> > >  =09=09if (error)
> > >  =09=09=09return error;
> > > -=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
> > > +=09=09if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
> > > +=09=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
> > >  =09=09=09return -EFSCORRUPTED;
> > > +=09=09}
> > > =20
> > >  =09=09rcur =3D xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> > >  =09=09if (!rcur) {
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 0ac69751fe85..4a923545465d 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
> > >  =09error =3D xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> > >  =09=09=09XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > >  =09=09=09XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > > +=09if (xfs_metadata_is_sick(error))
> > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
> > >  =09if (error)
> > >  =09=09return error;
> > >  =09xfs_buf_set_ref(bp, XFS_SSB_REF);
> > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > index 860dc70c99e7..36c32b108b39 100644
> > > --- a/fs/xfs/xfs_health.c
> > > +++ b/fs/xfs/xfs_health.c
> > > @@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
> > >  =09spin_unlock(&mp->m_sb_lock);
> > >  }
> > > =20
> > > +/* Mark unhealthy per-ag metadata given a raw AG number. */
> > > +void
> > > +xfs_agno_mark_sick(
> > > +=09struct xfs_mount=09*mp,
> > > +=09xfs_agnumber_t=09=09agno,
> > > +=09unsigned int=09=09mask)
> > > +{
> > > +=09struct xfs_perag=09*pag =3D xfs_perag_get(mp, agno);
> > > +
> > > +=09/* per-ag structure not set up yet? */
> > > +=09if (!pag)
> > > +=09=09return;
> > > +
> > > +=09xfs_ag_mark_sick(pag, mask);
> > > +=09xfs_perag_put(pag);
> > > +}
> > > +
> > >  /* Mark unhealthy per-ag metadata. */
> > >  void
> > >  xfs_ag_mark_sick(
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 401da197f012..a2812cea748d 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -35,6 +35,7 @@
> > >  #include "xfs_log.h"
> > >  #include "xfs_bmap_btree.h"
> > >  #include "xfs_reflink.h"
> > > +#include "xfs_health.h"
> > > =20
> > >  kmem_zone_t *xfs_inode_zone;
> > > =20
> > > @@ -787,6 +788,8 @@ xfs_ialloc(
> > >  =09 */
> > >  =09if ((pip && ino =3D=3D pip->i_ino) || !xfs_verify_dir_ino(mp, ino=
)) {
> > >  =09=09xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
> > > +=09=09xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
> > > +=09=09=09=09XFS_SICK_AG_INOBT);
> > >  =09=09return -EFSCORRUPTED;
> > >  =09}
> > > =20
> > > @@ -2137,6 +2140,7 @@ xfs_iunlink_update_bucket(
> > >  =09 */
> > >  =09if (old_value =3D=3D new_agino) {
> > >  =09=09xfs_buf_corruption_error(agibp);
> > > +=09=09xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
> > >  =09=09return -EFSCORRUPTED;
> > >  =09}
> > > =20
> > > @@ -2203,6 +2207,7 @@ xfs_iunlink_update_inode(
> > >  =09if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
> > >  =09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> > >  =09=09=09=09sizeof(*dip), __this_address);
> > > +=09=09xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> > >  =09=09error =3D -EFSCORRUPTED;
> > >  =09=09goto out;
> > >  =09}
> > > @@ -2217,6 +2222,7 @@ xfs_iunlink_update_inode(
> > >  =09=09if (next_agino !=3D NULLAGINO) {
> > >  =09=09=09xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> > >  =09=09=09=09=09dip, sizeof(*dip), __this_address);
> > > +=09=09=09xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
> > >  =09=09=09error =3D -EFSCORRUPTED;
> > >  =09=09}
> > >  =09=09goto out;
> > > @@ -2271,6 +2277,7 @@ xfs_iunlink(
> > >  =09if (next_agino =3D=3D agino ||
> > >  =09    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
> > >  =09=09xfs_buf_corruption_error(agibp);
> > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > >  =09=09return -EFSCORRUPTED;
> > >  =09}
> > > =20
> > > @@ -2408,6 +2415,7 @@ xfs_iunlink_map_prev(
> > >  =09=09=09XFS_CORRUPTION_ERROR(__func__,
> > >  =09=09=09=09=09XFS_ERRLEVEL_LOW, mp,
> > >  =09=09=09=09=09*dipp, sizeof(**dipp));
> > > +=09=09=09xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> > >  =09=09=09error =3D -EFSCORRUPTED;
> > >  =09=09=09return error;
> > >  =09=09}
> > > @@ -2454,6 +2462,7 @@ xfs_iunlink_remove(
> > >  =09if (!xfs_verify_agino(mp, agno, head_agino)) {
> > >  =09=09XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> > >  =09=09=09=09agi, sizeof(*agi));
> > > +=09=09xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
> > >  =09=09return -EFSCORRUPTED;
> > >  =09}
> > > =20
> > >=20
> >=20
>=20


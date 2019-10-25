Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6369CA9EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8F4021D71
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vw2hbGJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfJYOW4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:22:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729446AbfJYOWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572013370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arzSJwsyzs95WJsrBJaJlgvDKMoFZOrLtMUIk3FxCUI=;
        b=Vw2hbGJGzq30+gu4+rrhZCX/TXMyLisAexqOF0I8PhaiRe0k/Twhr1c9S+xNYnr+oEi/gD
        weIRak5R5+oY2vaL/ZnllQ9vrF67tUWU2s/6u+8sGc6d3vVWj6yqALumq+eKBoo3sstFzr
        RbQU3e5iI1ngnt3piZa0gu/VszGZx+g=
Received: from mimecast-mx01.redhat.com (209.132.183.4 [209.132.183.4])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-lM3GwRyGP7GGlpykzE46Fw-1; Fri, 25 Oct 2019 10:22:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05596800D41;
        Fri, 25 Oct 2019 14:22:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E54360BEC;
        Fri, 25 Oct 2019 14:22:29 +0000 (UTC)
Date:   Fri, 25 Oct 2019 10:22:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <20191025142227.GB11837@bfoster>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
 <157063979983.2914891.13811468205423934367.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063979983.2914891.13811468205423934367.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: lM3GwRyGP7GGlpykzE46Fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Create a new xrep_newbt structure to encapsulate a fake root for
> creating a staged btree cursor as well as to track all the blocks that
> we need to reserve in order to build that btree.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/repair.c |  260 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/xfs/scrub/repair.h |   61 +++++++++++
>  fs/xfs/scrub/trace.h  |   58 +++++++++++
>  3 files changed, 379 insertions(+)
>=20
>=20
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 588bc054db5c..beebd484c5f3 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -359,6 +359,266 @@ xrep_init_btblock(
>  =09return 0;
>  }
> =20
...
> +/* Initialize accounting resources for staging a new inode fork btree. *=
/
> +void
> +xrep_newbt_init_inode(
> +=09struct xrep_newbt=09=09*xnr,
> +=09struct xfs_scrub=09=09*sc,
> +=09int=09=09=09=09whichfork,
> +=09const struct xfs_owner_info=09*oinfo)
> +{
> +=09memset(xnr, 0, sizeof(struct xrep_newbt));
> +=09xnr->sc =3D sc;
> +=09xnr->oinfo =3D *oinfo; /* structure copy */
> +=09xnr->alloc_hint =3D XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino);
> +=09xnr->resv =3D XFS_AG_RESV_NONE;
> +=09xnr->ifake.if_fork =3D kmem_zone_zalloc(xfs_ifork_zone, 0);
> +=09xnr->ifake.if_fork_size =3D XFS_IFORK_SIZE(sc->ip, whichfork);
> +=09INIT_LIST_HEAD(&xnr->reservations);

Looks like this could reuse the above function for everything outside of
the fake root bits.

> +}
> +
> +/*
> + * Initialize accounting resources for staging a new btree.  Callers are
> + * expected to add their own reservations (and clean them up) manually.
> + */
> +void
> +xrep_newbt_init_bare(
> +=09struct xrep_newbt=09=09*xnr,
> +=09struct xfs_scrub=09=09*sc)
> +{
> +=09xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
> +=09=09=09XFS_AG_RESV_NONE);
> +}
> +
> +/* Add a space reservation manually. */
> +int
> +xrep_newbt_add_reservation(
> +=09struct xrep_newbt=09=09*xnr,
> +=09xfs_fsblock_t=09=09=09fsbno,
> +=09xfs_extlen_t=09=09=09len)
> +{

FWIW the "reservation" terminology sounds a bit funny to me. Perhaps
it's just because I've had log reservation on my mind :P, but something
that "reserves blocks" as opposed to "adds reservation" might be a bit
more clear from a naming perspective.

> +=09struct xrep_newbt_resv=09*resv;
> +
> +=09resv =3D kmem_alloc(sizeof(struct xrep_newbt_resv), KM_MAYFAIL);
> +=09if (!resv)
> +=09=09return -ENOMEM;
> +
> +=09INIT_LIST_HEAD(&resv->list);
> +=09resv->fsbno =3D fsbno;
> +=09resv->len =3D len;
> +=09resv->used =3D 0;

Is ->used purely a count or does it also serve as a pointer to the next
"unused" block?

> +=09list_add_tail(&resv->list, &xnr->reservations);
> +=09return 0;
> +}
> +
> +/* Reserve disk space for our new btree. */
> +int
> +xrep_newbt_reserve_space(
> +=09struct xrep_newbt=09*xnr,
> +=09uint64_t=09=09nr_blocks)
> +{
> +=09struct xfs_scrub=09*sc =3D xnr->sc;
> +=09xfs_alloctype_t=09=09type;
> +=09xfs_fsblock_t=09=09alloc_hint =3D xnr->alloc_hint;
> +=09int=09=09=09error =3D 0;
> +
> +=09type =3D sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
> +

So I take it this distinguishes between reconstruction of a bmapbt
where we can allocate across AGs vs an AG tree..? If so, a one liner
comment wouldn't hurt here.

> +=09while (nr_blocks > 0 && !error) {
> +=09=09struct xfs_alloc_arg=09args =3D {
> +=09=09=09.tp=09=09=3D sc->tp,
> +=09=09=09.mp=09=09=3D sc->mp,
> +=09=09=09.type=09=09=3D type,
> +=09=09=09.fsbno=09=09=3D alloc_hint,
> +=09=09=09.oinfo=09=09=3D xnr->oinfo,
> +=09=09=09.minlen=09=09=3D 1,
> +=09=09=09.maxlen=09=09=3D nr_blocks,
> +=09=09=09.prod=09=09=3D nr_blocks,

Why .prod? Is this relevant if .mod isn't set?

> +=09=09=09.resv=09=09=3D xnr->resv,
> +=09=09};
> +
> +=09=09error =3D xfs_alloc_vextent(&args);
> +=09=09if (error)
> +=09=09=09return error;
> +=09=09if (args.fsbno =3D=3D NULLFSBLOCK)
> +=09=09=09return -ENOSPC;
> +
> +=09=09trace_xrep_newbt_reserve_space(sc->mp,
> +=09=09=09=09XFS_FSB_TO_AGNO(sc->mp, args.fsbno),
> +=09=09=09=09XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
> +=09=09=09=09args.len, xnr->oinfo.oi_owner);
> +
> +=09=09error =3D xrep_newbt_add_reservation(xnr, args.fsbno, args.len);
> +=09=09if (error)
> +=09=09=09break;
> +
> +=09=09nr_blocks -=3D args.len;
> +=09=09alloc_hint =3D args.fsbno + args.len - 1;
> +
> +=09=09if (sc->ip)
> +=09=09=09error =3D xfs_trans_roll_inode(&sc->tp, sc->ip);
> +=09=09else
> +=09=09=09error =3D xrep_roll_ag_trans(sc);
> +=09}
> +
> +=09return error;
> +}
> +
> +/* Free all the accounting info and disk space we reserved for a new btr=
ee. */
> +void
> +xrep_newbt_destroy(
> +=09struct xrep_newbt=09*xnr,
> +=09int=09=09=09error)
> +{
> +=09struct xfs_scrub=09*sc =3D xnr->sc;
> +=09struct xrep_newbt_resv=09*resv, *n;
> +
> +=09if (error)
> +=09=09goto junkit;
> +
> +=09list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> +=09=09/* Free every block we didn't use. */
> +=09=09resv->fsbno +=3D resv->used;
> +=09=09resv->len -=3D resv->used;
> +=09=09resv->used =3D 0;

That answers my count/pointer question. :)

> +
> +=09=09if (resv->len > 0) {
> +=09=09=09trace_xrep_newbt_unreserve_space(sc->mp,
> +=09=09=09=09=09XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
> +=09=09=09=09=09XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
> +=09=09=09=09=09resv->len, xnr->oinfo.oi_owner);
> +
> +=09=09=09__xfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
> +=09=09=09=09=09&xnr->oinfo, true);
> +=09=09}
> +
> +=09=09list_del(&resv->list);
> +=09=09kmem_free(resv);
> +=09}
> +
> +junkit:
> +=09list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> +=09=09list_del(&resv->list);
> +=09=09kmem_free(resv);
> +=09}

Seems like this could be folded into the above loop by just checking
error and skipping the free logic appropriately.

> +
> +=09if (sc->ip) {
> +=09=09kmem_zone_free(xfs_ifork_zone, xnr->ifake.if_fork);
> +=09=09xnr->ifake.if_fork =3D NULL;
> +=09}
> +}
> +
> +/* Feed one of the reserved btree blocks to the bulk loader. */
> +int
> +xrep_newbt_alloc_block(
> +=09struct xfs_btree_cur=09*cur,
> +=09struct xrep_newbt=09*xnr,
> +=09union xfs_btree_ptr=09*ptr)
> +{
> +=09struct xrep_newbt_resv=09*resv;
> +=09xfs_fsblock_t=09=09fsb;
> +
> +=09/*
> +=09 * If last_resv doesn't have a block for us, move forward until we fi=
nd
> +=09 * one that does (or run out of reservations).
> +=09 */
> +=09if (xnr->last_resv =3D=3D NULL) {
> +=09=09list_for_each_entry(resv, &xnr->reservations, list) {
> +=09=09=09if (resv->used < resv->len) {
> +=09=09=09=09xnr->last_resv =3D resv;
> +=09=09=09=09break;
> +=09=09=09}
> +=09=09}

Not a big deal right now, but it might be worth eventually considering
something more efficient. For example, perhaps we could rotate depleted
entries to the end of the list and if we rotate and find nothing in the
next entry at the head, we know we've run out of space.

> +=09=09if (xnr->last_resv =3D=3D NULL)
> +=09=09=09return -ENOSPC;
> +=09} else if (xnr->last_resv->used =3D=3D xnr->last_resv->len) {
> +=09=09if (xnr->last_resv->list.next =3D=3D &xnr->reservations)
> +=09=09=09return -ENOSPC;
> +=09=09xnr->last_resv =3D list_entry(xnr->last_resv->list.next,
> +=09=09=09=09struct xrep_newbt_resv, list);
> +=09}
> +
> +=09/* Nab the block. */
> +=09fsb =3D xnr->last_resv->fsbno + xnr->last_resv->used;
> +=09xnr->last_resv->used++;
> +
> +=09trace_xrep_newbt_alloc_block(cur->bc_mp,
> +=09=09=09XFS_FSB_TO_AGNO(cur->bc_mp, fsb),
> +=09=09=09XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
> +=09=09=09xnr->oinfo.oi_owner);
> +
> +=09if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +=09=09ptr->l =3D cpu_to_be64(fsb);
> +=09else
> +=09=09ptr->s =3D cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
> +=09return 0;
> +}
> +
...
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 479cfe38065e..ab6c1199ecc0 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
...
> @@ -59,6 +63,63 @@ int xrep_agf(struct xfs_scrub *sc);
>  int xrep_agfl(struct xfs_scrub *sc);
>  int xrep_agi(struct xfs_scrub *sc);
> =20
...
> +
> +#define for_each_xrep_newbt_reservation(xnr, resv, n)=09\
> +=09list_for_each_entry_safe((resv), (n), &(xnr)->reservations, list)

This is unused (and seems unnecessary for a simple list).

...
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 3362bae28b46..deb177abf652 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -904,6 +904,64 @@ TRACE_EVENT(xrep_ialloc_insert,
>  =09=09  __entry->freemask)
>  )
> =20
...
> +#define DEFINE_NEWBT_EXTENT_EVENT(name) \
> +DEFINE_EVENT(xrep_newbt_extent_class, name, \
> +=09TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
> +=09=09 xfs_agblock_t agbno, xfs_extlen_t len, \
> +=09=09 int64_t owner), \
> +=09TP_ARGS(mp, agno, agbno, len, owner))
> +DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_reserve_space);
> +DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_unreserve_space);
> +
> +TRACE_EVENT(xrep_newbt_alloc_block,
> +=09TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> +=09=09 xfs_agblock_t agbno, int64_t owner),

This could be folded into the above class if we just passed 1 for the
length, eh?

Brian

> +=09TP_ARGS(mp, agno, agbno, owner),
> +=09TP_STRUCT__entry(
> +=09=09__field(dev_t, dev)
> +=09=09__field(xfs_agnumber_t, agno)
> +=09=09__field(xfs_agblock_t, agbno)
> +=09=09__field(int64_t, owner)
> +=09),
> +=09TP_fast_assign(
> +=09=09__entry->dev =3D mp->m_super->s_dev;
> +=09=09__entry->agno =3D agno;
> +=09=09__entry->agbno =3D agbno;
> +=09=09__entry->owner =3D owner;
> +=09),
> +=09TP_printk("dev %d:%d agno %u agbno %u owner %lld",
> +=09=09  MAJOR(__entry->dev), MINOR(__entry->dev),
> +=09=09  __entry->agno,
> +=09=09  __entry->agbno,
> +=09=09  __entry->owner)
> +);
> +
>  #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
> =20
>  #endif /* _TRACE_XFS_SCRUB_TRACE_H */
>=20


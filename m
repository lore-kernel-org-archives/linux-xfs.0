Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227A7CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D872E20684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 14:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="htiy9X93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394393AbfJYOYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 10:24:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60107 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393877AbfJYOYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 10:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572013449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckELSZiSP057e7eliYIxdW3Tic9WPAetXG9Y3dvycz8=;
        b=htiy9X93+tuVdGFhGb8t6jVsHPPqETBvOs9EgRmj694+mCONtbzdGgGY29giP0fxa5//x8
        D52mScayl8E6lktvFJw7fOK4QoJ2z5vDDZRTX4cXqMxJoCi/OtG3zp+yhpAwidZFIhEt8A
        P+3fHB+H8GWUTDctAoT5WF863xrMMuk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-ZPGnS-m3MNW6YIFp6EM-Yg-1; Fri, 25 Oct 2019 10:24:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735BC107AD31;
        Fri, 25 Oct 2019 14:24:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E64A60A97;
        Fri, 25 Oct 2019 14:24:03 +0000 (UTC)
Date:   Fri, 25 Oct 2019 10:24:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <20191025142401.GC11837@bfoster>
References: <157063978750.2914891.14339604572380248276.stgit@magnolia>
 <157063980635.2914891.10711621853635545427.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063980635.2914891.10711621853635545427.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: ZPGnS-m3MNW6YIFp6EM-Yg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:50:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> We need to log EFIs for every extent that we allocate for the purpose of
> staging a new btree so that if we fail then the blocks will be freed
> during log recovery.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Ok, so now I'm getting to the stuff we discussed earlier around pinning
the log tail and whatnot. I have no issue with getting this in as is in
the meantime, so long as we eventually account for those kind of issues
before we consider this non-experimental.

>  fs/xfs/scrub/repair.c     |   37 +++++++++++++++++++++++++++++++++++--
>  fs/xfs/scrub/repair.h     |    4 +++-
>  fs/xfs/xfs_extfree_item.c |    2 --
>  3 files changed, 38 insertions(+), 5 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index beebd484c5f3..49cea124148b 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -25,6 +25,8 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_quota.h"
>  #include "xfs_bmap.h"
> +#include "xfs_defer.h"
> +#include "xfs_extfree_item.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> @@ -412,7 +414,8 @@ int
>  xrep_newbt_add_reservation(
>  =09struct xrep_newbt=09=09*xnr,
>  =09xfs_fsblock_t=09=09=09fsbno,
> -=09xfs_extlen_t=09=09=09len)
> +=09xfs_extlen_t=09=09=09len,
> +=09void=09=09=09=09*priv)
>  {
>  =09struct xrep_newbt_resv=09*resv;
> =20
> @@ -424,6 +427,7 @@ xrep_newbt_add_reservation(
>  =09resv->fsbno =3D fsbno;
>  =09resv->len =3D len;
>  =09resv->used =3D 0;
> +=09resv->priv =3D priv;
>  =09list_add_tail(&resv->list, &xnr->reservations);
>  =09return 0;
>  }
> @@ -434,6 +438,7 @@ xrep_newbt_reserve_space(
>  =09struct xrep_newbt=09*xnr,
>  =09uint64_t=09=09nr_blocks)
>  {
> +=09const struct xfs_defer_op_type *efi_type =3D &xfs_extent_free_defer_t=
ype;

Heh. I feel like we should be able to do something a little cleaner
here, but I'm not sure what off the top of my head. Maybe a helper to
look up a generic "intent type" in the defer_op_types table and somewhat
abstract away the dfops-specific nature of the current interfaces..?
Maybe we should consider renaming xfs_defer_op_type to something more
generic too (xfs_intent_type ?). (This could all be a separate patch
btw.)

>  =09struct xfs_scrub=09*sc =3D xnr->sc;
>  =09xfs_alloctype_t=09=09type;
>  =09xfs_fsblock_t=09=09alloc_hint =3D xnr->alloc_hint;

Also variable names look misaligned with the above (here and in the
destroy function below).

> @@ -442,6 +447,7 @@ xrep_newbt_reserve_space(
>  =09type =3D sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
> =20
>  =09while (nr_blocks > 0 && !error) {
> +=09=09struct xfs_extent_free_item=09efi_item;
>  =09=09struct xfs_alloc_arg=09args =3D {
>  =09=09=09.tp=09=09=3D sc->tp,
>  =09=09=09.mp=09=09=3D sc->mp,
> @@ -453,6 +459,7 @@ xrep_newbt_reserve_space(
>  =09=09=09.prod=09=09=3D nr_blocks,
>  =09=09=09.resv=09=09=3D xnr->resv,
>  =09=09};
> +=09=09void=09=09=09*efi;
> =20
>  =09=09error =3D xfs_alloc_vextent(&args);
>  =09=09if (error)
> @@ -465,7 +472,20 @@ xrep_newbt_reserve_space(
>  =09=09=09=09XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
>  =09=09=09=09args.len, xnr->oinfo.oi_owner);
> =20
> -=09=09error =3D xrep_newbt_add_reservation(xnr, args.fsbno, args.len);
> +=09=09/*
> +=09=09 * Log a deferred free item for each extent we allocate so that
> +=09=09 * we can get all of the space back if we crash before we can
> +=09=09 * commit the new btree.
> +=09=09 */
> +=09=09efi_item.xefi_startblock =3D args.fsbno;
> +=09=09efi_item.xefi_blockcount =3D args.len;
> +=09=09efi_item.xefi_oinfo =3D xnr->oinfo;
> +=09=09efi_item.xefi_skip_discard =3D true;
> +=09=09efi =3D efi_type->create_intent(sc->tp, 1);
> +=09=09efi_type->log_item(sc->tp, efi, &efi_item.xefi_list);
> +
> +=09=09error =3D xrep_newbt_add_reservation(xnr, args.fsbno, args.len,
> +=09=09=09=09efi);
>  =09=09if (error)
>  =09=09=09break;
> =20
> @@ -487,6 +507,7 @@ xrep_newbt_destroy(
>  =09struct xrep_newbt=09*xnr,
>  =09int=09=09=09error)
>  {
> +=09const struct xfs_defer_op_type *efi_type =3D &xfs_extent_free_defer_t=
ype;
>  =09struct xfs_scrub=09*sc =3D xnr->sc;
>  =09struct xrep_newbt_resv=09*resv, *n;
> =20
> @@ -494,6 +515,17 @@ xrep_newbt_destroy(
>  =09=09goto junkit;
> =20
>  =09list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> +=09=09struct xfs_efd_log_item *efd;
> +
> +=09=09/*
> +=09=09 * Log a deferred free done for each extent we allocated now
> +=09=09 * that we've linked the block into the filesystem.  We cheat
> +=09=09 * since we know that log recovery has never looked at the
> +=09=09 * extents attached to an EFD.
> +=09=09 */
> +=09=09efd =3D efi_type->create_done(sc->tp, resv->priv, 0);
> +=09=09set_bit(XFS_LI_DIRTY, &efd->efd_item.li_flags);
> +

So here we've presumably succeeded so we drop the intent and actually
free any blocks that we didn't happen to use.

>  =09=09/* Free every block we didn't use. */
>  =09=09resv->fsbno +=3D resv->used;
>  =09=09resv->len -=3D resv->used;
> @@ -515,6 +547,7 @@ xrep_newbt_destroy(
> =20
>  junkit:
>  =09list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
> +=09=09efi_type->abort_intent(resv->priv);

And in this case we've failed so we abort the intent.. but what actually
happens to the blocks we might have allocated? Do we need to free those
somewhere or is that also handled by the above path somehow?

Brian

>  =09=09list_del(&resv->list);
>  =09=09kmem_free(resv);
>  =09}
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index ab6c1199ecc0..cb86281de28b 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -67,6 +67,8 @@ struct xrep_newbt_resv {
>  =09/* Link to list of extents that we've reserved. */
>  =09struct list_head=09list;
> =20
> +=09void=09=09=09*priv;
> +
>  =09/* FSB of the block we reserved. */
>  =09xfs_fsblock_t=09=09fsbno;
> =20
> @@ -112,7 +114,7 @@ void xrep_newbt_init_ag(struct xrep_newbt *xba, struc=
t xfs_scrub *sc,
>  void xrep_newbt_init_inode(struct xrep_newbt *xba, struct xfs_scrub *sc,
>  =09=09int whichfork, const struct xfs_owner_info *oinfo);
>  int xrep_newbt_add_reservation(struct xrep_newbt *xba, xfs_fsblock_t fsb=
no,
> -=09=09xfs_extlen_t len);
> +=09=09xfs_extlen_t len, void *priv);
>  int xrep_newbt_reserve_space(struct xrep_newbt *xba, uint64_t nr_blocks)=
;
>  void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
>  int xrep_newbt_alloc_block(struct xfs_btree_cur *cur, struct xrep_newbt =
*xba,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index e44efc41a041..1e49936afbfb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -328,8 +328,6 @@ xfs_trans_get_efd(
>  {
>  =09struct xfs_efd_log_item=09=09*efdp;
> =20
> -=09ASSERT(nextents > 0);
> -
>  =09if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
>  =09=09efdp =3D kmem_zalloc(sizeof(struct xfs_efd_log_item) +
>  =09=09=09=09(nextents - 1) * sizeof(struct xfs_extent),
>=20


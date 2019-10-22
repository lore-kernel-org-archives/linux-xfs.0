Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD7CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 13:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA83C21783
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 13:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxFgGZKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732073AbfJVNf0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 09:35:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731981AbfJVNf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 09:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571751324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ZtaW+HKnie9dwaaQ6SpKXMiotszTeiqu0LuTk2b/IM=;
        b=OxFgGZKpTjqD0KhA384RzZVP2+T6b+HePgzRJjCh6uVpHU5zwtFgnZ3+hI2k0v21wWc1pG
        92/VhFWdD53XpSRZX9Us7xUw2P5n2E4+HFCHXoSimUrU8TjrvefOI7KJZm1QWt0eSu2dxo
        FxM1WY8UxaZK8VBgpnrDkuUIB0iqkb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-BiKGN4_EM1GTIeGtqZbyhA-1; Tue, 22 Oct 2019 09:35:21 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF77F80183E;
        Tue, 22 Oct 2019 13:35:20 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8980910027AD;
        Tue, 22 Oct 2019 13:35:20 +0000 (UTC)
Date:   Tue, 22 Oct 2019 09:35:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove the for_each_xbitmap_ helpers
Message-ID: <20191022133518.GB51627@bfoster>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
 <157063976280.2913318.2140616655357544513.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063976280.2913318.2140616655357544513.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: BiKGN4_EM1GTIeGtqZbyhA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Remove the for_each_xbitmap_ macros in favor of proper iterator
> functions.  We'll soon be switching this data structure over to an
> interval tree implementation, which means that we can't allow callers to
> modify the bitmap during iteration without telling us.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/agheader_repair.c |   73 ++++++++++++++++++++++++----------=
------
>  fs/xfs/scrub/bitmap.c          |   59 ++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/bitmap.h          |   22 ++++++++----
>  fs/xfs/scrub/repair.c          |   60 +++++++++++++++++----------------
>  4 files changed, 148 insertions(+), 66 deletions(-)
>=20
>=20
...
> diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> index 900646b72de1..27fde5b4a753 100644
> --- a/fs/xfs/scrub/bitmap.h
> +++ b/fs/xfs/scrub/bitmap.h
...
> @@ -34,4 +27,19 @@ int xbitmap_set_btblocks(struct xbitmap *bitmap,
>  =09=09struct xfs_btree_cur *cur);
>  uint64_t xbitmap_hweight(struct xbitmap *bitmap);
> =20
> +/*
> + * Return codes for the bitmap iterator functions are 0 to continue iter=
ating,
> + * and non-zero to stop iterating.  Any non-zero value will be passed up=
 to the
> + * iteration caller.  The special value -ECANCELED can be used to stop
> + * iteration, because neither bitmap iterator ever generates that error =
code on
> + * its own.
> + */
> +typedef int (*xbitmap_walk_run_fn)(uint64_t start, uint64_t len, void *p=
riv);
> +int xbitmap_iter_set(struct xbitmap *bitmap, xbitmap_walk_run_fn fn,
> +=09=09void *priv);
> +
> +typedef int (*xbitmap_walk_bit_fn)(uint64_t bit, void *priv);
> +int xbitmap_iter_set_bits(struct xbitmap *bitmap, xbitmap_walk_bit_fn fn=
,
> +=09=09void *priv);
> +

Somewhat of a nit, but I read "set" as a verb in the above function
names which tends to confuse me over what these functions do (i.e.
iterate bits, not set bits). Could we call them something a bit more
neutral, like xbitmap[_bit]_iter() perhaps? That aside the rest of the
patch looks Ok to me.

Brian

>  #endif=09/* __XFS_SCRUB_BITMAP_H__ */
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index d41da4c44f10..588bc054db5c 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -507,15 +507,21 @@ xrep_reap_invalidate_block(
>  =09xfs_trans_binval(sc->tp, bp);
>  }
> =20
> +struct xrep_reap_block {
> +=09struct xfs_scrub=09=09*sc;
> +=09const struct xfs_owner_info=09*oinfo;
> +=09enum xfs_ag_resv_type=09=09resv;
> +=09unsigned int=09=09=09deferred;
> +};
> +
>  /* Dispose of a single block. */
>  STATIC int
>  xrep_reap_block(
> -=09struct xfs_scrub=09=09*sc,
> -=09xfs_fsblock_t=09=09=09fsbno,
> -=09const struct xfs_owner_info=09*oinfo,
> -=09enum xfs_ag_resv_type=09=09resv,
> -=09unsigned int=09=09=09*deferred)
> +=09uint64_t=09=09=09fsbno,
> +=09void=09=09=09=09*priv)
>  {
> +=09struct xrep_reap_block=09=09*rb =3D priv;
> +=09struct xfs_scrub=09=09*sc =3D rb->sc;
>  =09struct xfs_btree_cur=09=09*cur;
>  =09struct xfs_buf=09=09=09*agf_bp =3D NULL;
>  =09xfs_agnumber_t=09=09=09agno;
> @@ -527,6 +533,10 @@ xrep_reap_block(
>  =09agno =3D XFS_FSB_TO_AGNO(sc->mp, fsbno);
>  =09agbno =3D XFS_FSB_TO_AGBNO(sc->mp, fsbno);
> =20
> +=09ASSERT(sc->ip !=3D NULL || agno =3D=3D sc->sa.agno);
> +
> +=09trace_xrep_dispose_btree_extent(sc->mp, agno, agbno, 1);
> +
>  =09/*
>  =09 * If we are repairing per-inode metadata, we need to read in the AGF
>  =09 * buffer.  Otherwise, we're repairing a per-AG structure, so reuse
> @@ -544,7 +554,8 @@ xrep_reap_block(
>  =09cur =3D xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
> =20
>  =09/* Can we find any other rmappings? */
> -=09error =3D xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rm=
ap);
> +=09error =3D xfs_rmap_has_other_keys(cur, agbno, 1, rb->oinfo,
> +=09=09=09&has_other_rmap);
>  =09xfs_btree_del_cursor(cur, error);
>  =09if (error)
>  =09=09goto out_free;
> @@ -563,8 +574,9 @@ xrep_reap_block(
>  =09 * to run xfs_repair.
>  =09 */
>  =09if (has_other_rmap) {
> -=09=09error =3D xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
> -=09} else if (resv =3D=3D XFS_AG_RESV_AGFL) {
> +=09=09error =3D xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1,
> +=09=09=09=09rb->oinfo);
> +=09} else if (rb->resv =3D=3D XFS_AG_RESV_AGFL) {
>  =09=09xrep_reap_invalidate_block(sc, fsbno);
>  =09=09error =3D xrep_put_freelist(sc, agbno);
>  =09} else {
> @@ -576,16 +588,16 @@ xrep_reap_block(
>  =09=09 * reservation.
>  =09=09 */
>  =09=09xrep_reap_invalidate_block(sc, fsbno);
> -=09=09__xfs_bmap_add_free(sc->tp, fsbno, 1, oinfo, true);
> -=09=09(*deferred)++;
> -=09=09need_roll =3D *deferred > 100;
> +=09=09__xfs_bmap_add_free(sc->tp, fsbno, 1, rb->oinfo, true);
> +=09=09rb->deferred++;
> +=09=09need_roll =3D rb->deferred > 100;
>  =09}
>  =09if (agf_bp !=3D sc->sa.agf_bp)
>  =09=09xfs_trans_brelse(sc->tp, agf_bp);
>  =09if (error || !need_roll)
>  =09=09return error;
> =20
> -=09*deferred =3D 0;
> +=09rb->deferred =3D 0;
>  =09if (sc->ip)
>  =09=09return xfs_trans_roll_inode(&sc->tp, sc->ip);
>  =09return xrep_roll_ag_trans(sc);
> @@ -604,27 +616,17 @@ xrep_reap_extents(
>  =09const struct xfs_owner_info=09*oinfo,
>  =09enum xfs_ag_resv_type=09=09type)
>  {
> -=09struct xbitmap_range=09=09*bmr;
> -=09struct xbitmap_range=09=09*n;
> -=09xfs_fsblock_t=09=09=09fsbno;
> -=09unsigned int=09=09=09deferred =3D 0;
> +=09struct xrep_reap_block=09=09rb =3D {
> +=09=09.sc=09=09=09=3D sc,
> +=09=09.oinfo=09=09=09=3D oinfo,
> +=09=09.resv=09=09=09=3D type,
> +=09};
>  =09int=09=09=09=09error =3D 0;
> =20
>  =09ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
> =20
> -=09for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
> -=09=09ASSERT(sc->ip !=3D NULL ||
> -=09=09       XFS_FSB_TO_AGNO(sc->mp, fsbno) =3D=3D sc->sa.agno);
> -=09=09trace_xrep_dispose_btree_extent(sc->mp,
> -=09=09=09=09XFS_FSB_TO_AGNO(sc->mp, fsbno),
> -=09=09=09=09XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
> -
> -=09=09error =3D xrep_reap_block(sc, fsbno, oinfo, type, &deferred);
> -=09=09if (error)
> -=09=09=09break;
> -=09}
> -
> -=09if (error || deferred =3D=3D 0)
> +=09error =3D xbitmap_iter_set_bits(bitmap, xrep_reap_block, &rb);
> +=09if (error || rb.deferred =3D=3D 0)
>  =09=09return error;
> =20
>  =09if (sc->ip)
>=20


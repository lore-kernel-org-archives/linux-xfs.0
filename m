Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE08ECA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 14:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F2D2084B
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 14:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgM6gioY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfJUOew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 10:34:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726289AbfJUOew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 10:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571668490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uxQo4ves/thIdfSbGPO13TlfIXXSXnGkBg1+phmgFJ8=;
        b=RgM6gioYnBbXD6C6YC2IimTQAw1eT62PnertCx/DK6v6o0xiCNmI5Ws8wcYfxyciskEdgs
        6PCfW72zyLlYMAJ7DunBPb7YiETcX7JaZJj/HHJMMrbwABFS18Frnt1xyqF5n1b8yB/Zz+
        L/qdG/p2+1L6o/dMvQeqj2FZhnOy9IM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105--S9IA9aROGmHBjIQ9vvHDQ-1; Mon, 21 Oct 2019 10:34:48 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E64D107AD31;
        Mon, 21 Oct 2019 14:34:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C665F1001DE0;
        Mon, 21 Oct 2019 14:34:46 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:34:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: rename xfs_bitmap to xbitmap
Message-ID: <20191021143445.GC26105@bfoster>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
 <157063974228.2913318.15618537137940666793.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063974228.2913318.15618537137940666793.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: -S9IA9aROGmHBjIQ9vvHDQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Shorten the name of xfs_bitmap to xbitmap since the scrub bitmap has
> nothing to do with the libxfs bitmap.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader_repair.c |   42 ++++++++++++-----------
>  fs/xfs/scrub/bitmap.c          |   72 ++++++++++++++++++++--------------=
------
>  fs/xfs/scrub/bitmap.h          |   22 ++++++------
>  fs/xfs/scrub/repair.c          |    8 ++--
>  fs/xfs/scrub/repair.h          |    4 +-
>  5 files changed, 74 insertions(+), 74 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repai=
r.c
> index 8fcd43040c96..9fbb6035f4e2 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -429,10 +429,10 @@ xrep_agf(
> =20
>  struct xrep_agfl {
>  =09/* Bitmap of other OWN_AG metadata blocks. */
> -=09struct xfs_bitmap=09agmetablocks;
> +=09struct xbitmap=09=09agmetablocks;
> =20
>  =09/* Bitmap of free space. */
> -=09struct xfs_bitmap=09*freesp;
> +=09struct xbitmap=09=09*freesp;
> =20
>  =09struct xfs_scrub=09*sc;
>  };
> @@ -455,12 +455,12 @@ xrep_agfl_walk_rmap(
>  =09if (rec->rm_owner =3D=3D XFS_RMAP_OWN_AG) {
>  =09=09fsb =3D XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
>  =09=09=09=09rec->rm_startblock);
> -=09=09error =3D xfs_bitmap_set(ra->freesp, fsb, rec->rm_blockcount);
> +=09=09error =3D xbitmap_set(ra->freesp, fsb, rec->rm_blockcount);
>  =09=09if (error)
>  =09=09=09return error;
>  =09}
> =20
> -=09return xfs_bitmap_set_btcur_path(&ra->agmetablocks, cur);
> +=09return xbitmap_set_btcur_path(&ra->agmetablocks, cur);
>  }
> =20
>  /*
> @@ -476,19 +476,19 @@ STATIC int
>  xrep_agfl_collect_blocks(
>  =09struct xfs_scrub=09*sc,
>  =09struct xfs_buf=09=09*agf_bp,
> -=09struct xfs_bitmap=09*agfl_extents,
> +=09struct xbitmap=09=09*agfl_extents,
>  =09xfs_agblock_t=09=09*flcount)
>  {
>  =09struct xrep_agfl=09ra;
>  =09struct xfs_mount=09*mp =3D sc->mp;
>  =09struct xfs_btree_cur=09*cur;
> -=09struct xfs_bitmap_range=09*br;
> -=09struct xfs_bitmap_range=09*n;
> +=09struct xbitmap_range=09*br;
> +=09struct xbitmap_range=09*n;
>  =09int=09=09=09error;
> =20
>  =09ra.sc =3D sc;
>  =09ra.freesp =3D agfl_extents;
> -=09xfs_bitmap_init(&ra.agmetablocks);
> +=09xbitmap_init(&ra.agmetablocks);
> =20
>  =09/* Find all space used by the free space btrees & rmapbt. */
>  =09cur =3D xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> @@ -500,7 +500,7 @@ xrep_agfl_collect_blocks(
>  =09/* Find all blocks currently being used by the bnobt. */
>  =09cur =3D xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
>  =09=09=09XFS_BTNUM_BNO);
> -=09error =3D xfs_bitmap_set_btblocks(&ra.agmetablocks, cur);
> +=09error =3D xbitmap_set_btblocks(&ra.agmetablocks, cur);
>  =09if (error)
>  =09=09goto err;
>  =09xfs_btree_del_cursor(cur, error);
> @@ -508,7 +508,7 @@ xrep_agfl_collect_blocks(
>  =09/* Find all blocks currently being used by the cntbt. */
>  =09cur =3D xfs_allocbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno,
>  =09=09=09XFS_BTNUM_CNT);
> -=09error =3D xfs_bitmap_set_btblocks(&ra.agmetablocks, cur);
> +=09error =3D xbitmap_set_btblocks(&ra.agmetablocks, cur);
>  =09if (error)
>  =09=09goto err;
> =20
> @@ -518,8 +518,8 @@ xrep_agfl_collect_blocks(
>  =09 * Drop the freesp meta blocks that are in use by btrees.
>  =09 * The remaining blocks /should/ be AGFL blocks.
>  =09 */
> -=09error =3D xfs_bitmap_disunion(agfl_extents, &ra.agmetablocks);
> -=09xfs_bitmap_destroy(&ra.agmetablocks);
> +=09error =3D xbitmap_disunion(agfl_extents, &ra.agmetablocks);
> +=09xbitmap_destroy(&ra.agmetablocks);
>  =09if (error)
>  =09=09return error;
> =20
> @@ -528,7 +528,7 @@ xrep_agfl_collect_blocks(
>  =09 * the AGFL we'll free them later.
>  =09 */
>  =09*flcount =3D 0;
> -=09for_each_xfs_bitmap_extent(br, n, agfl_extents) {
> +=09for_each_xbitmap_extent(br, n, agfl_extents) {
>  =09=09*flcount +=3D br->len;
>  =09=09if (*flcount > xfs_agfl_size(mp))
>  =09=09=09break;
> @@ -538,7 +538,7 @@ xrep_agfl_collect_blocks(
>  =09return 0;
> =20
>  err:
> -=09xfs_bitmap_destroy(&ra.agmetablocks);
> +=09xbitmap_destroy(&ra.agmetablocks);
>  =09xfs_btree_del_cursor(cur, error);
>  =09return error;
>  }
> @@ -573,13 +573,13 @@ STATIC void
>  xrep_agfl_init_header(
>  =09struct xfs_scrub=09*sc,
>  =09struct xfs_buf=09=09*agfl_bp,
> -=09struct xfs_bitmap=09*agfl_extents,
> +=09struct xbitmap=09=09*agfl_extents,
>  =09xfs_agblock_t=09=09flcount)
>  {
>  =09struct xfs_mount=09*mp =3D sc->mp;
>  =09__be32=09=09=09*agfl_bno;
> -=09struct xfs_bitmap_range=09*br;
> -=09struct xfs_bitmap_range=09*n;
> +=09struct xbitmap_range=09*br;
> +=09struct xbitmap_range=09*n;
>  =09struct xfs_agfl=09=09*agfl;
>  =09xfs_agblock_t=09=09agbno;
>  =09unsigned int=09=09fl_off;
> @@ -603,7 +603,7 @@ xrep_agfl_init_header(
>  =09 */
>  =09fl_off =3D 0;
>  =09agfl_bno =3D XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
> -=09for_each_xfs_bitmap_extent(br, n, agfl_extents) {
> +=09for_each_xbitmap_extent(br, n, agfl_extents) {
>  =09=09agbno =3D XFS_FSB_TO_AGBNO(mp, br->start);
> =20
>  =09=09trace_xrep_agfl_insert(mp, sc->sa.agno, agbno, br->len);
> @@ -637,7 +637,7 @@ int
>  xrep_agfl(
>  =09struct xfs_scrub=09*sc)
>  {
> -=09struct xfs_bitmap=09agfl_extents;
> +=09struct xbitmap=09=09agfl_extents;
>  =09struct xfs_mount=09*mp =3D sc->mp;
>  =09struct xfs_buf=09=09*agf_bp;
>  =09struct xfs_buf=09=09*agfl_bp;
> @@ -649,7 +649,7 @@ xrep_agfl(
>  =09=09return -EOPNOTSUPP;
> =20
>  =09xchk_perag_get(sc->mp, &sc->sa);
> -=09xfs_bitmap_init(&agfl_extents);
> +=09xbitmap_init(&agfl_extents);
> =20
>  =09/*
>  =09 * Read the AGF so that we can query the rmapbt.  We hope that there'=
s
> @@ -701,7 +701,7 @@ xrep_agfl(
>  =09error =3D xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
>  =09=09=09XFS_AG_RESV_AGFL);
>  err:
> -=09xfs_bitmap_destroy(&agfl_extents);
> +=09xbitmap_destroy(&agfl_extents);
>  =09return error;
>  }
> =20
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 3d47d111be5a..5b07b46c89c9 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -18,14 +18,14 @@
>   * This is the logical equivalent of bitmap |=3D mask(start, len).
>   */
>  int
> -xfs_bitmap_set(
> -=09struct xfs_bitmap=09*bitmap,
> +xbitmap_set(
> +=09struct xbitmap=09=09*bitmap,
>  =09uint64_t=09=09start,
>  =09uint64_t=09=09len)
>  {
> -=09struct xfs_bitmap_range=09*bmr;
> +=09struct xbitmap_range=09*bmr;
> =20
> -=09bmr =3D kmem_alloc(sizeof(struct xfs_bitmap_range), KM_MAYFAIL);
> +=09bmr =3D kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
>  =09if (!bmr)
>  =09=09return -ENOMEM;
> =20
> @@ -39,13 +39,13 @@ xfs_bitmap_set(
> =20
>  /* Free everything related to this bitmap. */
>  void
> -xfs_bitmap_destroy(
> -=09struct xfs_bitmap=09*bitmap)
> +xbitmap_destroy(
> +=09struct xbitmap=09=09*bitmap)
>  {
> -=09struct xfs_bitmap_range=09*bmr;
> -=09struct xfs_bitmap_range=09*n;
> +=09struct xbitmap_range=09*bmr;
> +=09struct xbitmap_range=09*n;
> =20
> -=09for_each_xfs_bitmap_extent(bmr, n, bitmap) {
> +=09for_each_xbitmap_extent(bmr, n, bitmap) {
>  =09=09list_del(&bmr->list);
>  =09=09kmem_free(bmr);
>  =09}
> @@ -53,24 +53,24 @@ xfs_bitmap_destroy(
> =20
>  /* Set up a per-AG block bitmap. */
>  void
> -xfs_bitmap_init(
> -=09struct xfs_bitmap=09*bitmap)
> +xbitmap_init(
> +=09struct xbitmap=09=09*bitmap)
>  {
>  =09INIT_LIST_HEAD(&bitmap->list);
>  }
> =20
>  /* Compare two btree extents. */
>  static int
> -xfs_bitmap_range_cmp(
> +xbitmap_range_cmp(
>  =09void=09=09=09*priv,
>  =09struct list_head=09*a,
>  =09struct list_head=09*b)
>  {
> -=09struct xfs_bitmap_range=09*ap;
> -=09struct xfs_bitmap_range=09*bp;
> +=09struct xbitmap_range=09*ap;
> +=09struct xbitmap_range=09*bp;
> =20
> -=09ap =3D container_of(a, struct xfs_bitmap_range, list);
> -=09bp =3D container_of(b, struct xfs_bitmap_range, list);
> +=09ap =3D container_of(a, struct xbitmap_range, list);
> +=09bp =3D container_of(b, struct xbitmap_range, list);
> =20
>  =09if (ap->start > bp->start)
>  =09=09return 1;
> @@ -96,14 +96,14 @@ xfs_bitmap_range_cmp(
>  #define LEFT_ALIGNED=09(1 << 0)
>  #define RIGHT_ALIGNED=09(1 << 1)
>  int
> -xfs_bitmap_disunion(
> -=09struct xfs_bitmap=09*bitmap,
> -=09struct xfs_bitmap=09*sub)
> +xbitmap_disunion(
> +=09struct xbitmap=09=09*bitmap,
> +=09struct xbitmap=09=09*sub)
>  {
>  =09struct list_head=09*lp;
> -=09struct xfs_bitmap_range=09*br;
> -=09struct xfs_bitmap_range=09*new_br;
> -=09struct xfs_bitmap_range=09*sub_br;
> +=09struct xbitmap_range=09*br;
> +=09struct xbitmap_range=09*new_br;
> +=09struct xbitmap_range=09*sub_br;
>  =09uint64_t=09=09sub_start;
>  =09uint64_t=09=09sub_len;
>  =09int=09=09=09state;
> @@ -113,8 +113,8 @@ xfs_bitmap_disunion(
>  =09=09return 0;
>  =09ASSERT(!list_empty(&sub->list));
> =20
> -=09list_sort(NULL, &bitmap->list, xfs_bitmap_range_cmp);
> -=09list_sort(NULL, &sub->list, xfs_bitmap_range_cmp);
> +=09list_sort(NULL, &bitmap->list, xbitmap_range_cmp);
> +=09list_sort(NULL, &sub->list, xbitmap_range_cmp);
> =20
>  =09/*
>  =09 * Now that we've sorted both lists, we iterate bitmap once, rolling
> @@ -124,11 +124,11 @@ xfs_bitmap_disunion(
>  =09 * list traversal is similar to merge sort, but we're deleting
>  =09 * instead.  In this manner we avoid O(n^2) operations.
>  =09 */
> -=09sub_br =3D list_first_entry(&sub->list, struct xfs_bitmap_range,
> +=09sub_br =3D list_first_entry(&sub->list, struct xbitmap_range,
>  =09=09=09list);
>  =09lp =3D bitmap->list.next;
>  =09while (lp !=3D &bitmap->list) {
> -=09=09br =3D list_entry(lp, struct xfs_bitmap_range, list);
> +=09=09br =3D list_entry(lp, struct xbitmap_range, list);
> =20
>  =09=09/*
>  =09=09 * Advance sub_br and/or br until we find a pair that
> @@ -181,7 +181,7 @@ xfs_bitmap_disunion(
>  =09=09=09 * Deleting from the middle: add the new right extent
>  =09=09=09 * and then shrink the left extent.
>  =09=09=09 */
> -=09=09=09new_br =3D kmem_alloc(sizeof(struct xfs_bitmap_range),
> +=09=09=09new_br =3D kmem_alloc(sizeof(struct xbitmap_range),
>  =09=09=09=09=09KM_MAYFAIL);
>  =09=09=09if (!new_br) {
>  =09=09=09=09error =3D -ENOMEM;
> @@ -247,8 +247,8 @@ xfs_bitmap_disunion(
>   * blocks going from the leaf towards the root.
>   */
>  int
> -xfs_bitmap_set_btcur_path(
> -=09struct xfs_bitmap=09*bitmap,
> +xbitmap_set_btcur_path(
> +=09struct xbitmap=09=09*bitmap,
>  =09struct xfs_btree_cur=09*cur)
>  {
>  =09struct xfs_buf=09=09*bp;
> @@ -261,7 +261,7 @@ xfs_bitmap_set_btcur_path(
>  =09=09if (!bp)
>  =09=09=09continue;
>  =09=09fsb =3D XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> -=09=09error =3D xfs_bitmap_set(bitmap, fsb, 1);
> +=09=09error =3D xbitmap_set(bitmap, fsb, 1);
>  =09=09if (error)
>  =09=09=09return error;
>  =09}
> @@ -271,12 +271,12 @@ xfs_bitmap_set_btcur_path(
> =20
>  /* Collect a btree's block in the bitmap. */
>  STATIC int
> -xfs_bitmap_collect_btblock(
> +xbitmap_collect_btblock(
>  =09struct xfs_btree_cur=09*cur,
>  =09int=09=09=09level,
>  =09void=09=09=09*priv)
>  {
> -=09struct xfs_bitmap=09*bitmap =3D priv;
> +=09struct xbitmap=09=09*bitmap =3D priv;
>  =09struct xfs_buf=09=09*bp;
>  =09xfs_fsblock_t=09=09fsbno;
> =20
> @@ -285,14 +285,14 @@ xfs_bitmap_collect_btblock(
>  =09=09return 0;
> =20
>  =09fsbno =3D XFS_DADDR_TO_FSB(cur->bc_mp, bp->b_bn);
> -=09return xfs_bitmap_set(bitmap, fsbno, 1);
> +=09return xbitmap_set(bitmap, fsbno, 1);
>  }
> =20
>  /* Walk the btree and mark the bitmap wherever a btree block is found. *=
/
>  int
> -xfs_bitmap_set_btblocks(
> -=09struct xfs_bitmap=09*bitmap,
> +xbitmap_set_btblocks(
> +=09struct xbitmap=09=09*bitmap,
>  =09struct xfs_btree_cur=09*cur)
>  {
> -=09return xfs_btree_visit_blocks(cur, xfs_bitmap_collect_btblock, bitmap=
);
> +=09return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock, bitmap);
>  }
> diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> index ae8ecbce6fa6..8db4017ac78e 100644
> --- a/fs/xfs/scrub/bitmap.h
> +++ b/fs/xfs/scrub/bitmap.h
> @@ -6,31 +6,31 @@
>  #ifndef __XFS_SCRUB_BITMAP_H__
>  #define __XFS_SCRUB_BITMAP_H__
> =20
> -struct xfs_bitmap_range {
> +struct xbitmap_range {
>  =09struct list_head=09list;
>  =09uint64_t=09=09start;
>  =09uint64_t=09=09len;
>  };
> =20
> -struct xfs_bitmap {
> +struct xbitmap {
>  =09struct list_head=09list;
>  };
> =20
> -void xfs_bitmap_init(struct xfs_bitmap *bitmap);
> -void xfs_bitmap_destroy(struct xfs_bitmap *bitmap);
> +void xbitmap_init(struct xbitmap *bitmap);
> +void xbitmap_destroy(struct xbitmap *bitmap);
> =20
> -#define for_each_xfs_bitmap_extent(bex, n, bitmap) \
> +#define for_each_xbitmap_extent(bex, n, bitmap) \
>  =09list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
> =20
> -#define for_each_xfs_bitmap_block(b, bex, n, bitmap) \
> +#define for_each_xbitmap_block(b, bex, n, bitmap) \
>  =09list_for_each_entry_safe((bex), (n), &(bitmap)->list, list) \
> -=09=09for ((b) =3D bex->start; (b) < bex->start + bex->len; (b)++)
> +=09=09for ((b) =3D (bex)->start; (b) < (bex)->start + (bex)->len; (b)++)
> =20
> -int xfs_bitmap_set(struct xfs_bitmap *bitmap, uint64_t start, uint64_t l=
en);
> -int xfs_bitmap_disunion(struct xfs_bitmap *bitmap, struct xfs_bitmap *su=
b);
> -int xfs_bitmap_set_btcur_path(struct xfs_bitmap *bitmap,
> +int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
> +int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
> +int xbitmap_set_btcur_path(struct xbitmap *bitmap,
>  =09=09struct xfs_btree_cur *cur);
> -int xfs_bitmap_set_btblocks(struct xfs_bitmap *bitmap,
> +int xbitmap_set_btblocks(struct xbitmap *bitmap,
>  =09=09struct xfs_btree_cur *cur);
> =20
>  #endif=09/* __XFS_SCRUB_BITMAP_H__ */
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 8349694f985d..d41da4c44f10 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -600,19 +600,19 @@ xrep_reap_block(
>  int
>  xrep_reap_extents(
>  =09struct xfs_scrub=09=09*sc,
> -=09struct xfs_bitmap=09=09*bitmap,
> +=09struct xbitmap=09=09=09*bitmap,
>  =09const struct xfs_owner_info=09*oinfo,
>  =09enum xfs_ag_resv_type=09=09type)
>  {
> -=09struct xfs_bitmap_range=09=09*bmr;
> -=09struct xfs_bitmap_range=09=09*n;
> +=09struct xbitmap_range=09=09*bmr;
> +=09struct xbitmap_range=09=09*n;
>  =09xfs_fsblock_t=09=09=09fsbno;
>  =09unsigned int=09=09=09deferred =3D 0;
>  =09int=09=09=09=09error =3D 0;
> =20
>  =09ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
> =20
> -=09for_each_xfs_bitmap_block(fsbno, bmr, n, bitmap) {
> +=09for_each_xbitmap_block(fsbno, bmr, n, bitmap) {
>  =09=09ASSERT(sc->ip !=3D NULL ||
>  =09=09       XFS_FSB_TO_AGNO(sc->mp, fsbno) =3D=3D sc->sa.agno);
>  =09=09trace_xrep_dispose_btree_extent(sc->mp,
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index eab41928990f..479cfe38065e 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -28,10 +28,10 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblo=
ck_t fsb,
>  =09=09struct xfs_buf **bpp, xfs_btnum_t btnum,
>  =09=09const struct xfs_buf_ops *ops);
> =20
> -struct xfs_bitmap;
> +struct xbitmap;
> =20
>  int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
> -int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
> +int xrep_reap_extents(struct xfs_scrub *sc, struct xbitmap *exlist,
>  =09=09const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
> =20
>  struct xrep_find_ag_btree {
>=20


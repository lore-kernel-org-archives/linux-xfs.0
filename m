Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC1ACA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 13:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39E202064B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 13:38:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KLvXrWfz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfJVNiz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 09:38:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731981AbfJVNiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 09:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571751533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HGRsmkwUER9ug92xsEM8RA29I0LOU5B/0GAX/PrOi3w=;
        b=KLvXrWfz0uXZrbT7hlQXrMe/BlUkq4DmT2BKyTLVu0kxvSjgcfJzyLN4zbhYKyBSUNzTat
        GD+8uqoYae1Dry0NB9836sBhV0KtHG3x4/ybi8yyhHJFEWV07TFWNX9j1EUbhiXfAjIdpH
        hs8By0WYImejq2+6ESZq/lIWTgCtmKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-D4dylCr0OFOXxTtvLHtAYA-1; Tue, 22 Oct 2019 09:38:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9780E5ED;
        Tue, 22 Oct 2019 13:38:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 300FB60619;
        Tue, 22 Oct 2019 13:38:49 +0000 (UTC)
Date:   Tue, 22 Oct 2019 09:38:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: convert xbitmap to interval tree
Message-ID: <20191022133847.GC51627@bfoster>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
 <157063977028.2913318.2884583474654943260.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063977028.2913318.2884583474654943260.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: D4dylCr0OFOXxTtvLHtAYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Convert the xbitmap code to use interval trees instead of linked lists.
> This reduces the amount of coding required to handle the disunion
> operation and in the future will make it easier to set bits in arbitrary
> order yet later be able to extract maximally sized extents, which we'll
> need for rebuilding certain structures.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks mostly straightforward provided my lack of knowledge on interval
trees. A few random comments..

>  fs/xfs/Kconfig                 |    1=20
>  fs/xfs/scrub/agheader_repair.c |    4 -
>  fs/xfs/scrub/bitmap.c          |  292 +++++++++++++++++-----------------=
------
>  fs/xfs/scrub/bitmap.h          |   13 +-
>  4 files changed, 135 insertions(+), 175 deletions(-)
>=20
>=20
...
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 1041f17f6bb6..e1da103bce78 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -12,30 +12,105 @@
>  #include "xfs_btree.h"
>  #include "scrub/bitmap.h"
> =20
> -#define for_each_xbitmap_extent(bex, n, bitmap) \
> -=09list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
> +#define for_each_xbitmap_extent(itn, n, bitmap) \
> +=09rbtree_postorder_for_each_entry_safe((itn), (n), \
> +=09=09=09&(bitmap)->root.rb_root, rb)
> =20

I'm not familiar with the interval tree, but the header for this rbtree_
macro mentions it is unsafe with respect to rbtree_erase(). Is that a
concern for any of the users that might call interval_tree_remove()? It
looks like that calls down into rb_erase_augmented(), but it's not clear
to me if that's a problem..

> -/*
> - * Set a range of this bitmap.  Caller must ensure the range is not set.
> - *
> - * This is the logical equivalent of bitmap |=3D mask(start, len).
> - */
> +/* Clear a range of this bitmap. */
> +static void
> +__xbitmap_clear(
> +=09struct xbitmap=09=09=09*bitmap,
> +=09uint64_t=09=09=09start,
> +=09uint64_t=09=09=09last)
> +{
> +=09struct interval_tree_node=09*itn;
> +
> +=09while ((itn =3D interval_tree_iter_first(&bitmap->root, start, last))=
) {
> +=09=09if (itn->start < start) {
> +=09=09=09/* overlaps with the left side of the clearing range */
> +=09=09=09interval_tree_remove(itn, &bitmap->root);
> +=09=09=09itn->last =3D start - 1;
> +=09=09=09interval_tree_insert(itn, &bitmap->root);
> +=09=09} else if (itn->last > last) {
> +=09=09=09/* overlaps with the right side of the clearing range */
> +=09=09=09interval_tree_remove(itn, &bitmap->root);
> +=09=09=09itn->start =3D last + 1;
> +=09=09=09interval_tree_insert(itn, &bitmap->root);
> +=09=09=09break;
> +=09=09} else {
> +=09=09=09/* in the middle of the clearing range */
> +=09=09=09interval_tree_remove(itn, &bitmap->root);
> +=09=09=09kmem_free(itn);
> +=09=09}
> +=09}
> +}
> +
> +/* Clear a range of this bitmap. */
> +void
> +xbitmap_clear(
> +=09struct xbitmap=09=09=09*bitmap,
> +=09uint64_t=09=09=09start,
> +=09uint64_t=09=09=09len)
> +{
> +=09__xbitmap_clear(bitmap, start, start + len - 1);
> +}

It seems unnecessary to split the functions like this just to preserve
the interface. Could we have the other __xbitmap_clear() caller just
calculate the len itself and call xbitmap_clear() instead?

> +
> +/* Set a range of this bitmap. */
>  int
>  xbitmap_set(
> -=09struct xbitmap=09=09*bitmap,
> -=09uint64_t=09=09start,
> -=09uint64_t=09=09len)
> +=09struct xbitmap=09=09=09*bitmap,
> +=09uint64_t=09=09=09start,
> +=09uint64_t=09=09=09len)
>  {
> -=09struct xbitmap_range=09*bmr;
> +=09struct interval_tree_node=09*left;
> +=09struct interval_tree_node=09*right;
> +=09uint64_t=09=09=09last =3D start + len - 1;
> =20
> -=09bmr =3D kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
> -=09if (!bmr)
> -=09=09return -ENOMEM;
> +=09/* Is this whole range already set? */
> +=09left =3D interval_tree_iter_first(&bitmap->root, start, last);
> +=09if (left && left->start <=3D start && left->last >=3D last)
> +=09=09return 0;
> =20
> -=09INIT_LIST_HEAD(&bmr->list);
> -=09bmr->start =3D start;
> -=09bmr->len =3D len;
> -=09list_add_tail(&bmr->list, &bitmap->list);
> +=09/* Clear out everything in the range we want to set. */
> +=09xbitmap_clear(bitmap, start, len);
> +
> +=09/* Do we have a left-adjacent extent? */
> +=09left =3D interval_tree_iter_first(&bitmap->root, start - 1, start - 1=
);
> +=09if (left && left->last + 1 !=3D start)
> +=09=09left =3D NULL;
> +
> +=09/* Do we have a right-adjacent extent? */
> +=09right =3D interval_tree_iter_first(&bitmap->root, last + 1, last + 1)=
;
> +=09if (right && right->start !=3D last + 1)
> +=09=09right =3D NULL;

If we just cleared the range to set above, shouldn't these left/right
checks always return an adjacent extent or NULL? It seems harmless,
FWIW, but I'm curious if the logic is necessary.

Brian

> +
> +=09if (left && right) {
> +=09=09/* combine left and right adjacent extent */
> +=09=09interval_tree_remove(left, &bitmap->root);
> +=09=09interval_tree_remove(right, &bitmap->root);
> +=09=09left->last =3D right->last;
> +=09=09interval_tree_insert(left, &bitmap->root);
> +=09=09kmem_free(right);
> +=09} else if (left) {
> +=09=09/* combine with left extent */
> +=09=09interval_tree_remove(left, &bitmap->root);
> +=09=09left->last =3D last;
> +=09=09interval_tree_insert(left, &bitmap->root);
> +=09} else if (right) {
> +=09=09/* combine with right extent */
> +=09=09interval_tree_remove(right, &bitmap->root);
> +=09=09right->start =3D start;
> +=09=09interval_tree_insert(right, &bitmap->root);
> +=09} else {
> +=09=09/* add an extent */
> +=09=09left =3D kmem_alloc(sizeof(struct interval_tree_node),
> +=09=09=09=09KM_MAYFAIL);
> +=09=09if (!left)
> +=09=09=09return -ENOMEM;
> +=09=09left->start =3D start;
> +=09=09left->last =3D last;
> +=09=09interval_tree_insert(left, &bitmap->root);
> +=09}
> =20
>  =09return 0;
>  }
> @@ -43,14 +118,13 @@ xbitmap_set(
>  /* Free everything related to this bitmap. */
>  void
>  xbitmap_destroy(
> -=09struct xbitmap=09=09*bitmap)
> +=09struct xbitmap=09=09=09*bitmap)
>  {
> -=09struct xbitmap_range=09*bmr;
> -=09struct xbitmap_range=09*n;
> +=09struct interval_tree_node=09*itn, *p;
> =20
> -=09for_each_xbitmap_extent(bmr, n, bitmap) {
> -=09=09list_del(&bmr->list);
> -=09=09kmem_free(bmr);
> +=09for_each_xbitmap_extent(itn, p, bitmap) {
> +=09=09interval_tree_remove(itn, &bitmap->root);
> +=09=09kfree(itn);
>  =09}
>  }
> =20
> @@ -59,27 +133,7 @@ void
>  xbitmap_init(
>  =09struct xbitmap=09=09*bitmap)
>  {
> -=09INIT_LIST_HEAD(&bitmap->list);
> -}
> -
> -/* Compare two btree extents. */
> -static int
> -xbitmap_range_cmp(
> -=09void=09=09=09*priv,
> -=09struct list_head=09*a,
> -=09struct list_head=09*b)
> -{
> -=09struct xbitmap_range=09*ap;
> -=09struct xbitmap_range=09*bp;
> -
> -=09ap =3D container_of(a, struct xbitmap_range, list);
> -=09bp =3D container_of(b, struct xbitmap_range, list);
> -
> -=09if (ap->start > bp->start)
> -=09=09return 1;
> -=09if (ap->start < bp->start)
> -=09=09return -1;
> -=09return 0;
> +=09bitmap->root =3D RB_ROOT_CACHED;
>  }
> =20
>  /*
> @@ -96,118 +150,19 @@ xbitmap_range_cmp(
>   *
>   * This is the logical equivalent of bitmap &=3D ~sub.
>   */
> -#define LEFT_ALIGNED=09(1 << 0)
> -#define RIGHT_ALIGNED=09(1 << 1)
> -int
> +void
>  xbitmap_disunion(
> -=09struct xbitmap=09=09*bitmap,
> -=09struct xbitmap=09=09*sub)
> +=09struct xbitmap=09=09=09*bitmap,
> +=09struct xbitmap=09=09=09*sub)
>  {
> -=09struct list_head=09*lp;
> -=09struct xbitmap_range=09*br;
> -=09struct xbitmap_range=09*new_br;
> -=09struct xbitmap_range=09*sub_br;
> -=09uint64_t=09=09sub_start;
> -=09uint64_t=09=09sub_len;
> -=09int=09=09=09state;
> -=09int=09=09=09error =3D 0;
> -
> -=09if (list_empty(&bitmap->list) || list_empty(&sub->list))
> -=09=09return 0;
> -=09ASSERT(!list_empty(&sub->list));
> -
> -=09list_sort(NULL, &bitmap->list, xbitmap_range_cmp);
> -=09list_sort(NULL, &sub->list, xbitmap_range_cmp);
> -
> -=09/*
> -=09 * Now that we've sorted both lists, we iterate bitmap once, rolling
> -=09 * forward through sub and/or bitmap as necessary until we find an
> -=09 * overlap or reach the end of either list.  We do not reset lp to th=
e
> -=09 * head of bitmap nor do we reset sub_br to the head of sub.  The
> -=09 * list traversal is similar to merge sort, but we're deleting
> -=09 * instead.  In this manner we avoid O(n^2) operations.
> -=09 */
> -=09sub_br =3D list_first_entry(&sub->list, struct xbitmap_range,
> -=09=09=09list);
> -=09lp =3D bitmap->list.next;
> -=09while (lp !=3D &bitmap->list) {
> -=09=09br =3D list_entry(lp, struct xbitmap_range, list);
> -
> -=09=09/*
> -=09=09 * Advance sub_br and/or br until we find a pair that
> -=09=09 * intersect or we run out of extents.
> -=09=09 */
> -=09=09while (sub_br->start + sub_br->len <=3D br->start) {
> -=09=09=09if (list_is_last(&sub_br->list, &sub->list))
> -=09=09=09=09goto out;
> -=09=09=09sub_br =3D list_next_entry(sub_br, list);
> -=09=09}
> -=09=09if (sub_br->start >=3D br->start + br->len) {
> -=09=09=09lp =3D lp->next;
> -=09=09=09continue;
> -=09=09}
> +=09struct interval_tree_node=09*itn, *n;
> =20
> -=09=09/* trim sub_br to fit the extent we have */
> -=09=09sub_start =3D sub_br->start;
> -=09=09sub_len =3D sub_br->len;
> -=09=09if (sub_br->start < br->start) {
> -=09=09=09sub_len -=3D br->start - sub_br->start;
> -=09=09=09sub_start =3D br->start;
> -=09=09}
> -=09=09if (sub_len > br->len)
> -=09=09=09sub_len =3D br->len;
> -
> -=09=09state =3D 0;
> -=09=09if (sub_start =3D=3D br->start)
> -=09=09=09state |=3D LEFT_ALIGNED;
> -=09=09if (sub_start + sub_len =3D=3D br->start + br->len)
> -=09=09=09state |=3D RIGHT_ALIGNED;
> -=09=09switch (state) {
> -=09=09case LEFT_ALIGNED:
> -=09=09=09/* Coincides with only the left. */
> -=09=09=09br->start +=3D sub_len;
> -=09=09=09br->len -=3D sub_len;
> -=09=09=09break;
> -=09=09case RIGHT_ALIGNED:
> -=09=09=09/* Coincides with only the right. */
> -=09=09=09br->len -=3D sub_len;
> -=09=09=09lp =3D lp->next;
> -=09=09=09break;
> -=09=09case LEFT_ALIGNED | RIGHT_ALIGNED:
> -=09=09=09/* Total overlap, just delete ex. */
> -=09=09=09lp =3D lp->next;
> -=09=09=09list_del(&br->list);
> -=09=09=09kmem_free(br);
> -=09=09=09break;
> -=09=09case 0:
> -=09=09=09/*
> -=09=09=09 * Deleting from the middle: add the new right extent
> -=09=09=09 * and then shrink the left extent.
> -=09=09=09 */
> -=09=09=09new_br =3D kmem_alloc(sizeof(struct xbitmap_range),
> -=09=09=09=09=09KM_MAYFAIL);
> -=09=09=09if (!new_br) {
> -=09=09=09=09error =3D -ENOMEM;
> -=09=09=09=09goto out;
> -=09=09=09}
> -=09=09=09INIT_LIST_HEAD(&new_br->list);
> -=09=09=09new_br->start =3D sub_start + sub_len;
> -=09=09=09new_br->len =3D br->start + br->len - new_br->start;
> -=09=09=09list_add(&new_br->list, &br->list);
> -=09=09=09br->len =3D sub_start - br->start;
> -=09=09=09lp =3D lp->next;
> -=09=09=09break;
> -=09=09default:
> -=09=09=09ASSERT(0);
> -=09=09=09break;
> -=09=09}
> -=09}
> +=09if (xbitmap_empty(bitmap) || xbitmap_empty(sub))
> +=09=09return;
> =20
> -out:
> -=09return error;
> +=09for_each_xbitmap_extent(itn, n, sub)
> +=09=09__xbitmap_clear(bitmap, itn->start, itn->last);
>  }
> -#undef LEFT_ALIGNED
> -#undef RIGHT_ALIGNED
> =20
>  /*
>   * Record all btree blocks seen while iterating all records of a btree.
> @@ -303,14 +258,13 @@ xbitmap_set_btblocks(
>  /* How many bits are set in this bitmap? */
>  uint64_t
>  xbitmap_hweight(
> -=09struct xbitmap=09=09*bitmap)
> +=09struct xbitmap=09=09=09*bitmap)
>  {
> -=09struct xbitmap_range=09*bmr;
> -=09struct xbitmap_range=09*n;
> -=09uint64_t=09=09ret =3D 0;
> +=09struct interval_tree_node=09*itn, *n;
> +=09uint64_t=09=09=09ret =3D 0;
> =20
> -=09for_each_xbitmap_extent(bmr, n, bitmap)
> -=09=09ret +=3D bmr->len;
> +=09for_each_xbitmap_extent(itn, n, bitmap)
> +=09=09ret +=3D itn->last - itn->start + 1;
> =20
>  =09return ret;
>  }
> @@ -318,15 +272,15 @@ xbitmap_hweight(
>  /* Call a function for every run of set bits in this bitmap. */
>  int
>  xbitmap_iter_set(
> -=09struct xbitmap=09=09*bitmap,
> -=09xbitmap_walk_run_fn=09fn,
> -=09void=09=09=09*priv)
> +=09struct xbitmap=09=09=09*bitmap,
> +=09xbitmap_walk_run_fn=09=09fn,
> +=09void=09=09=09=09*priv)
>  {
> -=09struct xbitmap_range=09*bex, *n;
> -=09int=09=09=09error;
> +=09struct interval_tree_node=09*itn, *n;
> +=09int=09=09=09=09error;
> =20
> -=09for_each_xbitmap_extent(bex, n, bitmap) {
> -=09=09error =3D fn(bex->start, bex->len, priv);
> +=09for_each_xbitmap_extent(itn, n, bitmap) {
> +=09=09error =3D fn(itn->start, itn->last - itn->start + 1, priv);
>  =09=09if (error)
>  =09=09=09break;
>  =09}
> @@ -370,3 +324,11 @@ xbitmap_iter_set_bits(
> =20
>  =09return xbitmap_iter_set(bitmap, xbitmap_walk_bits_in_run, &wb);
>  }
> +
> +/* Does this bitmap have no bits set at all? */
> +bool
> +xbitmap_empty(
> +=09struct xbitmap=09=09*bitmap)
> +{
> +=09return bitmap->root.rb_root.rb_node =3D=3D NULL;
> +}
> diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> index 27fde5b4a753..6be596e60ac8 100644
> --- a/fs/xfs/scrub/bitmap.h
> +++ b/fs/xfs/scrub/bitmap.h
> @@ -6,21 +6,18 @@
>  #ifndef __XFS_SCRUB_BITMAP_H__
>  #define __XFS_SCRUB_BITMAP_H__
> =20
> -struct xbitmap_range {
> -=09struct list_head=09list;
> -=09uint64_t=09=09start;
> -=09uint64_t=09=09len;
> -};
> +#include <linux/interval_tree.h>
> =20
>  struct xbitmap {
> -=09struct list_head=09list;
> +=09struct rb_root_cached=09root;
>  };
> =20
>  void xbitmap_init(struct xbitmap *bitmap);
>  void xbitmap_destroy(struct xbitmap *bitmap);
> =20
> +void xbitmap_clear(struct xbitmap *bitmap, uint64_t start, uint64_t len)=
;
>  int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
> -int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
> +void xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
>  int xbitmap_set_btcur_path(struct xbitmap *bitmap,
>  =09=09struct xfs_btree_cur *cur);
>  int xbitmap_set_btblocks(struct xbitmap *bitmap,
> @@ -42,4 +39,6 @@ typedef int (*xbitmap_walk_bit_fn)(uint64_t bit, void *=
priv);
>  int xbitmap_iter_set_bits(struct xbitmap *bitmap, xbitmap_walk_bit_fn fn=
,
>  =09=09void *priv);
> =20
> +bool xbitmap_empty(struct xbitmap *bitmap);
> +
>  #endif=09/* __XFS_SCRUB_BITMAP_H__ */
>=20


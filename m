Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570B3C17447
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25665222D3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTHQfwrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKMOX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43806 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfKMOX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNuaejvAsY3pweHbuPpRZ0zJIDhB/9GPCWtubPEEAfo=;
        b=bTHQfwrl1vNDyOTuhb7VWXcc5TG3e5zJ9xDyMZivsooPsSwL2YQUC9SurBx6yySqpqxLc5
        hd1MXwTcFhOSH9RU7v4POGf8hr+pLrrNR0aUpdUWvhzK0Nv6Osxx9mOx7kFJ17BAkJ5ogs
        Ti1XUxzVQ67gSc5SoMpGSXUkVAxXwZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-se8IeDVTOxSdCPYshm99Yg-1; Wed, 13 Nov 2019 09:23:54 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E86AB19248A8
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:52 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C4B54D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:52 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/11] xfs: Convert kmem_alloc() users
Date:   Wed, 13 Nov 2019 15:23:32 +0100
Message-Id: <20191113142335.1045631-9-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: se8IeDVTOxSdCPYshm99Yg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kmalloc() directly.

kmem_alloc_io() and kmem_alloc_large() still have use for kmem_alloc(), due
their fallback to vmalloc() and also the alignment check. But for that, the=
re is
no need to export kmem_alloc() to the whole XFS driver, so, also convert
kmem_alloc() into a static, local function __kmem_alloc().

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c                  |  8 ++++----
 fs/xfs/kmem.h                  |  1 -
 fs/xfs/libxfs/xfs_attr_leaf.c  |  6 +++---
 fs/xfs/libxfs/xfs_bmap.c       |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  4 +++-
 fs/xfs/libxfs/xfs_defer.c      |  4 ++--
 fs/xfs/libxfs/xfs_dir2.c       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  8 ++++----
 fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
 fs/xfs/libxfs/xfs_refcount.c   |  9 +++++----
 fs/xfs/libxfs/xfs_rmap.c       |  2 +-
 fs/xfs/scrub/bitmap.c          |  7 ++++---
 fs/xfs/scrub/btree.c           |  4 ++--
 fs/xfs/scrub/refcount.c        |  4 ++--
 fs/xfs/xfs_attr_inactive.c     |  2 +-
 fs/xfs/xfs_attr_list.c         |  2 +-
 fs/xfs/xfs_buf.c               |  5 +++--
 fs/xfs/xfs_filestream.c        |  2 +-
 fs/xfs/xfs_inode.c             |  2 +-
 fs/xfs/xfs_iwalk.c             |  2 +-
 fs/xfs/xfs_log_recover.c       |  7 ++++---
 fs/xfs/xfs_qm.c                |  3 ++-
 fs/xfs/xfs_rtalloc.c           |  2 +-
 fs/xfs/xfs_super.c             |  2 +-
 25 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 6e10e565632c..79467813d810 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -8,8 +8,8 @@
 #include "xfs_message.h"
 #include "xfs_trace.h"
=20
-void *
-kmem_alloc(size_t size, xfs_km_flags_t flags)
+static void *
+__kmem_alloc(size_t size, xfs_km_flags_t flags)
 {
 =09int=09retries =3D 0;
 =09gfp_t=09lflags =3D kmem_flags_convert(flags);
@@ -72,7 +72,7 @@ kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t=
 flags)
 =09if (WARN_ON_ONCE(align_mask >=3D PAGE_SIZE))
 =09=09align_mask =3D PAGE_SIZE - 1;
=20
-=09ptr =3D kmem_alloc(size, flags | KM_MAYFAIL);
+=09ptr =3D __kmem_alloc(size, flags | KM_MAYFAIL);
 =09if (ptr) {
 =09=09if (!((uintptr_t)ptr & align_mask))
 =09=09=09return ptr;
@@ -88,7 +88,7 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
=20
 =09trace_kmem_alloc_large(size, flags, _RET_IP_);
=20
-=09ptr =3D kmem_alloc(size, flags | KM_MAYFAIL);
+=09ptr =3D __kmem_alloc(size, flags | KM_MAYFAIL);
 =09if (ptr)
 =09=09return ptr;
 =09return __kmem_vmalloc(size, flags);
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 18b62eee3177..29d02c71fb22 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -52,7 +52,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 =09return lflags;
 }
=20
-extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t fla=
gs);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 9f54e59f4004..e78cba993eae 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -885,7 +885,7 @@ xfs_attr_shortform_to_leaf(
 =09ifp =3D dp->i_afp;
 =09sf =3D (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 =09size =3D be16_to_cpu(sf->hdr.totsize);
-=09tmpbuffer =3D kmem_alloc(size, 0);
+=09tmpbuffer =3D kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
 =09ASSERT(tmpbuffer !=3D NULL);
 =09memcpy(tmpbuffer, ifp->if_u1.if_data, size);
 =09sf =3D (xfs_attr_shortform_t *)tmpbuffer;
@@ -1073,7 +1073,7 @@ xfs_attr3_leaf_to_shortform(
=20
 =09trace_xfs_attr_leaf_to_sf(args);
=20
-=09tmpbuffer =3D kmem_alloc(args->geo->blksize, 0);
+=09tmpbuffer =3D kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 =09if (!tmpbuffer)
 =09=09return -ENOMEM;
=20
@@ -1534,7 +1534,7 @@ xfs_attr3_leaf_compact(
=20
 =09trace_xfs_attr_leaf_compact(args);
=20
-=09tmpbuffer =3D kmem_alloc(args->geo->blksize, 0);
+=09tmpbuffer =3D kmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
 =09memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
 =09memset(bp->b_addr, 0, args->geo->blksize);
 =09leaf_src =3D (xfs_attr_leafblock_t *)tmpbuffer;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 37596e49b92e..fc5bed95bd44 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6045,7 +6045,7 @@ __xfs_bmap_add(
 =09=09=09bmap->br_blockcount,
 =09=09=09bmap->br_state);
=20
-=09bi =3D kmem_alloc(sizeof(struct xfs_bmap_intent), KM_NOFS);
+=09bi =3D kmalloc(sizeof(struct xfs_bmap_intent), GFP_NOFS | __GFP_NOFAIL)=
;
 =09INIT_LIST_HEAD(&bi->bi_list);
 =09bi->bi_type =3D type;
 =09bi->bi_owner =3D ip;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index dbd2434e68b5..d1211153e7d9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2152,7 +2152,9 @@ xfs_da_grow_inode_int(
 =09=09 * If we didn't get it and the block might work if fragmented,
 =09=09 * try without the CONTIG flag.  Loop until we get it all.
 =09=09 */
-=09=09mapp =3D kmem_alloc(sizeof(*mapp) * count, 0);
+=09=09mapp =3D kmalloc(sizeof(*mapp) * count,
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
+
 =09=09for (b =3D *bno, mapi =3D 0; b < *bno + count; ) {
 =09=09=09nmap =3D min(XFS_BMAP_MAX_NMAP, count);
 =09=09=09c =3D (int)(*bno + count - b);
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 22557527cfdb..24f71a59462f 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -516,8 +516,8 @@ xfs_defer_add(
 =09=09=09dfp =3D NULL;
 =09}
 =09if (!dfp) {
-=09=09dfp =3D kmem_alloc(sizeof(struct xfs_defer_pending),
-=09=09=09=09KM_NOFS);
+=09=09dfp =3D kmalloc(sizeof(struct xfs_defer_pending),
+=09=09=09      GFP_NOFS | __GFP_NOFAIL);
 =09=09dfp->dfp_type =3D type;
 =09=09dfp->dfp_intent =3D NULL;
 =09=09dfp->dfp_done =3D NULL;
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 67172e376e1d..2606d3070cba 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -331,7 +331,7 @@ xfs_dir_cilookup_result(
 =09=09=09=09=09!(args->op_flags & XFS_DA_OP_CILOOKUP))
 =09=09return -EEXIST;
=20
-=09args->value =3D kmem_alloc(len, KM_NOFS | KM_MAYFAIL);
+=09args->value =3D kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
 =09if (!args->value)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.=
c
index 358151ddfa75..c90d2d001815 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1083,7 +1083,7 @@ xfs_dir2_sf_to_block(
 =09 * Copy the directory into a temporary buffer.
 =09 * Then pitch the incore inode data so we can make extents.
 =09 */
-=09sfp =3D kmem_alloc(ifp->if_bytes, 0);
+=09sfp =3D kmalloc(ifp->if_bytes, GFP_KERNEL | __GFP_NOFAIL);
 =09memcpy(sfp, oldsfp, ifp->if_bytes);
=20
 =09xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index db1a82972d9e..bf38294ba785 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -276,7 +276,7 @@ xfs_dir2_block_to_sf(
 =09 * format the data into.  Once we have formatted the data, we can free
 =09 * the block and copy the formatted data into the inode literal area.
 =09 */
-=09sfp =3D kmem_alloc(mp->m_sb.sb_inodesize, 0);
+=09sfp =3D kmalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | __GFP_NOFAIL);
 =09memcpy(sfp, sfhp, xfs_dir2_sf_hdr_size(sfhp->i8count));
=20
 =09/*
@@ -530,7 +530,7 @@ xfs_dir2_sf_addname_hard(
 =09 */
 =09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 =09old_isize =3D (int)dp->i_d.di_size;
-=09buf =3D kmem_alloc(old_isize, 0);
+=09buf =3D kmalloc(old_isize, GFP_KERNEL | __GFP_NOFAIL);
 =09oldsfp =3D (xfs_dir2_sf_hdr_t *)buf;
 =09memcpy(oldsfp, sfp, old_isize);
 =09/*
@@ -1162,7 +1162,7 @@ xfs_dir2_sf_toino4(
 =09 * Don't want xfs_idata_realloc copying the data here.
 =09 */
 =09oldsize =3D dp->i_df.if_bytes;
-=09buf =3D kmem_alloc(oldsize, 0);
+=09buf =3D kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
 =09oldsfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 =09ASSERT(oldsfp->i8count =3D=3D 1);
 =09memcpy(buf, oldsfp, oldsize);
@@ -1235,7 +1235,7 @@ xfs_dir2_sf_toino8(
 =09 * Don't want xfs_idata_realloc copying the data here.
 =09 */
 =09oldsize =3D dp->i_df.if_bytes;
-=09buf =3D kmem_alloc(oldsize, 0);
+=09buf =3D kmalloc(oldsize, GFP_KERNEL | __GFP_NOFAIL);
 =09oldsfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 =09ASSERT(oldsfp->i8count =3D=3D 0);
 =09memcpy(buf, oldsfp, oldsize);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.=
c
index 34c336f45796..1e4c93cde07e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -153,7 +153,8 @@ xfs_init_local_fork(
=20
 =09if (size) {
 =09=09real_size =3D roundup(mem_size, 4);
-=09=09ifp->if_u1.if_data =3D kmem_alloc(real_size, KM_NOFS);
+=09=09ifp->if_u1.if_data =3D kmalloc(real_size,
+=09=09=09=09=09     GFP_NOFS | __GFP_NOFAIL);
 =09=09memcpy(ifp->if_u1.if_data, data, size);
 =09=09if (zero_terminate)
 =09=09=09ifp->if_u1.if_data[size] =3D '\0';
@@ -308,7 +309,7 @@ xfs_iformat_btree(
 =09}
=20
 =09ifp->if_broot_bytes =3D size;
-=09ifp->if_broot =3D kmem_alloc(size, KM_NOFS);
+=09ifp->if_broot =3D kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
 =09ASSERT(ifp->if_broot !=3D NULL);
 =09/*
 =09 * Copy and convert from the on-disk structure
@@ -373,7 +374,8 @@ xfs_iroot_realloc(
 =09=09 */
 =09=09if (ifp->if_broot_bytes =3D=3D 0) {
 =09=09=09new_size =3D XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
-=09=09=09ifp->if_broot =3D kmem_alloc(new_size, KM_NOFS);
+=09=09=09ifp->if_broot =3D kmalloc(new_size,
+=09=09=09=09=09=09GFP_NOFS | __GFP_NOFAIL);
 =09=09=09ifp->if_broot_bytes =3D (int)new_size;
 =09=09=09return;
 =09=09}
@@ -414,7 +416,7 @@ xfs_iroot_realloc(
 =09else
 =09=09new_size =3D 0;
 =09if (new_size > 0) {
-=09=09new_broot =3D kmem_alloc(new_size, KM_NOFS);
+=09=09new_broot =3D kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
 =09=09/*
 =09=09 * First copy over the btree block header.
 =09=09 */
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 78236bd6c64f..5b76d6bbfa58 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1188,8 +1188,8 @@ __xfs_refcount_add(
 =09=09=09type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
 =09=09=09blockcount);
=20
-=09ri =3D kmem_alloc(sizeof(struct xfs_refcount_intent),
-=09=09=09KM_NOFS);
+=09ri =3D kmalloc(sizeof(struct xfs_refcount_intent),
+=09=09     GFP_NOFS | __GFP_NOFAIL);
 =09INIT_LIST_HEAD(&ri->ri_list);
 =09ri->ri_type =3D type;
 =09ri->ri_startblock =3D startblock;
@@ -1584,7 +1584,7 @@ struct xfs_refcount_recovery {
 /* Stuff an extent on the recovery list. */
 STATIC int
 xfs_refcount_recover_extent(
-=09struct xfs_btree_cur =09=09*cur,
+=09struct xfs_btree_cur=09=09*cur,
 =09union xfs_btree_rec=09=09*rec,
 =09void=09=09=09=09*priv)
 {
@@ -1596,7 +1596,8 @@ xfs_refcount_recover_extent(
 =09=09return -EFSCORRUPTED;
 =09}
=20
-=09rr =3D kmem_alloc(sizeof(struct xfs_refcount_recovery), 0);
+=09rr =3D kmalloc(sizeof(struct xfs_refcount_recovery),
+=09=09     GFP_KERNEL | __GFP_NOFAIL);
 =09xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 =09list_add_tail(&rr->rr_list, debris);
=20
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 38e9414878b3..0e1e8cbb8862 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2286,7 +2286,7 @@ __xfs_rmap_add(
 =09=09=09bmap->br_blockcount,
 =09=09=09bmap->br_state);
=20
-=09ri =3D kmem_alloc(sizeof(struct xfs_rmap_intent), KM_NOFS);
+=09ri =3D kmalloc(sizeof(struct xfs_rmap_intent), GFP_NOFS | __GFP_NOFAIL)=
;
 =09INIT_LIST_HEAD(&ri->ri_list);
 =09ri->ri_type =3D type;
 =09ri->ri_owner =3D owner;
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 18a684e18a69..37aaab8cca7f 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -25,7 +25,8 @@ xfs_bitmap_set(
 {
 =09struct xfs_bitmap_range=09*bmr;
=20
-=09bmr =3D kmem_alloc(sizeof(struct xfs_bitmap_range), KM_MAYFAIL);
+=09bmr =3D kmalloc(sizeof(struct xfs_bitmap_range),
+=09=09      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!bmr)
 =09=09return -ENOMEM;
=20
@@ -181,8 +182,8 @@ xfs_bitmap_disunion(
 =09=09=09 * Deleting from the middle: add the new right extent
 =09=09=09 * and then shrink the left extent.
 =09=09=09 */
-=09=09=09new_br =3D kmem_alloc(sizeof(struct xfs_bitmap_range),
-=09=09=09=09=09KM_MAYFAIL);
+=09=09=09new_br =3D kmalloc(sizeof(struct xfs_bitmap_range),
+=09=09=09=09=09 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09=09=09if (!new_br) {
 =09=09=09=09error =3D -ENOMEM;
 =09=09=09=09goto out;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index f52a7b8256f9..93c2371d128b 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -429,8 +429,8 @@ xchk_btree_check_owner(
 =09 * later scanning.
 =09 */
 =09if (cur->bc_btnum =3D=3D XFS_BTNUM_BNO || cur->bc_btnum =3D=3D XFS_BTNU=
M_RMAP) {
-=09=09co =3D kmem_alloc(sizeof(struct check_owner),
-=09=09=09=09KM_MAYFAIL);
+=09=09co =3D kmalloc(sizeof(struct check_owner),
+=09=09=09     GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09=09if (!co)
 =09=09=09return -ENOMEM;
 =09=09co->level =3D level;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 0cab11a5d390..468b739b90b5 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -125,8 +125,8 @@ xchk_refcountbt_rmap_check(
 =09=09 * is healthy each rmap_irec we see will be in agbno order
 =09=09 * so we don't need insertion sort here.
 =09=09 */
-=09=09frag =3D kmem_alloc(sizeof(struct xchk_refcnt_frag),
-=09=09=09=09KM_MAYFAIL);
+=09=09frag =3D kmalloc(sizeof(struct xchk_refcnt_frag),
+=09=09=09       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09=09if (!frag)
 =09=09=09return -ENOMEM;
 =09=09memcpy(&frag->rm, rec, sizeof(frag->rm));
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index a78c501f6fb1..ac0931919999 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -148,7 +148,7 @@ xfs_attr3_leaf_inactive(
 =09 * Allocate storage for a list of all the "remote" value extents.
 =09 */
 =09size =3D count * sizeof(xfs_attr_inactive_list_t);
-=09list =3D kmem_alloc(size, 0);
+=09list =3D kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
=20
 =09/*
 =09 * Identify each of the "remote" value extents.
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 0ec6606149a2..1b39bbff113e 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -116,7 +116,7 @@ xfs_attr_shortform_list(
 =09 * It didn't all fit, so we have to sort everything on hashval.
 =09 */
 =09sbsize =3D sf->hdr.count * sizeof(*sbuf);
-=09sbp =3D sbuf =3D kmem_alloc(sbsize, KM_NOFS);
+=09sbp =3D sbuf =3D kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
=20
 =09/*
 =09 * Scan the attribute list for the rest of the entries, storing
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e2a7eac03d04..8a0cc7593212 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -274,8 +274,9 @@ _xfs_buf_get_pages(
 =09=09if (page_count <=3D XB_PAGES) {
 =09=09=09bp->b_pages =3D bp->b_page_array;
 =09=09} else {
-=09=09=09bp->b_pages =3D kmem_alloc(sizeof(struct page *) *
-=09=09=09=09=09=09 page_count, KM_NOFS);
+=09=09=09bp->b_pages =3D kmalloc(sizeof(struct page *) *
+=09=09=09=09=09      page_count,
+=09=09=09=09=09      GFP_NOFS | __GFP_NOFAIL);
 =09=09=09if (bp->b_pages =3D=3D NULL)
 =09=09=09=09return -ENOMEM;
 =09=09}
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2ae356775f63..0a4bd510e631 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -247,7 +247,7 @@ xfs_filestream_pick_ag(
 =09=09return 0;
=20
 =09err =3D -ENOMEM;
-=09item =3D kmem_alloc(sizeof(*item), KM_MAYFAIL);
+=09item =3D kmalloc(sizeof(*item), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!item)
 =09=09goto out_put_ag;
=20
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8a67e97ecbfc..48d162b0c254 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3493,7 +3493,7 @@ xfs_iflush_cluster(
 =09pag =3D xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
=20
 =09cilist_size =3D igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
-=09cilist =3D kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
+=09cilist =3D kmalloc(cilist_size, GFP_NOFS | __GFP_RETRY_MAYFAIL);
 =09if (!cilist)
 =09=09goto out_put;
=20
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index c812b14af3bb..d6b93a8ee1dc 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -152,7 +152,7 @@ xfs_iwalk_alloc(
=20
 =09/* Allocate a prefetch buffer for inobt records. */
 =09size =3D iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
-=09iwag->recs =3D kmem_alloc(size, KM_MAYFAIL);
+=09iwag->recs =3D kmalloc(size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (iwag->recs =3D=3D NULL)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a7f1dcecc640..d46240152518 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1962,7 +1962,7 @@ xlog_recover_buffer_pass1(
 =09=09}
 =09}
=20
-=09bcp =3D kmem_alloc(sizeof(struct xfs_buf_cancel), 0);
+=09bcp =3D kmalloc(sizeof(struct xfs_buf_cancel), GFP_KERNEL | __GFP_NOFAI=
L);
 =09bcp->bc_blkno =3D buf_f->blf_blkno;
 =09bcp->bc_len =3D buf_f->blf_len;
 =09bcp->bc_refcount =3D 1;
@@ -2932,7 +2932,8 @@ xlog_recover_inode_pass2(
 =09if (item->ri_buf[0].i_len =3D=3D sizeof(struct xfs_inode_log_format)) {
 =09=09in_f =3D item->ri_buf[0].i_addr;
 =09} else {
-=09=09in_f =3D kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
+=09=09in_f =3D kmalloc(sizeof(struct xfs_inode_log_format),
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
 =09=09need_free =3D 1;
 =09=09error =3D xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
 =09=09if (error)
@@ -4271,7 +4272,7 @@ xlog_recover_add_to_trans(
 =09=09return 0;
 =09}
=20
-=09ptr =3D kmem_alloc(len, 0);
+=09ptr =3D kmalloc(len, GFP_KERNEL | __GFP_NOFAIL);
 =09memcpy(ptr, dp, len);
 =09in_f =3D (struct xfs_inode_log_format *)ptr;
=20
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 771f695d8092..ce0c1dddb784 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -988,7 +988,8 @@ xfs_qm_reset_dqcounts_buf(
 =09if (qip->i_d.di_nblocks =3D=3D 0)
 =09=09return 0;
=20
-=09map =3D kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
+=09map =3D kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
+=09=09      GFP_KERNEL | __GFP_NOFAIL);
=20
 =09lblkno =3D 0;
 =09maxlblkcnt =3D XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d42b5a2047e0..1875484123d7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -962,7 +962,7 @@ xfs_growfs_rt(
 =09/*
 =09 * Allocate a new (fake) mount/sb.
 =09 */
-=09nmp =3D kmem_alloc(sizeof(*nmp), 0);
+=09nmp =3D kmalloc(sizeof(*nmp), GFP_KERNEL | __GFP_NOFAIL);
 =09/*
 =09 * Loop over the bitmap blocks.
 =09 * We will do everything one bitmap block at a time.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d9ae27ddf253..c6c423f76447 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1739,7 +1739,7 @@ static int xfs_init_fs_context(
 {
 =09struct xfs_mount=09*mp;
=20
-=09mp =3D kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
+=09mp =3D kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
 =09if (!mp)
 =09=09return -ENOMEM;
=20
--=20
2.23.0


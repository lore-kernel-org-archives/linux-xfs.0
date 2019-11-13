Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8757AC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4F9222C9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYjgSRbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfKMOXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60497 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727450AbfKMOXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxGPOxPp8KgCyRi/h597b5P2SpC2FDTMSGeoLYYlPnM=;
        b=HYjgSRbPHs20wmRvaKgLFm5rST3OqWwFf5mm5QYEJIeEuMxzjRoBX/lIp72a0UVvb1EccJ
        VZKMQiRdLM+AQDtjPJrEJbZPFX+6QmDqDMYIIG30Lq1QQnuZTkGNPZI2OoXDOt07FpBogK
        6GPkOqDpHC1gca2xG33BOYG03uCByO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-aFdsSnT_O7mgfYH5VSPoog-1; Wed, 13 Nov 2019 09:23:51 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEC031345B0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:50 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EA4666835
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:49 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/11] xfs: remove kmem_zalloc() wrapper
Date:   Wed, 13 Nov 2019 15:23:30 +0100
Message-Id: <20191113142335.1045631-7-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: aFdsSnT_O7mgfYH5VSPoog-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kzalloc() directly

Special attention goes to function xfs_buf_map_from_irec(). Giving the
fact we are not allowed to fail there, I removed the 'if (!map)'
conditional from there, I'd just like somebody to double check if it's
fine as I believe it is

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.h                 |  6 ------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
 fs/xfs/libxfs/xfs_da_btree.c  | 10 ++++------
 fs/xfs/libxfs/xfs_dir2.c      | 18 +++++++++---------
 fs/xfs/libxfs/xfs_iext_tree.c | 12 ++++++++----
 fs/xfs/scrub/agheader.c       |  4 ++--
 fs/xfs/scrub/fscounters.c     |  3 ++-
 fs/xfs/xfs_buf.c              |  6 +++---
 fs/xfs/xfs_buf_item.c         |  4 ++--
 fs/xfs/xfs_dquot_item.c       |  3 ++-
 fs/xfs/xfs_error.c            |  4 ++--
 fs/xfs/xfs_extent_busy.c      |  3 ++-
 fs/xfs/xfs_extfree_item.c     |  6 +++---
 fs/xfs/xfs_inode.c            |  2 +-
 fs/xfs/xfs_itable.c           |  8 ++++----
 fs/xfs/xfs_iwalk.c            |  3 ++-
 fs/xfs/xfs_log.c              |  5 +++--
 fs/xfs/xfs_log_cil.c          |  6 +++---
 fs/xfs/xfs_log_recover.c      | 12 ++++++------
 fs/xfs/xfs_mount.c            |  3 ++-
 fs/xfs/xfs_mru_cache.c        |  5 +++--
 fs/xfs/xfs_qm.c               |  3 ++-
 fs/xfs/xfs_refcount_item.c    |  4 ++--
 fs/xfs/xfs_rmap_item.c        |  3 ++-
 fs/xfs/xfs_trans_ail.c        |  3 ++-
 25 files changed, 73 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 33523a0b5801..46c8c5546674 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -62,12 +62,6 @@ static inline void  kmem_free(const void *ptr)
 }
=20
=20
-static inline void *
-kmem_zalloc(size_t size, xfs_km_flags_t flags)
-{
-=09return kmem_alloc(size, flags | KM_ZERO);
-}
-
 static inline void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 85ec5945d29f..9f54e59f4004 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2253,7 +2253,8 @@ xfs_attr3_leaf_unbalance(
 =09=09struct xfs_attr_leafblock *tmp_leaf;
 =09=09struct xfs_attr3_icleaf_hdr tmphdr;
=20
-=09=09tmp_leaf =3D kmem_zalloc(state->args->geo->blksize, 0);
+=09=09tmp_leaf =3D kzalloc(state->args->geo->blksize,
+=09=09=09=09   GFP_KERNEL | __GFP_NOFAIL);
=20
 =09=09/*
 =09=09 * Copy the header into the temp leaf so that all the stuff
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 4e0ec46aec78..dbd2434e68b5 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2534,10 +2534,8 @@ xfs_buf_map_from_irec(
 =09ASSERT(nirecs >=3D 1);
=20
 =09if (nirecs > 1) {
-=09=09map =3D kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
-=09=09=09=09  KM_NOFS);
-=09=09if (!map)
-=09=09=09return -ENOMEM;
+=09=09map =3D kzalloc(nirecs * sizeof(struct xfs_buf_map),
+=09=09=09      GFP_NOFS | __GFP_NOFAIL);
 =09=09*mapp =3D map;
 =09}
=20
@@ -2593,8 +2591,8 @@ xfs_dabuf_map(
 =09=09 * Optimize the one-block case.
 =09=09 */
 =09=09if (nfsb !=3D 1)
-=09=09=09irecs =3D kmem_zalloc(sizeof(irec) * nfsb,
-=09=09=09=09=09    KM_NOFS);
+=09=09=09irecs =3D kzalloc(sizeof(irec) * nfsb,
+=09=09=09=09=09GFP_NOFS | __GFP_NOFAIL);
=20
 =09=09nirecs =3D nfsb;
 =09=09error =3D xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 624c05e77ab4..67172e376e1d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -104,10 +104,10 @@ xfs_da_mount(
 =09ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 =09ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <=3D XFS_MAX_BLOCKSIZE);
=20
-=09mp->m_dir_geo =3D kmem_zalloc(sizeof(struct xfs_da_geometry),
-=09=09=09=09    KM_MAYFAIL);
-=09mp->m_attr_geo =3D kmem_zalloc(sizeof(struct xfs_da_geometry),
-=09=09=09=09     KM_MAYFAIL);
+=09mp->m_dir_geo =3D kzalloc(sizeof(struct xfs_da_geometry),
+=09=09=09=09GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+=09mp->m_attr_geo =3D kzalloc(sizeof(struct xfs_da_geometry),
+=09=09=09=09 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!mp->m_dir_geo || !mp->m_attr_geo) {
 =09=09kmem_free(mp->m_dir_geo);
 =09=09kmem_free(mp->m_attr_geo);
@@ -234,7 +234,7 @@ xfs_dir_init(
 =09if (error)
 =09=09return error;
=20
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09if (!args)
 =09=09return -ENOMEM;
=20
@@ -271,7 +271,7 @@ xfs_dir_createname(
 =09=09XFS_STATS_INC(dp->i_mount, xs_dir_create);
 =09}
=20
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09if (!args)
 =09=09return -ENOMEM;
=20
@@ -370,7 +370,7 @@ xfs_dir_lookup(
 =09 * lockdep Doing this avoids having to add a bunch of lockdep class
 =09 * annotations into the reclaim path for the ilock.
 =09 */
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09args->geo =3D dp->i_mount->m_dir_geo;
 =09args->name =3D name->name;
 =09args->namelen =3D name->len;
@@ -439,7 +439,7 @@ xfs_dir_removename(
 =09ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 =09XFS_STATS_INC(dp->i_mount, xs_dir_remove);
=20
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09if (!args)
 =09=09return -ENOMEM;
=20
@@ -500,7 +500,7 @@ xfs_dir_replace(
 =09if (rval)
 =09=09return rval;
=20
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09if (!args)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 52451809c478..f2005671e86c 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -398,7 +398,8 @@ static void
 xfs_iext_grow(
 =09struct xfs_ifork=09*ifp)
 {
-=09struct xfs_iext_node=09*node =3D kmem_zalloc(NODE_SIZE, KM_NOFS);
+=09struct xfs_iext_node=09*node =3D kzalloc(NODE_SIZE,
+=09=09=09=09=09=09GFP_NOFS | __GFP_NOFAIL);
 =09int=09=09=09i;
=20
 =09if (ifp->if_height =3D=3D 1) {
@@ -454,7 +455,8 @@ xfs_iext_split_node(
 =09int=09=09=09*nr_entries)
 {
 =09struct xfs_iext_node=09*node =3D *nodep;
-=09struct xfs_iext_node=09*new =3D kmem_zalloc(NODE_SIZE, KM_NOFS);
+=09struct xfs_iext_node=09*new =3D kzalloc(NODE_SIZE,
+=09=09=09=09=09       GFP_NOFS | __GFP_NOFAIL);
 =09const int=09=09nr_move =3D KEYS_PER_NODE / 2;
 =09int=09=09=09nr_keep =3D nr_move + (KEYS_PER_NODE & 1);
 =09int=09=09=09i =3D 0;
@@ -542,7 +544,8 @@ xfs_iext_split_leaf(
 =09int=09=09=09*nr_entries)
 {
 =09struct xfs_iext_leaf=09*leaf =3D cur->leaf;
-=09struct xfs_iext_leaf=09*new =3D kmem_zalloc(NODE_SIZE, KM_NOFS);
+=09struct xfs_iext_leaf=09*new =3D kzalloc(NODE_SIZE,
+=09=09=09=09=09       GFP_NOFS | __GFP_NOFAIL);
 =09const int=09=09nr_move =3D RECS_PER_LEAF / 2;
 =09int=09=09=09nr_keep =3D nr_move + (RECS_PER_LEAF & 1);
 =09int=09=09=09i;
@@ -583,7 +586,8 @@ xfs_iext_alloc_root(
 {
 =09ASSERT(ifp->if_bytes =3D=3D 0);
=20
-=09ifp->if_u1.if_root =3D kmem_zalloc(sizeof(struct xfs_iext_rec), KM_NOFS=
);
+=09ifp->if_u1.if_root =3D kzalloc(sizeof(struct xfs_iext_rec),
+=09=09=09=09     GFP_NOFS | __GFP_NOFAIL);
 =09ifp->if_height =3D 1;
=20
 =09/* now that we have a node step into it */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index ba0f747c82e8..93b9a93b40f3 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -720,8 +720,8 @@ xchk_agfl(
 =09memset(&sai, 0, sizeof(sai));
 =09sai.sc =3D sc;
 =09sai.sz_entries =3D agflcount;
-=09sai.entries =3D kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
-=09=09=09KM_MAYFAIL);
+=09sai.entries =3D kzalloc(sizeof(xfs_agblock_t) * agflcount,
+=09=09=09      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!sai.entries) {
 =09=09error =3D -ENOMEM;
 =09=09goto out;
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 7251c66a82c9..bb036c5a6f21 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -125,7 +125,8 @@ xchk_setup_fscounters(
 =09struct xchk_fscounters=09*fsc;
 =09int=09=09=09error;
=20
-=09sc->buf =3D kmem_zalloc(sizeof(struct xchk_fscounters), 0);
+=09sc->buf =3D kzalloc(sizeof(struct xchk_fscounters),
+=09=09=09  GFP_KERNEL | __GFP_NOFAIL);
 =09if (!sc->buf)
 =09=09return -ENOMEM;
 =09fsc =3D sc->buf;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 85f9ef4f504e..e2a7eac03d04 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -178,8 +178,8 @@ xfs_buf_get_maps(
 =09=09return 0;
 =09}
=20
-=09bp->b_maps =3D kmem_zalloc(map_count * sizeof(struct xfs_buf_map),
-=09=09=09=09KM_NOFS);
+=09bp->b_maps =3D kzalloc(map_count * sizeof(struct xfs_buf_map),
+=09=09=09     GFP_NOFS | __GFP_NOFAIL);
 =09if (!bp->b_maps)
 =09=09return -ENOMEM;
 =09return 0;
@@ -1749,7 +1749,7 @@ xfs_alloc_buftarg(
 {
 =09xfs_buftarg_t=09=09*btp;
=20
-=09btp =3D kmem_zalloc(sizeof(*btp), KM_NOFS);
+=09btp =3D kzalloc(sizeof(*btp), GFP_NOFS | __GFP_NOFAIL);
=20
 =09btp->bt_mount =3D mp;
 =09btp->bt_dev =3D  bdev->bd_dev;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 676149ac09a3..e6f48fe24537 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -701,8 +701,8 @@ xfs_buf_item_get_format(
 =09=09return 0;
 =09}
=20
-=09bip->bli_formats =3D kmem_zalloc(count * sizeof(struct xfs_buf_log_form=
at),
-=09=09=09=090);
+=09bip->bli_formats =3D kzalloc(count * sizeof(struct xfs_buf_log_format),
+=09=09=09=09   GFP_KERNEL | __GFP_NOFAIL);
 =09if (!bip->bli_formats)
 =09=09return -ENOMEM;
 =09return 0;
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d60647d7197b..a720425d0728 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -347,7 +347,8 @@ xfs_qm_qoff_logitem_init(
 {
 =09struct xfs_qoff_logitem=09*qf;
=20
-=09qf =3D kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
+=09qf =3D kzalloc(sizeof(struct xfs_qoff_logitem),
+=09=09     GFP_KERNEL | __GFP_NOFAIL);
=20
 =09xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
 =09=09=09&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 51dd1f43d12f..51ca07eed4f3 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -212,8 +212,8 @@ int
 xfs_errortag_init(
 =09struct xfs_mount=09*mp)
 {
-=09mp->m_errortag =3D kmem_zalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
-=09=09=09KM_MAYFAIL);
+=09mp->m_errortag =3D kzalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
+=09=09=09=09 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!mp->m_errortag)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 3991e59cfd18..76422684449c 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -33,7 +33,8 @@ xfs_extent_busy_insert(
 =09struct rb_node=09=09**rbp;
 =09struct rb_node=09=09*parent =3D NULL;
=20
-=09new =3D kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
+=09new =3D kzalloc(sizeof(struct xfs_extent_busy),
+=09=09      GFP_KERNEL | __GFP_NOFAIL);
 =09new->agno =3D agno;
 =09new->bno =3D bno;
 =09new->length =3D len;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 49ce6d6c4bb9..f8f0efe42513 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -163,7 +163,7 @@ xfs_efi_init(
 =09if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
 =09=09size =3D (uint)(sizeof(xfs_efi_log_item_t) +
 =09=09=09((nextents - 1) * sizeof(xfs_extent_t)));
-=09=09efip =3D kmem_zalloc(size, 0);
+=09=09efip =3D kzalloc(size, GFP_KERNEL | __GFP_NOFAIL);
 =09} else {
 =09=09efip =3D kmem_cache_zalloc(xfs_efi_zone,
 =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
@@ -333,9 +333,9 @@ xfs_trans_get_efd(
 =09ASSERT(nextents > 0);
=20
 =09if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-=09=09efdp =3D kmem_zalloc(sizeof(struct xfs_efd_log_item) +
+=09=09efdp =3D kzalloc(sizeof(struct xfs_efd_log_item) +
 =09=09=09=09(nextents - 1) * sizeof(struct xfs_extent),
-=09=09=09=090);
+=09=09=09=09GFP_KERNEL | __GFP_NOFAIL);
 =09} else {
 =09=09efdp =3D kmem_cache_zalloc(xfs_efd_zone,
 =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a92d4521748d..8a67e97ecbfc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2024,7 +2024,7 @@ xfs_iunlink_add_backref(
 =09if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
 =09=09return 0;
=20
-=09iu =3D kmem_zalloc(sizeof(*iu), KM_NOFS);
+=09iu =3D kzalloc(sizeof(*iu), GFP_NOFS | __GFP_NOFAIL);
 =09iu->iu_agino =3D prev_agino;
 =09iu->iu_next_unlinked =3D this_agino;
=20
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 884950adbd16..b9b78874e60d 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -168,8 +168,8 @@ xfs_bulkstat_one(
=20
 =09ASSERT(breq->icount =3D=3D 1);
=20
-=09bc.buf =3D kmem_zalloc(sizeof(struct xfs_bulkstat),
-=09=09=09KM_MAYFAIL);
+=09bc.buf =3D kzalloc(sizeof(struct xfs_bulkstat),
+=09=09=09 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!bc.buf)
 =09=09return -ENOMEM;
=20
@@ -242,8 +242,8 @@ xfs_bulkstat(
 =09if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 =09=09return 0;
=20
-=09bc.buf =3D kmem_zalloc(sizeof(struct xfs_bulkstat),
-=09=09=09KM_MAYFAIL);
+=09bc.buf =3D kzalloc(sizeof(struct xfs_bulkstat),
+=09=09=09 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!bc.buf)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index aa375cf53021..c812b14af3bb 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -616,7 +616,8 @@ xfs_iwalk_threaded(
 =09=09if (xfs_pwork_ctl_want_abort(&pctl))
 =09=09=09break;
=20
-=09=09iwag =3D kmem_zalloc(sizeof(struct xfs_iwalk_ag), 0);
+=09=09iwag =3D kzalloc(sizeof(struct xfs_iwalk_ag),
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
 =09=09iwag->mp =3D mp;
 =09=09iwag->iwalk_fn =3D iwalk_fn;
 =09=09iwag->data =3D data;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 30447bd477d2..28e82d5d5943 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1412,7 +1412,7 @@ xlog_alloc_log(
 =09int=09=09=09error =3D -ENOMEM;
 =09uint=09=09=09log2_size =3D 0;
=20
-=09log =3D kmem_zalloc(sizeof(struct xlog), KM_MAYFAIL);
+=09log =3D kzalloc(sizeof(struct xlog), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!log) {
 =09=09xfs_warn(mp, "Log allocation failed: No memory!");
 =09=09goto out;
@@ -1482,7 +1482,8 @@ xlog_alloc_log(
 =09=09size_t bvec_size =3D howmany(log->l_iclog_size, PAGE_SIZE) *
 =09=09=09=09sizeof(struct bio_vec);
=20
-=09=09iclog =3D kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
+=09=09iclog =3D kzalloc(sizeof(*iclog) + bvec_size,
+=09=09=09=09GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09=09if (!iclog)
 =09=09=09goto out_free_iclog;
=20
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 630c2482c8f1..aa1b923f7293 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -660,7 +660,7 @@ xlog_cil_push(
 =09if (!cil)
 =09=09return 0;
=20
-=09new_ctx =3D kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
+=09new_ctx =3D kzalloc(sizeof(*new_ctx), GFP_NOFS | __GFP_NOFAIL);
 =09new_ctx->ticket =3D xlog_cil_ticket_alloc(log);
=20
 =09down_write(&cil->xc_ctx_lock);
@@ -1179,11 +1179,11 @@ xlog_cil_init(
 =09struct xfs_cil=09*cil;
 =09struct xfs_cil_ctx *ctx;
=20
-=09cil =3D kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
+=09cil =3D kzalloc(sizeof(*cil), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!cil)
 =09=09return -ENOMEM;
=20
-=09ctx =3D kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
+=09ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!ctx) {
 =09=09kmem_free(cil);
 =09=09return -ENOMEM;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02f2147952b3..bc5c0aef051c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4171,7 +4171,7 @@ xlog_recover_add_item(
 {
 =09xlog_recover_item_t=09*item;
=20
-=09item =3D kmem_zalloc(sizeof(xlog_recover_item_t), 0);
+=09item =3D kzalloc(sizeof(xlog_recover_item_t), GFP_KERNEL | __GFP_NOFAIL=
);
 =09INIT_LIST_HEAD(&item->ri_list);
 =09list_add_tail(&item->ri_list, head);
 }
@@ -4298,8 +4298,8 @@ xlog_recover_add_to_trans(
=20
 =09=09item->ri_total =3D in_f->ilf_size;
 =09=09item->ri_buf =3D
-=09=09=09kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
-=09=09=09=09    0);
+=09=09=09kzalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+=09=09=09=09GFP_KERNEL | __GFP_NOFAIL);
 =09}
=20
 =09if (item->ri_total <=3D item->ri_cnt) {
@@ -4442,7 +4442,7 @@ xlog_recover_ophdr_to_trans(
 =09 * This is a new transaction so allocate a new recovery container to
 =09 * hold the recovery ops that will follow.
 =09 */
-=09trans =3D kmem_zalloc(sizeof(struct xlog_recover), 0);
+=09trans =3D kzalloc(sizeof(struct xlog_recover), GFP_KERNEL | __GFP_NOFAI=
L);
 =09trans->r_log_tid =3D tid;
 =09trans->r_lsn =3D be64_to_cpu(rhead->h_lsn);
 =09INIT_LIST_HEAD(&trans->r_itemq);
@@ -5561,9 +5561,9 @@ xlog_do_log_recovery(
 =09 * First do a pass to find all of the cancelled buf log items.
 =09 * Store them in the buf_cancel_table for use in the second pass.
 =09 */
-=09log->l_buf_cancel_table =3D kmem_zalloc(XLOG_BC_TABLE_SIZE *
+=09log->l_buf_cancel_table =3D kzalloc(XLOG_BC_TABLE_SIZE *
 =09=09=09=09=09=09 sizeof(struct list_head),
-=09=09=09=09=09=09 0);
+=09=09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
 =09for (i =3D 0; i < XLOG_BC_TABLE_SIZE; i++)
 =09=09INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
=20
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5ea95247a37f..91a5354f20fb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -194,7 +194,8 @@ xfs_initialize_perag(
 =09=09=09continue;
 =09=09}
=20
-=09=09pag =3D kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
+=09=09pag =3D kzalloc(sizeof(*pag),
+=09=09=09      GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09=09if (!pag)
 =09=09=09goto out_unwind_new_pags;
 =09=09pag->pag_agno =3D index;
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index a06661dac5be..d281db58934e 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -333,12 +333,13 @@ xfs_mru_cache_create(
 =09if (!(grp_time =3D msecs_to_jiffies(lifetime_ms) / grp_count))
 =09=09return -EINVAL;
=20
-=09if (!(mru =3D kmem_zalloc(sizeof(*mru), 0)))
+=09if (!(mru =3D kzalloc(sizeof(*mru), GFP_KERNEL | __GFP_NOFAIL)))
 =09=09return -ENOMEM;
=20
 =09/* An extra list is needed to avoid reaping up to a grp_time early. */
 =09mru->grp_count =3D grp_count + 1;
-=09mru->lists =3D kmem_zalloc(mru->grp_count * sizeof(*mru->lists), 0);
+=09mru->lists =3D kzalloc(mru->grp_count * sizeof(*mru->lists),
+=09=09=09     GFP_KERNEL | __GFP_NOFAIL);
=20
 =09if (!mru->lists) {
 =09=09err =3D -ENOMEM;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 66ea8e4fca86..771f695d8092 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -643,7 +643,8 @@ xfs_qm_init_quotainfo(
=20
 =09ASSERT(XFS_IS_QUOTA_RUNNING(mp));
=20
-=09qinf =3D mp->m_quotainfo =3D kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
+=09qinf =3D mp->m_quotainfo =3D kzalloc(sizeof(xfs_quotainfo_t),
+=09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
=20
 =09error =3D list_lru_init(&qinf->qi_lru);
 =09if (error)
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a242bc9874a6..37e46a908784 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -143,8 +143,8 @@ xfs_cui_init(
=20
 =09ASSERT(nextents > 0);
 =09if (nextents > XFS_CUI_MAX_FAST_EXTENTS)
-=09=09cuip =3D kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
-=09=09=09=090);
+=09=09cuip =3D kzalloc(xfs_cui_log_item_sizeof(nextents),
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
 =09else
 =09=09cuip =3D kmem_cache_zalloc(xfs_cui_zone, GFP_KERNEL | __GFP_NOFAIL);
=20
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 857cc78dc440..e7ae8f99305c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -142,7 +142,8 @@ xfs_rui_init(
=20
 =09ASSERT(nextents > 0);
 =09if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
-=09=09ruip =3D kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
+=09=09ruip =3D kzalloc(xfs_rui_log_item_sizeof(nextents),
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
 =09else
 =09=09ruip =3D kmem_cache_zalloc(xfs_rui_zone,
 =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 00cc5b8734be..d8ef4fa033eb 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -824,7 +824,8 @@ xfs_trans_ail_init(
 {
 =09struct xfs_ail=09*ailp;
=20
-=09ailp =3D kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
+=09ailp =3D kzalloc(sizeof(struct xfs_ail),
+=09=09       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 =09if (!ailp)
 =09=09return -ENOMEM;
=20
--=20
2.23.0


Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58784C43215
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EF0722429
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yfqam18w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfKTKol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:44:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728777AbfKTKol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 05:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574246679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8wMbOFB5ZbapsTjjWuyDsJmlc6PdIhkpPHE1ahPzho=;
        b=Yfqam18wdfPJAkOqsW6y/XfbkohelDEeTsYIwTxJx6KvyMWbxWOYohbStn66vFXganopBN
        LZkd+MrrfgeAvf15s8/pAHqXRG7R0ldr+CmUVt37knWc8ZqWcpYn2J+Ml6ZAT5dxSwkGEn
        ebSHmoVQrqg80dIlPiJTqu8CU1rjqFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-3WIatpnEMiqSataU-9Z8tw-1; Wed, 20 Nov 2019 05:44:37 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 441F8801FA1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:36 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-164.brq.redhat.com [10.40.204.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AACD66D4D
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:35 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: remove kmem_zalloc() wrapper
Date:   Wed, 20 Nov 2019 11:44:23 +0100
Message-Id: <20191120104425.407213-4-cmaiolino@redhat.com>
In-Reply-To: <20191120104425.407213-1-cmaiolino@redhat.com>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 3WIatpnEMiqSataU-9Z8tw-1
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
V2:
=09- Fix comment on xfs_dir_lookup()

 fs/xfs/kmem.h                 |  6 ------
 fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
 fs/xfs/libxfs/xfs_da_btree.c  | 10 ++++------
 fs/xfs/libxfs/xfs_dir2.c      | 27 +++++++++++++--------------
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
 25 files changed, 77 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 7e4ad73771ce..b9ee67fa747b 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -57,12 +57,6 @@ extern void *kmem_alloc_io(size_t size, int align_mask, =
xfs_km_flags_t flags);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
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
index 795b9b21b64d..67de68584224 100644
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
index 10a96e64b2ec..29c25d1b3b76 100644
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
index efd7cec65259..c2deda036271 100644
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
 =09=09kfree(mp->m_dir_geo);
 =09=09kfree(mp->m_attr_geo);
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
@@ -363,14 +363,13 @@ xfs_dir_lookup(
 =09XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
=20
 =09/*
-=09 * We need to use KM_NOFS here so that lockdep will not throw false
+=09 * We need to use GFP_NOFS here so that lockdep will not throw false
 =09 * positive deadlock warnings on a non-transactional lookup path. It is
-=09 * safe to recurse into inode recalim in that case, but lockdep can't
-=09 * easily be taught about it. Hence KM_NOFS avoids having to add more
-=09 * lockdep Doing this avoids having to add a bunch of lockdep class
-=09 * annotations into the reclaim path for the ilock.
+=09 * safe to recurse into inode reclaim in that case, but lockdep can't
+=09 * easily be taught about it. Hence GFP_NOFS avoids having to add more
+=09 * lockdep class annotations into the reclaim path for the ilock.
 =09 */
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09args->geo =3D dp->i_mount->m_dir_geo;
 =09args->name =3D name->name;
 =09args->namelen =3D name->len;
@@ -439,7 +438,7 @@ xfs_dir_removename(
 =09ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 =09XFS_STATS_INC(dp->i_mount, xs_dir_remove);
=20
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09if (!args)
 =09=09return -ENOMEM;
=20
@@ -500,7 +499,7 @@ xfs_dir_replace(
 =09if (rval)
 =09=09return rval;
=20
-=09args =3D kmem_zalloc(sizeof(*args), KM_NOFS);
+=09args =3D kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
 =09if (!args)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index a7ba30cd81da..e75e7c021187 100644
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
index 6f7126f6d25c..5533c0d38333 100644
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
index 0d2c41c6639d..c70122fbc2a8 100644
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
index dc39b2d1b351..4fea8e5e70fb 100644
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
index 1b5e68ccef60..91bd47e8b832 100644
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
index 4c0883380d7c..0e0ef2e15e2e 100644
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
index 9f0b99c7b34a..0ce50b47fc28 100644
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
index c3b8804aa396..872312029957 100644
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
index e1121ed7cbb5..297b2a73f285 100644
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
index 36bf47f11117..ec5d590469fc 100644
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
index 67e98f9023d2..e6006423e140 100644
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
index 9ed7869d879f..152c87865241 100644
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
index 9953f2f040ab..de5c892c72b0 100644
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
 =09=09kfree(cil);
 =09=09return -ENOMEM;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4167e1326f62..cb02deb5dedc 100644
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
index 53ddb058b11a..c352567c8ef5 100644
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
index 6ef0a71d7681..f24014759c57 100644
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
index 06c92dc61a03..a2664afa10c3 100644
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
index 76b39f2a0260..7ec70a5f1cb0 100644
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
 =09=09cuip =3D kmem_cache_zalloc(xfs_cui_zone,
 =09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 6aeb6745d007..82d822885996 100644
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
index 589918d11041..2e3515df1bb5 100644
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


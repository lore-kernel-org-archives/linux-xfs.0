Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F29AC17447
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EC40222C9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKwPzM09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfKMOXw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727450AbfKMOXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDxROk7DczfwEULzpxU0Gm+CvKw7ZfB4ZXyXqACDCG0=;
        b=BKwPzM096AlFhydgPSMhE55pe0e9YRUHE1hJfJHDk85ONTVBZNuKyctiXWphWa2HhUHJp/
        BdCsi1KysqUXa/Xamumrwv6QVZiEJmcf1k7y/Kpd7RXX3N+3aG6G9NBRVAyOc0VPh7YhbR
        jjyoXUBnmZav7Nnb1gSisbjQfJzXJWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-KZ79FwVKPYmfVnecHAeH0g-1; Wed, 13 Nov 2019 09:23:49 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0333102C85E
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:48 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 027124D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:47 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/11] xfs: remove kmem_zone_zalloc()
Date:   Wed, 13 Nov 2019 15:23:28 +0100
Message-Id: <20191113142335.1045631-5-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: KZ79FwVKPYmfVnecHAeH0g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kmem_cache_zalloc() directly.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.h                      | 6 ------
 fs/xfs/libxfs/xfs_alloc_btree.c    | 2 +-
 fs/xfs/libxfs/xfs_bmap.c           | 3 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c     | 2 +-
 fs/xfs/libxfs/xfs_da_btree.c       | 2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c     | 6 +++---
 fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     | 2 +-
 fs/xfs/xfs_bmap_item.c             | 4 ++--
 fs/xfs/xfs_buf.c                   | 2 +-
 fs/xfs/xfs_buf_item.c              | 2 +-
 fs/xfs/xfs_dquot.c                 | 2 +-
 fs/xfs/xfs_extfree_item.c          | 6 ++++--
 fs/xfs/xfs_icreate_item.c          | 2 +-
 fs/xfs/xfs_inode_item.c            | 3 ++-
 fs/xfs/xfs_log.c                   | 7 ++++---
 fs/xfs/xfs_log_cil.c               | 2 +-
 fs/xfs/xfs_log_priv.h              | 2 +-
 fs/xfs/xfs_refcount_item.c         | 4 ++--
 fs/xfs/xfs_rmap_item.c             | 5 +++--
 fs/xfs/xfs_trans.c                 | 4 ++--
 fs/xfs/xfs_trans_dquot.c           | 3 ++-
 23 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 6143117770e9..c12ab170c396 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -83,12 +83,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
=20
 extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
=20
-static inline void *
-kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-=09return kmem_zone_alloc(zone, flags | KM_ZERO);
-}
-
 static inline struct page *
 kmem_to_page(void *addr)
 {
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btre=
e.c
index 279694d73e4e..0867c1fad11b 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -487,7 +487,7 @@ xfs_allocbt_init_cursor(
=20
 =09ASSERT(btnum =3D=3D XFS_BTNUM_BNO || btnum =3D=3D XFS_BTNUM_CNT);
=20
-=09cur =3D kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+=09cur =3D kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
=20
 =09cur->bc_tp =3D tp;
 =09cur->bc_mp =3D mp;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b7cc2f9eae7b..9fbdca183465 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1104,7 +1104,8 @@ xfs_bmap_add_attrfork(
 =09if (error)
 =09=09goto trans_cancel;
 =09ASSERT(ip->i_afp =3D=3D NULL);
-=09ip->i_afp =3D kmem_zone_zalloc(xfs_ifork_zone, 0);
+=09ip->i_afp =3D kmem_cache_zalloc(xfs_ifork_zone,
+=09=09=09=09      GFP_KERNEL | __GFP_NOFAIL);
 =09ip->i_afp->if_flags =3D XFS_IFEXTENTS;
 =09logflags =3D 0;
 =09switch (ip->i_d.di_format) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.=
c
index ffe608d2a2d9..77fe4ae671e5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -552,7 +552,7 @@ xfs_bmbt_init_cursor(
 =09struct xfs_btree_cur=09*cur;
 =09ASSERT(whichfork !=3D XFS_COW_FORK);
=20
-=09cur =3D kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+=09cur =3D kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
=20
 =09cur->bc_tp =3D tp;
 =09cur->bc_mp =3D mp;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index c5c0b73febae..4e0ec46aec78 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -81,7 +81,7 @@ kmem_zone_t *xfs_da_state_zone;=09/* anchor for state str=
uct zone */
 xfs_da_state_t *
 xfs_da_state_alloc(void)
 {
-=09return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
+=09return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
 }
=20
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_bt=
ree.c
index b82992f795aa..5366a874b076 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -413,7 +413,7 @@ xfs_inobt_init_cursor(
 =09struct xfs_agi=09=09*agi =3D XFS_BUF_TO_AGI(agbp);
 =09struct xfs_btree_cur=09*cur;
=20
-=09cur =3D kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+=09cur =3D kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
=20
 =09cur->bc_tp =3D tp;
 =09cur->bc_mp =3D mp;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.=
c
index ad2b9c313fd2..2bffaa31d62a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -98,7 +98,7 @@ xfs_iformat_fork(
 =09=09return 0;
=20
 =09ASSERT(ip->i_afp =3D=3D NULL);
-=09ip->i_afp =3D kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
+=09ip->i_afp =3D kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL=
);
=20
 =09switch (dip->di_aformat) {
 =09case XFS_DINODE_FMT_LOCAL:
@@ -688,8 +688,8 @@ xfs_ifork_init_cow(
 =09if (ip->i_cowfp)
 =09=09return;
=20
-=09ip->i_cowfp =3D kmem_zone_zalloc(xfs_ifork_zone,
-=09=09=09=09       KM_NOFS);
+=09ip->i_cowfp =3D kmem_cache_zalloc(xfs_ifork_zone,
+=09=09=09=09       GFP_NOFS | __GFP_NOFAIL);
 =09ip->i_cowfp->if_flags =3D XFS_IFEXTENTS;
 =09ip->i_cformat =3D XFS_DINODE_FMT_EXTENTS;
 =09ip->i_cnextents =3D 0;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcoun=
t_btree.c
index 38529dbacd55..bb86988780ea 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -325,7 +325,7 @@ xfs_refcountbt_init_cursor(
=20
 =09ASSERT(agno !=3D NULLAGNUMBER);
 =09ASSERT(agno < mp->m_sb.sb_agcount);
-=09cur =3D kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+=09cur =3D kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
=20
 =09cur->bc_tp =3D tp;
 =09cur->bc_mp =3D mp;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.=
c
index fc78efa52c94..8d84dd98e8d3 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -461,7 +461,7 @@ xfs_rmapbt_init_cursor(
 =09struct xfs_agf=09=09*agf =3D XFS_BUF_TO_AGF(agbp);
 =09struct xfs_btree_cur=09*cur;
=20
-=09cur =3D kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+=09cur =3D kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
 =09cur->bc_tp =3D tp;
 =09cur->bc_mp =3D mp;
 =09/* Overlapping btree; 2 keys per pointer. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc..451d6b925930 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -141,7 +141,7 @@ xfs_bui_init(
 {
 =09struct xfs_bui_log_item=09=09*buip;
=20
-=09buip =3D kmem_zone_zalloc(xfs_bui_zone, 0);
+=09buip =3D kmem_cache_zalloc(xfs_bui_zone, GFP_KERNEL | __GFP_NOFAIL);
=20
 =09xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
 =09buip->bui_format.bui_nextents =3D XFS_BUI_MAX_FAST_EXTENTS;
@@ -218,7 +218,7 @@ xfs_trans_get_bud(
 {
 =09struct xfs_bud_log_item=09=09*budp;
=20
-=09budp =3D kmem_zone_zalloc(xfs_bud_zone, 0);
+=09budp =3D kmem_cache_zalloc(xfs_bud_zone, GFP_KERNEL | __GFP_NOFAIL);
 =09xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
 =09=09=09  &xfs_bud_item_ops);
 =09budp->bud_buip =3D buip;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a0229c368e78..85f9ef4f504e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -209,7 +209,7 @@ _xfs_buf_alloc(
 =09int=09=09=09error;
 =09int=09=09=09i;
=20
-=09bp =3D kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
+=09bp =3D kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS | __GFP_NOFAIL);
 =09if (unlikely(!bp))
 =09=09return NULL;
=20
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3458a1264a3f..676149ac09a3 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -747,7 +747,7 @@ xfs_buf_item_init(
 =09=09return 0;
 =09}
=20
-=09bip =3D kmem_zone_zalloc(xfs_buf_item_zone, 0);
+=09bip =3D kmem_cache_zalloc(xfs_buf_item_zone, GFP_KERNEL | __GFP_NOFAIL)=
;
 =09xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 =09bip->bli_buf =3D bp;
=20
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 153815bf18fc..79f0de378123 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -440,7 +440,7 @@ xfs_dquot_alloc(
 {
 =09struct xfs_dquot=09*dqp;
=20
-=09dqp =3D kmem_zone_zalloc(xfs_qm_dqzone, 0);
+=09dqp =3D kmem_cache_zalloc(xfs_qm_dqzone, GFP_KERNEL | __GFP_NOFAIL);
=20
 =09dqp->dq_flags =3D type;
 =09dqp->q_core.d_id =3D cpu_to_be32(id);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e298..49ce6d6c4bb9 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -165,7 +165,8 @@ xfs_efi_init(
 =09=09=09((nextents - 1) * sizeof(xfs_extent_t)));
 =09=09efip =3D kmem_zalloc(size, 0);
 =09} else {
-=09=09efip =3D kmem_zone_zalloc(xfs_efi_zone, 0);
+=09=09efip =3D kmem_cache_zalloc(xfs_efi_zone,
+=09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
 =09}
=20
 =09xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
@@ -336,7 +337,8 @@ xfs_trans_get_efd(
 =09=09=09=09(nextents - 1) * sizeof(struct xfs_extent),
 =09=09=09=090);
 =09} else {
-=09=09efdp =3D kmem_zone_zalloc(xfs_efd_zone, 0);
+=09=09efdp =3D kmem_cache_zalloc(xfs_efd_zone,
+=09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
 =09}
=20
 =09xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 490fee22b878..85bbf9dbe095 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -89,7 +89,7 @@ xfs_icreate_log(
 {
 =09struct xfs_icreate_item=09*icp;
=20
-=09icp =3D kmem_zone_zalloc(xfs_icreate_zone, 0);
+=09icp =3D kmem_cache_zalloc(xfs_icreate_zone, GFP_KERNEL | __GFP_NOFAIL);
=20
 =09xfs_log_item_init(tp->t_mountp, &icp->ic_item, XFS_LI_ICREATE,
 =09=09=09  &xfs_icreate_item_ops);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3a62976291a1..2097e6932a48 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -652,7 +652,8 @@ xfs_inode_item_init(
 =09struct xfs_inode_log_item *iip;
=20
 =09ASSERT(ip->i_itemp =3D=3D NULL);
-=09iip =3D ip->i_itemp =3D kmem_zone_zalloc(xfs_ili_zone, 0);
+=09iip =3D ip->i_itemp =3D kmem_cache_zalloc(xfs_ili_zone,
+=09=09=09=09=09      GFP_KERNEL | __GFP_NOFAIL);
=20
 =09iip->ili_inode =3D ip;
 =09xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6a147c63a8a6..30447bd477d2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -454,7 +454,8 @@ xfs_log_reserve(
 =09XFS_STATS_INC(mp, xs_try_logspace);
=20
 =09ASSERT(*ticp =3D=3D NULL);
-=09tic =3D xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
+=09tic =3D xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
+=09=09=09=09GFP_KERNEL | __GFP_NOFAIL);
 =09*ticp =3D tic;
=20
 =09xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -3587,12 +3588,12 @@ xlog_ticket_alloc(
 =09int=09=09=09cnt,
 =09char=09=09=09client,
 =09bool=09=09=09permanent,
-=09xfs_km_flags_t=09=09alloc_flags)
+=09gfp_t=09=09=09alloc_flags)
 {
 =09struct xlog_ticket=09*tic;
 =09int=09=09=09unit_res;
=20
-=09tic =3D kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
+=09tic =3D kmem_cache_zalloc(xfs_log_ticket_zone, alloc_flags);
 =09if (!tic)
 =09=09return NULL;
=20
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 48435cf2aa16..630c2482c8f1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -38,7 +38,7 @@ xlog_cil_ticket_alloc(
 =09struct xlog_ticket *tic;
=20
 =09tic =3D xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
-=09=09=09=09KM_NOFS);
+=09=09=09=09GFP_NOFS | __GFP_NOFAIL);
=20
 =09/*
 =09 * set the current reservation to zero so we know to steal the basic
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c47aa2ca6dc7..54c95fee9dc4 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -427,7 +427,7 @@ xlog_ticket_alloc(
 =09int=09=09count,
 =09char=09=09client,
 =09bool=09=09permanent,
-=09xfs_km_flags_t=09alloc_flags);
+=09gfp_t=09=09alloc_flags);
=20
=20
 static inline void
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cd..a242bc9874a6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -146,7 +146,7 @@ xfs_cui_init(
 =09=09cuip =3D kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
 =09=09=09=090);
 =09else
-=09=09cuip =3D kmem_zone_zalloc(xfs_cui_zone, 0);
+=09=09cuip =3D kmem_cache_zalloc(xfs_cui_zone, GFP_KERNEL | __GFP_NOFAIL);
=20
 =09xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
 =09cuip->cui_format.cui_nextents =3D nextents;
@@ -223,7 +223,7 @@ xfs_trans_get_cud(
 {
 =09struct xfs_cud_log_item=09=09*cudp;
=20
-=09cudp =3D kmem_zone_zalloc(xfs_cud_zone, 0);
+=09cudp =3D kmem_cache_zalloc(xfs_cud_zone, GFP_KERNEL | __GFP_NOFAIL);
 =09xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
 =09=09=09  &xfs_cud_item_ops);
 =09cudp->cud_cuip =3D cuip;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..857cc78dc440 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -144,7 +144,8 @@ xfs_rui_init(
 =09if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
 =09=09ruip =3D kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
 =09else
-=09=09ruip =3D kmem_zone_zalloc(xfs_rui_zone, 0);
+=09=09ruip =3D kmem_cache_zalloc(xfs_rui_zone,
+=09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
=20
 =09xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
 =09ruip->rui_format.rui_nextents =3D nextents;
@@ -246,7 +247,7 @@ xfs_trans_get_rud(
 {
 =09struct xfs_rud_log_item=09=09*rudp;
=20
-=09rudp =3D kmem_zone_zalloc(xfs_rud_zone, 0);
+=09rudp =3D kmem_cache_zalloc(xfs_rud_zone, GFP_KERNEL | __GFP_NOFAIL);
 =09xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
 =09=09=09  &xfs_rud_item_ops);
 =09rudp->rud_ruip =3D ruip;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..29f34492d5f4 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -90,7 +90,7 @@ xfs_trans_dup(
=20
 =09trace_xfs_trans_dup(tp, _RET_IP_);
=20
-=09ntp =3D kmem_zone_zalloc(xfs_trans_zone, 0);
+=09ntp =3D kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
=20
 =09/*
 =09 * Initialize the new transaction structure.
@@ -263,7 +263,7 @@ xfs_trans_alloc(
 =09 * GFP_NOFS allocation context so that we avoid lockdep false positives
 =09 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 =09 */
-=09tp =3D kmem_zone_zalloc(xfs_trans_zone, 0);
+=09tp =3D kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 =09if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 =09=09sb_start_intwrite(mp->m_super);
=20
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ff1c326826d3..69e8f6d049aa 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -863,7 +863,8 @@ STATIC void
 xfs_trans_alloc_dqinfo(
 =09xfs_trans_t=09*tp)
 {
-=09tp->t_dqinfo =3D kmem_zone_zalloc(xfs_qm_dqtrxzone, 0);
+=09tp->t_dqinfo =3D kmem_cache_zalloc(xfs_qm_dqtrxzone,
+=09=09=09=09=09 GFP_KERNEL | __GFP_NOFAIL);
 }
=20
 void
--=20
2.23.0


Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B50C17449
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA54B222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h3km7fGW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfKMOX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727450AbfKMOX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RNw2S2gNwpVOhiCiQLryRg1p0d9sRXFcyZm4Bc3KvY=;
        b=h3km7fGW9Duy26koZKRRKwUK5qKmHmWDvqHmXNgGxC1cW6KzFqCbAlFydTp8sVALQmJQ8v
        sFp6shvCqQRKNNLiKDwmcCUrIXbceW17bL7n6pMwO2rGHXANOOzyqRz5AgPXAFKsHIUo0Y
        vpXgdWp0Ijo2ifa3NHIpa1iOtB0QgNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-Tz7gWfH6PGuzzUCylCklsg-1; Wed, 13 Nov 2019 09:23:48 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98BD5102C8BE
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:47 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F090F4D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:46 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/11] xfs: Remove kmem_zone_free() wrapper
Date:   Wed, 13 Nov 2019 15:23:27 +0100
Message-Id: <20191113142335.1045631-4-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Tz7gWfH6PGuzzUCylCklsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can remove it now, without needing to rework the KM_ flags.

Use kmem_cache_free() directly.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.h                  | 6 ------
 fs/xfs/libxfs/xfs_btree.c      | 2 +-
 fs/xfs/libxfs/xfs_da_btree.c   | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 8 ++++----
 fs/xfs/xfs_bmap_item.c         | 4 ++--
 fs/xfs/xfs_buf.c               | 6 +++---
 fs/xfs/xfs_buf_item.c          | 4 ++--
 fs/xfs/xfs_dquot.c             | 2 +-
 fs/xfs/xfs_extfree_item.c      | 4 ++--
 fs/xfs/xfs_icache.c            | 4 ++--
 fs/xfs/xfs_icreate_item.c      | 2 +-
 fs/xfs/xfs_inode_item.c        | 2 +-
 fs/xfs/xfs_log.c               | 2 +-
 fs/xfs/xfs_refcount_item.c     | 4 ++--
 fs/xfs/xfs_rmap_item.c         | 4 ++--
 fs/xfs/xfs_trans.c             | 2 +-
 fs/xfs/xfs_trans_dquot.c       | 2 +-
 17 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 70ed74c7f37e..6143117770e9 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -81,12 +81,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 #define kmem_zone=09kmem_cache
 #define kmem_zone_t=09struct kmem_cache
=20
-static inline void
-kmem_zone_free(kmem_zone_t *zone, void *ptr)
-{
-=09kmem_cache_free(zone, ptr);
-}
-
 extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
=20
 static inline void *
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 98843f1258b8..ac0b78ea417b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -384,7 +384,7 @@ xfs_btree_del_cursor(
 =09/*
 =09 * Free the cursor.
 =09 */
-=09kmem_zone_free(xfs_btree_cur_zone, cur);
+=09kmem_cache_free(xfs_btree_cur_zone, cur);
 }
=20
 /*
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 46b1c3fb305c..c5c0b73febae 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -107,7 +107,7 @@ xfs_da_state_free(xfs_da_state_t *state)
 #ifdef DEBUG
 =09memset((char *)state, 0, sizeof(*state));
 #endif /* DEBUG */
-=09kmem_zone_free(xfs_da_state_zone, state);
+=09kmem_cache_free(xfs_da_state_zone, state);
 }
=20
 void
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.=
c
index 15d6f947620f..ad2b9c313fd2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -120,10 +120,10 @@ xfs_iformat_fork(
 =09=09break;
 =09}
 =09if (error) {
-=09=09kmem_zone_free(xfs_ifork_zone, ip->i_afp);
+=09=09kmem_cache_free(xfs_ifork_zone, ip->i_afp);
 =09=09ip->i_afp =3D NULL;
 =09=09if (ip->i_cowfp)
-=09=09=09kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+=09=09=09kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
 =09=09ip->i_cowfp =3D NULL;
 =09=09xfs_idestroy_fork(ip, XFS_DATA_FORK);
 =09}
@@ -531,10 +531,10 @@ xfs_idestroy_fork(
 =09}
=20
 =09if (whichfork =3D=3D XFS_ATTR_FORK) {
-=09=09kmem_zone_free(xfs_ifork_zone, ip->i_afp);
+=09=09kmem_cache_free(xfs_ifork_zone, ip->i_afp);
 =09=09ip->i_afp =3D NULL;
 =09} else if (whichfork =3D=3D XFS_COW_FORK) {
-=09=09kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+=09=09kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
 =09=09ip->i_cowfp =3D NULL;
 =09}
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 243e5e0f82a3..ee6f4229cebc 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -35,7 +35,7 @@ void
 xfs_bui_item_free(
 =09struct xfs_bui_log_item=09*buip)
 {
-=09kmem_zone_free(xfs_bui_zone, buip);
+=09kmem_cache_free(xfs_bui_zone, buip);
 }
=20
 /*
@@ -201,7 +201,7 @@ xfs_bud_item_release(
 =09struct xfs_bud_log_item=09*budp =3D BUD_ITEM(lip);
=20
 =09xfs_bui_release(budp->bud_buip);
-=09kmem_zone_free(xfs_bud_zone, budp);
+=09kmem_cache_free(xfs_bud_zone, budp);
 }
=20
 static const struct xfs_item_ops xfs_bud_item_ops =3D {
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ccccfb792ff8..a0229c368e78 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -238,7 +238,7 @@ _xfs_buf_alloc(
 =09 */
 =09error =3D xfs_buf_get_maps(bp, nmaps);
 =09if (error)  {
-=09=09kmem_zone_free(xfs_buf_zone, bp);
+=09=09kmem_cache_free(xfs_buf_zone, bp);
 =09=09return NULL;
 =09}
=20
@@ -328,7 +328,7 @@ xfs_buf_free(
 =09=09kmem_free(bp->b_addr);
 =09_xfs_buf_free_pages(bp);
 =09xfs_buf_free_maps(bp);
-=09kmem_zone_free(xfs_buf_zone, bp);
+=09kmem_cache_free(xfs_buf_zone, bp);
 }
=20
 /*
@@ -949,7 +949,7 @@ xfs_buf_get_uncached(
 =09_xfs_buf_free_pages(bp);
  fail_free_buf:
 =09xfs_buf_free_maps(bp);
-=09kmem_zone_free(xfs_buf_zone, bp);
+=09kmem_cache_free(xfs_buf_zone, bp);
  fail:
 =09return NULL;
 }
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 6b69e6137b2b..3458a1264a3f 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -763,7 +763,7 @@ xfs_buf_item_init(
 =09error =3D xfs_buf_item_get_format(bip, bp->b_map_count);
 =09ASSERT(error =3D=3D 0);
 =09if (error) {=09/* to stop gcc throwing set-but-unused warnings */
-=09=09kmem_zone_free(xfs_buf_item_zone, bip);
+=09=09kmem_cache_free(xfs_buf_item_zone, bip);
 =09=09return error;
 =09}
=20
@@ -939,7 +939,7 @@ xfs_buf_item_free(
 {
 =09xfs_buf_item_free_format(bip);
 =09kmem_free(bip->bli_item.li_lv_shadow);
-=09kmem_zone_free(xfs_buf_item_zone, bip);
+=09kmem_cache_free(xfs_buf_item_zone, bip);
 }
=20
 /*
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4f969d94fb74..153815bf18fc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -56,7 +56,7 @@ xfs_qm_dqdestroy(
 =09mutex_destroy(&dqp->q_qlock);
=20
 =09XFS_STATS_DEC(dqp->q_mount, xs_qm_dquot);
-=09kmem_zone_free(xfs_qm_dqzone, dqp);
+=09kmem_cache_free(xfs_qm_dqzone, dqp);
 }
=20
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a05a1074e8f8..6ea847f6e298 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -39,7 +39,7 @@ xfs_efi_item_free(
 =09if (efip->efi_format.efi_nextents > XFS_EFI_MAX_FAST_EXTENTS)
 =09=09kmem_free(efip);
 =09else
-=09=09kmem_zone_free(xfs_efi_zone, efip);
+=09=09kmem_cache_free(xfs_efi_zone, efip);
 }
=20
 /*
@@ -244,7 +244,7 @@ xfs_efd_item_free(struct xfs_efd_log_item *efdp)
 =09if (efdp->efd_format.efd_nextents > XFS_EFD_MAX_FAST_EXTENTS)
 =09=09kmem_free(efdp);
 =09else
-=09=09kmem_zone_free(xfs_efd_zone, efdp);
+=09=09kmem_cache_free(xfs_efd_zone, efdp);
 }
=20
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 944add5ff8e0..950e8a51ec66 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -44,7 +44,7 @@ xfs_inode_alloc(
 =09if (!ip)
 =09=09return NULL;
 =09if (inode_init_always(mp->m_super, VFS_I(ip))) {
-=09=09kmem_zone_free(xfs_inode_zone, ip);
+=09=09kmem_cache_free(xfs_inode_zone, ip);
 =09=09return NULL;
 =09}
=20
@@ -104,7 +104,7 @@ xfs_inode_free_callback(
 =09=09ip->i_itemp =3D NULL;
 =09}
=20
-=09kmem_zone_free(xfs_inode_zone, ip);
+=09kmem_cache_free(xfs_inode_zone, ip);
 }
=20
 static void
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 3ebd1b7f49d8..490fee22b878 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -55,7 +55,7 @@ STATIC void
 xfs_icreate_item_release(
 =09struct xfs_log_item=09*lip)
 {
-=09kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
+=09kmem_cache_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
=20
 static const struct xfs_item_ops xfs_icreate_item_ops =3D {
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 726aa3bfd6e8..3a62976291a1 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -667,7 +667,7 @@ xfs_inode_item_destroy(
 =09xfs_inode_t=09*ip)
 {
 =09kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
-=09kmem_zone_free(xfs_ili_zone, ip->i_itemp);
+=09kmem_cache_free(xfs_ili_zone, ip->i_itemp);
 }
=20
=20
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3806674090ed..6a147c63a8a6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3468,7 +3468,7 @@ xfs_log_ticket_put(
 {
 =09ASSERT(atomic_read(&ticket->t_ref) > 0);
 =09if (atomic_dec_and_test(&ticket->t_ref))
-=09=09kmem_zone_free(xfs_log_ticket_zone, ticket);
+=09=09kmem_cache_free(xfs_log_ticket_zone, ticket);
 }
=20
 xlog_ticket_t *
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d5708d40ad87..8eeed73928cd 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -34,7 +34,7 @@ xfs_cui_item_free(
 =09if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
 =09=09kmem_free(cuip);
 =09else
-=09=09kmem_zone_free(xfs_cui_zone, cuip);
+=09=09kmem_cache_free(xfs_cui_zone, cuip);
 }
=20
 /*
@@ -206,7 +206,7 @@ xfs_cud_item_release(
 =09struct xfs_cud_log_item=09*cudp =3D CUD_ITEM(lip);
=20
 =09xfs_cui_release(cudp->cud_cuip);
-=09kmem_zone_free(xfs_cud_zone, cudp);
+=09kmem_cache_free(xfs_cud_zone, cudp);
 }
=20
 static const struct xfs_item_ops xfs_cud_item_ops =3D {
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 02f84d9a511c..4911b68f95dd 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -34,7 +34,7 @@ xfs_rui_item_free(
 =09if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
 =09=09kmem_free(ruip);
 =09else
-=09=09kmem_zone_free(xfs_rui_zone, ruip);
+=09=09kmem_cache_free(xfs_rui_zone, ruip);
 }
=20
 /*
@@ -229,7 +229,7 @@ xfs_rud_item_release(
 =09struct xfs_rud_log_item=09*rudp =3D RUD_ITEM(lip);
=20
 =09xfs_rui_release(rudp->rud_ruip);
-=09kmem_zone_free(xfs_rud_zone, rudp);
+=09kmem_cache_free(xfs_rud_zone, rudp);
 }
=20
 static const struct xfs_item_ops xfs_rud_item_ops =3D {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f4795fdb7389..3b208f9a865c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -71,7 +71,7 @@ xfs_trans_free(
 =09if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 =09=09sb_end_intwrite(tp->t_mountp->m_super);
 =09xfs_trans_free_dqinfo(tp);
-=09kmem_zone_free(xfs_trans_zone, tp);
+=09kmem_cache_free(xfs_trans_zone, tp);
 }
=20
 /*
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 16457465833b..ff1c326826d3 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -872,6 +872,6 @@ xfs_trans_free_dqinfo(
 {
 =09if (!tp->t_dqinfo)
 =09=09return;
-=09kmem_zone_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
+=09kmem_cache_free(xfs_qm_dqtrxzone, tp->t_dqinfo);
 =09tp->t_dqinfo =3D NULL;
 }
--=20
2.23.0


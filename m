Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB91C43141
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 20:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E35206F0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 20:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChglT0hz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfKNUKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 15:10:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34631 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbfKNUKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 15:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573762202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8stSM4frYIbRPVanfdc/SYFDQDYGqN5WdmXU7XGsHT8=;
        b=ChglT0hzOr86oZAsxQFGhbn28duHc1KABeQNUC6ZLBwtLDq0FmXU49rrxRKl5ISaXz/boX
        bHcRCk0KP+QJUfs8e6nMzKMRHpU9wBOhesLbw6YFjJHbwRfX+e6LxJvFtZqFsin1qBhyDy
        6+aryaAYxYapH08f9h9tKV6rfbjCkbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-mvt0bwmAN16L4N5W9vdg6w-1; Thu, 14 Nov 2019 15:10:01 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD9BF1080F17
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 20:10:00 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F48A17F22
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2019 20:09:59 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: Remove kmem_zone_destroy() wrapper
Date:   Thu, 14 Nov 2019 21:09:53 +0100
Message-Id: <20191114200955.1365926-3-cmaiolino@redhat.com>
In-Reply-To: <20191114200955.1365926-1-cmaiolino@redhat.com>
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: mvt0bwmAN16L4N5W9vdg6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kmem_cache_destroy directly

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.h      |  6 ----
 fs/xfs/xfs_buf.c   |  2 +-
 fs/xfs/xfs_dquot.c |  6 ++--
 fs/xfs/xfs_super.c | 70 +++++++++++++++++++++++-----------------------
 4 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 15c5800128b3..70ed74c7f37e 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -87,12 +87,6 @@ kmem_zone_free(kmem_zone_t *zone, void *ptr)
 =09kmem_cache_free(zone, ptr);
 }
=20
-static inline void
-kmem_zone_destroy(kmem_zone_t *zone)
-{
-=09kmem_cache_destroy(zone);
-}
-
 extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
=20
 static inline void *
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3741f5b369de..ccccfb792ff8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2075,7 +2075,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-=09kmem_zone_destroy(xfs_buf_zone);
+=09kmem_cache_destroy(xfs_buf_zone);
 }
=20
 void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 90dd1623de5a..4f969d94fb74 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1226,7 +1226,7 @@ xfs_qm_init(void)
 =09return 0;
=20
 out_free_dqzone:
-=09kmem_zone_destroy(xfs_qm_dqzone);
+=09kmem_cache_destroy(xfs_qm_dqzone);
 out:
 =09return -ENOMEM;
 }
@@ -1234,8 +1234,8 @@ xfs_qm_init(void)
 void
 xfs_qm_exit(void)
 {
-=09kmem_zone_destroy(xfs_qm_dqtrxzone);
-=09kmem_zone_destroy(xfs_qm_dqzone);
+=09kmem_cache_destroy(xfs_qm_dqtrxzone);
+=09kmem_cache_destroy(xfs_qm_dqzone);
 }
=20
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d3c3f7b5bdcf..d9ae27ddf253 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1921,39 +1921,39 @@ xfs_init_zones(void)
 =09return 0;
=20
  out_destroy_bud_zone:
-=09kmem_zone_destroy(xfs_bud_zone);
+=09kmem_cache_destroy(xfs_bud_zone);
  out_destroy_cui_zone:
-=09kmem_zone_destroy(xfs_cui_zone);
+=09kmem_cache_destroy(xfs_cui_zone);
  out_destroy_cud_zone:
-=09kmem_zone_destroy(xfs_cud_zone);
+=09kmem_cache_destroy(xfs_cud_zone);
  out_destroy_rui_zone:
-=09kmem_zone_destroy(xfs_rui_zone);
+=09kmem_cache_destroy(xfs_rui_zone);
  out_destroy_rud_zone:
-=09kmem_zone_destroy(xfs_rud_zone);
+=09kmem_cache_destroy(xfs_rud_zone);
  out_destroy_icreate_zone:
-=09kmem_zone_destroy(xfs_icreate_zone);
+=09kmem_cache_destroy(xfs_icreate_zone);
  out_destroy_ili_zone:
-=09kmem_zone_destroy(xfs_ili_zone);
+=09kmem_cache_destroy(xfs_ili_zone);
  out_destroy_inode_zone:
-=09kmem_zone_destroy(xfs_inode_zone);
+=09kmem_cache_destroy(xfs_inode_zone);
  out_destroy_efi_zone:
-=09kmem_zone_destroy(xfs_efi_zone);
+=09kmem_cache_destroy(xfs_efi_zone);
  out_destroy_efd_zone:
-=09kmem_zone_destroy(xfs_efd_zone);
+=09kmem_cache_destroy(xfs_efd_zone);
  out_destroy_buf_item_zone:
-=09kmem_zone_destroy(xfs_buf_item_zone);
+=09kmem_cache_destroy(xfs_buf_item_zone);
  out_destroy_trans_zone:
-=09kmem_zone_destroy(xfs_trans_zone);
+=09kmem_cache_destroy(xfs_trans_zone);
  out_destroy_ifork_zone:
-=09kmem_zone_destroy(xfs_ifork_zone);
+=09kmem_cache_destroy(xfs_ifork_zone);
  out_destroy_da_state_zone:
-=09kmem_zone_destroy(xfs_da_state_zone);
+=09kmem_cache_destroy(xfs_da_state_zone);
  out_destroy_btree_cur_zone:
-=09kmem_zone_destroy(xfs_btree_cur_zone);
+=09kmem_cache_destroy(xfs_btree_cur_zone);
  out_destroy_bmap_free_item_zone:
-=09kmem_zone_destroy(xfs_bmap_free_item_zone);
+=09kmem_cache_destroy(xfs_bmap_free_item_zone);
  out_destroy_log_ticket_zone:
-=09kmem_zone_destroy(xfs_log_ticket_zone);
+=09kmem_cache_destroy(xfs_log_ticket_zone);
  out:
 =09return -ENOMEM;
 }
@@ -1966,24 +1966,24 @@ xfs_destroy_zones(void)
 =09 * destroy caches.
 =09 */
 =09rcu_barrier();
-=09kmem_zone_destroy(xfs_bui_zone);
-=09kmem_zone_destroy(xfs_bud_zone);
-=09kmem_zone_destroy(xfs_cui_zone);
-=09kmem_zone_destroy(xfs_cud_zone);
-=09kmem_zone_destroy(xfs_rui_zone);
-=09kmem_zone_destroy(xfs_rud_zone);
-=09kmem_zone_destroy(xfs_icreate_zone);
-=09kmem_zone_destroy(xfs_ili_zone);
-=09kmem_zone_destroy(xfs_inode_zone);
-=09kmem_zone_destroy(xfs_efi_zone);
-=09kmem_zone_destroy(xfs_efd_zone);
-=09kmem_zone_destroy(xfs_buf_item_zone);
-=09kmem_zone_destroy(xfs_trans_zone);
-=09kmem_zone_destroy(xfs_ifork_zone);
-=09kmem_zone_destroy(xfs_da_state_zone);
-=09kmem_zone_destroy(xfs_btree_cur_zone);
-=09kmem_zone_destroy(xfs_bmap_free_item_zone);
-=09kmem_zone_destroy(xfs_log_ticket_zone);
+=09kmem_cache_destroy(xfs_bui_zone);
+=09kmem_cache_destroy(xfs_bud_zone);
+=09kmem_cache_destroy(xfs_cui_zone);
+=09kmem_cache_destroy(xfs_cud_zone);
+=09kmem_cache_destroy(xfs_rui_zone);
+=09kmem_cache_destroy(xfs_rud_zone);
+=09kmem_cache_destroy(xfs_icreate_zone);
+=09kmem_cache_destroy(xfs_ili_zone);
+=09kmem_cache_destroy(xfs_inode_zone);
+=09kmem_cache_destroy(xfs_efi_zone);
+=09kmem_cache_destroy(xfs_efd_zone);
+=09kmem_cache_destroy(xfs_buf_item_zone);
+=09kmem_cache_destroy(xfs_trans_zone);
+=09kmem_cache_destroy(xfs_ifork_zone);
+=09kmem_cache_destroy(xfs_da_state_zone);
+=09kmem_cache_destroy(xfs_btree_cur_zone);
+=09kmem_cache_destroy(xfs_bmap_free_item_zone);
+=09kmem_cache_destroy(xfs_log_ticket_zone);
 }
=20
 STATIC int __init
--=20
2.23.0


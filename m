Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AA9C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A870822429
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2wZ4NIK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbfKTKoh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:44:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57492 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728777AbfKTKoh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 05:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574246676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7iPWZ1zoT4oDJyIZ+XbxqAhioixobssbGuL/OvJjrM=;
        b=a2wZ4NIKm5W67a6NhHUSM9PS+EXV0gZIKwczpjFgmcauSsb0keg0I4bmyastK19Oy4cCHq
        y1c6abEld9Ux6IWugtckOCNMJtI7fIMshK1A2VPaSW+cm69wkPpvDOSZaW/IdLZvzjmlPC
        vWKpqZcdffG1/wps0zJGvAuAbJznmAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-qYmhBsTOMY2r5MytncSVQw-1; Wed, 20 Nov 2019 05:44:35 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68E298024C3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:34 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-164.brq.redhat.com [10.40.204.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0F1E6726C
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:33 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2 2/5] xfs: Remove kmem_zone_alloc() wrapper
Date:   Wed, 20 Nov 2019 11:44:22 +0100
Message-Id: <20191120104425.407213-3-cmaiolino@redhat.com>
In-Reply-To: <20191120104425.407213-1-cmaiolino@redhat.com>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: qYmhBsTOMY2r5MytncSVQw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

__GFP_NOFAIL can be used for an infinite retry + congestion_wait, so we
can use kmem_cache_alloc() directly.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
=09- Rephrase commit log to explain why it's ok to remove the retry
=09  loop from kmem_zone_alloc().

 fs/xfs/kmem.c             | 21 ---------------------
 fs/xfs/kmem.h             |  2 --
 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
 fs/xfs/xfs_icache.c       |  2 +-
 fs/xfs/xfs_trace.h        |  1 -
 6 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 1da94237a8cf..2644fdaa0549 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -115,24 +115,3 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_f=
lags_t flags)
 =09=09congestion_wait(BLK_RW_ASYNC, HZ/50);
 =09} while (1);
 }
-
-void *
-kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
-{
-=09int=09retries =3D 0;
-=09gfp_t=09lflags =3D kmem_flags_convert(flags);
-=09void=09*ptr;
-
-=09trace_kmem_zone_alloc(kmem_cache_size(zone), flags, _RET_IP_);
-=09do {
-=09=09ptr =3D kmem_cache_alloc(zone, lflags);
-=09=09if (ptr || (flags & KM_MAYFAIL))
-=09=09=09return ptr;
-=09=09if (!(++retries % 100))
-=09=09=09xfs_err(NULL,
-=09=09"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
-=09=09=09=09current->comm, current->pid,
-=09=09=09=09__func__, lflags);
-=09=09congestion_wait(BLK_RW_ASYNC, HZ/50);
-=09} while (1);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 3242de676808..7e4ad73771ce 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -76,8 +76,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 #define kmem_zone=09kmem_cache
 #define kmem_zone_t=09struct kmem_cache
=20
-extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
-
 static inline struct page *
 kmem_to_page(void *addr)
 {
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 675613c7bacb..42cae87bdd2d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2351,7 +2351,8 @@ xfs_defer_agfl_block(
 =09ASSERT(xfs_bmap_free_item_zone !=3D NULL);
 =09ASSERT(oinfo !=3D NULL);
=20
-=09new =3D kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
+=09new =3D kmem_cache_alloc(xfs_bmap_free_item_zone,
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
 =09new->xefi_startblock =3D XFS_AGB_TO_FSB(mp, agno, agbno);
 =09new->xefi_blockcount =3D 1;
 =09new->xefi_oinfo =3D *oinfo;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9fbdca183465..37596e49b92e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -554,7 +554,8 @@ __xfs_bmap_add_free(
 #endif
 =09ASSERT(xfs_bmap_free_item_zone !=3D NULL);
=20
-=09new =3D kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
+=09new =3D kmem_cache_alloc(xfs_bmap_free_item_zone,
+=09=09=09       GFP_KERNEL | __GFP_NOFAIL);
 =09new->xefi_startblock =3D bno;
 =09new->xefi_blockcount =3D (xfs_extlen_t)len;
 =09if (oinfo)
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 950e8a51ec66..985f48e3795f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -40,7 +40,7 @@ xfs_inode_alloc(
 =09 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
 =09 * code up to do this anyway.
 =09 */
-=09ip =3D kmem_zone_alloc(xfs_inode_zone, 0);
+=09ip =3D kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
 =09if (!ip)
 =09=09return NULL;
 =09if (inode_init_always(mp->m_super, VFS_I(ip))) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c13bb3655e48..192f499ccd7e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3571,7 +3571,6 @@ DEFINE_KMEM_EVENT(kmem_alloc);
 DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
-DEFINE_KMEM_EVENT(kmem_zone_alloc);
=20
 #endif /* _TRACE_XFS_H */
=20
--=20
2.23.0


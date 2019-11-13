Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA330C17442
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B4D222C9
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZPr/9Sc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKMOX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727542AbfKMOX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Towf53ptrEqnsIv0OY2h1+es/G4e+qZyfojxBLUewys=;
        b=hZPr/9ScoiqikWhFfanl/PAPEidewV6fopYvi6AMDhKSGc/NRKH6cPVeV2/3OTf/U9DUcU
        erX7qCI8iFq79l8ZKRDMveSGyx+qHmF9DC9+CMzD6KYdolF9UBX8rSOw1tQLXK5EyNOArH
        QdgcDaPd6VE182tbPhuQ9qtOTO1kxkw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-xi4g4ES-MM-K4iwg198jJA-1; Wed, 13 Nov 2019 09:23:52 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E14A1102CB91
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:51 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 470D94D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:51 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/11] xfs: Remove kmem_realloc
Date:   Wed, 13 Nov 2019 15:23:31 +0100
Message-Id: <20191113142335.1045631-8-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: xi4g4ES-MM-K4iwg198jJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can use krealloc() with __GFP_NOFAIL directly

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c                  | 22 ----------------------
 fs/xfs/kmem.h                  |  1 -
 fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_mount.c             |  4 ++--
 6 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 2644fdaa0549..6e10e565632c 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -93,25 +93,3 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 =09=09return ptr;
 =09return __kmem_vmalloc(size, flags);
 }
-
-void *
-kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
-{
-=09int=09retries =3D 0;
-=09gfp_t=09lflags =3D kmem_flags_convert(flags);
-=09void=09*ptr;
-
-=09trace_kmem_realloc(newsize, flags, _RET_IP_);
-
-=09do {
-=09=09ptr =3D krealloc(old, newsize, lflags);
-=09=09if (ptr || (flags & KM_MAYFAIL))
-=09=09=09return ptr;
-=09=09if (!(++retries % 100))
-=09=09=09xfs_err(NULL,
-=09"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)"=
,
-=09=09=09=09current->comm, current->pid,
-=09=09=09=09newsize, __func__, lflags);
-=09=09congestion_wait(BLK_RW_ASYNC, HZ/50);
-=09} while (1);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 46c8c5546674..18b62eee3177 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -55,7 +55,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t fla=
gs);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
-extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
 {
 =09kvfree(ptr);
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index f2005671e86c..a929ea0b09b7 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -607,7 +607,7 @@ xfs_iext_realloc_root(
 =09if (new_size / sizeof(struct xfs_iext_rec) =3D=3D RECS_PER_LEAF)
 =09=09new_size =3D NODE_SIZE;
=20
-=09new =3D kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
+=09new =3D krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL)=
;
 =09memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
 =09ifp->if_u1.if_root =3D new;
 =09cur->leaf =3D new;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.=
c
index 2bffaa31d62a..34c336f45796 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -387,8 +387,8 @@ xfs_iroot_realloc(
 =09=09cur_max =3D xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 =09=09new_max =3D cur_max + rec_diff;
 =09=09new_size =3D XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-=09=09ifp->if_broot =3D kmem_realloc(ifp->if_broot, new_size,
-=09=09=09=09KM_NOFS);
+=09=09ifp->if_broot =3D krealloc(ifp->if_broot, new_size,
+=09=09=09=09GFP_NOFS | __GFP_NOFAIL);
 =09=09op =3D (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 =09=09=09=09=09=09     ifp->if_broot_bytes);
 =09=09np =3D (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -497,8 +497,8 @@ xfs_idata_realloc(
 =09 * in size so that it can be logged and stay on word boundaries.
 =09 * We enforce that here.
 =09 */
-=09ifp->if_u1.if_data =3D kmem_realloc(ifp->if_u1.if_data,
-=09=09=09roundup(new_size, 4), KM_NOFS);
+=09ifp->if_u1.if_data =3D krealloc(ifp->if_u1.if_data, roundup(new_size, 4=
),
+=09=09=09=09      GFP_NOFS | __GFP_NOFAIL);
 =09ifp->if_bytes =3D new_size;
 }
=20
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bc5c0aef051c..a7f1dcecc640 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4211,7 +4211,7 @@ xlog_recover_add_to_cont_trans(
 =09old_ptr =3D item->ri_buf[item->ri_cnt-1].i_addr;
 =09old_len =3D item->ri_buf[item->ri_cnt-1].i_len;
=20
-=09ptr =3D kmem_realloc(old_ptr, len + old_len, 0);
+=09ptr =3D krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
 =09memcpy(&ptr[old_len], dp, len);
 =09item->ri_buf[item->ri_cnt-1].i_len +=3D len;
 =09item->ri_buf[item->ri_cnt-1].i_addr =3D ptr;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 91a5354f20fb..a14046314c1f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -80,9 +80,9 @@ xfs_uuid_mount(
 =09}
=20
 =09if (hole < 0) {
-=09=09xfs_uuid_table =3D kmem_realloc(xfs_uuid_table,
+=09=09xfs_uuid_table =3D krealloc(xfs_uuid_table,
 =09=09=09(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-=09=09=090);
+=09=09=09GFP_KERNEL | __GFP_NOFAIL);
 =09=09hole =3D xfs_uuid_table_size++;
 =09}
 =09xfs_uuid_table[hole] =3D *uuid;
--=20
2.23.0


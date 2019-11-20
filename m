Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68B0C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A851522440
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 10:44:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUWKRov1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfKTKol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:44:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728813AbfKTKol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 05:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574246680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z4NIDg+hTSGhNG5A3c4Bezq3Z58+W0BD7Dmh4e8dKVM=;
        b=CUWKRov1qLXsEnTgMhsr+w6CrwQ3ywvgHf027v9G/JzrLoZUPTqJ9NL7s2jxAbU46E32+m
        XLZDlfL2DVvOX0thBweK95aDP5iiHaimyDFuOK8ysZ525eyYR9rknwnOLfKuFkDhe0Vu/k
        TeYOeifYPr6MexgUrT8W1JLdRxdA0wY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-nyLvrqHuMam4PX-78KPm8w-1; Wed, 20 Nov 2019 05:44:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA0C107ACC4
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:37 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-164.brq.redhat.com [10.40.204.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 358BC66D4D
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2019 10:44:37 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: Remove kmem_realloc
Date:   Wed, 20 Nov 2019 11:44:24 +0100
Message-Id: <20191120104425.407213-5-cmaiolino@redhat.com>
In-Reply-To: <20191120104425.407213-1-cmaiolino@redhat.com>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: nyLvrqHuMam4PX-78KPm8w-1
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
V2:
=09- Fix small conflict in kmem.h due removal of kmem_free()
=09- Small comment update on xfs_iroot_realloc()

 fs/xfs/kmem.c                  | 22 ----------------------
 fs/xfs/kmem.h                  |  1 -
 fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 10 +++++-----
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_mount.c             |  4 ++--
 6 files changed, 9 insertions(+), 32 deletions(-)

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
index b9ee67fa747b..a18c27c99721 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -55,7 +55,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t fla=
gs);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
-extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
=20
 static inline void *
 kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index e75e7c021187..78c9f6c7a36a 100644
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
index ceb322c7105e..82799dddf97d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -380,15 +380,15 @@ xfs_iroot_realloc(
=20
 =09=09/*
 =09=09 * If there is already an existing if_broot, then we need
-=09=09 * to realloc() it and shift the pointers to their new
+=09=09 * to krealloc() it and shift the pointers to their new
 =09=09 * location.  The records don't change location because
 =09=09 * they are kept butted up against the btree block header.
 =09=09 */
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
index cb02deb5dedc..5423171e0b7d 100644
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
index c352567c8ef5..12a1cdf8e292 100644
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


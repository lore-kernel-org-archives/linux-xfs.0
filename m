Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B33EC1744A
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B5A5222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:23:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZENO1lWj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfKMOX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:23:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727578AbfKMOX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLuo1Do5wfqp2XuwnOkr6ZHc0JTGJJKIP4rxk5RSiro=;
        b=ZENO1lWj0m0UWtIlc0xO54OnjBB+nvkPlkoND5QqDzZcnbVwS6Cq/3hylGRAVCrx4TWJFx
        ZaeCVZ+AgrzLXgylCORAQMRuEwiDgrVjH6x4bSB1/FY4ZJRcixu+0pJoIlLqZR2riHEOO0
        rPd28VmxVoWsppSMTRnVYAkXI93tmV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-sXwqSnNtN0eoPFt6iKLPNA-1; Wed, 13 Nov 2019 09:23:54 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF1E7102CB91
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:53 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51C794D9E1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:53 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/11] xfs: rework kmem_alloc_{io,large} to use GFP_* flags
Date:   Wed, 13 Nov 2019 15:23:33 +0100
Message-Id: <20191113142335.1045631-10-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: sXwqSnNtN0eoPFt6iKLPNA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Pass slab flags directly to these functions

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c                 | 60 ++++-------------------------------
 fs/xfs/kmem.h                 |  8 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/scrub/attr.c           |  8 ++---
 fs/xfs/scrub/attr.h           |  3 +-
 fs/xfs/xfs_buf.c              |  7 ++--
 fs/xfs/xfs_log.c              |  2 +-
 fs/xfs/xfs_log_cil.c          |  2 +-
 fs/xfs/xfs_log_recover.c      |  3 +-
 9 files changed, 22 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 79467813d810..44145293cfc9 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -8,54 +8,6 @@
 #include "xfs_message.h"
 #include "xfs_trace.h"
=20
-static void *
-__kmem_alloc(size_t size, xfs_km_flags_t flags)
-{
-=09int=09retries =3D 0;
-=09gfp_t=09lflags =3D kmem_flags_convert(flags);
-=09void=09*ptr;
-
-=09trace_kmem_alloc(size, flags, _RET_IP_);
-
-=09do {
-=09=09ptr =3D kmalloc(size, lflags);
-=09=09if (ptr || (flags & KM_MAYFAIL))
-=09=09=09return ptr;
-=09=09if (!(++retries % 100))
-=09=09=09xfs_err(NULL,
-=09"%s(%u) possible memory allocation deadlock size %u in %s (mode:0x%x)",
-=09=09=09=09current->comm, current->pid,
-=09=09=09=09(unsigned int)size, __func__, lflags);
-=09=09congestion_wait(BLK_RW_ASYNC, HZ/50);
-=09} while (1);
-}
-
-
-/*
- * __vmalloc() will allocate data pages and auxiliary structures (e.g.
- * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context here.=
 Hence
- * we need to tell memory reclaim that we are in such a context via
- * PF_MEMALLOC_NOFS to prevent memory reclaim re-entering the filesystem h=
ere
- * and potentially deadlocking.
- */
-static void *
-__kmem_vmalloc(size_t size, xfs_km_flags_t flags)
-{
-=09unsigned nofs_flag =3D 0;
-=09void=09*ptr;
-=09gfp_t=09lflags =3D kmem_flags_convert(flags);
-
-=09if (flags & KM_NOFS)
-=09=09nofs_flag =3D memalloc_nofs_save();
-
-=09ptr =3D __vmalloc(size, lflags, PAGE_KERNEL);
-
-=09if (flags & KM_NOFS)
-=09=09memalloc_nofs_restore(nofs_flag);
-
-=09return ptr;
-}
-
 /*
  * Same as kmem_alloc_large, except we guarantee the buffer returned is al=
igned
  * to the @align_mask. We only guarantee alignment up to page size, we'll =
clamp
@@ -63,7 +15,7 @@ __kmem_vmalloc(size_t size, xfs_km_flags_t flags)
  * aligned region.
  */
 void *
-kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
+kmem_alloc_io(size_t size, int align_mask, gfp_t flags)
 {
 =09void=09*ptr;
=20
@@ -72,24 +24,24 @@ kmem_alloc_io(size_t size, int align_mask, xfs_km_flags=
_t flags)
 =09if (WARN_ON_ONCE(align_mask >=3D PAGE_SIZE))
 =09=09align_mask =3D PAGE_SIZE - 1;
=20
-=09ptr =3D __kmem_alloc(size, flags | KM_MAYFAIL);
+=09ptr =3D kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
 =09if (ptr) {
 =09=09if (!((uintptr_t)ptr & align_mask))
 =09=09=09return ptr;
 =09=09kfree(ptr);
 =09}
-=09return __kmem_vmalloc(size, flags);
+=09return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
 }
=20
 void *
-kmem_alloc_large(size_t size, xfs_km_flags_t flags)
+kmem_alloc_large(size_t size, gfp_t flags)
 {
 =09void=09*ptr;
=20
 =09trace_kmem_alloc_large(size, flags, _RET_IP_);
=20
-=09ptr =3D __kmem_alloc(size, flags | KM_MAYFAIL);
+=09ptr =3D kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
 =09if (ptr)
 =09=09return ptr;
-=09return __kmem_vmalloc(size, flags);
+=09return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
 }
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 29d02c71fb22..9249323567ce 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -52,8 +52,8 @@ kmem_flags_convert(xfs_km_flags_t flags)
 =09return lflags;
 }
=20
-extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t fla=
gs);
-extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
+extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
+extern void *kmem_alloc_large(size_t size, gfp_t);
 static inline void  kmem_free(const void *ptr)
 {
 =09kvfree(ptr);
@@ -61,9 +61,9 @@ static inline void  kmem_free(const void *ptr)
=20
=20
 static inline void *
-kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
+kmem_zalloc_large(size_t size, gfp_t flags)
 {
-=09return kmem_alloc_large(size, flags | KM_ZERO);
+=09return kmem_alloc_large(size, flags | __GFP_ZERO);
 }
=20
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e78cba993eae..d3f872460ea6 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -479,7 +479,7 @@ xfs_attr_copy_value(
 =09}
=20
 =09if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
-=09=09args->value =3D kmem_alloc_large(valuelen, 0);
+=09=09args->value =3D kmem_alloc_large(valuelen, GFP_KERNEL);
 =09=09if (!args->value)
 =09=09=09return -ENOMEM;
 =09}
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d9f0dd444b80..bc09c46f4ff2 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -29,7 +29,7 @@ int
 xchk_setup_xattr_buf(
 =09struct xfs_scrub=09*sc,
 =09size_t=09=09=09value_size,
-=09xfs_km_flags_t=09=09flags)
+=09gfp_t=09=09=09flags)
 {
 =09size_t=09=09=09sz;
 =09struct xchk_xattr_buf=09*ab =3D sc->buf;
@@ -80,7 +80,7 @@ xchk_setup_xattr(
 =09 * without the inode lock held, which means we can sleep.
 =09 */
 =09if (sc->flags & XCHK_TRY_HARDER) {
-=09=09error =3D xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, 0);
+=09=09error =3D xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, GFP_KERNEL);
 =09=09if (error)
 =09=09=09return error;
 =09}
@@ -139,7 +139,7 @@ xchk_xattr_listent(
 =09 * doesn't work, we overload the seen_enough variable to convey
 =09 * the error message back to the main scrub function.
 =09 */
-=09error =3D xchk_setup_xattr_buf(sx->sc, valuelen, KM_MAYFAIL);
+=09error =3D xchk_setup_xattr_buf(sx->sc, valuelen, GFP_KERNEL);
 =09if (error =3D=3D -ENOMEM)
 =09=09error =3D -EDEADLOCK;
 =09if (error) {
@@ -324,7 +324,7 @@ xchk_xattr_block(
 =09=09return 0;
=20
 =09/* Allocate memory for block usage checking. */
-=09error =3D xchk_setup_xattr_buf(ds->sc, 0, KM_MAYFAIL);
+=09error =3D xchk_setup_xattr_buf(ds->sc, 0, GFP_KERNEL);
 =09if (error =3D=3D -ENOMEM)
 =09=09return -EDEADLOCK;
 =09if (error)
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 13a1d2e8424d..2c27a82574cb 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -65,7 +65,6 @@ xchk_xattr_dstmap(
 =09=09=09BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
=20
-int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size,
-=09=09xfs_km_flags_t flags);
+int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size, gfp_t fl=
ags);
=20
 #endif=09/* __XFS_SCRUB_ATTR_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8a0cc7593212..678e024f7f1c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -346,15 +346,12 @@ xfs_buf_allocate_memory(
 =09unsigned short=09=09page_count, i;
 =09xfs_off_t=09=09start, end;
 =09int=09=09=09error;
-=09xfs_km_flags_t=09=09kmflag_mask =3D 0;
=20
 =09/*
 =09 * assure zeroed buffer for non-read cases.
 =09 */
-=09if (!(flags & XBF_READ)) {
-=09=09kmflag_mask |=3D KM_ZERO;
+=09if (!(flags & XBF_READ))
 =09=09gfp_mask |=3D __GFP_ZERO;
-=09}
=20
 =09/*
 =09 * for buffers that are contained within a single page, just allocate
@@ -365,7 +362,7 @@ xfs_buf_allocate_memory(
 =09if (size < PAGE_SIZE) {
 =09=09int align_mask =3D xfs_buftarg_dma_alignment(bp->b_target);
 =09=09bp->b_addr =3D kmem_alloc_io(size, align_mask,
-=09=09=09=09=09   KM_NOFS | kmflag_mask);
+=09=09=09=09=09   GFP_NOFS | __GFP_ZERO);
 =09=09if (!bp->b_addr) {
 =09=09=09/* low memory - use alloc_page loop instead */
 =09=09=09goto use_alloc_page;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 28e82d5d5943..dd65fdabf50e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1492,7 +1492,7 @@ xlog_alloc_log(
 =09=09prev_iclog =3D iclog;
=20
 =09=09iclog->ic_data =3D kmem_alloc_io(log->l_iclog_size, align_mask,
-=09=09=09=09=09=09KM_MAYFAIL | KM_ZERO);
+=09=09=09=09=09       GFP_KERNEL | __GFP_ZERO);
 =09=09if (!iclog->ic_data)
 =09=09=09goto out_free_iclog;
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index aa1b923f7293..9250b6b2f0fd 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -186,7 +186,7 @@ xlog_cil_alloc_shadow_bufs(
 =09=09=09 */
 =09=09=09kmem_free(lip->li_lv_shadow);
=20
-=09=09=09lv =3D kmem_alloc_large(buf_size, KM_NOFS);
+=09=09=09lv =3D kmem_alloc_large(buf_size, GFP_NOFS);
 =09=09=09memset(lv, 0, xlog_cil_iovec_space(niovecs));
=20
 =09=09=09lv->lv_item =3D lip;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d46240152518..76b99ebdfcd9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -127,7 +127,8 @@ xlog_alloc_buffer(
 =09if (nbblks > 1 && log->l_sectBBsize > 1)
 =09=09nbblks +=3D log->l_sectBBsize;
 =09nbblks =3D round_up(nbblks, log->l_sectBBsize);
-=09return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);
+=09return kmem_alloc_io(BBTOB(nbblks), align_mask,
+=09=09=09     GFP_KERNEL | __GFP_ZERO);
 }
=20
 /*
--=20
2.23.0


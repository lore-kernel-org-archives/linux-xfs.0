Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F35C17442
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F84222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 14:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hleTIj7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfKMOYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 09:24:00 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58755 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727559AbfKMOX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 09:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573655038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbWC5AKkO5UkYH5atxBlcNswchSvVpcUYcY0S4PPZWQ=;
        b=hleTIj7UrD0BLQZxKpfVBCNQTI9G1ljE33sDiqJ9Wabzyu1R4UP8yJwNjypyIPUKqv58VO
        3mnf3tgVZPetjWh5ozxJQ3HZNUMAexl5r85Q97gcuVjjNgxptiIASoi1BJubmhQUhxodp8
        R3+GTGLY1fIGAOYXHGkpr7WubJ82N+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-Y3GHNF19PYmIH1yBI_QoVw-1; Wed, 13 Nov 2019 09:23:57 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0575C104ED1A
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:56 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-203.brq.redhat.com [10.40.204.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DDED63742
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 14:23:55 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/11] xfs: Remove kmem_alloc_{io, large} and kmem_zalloc_large
Date:   Wed, 13 Nov 2019 15:23:35 +0100
Message-Id: <20191113142335.1045631-12-cmaiolino@redhat.com>
In-Reply-To: <20191113142335.1045631-1-cmaiolino@redhat.com>
References: <20191113142335.1045631-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Y3GHNF19PYmIH1yBI_QoVw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Getting rid of these functions, is a bit more complicated, giving the
fact they use a vmalloc fallback, and (in case of _io version) uses an
alignment check, so they have their useness.

Instead of keeping both of them, I think sharing the same function for
both cases is a more interesting idea, giving the fact they both have
the same purpose, with the only difference being the alignment check,
which can be selected by using a flag.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/kmem.c                 | 39 +++++++++++------------------------
 fs/xfs/kmem.h                 | 10 +--------
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/scrub/symlink.c        |  3 ++-
 fs/xfs/xfs_acl.c              |  3 ++-
 fs/xfs/xfs_buf.c              |  4 ++--
 fs/xfs/xfs_ioctl.c            |  8 ++++---
 fs/xfs/xfs_ioctl32.c          |  3 ++-
 fs/xfs/xfs_log.c              |  5 +++--
 fs/xfs/xfs_log_cil.c          |  2 +-
 fs/xfs/xfs_log_recover.c      |  4 ++--
 fs/xfs/xfs_rtalloc.c          |  3 ++-
 13 files changed, 36 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 44145293cfc9..bb4990970647 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -8,40 +8,25 @@
 #include "xfs_message.h"
 #include "xfs_trace.h"
=20
-/*
- * Same as kmem_alloc_large, except we guarantee the buffer returned is al=
igned
- * to the @align_mask. We only guarantee alignment up to page size, we'll =
clamp
- * alignment at page size if it is larger. vmalloc always returns a PAGE_S=
IZE
- * aligned region.
- */
 void *
-kmem_alloc_io(size_t size, int align_mask, gfp_t flags)
+xfs_kmem_alloc(size_t size, gfp_t flags, bool align, int align_mask)
 {
 =09void=09*ptr;
=20
-=09trace_kmem_alloc_io(size, flags, _RET_IP_);
-
-=09if (WARN_ON_ONCE(align_mask >=3D PAGE_SIZE))
-=09=09align_mask =3D PAGE_SIZE - 1;
-
 =09ptr =3D kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
 =09if (ptr) {
-=09=09if (!((uintptr_t)ptr & align_mask))
+=09=09if (align) {
+=09=09=09trace_kmem_alloc_io(size, flags, _RET_IP_);
+=09=09=09if (WARN_ON_ONCE(align_mask >=3D PAGE_SIZE))
+=09=09=09=09align_mask =3D PAGE_SIZE - 1;
+
+=09=09=09if (!((uintptr_t)ptr & align_mask))
+=09=09=09=09return ptr;
+=09=09=09kfree(ptr);
+=09=09} else {
+=09=09=09trace_kmem_alloc_large(size, flags, _RET_IP_);
 =09=09=09return ptr;
-=09=09kfree(ptr);
+=09=09}
 =09}
 =09return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
 }
-
-void *
-kmem_alloc_large(size_t size, gfp_t flags)
-{
-=09void=09*ptr;
-
-=09trace_kmem_alloc_large(size, flags, _RET_IP_);
-
-=09ptr =3D kmalloc(size, flags | __GFP_RETRY_MAYFAIL);
-=09if (ptr)
-=09=09return ptr;
-=09return __vmalloc(size, flags | __GFP_NOFAIL, PAGE_KERNEL);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 791e770be0eb..ee4c0152cdeb 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -15,20 +15,12 @@
  * General memory allocation interfaces
  */
=20
-extern void *kmem_alloc_io(size_t size, int align_mask, gfp_t flags);
-extern void *kmem_alloc_large(size_t size, gfp_t);
+extern void *xfs_kmem_alloc(size_t, gfp_t, bool, int);
 static inline void  kmem_free(const void *ptr)
 {
 =09kvfree(ptr);
 }
=20
-
-static inline void *
-kmem_zalloc_large(size_t size, gfp_t flags)
-{
-=09return kmem_alloc_large(size, flags | __GFP_ZERO);
-}
-
 /*
  * Zone interfaces
  */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d3f872460ea6..eeb90f63cf2e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -479,7 +479,7 @@ xfs_attr_copy_value(
 =09}
=20
 =09if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
-=09=09args->value =3D kmem_alloc_large(valuelen, GFP_KERNEL);
+=09=09args->value =3D xfs_kmem_alloc(valuelen, GFP_KERNEL, false, 0);
 =09=09if (!args->value)
 =09=09=09return -ENOMEM;
 =09}
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index bc09c46f4ff2..90239b902b47 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -57,7 +57,7 @@ xchk_setup_xattr_buf(
 =09 * Don't zero the buffer upon allocation to avoid runtime overhead.
 =09 * All users must be careful never to read uninitialized contents.
 =09 */
-=09ab =3D kmem_alloc_large(sizeof(*ab) + sz, flags);
+=09ab =3D xfs_kmem_alloc(sizeof(*ab) + sz, flags, false, 0);
 =09if (!ab)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 5641ae512c9e..78f6d0dd8f2e 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -22,7 +22,8 @@ xchk_setup_symlink(
 =09struct xfs_inode=09*ip)
 {
 =09/* Allocate the buffer without the inode lock held. */
-=09sc->buf =3D kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
+=09sc->buf =3D xfs_kmem_alloc(XFS_SYMLINK_MAXLEN + 1,
+=09=09=09=09 GFP_KERNEL | __GFP_ZERO, false, 0);
 =09if (!sc->buf)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 91693fce34a8..988598e4e07c 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -186,7 +186,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *ac=
l, int type)
 =09=09struct xfs_acl *xfs_acl;
 =09=09int len =3D XFS_ACL_MAX_SIZE(ip->i_mount);
=20
-=09=09xfs_acl =3D kmem_zalloc_large(len, 0);
+=09=09xfs_acl =3D xfs_kmem_alloc(len, GFP_KERNEL | __GFP_ZERO,
+=09=09=09=09=09 false, 0);
 =09=09if (!xfs_acl)
 =09=09=09return -ENOMEM;
=20
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 678e024f7f1c..b36e4c4d3b9a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -361,8 +361,8 @@ xfs_buf_allocate_memory(
 =09size =3D BBTOB(bp->b_length);
 =09if (size < PAGE_SIZE) {
 =09=09int align_mask =3D xfs_buftarg_dma_alignment(bp->b_target);
-=09=09bp->b_addr =3D kmem_alloc_io(size, align_mask,
-=09=09=09=09=09   GFP_NOFS | __GFP_ZERO);
+=09=09bp->b_addr =3D xfs_kmem_alloc(size, GFP_NOFS | __GFP_ZERO, true,
+=09=09=09=09=09    align_mask);
 =09=09if (!bp->b_addr) {
 =09=09=09/* low memory - use alloc_page loop instead */
 =09=09=09goto use_alloc_page;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 364961c23cd0..72e26b7ac48f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -398,7 +398,8 @@ xfs_attrlist_by_handle(
 =09if (IS_ERR(dentry))
 =09=09return PTR_ERR(dentry);
=20
-=09kbuf =3D kmem_zalloc_large(al_hreq.buflen, 0);
+=09kbuf =3D xfs_kmem_alloc(al_hreq.buflen, GFP_KERNEL | __GFP_ZERO,
+=09=09=09      false, 0);
 =09if (!kbuf)
 =09=09goto out_dput;
=20
@@ -436,7 +437,7 @@ xfs_attrmulti_attr_get(
=20
 =09if (*len > XFS_XATTR_SIZE_MAX)
 =09=09return -EINVAL;
-=09kbuf =3D kmem_zalloc_large(*len, 0);
+=09kbuf =3D xfs_kmem_alloc(*len, GFP_KERNEL | __GFP_ZERO, false, 0);
 =09if (!kbuf)
 =09=09return -ENOMEM;
=20
@@ -1756,7 +1757,8 @@ xfs_ioc_getbmap(
 =09if (bmx.bmv_count > ULONG_MAX / recsize)
 =09=09return -ENOMEM;
=20
-=09buf =3D kmem_zalloc_large(bmx.bmv_count * sizeof(*buf), 0);
+=09buf =3D xfs_kmem_alloc(bmx.bmv_count * sizeof(*buf),
+=09=09=09     GFP_KERNEL | __GFP_ZERO, false, 0);
 =09if (!buf)
 =09=09return -ENOMEM;
=20
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 3c0d518e1039..99886b1ba319 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -381,7 +381,8 @@ xfs_compat_attrlist_by_handle(
 =09=09return PTR_ERR(dentry);
=20
 =09error =3D -ENOMEM;
-=09kbuf =3D kmem_zalloc_large(al_hreq.buflen, 0);
+=09kbuf =3D xfs_kmem_alloc(al_hreq.buflen, GFP_KERNEL | __GFP_ZERO,
+=09=09=09      false, 0);
 =09if (!kbuf)
 =09=09goto out_dput;
=20
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dd65fdabf50e..c5e26080262c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1491,8 +1491,9 @@ xlog_alloc_log(
 =09=09iclog->ic_prev =3D prev_iclog;
 =09=09prev_iclog =3D iclog;
=20
-=09=09iclog->ic_data =3D kmem_alloc_io(log->l_iclog_size, align_mask,
-=09=09=09=09=09       GFP_KERNEL | __GFP_ZERO);
+=09=09iclog->ic_data =3D xfs_kmem_alloc(log->l_iclog_size,
+=09=09=09=09=09       GFP_KERNEL | __GFP_ZERO,
+=09=09=09=09=09       true, align_mask);
 =09=09if (!iclog->ic_data)
 =09=09=09goto out_free_iclog;
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9250b6b2f0fd..2585dbf653cc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -186,7 +186,7 @@ xlog_cil_alloc_shadow_bufs(
 =09=09=09 */
 =09=09=09kmem_free(lip->li_lv_shadow);
=20
-=09=09=09lv =3D kmem_alloc_large(buf_size, GFP_NOFS);
+=09=09=09lv =3D xfs_kmem_alloc(buf_size, GFP_NOFS, false, 0);
 =09=09=09memset(lv, 0, xlog_cil_iovec_space(niovecs));
=20
 =09=09=09lv->lv_item =3D lip;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 76b99ebdfcd9..3eb23f71a415 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -127,8 +127,8 @@ xlog_alloc_buffer(
 =09if (nbblks > 1 && log->l_sectBBsize > 1)
 =09=09nbblks +=3D log->l_sectBBsize;
 =09nbblks =3D round_up(nbblks, log->l_sectBBsize);
-=09return kmem_alloc_io(BBTOB(nbblks), align_mask,
-=09=09=09     GFP_KERNEL | __GFP_ZERO);
+=09return xfs_kmem_alloc(BBTOB(nbblks), GFP_KERNEL | __GFP_ZERO, true,
+=09=09=09      align_mask);
 }
=20
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 1875484123d7..b2fa5f1a6acb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -864,7 +864,8 @@ xfs_alloc_rsum_cache(
 =09 * lower bound on the minimum level with any free extents. We can
 =09 * continue without the cache if it couldn't be allocated.
 =09 */
-=09mp->m_rsum_cache =3D kmem_zalloc_large(rbmblocks, 0);
+=09mp->m_rsum_cache =3D xfs_kmem_alloc(rbmblocks, GFP_KERNEL | __GFP_ZERO,
+=09=09=09=09=09  false, 0);
 =09if (!mp->m_rsum_cache)
 =09=09xfs_warn(mp, "could not allocate realtime summary cache");
 }
--=20
2.23.0


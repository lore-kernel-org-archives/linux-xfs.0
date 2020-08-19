Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD55CC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5FB2076E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 13:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fDiHjaU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgHSNFf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Aug 2020 09:05:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728273AbgHSNA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Aug 2020 09:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597842055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2POP4PvZ4HyMWxP8eCBY7psytWLAVBtNJv6Gxgg3S9I=;
        b=fDiHjaU34J2JSumWvdcZVZEQDsl0DJjz1xVbQMB3YpPukx1NG8QoJW51/ATKb/GYFnWs0E
        E4csVEg9hrIYOlsiZUG5mXR8H6kAav6C6QMqK4KucIDJzHIHHoxgR8CM5jhTNu93E6PKZl
        IkjN4TF7Vf1bI6lBmsyWHYMuxYqyilg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-BlucDlr4O3G5NS45aMSMig-1; Wed, 19 Aug 2020 09:00:54 -0400
X-MC-Unique: BlucDlr4O3G5NS45aMSMig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BD0610054FF
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 13:00:53 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.195.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 831297A40F
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 13:00:52 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] xfs: remove kmem_realloc()
Date:   Wed, 19 Aug 2020 15:00:50 +0200
Message-Id: <20200819130050.115687-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove kmem_realloc() function and convert its users to use MM API
directly (krealloc())

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

This is essentially the same patches as the original series, just both patches
squashed together.

 fs/xfs/kmem.c                  | 22 ----------------------
 fs/xfs/kmem.h                  |  1 -
 fs/xfs/libxfs/xfs_iext_tree.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_mount.c             |  4 ++--
 fs/xfs/xfs_trace.h             |  1 -
 7 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index e841ed781a257..e986b95d94c9b 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -93,25 +93,3 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 		return ptr;
 	return __kmem_vmalloc(size, flags);
 }
-
-void *
-kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
-{
-	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
-	void	*ptr;
-
-	trace_kmem_realloc(newsize, flags, _RET_IP_);
-
-	do {
-		ptr = krealloc(old, newsize, lflags);
-		if (ptr || (flags & KM_MAYFAIL))
-			return ptr;
-		if (!(++retries % 100))
-			xfs_err(NULL,
-	"%s(%u) possible memory allocation deadlock size %zu in %s (mode:0x%x)",
-				current->comm, current->pid,
-				newsize, __func__, lflags);
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-	} while (1);
-}
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 8e8555817e6d3..fb1d066770723 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -59,7 +59,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
-extern void *kmem_realloc(const void *, size_t, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
 {
 	kvfree(ptr);
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index 52451809c4786..b4164256993d8 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -603,7 +603,7 @@ xfs_iext_realloc_root(
 	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
 		new_size = NODE_SIZE;
 
-	new = kmem_realloc(ifp->if_u1.if_root, new_size, KM_NOFS);
+	new = krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL);
 	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
 	ifp->if_u1.if_root = new;
 	cur->leaf = new;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 0cf853d42d622..7575de5cecb1f 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -386,8 +386,8 @@ xfs_iroot_realloc(
 		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				KM_NOFS);
+		ifp->if_broot = krealloc(ifp->if_broot, new_size,
+					 GFP_NOFS | __GFP_NOFAIL);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -496,8 +496,8 @@ xfs_idata_realloc(
 	 * in size so that it can be logged and stay on word boundaries.
 	 * We enforce that here.
 	 */
-	ifp->if_u1.if_data = kmem_realloc(ifp->if_u1.if_data,
-			roundup(new_size, 4), KM_NOFS);
+	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
+				      GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2ec91b2d0f46..45dca18a95204 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2097,7 +2097,7 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len + old_len, 0);
+	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c8ae49a1e99c3..0bc623c175e93 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -80,9 +80,9 @@ xfs_uuid_mount(
 	}
 
 	if (hole < 0) {
-		xfs_uuid_table = kmem_realloc(xfs_uuid_table,
+		xfs_uuid_table = krealloc(xfs_uuid_table,
 			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
-			0);
+			GFP_KERNEL | __GFP_NOFAIL);
 		hole = xfs_uuid_table_size++;
 	}
 	xfs_uuid_table[hole] = *uuid;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index abb1d859f226a..d898d7ac4dc31 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3676,7 +3676,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
 DEFINE_KMEM_EVENT(kmem_alloc);
 DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
-DEFINE_KMEM_EVENT(kmem_realloc);
 
 TRACE_EVENT(xfs_check_new_dalign,
 	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
-- 
2.26.2


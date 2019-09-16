Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86558C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 15:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6769B21848
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 15:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389285AbfIPPfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 11:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389259AbfIPPfG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 11:35:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3EC9E34CC;
        Mon, 16 Sep 2019 15:35:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-122-216.rdu2.redhat.com [10.10.122.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83DD600C1;
        Mon, 16 Sep 2019 15:35:05 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com
Subject: [PATCH] xfs: assure zeroed memory buffers for certain kmem allocations
Date:   Mon, 16 Sep 2019 10:35:04 -0500
Message-Id: <20190916153504.30809-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 16 Sep 2019 15:35:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Guarantee zeroed memory buffers for cases where potential memory
leak to disk can occur. In these cases, kmem_alloc is used and
doesn't zero the buffer, opening the possibility of information
leakage to disk.

Introduce a xfs_buf_flag, _XBF_KMZ, to indicate a request for a zeroed
buffer, and use existing infrastucture (xfs_buf_allocate_memory) to
obtain the already zeroed buffer from kernel memory.

This solution avoids the performance issue that would occur if a
wholesale change to replace kmem_alloc with kmem_zalloc was done.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_buf.c | 8 ++++++--
 fs/xfs/xfs_buf.h | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 120ef99d09e8..916a3f782950 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -345,16 +345,19 @@ xfs_buf_allocate_memory(
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
 	int			error;
+	uint			kmflag_mask = 0;
 
 	/*
 	 * for buffers that are contained within a single page, just allocate
 	 * the memory from the heap - there's no need for the complexity of
 	 * page arrays to keep allocation down to order 0.
 	 */
+	if (flags & _XBF_KMZ)
+		kmflag_mask |= KM_ZERO;
 	size = BBTOB(bp->b_length);
 	if (size < PAGE_SIZE) {
 		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
-		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
+		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS | kmflag_mask);
 		if (!bp->b_addr) {
 			/* low memory - use alloc_page loop instead */
 			goto use_alloc_page;
@@ -391,7 +394,7 @@ xfs_buf_allocate_memory(
 		struct page	*page;
 		uint		retries = 0;
 retry:
-		page = alloc_page(gfp_mask);
+		page = alloc_page(gfp_mask | kmflag_mask);
 		if (unlikely(page == NULL)) {
 			if (flags & XBF_READ_AHEAD) {
 				bp->b_page_count = i;
@@ -683,6 +686,7 @@ xfs_buf_get_map(
 	struct xfs_buf		*new_bp;
 	int			error = 0;
 
+	flags |= _XBF_KMZ;
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
 
 	switch (error) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f6ce17d8d848..416ff588240a 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -38,6 +38,7 @@
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
+#define _XBF_KMZ	 (1 << 23)/* zeroed buffer required */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -54,7 +55,8 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
+	{ _XBF_KMZ,             "KMEM_Z" }
 
 
 /*
-- 
2.21.0


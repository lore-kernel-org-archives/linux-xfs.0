Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B56C2D0F0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38C69212CC
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QKUqyAEk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbgDAPZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:25:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33776 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732728AbgDAPZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 11:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kVVew8rGFGHAlREif31tRAlmHloJtJ9UQTnFLSYD3aE=; b=QKUqyAEkTjLpm8nxKdlkg2h8+3
        3t1GovFmn72GRsoVyLm/54cWNzyo25eNE9kCvvPYPph3VPafz9q1tyunnPpS1fyOC3LbxCJy9GgVd
        gOuw2JcqOtPuWa6NKODJSKwc9wetGQsHvLE8R76ROXmyfG5tMREeVsdCY8sohJN3y2XdX8FhmCDVl
        kdGlrvPi+43arWADz1YbCMXQ8cbMYg5cUxLOIx+yIqPfdPGzGQy2pypXDVljefEtcU3nPrMKOle+A
        jDbmdbS09dZN9b0t9auq/PVrcuQQtsWdSO+DR8Jn+ShjB5qge+ISmfrX2XN/818dUyEGfjWwoFzPe
        n/xuG7xg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJfF9-0005Pd-Um; Wed, 01 Apr 2020 15:25:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     hch@infradead.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] iomap: Add iomap_iter API
Date:   Wed,  1 Apr 2020 08:25:21 -0700
Message-Id: <20200401152522.20737-2-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200401152522.20737-1-willy@infradead.org>
References: <20200401152522.20737-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

To replace the apply API

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/Makefile     |  2 +-
 fs/iomap/iter.c       | 81 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h | 24 +++++++++++++
 3 files changed, 106 insertions(+), 1 deletion(-)
 create mode 100644 fs/iomap/iter.c

diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
index eef2722d93a1..477e5e79f874 100644
--- a/fs/iomap/Makefile
+++ b/fs/iomap/Makefile
@@ -9,7 +9,7 @@ ccflags-y += -I $(srctree)/$(src)		# needed for trace events
 obj-$(CONFIG_FS_IOMAP)		+= iomap.o
 
 iomap-y				+= trace.o \
-				   apply.o \
+				   apply.o iter.o \
 				   buffered-io.o \
 				   direct-io.o \
 				   fiemap.o \
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
new file mode 100644
index 000000000000..1d668fdd928e
--- /dev/null
+++ b/fs/iomap/iter.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (c) 2016-2018 Christoph Hellwig.
+ */
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include "trace.h"
+
+/*
+ * Execute a iomap write on a segment of the mapping that spans a
+ * contiguous range of pages that have identical block mapping state.
+ *
+ * This avoids the need to map pages individually, do individual allocations
+ * for each page and most importantly avoid the need for filesystem specific
+ * locking per page. Instead, all the operations are amortised over the entire
+ * range of pages. It is assumed that the filesystems will lock whatever
+ * resources they require in the iomap_begin call, and release them in the
+ * iomap_end call.
+ */
+loff_t iomap_iter(struct iomap_iter *iter, loff_t written)
+{
+	const struct iomap_ops *ops = iter->ops;
+	struct iomap *iomap = &iter->iomap;
+	struct iomap *srcmap = &iter->srcmap;
+	loff_t end, ret = 0;
+
+	trace_iomap_apply(iter->inode, iter->pos, iter->len, iter->flags,
+			iter->ops, NULL, _RET_IP_);
+
+	if (written != IOMAP_FIRST_CALL) {
+		if (ops->iomap_end)
+			ret = ops->iomap_end(iter->inode, iter->pos,
+					iter->len, written > 0 ? written : 0,
+					iter->flags, iomap);
+		if (written < 0)
+			return written;
+		if (ret < 0)
+			return ret;
+		iter->pos += written;
+		iter->len -= written;
+	}
+
+	/*
+	 * Need to map a range from start position for length bytes. This can
+	 * span multiple pages - it is only guaranteed to return a range of a
+	 * single type of pages (e.g. all into a hole, all mapped or all
+	 * unwritten). Failure at this point has nothing to undo.
+	 *
+	 * If allocation is required for this range, reserve the space now so
+	 * that the allocation is guaranteed to succeed later on. Once we copy
+	 * the data into the page cache pages, then we cannot fail otherwise we
+	 * expose transient stale data. If the reserve fails, we can safely
+	 * back out at this point as there is nothing to undo.
+	 */
+	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len,
+			iter->flags, iomap, srcmap);
+	if (ret)
+		return ret;
+	if (WARN_ON(iomap->offset > iter->pos))
+		return -EIO;
+	if (WARN_ON(iomap->offset + iomap->length <= iter->pos))
+		return -EIO;
+	if (WARN_ON(iomap->length == 0))
+		return -EIO;
+
+	trace_iomap_apply_dstmap(iter->inode, iomap);
+	if (srcmap->type != IOMAP_HOLE)
+		trace_iomap_apply_srcmap(iter->inode, srcmap);
+
+	/*
+	 * Cut down the length to the one actually provided by the filesystem,
+	 * as it might not be able to give us the whole size that we requested.
+	 */
+	end = iomap->offset + iomap->length;
+	if (srcmap->type != IOMAP_HOLE)
+		end = min_t(loff_t, end, srcmap->offset + srcmap->length);
+	return min(iter->len, end - iter->pos);
+}
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8b09463dae0d..ec00a2268f14 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -142,6 +142,30 @@ struct iomap_ops {
 			ssize_t written, unsigned flags, struct iomap *iomap);
 };
 
+struct iomap_iter {
+	struct inode *inode;
+	const struct iomap_ops *ops;
+	loff_t pos;
+	loff_t len;
+	unsigned flags;
+	struct iomap iomap;
+	struct iomap srcmap;
+};
+
+#define DEFINE_IOMAP_ITER(name, _inode, _pos, _len, _flags, _ops)	\
+	struct iomap_iter name = {					\
+		.inode = _inode,					\
+		.ops = _ops,						\
+		.pos = _pos,						\
+		.len = _len,						\
+		.flags = _flags,					\
+	}
+
+/* Magic value for first call to iterator */
+#define IOMAP_FIRST_CALL	LLONG_MIN
+
+loff_t iomap_iter(struct iomap_iter *, loff_t written);
+
 /*
  * Main iomap iterator function.
  */
-- 
2.25.1


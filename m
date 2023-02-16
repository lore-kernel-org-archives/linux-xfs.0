Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3213EC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjBPVGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjBPVGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:06:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F57528A1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:06:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6468D60C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9669C433D2;
        Thu, 16 Feb 2023 21:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581593;
        bh=dXKEzg/qkL7Bo6qY0Np/0mImyT6jU5nEhDvtcGhA14w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=f/Ily+SfLOhmWhJZMLfR6dae58SeEWdFwSK5uHfQHp0hWQdF2xxfqqwDqrE68WKfQ
         GKVXJDrP5+/gs/S8cxrlJk0ZUv39yeXwyo1UucfC4s6GOOhoo2VHXPbDS8orY5XBCN
         i9eN3kmHjmCdIPHpcCYhORZdLjB/ZF4BnqTicBaJRdSeOG63WmUr0ku7reG5tx3LTF
         wb5aVJQPyI4mSXrvAujYdLWl5X5OHTk1QswpOYe3jj5bUyFHKT7eV1hd0DfRwf0fj1
         zpzvyFEORrmhXElxgGO94WSSlbXqUHfVFENLNCKY5QxeuzTLgBqEk56KiZ+OSYTNrb
         w+u+548/jS3Uw==
Date:   Thu, 16 Feb 2023 13:06:33 -0800
Subject: [PATCH 3/4] xfs: create a blob array data structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880720.3477371.15024482783988794017.stgit@magnolia>
In-Reply-To: <167657880680.3477371.18364607478868446486.stgit@magnolia>
References: <167657880680.3477371.18364607478868446486.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a simple 'blob array' data structure for storage of arbitrarily
sized metadata objects that will be used to reconstruct metadata.  For
the intended usage (temporarily storing extended attribute names and
values) we only have to support storing objects and retrieving them.
Use the xfile abstraction to store the attribute information in memory
that can be swapped out.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile |    2 +
 libxfs/xfblob.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfblob.h |   25 +++++++++
 libxfs/xfile.c  |   11 ++++
 libxfs/xfile.h  |    1 
 5 files changed, 187 insertions(+)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 17978006..cac0c948 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -26,6 +26,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	xfblob.h \
 	xfile.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
@@ -67,6 +68,7 @@ CFILES = cache.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfblob.c \
 	xfile.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
new file mode 100644
index 00000000..6c1c8e6f
--- /dev/null
+++ b/libxfs/xfblob.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfblob.h"
+
+/*
+ * XFS Blob Storage
+ * ================
+ * Stores and retrieves blobs using an xfile.  Objects are appended to the file
+ * and the offset is returned as a magic cookie for retrieval.
+ */
+
+#define XB_KEY_MAGIC	0xABAADDAD
+struct xb_key {
+	uint32_t		xb_magic;  /* XB_KEY_MAGIC */
+	uint32_t		xb_size;   /* size of the blob, in bytes */
+	loff_t			xb_offset; /* byte offset of this key */
+	/* blob comes after here */
+} __packed;
+
+/* Initialize a blob storage object. */
+int
+xfblob_create(
+	struct xfs_mount	*mp,
+	const char		*description,
+	struct xfblob		**blobp)
+{
+	struct xfblob		*blob;
+	struct xfile		*xfile;
+	int			error;
+
+	error = xfile_create(mp, description, &xfile);
+	if (error)
+		return error;
+
+	blob = malloc(sizeof(struct xfblob));
+	if (!blob) {
+		error = -ENOMEM;
+		goto out_xfile;
+	}
+
+	blob->xfile = xfile;
+	blob->last_offset = PAGE_SIZE;
+
+	*blobp = blob;
+	return 0;
+
+out_xfile:
+	xfile_destroy(xfile);
+	return error;
+}
+
+/* Destroy a blob storage object. */
+void
+xfblob_destroy(
+	struct xfblob	*blob)
+{
+	xfile_destroy(blob->xfile);
+	kfree(blob);
+}
+
+/* Retrieve a blob. */
+int
+xfblob_load(
+	struct xfblob	*blob,
+	xfblob_cookie	cookie,
+	void		*ptr,
+	uint32_t	size)
+{
+	struct xb_key	key;
+	int		error;
+
+	error = xfile_obj_load(blob->xfile, &key, sizeof(key), cookie);
+	if (error)
+		return error;
+
+	if (key.xb_magic != XB_KEY_MAGIC || key.xb_offset != cookie) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+	if (size < key.xb_size) {
+		ASSERT(0);
+		return -EFBIG;
+	}
+
+	return xfile_obj_load(blob->xfile, ptr, key.xb_size,
+			cookie + sizeof(key));
+}
+
+/* Store a blob. */
+int
+xfblob_store(
+	struct xfblob	*blob,
+	xfblob_cookie	*cookie,
+	const void	*ptr,
+	uint32_t	size)
+{
+	struct xb_key	key = {
+		.xb_offset = blob->last_offset,
+		.xb_magic = XB_KEY_MAGIC,
+		.xb_size = size,
+	};
+	loff_t		pos = blob->last_offset;
+	int		error;
+
+	error = xfile_obj_store(blob->xfile, &key, sizeof(key), pos);
+	if (error)
+		return error;
+
+	pos += sizeof(key);
+	error = xfile_obj_store(blob->xfile, ptr, size, pos);
+	if (error)
+		goto out_err;
+
+	*cookie = blob->last_offset;
+	blob->last_offset += sizeof(key) + size;
+	return 0;
+out_err:
+	xfile_discard(blob->xfile, blob->last_offset, sizeof(key));
+	return error;
+}
+
+/* Free a blob. */
+int
+xfblob_free(
+	struct xfblob	*blob,
+	xfblob_cookie	cookie)
+{
+	struct xb_key	key;
+	int		error;
+
+	error = xfile_obj_load(blob->xfile, &key, sizeof(key), cookie);
+	if (error)
+		return error;
+
+	if (key.xb_magic != XB_KEY_MAGIC || key.xb_offset != cookie) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+
+	xfile_discard(blob->xfile, cookie, sizeof(key) + key.xb_size);
+	return 0;
+}
diff --git a/libxfs/xfblob.h b/libxfs/xfblob.h
new file mode 100644
index 00000000..d1282810
--- /dev/null
+++ b/libxfs/xfblob.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_XFBLOB_H__
+#define __XFS_SCRUB_XFBLOB_H__
+
+struct xfblob {
+	struct xfile	*xfile;
+	loff_t		last_offset;
+};
+
+typedef loff_t		xfblob_cookie;
+
+int xfblob_create(struct xfs_mount *mp, const char *descr,
+		struct xfblob **blobp);
+void xfblob_destroy(struct xfblob *blob);
+int xfblob_load(struct xfblob *blob, xfblob_cookie cookie, void *ptr,
+		uint32_t size);
+int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, const void *ptr,
+		uint32_t size);
+int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
+
+#endif /* __XFS_SCRUB_XFBLOB_H__ */
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index f551aef5..57542507 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -222,3 +222,14 @@ xfile_dump(
 
 	return execvp("od", argv);
 }
+
+/* Discard pages backing a range of the xfile. */
+void
+xfile_discard(
+	struct xfile		*xf,
+	loff_t			pos,
+	unsigned long long	count)
+{
+	fallocate(xf->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			pos, count);
+}
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index 1389ff8f..89431f6f 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -52,5 +52,6 @@ struct xfile_stat {
 
 int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);
 int xfile_dump(struct xfile *xf);
+void xfile_discard(struct xfile *xf, loff_t pos, unsigned long long count);
 
 #endif /* __LIBXFS_XFILE_H__ */


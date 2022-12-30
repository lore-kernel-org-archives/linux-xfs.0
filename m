Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D7BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiLaAAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiLaAAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:00:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0481E3E5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1763B61CAF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77710C433D2;
        Sat, 31 Dec 2022 00:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444800;
        bh=H4Ec0dsHYplNTtoIx/qVOZabgIuoLA32Q8EJf/nouJw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DrdbtOcTgni9Lws6WWaD4oiF2mzdgIUpdMeDNKy8DvwQA/taF78yFEo2p6ILoMqTk
         +DaKbdC/5xSKxwrF7UQEO4Sr1ep3+xsNHAqrS+8802ZKvZg+uKXlDweRGulHUsHS5c
         DXqHXtLpXMF9jjK7QxoXmJeksjMUZjj9qwtVX/GDH4RVIa72lFl6ABK/DI6BULLJqE
         Z21XZ7n2nsGeVm3BczvpHlGNov+mhLNNNiAdocCa6tfOJRkJxvHp5HtThndqDEMPsr
         7CeZKIZDPHV28ZmTNx43HpkIcYDmhfICiOrvACtmRJvlI87alf71ihi37FO8AM+2kg
         JfvI/DzXU/3sg==
Subject: [PATCH 1/5] xfs: create a blob array data structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:12 -0800
Message-ID: <167243845284.700496.7818211212049308592.stgit@magnolia>
In-Reply-To: <167243845264.700496.9115810454468711427.stgit@magnolia>
References: <167243845264.700496.9115810454468711427.stgit@magnolia>
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
 fs/xfs/Makefile       |    1 
 fs/xfs/scrub/xfblob.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfblob.h |   25 ++++++++
 3 files changed, 178 insertions(+)
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0abdcc69cd7f..ac3bda492446 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -202,6 +202,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   repair.o \
 				   rmap_repair.o \
 				   tempfile.o \
+				   xfblob.o \
 				   xfbtree.o \
 				   )
 
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
new file mode 100644
index 000000000000..c3a646cad5ed
--- /dev/null
+++ b/fs/xfs/scrub/xfblob.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "scrub/scrub.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
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
+	error = xfile_create(mp, description, 0, &xfile);
+	if (error)
+		return error;
+
+	blob = kmalloc(sizeof(struct xfblob), XCHK_GFP_FLAGS);
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
+	void		*ptr,
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
diff --git a/fs/xfs/scrub/xfblob.h b/fs/xfs/scrub/xfblob.h
new file mode 100644
index 000000000000..2c1810b4a4eb
--- /dev/null
+++ b/fs/xfs/scrub/xfblob.h
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
+int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, void *ptr,
+		uint32_t size);
+int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
+
+#endif /* __XFS_SCRUB_XFBLOB_H__ */


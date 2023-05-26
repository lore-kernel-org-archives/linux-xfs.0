Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4352C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjEZC36 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjEZC35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AB913D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2287B64C4C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851D7C433D2;
        Fri, 26 May 2023 02:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068194;
        bh=E89Bk11wjPZzx86OWStcPQeU07pNbUfjnm5LVtL93J4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KFFgjxSJVUT0nvWCAbcAh8aMbGiCEvovs0DpXk8hPd+8CblUfr5LiT3prXHbeQYeW
         cSVuxlPqLxylJpfQq8Ifl/s6AJJ1Fq91ptWmUgAMK3uVxTjGVFKd7V5ZdSFmVcDz0d
         Pvl0UXFofgZKYpkL2Kb2JJLuxhLbrlaqJC7CpwYFm3KsAk6QPeA2HbvtJRD38dr30T
         U7DwhZX0JcnNaJLU+uSDNLxOd/DrzchQs1TE71XcQ4BWlC0Ba5QUvmINbuugKJNs4o
         d4eDILL92+Se3S4NjSrTG06fAyz2iQTnVUAJainq2Z8KquMkY+Wnytv9CSXcahWAH6
         n49DbEhR5AYWQ==
Date:   Thu, 25 May 2023 19:29:54 -0700
Subject: [PATCH 01/14] xfs: create a blob array data structure
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078609.3750196.9659112305237495186.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
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
index f6c7c5c010e..80bd666d356 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -27,6 +27,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	xfblob.h \
 	xfbtree.h \
 	xfile.h \
 	xfs_ag_resv.h \
@@ -71,6 +72,7 @@ CFILES = cache.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfblob.c \
 	xfbtree.c \
 	xfile.c \
 	xfs_ag.c \
diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
new file mode 100644
index 00000000000..9da97fb3a23
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
+	error = xfile_create(mp, 0, description, &xfile);
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
index 00000000000..d1282810bb1
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
index af556b9a965..3ae1a0c2ec3 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -482,3 +482,14 @@ xfile_prealloc(
 		return -errno;
 	return 0;
 }
+
+/* Discard pages backing a range of the xfile. */
+void
+xfile_discard(
+	struct xfile		*xf,
+	loff_t			pos,
+	unsigned long long	count)
+{
+	fallocate(xf->fcb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			pos, count);
+}
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
index 8bd679e7478..9294595e05f 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -61,6 +61,7 @@ struct xfile_stat {
 int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);
 unsigned long long xfile_bytes(struct xfile *xf);
 int xfile_dump(struct xfile *xf);
+void xfile_discard(struct xfile *xf, loff_t pos, unsigned long long count);
 
 static inline loff_t xfile_size(struct xfile *xf)
 {


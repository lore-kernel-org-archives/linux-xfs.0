Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CA91CA81
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000937; cv=none; b=UhHQP9wfhUpPxw9OKQCHLGXDysFUH8mIR4GZdo5H+7yf+cP+JaASDLva4xIBMW/S6IpXVp7i4ci7IvKHHy0E+c4mdtq283ByO6AgV+moGSY6vouqr37hg/EhskMuTGRp0Xg0/K/fbk2Try+Gs9XiCsLfVfUnjgbFfj9Y8PtJ8wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000937; c=relaxed/simple;
	bh=JAvAIe9qBxo03rbfSs+8AmP0KiQrV5SbRwZpZJmr+XE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9AcQtRts77xgNIo7skxJrgVsBj/T6Ejg2jm/XIyw24MsJ555tGOEd8IY3uhYC02rEV7uCBDW6OR5bfMdkGef8l/xfEgtx/Rt9bTxcbHOPd7U8a6AW7xQEjzWdcrn8warRy94nYRjwfoPdRxi1kuc8/3WPxTpRiSNBJ8Hnd8t6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oA3uRpTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oA3uRpTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AE2C433C7;
	Tue, 27 Feb 2024 02:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000937;
	bh=JAvAIe9qBxo03rbfSs+8AmP0KiQrV5SbRwZpZJmr+XE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oA3uRpTbBN564GskgVUdUtcO2sBujyrYplmuzRZ9Y5fCTTeGc1hk3tFlRrcXeKOA1
	 0fYBS3oRFIKYEGU40PjXTGfRA1pytATDqdCbobyQIU7oIsTg5kYA0iw2YSnunsJ6BB
	 btngqjIDan7tnwEGuUIGAnf8SiPH1LzLTOORkE999YjztlLJu2O+ftAb0QGawTG1c7
	 H3RcjIMZ4dgTre1+vO4S97Bx5DwX7cFRWnXtTxE2mtZyn6TvGSVPMRPwiUM3nayBC1
	 lLjN90gIyevQ+KqswKQO2Oh6f9waULek/SNyDan3i825/ufAGnwqLxyBTrSd/gZCFU
	 tJK5xSPy6a6vg==
Date: Mon, 26 Feb 2024 18:28:56 -0800
Subject: [PATCH 1/6] xfs: create a blob array data structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013644.939212.14951407608685671445.stgit@frogsfrogsfrogs>
In-Reply-To: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 fs/xfs/scrub/trace.h  |    1 
 fs/xfs/scrub/xfblob.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfblob.h |   24 ++++++++
 fs/xfs/scrub/xfile.c  |   12 ++++
 fs/xfs/scrub/xfile.h  |    1 
 6 files changed, 190 insertions(+)
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 66415ac8f5717..91af9b7f418e9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -209,6 +209,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   repair.o \
 				   rmap_repair.o \
 				   tempfile.o \
+				   xfblob.o \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5edbabacc31a8..b5fe49a6da534 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -948,6 +948,7 @@ DEFINE_XFILE_EVENT(xfile_store);
 DEFINE_XFILE_EVENT(xfile_seek_data);
 DEFINE_XFILE_EVENT(xfile_get_folio);
 DEFINE_XFILE_EVENT(xfile_put_folio);
+DEFINE_XFILE_EVENT(xfile_discard);
 
 TRACE_EVENT(xfarray_create,
 	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
new file mode 100644
index 0000000000000..cec668debce5a
--- /dev/null
+++ b/fs/xfs/scrub/xfblob.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+	const char		*description,
+	struct xfblob		**blobp)
+{
+	struct xfblob		*blob;
+	struct xfile		*xfile;
+	int			error;
+
+	error = xfile_create(description, 0, &xfile);
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
+	error = xfile_load(blob->xfile, &key, sizeof(key), cookie);
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
+	return xfile_load(blob->xfile, ptr, key.xb_size,
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
+	error = xfile_store(blob->xfile, &key, sizeof(key), pos);
+	if (error)
+		return error;
+
+	pos += sizeof(key);
+	error = xfile_store(blob->xfile, ptr, size, pos);
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
+	error = xfile_load(blob->xfile, &key, sizeof(key), cookie);
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
index 0000000000000..bd98647407f1d
--- /dev/null
+++ b/fs/xfs/scrub/xfblob.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+int xfblob_create(const char *descr, struct xfblob **blobp);
+void xfblob_destroy(struct xfblob *blob);
+int xfblob_load(struct xfblob *blob, xfblob_cookie cookie, void *ptr,
+		uint32_t size);
+int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, const void *ptr,
+		uint32_t size);
+int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
+
+#endif /* __XFS_SCRUB_XFBLOB_H__ */
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 8cdd863db5850..459e513ade464 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -310,3 +310,15 @@ xfile_put_folio(
 	folio_unlock(folio);
 	folio_put(folio);
 }
+
+/* Discard pages backing a range of the xfile. */
+void
+xfile_discard(
+	struct xfile		*xf,
+	loff_t			pos,
+	u64			count)
+{
+	trace_xfile_discard(xf, pos, count);
+
+	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
+}
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 76d78dba7e347..8dfbae1fe33a5 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -17,6 +17,7 @@ int xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
 int xfile_store(struct xfile *xf, const void *buf, size_t count,
 		loff_t pos);
 
+void xfile_discard(struct xfile *xf, loff_t pos, u64 count);
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 #define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)


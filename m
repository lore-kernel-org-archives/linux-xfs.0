Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC91DF55
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XN5iNHft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E285BC433C8;
	Sun, 31 Dec 2023 23:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064422;
	bh=04Mh2hFNut6AcbYiQTXNa3yVqeaZJt1Lz8fKZtTZTSo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XN5iNHftOXGOXxCrtf+53NQGxCetxg69kbyts43XGXewG3A0LdfgCd2tQeqtO8HPa
	 Fp15RSyWjnDfag4NYdWjFuJRKuj9VZWbMnDz2SI92gIyJGy2AOdHIWSOFntrzeX1O7
	 6eyYe7998PVzzj5ggVeCDzrFWpNm6XQ82HVBwSb2jKn7yzduNU0GO/7MkuF8pS2dH5
	 IwSJ29LSx6E/sayZ75YD+VfK20rvFT/8x6b5XwpxkLWQ9rZeftdBJLzQ3DXFDJXhdT
	 5qTj7jX2R1psJRfngQ9dXdqW2v8+kqcz06yo/CwjWw7gjlvE5odfhpJyJozb+NAFBR
	 5PeIYUWD6k+Jg==
Date: Sun, 31 Dec 2023 15:13:42 -0800
Subject: [PATCH 01/18] xfs: create a blob array data structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006876.1805510.9516362710795395789.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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
 libxfs/Makefile |    2 +
 libxfs/xfblob.c |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfblob.h |   24 +++++++++
 libxfs/xfile.c  |   11 ++++
 libxfs/xfile.h  |    1 
 5 files changed, 185 insertions(+)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index e0bdaefb209..42dce62ecf9 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -28,6 +28,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	xfblob.h \
 	xfbtree.h \
 	xfile.h \
 	xfs_ag_resv.h \
@@ -73,6 +74,7 @@ CFILES = cache.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfblob.c \
 	xfbtree.c \
 	xfile.c \
 	xfs_ag.c \
diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
new file mode 100644
index 00000000000..d826e5f3cb0
--- /dev/null
+++ b/libxfs/xfblob.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
index 00000000000..28bf4ab2898
--- /dev/null
+++ b/libxfs/xfblob.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index 7f785feb125..87362f96c43 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -479,3 +479,14 @@ xfile_prealloc(
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
index ac368432382..595a369c89e 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -61,6 +61,7 @@ struct xfile_stat {
 int xfile_stat(struct xfile *xf, struct xfile_stat *statbuf);
 unsigned long long xfile_bytes(struct xfile *xf);
 int xfile_dump(struct xfile *xf);
+void xfile_discard(struct xfile *xf, loff_t pos, unsigned long long count);
 
 static inline loff_t xfile_size(struct xfile *xf)
 {


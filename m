Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B777ABA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBMZHtYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285A6C433C7;
	Sun, 31 Dec 2023 20:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054912;
	bh=k7dBTG01g9t36WAJmN2IrVgGxemPZ8ZKDyxDjyYLjBE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lBMZHtYlaG3gNP5eZN+kTdZ0jdV+nlQ5fFcHfPJ/NZtlfVoB5V50P3NNTTEccIUFi
	 zS1DsgU2/Mm0q21UWoKYY8jffhMC1vXJbikS11uy6A26b4o1pzteBTssSLImx3J2Ls
	 TXKiQlcnpQSgxSV+QqUmFcW1L/4dgKYpfZAtbLs/3x8T2cn0vchEwJqEbl+fkAWUSG
	 7SM8A0tXCyiKlHmRzdSSpOw1V6SPW34gpGenEDgPtUd3VZf9jcRZDsBcNNV1nWX7lb
	 UG0827qRi8NjXcmJrzqkOq8giDfgrVKwBEbSbQdA3a6EirAeKZ057Nz9gNV2bUdPAU
	 ZLwz8lioWXSDg==
Date: Sun, 31 Dec 2023 12:35:11 -0800
Subject: [PATCH 1/6] xfs: create a blob array data structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404835229.1753315.13978723246161515244.stgit@frogsfrogsfrogs>
In-Reply-To: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/xfblob.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfblob.h |   24 ++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 62e38f70c304b..72df9890edcf6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -208,6 +208,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   repair.o \
 				   rmap_repair.o \
 				   tempfile.o \
+				   xfblob.o \
 				   xfbtree.o \
 				   )
 
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
new file mode 100644
index 0000000000000..216f9cb2965a7
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


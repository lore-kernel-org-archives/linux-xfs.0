Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D64157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224980; cv=none; b=WiJ2Z3xQ/kRe7klGTdBH1jNLeyrs+kdbOUPoRRPmVt0+diJLUPNADYQ396K0qckMqpAcicGDEljJXzdemMckG44MV2dxlUWl6Z/daFh5kKX8JI/PDS+/3x4+SdHTzqC+5g9sVUZ8FYRjpaRZdIFpOY1/2/YtuieDciDC/OXUE1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224980; c=relaxed/simple;
	bh=M10BK5TIsuwO+3Z599E4pURz/WEJiMSWv0HMN1XeG9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SpCQghZ33EA19zAjb+wreEBOVx/smsqDbD9Z8stqOjBe8FCdyjugjUDT63jh8Y5Fc3l8W2eg0LO+b8TKSDFxydkfC2bRkLWVHu1S0P2gEMc2iiHFrahJ5sZkQ0DnnzZGlPPpcNglqOrzPfjzOWpQznKhNHX3yYUSlmwWfEOUABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwZZN4cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwZZN4cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F326C113CC;
	Mon, 15 Apr 2024 23:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224980;
	bh=M10BK5TIsuwO+3Z599E4pURz/WEJiMSWv0HMN1XeG9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dwZZN4cryorEaYdDpqUN4x8rdnQl8shI1JbndEny5LG/rZptsTJ+3pP1dYLGjhIJr
	 z8QTP9sjpNHJ4kljSipFAV0UCUxmpw9qimwcAbYQXumSfLmTXLUyFc1UpkQ3XX/O0S
	 +CRJF4+q7p5GBns45J7dABd/7oSsL3W+GgbdS42UTQu7P5yGlQbLPRdldylzPK0S7i
	 JU3g6z50HRb7ZS3UJbMErz0XRZ72eP9yYzr3VUj2DCWyet9XUZypet1PLvHweV2xEE
	 ayDGMT2AYTeQi42FYA/52H/ampvgglLTfssjGzNSstAC2Kil6iE9OWnsUvytFLtA3S
	 wUPAhT4qpWQOA==
Date: Mon, 15 Apr 2024 16:49:39 -0700
Subject: [PATCH 2/7] xfs: create a blob array data structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383114.88776.381926659271750588.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
References: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile       |    1 
 fs/xfs/scrub/xfblob.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfblob.h |   24 ++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 fs/xfs/scrub/xfblob.c
 create mode 100644 fs/xfs/scrub/xfblob.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5e3ac7ec8fa5..bc27757702fe 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -208,6 +208,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   repair.o \
 				   rmap_repair.o \
 				   tempfile.o \
+				   xfblob.o \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/xfblob.c b/fs/xfs/scrub/xfblob.c
new file mode 100644
index 000000000000..cec668debce5
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
index 000000000000..bd98647407f1
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2A54A06
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883033; cv=none; b=eTM75Y28F78g8NuSSacWOYqBGdM1rxlRxPWgjVVnTonLRT2shEzzK4MxJCDTvWFAKsqAXg1Bt9u1yAmjvoYHea3g98Pb9kthmu9Yb0Or2u2SGPmqYQVlASri3v4oylw/PsdhJYgj8eIDWE/nPQ42LRBCZ1gDd7Pztv/1gTHePOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883033; c=relaxed/simple;
	bh=5wBwM7q5c0uzktGZXRvhqaH6uoSyhx3fdglQNPDFusk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPbQltIeileOYRbUvmv7AU05jIioYwzj1vMNRb1kLXW1Rc1poBj6hE/8gUoSza8mgGyQsj9PqiFaHOWk60IG9WLV5tKdDbHHn9r0UUr4/SkofwBO+ph8Z5J1EOCHpKK8WlOhUsuSELE+61t3smwJZAxvOi7pbBIfUGMDOXLCinw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n81iGSn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n81iGSn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02644C116B1;
	Tue,  2 Jul 2024 01:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883033;
	bh=5wBwM7q5c0uzktGZXRvhqaH6uoSyhx3fdglQNPDFusk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n81iGSn30awrm3ioHpMY/wK7hklLWESXeIX8+fCd+q0XudTAPBHiddDP2xfcIM4Rj
	 z285JWHZARd7f7zHqDtBDrlB8qgMON/dPa+LNq4VEFjzuf9GHFvJ9HEQLSpvWp97Gc
	 lvcgLR/qM3npIGFZCQJGxK9Cm6h5qsdel2RgYkQrxr1y/0zWxn4RzkXuidFygAnLPs
	 dWpecTsssyH65N6OXmltJ1N/iCZ267M5ShXAfrXMIqx3lKaLnxT56govozmXqkZe8R
	 2BRZCxWV7WH8cah84Uhwy94ZVHerEzMhyq+T3uJshvzYCE+wXKw8xhzt4P252LP6ML
	 kUONSe+eD04SQ==
Date: Mon, 01 Jul 2024 18:17:12 -0700
Subject: [PATCH 1/2] xfs: create a blob array data structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121789.2010091.5748728321001846244.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs>
References: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs>
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
index 9fb53d9cc32c..4e8f9a135818 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -28,6 +28,7 @@ HFILES = \
 	linux-err.h \
 	topology.h \
 	buf_mem.h \
+	xfblob.h \
 	xfile.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
@@ -73,6 +74,7 @@ CFILES = buf_mem.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfblob.c \
 	xfile.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
new file mode 100644
index 000000000000..7d8caaa4c164
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
diff --git a/libxfs/xfblob.h b/libxfs/xfblob.h
new file mode 100644
index 000000000000..28bf4ab2898f
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
index 6e0fa809a296..b4908b49b6d5 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -391,3 +391,14 @@ xfile_bytes(
 
 	return (unsigned long long)statbuf.st_blocks << 9;
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
index 180a42bbbaa2..7ee8b90cdf30 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -30,5 +30,6 @@ ssize_t xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
 ssize_t xfile_store(struct xfile *xf, const void *buf, size_t count, loff_t pos);
 
 unsigned long long xfile_bytes(struct xfile *xf);
+void xfile_discard(struct xfile *xf, loff_t pos, unsigned long long count);
 
 #endif /* __LIBXFS_XFILE_H__ */


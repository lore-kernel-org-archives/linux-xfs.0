Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DFE6FB0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302723; cv=none; b=DsJOsg+uO7nUu7peEsN/uuGsmqkLibB9WKRy7LGt0NDu3Id18UW18vHxH0aqjDhu+VgadwMv+ZlTnnE78P0LFSHHncEqnN7zWsmGXv8zMthw48+ev7c+0AHUy2uTM25WpXMymKWwUdO02zBfaLb/bs848NG8RjcZJ8MSrduhJkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302723; c=relaxed/simple;
	bh=P/CZ87AYeBo+x2yskXBOYKUhjRn0oAufg+hQzonC1kc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J30gQcOVoiKuPj+72aQZX5bWpFvLgofSfFGVaGaYtVX6FyKfNz52fTZdrKY9qji9ehgbrkI3Q1crxSyXHpz+0T0FmUA8/9d5XHHA9kXAQbkDIbnJw/eeoKPgdi3YuMqeRygCmdmucioMxMrfiV/XWcccQnwmyci+dkyfFbl63e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkmSK69b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkmSK69b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE083C4AF0A;
	Tue, 30 Jul 2024 01:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302723;
	bh=P/CZ87AYeBo+x2yskXBOYKUhjRn0oAufg+hQzonC1kc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WkmSK69bIUSiORH8v2R+fc6ziP4gZnJzW9ON843KVF9c78NhpJf1Q2Nv79yyvv72X
	 UXCdiB1F6obDuPgrvcWnT2V5Jy20pb+xd91Gehq+0q2bPzocNRZibTJaG+QOMlE5jW
	 zxv/2I+JluYdQynU9rgoJJrCjPGiJg4xjEX4GzJ2uq8qWzMJkjfk3t0hjHC8fvSL0P
	 Cnyx7u2ezjtKpe06+uV9tF2avfW6GZD3SAq8ys9LSO6+ONaWnT5VMHvVfrqE+KqC1F
	 yoTKssNxREd+P96QAxdtQ4QcNSlKrM5QW3T0F/cRsEMvaH2kExP73ka4fR/6ErsevC
	 C4/64MRdRBl2g==
Date: Mon, 29 Jul 2024 18:25:22 -0700
Subject: [PATCH 1/2] xfs: create a blob array data structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851153.1352400.10523994962893668509.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851139.1352400.10715918413205904955.stgit@frogsfrogsfrogs>
References: <172229851139.1352400.10715918413205904955.stgit@frogsfrogsfrogs>
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
 libxfs/Makefile |    2 +
 libxfs/xfblob.c |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfblob.h |   24 +++++++++
 libxfs/xfile.c  |   11 ++++
 libxfs/xfile.h  |    1 
 5 files changed, 185 insertions(+)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 9fb53d9cc..4e8f9a135 100644
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
index 000000000..7d8caaa4c
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
index 000000000..28bf4ab28
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
index 6e0fa809a..b4908b49b 100644
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
index 180a42bbb..7ee8b90cd 100644
--- a/libxfs/xfile.h
+++ b/libxfs/xfile.h
@@ -30,5 +30,6 @@ ssize_t xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
 ssize_t xfile_store(struct xfile *xf, const void *buf, size_t count, loff_t pos);
 
 unsigned long long xfile_bytes(struct xfile *xf);
+void xfile_discard(struct xfile *xf, loff_t pos, unsigned long long count);
 
 #endif /* __LIBXFS_XFILE_H__ */


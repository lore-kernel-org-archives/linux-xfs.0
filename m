Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750ODPi023887
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:59 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u51ptmbb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750NBd3195718
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u4ycttw2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:59 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750ZwVA012898
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:58 GMT
Subject: [PATCH 11/18] xfs: create a blob array data structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:35:57 -0700
Message-ID: <156496535750.804304.9164844655605252141.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a simple 'blob array' data structure for storage of arbitrarily
sized metadata objects that will be used to reconstruct metadata.  For
the intended usage (temporarily storing extended attribute names and
values) we only have to support storing objects and retrieving them.

This initial implementation uses linked lists to store the blobs, but a
subsequent patch will restructure the backend to avoid using high order
pinned kernel memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile     |    1 
 fs/xfs/scrub/blob.c |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/blob.h |   23 ++++++++++
 3 files changed, 145 insertions(+)
 create mode 100644 fs/xfs/scrub/blob.c
 create mode 100644 fs/xfs/scrub/blob.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e8459ab2b28d..fecde2c9d2de 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -163,6 +163,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
+				   blob.o \
 				   bmap_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
diff --git a/fs/xfs/scrub/blob.c b/fs/xfs/scrub/blob.c
new file mode 100644
index 000000000000..4928f0985d49
--- /dev/null
+++ b/fs/xfs/scrub/blob.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "scrub/array.h"
+#include "scrub/blob.h"
+
+/*
+ * XFS Blob Storage
+ * ================
+ * Stores and retrieves blobs using a list.  Objects are appended to
+ * the list and the pointer is returned as a magic cookie for retrieval.
+ */
+
+#define XB_KEY_MAGIC	0xABAADDAD
+struct xb_key {
+	struct list_head	list;
+	uint32_t		magic;
+	uint32_t		size;
+	/* blob comes after here */
+} __packed;
+
+#define XB_KEY_SIZE(sz)	(sizeof(struct xb_key) + (sz))
+
+/* Initialize a blob storage object. */
+struct xblob *
+xblob_init(void)
+{
+	struct xblob	*blob;
+	int		error;
+
+	error = -ENOMEM;
+	blob = kmem_alloc(sizeof(struct xblob), KM_NOFS | KM_MAYFAIL);
+	if (!blob)
+		return ERR_PTR(error);
+
+	INIT_LIST_HEAD(&blob->list);
+	return blob;
+}
+
+/* Destroy a blob storage object. */
+void
+xblob_destroy(
+	struct xblob	*blob)
+{
+	struct xb_key	*key, *n;
+
+	list_for_each_entry_safe(key, n, &blob->list, list) {
+		list_del(&key->list);
+		kmem_free(key);
+	}
+	kmem_free(blob);
+}
+
+/* Retrieve a blob. */
+int
+xblob_get(
+	struct xblob	*blob,
+	xblob_cookie	cookie,
+	void		*ptr,
+	uint32_t	size)
+{
+	struct xb_key	*key = (struct xb_key *)cookie;
+
+	if (key->magic != XB_KEY_MAGIC) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+	if (size < key->size) {
+		ASSERT(0);
+		return -EFBIG;
+	}
+
+	memcpy(ptr, key + 1, key->size);
+	return 0;
+}
+
+/* Store a blob. */
+int
+xblob_put(
+	struct xblob	*blob,
+	xblob_cookie	*cookie,
+	void		*ptr,
+	uint32_t	size)
+{
+	struct xb_key	*key;
+
+	key = kmem_alloc(XB_KEY_SIZE(size), KM_NOFS | KM_MAYFAIL);
+	if (!key)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&key->list);
+	list_add_tail(&key->list, &blob->list);
+	key->magic = XB_KEY_MAGIC;
+	key->size = size;
+	memcpy(key + 1, ptr, size);
+	*cookie = (xblob_cookie)key;
+	return 0;
+}
+
+/* Free a blob. */
+int
+xblob_free(
+	struct xblob	*blob,
+	xblob_cookie	cookie)
+{
+	struct xb_key	*key = (struct xb_key *)cookie;
+
+	if (key->magic != XB_KEY_MAGIC) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+	key->magic = 0;
+	list_del(&key->list);
+	kmem_free(key);
+	return 0;
+}
diff --git a/fs/xfs/scrub/blob.h b/fs/xfs/scrub/blob.h
new file mode 100644
index 000000000000..2595a15f78ac
--- /dev/null
+++ b/fs/xfs/scrub/blob.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_BLOB_H__
+#define __XFS_SCRUB_BLOB_H__
+
+struct xblob {
+	struct list_head	list;
+};
+
+typedef void			*xblob_cookie;
+
+struct xblob *xblob_init(void);
+void xblob_destroy(struct xblob *blob);
+int xblob_get(struct xblob *blob, xblob_cookie cookie, void *ptr,
+		uint32_t size);
+int xblob_put(struct xblob *blob, xblob_cookie *cookie, void *ptr,
+		uint32_t size);
+int xblob_free(struct xblob *blob, xblob_cookie cookie);
+
+#endif /* __XFS_SCRUB_BLOB_H__ */

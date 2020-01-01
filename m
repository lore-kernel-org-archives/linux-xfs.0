Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06801C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB8D8206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QDp1Hiio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABD4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:03:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45900 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgAABD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:03:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00110Qhu086424
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OeKu3kHXIYJsM3Fw3KViKttF8lsTwX8Ks+rTEUu2kv8=;
 b=QDp1Hiio009ztwR+Be7uuIPl8yNnV0JyLhSRE0eimiZidE+PvQFhk68TFKah/or2vX/m
 qp6hHFdy0Q3uGc6+7qe3/HLG1JiJSAvzx+E67gQPb/N5CJk323shLn8iohhKp3Gh+bqX
 hsjOZTMw4ob1tYFUNLeEONlhCsM4waNpbV9ppxxQWD3JF1XtqjHdbNQteh/2kZtRRp6m
 I3nGN5dsJRnqNlk/eoVmAIoqd5kNigwbzYgg53DsHpUjLkco/JJUrX/GtkwBz10hhJ0E
 n+LxJc8DgI2V5WWvLMjrIexmanDv2cOh1OIJxSCr+pb/4StMmb2C8quEhUvXe9813Fin sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wS7U026822
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x7medf883-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:54 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00113rsh024181
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:53 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:03:53 -0800
Subject: [PATCH 1/6] xfs: create a blob array data structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:03:51 -0800
Message-ID: <157784063150.1358958.7393395703261474596.stgit@magnolia>
In-Reply-To: <157784062523.1358958.17318700801044648140.stgit@magnolia>
References: <157784062523.1358958.17318700801044648140.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a simple 'blob array' data structure for storage of arbitrarily
sized metadata objects that will be used to reconstruct metadata.  For
the intended usage (temporarily storing extended attribute names and
values) we only have to support storing objects and retrieving them.
Use the xfile abstraction to store the attribute information in memory
that can be swapped out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile     |    1 
 fs/xfs/scrub/blob.c |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/blob.h |   24 ++++++++
 3 files changed, 170 insertions(+)
 create mode 100644 fs/xfs/scrub/blob.c
 create mode 100644 fs/xfs/scrub/blob.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f746ba679948..1a9a5e1840d2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -162,6 +162,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   array.o \
 				   bitmap.o \
+				   blob.o \
 				   bmap_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
diff --git a/fs/xfs/scrub/blob.c b/fs/xfs/scrub/blob.c
new file mode 100644
index 000000000000..94912fcb1fd1
--- /dev/null
+++ b/fs/xfs/scrub/blob.c
@@ -0,0 +1,145 @@
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
+#include "scrub/xfile.h"
+
+/*
+ * XFS Blob Storage
+ * ================
+ * Stores and retrieves blobs using a memfd object.  Objects are appended to
+ * the file and the offset is returned as a magic cookie for retrieval.
+ */
+
+#define XB_KEY_MAGIC	0xABAADDAD
+struct xb_key {
+	uint32_t		magic;
+	uint32_t		size;
+	loff_t			offset;
+	/* blob comes after here */
+} __packed;
+
+/* Initialize a blob storage object. */
+struct xblob *
+xblob_init(void)
+{
+	struct xblob	*blob;
+	struct file	*filp;
+	int		error;
+
+	filp = xfile_create("blob storage");
+	if (!filp)
+		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(filp))
+		return ERR_CAST(filp);
+
+	error = -ENOMEM;
+	blob = kmem_alloc(sizeof(struct xblob), KM_NOFS | KM_MAYFAIL);
+	if (!blob)
+		goto out_filp;
+
+	blob->filp = filp;
+	blob->last_offset = PAGE_SIZE;
+	return blob;
+out_filp:
+	fput(filp);
+	return ERR_PTR(error);
+}
+
+/* Destroy a blob storage object. */
+void
+xblob_destroy(
+	struct xblob	*blob)
+{
+	xfile_destroy(blob->filp);
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
+	struct xb_key	key;
+	loff_t		pos = cookie;
+	int		error;
+
+	error = xfile_io(blob->filp, XFILE_IO_READ, &pos, &key, sizeof(key));
+	if (error)
+		return error;
+
+	if (key.magic != XB_KEY_MAGIC || key.offset != cookie) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+	if (size < key.size) {
+		ASSERT(0);
+		return -EFBIG;
+	}
+
+	return xfile_io(blob->filp, XFILE_IO_READ, &pos, ptr, key.size);
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
+	struct xb_key	key = {
+		.offset = blob->last_offset,
+		.magic = XB_KEY_MAGIC,
+		.size = size,
+	};
+	loff_t		pos = blob->last_offset;
+	int		error;
+
+	error = xfile_io(blob->filp, XFILE_IO_WRITE, &pos, &key, sizeof(key));
+	if (error)
+		goto out_err;
+
+	error = xfile_io(blob->filp, XFILE_IO_WRITE, &pos, ptr, size);
+	if (error)
+		goto out_err;
+
+	*cookie = blob->last_offset;
+	blob->last_offset = pos;
+	return 0;
+out_err:
+	xfile_discard(blob->filp, blob->last_offset, pos - 1);
+	return -ENOMEM;
+}
+
+/* Free a blob. */
+int
+xblob_free(
+	struct xblob	*blob,
+	xblob_cookie	cookie)
+{
+	struct xb_key	key;
+	loff_t		pos = cookie;
+	int		error;
+
+	error = xfile_io(blob->filp, XFILE_IO_READ, &pos, &key, sizeof(key));
+	if (error)
+		return error;
+
+	if (key.magic != XB_KEY_MAGIC || key.offset != cookie) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+
+	xfile_discard(blob->filp, cookie, cookie + sizeof(key) + key.size - 1);
+	return 0;
+}
diff --git a/fs/xfs/scrub/blob.h b/fs/xfs/scrub/blob.h
new file mode 100644
index 000000000000..c6f6c6a2e084
--- /dev/null
+++ b/fs/xfs/scrub/blob.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_BLOB_H__
+#define __XFS_SCRUB_BLOB_H__
+
+struct xblob {
+	struct file	*filp;
+	loff_t		last_offset;
+};
+
+typedef loff_t		xblob_cookie;
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


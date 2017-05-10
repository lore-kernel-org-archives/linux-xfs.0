Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdEJSCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 14:02:24 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/16] xfs: use uuid_be to implement the uuid_t type
Date: Wed, 10 May 2017 20:02:00 +0200
Message-Id: <20170510180214.16852-3-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Use the generic Linux definition to implement our UUID type, this will
allow using more generic infrastructure in the future.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/uuid.h      | 4 ----
 fs/xfs/xfs_linux.h | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 104db0f3bed6..4f1441ba4fa5 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -18,10 +18,6 @@
 #ifndef __XFS_SUPPORT_UUID_H__
 #define __XFS_SUPPORT_UUID_H__
 
-typedef struct {
-	unsigned char	__u_bits[16];
-} uuid_t;
-
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
 extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 044fb0e15390..89ee5ec66837 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -19,6 +19,7 @@
 #define __XFS_LINUX__
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 /*
  * Kernel specific type declarations for XFS
@@ -38,6 +39,8 @@ typedef __s64			xfs_daddr_t;	/* <disk address> type */
 typedef __u32			xfs_dev_t;
 typedef __u32			xfs_nlink_t;
 
+typedef uuid_be			uuid_t;
+
 #include "xfs_types.h"
 
 #include "kmem.h"
-- 
2.11.0


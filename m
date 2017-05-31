Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38527 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaQTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2017 12:19:17 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/24] uuid: remove uuid_be defintions from the uapi header
Date: Wed, 31 May 2017 18:18:07 +0200
Message-Id: <20170531161826.23243-6-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

We don't use uuid_be and the UUID_BE constants in any uapi headers, so make
them private to the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h      | 15 +++++++++++++++
 include/uapi/linux/uuid.h | 16 ----------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 2d095fc60204..30fb13018e29 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -18,6 +18,21 @@
 
 #include <uapi/linux/uuid.h>
 
+typedef struct {
+	__u8 b[16];
+} uuid_be;
+
+#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+((uuid_be)								\
+{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+   ((b) >> 8) & 0xff, (b) & 0xff,					\
+   ((c) >> 8) & 0xff, (c) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define NULL_UUID_BE							\
+	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		0x00, 0x00, 0x00, 0x00)
+
 /*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
  * not including trailing NUL.
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 3738e5fb6a4d..0099756c4bac 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -24,10 +24,6 @@ typedef struct {
 	__u8 b[16];
 } uuid_le;
 
-typedef struct {
-	__u8 b[16];
-} uuid_be;
-
 #define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
 ((uuid_le)								\
 {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
@@ -35,20 +31,8 @@ typedef struct {
    (c) & 0xff, ((c) >> 8) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
-#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
-((uuid_be)								\
-{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
-   ((b) >> 8) & 0xff, (b) & 0xff,					\
-   ((c) >> 8) & 0xff, (c) & 0xff,					\
-   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
-
 #define NULL_UUID_LE							\
 	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
 		0x00, 0x00, 0x00, 0x00)
 
-#define NULL_UUID_BE							\
-	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
-
-
 #endif /* _UAPI_LINUX_UUID_H_ */
-- 
2.11.0


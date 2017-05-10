Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54873 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753825AbdEJP4r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 11:56:47 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/3] (to be split and folded into): uuid: rename uuid types
Date: Wed, 10 May 2017 18:56:10 +0300
Message-Id: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

TBD:
	NTFS ?
	other conflicts?

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/jfs/jfs_logmgr.h       |  4 ++--
 include/linux/efi.h       |  3 +--
 include/uapi/linux/uuid.h | 16 ++++++++--------
 lib/test_uuid.c           | 12 ++++++------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.h b/fs/jfs/jfs_logmgr.h
index e38c21598850..0b9efddeb9f5 100644
--- a/fs/jfs/jfs_logmgr.h
+++ b/fs/jfs/jfs_logmgr.h
@@ -19,6 +19,8 @@
 #ifndef	_H_JFS_LOGMGR
 #define _H_JFS_LOGMGR
 
+#include <linux/uuid.h>
+
 #include "jfs_filsys.h"
 #include "jfs_lock.h"
 
@@ -80,8 +82,6 @@ struct logsuper {
 	} active[MAX_ACTIVE];	/* 2048: active file systems list */
 };
 
-#define NULL_UUID "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
-
 /* log flag: commit option (see jfs_filsys.h) */
 
 /* log state */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec36f42a2add..cbd4d00e62c5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -50,7 +50,7 @@ typedef void *efi_handle_t;
 typedef uuid_le efi_guid_t;
 
 #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
-	UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
+	GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
 
 /*
  * Generic EFI table header
@@ -584,7 +584,6 @@ void efi_native_runtime_setup(void);
  * Note that the 'extra space' separates the values at the same place
  * where the UEFI SPEC breaks the line.
  */
-#define NULL_GUID				EFI_GUID(0x00000000, 0x0000, 0x0000,  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)
 #define MPS_TABLE_GUID				EFI_GUID(0xeb9d2d2f, 0x2d88, 0x11d3,  0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define ACPI_TABLE_GUID				EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3,  0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define ACPI_20_TABLE_GUID			EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 1fcf119e9726..1039d2f3e114 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -55,27 +55,27 @@ typedef struct {
 	};
 } uuid_t;
 
-#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+#define GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
 ((guid_t)								\
 {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
    (b) & 0xff, ((b) >> 8) & 0xff,					\
    (c) & 0xff, ((c) >> 8) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
-#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+#define UUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
 ((uuid_t)								\
 {{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
    ((b) >> 8) & 0xff, (b) & 0xff,					\
    ((c) >> 8) & 0xff, (c) & 0xff,					\
    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
 
-#define NULL_UUID_LE							\
-	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+#define NULL_GUID							\
+	GUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	     0x00, 0x00, 0x00, 0x00)
 
-#define NULL_UUID_BE							\
-	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
-		0x00, 0x00, 0x00, 0x00)
+#define NULL_UUID							\
+	UUID(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+	     0x00, 0x00, 0x00, 0x00)
 
 /* backwards compatibility, don't use in new code */
 typedef guid_t uuid_le;
diff --git a/lib/test_uuid.c b/lib/test_uuid.c
index 547d3127a3cf..7e05c1565dcc 100644
--- a/lib/test_uuid.c
+++ b/lib/test_uuid.c
@@ -18,18 +18,18 @@ struct test_uuid_data {
 static const struct test_uuid_data test_uuid_test_data[] = {
 	{
 		.uuid = "c33f4995-3701-450e-9fbf-206a2e98e576",
-		.le = UUID_LE(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
-		.be = UUID_BE(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
+		.le = GUID(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
+		.be = UUID(0xc33f4995, 0x3701, 0x450e, 0x9f, 0xbf, 0x20, 0x6a, 0x2e, 0x98, 0xe5, 0x76),
 	},
 	{
 		.uuid = "64b4371c-77c1-48f9-8221-29f054fc023b",
-		.le = UUID_LE(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
-		.be = UUID_BE(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
+		.le = GUID(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
+		.be = UUID(0x64b4371c, 0x77c1, 0x48f9, 0x82, 0x21, 0x29, 0xf0, 0x54, 0xfc, 0x02, 0x3b),
 	},
 	{
 		.uuid = "0cb4ddff-a545-4401-9d06-688af53e7f84",
-		.le = UUID_LE(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
-		.be = UUID_BE(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
+		.le = GUID(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
+		.be = UUID(0x0cb4ddff, 0xa545, 0x4401, 0x9d, 0x06, 0x68, 0x8a, 0xf5, 0x3e, 0x7f, 0x84),
 	},
 };
 
-- 
2.11.0


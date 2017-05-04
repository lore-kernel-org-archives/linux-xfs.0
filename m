Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34978 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753558AbdEDN0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:30 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 7/8] linux/uuid.h: hoist uuid_is_null() helper from libnvdimm
Date: Thu,  4 May 2017 16:26:22 +0300
Message-Id: <1493904383-2187-8-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hoist the libnvdimm helper as an inline helper to linux/uuid.h
using an auxiliary const variable uuid_null in lib/uuid.c.

The common helper uses the new abstract type uuid_t* instead of
u8*.

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 drivers/nvdimm/btt_devs.c | 10 ++--------
 include/linux/uuid.h      |  7 +++++++
 lib/uuid.c                |  3 +++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 97dd292..f52c66d 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/uuid.h>
 #include "nd-core.h"
 #include "btt.h"
 #include "nd.h"
@@ -222,13 +223,6 @@ struct device *nd_btt_create(struct nd_region *nd_region)
 	return dev;
 }
 
-static bool uuid_is_null(u8 *uuid)
-{
-	static const u8 null_uuid[16];
-
-	return (memcmp(uuid, null_uuid, 16) == 0);
-}
-
 /**
  * nd_btt_arena_is_valid - check if the metadata layout is valid
  * @nd_btt:	device with BTT geometry and backing device info
@@ -249,7 +243,7 @@ bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
 	if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
 		return false;
 
-	if (!uuid_is_null(super->parent_uuid))
+	if (!uuid_is_null((uuid_t *)super->parent_uuid))
 		if (memcmp(super->parent_uuid, parent_uuid, 16) != 0)
 			return false;
 
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index a1dd9cc..a617ccf 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -68,6 +68,13 @@ static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+extern const uuid_t uuid_null;
+
+static inline bool uuid_is_null(uuid_t *uuid)
+{
+	return uuid_equal(uuid, &uuid_null);
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void uuid_le_gen(uuid_le *u);
diff --git a/lib/uuid.c b/lib/uuid.c
index 37687af..17d0360 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -21,6 +21,9 @@
 #include <linux/uuid.h>
 #include <linux/random.h>
 
+const uuid_t uuid_null;
+EXPORT_SYMBOL(uuid_null);
+
 const u8 uuid_le_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
 EXPORT_SYMBOL(uuid_le_index);
 const u8 uuid_be_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
-- 
2.7.4


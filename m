Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55412 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753988AbdEJP4S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 11:56:18 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/3] (to be folded into): uuid: hoist uuid_is_null() helper from libnvdimm
Date: Wed, 10 May 2017 18:56:11 +0300
Message-Id: <20170510155612.55870-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
References: <20170510155612.55870-1-andriy.shevchenko@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/uuid.h | 7 ++-----
 lib/uuid.c           | 5 -----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 2f9bdc88079e..5dcaabc1e28b 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -24,9 +24,6 @@
  */
 #define	UUID_STRING_LEN		36
 
-extern const guid_t guid_null;
-extern const uuid_t uuid_null;
-
 static inline int guid_cmp(const guid_t u1, const guid_t u2)
 {
 	return memcmp(&u1, &u2, sizeof(guid_t));
@@ -44,7 +41,7 @@ static inline void guid_copy(guid_t *dst, const guid_t *src)
 
 static inline bool guid_is_null(guid_t *guid)
 {
-	return guid_equal(guid, &guid_null);
+	return guid_equal(guid, &NULL_GUID);
 }
 
 static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
@@ -64,7 +61,7 @@ static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
 
 static inline bool uuid_is_null(uuid_t *uuid)
 {
-	return uuid_equal(uuid, &uuid_null);
+	return uuid_equal(uuid, &NULL_UUID);
 }
 
 void generate_random_uuid(unsigned char uuid[16]);
diff --git a/lib/uuid.c b/lib/uuid.c
index 25145bfb0eaa..003bf6823003 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -21,11 +21,6 @@
 #include <linux/uuid.h>
 #include <linux/random.h>
 
-const guid_t guid_null;
-EXPORT_SYMBOL(guid_null);
-const uuid_t uuid_null;
-EXPORT_SYMBOL(uuid_null);
-
 const u8 guid_index[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
 const u8 uuid_index[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
 
-- 
2.11.0


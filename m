Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdEJSCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 14:02:55 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/16] uuid: hoist helpers uuid_equal() and uuid_copy() from xfs
Date: Wed, 10 May 2017 20:02:08 +0200
Message-Id: <20170510180214.16852-11-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

These helper are used to compare and copy two uuid_t type objects.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[hch: also provide the respective guid_ versions]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/uuid.c        |  6 ------
 fs/xfs/uuid.h        |  7 -------
 include/linux/uuid.h | 20 ++++++++++++++++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index 937deaf2128d..737c186ea98b 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -30,9 +30,3 @@ uuid_is_nil(uuid_t *uuid)
 		if (*cp++) return 0;	/* not nil */
 	return 1;	/* is nil */
 }
-
-int
-uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
-{
-	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
-}
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 65b5cebf2f99..5aea49bf0963 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -19,12 +19,5 @@
 #define __XFS_SUPPORT_UUID_H__
 
 extern int uuid_is_nil(uuid_t *uuid);
-extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
-
-static inline void
-uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	memcpy(dst, src, sizeof(uuid_t));
-}
 
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 28a5a894b926..b7fec8b266eb 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -29,11 +29,31 @@ static inline int guid_cmp(const guid_t u1, const guid_t u2)
 	return memcmp(&u1, &u2, sizeof(guid_t));
 }
 
+static inline bool guid_equal(const guid_t *u1, const guid_t *u2)
+{
+	return memcmp(u1, u2, sizeof(guid_t)) == 0;
+}
+
+static inline void guid_copy(guid_t *dst, const guid_t *src)
+{
+	memcpy(dst, src, sizeof(guid_t));
+}
+
 static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
 {
 	return memcmp(&u1, &u2, sizeof(uuid_t));
 }
 
+static inline bool uuid_equal(const uuid_t *u1, const uuid_t *u2)
+{
+	return memcmp(u1, u2, sizeof(uuid_t)) == 0;
+}
+
+static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void guid_gen(guid_t *u);
-- 
2.11.0


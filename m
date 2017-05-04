Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34891 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdEDN02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:28 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 6/8] linux/uuid.h: hoist helpers uuid_equal() and uuid_copy() from xfs
Date: Thu,  4 May 2017 16:26:21 +0300
Message-Id: <1493904383-2187-7-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

These helper are used to compare and copy two uuid_t type objects.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/uuid.c        |  6 ------
 fs/xfs/uuid.h        |  7 -------
 include/linux/uuid.h | 10 ++++++++++
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index 16958e7..d41fa68 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -45,9 +45,3 @@ uuid_is_nil(uuid_t *uuid)
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
index b40dee7..4911905 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -21,13 +21,6 @@
 #include <linux/uuid.h>
 
 extern int uuid_is_nil(uuid_t *uuid);
-extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
 extern void xfs_uuid_getnodeuniq(uuid_t *uuid, int fsid[2]);
 
-static inline void
-uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	memcpy(dst, src, sizeof(uuid_t));
-}
-
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 02253f0..a1dd9cc 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -58,6 +58,16 @@ static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
 	return memcmp(&u1, &u2, sizeof(uuid_be));
 }
 
+static inline bool uuid_equal(const uuid_t *u1, const uuid_t *u2)
+{
+	return (memcmp(u1, u2, sizeof(uuid_t)) == 0);
+}
+
+static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void uuid_le_gen(uuid_le *u);
-- 
2.7.4


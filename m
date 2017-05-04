Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34250 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdEDN0Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 09:26:24 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/8] xfs: namespace the helper uuid_getnodeuniq()
Date: Thu,  4 May 2017 16:26:19 +0300
Message-Id: <1493904383-2187-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
References: <1493904383-2187-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Theodore Tso <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mfasheh@versity.com>, Dan Williams <dan.j.williams@intel.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

uuid_getnodeuniq(), as the comment says, 'is not in any way
a standard or condoned UUID function'.

Therefore, prefix the helper name with xfs_ to differentiate it
from the rest of the common uuid_ helpers.

The uuid_ helpers are about to be hoisted to lib/uuid.c.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/uuid.c      | 4 ++--
 fs/xfs/uuid.h      | 2 +-
 fs/xfs/xfs_mount.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index 7bb4fb8..16958e7 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -18,13 +18,13 @@
 #include <xfs.h>
 
 /*
- * uuid_getnodeuniq - obtain the node unique fields of a UUID.
+ * xfs_uuid_getnodeuniq - obtain the node unique fields of a UUID.
  *
  * This is not in any way a standard or condoned UUID function;
  * it just something that's needed for user-level file handles.
  */
 void
-uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
+xfs_uuid_getnodeuniq(uuid_t *uuid, int fsid[2])
 {
 	fsid[0] = (uuid->clock_seq_hi_and_reserved << 24) |
 		  (uuid->clock_seq_low << 16) |
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 0e3ecd0..b40dee7 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -22,7 +22,7 @@
 
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
-extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
+extern void xfs_uuid_getnodeuniq(uuid_t *uuid, int fsid[2]);
 
 static inline void
 uuid_copy(uuid_t *dst, uuid_t *src)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4c0d8d7..f4fdce7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -794,7 +794,7 @@ xfs_mountfs(
 	 *  Copies the low order bits of the timestamp and the randomly
 	 *  set "sequence" number out of a UUID.
 	 */
-	uuid_getnodeuniq(&sbp->sb_uuid, mp->m_fixedfsid);
+	xfs_uuid_getnodeuniq(&sbp->sb_uuid, mp->m_fixedfsid);
 
 	mp->m_dmevmask = 0;	/* not persistent; set after each mount */
 
-- 
2.7.4


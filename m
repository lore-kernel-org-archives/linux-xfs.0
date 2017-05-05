Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35571 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755120AbdEEH5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 03:57:45 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: remove uuid_getnodeuniq and xfs_uu_t
Date: Fri,  5 May 2017 09:57:25 +0200
Message-Id: <20170505075725.19597-4-hch@lst.de>
In-Reply-To: <20170505075725.19597-1-hch@lst.de>
References: <20170505075725.19597-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com

And just opencode retreiving the UUID v1 information in the only caller
using get_unaligned_be*.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/uuid.c      | 25 -------------------------
 fs/xfs/uuid.h      |  1 -
 fs/xfs/xfs_mount.c |  5 ++++-
 3 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index b83f76b6d410..937deaf2128d 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -17,31 +17,6 @@
  */
 #include <xfs.h>
 
-/* IRIX interpretation of an uuid_t */
-typedef struct {
-	__be32	uu_timelow;
-	__be16	uu_timemid;
-	__be16	uu_timehi;
-	__be16	uu_clockseq;
-	__be16	uu_node[3];
-} xfs_uu_t;
-
-/*
- * uuid_getnodeuniq - obtain the node unique fields of a UUID.
- *
- * This is not in any way a standard or condoned UUID function;
- * it just something that's needed for user-level file handles.
- */
-void
-uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
-{
-	xfs_uu_t *uup = (xfs_uu_t *)uuid;
-
-	fsid[0] = (be16_to_cpu(uup->uu_clockseq) << 16) |
-		   be16_to_cpu(uup->uu_timemid);
-	fsid[1] = be32_to_cpu(uup->uu_timelow);
-}
-
 int
 uuid_is_nil(uuid_t *uuid)
 {
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 4f1441ba4fa5..65b5cebf2f99 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -20,7 +20,6 @@
 
 extern int uuid_is_nil(uuid_t *uuid);
 extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
-extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
 
 static inline void
 uuid_copy(uuid_t *dst, uuid_t *src)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 688ebff1f663..5bf1edb0986d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -789,7 +789,10 @@ xfs_mountfs(
 	 *  Copies the low order bits of the timestamp and the randomly
 	 *  set "sequence" number out of a UUID.
 	 */
-	uuid_getnodeuniq(&sbp->sb_uuid, mp->m_fixedfsid);
+	mp->m_fixedfsid[0] =
+		(get_unaligned_be16(&sbp->sb_uuid.b[8]) << 16) |
+		 get_unaligned_be16(&sbp->sb_uuid.b[4]);
+	mp->m_fixedfsid[1] = get_unaligned_be32(&sbp->sb_uuid.b[0]);
 
 	mp->m_dmevmask = 0;	/* not persistent; set after each mount */
 
-- 
2.11.0


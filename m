Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753885AbdFWNe7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 09:34:59 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 5/6] GFS2: Switch fiemap implementation to use iomap
Date: Fri, 23 Jun 2017 15:34:43 +0200
Message-Id: <1498224884-346-6-git-send-email-agruenba@redhat.com>
In-Reply-To: <1498224884-346-1-git-send-email-agruenba@redhat.com>
References: <1498224884-346-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, Andreas Gruenbacher <agruenba@redhat.com>

From: Bob Peterson <rpeterso@redhat.com>

This patch switches GFS2's implementation of fiemap from the old
block_map code to the new iomap interface.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/Kconfig |  1 +
 fs/gfs2/inode.c | 22 +++++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 90c6a8f..43c827a 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -4,6 +4,7 @@ config GFS2_FS
 	select FS_POSIX_ACL
 	select CRC32
 	select QUOTACTL
+	select FS_IOMAP
 	help
 	  A cluster filesystem.
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9f605ea..9ed2e91 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -18,7 +18,7 @@
 #include <linux/posix_acl.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/fiemap.h>
+#include <linux/iomap.h>
 #include <linux/security.h>
 #include <linux/uaccess.h>
 
@@ -1996,6 +1996,17 @@ static int gfs2_getattr(const struct path *path, struct kstat *stat,
 	return 0;
 }
 
+static int gfs2_iomap_begin(struct inode *inode, loff_t offset,
+			    loff_t length, unsigned flags,
+			    struct iomap *iomap)
+{
+	return gfs2_get_iomap(inode, offset, length, flags, iomap);
+}
+
+const struct iomap_ops gfs2_iomap_ops = {
+	.iomap_begin = gfs2_iomap_begin,
+};
+
 static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len)
 {
@@ -2003,10 +2014,6 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	struct gfs2_holder gh;
 	int ret;
 
-	ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC);
-	if (ret)
-		return ret;
-
 	inode_lock(inode);
 
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
@@ -2018,6 +2025,7 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 size = i_size_read(inode);
 		u32 flags = FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_NOT_ALIGNED|
 			    FIEMAP_EXTENT_DATA_INLINE;
+
 		phys += sizeof(struct gfs2_dinode);
 		phys += start;
 		if (start + len > size)
@@ -2028,11 +2036,11 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (ret == 1)
 			ret = 0;
 	} else {
-		ret = __generic_block_fiemap(inode, fieinfo, start, len,
-					     gfs2_block_map);
+		ret = iomap_fiemap(inode, fieinfo, start, len, &gfs2_iomap_ops);
 	}
 
 	gfs2_glock_dq_uninit(&gh);
+
 out:
 	inode_unlock(inode);
 	return ret;
-- 
2.7.5


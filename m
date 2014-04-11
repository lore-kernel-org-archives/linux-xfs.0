Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E85D729E04
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 13:57:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C05888F8039
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 11:57:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UWFeLCORjRIOH5Sb for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 11:57:55 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 4/4] fs: Disallow all fallocate operation on active swapfile
Date: Fri, 11 Apr 2014 20:57:45 +0200
Message-Id: <1397242665-2183-4-git-send-email-lczerner@redhat.com>
In-Reply-To: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Currently some file system have IS_SWAPFILE check in their fallocate
implementations and some does not. However we should really prevent any
fallocate operation on swapfile so move the check to vfs and remove the
redundant checks from the file systems fallocate implementations.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ceph/file.c    | 3 ---
 fs/ext4/extents.c | 5 -----
 fs/ext4/inode.c   | 5 -----
 fs/open.c         | 7 +++++++
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 66075a4..3a69d80 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1219,9 +1219,6 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	if (IS_SWAPFILE(inode))
-		return -ETXTBSY;
-
 	mutex_lock(&inode->i_mutex);
 
 	if (ceph_snap(inode) != CEPH_NOSNAP) {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ff823b7..517b376 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5394,11 +5394,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
-	if (IS_SWAPFILE(inode)) {
-		ret = -ETXTBSY;
-		goto out_mutex;
-	}
-
 	/* Currently just for extent based files */
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		ret = -EOPNOTSUPP;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 56f1ff4..d8a270d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3529,11 +3529,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 
 	mutex_lock(&inode->i_mutex);
 
-	if (IS_SWAPFILE(inode)) {
-		ret = -ETXTBSY;
-		goto out_mutex;
-	}
-
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size)
 		goto out_mutex;
diff --git a/fs/open.c b/fs/open.c
index 14af6be..48e3fd0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -266,6 +266,13 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EPERM;
 
 	/*
+	 * We can not allow to do any fallocate operation on an active
+	 * swapfile
+	 */
+	if (IS_SWAPFILE(inode))
+		ret = -ETXTBSY;
+
+	/*
 	 * Revalidate the write permissions, in case security policy has
 	 * changed since the files were opened.
 	 */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

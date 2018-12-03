Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:39077
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbeLCIee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:34:34 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Date: Mon,  3 Dec 2018 19:34:13 +1100
Message-Id: <20181203083416.28978-9-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-1-david@fromorbit.com>
References: <20181203083416.28978-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

before we can enable cross-device copies into copy_file_range(),
we have to ensure that ->remap_file_range() implemenations will
correctly reject attempts to do cross filesystem clones. Currently
these checks are done above calls to ->remap_file_range(), but
we need to drive them inwards so that we get EXDEV protection for all
callers of ->remap_file_range().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/read_write.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 3288db1d5f21..174cf92eea1d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1909,6 +1909,19 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	bool same_inode = (inode_in == inode_out);
 	int ret;
 
+	/*
+	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
+	 * the same mount. Practically, they only need to be on the same file
+	 * system. We check this here rather than at the ioctl layers because
+	 * this is effectively a limitation of the fielsystem implementations,
+	 * not so much the API itself. Further, ->remap_file_range() can be
+	 * called from syscalls that don't have cross device copy restrictions
+	 * (such as copy_file_range()) and so we need to catch them before we
+	 * do any damage.
+	 */
+	if (inode_in->i_sb != inode_out->i_sb)
+		return -EXDEV;
+
 	/* Don't touch certain kinds of inodes */
 	if (IS_IMMUTABLE(inode_out))
 		return -EPERM;
@@ -2013,14 +2026,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
-	/*
-	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
-	 * the same mount. Practically, they only need to be on the same file
-	 * system.
-	 */
-	if (inode_in->i_sb != inode_out->i_sb)
-		return -EXDEV;
-
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||
 	    (file_out->f_flags & O_APPEND))
-- 
2.19.1

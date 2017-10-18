Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29947 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdJRXAO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:00:14 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 09/17] xfs: define parent pointer xattr format
Date: Wed, 18 Oct 2017 15:55:25 -0700
Message-Id: <1508367333-3237-10-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Allison Henderson <allison.henderson@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

We need to define the parent pointer attribute format before we
start adding support for it into all the code that needs to use it.
The EA format we will use encodes the following information:

	name={parent inode #, parent inode generation, dirent offset}
	value={dirent filename}

The inode/gen gives all the information we need to reliably identify
the parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl
calls.

By using the dirent offset in the EA name, we have a method of
knowing the exact parent pointer EA we need to modify/remove in
rename/unlink without an unbound EA name search.

By keeping the dirent name in the value, we have enough information
to be able to validate and reconstruct damaged directory trees.
While the diroffset of a filename alone is not unique enough to
identify the child, the {diroffset,filename,child_inode} tuple is
sufficient. That is, if the diroffset gets reused and points to a
different filename, we can detect that from the contents of EA. If a
link of the same name is created, then we can check whether it
points at the same inode as the parent EA we current have.

[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: changed p_ino to xfs_ino_t and p_namelen to uint8_t

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 23229f0..b9ea5bf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_FORMAT_H__
 #define __XFS_FORMAT_H__
 
+#include "xfs_da_format.h"
+
 /*
  * XFS On Disk Format Definitions
  *
@@ -1716,4 +1718,29 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+	__be32	p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_FORMAT_H__ */
-- 
2.7.4


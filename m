Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC59BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpHGmGi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED7FC433C7;
	Sun, 31 Dec 2023 20:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054333;
	bh=jkO3fR30BtvvUZ39gFLgv6FfNGRbd1I6AP+Hbru0Gtw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WpHGmGi7XJTJd+ptIa2twPh3RmwmDxA5unVerNZ0qLmsYDKGbAPZ6x6GBGwotAxAV
	 sd+q7ltuYgfqGZuDZH+MDJBfg8dFq4ysvS0VyjYa5aQgqdLXJaepxRhmDsB6mhRek8
	 8qnc/uFulXTo8qz4XpZNail9fZpp9g+Ir98p9WzbZA1uIooE2UYMhM/8hgJAVimcql
	 ZkpNyxK5N6IJ6x05ZiB5Ma4D5hun/pMb6ktqhegiKvIriJSKaiwbtErIf9bYNaweHb
	 0ZCUwTzhkC8IPVY97O6HYDrY4MQPaenV4Hcy2P+BzwyW3BaxbrLyOZ5NaHNiTWUD6W
	 ZiN8v58ifRYKQ==
Date: Sun, 31 Dec 2023 12:25:32 -0800
Subject: [PATCH 05/25] xfs: declare xfs_file.c symbols in xfs_file.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833218.1750288.5677045147188237209.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the two public symbols in xfs_file.c to xfs_file.h.  We're about to
add more public symbols in that source file, so let's finally create the
header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |    1 +
 fs/xfs/xfs_file.h  |   12 ++++++++++++
 fs/xfs/xfs_ioctl.c |    1 +
 fs/xfs/xfs_iops.c  |    1 +
 fs/xfs/xfs_iops.h  |    3 ---
 5 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 351e00065bf24..9becf6a075361 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -24,6 +24,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_file.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
new file mode 100644
index 0000000000000..7d39e3eca56dc
--- /dev/null
+++ b/fs/xfs/xfs_file.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_FILE_H__
+#define __XFS_FILE_H__
+
+extern const struct file_operations xfs_file_operations;
+extern const struct file_operations xfs_dir_file_operations;
+
+#endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d320f42dab32c..372530698a154 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_xchgrange.h"
+#include "xfs_file.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a0d77f5f512e2..11382c499c92c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_file.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 8a38c3e2ed0e8..3c1a2605ffd2b 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -8,9 +8,6 @@
 
 struct xfs_inode;
 
-extern const struct file_operations xfs_file_operations;
-extern const struct file_operations xfs_dir_file_operations;
-
 extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
 
 int xfs_vn_setattr_size(struct mnt_idmap *idmap,


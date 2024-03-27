Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1056A18C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504308; cv=none; b=tT/YwGmHTTjzRgPkZHb8LWNZo75FLQZqWVCSs3+xX+diQ41Z1zV2zbyuyE1zylazwu+H7t/YQPBRHuchIq1eON2C+HiHZgVQWE9J2zgx3mu7Si4FIuOWDLsqZTs4557jbufNKtAIPdg0w3XROaFrgl0+v7d2lwj+HJIE+9LQgew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504308; c=relaxed/simple;
	bh=eG1Q8QS3S1TB5dpArHtZam2wkNvVObLZdH4yEspSIts=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qTmNY+ZfJp1fzHw6Oy0sLTLjWK/9+vAMA6UNjp6u6nV86BJ3fGnTHrWmIFn7mDo+FBEEK6A9j6PwsIK5duqWEri2E5sIPWwFhQt2OykK+SoXWIeQWid3/5DULQRU3jT9SWvc17YlPK9CJ0fSKNdbOmGVcP7FqUrmOjaEYj3MD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upk11ede; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upk11ede"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9289C433B2;
	Wed, 27 Mar 2024 01:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504307;
	bh=eG1Q8QS3S1TB5dpArHtZam2wkNvVObLZdH4yEspSIts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=upk11ede0R7t8kVeoHAV8z9+TrZKrEHdyHvDG1+2GUHTqYb5U9ntoF3MNdCowI7LW
	 jdkLc2Q4GN03ujbSFo0sdqIWSvZpYvIbxISiWZgxtBdrqqYW2jVgWYE/0dTPgxtRby
	 PatjCFAD2nXIkKqdTQM+pZ14j9Kd9kg7nz5K2lmVEHUE4P+GSjamPJ3+EQZOP2phC7
	 eY5Tr7qhI+P8z/zmR4iukQkr2+dI0f8cgWqN54eWP53oe2PZxlN03DNcm/wdg5gVA4
	 SIVel6nPjBmtTZ8JuskASh1S5X30R+PL6ueP3bxTpnGiY1UYJ+R8SUosWLY3+uuqYX
	 NN6va/d+A35ZA==
Date: Tue, 26 Mar 2024 18:51:47 -0700
Subject: [PATCH 3/7] xfs: declare xfs_file.c symbols in xfs_file.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380182.3216450.14385635879347198116.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  |    1 +
 fs/xfs/xfs_file.h  |   12 ++++++++++++
 fs/xfs/xfs_ioctl.c |    1 +
 fs/xfs/xfs_iops.c  |    1 +
 fs/xfs/xfs_iops.h  |    3 ---
 5 files changed, 15 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_file.h


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 40b778415f5fc..9961d4b5efbe6 100644
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
index d0e2cec6210dd..1397edea20f19 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -39,6 +39,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_file.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 66f8c47642e88..55ed2d1023d67 100644
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61312C12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UbKMgPzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F555C433C8;
	Sun, 31 Dec 2023 22:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061639;
	bh=5iawxK7ibeLrqBqc3iGXZu4Nl0RPkyK0C4Xb7CmzNs4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UbKMgPzTtz+PzsxilyRxQaDxMqgMvzQHHUTjdt/2zs/GnM4hRy1icRDnc071LJaZe
	 mmR3T2j586iM3gbbHHiTsfYAqiIEcXcX/lLkWbBFarX8zOU8ui6unNOJx3FgRQo13a
	 kZ0dqKPhpBzgLD6cZma119L+cw6wNXdiI05B6lvtK5nex1Ilpn/uq1JWmOcOSdLEB4
	 ewNVSMKA7zZU20fde7ZGP2lAT61hIz0Vq9FZJgJBrDrGtvD56z7tqWkUi232ZywX49
	 o4gH90zVXFcBd8ReyvbLz9ORjw3y27bxgzCA5IJeHOiaOWbdoCX3CxVbO1cm+TXRNi
	 k3OFe9DG7u21w==
Date: Sun, 31 Dec 2023 14:27:18 -0800
Subject: [PATCH 01/20] xfs: add a libxfs header file for staging new ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996288.1796128.1378431313126059439.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

Create a new xfs_fs_staging.h header where we can land experimental
ioctls without committing them to any stable interfaces anywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h        |    1 +
 include/xfs.h           |    1 +
 libxfs/Makefile         |    1 +
 libxfs/libxfs_priv.h    |    1 +
 libxfs/xfs_fs_staging.h |   18 ++++++++++++++++++
 5 files changed, 22 insertions(+)
 create mode 100644 libxfs/xfs_fs_staging.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 16667b9d8b3..9e8596bedf9 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -27,6 +27,7 @@
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "xfs_arch.h"
 
 #include "xfs_shared.h"
diff --git a/include/xfs.h b/include/xfs.h
index e97158c8d22..c4a95bec9a9 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -44,5 +44,6 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 /* Include deprecated/compat pre-vfs xfs-specific symbols */
 #include <xfs/xfs_fs_compat.h>
 #include <xfs/xfs_fs.h>
+#include <xfs/xfs_fs_staging.h>
 
 #endif	/* __XFS_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index e1248c2b3ca..ed22f5c873e 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -14,6 +14,7 @@ LTLDFLAGS += -static
 
 # headers to install in include/xfs
 PKGHFILES = xfs_fs.h \
+	xfs_fs_staging.h \
 	xfs_types.h \
 	xfs_da_format.h \
 	xfs_format.h \
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e3d9b70cc17..4d9c49091bc 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -60,6 +60,7 @@
 #include "xfs_arch.h"
 
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "libfrog/crc32c.h"
 
 #include <sys/xattr.h>
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
new file mode 100644
index 00000000000..d220790d5b5
--- /dev/null
+++ b/libxfs/xfs_fs_staging.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_FS_STAGING_H__
+#define __XFS_FS_STAGING_H__
+
+/*
+ * Experimental system calls, ioctls and data structures supporting them.
+ * Nothing in here should be considered part of a stable interface of any kind.
+ *
+ * If you add an ioctl here, please leave a comment in xfs_fs.h marking it
+ * reserved.  If you promote anything out of this file, please leave a comment
+ * explaining where it went.
+ */
+
+#endif /* __XFS_FS_STAGING_H__ */


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066FA58231
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798340; cv=none; b=A+dNNv2sM2Khqn+UMwedlqe0SIbj3T6GY995Lx4j9F93ILE0i90DVeXOX9WcbdyjR94Iqz2lvnKc6vDFp5IxDg5+te55zbgTsWEGF6//4Mb0GaDD8kqL7BzVELL4IDvZoLOymq265y905Hd2dA4lqqHVRvHm/2KIi1d34dTVzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798340; c=relaxed/simple;
	bh=uwPVoyWa5LWr/8fQkYnar1JjhMURYjS+7NC1gWzzIII=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsvN6GhqV9CUDCHZCEjY8Y6+6Ytta8YPuGX4nKxx7CngrEWgh84jhs9NBgxS2/ubvaABmhoJ/xeWPD66Uh8iUttfYBCQN9rYFL14dyaitXdPph9nDV73Kv21ggl9fxujId94UT4pk8vu5KwV7EVR+X2NRXDhnOxjrdaugAYuB60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZldjl8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZldjl8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A3BC433F1;
	Mon, 18 Mar 2024 21:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798339;
	bh=uwPVoyWa5LWr/8fQkYnar1JjhMURYjS+7NC1gWzzIII=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WZldjl8Qn91AIZyr4675OR0ApfGl1G9zk8W+UfSrWwaQNap0o0JlqHADZtFAflrzB
	 WafK1UzFPbCG+bRQRjEIdpuS2PyFHJWo8+9BiCTXfJ8Qk7TOBSpBKENl4RoMrxbZl5
	 uTx89YZd3jMDQcj01066iM0e6Ptdusvc0Lj2qfX7sYMMiLhHsqD+okMvHJF6iMKP3r
	 q7Gl6ex3ZG25SWFJvmWPfmBn9AWdcOf+Q1NKnaFK06FVOkUVcMqItwG2cs3OXn4y77
	 yUCAiC328peaGlpAs9jPk9GWpDZSqAQL/WWa/SHY3UvUCiukTLUDX6jrxk7PtvvFbj
	 Or6Z2cEbbbv9Q==
Date: Mon, 18 Mar 2024 14:45:38 -0700
Subject: [PATCH 14/23] xfs: add a libxfs header file for staging new ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802102.3806377.3407873452477274145.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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
 fs/xfs/Kconfig                 |   11 +++++++++++
 fs/xfs/libxfs/xfs_fs_staging.h |   18 ++++++++++++++++++
 fs/xfs/xfs_linux.h             |    1 +
 fs/xfs/xfs_super.c             |    3 +++
 4 files changed, 33 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_fs_staging.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index d41edd30388b7..5f94f69dc844c 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -191,6 +191,17 @@ config XFS_ONLINE_REPAIR
 
 	  If unsure, say N.
 
+config XFS_EXPERIMENTAL_IOCTLS
+	bool "XFS experimental system calls"
+	default y if XFS_DEBUG
+	depends on XFS_FS
+	help
+	  If you say Y here, the kernel will be built with support for new
+	  system calls that are not yet ready to become part of the stable
+	  kernel ABI.  This enables testing for early adopters.
+
+	  If unsure, say N.
+
 config XFS_WARN
 	bool "XFS Verbose Warnings"
 	depends on XFS_FS && !XFS_DEBUG
diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
new file mode 100644
index 0000000000000..d220790d5b593
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
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
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 439f10b4a77a5..13511ff810d18 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -73,6 +73,7 @@ typedef __u32			xfs_nlink_t;
 #include <asm/unaligned.h>
 
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "xfs_stats.h"
 #include "xfs_sysctl.h"
 #include "xfs_iops.h"
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 66930ef4ad8cd..15b59c37e0ed1 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2356,6 +2356,9 @@ init_xfs_fs(void)
 	printk(KERN_INFO XFS_VERSION_STRING " with "
 			 XFS_BUILD_OPTIONS " enabled\n");
 
+#ifdef CONFIG_XFS_EXPERIMENTAL_IOCTLS
+	xfs_info(NULL, "EXPERIMENTAL ioctls in use.  Use at your own risk!");
+#endif
 	xfs_dir_startup();
 
 	error = xfs_init_caches();


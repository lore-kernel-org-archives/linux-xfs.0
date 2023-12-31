Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F258B653
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IB4/ufK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6B9C433C7;
	Sun, 31 Dec 2023 20:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054270;
	bh=l1Bl1Ce7VhtPSxiQUD3zviaGqkD0/pOGlMHGn6Eramo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IB4/ufK9Mp/lTlowMsB/mb7U0NPLPXUTsaz/a+0rOKpScyOBPp0cDzDllXpSQK/0h
	 KiN+EGHPVMpo2mMLV5xsBCfLRpNIluQAU57nAonypoMjmSJ25ykAUuHHrtLapceS9o
	 mSVLmsyMBbbO4FST3KW0JIKjGai7U8AQYVbHjJzjcpdTtU2A9FPycd8ibJ75zbvlhF
	 Ib/2Zvbk4/DA3yUyEJ9lfA59UTw1E8upxFtjR/pqk7g8NH/6PRyxh16Uju6UHoZct7
	 sGZyEuF27fyO+W9W0VBQBNvXha7NQjagF7clkOS2brGNGOfK11dQjE9ECAVWvNj09h
	 qcFxJVOO1oMug==
Date: Sun, 31 Dec 2023 12:24:30 -0800
Subject: [PATCH 01/25] xfs: add a libxfs header file for staging new ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833155.1750288.15631299091475630049.stgit@frogsfrogsfrogs>
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

Create a new xfs_fs_staging.h header where we can land experimental
ioctls without committing them to any stable interfaces anywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs_staging.h |   18 ++++++++++++++++++
 fs/xfs/xfs_linux.h             |    1 +
 2 files changed, 19 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_fs_staging.h


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
index 73854ad981eb5..c24e0d52bc04e 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -73,6 +73,7 @@ typedef __u32			xfs_nlink_t;
 #include <asm/unaligned.h>
 
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "xfs_stats.h"
 #include "xfs_sysctl.h"
 #include "xfs_iops.h"


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF629D297;
	Tue, 17 Feb 2026 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370482; cv=none; b=Pq5aprWs1sUAa9E7V/o5daxCrZwCQgKaOvlpDbN03aUeXBhS031jY0puVCNePfx9b+6Vmm/y1suenlc5YEYt3PVR5zE0vpunA41IBqf5CLX96f1bNUPa+GQ5S1UYTHq3Vn2EsgOVL63vvy3JdZs1nqTefLZNUOXWuIRW08LMloA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370482; c=relaxed/simple;
	bh=EbkNlukZCXKfjXWHRl44jLAnaH6c/LmSXUUxkgb/vK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYRXwRhx+EVBC7PyKpLEWF97JW7CkAbuqqxO/bxIHPFK+6tK2cLNFk/mqgf4ADtrLIDQV7nEhNlLDq/SEsvGRKPvGWWmSsmbdlxrOTyz5chTO6f9BCFSdUmQRoPI2LBJhmgIXb5mZsiFJgzaBIe1yBwpFzQtuYHJtyh5FZVOQQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXtmq84e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXtmq84e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6DAC19423;
	Tue, 17 Feb 2026 23:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771370482;
	bh=EbkNlukZCXKfjXWHRl44jLAnaH6c/LmSXUUxkgb/vK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXtmq84eXXIpCxGba0nnsG2G6hnIqVWiHqjlGaWCXgHf9TCxWH3Zicigrz46lVzZ5
	 qnaqLKpJEquaEnp/kX0bai9GjJ4s9Ipx6zevKYXANioLaiKKxybpGDD9mKsMDjUHuB
	 t+6rhCMK5P9VH/Ms2C+zWsHlKhKFCf6SxolTqbeokdqcL17hxNkx1EpWKFB+Zj4gc4
	 feYtbFndfwE20THPznUzyWVWQV5zGIXx2fqJQM7y4QWf6PE8B4UjmgsUcuWKsVzrWf
	 ipmIvowUUE0DXuyHKkMItW8KyE09cX577t7eXaVKH21/8dhxb2kSIr4NnAy4trqZKS
	 woyOXlk1psBPg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	djwong@kernel.org
Subject: [PATCH v3 23/35] xfs: add helper to check that inode data need fsverity verification
Date: Wed, 18 Feb 2026 00:19:23 +0100
Message-ID: <20260217231937.1183679-24-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260217231937.1183679-1-aalbersh@kernel.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simple helper to check that this is not fsverity metadata but file data
that needs verification. XFS will use this in iomap callbacks to check
what is being read.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c | 21 +++++++++++++++++++++
 fs/xfs/xfs_fsverity.h | 22 ++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
new file mode 100644
index 000000000000..47add19a241e
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.c
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#include "xfs.h"
+#include "xfs_format.h"
+#include "xfs_inode.h"
+#include "xfs_fsverity.h"
+#include <linux/fsverity.h>
+
+bool
+xfs_fsverity_sealed_data(
+	const struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	const struct inode	*inode = VFS_IC(ip);
+
+	return fsverity_active(inode) &&
+	       (offset < fsverity_metadata_offset(inode));
+}
+
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
new file mode 100644
index 000000000000..5fc55f42b317
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Red Hat, Inc.
+ */
+#ifndef __XFS_FSVERITY_H__
+#define __XFS_FSVERITY_H__
+
+#include "xfs.h"
+
+#ifdef CONFIG_FS_VERITY
+bool xfs_fsverity_sealed_data(const struct xfs_inode *ip,
+		loff_t offset);
+#else
+static inline loff_t xfs_fsverity_offset_to_disk(struct xfs_inode *ip,
+						 loff_t pos)
+{
+	WARN_ON_ONCE(1);
+	return ULLONG_MAX;
+}
+#endif	/* CONFIG_FS_VERITY */
+
+#endif	/* __XFS_FSVERITY_H__ */
-- 
2.51.2


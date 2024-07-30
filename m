Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC38C0B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300889; cv=none; b=dsDpoXYgkbY5TfMzoXfTL5KXFCl53/DtFr6L9Rs5B14zIpf92rvvattgglBTA6FpGY94u32IpCsbkYEKPWfKw8nVCpfF+qMzqdl2bcxlVDKXIr0qd+t4jemTw/tInTdkXMn84clPKBVFXYOTyMC2/YJCLL90Pm+735IdoK2IzkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300889; c=relaxed/simple;
	bh=kwbruGKyUStk+cHBcaDsrZqU1oe9/WDtbrVvc1bxna8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAgxaBu7R8lr8IBr4x4Ob1ayMs+gbvbhSIvXm6bkwVYfzvUaEq+CGr50cOXqPkLDmpbosmAURnPvmttqVY9DL2jUBWN9GXXYedpKnYTBcc2L9CBfc3qBHWWqqS7nAowtxt5Rb5PZMWUk2P0cxD0LG0FCdmXi2AdqKCPGayKqHrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbuBXO9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbuBXO9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DFCC4AF07;
	Tue, 30 Jul 2024 00:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300889;
	bh=kwbruGKyUStk+cHBcaDsrZqU1oe9/WDtbrVvc1bxna8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QbuBXO9nTgqPlOwCc9d5sujDNrev7eEGyP5PXbaKSePm7uPv/GiGPuGhS+bnoblwQ
	 wtpC87thsi8yuQAUWUn7GEeawjpPDnfs7Y/w1hK8S2Z8O6ClFjm64bAji3YxoTD+F/
	 yZcEKQikrHrPNU3eb1hi3LuDKUTgvVIcH61Z0WyC6aRZ4dAW3+Fq8hyHRd8DhN9hcO
	 0UWwoDzlfRrzWxj5K9DqsXeOXNQP3z8ViLCSzs6kKO7OFioLnmPQUaJVV1bp1OH1cf
	 q0bsKI3r7fo5FGyvku9ZyalCSouMRnbrSpxvEv3NsSg/V4Eac1QmLzbj0j596VC2RI
	 9xPKlmxzOZMDg==
Date: Mon, 29 Jul 2024 17:54:49 -0700
Subject: [PATCH 04/12] libfrog: add support for exchange range ioctl family
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844457.1344699.8587837512292274839.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Add some library code to support the new file range exchange and commit
ioctls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/Makefile        |    2 ++
 libfrog/file_exchange.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_exchange.h |   15 ++++++++++++++
 3 files changed, 69 insertions(+)
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h


diff --git a/libfrog/Makefile b/libfrog/Makefile
index cafee073f..53e3c3492 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -18,6 +18,7 @@ bitmap.c \
 bulkstat.c \
 convert.c \
 crc32.c \
+file_exchange.c \
 fsgeom.c \
 list_sort.c \
 linux.c \
@@ -42,6 +43,7 @@ crc32defs.h \
 crc32table.h \
 dahashselftest.h \
 div64.h \
+file_exchange.h \
 fsgeom.h \
 logging.h \
 paths.h \
diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
new file mode 100644
index 000000000..29fdc17e5
--- /dev/null
+++ b/libfrog/file_exchange.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <string.h>
+#include "xfs.h"
+#include "fsgeom.h"
+#include "bulkstat.h"
+#include "libfrog/file_exchange.h"
+
+/* Prepare for a file contents exchange. */
+void
+xfrog_exchangerange_prep(
+	struct xfs_exchange_range	*fxr,
+	off_t				file2_offset,
+	int				file1_fd,
+	off_t				file1_offset,
+	uint64_t			length)
+{
+	memset(fxr, 0, sizeof(*fxr));
+
+	fxr->file1_fd			= file1_fd;
+	fxr->file1_offset		= file1_offset;
+	fxr->length			= length;
+	fxr->file2_offset		= file2_offset;
+}
+
+/*
+ * Execute an exchange-range operation.  Returns 0 for success or a negative
+ * errno.
+ */
+int
+xfrog_exchangerange(
+	int				file2_fd,
+	struct xfs_exchange_range	*fxr,
+	uint64_t			flags)
+{
+	int				ret;
+
+	fxr->flags = flags;
+
+	ret = ioctl(file2_fd, XFS_IOC_EXCHANGE_RANGE, fxr);
+	if (ret)
+		return -errno;
+
+	return 0;
+}
diff --git a/libfrog/file_exchange.h b/libfrog/file_exchange.h
new file mode 100644
index 000000000..b6f6f9f69
--- /dev/null
+++ b/libfrog/file_exchange.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All rights reserved.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_FILE_EXCHANGE_H__
+#define __LIBFROG_FILE_EXCHANGE_H__
+
+void xfrog_exchangerange_prep(struct xfs_exchange_range *fxr,
+		off_t file2_offset, int file1_fd,
+		off_t file1_offset, uint64_t length);
+int xfrog_exchangerange(int file2_fd, struct xfs_exchange_range *fxr,
+		uint64_t flags);
+
+#endif	/* __LIBFROG_FILE_EXCHANGE_H__ */


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E525D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881672; cv=none; b=ra7sQeqhl5gSPuYms2KI04BHJeIweukBqrEaCf0nzdHbA3HF84EXaCpGxUU7F9LDZEU+IETz6C0gUE++K6d9/YwzBStmaGcMht/PGuiapk9Nv9d8Kn0vCd6zYWAQMsYaZYLk4wZ+KfMeb0avoKmurEJ9jUxXrOdVUrXjbaBXg7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881672; c=relaxed/simple;
	bh=f62pDQoKp+ZtYgKFLAMpi3/rOqRQzJXs15f4rp7RjDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGOH/Mv10Ks2+Gk9Ey/xNJjdnbQL/9Jl7fNqFfnOWNt3KQU3FI6C8Q47n20k5twhld/RpYC7pfOR7IbJzlsyZQQ1+x9TvKq7e2S3RbXj8b0pepVzcaFGIsTdM/97r0N/7SZWr8z8TwBBB7M2nmE8S7ccseJm7EABDVF4vayWjtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onc6RzYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onc6RzYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACC9C116B1;
	Tue,  2 Jul 2024 00:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881672;
	bh=f62pDQoKp+ZtYgKFLAMpi3/rOqRQzJXs15f4rp7RjDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=onc6RzYLAx7zkV5HLFeOFA/ehrZpsWnwRvd8wwOcOtOImz0R8G84j8OyENtbOwyjf
	 F3DSJYWKpFvy8rAHpSo3XknjovN9jJB9QGobhf1G4BuCUF8JxrwO1NyZjMi5PUlWqq
	 9fMxcTWu0AlwjG9FEFlPU1WG+4VU0YcOk56Swsc93UsMdqBUTE6Kj62hh3hOvI6iBS
	 Nwxple8tZVM0/8EUNNO+wRGKOKqycYvjf6UHUbfdTdZesaOr6RNiUZJrzBkAEGkJ5C
	 ktUvRx1CIa/NH8fGX9tJT4fnUEtrYp2rMVju9vTltk+0HYyHvNJm6poiRnHEBfFcye
	 O4BzhhLWWlxZw==
Date: Mon, 01 Jul 2024 17:54:31 -0700
Subject: [PATCH 04/12] libfrog: add support for exchange range ioctl family
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116771.2006519.532946760546599337.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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
---
 libfrog/Makefile        |    2 ++
 libfrog/file_exchange.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_exchange.h |   15 ++++++++++++++
 3 files changed, 69 insertions(+)
 create mode 100644 libfrog/file_exchange.c
 create mode 100644 libfrog/file_exchange.h


diff --git a/libfrog/Makefile b/libfrog/Makefile
index cafee073fe3c..53e3c3492377 100644
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
index 000000000000..29fdc17e598c
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
index 000000000000..b6f6f9f698a8
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


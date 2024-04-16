Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87982185E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229224; cv=none; b=V1T5dYRqwuYT/egHYCMxUBeeEuHvs15SGhrHHgMwHygc85yF6oHJtyOBrSAOBbzqep2VPkdmexh8OOXI2cUqpMnMimwA4p564kpzVEUpZZeMsaxe1bCDGaCMX1rpQ33aKRHylmDkErU7bnC23wo/VQogAgVFXiOpeKsv4HQsu7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229224; c=relaxed/simple;
	bh=opUIXEvljglMNsYKwMrktfJucTMw2d2RVT25a40Y0Es=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3lE6WwdqjwxmBln3ZAfAurSmL1uRFbDq/TyQ8pXnOsaXD8lsExsaHtv/5A/emKaCkcsNXaeE8xsC5vvzsPTHYeCgXT+xdgog1CfmeDNdurT7cCVOBa10wKjx39Rt5uzlQBJ3k/6pcItmTAeswj5PM8OBLSwOLH/+gdVuNxqqMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccfWFWrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccfWFWrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE38C113CC;
	Tue, 16 Apr 2024 01:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229224;
	bh=opUIXEvljglMNsYKwMrktfJucTMw2d2RVT25a40Y0Es=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ccfWFWrIsBqwhazAZYDI/ql6yGh3um1qomwxSfLjremi8aJ2ajRcNbRtG+thw+GiG
	 /MKKvUExa7HoNdhYXzKjIW80xKL1egDIXH1UU4USJY7SikD5tCVnKcCQBVMMDUPzPP
	 qxaKkkoFhktsJQPkFqbpFMtjfjrmIliToZtrqEE12cN1MlxdDNZKxtRrUP2hWRh7Zq
	 SexWTuwk3uiTIMYPMu54EZF6X8SMaNn8p36IVYJUAHT7CFtDmPjbQK0MCz1MVEwqu3
	 TRr+UhdSomMgI9TlF+i7C34lTPF1F9komGNdVuTH/JCtLzb5HC15kPa3IXlJRklnym
	 b8VZq5RTKShZw==
Date: Mon, 15 Apr 2024 18:00:23 -0700
Subject: [PATCH 089/111] libxfs: add xfile support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, cmaiolino@redhat.com,
 linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322883501.211103.5837361141423551988.stgit@frogsfrogsfrogs>
In-Reply-To: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
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

Port the xfile functionality (anonymous pageable file-index memory) from
the kernel.  In userspace, we try to use memfd() to create tmpfs files
that are not in any namespace, matching the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile     |    2 
 libxfs/xfile.c      |  210 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfile.h      |   21 +++++
 repair/xfs_repair.c |   15 ++++
 4 files changed, 248 insertions(+)
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 6f688c0ad25a..43e8ae183229 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -26,6 +26,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	xfile.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
 	xfs_alloc_btree.h \
@@ -66,6 +67,7 @@ CFILES = cache.c \
 	topology.c \
 	trans.c \
 	util.c \
+	xfile.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
 	xfs_alloc.c \
diff --git a/libxfs/xfile.c b/libxfs/xfile.c
new file mode 100644
index 000000000000..cba173cc17f1
--- /dev/null
+++ b/libxfs/xfile.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include <linux/memfd.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+/*
+ * Swappable Temporary Memory
+ * ==========================
+ *
+ * Offline checking sometimes needs to be able to stage a large amount of data
+ * in memory.  This information might not fit in the available memory and it
+ * doesn't all need to be accessible at all times.  In other words, we want an
+ * indexed data buffer to store data that can be paged out.
+ *
+ * memfd files meet those requirements.  Therefore, the xfile mechanism uses
+ * one to store our staging data.  The xfile must be freed with xfile_destroy.
+ *
+ * xfiles assume that the caller will handle all required concurrency
+ * management; file locks are not taken.
+ */
+
+/*
+ * Starting with Linux 6.3, there's a new MFD_NOEXEC_SEAL flag that disables
+ * the longstanding memfd behavior that files are created with the executable
+ * bit set, and seals the file against it being turned back on.
+ */
+#ifndef MFD_NOEXEC_SEAL
+# define MFD_NOEXEC_SEAL	(0x0008U)
+#endif
+
+/*
+ * Open a memory-backed fd to back an xfile.  We require close-on-exec here,
+ * because these memfd files function as windowed RAM and hence should never
+ * be shared with other processes.
+ */
+static int
+xfile_create_fd(
+	const char		*description)
+{
+	int			fd = -1;
+	int			ret;
+
+	/*
+	 * memfd_create was added to kernel 3.17 (2014).  MFD_NOEXEC_SEAL
+	 * causes -EINVAL on old kernels, so fall back to omitting it so that
+	 * new xfs_repair can run on an older recovery cd kernel.
+	 */
+	fd = memfd_create(description, MFD_CLOEXEC | MFD_NOEXEC_SEAL);
+	if (fd >= 0)
+		goto got_fd;
+	fd = memfd_create(description, MFD_CLOEXEC);
+	if (fd >= 0)
+		goto got_fd;
+
+	/*
+	 * O_TMPFILE exists as of kernel 3.11 (2013), which means that if we
+	 * find it, we're pretty safe in assuming O_CLOEXEC exists too.
+	 */
+	fd = open("/dev/shm", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
+	if (fd >= 0)
+		goto got_fd;
+
+	fd = open("/tmp", O_TMPFILE | O_CLOEXEC | O_RDWR, 0600);
+	if (fd >= 0)
+		goto got_fd;
+
+	/*
+	 * mkostemp exists as of glibc 2.7 (2007) and O_CLOEXEC exists as of
+	 * kernel 2.6.23 (2007).
+	 */
+	fd = mkostemp("libxfsXXXXXX", O_CLOEXEC);
+	if (fd >= 0)
+		goto got_fd;
+
+	if (!errno)
+		errno = EOPNOTSUPP;
+	return -1;
+got_fd:
+	/*
+	 * Turn off mode bits we don't want -- group members and others should
+	 * not have access to the xfile, nor it be executable.  memfds are
+	 * created with mode 0777, but we'll be careful just in case the other
+	 * implementations fail to set 0600.
+	 */
+	ret = fchmod(fd, 0600);
+	if (ret)
+		perror("disabling xfile executable bit");
+
+	return fd;
+}
+
+/*
+ * Create an xfile of the given size.  The description will be used in the
+ * trace output.
+ */
+int
+xfile_create(
+	const char		*description,
+	struct xfile		**xfilep)
+{
+	struct xfile		*xf;
+	int			error;
+
+	xf = kmalloc(sizeof(struct xfile), 0);
+	if (!xf)
+		return -ENOMEM;
+
+	xf->fd = xfile_create_fd(description);
+	if (xf->fd < 0) {
+		error = -errno;
+		kfree(xf);
+		return error;
+	}
+
+	*xfilep = xf;
+	return 0;
+}
+
+/* Close the file and release all resources. */
+void
+xfile_destroy(
+	struct xfile		*xf)
+{
+	close(xf->fd);
+	kfree(xf);
+}
+
+static inline loff_t
+xfile_maxbytes(
+	struct xfile		*xf)
+{
+	if (sizeof(loff_t) == 8)
+		return LLONG_MAX;
+	return LONG_MAX;
+}
+
+/*
+ * Load an object.  Since we're treating this file as "memory", any error or
+ * short IO is treated as a failure to allocate memory.
+ */
+ssize_t
+xfile_load(
+	struct xfile		*xf,
+	void			*buf,
+	size_t			count,
+	loff_t			pos)
+{
+	ssize_t			ret;
+
+	if (count > INT_MAX)
+		return -ENOMEM;
+	if (xfile_maxbytes(xf) - pos < count)
+		return -ENOMEM;
+
+	ret = pread(xf->fd, buf, count, pos);
+	if (ret < 0)
+		return -errno;
+	if (ret != count)
+		return -ENOMEM;
+	return 0;
+}
+
+/*
+ * Store an object.  Since we're treating this file as "memory", any error or
+ * short IO is treated as a failure to allocate memory.
+ */
+ssize_t
+xfile_store(
+	struct xfile		*xf,
+	const void		*buf,
+	size_t			count,
+	loff_t			pos)
+{
+	ssize_t			ret;
+
+	if (count > INT_MAX)
+		return -E2BIG;
+	if (xfile_maxbytes(xf) - pos < count)
+		return -EFBIG;
+
+	ret = pwrite(xf->fd, buf, count, pos);
+	if (ret < 0)
+		return -errno;
+	if (ret != count)
+		return -ENOMEM;
+	return 0;
+}
+
+/* Compute the number of bytes used by a xfile. */
+unsigned long long
+xfile_bytes(
+	struct xfile		*xf)
+{
+	struct stat		statbuf;
+	int			error;
+
+	error = fstat(xf->fd, &statbuf);
+	if (error)
+		return -errno;
+
+	return (unsigned long long)statbuf.st_blocks << 9;
+}
diff --git a/libxfs/xfile.h b/libxfs/xfile.h
new file mode 100644
index 000000000000..d60084011357
--- /dev/null
+++ b/libxfs/xfile.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_XFILE_H__
+#define __LIBXFS_XFILE_H__
+
+struct xfile {
+	int			fd;
+};
+
+int xfile_create(const char *description, struct xfile **xfilep);
+void xfile_destroy(struct xfile *xf);
+
+ssize_t xfile_load(struct xfile *xf, void *buf, size_t count, loff_t pos);
+ssize_t xfile_store(struct xfile *xf, const void *buf, size_t count, loff_t pos);
+
+unsigned long long xfile_bytes(struct xfile *xf);
+
+#endif /* __LIBXFS_XFILE_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d4f99f36f71d..01f92e841f29 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -953,6 +953,20 @@ phase_end(
 		platform_crash();
 }
 
+/* Try to allow as many memfds as possible. */
+static void
+bump_max_fds(void)
+{
+	struct rlimit	rlim = { };
+	int		ret;
+
+	ret = getrlimit(RLIMIT_NOFILE, &rlim);
+	if (!ret) {
+		rlim.rlim_cur = rlim.rlim_max;
+		setrlimit(RLIMIT_NOFILE, &rlim);
+	}
+}
+
 int
 main(int argc, char **argv)
 {
@@ -972,6 +986,7 @@ main(int argc, char **argv)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 	dinode_bmbt_translation_init();
+	bump_max_fds();
 
 	temp_mp = &xfs_m;
 	setbuf(stdout, NULL);


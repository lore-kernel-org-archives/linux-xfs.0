Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E963C38
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882736; cv=none; b=WcJSbOgIXNQnYjUV5Kp5AAoDmgFdIPi+ifp6ylDV2ypR2sJ1hmR7+ebnD2XUSZ4MnSH/hJIsxxo+nHrlKKyaTai27Mq6d4RyJnTMK4mNHoQTuFZ+E/I3ukB6V58a3Y0MiiniQBQ23lYdfaylGtCqZ2k7rdG6hL7mMSu+kNuPH3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882736; c=relaxed/simple;
	bh=xrxj8DXM1ApaBQn4w3PcgqFK79WgIoCYdwgl7olxiIk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6vFlBwJsHFzqkQKqCuafHXiY9KD49hQDTA5b70Op/a8ua+rPElTwbXDFkHcbfaiop6TA0QhlQNrpdJ8iQQG1SzHk1MOmHLpzEh8uHZSwxoa/dq+LrIGfOOdHOIugO8B+URVcuU9SMIt74ChKwce3QexFITBUWsrfiww9k5tGVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/U2LoSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/U2LoSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE8FC116B1;
	Tue,  2 Jul 2024 01:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882735;
	bh=xrxj8DXM1ApaBQn4w3PcgqFK79WgIoCYdwgl7olxiIk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/U2LoShcQpg/jV90Va9M8FLguIj5HGih8OptX8AmXSDPG0dys0wy+nmQJRQUQsdC
	 KP2B+tF96ctBTRzT1Oyoq/uUg91xbPnuDMjUwNtlS/izQEc4ffEnHcpbTY5jcFUBVd
	 PcIrBdw+lYg0Z3rZNDwkX5M4luj02rIyy6UKHLmBVCFwe9m6/3l0mJUz/FiMdKZsox
	 0bnGeY1uxpEK9JoEtm8D02dTHcXMUWCtAu/sA4hZdlHBw9p4QtrfO0xmL7Ay1FKkWD
	 8QgximSEwUKgXPTo+8tgDnnlOGE4eXvwMMEE4gpKFuK2uKnb2nnZGk0sibjLDEsgDx
	 1RARScd1bLW8A==
Date: Mon, 01 Jul 2024 18:12:15 -0700
Subject: [PATCH 06/24] libfrog: add parent pointer support code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121155.2009260.6759812584905155328.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Add some support code to libfrog so that client programs can walk file
descriptors and handles upwards through the directory tree; and obtain a
reasonable file path from a file descriptor/handle.  This code will be
used in xfsprogs utilities.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/handle.h     |    1 
 libfrog/Makefile     |    2 
 libfrog/getparents.c |  355 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/getparents.h |   42 ++++++
 libfrog/paths.c      |  168 ++++++++++++++++++++++++
 libfrog/paths.h      |   25 ++++
 libhandle/handle.c   |    7 +
 7 files changed, 597 insertions(+), 3 deletions(-)
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h


diff --git a/include/handle.h b/include/handle.h
index 34246f3854de..ba06500516cf 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -17,6 +17,7 @@ struct parent;
 extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
 extern int  path_to_fshandle (char *__path, void **__fshanp, size_t *__fshlen);
 extern int  fd_to_handle (int fd, void **hanp, size_t *hlen);
+extern int  handle_to_fsfd(void *, char **);
 extern int  handle_to_fshandle (void *__hanp, size_t __hlen, void **__fshanp,
 				size_t *__fshlen);
 extern void free_handle (void *__hanp, size_t __hlen);
diff --git a/libfrog/Makefile b/libfrog/Makefile
index acfa228bc8ec..0b5b23893a13 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -20,6 +20,7 @@ convert.c \
 crc32.c \
 file_exchange.c \
 fsgeom.c \
+getparents.c \
 histogram.c \
 list_sort.c \
 linux.c \
@@ -46,6 +47,7 @@ dahashselftest.h \
 div64.h \
 file_exchange.h \
 fsgeom.h \
+getparents.h \
 histogram.h \
 logging.h \
 paths.h \
diff --git a/libfrog/getparents.c b/libfrog/getparents.c
new file mode 100644
index 000000000000..9118b0ff32db
--- /dev/null
+++ b/libfrog/getparents.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2017-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_arch.h"
+#include "list.h"
+#include "paths.h"
+#include "handle.h"
+#include "libfrog/getparents.h"
+
+/* Allocate a buffer for the xfs_getparent_rec array. */
+static void *
+alloc_records(
+	struct xfs_getparents	*gp,
+	size_t			bufsize)
+{
+	void			*buf;
+
+	if (bufsize >= UINT32_MAX) {
+		errno = ENOMEM;
+		return NULL;
+	} else if (!bufsize) {
+		bufsize = XFS_XATTR_LIST_MAX;
+	}
+
+	buf = malloc(bufsize);
+	if (!buf)
+		return NULL;
+
+	gp->gp_buffer = (uintptr_t)buf;
+	gp->gp_bufsize = bufsize;
+	return buf;
+}
+
+/* Copy a file handle. */
+static inline void
+copy_handle(
+	struct xfs_handle	*dest,
+	const struct xfs_handle	*src)
+{
+	memcpy(dest, src, sizeof(struct xfs_handle));
+}
+
+/* Initiate a callback for each parent pointer. */
+static int
+walk_parent_records(
+	struct xfs_getparents	*gp,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents_rec *gpr;
+	int			ret;
+
+	if (gp->gp_oflags & XFS_GETPARENTS_OFLAG_ROOT) {
+		struct parent_rec	rec = {
+			.p_flags	= PARENTREC_FILE_IS_ROOT,
+		};
+
+		return fn(&rec, arg);
+	}
+
+	for (gpr = xfs_getparents_first_rec(gp);
+	     gpr != NULL;
+	     gpr = xfs_getparents_next_rec(gp, gpr)) {
+		struct parent_rec	rec = { };
+
+		if (gpr->gpr_name[0] == 0)
+			break;
+
+		copy_handle(&rec.p_handle, &gpr->gpr_parent);
+		rec.p_name = gpr->gpr_name;
+
+		ret = fn(&rec, arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Walk all parent pointers of this fd.  Returns 0 or positive errno. */
+int
+fd_walk_parents(
+	int			fd,
+	size_t			bufsize,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents	gp = { };
+	void			*buf;
+	int			ret;
+
+	buf = alloc_records(&gp, bufsize);
+	if (!buf)
+		return errno;
+
+	while ((ret = ioctl(fd, XFS_IOC_GETPARENTS, &gp)) == 0) {
+		ret = walk_parent_records(&gp, fn, arg);
+		if (ret)
+			goto out_buf;
+		if (gp.gp_oflags & XFS_GETPARENTS_OFLAG_DONE)
+			break;
+	}
+	if (ret)
+		ret = errno;
+
+out_buf:
+	free(buf);
+	return ret;
+}
+
+/* Walk all parent pointers of this handle.  Returns 0 or positive errno. */
+int
+handle_walk_parents(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			bufsize,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents_by_handle	gph = { };
+	void			*buf;
+	char			*mntpt;
+	int			fd;
+	int			ret;
+
+	if (hlen != sizeof(struct xfs_handle))
+		return EINVAL;
+
+	/*
+	 * This function doesn't modify the handle, but we don't want to have
+	 * to bump the libhandle major version just to change that.
+	 */
+	fd = handle_to_fsfd((void *)hanp, &mntpt);
+	if (fd < 0)
+		return errno;
+
+	buf = alloc_records(&gph.gph_request, bufsize);
+	if (!buf)
+		return errno;
+
+	copy_handle(&gph.gph_handle, hanp);
+	while ((ret = ioctl(fd, XFS_IOC_GETPARENTS_BY_HANDLE, &gph)) == 0) {
+		ret = walk_parent_records(&gph.gph_request, fn, arg);
+		if (ret)
+			goto out_buf;
+		if (gph.gph_request.gp_oflags & XFS_GETPARENTS_OFLAG_DONE)
+			break;
+	}
+	if (ret)
+		ret = errno;
+
+out_buf:
+	free(buf);
+	return ret;
+}
+
+struct walk_ppaths_info {
+	/* Callback */
+	walk_path_fn		fn;
+	void			*arg;
+
+	/* Mountpoint of this filesystem. */
+	char			*mntpt;
+
+	/* Path that we're constructing. */
+	struct path_list	*path;
+
+	size_t			ioctl_bufsize;
+};
+
+/*
+ * Recursively walk upwards through the directory tree, changing out the path
+ * components as needed.  Call the callback when we have a complete path.
+ */
+static int
+find_parent_component(
+	const struct parent_rec	*rec,
+	void			*arg)
+{
+	struct walk_ppaths_info	*wpi = arg;
+	struct path_component	*pc;
+	int			ret;
+
+	if (rec->p_flags & PARENTREC_FILE_IS_ROOT)
+		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
+
+	/*
+	 * If we detect a directory tree cycle, give up.  We never made any
+	 * guarantees about concurrent tree updates.
+	 */
+	if (path_will_loop(wpi->path, rec->p_handle.ha_fid.fid_ino))
+		return 0;
+
+	pc = path_component_init(rec->p_name, rec->p_handle.ha_fid.fid_ino);
+	if (!pc)
+		return errno;
+	path_list_add_parent_component(wpi->path, pc);
+
+	ret = handle_walk_parents(&rec->p_handle, sizeof(rec->p_handle),
+			wpi->ioctl_bufsize, find_parent_component, wpi);
+
+	path_list_del_component(wpi->path, pc);
+	path_component_free(pc);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * described in the handle.  Returns 0 for success or positive errno.
+ */
+int
+handle_walk_paths(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			ioctl_bufsize,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi = {
+		.ioctl_bufsize	= ioctl_bufsize,
+	};
+	int			ret;
+
+	/*
+	 * This function doesn't modify the handle, but we don't want to have
+	 * to bump the libhandle major version just to change that.
+	 */
+	ret = handle_to_fsfd((void *)hanp, &wpi.mntpt);
+	if (ret < 0)
+		return errno;
+
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return errno;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parents(hanp, hlen, ioctl_bufsize,
+			find_parent_component, &wpi);
+
+	path_list_free(wpi.path);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * referred to by the file description.  Returns 0 or positive errno.
+ */
+int
+fd_walk_paths(
+	int			fd,
+	size_t			ioctl_bufsize,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	void			*hanp;
+	size_t			hlen;
+	int			ret;
+
+	ret = fd_to_handle(fd, &hanp, &hlen);
+	if (ret)
+		return errno;
+
+	ret = handle_walk_paths(hanp, hlen, ioctl_bufsize, fn, arg);
+	free_handle(hanp, hlen);
+	return ret;
+}
+
+struct gather_path_info {
+	char			*buf;
+	size_t			len;
+	size_t			written;
+};
+
+/* Helper that stringifies the first full path that we find. */
+static int
+path_to_string(
+	const char		*mntpt,
+	const struct path_list	*path,
+	void			*arg)
+{
+	struct gather_path_info	*gpi = arg;
+	int			mntpt_len = strlen(mntpt);
+	int			ret;
+
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
+
+	ret = snprintf(gpi->buf, gpi->len, "%.*s", mntpt_len, mntpt);
+	if (ret != mntpt_len)
+		return ENAMETOOLONG;
+	gpi->written += ret;
+
+	ret = path_list_to_string(path, gpi->buf + ret, gpi->len - ret);
+	if (ret < 0)
+		return ENAMETOOLONG;
+
+	gpi->written += ret;
+	return ECANCELED;
+}
+
+/*
+ * Return any eligible path to this file handle.  Returns 0 for success or
+ * positive errno.
+ */
+int
+handle_to_path(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			ioctl_bufsize,
+	char			*path,
+	size_t			pathlen)
+{
+	struct gather_path_info	gpi = { .buf = path, .len = pathlen };
+	int			ret;
+
+	ret = handle_walk_paths(hanp, hlen, ioctl_bufsize, path_to_string,
+			&gpi);
+	if (ret && ret != ECANCELED)
+		return ret;
+	if (!gpi.written)
+		return ENODATA;
+
+	path[gpi.written] = 0;
+	return 0;
+}
+
+/*
+ * Return any eligible path to this file description.  Returns 0 for success
+ * or positive errno.
+ */
+int
+fd_to_path(
+	int			fd,
+	size_t			ioctl_bufsize,
+	char			*path,
+	size_t			pathlen)
+{
+	struct gather_path_info	gpi = { .buf = path, .len = pathlen };
+	int			ret;
+
+	ret = fd_walk_paths(fd, ioctl_bufsize, path_to_string, &gpi);
+	if (ret && ret != ECANCELED)
+		return ret;
+	if (!gpi.written)
+		return ENODATA;
+
+	path[gpi.written] = 0;
+	return 0;
+}
diff --git a/libfrog/getparents.h b/libfrog/getparents.h
new file mode 100644
index 000000000000..8098d594219b
--- /dev/null
+++ b/libfrog/getparents.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef	__LIBFROG_GETPARENTS_H_
+#define	__LIBFROG_GETPARENTS_H_
+
+struct path_list;
+
+struct parent_rec {
+	/* File handle to parent directory */
+	struct xfs_handle	p_handle;
+
+	/* Null-terminated directory entry name in the parent */
+	char			*p_name;
+
+	/* Flags for this record; see PARENTREC_* below */
+	uint32_t		p_flags;
+};
+
+/* This is the root directory. */
+#define PARENTREC_FILE_IS_ROOT	(1U << 0)
+
+typedef int (*walk_parent_fn)(const struct parent_rec *rec, void *arg);
+
+int fd_walk_parents(int fd, size_t ioctl_bufsize, walk_parent_fn fn, void *arg);
+int handle_walk_parents(const void *hanp, size_t hanlen, size_t ioctl_bufsize,
+		walk_parent_fn fn, void *arg);
+
+typedef int (*walk_path_fn)(const char *mntpt, const struct path_list *path,
+		void *arg);
+
+int fd_walk_paths(int fd, size_t ioctl_bufsize, walk_path_fn fn, void *arg);
+int handle_walk_paths(const void *hanp, size_t hanlen, size_t ioctl_bufsize,
+		walk_path_fn fn, void *arg);
+
+int fd_to_path(int fd, size_t ioctl_bufsize, char *path, size_t pathlen);
+int handle_to_path(const void *hanp, size_t hlen, size_t ioctl_bufsize,
+		char *path, size_t pathlen);
+
+#endif /* __LIBFROG_GETPARENTS_H_ */
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 320b26dbf25b..a5dfab48ec1e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -16,6 +16,7 @@
 #include "input.h"
 #include "projects.h"
 #include <mntent.h>
+#include "list.h"
 #include <limits.h>
 
 extern char *progname;
@@ -560,3 +561,170 @@ fs_table_insert_project_path(
 
 	return error;
 }
+
+/* Structured path components. */
+
+struct path_list {
+	struct list_head	p_head;
+};
+
+struct path_component {
+	struct list_head	pc_list;
+	uint64_t		pc_ino;
+	char			*pc_fname;
+};
+
+/* Initialize a path component with a given name. */
+struct path_component *
+path_component_init(
+	const char		*name,
+	uint64_t		ino)
+{
+	struct path_component	*pc;
+
+	pc = malloc(sizeof(struct path_component));
+	if (!pc)
+		return NULL;
+	INIT_LIST_HEAD(&pc->pc_list);
+	pc->pc_fname = strdup(name);
+	if (!pc->pc_fname) {
+		free(pc);
+		return NULL;
+	}
+	pc->pc_ino = ino;
+	return pc;
+}
+
+/* Free a path component. */
+void
+path_component_free(
+	struct path_component	*pc)
+{
+	free(pc->pc_fname);
+	free(pc);
+}
+
+/* Initialize a pathname or returns positive errno. */
+struct path_list *
+path_list_init(void)
+{
+	struct path_list	*path;
+
+	path = malloc(sizeof(struct path_list));
+	if (!path)
+		return NULL;
+	INIT_LIST_HEAD(&path->p_head);
+	return path;
+}
+
+/* Empty out a pathname. */
+void
+path_list_free(
+	struct path_list	*path)
+{
+	struct path_component	*pos;
+	struct path_component	*n;
+
+	list_for_each_entry_safe(pos, n, &path->p_head, pc_list) {
+		path_list_del_component(path, pos);
+		path_component_free(pos);
+	}
+	free(path);
+}
+
+/* Add a parent component to a pathname. */
+void
+path_list_add_parent_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add(&pc->pc_list, &path->p_head);
+}
+
+/* Add a component to a pathname. */
+void
+path_list_add_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add_tail(&pc->pc_list, &path->p_head);
+}
+
+/* Remove a component from a pathname. */
+void
+path_list_del_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_del_init(&pc->pc_list);
+}
+
+/*
+ * Convert a pathname into a string or returns -1 if the buffer isn't long
+ * enough.
+ */
+ssize_t
+path_list_to_string(
+	const struct path_list	*path,
+	char			*buf,
+	size_t			buflen)
+{
+	struct path_component	*pos;
+	char			*buf_end = buf + buflen;
+	ssize_t			bytes = 0;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		if (buf >= buf_end)
+			return -1;
+
+		ret = snprintf(buf, buflen, "/%s", pos->pc_fname);
+		if (ret < 0 || ret >= buflen)
+			return -1;
+
+		bytes += ret;
+		buf += ret;
+		buflen -= ret;
+	}
+	return bytes;
+}
+
+/* Walk each component of a path. */
+int
+path_walk_components(
+	const struct path_list	*path,
+	path_walk_fn_t		fn,
+	void			*arg)
+{
+	struct path_component	*pos;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		ret = fn(pos->pc_fname, pos->pc_ino, arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Will this path contain a loop if we add this inode? */
+bool
+path_will_loop(
+	const struct path_list	*path_list,
+	uint64_t		ino)
+{
+	struct path_component	*pc;
+	unsigned int		nr = 0;
+
+	list_for_each_entry(pc, &path_list->p_head, pc_list) {
+		if (pc->pc_ino == ino)
+			return true;
+
+		/* 256 path components should be enough for anyone. */
+		if (++nr > 256)
+			return true;
+	}
+
+	return false;
+}
diff --git a/libfrog/paths.h b/libfrog/paths.h
index f20a2c3ef582..306fd3cb8fde 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -58,4 +58,29 @@ typedef struct fs_cursor {
 extern void fs_cursor_initialise(char *__dir, uint __flags, fs_cursor_t *__cp);
 extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
 
+/* Path information. */
+
+struct path_list;
+struct path_component;
+
+struct path_component *path_component_init(const char *name, uint64_t ino);
+void path_component_free(struct path_component *pc);
+
+struct path_list *path_list_init(void);
+void path_list_free(struct path_list *path);
+void path_list_add_parent_component(struct path_list *path,
+		struct path_component *pc);
+void path_list_add_component(struct path_list *path, struct path_component *pc);
+void path_list_del_component(struct path_list *path, struct path_component *pc);
+
+ssize_t path_list_to_string(const struct path_list *path, char *buf,
+		size_t buflen);
+
+typedef int (*path_walk_fn_t)(const char *name, uint64_t ino, void *arg);
+
+int path_walk_components(const struct path_list *path, path_walk_fn_t fn,
+		void *arg);
+
+bool path_will_loop(const struct path_list *path, uint64_t ino);
+
 #endif	/* __LIBFROG_PATH_H__ */
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 333c21909007..1e8fe9ac5f10 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -29,7 +29,6 @@ typedef union {
 } comarg_t;
 
 static int obj_to_handle(char *, int, unsigned int, comarg_t, void**, size_t*);
-static int handle_to_fsfd(void *, char **);
 static char *path_to_fspath(char *path);
 
 
@@ -203,8 +202,10 @@ handle_to_fshandle(
 	return 0;
 }
 
-static int
-handle_to_fsfd(void *hanp, char **path)
+int
+handle_to_fsfd(
+	void		*hanp,
+	char		**path)
 {
 	struct fdhash	*fdhp;
 


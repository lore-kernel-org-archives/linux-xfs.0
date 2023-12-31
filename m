Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E93C147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFxAknJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C13CC433C8;
	Sun, 31 Dec 2023 23:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064157;
	bh=2NIrejcvRGkUT0mu3Rf6/Xf6CMXy+qgiLzAgfrRbtGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gFxAknJEA6t8AJ3ZPnL+u+nl0RpCC2cQZ6oXSsiO6/u+0uSISps6fr4J0LH1vY0QA
	 C6KPQH5hQ+eo2zTAKxRMe4xGDiR34/1U80gsd3Ts83DT+NTzGZzpMvWnbIAGH8anTG
	 P2UgzH+A1my/TOFsyLo9V6Sae3/ezO0UbYg6dMvNCJSDq7kR/5Y/LmisrWwO8pCXR0
	 PKflOdW5TXrSrz7h+XoMOBk/GR4+fwyH2j7euXnKixJv88ze2WzMFgtY4cfP14NV+L
	 nw4/0BOSXRUY3pj5GxvVFUTXLspJUV96DStDgtVIAFUCQWJKZ9GrejaemZuQ1bseqD
	 0XS6yEHnkZDEA==
Date: Sun, 31 Dec 2023 15:09:16 -0800
Subject: [PATCH 16/32] libfrog: add parent pointer support code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006315.1804688.18073267977833660387.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 include/handle.h     |    1 
 libfrog/Makefile     |    2 
 libfrog/getparents.c |  345 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/getparents.h |   36 +++++
 libfrog/paths.c      |  167 ++++++++++++++++++++++++
 libfrog/paths.h      |   25 ++++
 libhandle/handle.c   |    7 +
 7 files changed, 580 insertions(+), 3 deletions(-)
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h


diff --git a/include/handle.h b/include/handle.h
index 34246f3854d..ba06500516c 100644
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
index bbc5b887cd3..8c2d040bc29 100644
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
index 00000000000..016fe3f026d
--- /dev/null
+++ b/libfrog/getparents.c
@@ -0,0 +1,345 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2017-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_arch.h"
+#include "list.h"
+#include "libfrog/paths.h"
+#include "handle.h"
+#include "libfrog/getparents.h"
+
+/* Allocate a buffer large enough for some parent pointer records. */
+static inline struct xfs_getparents *
+alloc_pptr_buf(
+	size_t			bufsize)
+{
+	struct xfs_getparents	*pi;
+
+	pi = calloc(bufsize, 1);
+	if (!pi)
+		return NULL;
+	pi->gp_bufsize = bufsize;
+	return pi;
+}
+
+/*
+ * Walk all parents of the given file handle.  Returns 0 on success or positive
+ * errno.
+ */
+static int
+call_getparents(
+	int			fd,
+	struct xfs_handle	*handle,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents	*pi;
+	struct xfs_getparents_rec	*p;
+	unsigned int		i;
+	ssize_t			ret = -1;
+
+	pi = alloc_pptr_buf(XFS_XATTR_LIST_MAX);
+	if (!pi)
+		return errno;
+
+	if (handle) {
+		memcpy(&pi->gp_handle, handle, sizeof(struct xfs_handle));
+		pi->gp_flags = XFS_GETPARENTS_IFLAG_HANDLE;
+	}
+
+	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+	while (!ret) {
+		if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT) {
+			struct parent_rec	rec = {
+				.p_flags	= PARENT_IS_ROOT,
+			};
+
+			ret = fn(&rec, arg);
+			goto out_pi;
+		}
+
+		for (i = 0; i < pi->gp_count; i++) {
+			struct parent_rec	rec = { 0 };
+
+			p = xfs_getparents_rec(pi, i);
+			rec.p_ino = p->gpr_ino;
+			rec.p_gen = p->gpr_gen;
+			strncpy((char *)rec.p_name, (char *)p->gpr_name,
+					MAXNAMELEN - 1);
+
+			ret = fn(&rec, arg);
+			if (ret)
+				goto out_pi;
+		}
+
+		if (pi->gp_flags & XFS_GETPARENTS_OFLAG_DONE)
+			break;
+
+		ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+	}
+	if (ret)
+		ret = errno;
+
+out_pi:
+	free(pi);
+	return ret;
+}
+
+/* Walk all parent pointers of this handle.  Returns 0 or positive errno. */
+int
+handle_walk_parents(
+	void			*hanp,
+	size_t			hlen,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	char			*mntpt;
+	int			fd;
+
+	if (hlen != sizeof(struct xfs_handle))
+		return EINVAL;
+
+	fd = handle_to_fsfd(hanp, &mntpt);
+	if (fd < 0)
+		return errno;
+
+	return call_getparents(fd, hanp, fn, arg);
+}
+
+/* Walk all parent pointers of this fd.  Returns 0 or positive errno. */
+int
+fd_walk_parents(
+	int			fd,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	return call_getparents(fd, NULL, fn, arg);
+}
+
+struct walk_ppaths_info {
+	walk_path_fn			fn;
+	void				*arg;
+	char				*mntpt;
+	struct path_list		*path;
+	int				fd;
+};
+
+struct walk_ppath_level_info {
+	struct xfs_handle		newhandle;
+	struct path_component		*pc;
+	struct walk_ppaths_info		*wpi;
+};
+
+static int handle_walk_ppath(struct walk_ppaths_info *wpi,
+		struct xfs_handle *handle);
+
+static int
+handle_walk_ppath_rec(
+	const struct parent_rec		*rec,
+	void				*arg)
+{
+	struct walk_ppath_level_info	*wpli = arg;
+	struct walk_ppaths_info		*wpi = wpli->wpi;
+	int				ret = 0;
+
+	if (rec->p_flags & PARENT_IS_ROOT)
+		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
+
+	ret = path_component_change(wpli->pc, rec->p_name,
+				strlen((char *)rec->p_name), rec->p_ino);
+	if (ret)
+		return ret;
+
+	wpli->newhandle.ha_fid.fid_ino = rec->p_ino;
+	wpli->newhandle.ha_fid.fid_gen = rec->p_gen;
+
+	path_list_add_parent_component(wpi->path, wpli->pc);
+	ret = handle_walk_ppath(wpi, &wpli->newhandle);
+	path_list_del_component(wpi->path, wpli->pc);
+
+	return ret;
+}
+
+/*
+ * Recursively walk all parents of the given file handle; if we hit the
+ * fs root then we call the associated function with the constructed path.
+ * Returns 0 for success or positive errno.
+ */
+static int
+handle_walk_ppath(
+	struct walk_ppaths_info		*wpi,
+	struct xfs_handle		*handle)
+{
+	struct walk_ppath_level_info	*wpli;
+	int				ret;
+
+	wpli = malloc(sizeof(struct walk_ppath_level_info));
+	if (!wpli)
+		return errno;
+	wpli->pc = path_component_init("", 0);
+	if (!wpli->pc) {
+		ret = errno;
+		free(wpli);
+		return ret;
+	}
+	wpli->wpi = wpi;
+	memcpy(&wpli->newhandle, handle, sizeof(struct xfs_handle));
+
+	ret = call_getparents(wpi->fd, handle, handle_walk_ppath_rec, wpli);
+
+	path_component_free(wpli->pc);
+	free(wpli);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * described in the handle.  Returns 0 for success or positive errno.
+ */
+int
+handle_walk_parent_paths(
+	void			*hanp,
+	size_t			hlen,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi;
+	ssize_t			ret;
+
+	if (hlen != sizeof(struct xfs_handle))
+		return EINVAL;
+
+	wpi.fd = handle_to_fsfd(hanp, &wpi.mntpt);
+	if (wpi.fd < 0)
+		return errno;
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return errno;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_ppath(&wpi, hanp);
+	path_list_free(wpi.path);
+
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * referred to by the file description.  Returns 0 or positive errno.
+ */
+int
+fd_walk_parent_paths(
+	int			fd,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi;
+	void			*hanp;
+	size_t			hlen;
+	int			fsfd;
+	int			ret;
+
+	ret = fd_to_handle(fd, &hanp, &hlen);
+	if (ret)
+		return errno;
+
+	fsfd = handle_to_fsfd(hanp, &wpi.mntpt);
+	if (fsfd < 0)
+		return errno;
+	wpi.fd = fd;
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return errno;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_ppath(&wpi, hanp);
+	path_list_free(wpi.path);
+
+	return ret;
+}
+
+struct path_walk_info {
+	char			*buf;
+	size_t			len;
+	size_t			written;
+};
+
+/* Helper that stringifies the first full path that we find. */
+static int
+handle_to_path_walk(
+	const char		*mntpt,
+	const struct path_list	*path,
+	void			*arg)
+{
+	struct path_walk_info	*pwi = arg;
+	int			mntpt_len = strlen(mntpt);
+	int			ret;
+
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
+
+	ret = snprintf(pwi->buf, pwi->len, "%.*s", mntpt_len, mntpt);
+	if (ret != mntpt_len)
+		return ENAMETOOLONG;
+	pwi->written += ret;
+
+	ret = path_list_to_string(path, pwi->buf + ret, pwi->len - ret);
+	if (ret < 0)
+		return ENAMETOOLONG;
+
+	pwi->written += ret;
+	return ECANCELED;
+}
+
+/*
+ * Return any eligible path to this file handle.  Returns 0 for success or
+ * positive errno.
+ */
+int
+handle_to_path(
+	void			*hanp,
+	size_t			hlen,
+	char			*path,
+	size_t			pathlen)
+{
+	struct path_walk_info	pwi = { .buf = path, .len = pathlen };
+	int			ret;
+
+	ret = handle_walk_parent_paths(hanp, hlen, handle_to_path_walk, &pwi);
+	if (ret && ret != ECANCELED)
+		return ret;
+	if (!pwi.written)
+		return ENODATA;
+
+	path[pwi.written] = 0;
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
+	char			*path,
+	size_t			pathlen)
+{
+	struct path_walk_info	pwi = { .buf = path, .len = pathlen };
+	int			ret;
+
+	ret = fd_walk_parent_paths(fd, handle_to_path_walk, &pwi);
+	if (ret && ret != ECANCELED)
+		return ret;
+	if (!pwi.written)
+		return ENODATA;
+
+	path[pwi.written] = 0;
+	return ret;
+}
diff --git a/libfrog/getparents.h b/libfrog/getparents.h
new file mode 100644
index 00000000000..41beb4ce3be
--- /dev/null
+++ b/libfrog/getparents.h
@@ -0,0 +1,36 @@
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
+	uint64_t	p_ino;
+	uint32_t	p_gen;
+	uint32_t	p_flags;
+	unsigned char	p_name[MAXNAMELEN];
+};
+
+/* This is the root directory. */
+#define PARENT_IS_ROOT	(1U << 0)
+
+typedef int (*walk_parent_fn)(const struct parent_rec *rec, void *arg);
+typedef int (*walk_path_fn)(const char *mntpt, const struct path_list *path,
+		void *arg);
+
+int fd_walk_parents(int fd, walk_parent_fn fn, void *arg);
+int handle_walk_parents(void *hanp, size_t hanlen, walk_parent_fn fn,
+		void *arg);
+
+int fd_walk_parent_paths(int fd, walk_path_fn fn, void *arg);
+int handle_walk_parent_paths(void *hanp, size_t hanlen, walk_path_fn fn,
+		void *arg);
+
+int fd_to_path(int fd, char *path, size_t pathlen);
+int handle_to_path(void *hanp, size_t hlen, char *path, size_t pathlen);
+
+#endif /* __LIBFROG_GETPARENTS_H_ */
diff --git a/libfrog/paths.c b/libfrog/paths.c
index d8c42163a7b..b3c5236990e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -15,6 +15,7 @@
 #include "paths.h"
 #include "input.h"
 #include "projects.h"
+#include "list.h"
 #include <limits.h>
 
 extern char *progname;
@@ -567,3 +568,169 @@ fs_table_insert_project_path(
 
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
+/* Change a path component's filename or returns positive errno. */
+int
+path_component_change(
+	struct path_component	*pc,
+	const void		*name,
+	size_t			namelen,
+	uint64_t		ino)
+{
+	void			*p;
+
+	p = realloc(pc->pc_fname, namelen + 1);
+	if (!p)
+		return errno;
+	pc->pc_fname = p;
+	memcpy(pc->pc_fname, name, namelen);
+	pc->pc_fname[namelen] = 0;
+	pc->pc_ino = ino;
+	return 0;
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
diff --git a/libfrog/paths.h b/libfrog/paths.h
index f20a2c3ef58..6be74c42b07 100644
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
+int path_component_change(struct path_component *pc, const void *name,
+		size_t namelen, uint64_t ino);
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
 #endif	/* __LIBFROG_PATH_H__ */
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 333c2190900..1e8fe9ac5f1 100644
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
 


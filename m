Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B97D1854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309599; cv=none; b=WpCq8Mg5fKdldUGRbwHWTLqvuFFY6/HBPgnl5SMmJY21qeZBED3trmvTI2QSv5TA/anDRb/+mW1d23xWm8NsScEP5Sa7aXz5dyeh1JE+C1QPDVbZsK7Lh8e9jxOqiJG7XuOR+Zm63cSjO6XvwPK3vwf4Va/xanH74q7Gv6PcN3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309599; c=relaxed/simple;
	bh=d15uRViIp3FIDu2c3wVeq1EM+Ge9zz7UjG+1D30MFL8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wg4loFQEp/vLbNQWz9LWG6OehRq0lHxGJq2EiB2yG0w0qXtKBZubkM2za+J3TXwmDpkw4mjfwj0lFYa0s7wwXa6CBa0JXc3VmU6X5njqWpki7UVuDZPetdcePJrfrUzCjcNTyT0m41DkJuyPV7w2diReJzWKQtvVuopXkQB1/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njWYwH5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njWYwH5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69220C32786;
	Tue, 30 Jul 2024 03:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309599;
	bh=d15uRViIp3FIDu2c3wVeq1EM+Ge9zz7UjG+1D30MFL8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=njWYwH5EFfalTiV55TL/X4+KxLN1fSM1ZaogGXj+NeXyMYdJi985/IWnTkdT6rP4a
	 ZDRTT7jd+b3iuJvskSkO5T6MMMdVpRsQS2AoP97n+RtceYrNzPzD3/vLdW8oYMz0Ja
	 aSTUQEiZAOgeN3q48IpP3fejPv6tLFrO2+8BJZFliQ8VstLYVTVY8/EZ+5zxfgVvEU
	 j3Qawtdbj/iq5SUr48GyQzghz2/hnKd3CKgwMIbuWyBiQbbI75fRRg89/Er34OALQE
	 sWsrxfYE0KZVRnOguBqwksC2S/1CjXtNdYmeh4kE4BAv2J7t6rgqwR3vnua0vd2tAW
	 XCYr7WRIRpDnA==
Date: Mon, 29 Jul 2024 20:19:58 -0700
Subject: [PATCH 1/7] libfrog: support editing filesystem property sets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940585.1543753.1262767533961990704.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
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

Add some library functions so that spaceman and scrub can share the same
code to edit and retrieve filesystem properties.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/Makefile       |    7 ++
 libfrog/fsproperties.c |   39 +++++++++
 libfrog/fsproperties.h |   50 +++++++++++
 libfrog/fsprops.c      |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsprops.h      |   34 ++++++++
 5 files changed, 344 insertions(+)
 create mode 100644 libfrog/fsproperties.c
 create mode 100644 libfrog/fsproperties.h
 create mode 100644 libfrog/fsprops.c
 create mode 100644 libfrog/fsprops.h


diff --git a/libfrog/Makefile b/libfrog/Makefile
index 0b5b23893a13..acddc894ee93 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -20,6 +20,7 @@ convert.c \
 crc32.c \
 file_exchange.c \
 fsgeom.c \
+fsproperties.c \
 getparents.c \
 histogram.c \
 list_sort.c \
@@ -47,6 +48,7 @@ dahashselftest.h \
 div64.h \
 file_exchange.h \
 fsgeom.h \
+fsproperties.h \
 getparents.h \
 histogram.h \
 logging.h \
@@ -60,6 +62,11 @@ workqueue.h
 
 LSRCFILES += gen_crc32table.c
 
+ifeq ($(HAVE_LIBATTR),yes)
+CFILES+=fsprops.c
+HFILES+=fsprops.h
+endif
+
 LDIRT = gen_crc32table crc32table.h
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libfrog/fsproperties.c b/libfrog/fsproperties.c
new file mode 100644
index 000000000000..c317d15c1de0
--- /dev/null
+++ b/libfrog/fsproperties.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include <string.h>
+#include "xfs.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/fsproperties.h"
+#include "list.h"
+
+/* Return the offset of a string in a string table, or -1 if not found. */
+static inline int
+__fsprops_lookup(
+	const char	*values[],
+	unsigned int	nr_values,
+	const char	*value)
+{
+	unsigned int	i;
+
+	for (i = 0; i < nr_values; i++) {
+		if (values[i] && !strcmp(value, values[i]))
+			return i;
+	}
+
+	return -1;
+}
+
+#define fsprops_lookup(values, value) \
+	__fsprops_lookup((values), ARRAY_SIZE(values), (value))
+
+/* Return true if a fs property name=value tuple is allowed. */
+bool
+fsprop_validate(
+	const char	*name,
+	const char	*value)
+{
+	return true;
+}
diff --git a/libfrog/fsproperties.h b/libfrog/fsproperties.h
new file mode 100644
index 000000000000..6dee8259a437
--- /dev/null
+++ b/libfrog/fsproperties.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_FSPROPERTIES_H__
+#define __LIBFROG_FSPROPERTIES_H__
+
+/* Name space for filesystem properties. */
+#define XFS_FSPROPS_NS		"trusted"
+
+/*
+ * All filesystem property xattr names must have this string after the
+ * namespace.  For example, the VFS xattr calls should use the name
+ * "trusted.xfs:fubar".  The xfs xattr ioctls would set ATTR_ROOT and use the
+ * name "xfs:fubar".
+ */
+#define XFS_FSPROPS_PREFIX	"xfs:"
+
+static inline int
+fsprop_name_to_attr_name(
+	const char		*prop_name,
+	char			**attr_name)
+{
+	return asprintf(attr_name, XFS_FSPROPS_PREFIX "%s", prop_name);
+}
+
+static inline const char *
+attr_name_to_fsprop_name(
+	const char		*attr_name)
+{
+	const size_t		bytes = sizeof(XFS_FSPROPS_PREFIX) - 1;
+	unsigned int		i;
+
+	for (i = 0; i < bytes; i++) {
+		if (attr_name[i] == 0)
+			return NULL;
+	}
+
+	if (memcmp(attr_name, XFS_FSPROPS_PREFIX, bytes) != 0)
+		return NULL;
+
+	return attr_name + bytes;
+}
+
+bool fsprop_validate(const char *name, const char *value);
+
+/* Specific Filesystem Properties */
+
+#endif /* __LIBFROG_FSPROPERTIES_H__ */
diff --git a/libfrog/fsprops.c b/libfrog/fsprops.c
new file mode 100644
index 000000000000..d6d143efe027
--- /dev/null
+++ b/libfrog/fsprops.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "handle.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/paths.h"
+#include "libfrog/bulkstat.h"
+#include "libfrog/fsprops.h"
+#include "libfrog/fsproperties.h"
+
+#include <attr/attributes.h>
+
+/*
+ * Given an xfd and a mount table path, get us the handle for the root dir so
+ * we can set filesystem properties.
+ */
+int
+fsprops_open_handle(
+	struct xfs_fd		*xfd,
+	struct fs_path		*fs_path,
+	struct fsprops_handle	*fph)
+{
+	struct xfs_bulkstat	bulkstat;
+	struct stat		sb;
+	int			fd;
+	int			ret;
+
+	/* fs properties only supported on V5 filesystems */
+	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_V5SB)) {
+		errno = EOPNOTSUPP;
+		return -1;
+	}
+
+	ret = -xfrog_bulkstat_single(xfd, XFS_BULK_IREQ_SPECIAL_ROOT,
+			XFS_BULK_IREQ_SPECIAL, &bulkstat);
+	if (ret)
+		return ret;
+
+	fd = open(fs_path->fs_dir, O_RDONLY | O_DIRECTORY);
+	if (fd < 0)
+		return -1;
+
+	ret = fstat(fd, &sb);
+	if (ret)
+		goto out_fd;
+
+	if (sb.st_ino != bulkstat.bs_ino) {
+		errno = ESRMNT;
+		ret = -1;
+		goto out_fd;
+	}
+
+	ret = fd_to_handle(fd, &fph->hanp, &fph->hlen);
+	if (ret)
+		goto out_fd;
+
+out_fd:
+	close(fd);
+	return ret;
+}
+
+/* Free a fsproperties handle. */
+void
+fsprops_free_handle(
+	struct fsprops_handle	*fph)
+{
+	if (fph->hanp)
+		free_handle(fph->hanp, fph->hlen);
+	fph->hanp = NULL;
+	fph->hlen = 0;
+}
+
+/* Call the given callback on every fs property accessible through the handle. */
+int
+fsprops_walk_names(
+	struct fsprops_handle	*fph,
+	fsprops_name_walk_fn	walk_fn,
+	void			*priv)
+{
+	struct attrlist_cursor	cur = { };
+	char			attrbuf[XFS_XATTR_LIST_MAX];
+	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
+	int			ret;
+
+	memset(attrbuf, 0, XFS_XATTR_LIST_MAX);
+
+	while ((ret = attr_list_by_handle(fph->hanp, fph->hlen, attrbuf,
+				XFS_XATTR_LIST_MAX, XFS_IOC_ATTR_ROOT,
+				&cur)) == 0) {
+		unsigned int	i;
+
+		for (i = 0; i < attrlist->al_count; i++) {
+			struct attrlist_ent	*ent = ATTR_ENTRY(attrlist, i);
+			const char		*p =
+				attr_name_to_fsprop_name(ent->a_name);
+
+			if (p) {
+				ret = walk_fn(fph, p, ent->a_valuelen, priv);
+				if (ret)
+					break;
+			}
+		}
+
+		if (!attrlist->al_more)
+			break;
+	}
+
+	return ret;
+}
+
+/* Retrieve the value of a specific fileystem property. */
+int
+fsprops_get(
+	struct fsprops_handle	*fph,
+	const char		*name,
+	void			*valuebuf,
+	size_t			*valuelen)
+{
+	struct xfs_attr_multiop	ops = {
+		.am_opcode	= ATTR_OP_GET,
+		.am_attrvalue	= valuebuf,
+		.am_length	= *valuelen,
+		.am_flags	= XFS_IOC_ATTR_ROOT,
+	};
+	int			ret;
+
+	ret = fsprop_name_to_attr_name(name, (char **)&ops.am_attrname);
+	if (ret < 0)
+		return ret;
+
+	ret = attr_multi_by_handle(fph->hanp, fph->hlen, &ops, 1, 0);
+	if (ret < 0)
+		goto out_name;
+
+	if (ops.am_error) {
+		errno = -ops.am_error;
+		ret = -1;
+		goto out_name;
+	}
+
+	*valuelen = ops.am_length;
+out_name:
+	free(ops.am_attrname);
+	return ret;
+}
+
+/* Set the value of a specific fileystem property. */
+int
+fsprops_set(
+	struct fsprops_handle	*fph,
+	const char		*name,
+	void			*valuebuf,
+	size_t			valuelen)
+{
+	struct xfs_attr_multiop	ops = {
+		.am_opcode	= ATTR_OP_SET,
+		.am_attrvalue	= valuebuf,
+		.am_length	= valuelen,
+		.am_flags	= XFS_IOC_ATTR_ROOT,
+	};
+	int			ret;
+
+	ret = fsprop_name_to_attr_name(name, (char **)&ops.am_attrname);
+	if (ret < 0)
+		return ret;
+
+	ret = attr_multi_by_handle(fph->hanp, fph->hlen, &ops, 1, 0);
+	if (ret < 0)
+		goto out_name;
+
+	if (ops.am_error) {
+		errno = -ops.am_error;
+		ret = -1;
+		goto out_name;
+	}
+
+out_name:
+	free(ops.am_attrname);
+	return ret;
+}
+
+/* Unset the value of a specific fileystem property. */
+int
+fsprops_remove(
+	struct fsprops_handle	*fph,
+	const char		*name)
+{
+	struct xfs_attr_multiop	ops = {
+		.am_opcode	= ATTR_OP_REMOVE,
+		.am_flags	= XFS_IOC_ATTR_ROOT,
+	};
+	int			ret;
+
+	ret = fsprop_name_to_attr_name(name, (char **)&ops.am_attrname);
+	if (ret < 0)
+		return ret;
+
+	ret = attr_multi_by_handle(fph->hanp, fph->hlen, &ops, 1, 0);
+	if (ret < 0)
+		goto out_name;
+
+	if (ops.am_error) {
+		errno = -ops.am_error;
+		ret = -1;
+		goto out_name;
+	}
+
+out_name:
+	free(ops.am_attrname);
+	return ret;
+}
diff --git a/libfrog/fsprops.h b/libfrog/fsprops.h
new file mode 100644
index 000000000000..9276f2425191
--- /dev/null
+++ b/libfrog/fsprops.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_FSPROPS_H__
+#define __LIBFROG_FSPROPS_H__
+
+/* Edit and view filesystem property sets. */
+
+struct fsprops_handle {
+	void	*hanp;
+	size_t	hlen;
+};
+
+struct xfs_fd;
+struct fs_path;
+
+int fsprops_open_handle(struct xfs_fd *xfd, struct fs_path *fspath,
+		struct fsprops_handle *fph);
+void fsprops_free_handle(struct fsprops_handle *fph);
+
+typedef int (*fsprops_name_walk_fn)(struct fsprops_handle *fph,
+		const char *name, size_t valuelen, void *priv);
+
+int fsprops_walk_names(struct fsprops_handle *fph, fsprops_name_walk_fn walk_fn,
+		void *priv);
+int fsprops_get(struct fsprops_handle *fph, const char *name, void *attrbuf,
+		size_t *attrlen);
+int fsprops_set(struct fsprops_handle *fph, const char *name, void *attrbuf,
+		size_t attrlen);
+int fsprops_remove(struct fsprops_handle *fph, const char *name);
+
+#endif /* __LIBFROG_FSPROPS_H__ */


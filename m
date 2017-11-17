Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42250 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760147AbdKQVBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 16:01:14 -0500
Subject: [PATCH 10/27] xfs_scrub: add file space map iteration functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 13:01:09 -0800
Message-ID: <151095246973.4825.18446369636263748964.stgit@magnolia>
In-Reply-To: <151095240950.4825.6375172010231614655.stgit@magnolia>
References: <151095240950.4825.6375172010231614655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

These helpers enable userspace to iterate all the space map information
for a file.  The iteration function uses GETBMAPX.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile  |    2 +
 scrub/filemap.c |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/filemap.h |   39 ++++++++++++++
 3 files changed, 199 insertions(+)
 create mode 100644 scrub/filemap.c
 create mode 100644 scrub/filemap.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 5a2ec67..bf0a813 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -18,6 +18,7 @@ endif	# scrub_prereqs
 HFILES = \
 common.h \
 disk.h \
+filemap.h \
 inodes.h \
 spacemap.h \
 xfs_scrub.h
@@ -25,6 +26,7 @@ xfs_scrub.h
 CFILES = \
 common.c \
 disk.c \
+filemap.c \
 inodes.c \
 phase1.c \
 spacemap.c \
diff --git a/scrub/filemap.c b/scrub/filemap.c
new file mode 100644
index 0000000..a56fc2b
--- /dev/null
+++ b/scrub/filemap.c
@@ -0,0 +1,158 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include <stdio.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "path.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "filemap.h"
+
+/*
+ * These routines provide a simple interface to query the block
+ * mappings of the fork of a given inode via GETBMAPX and call a
+ * function to iterate each mapping result.
+ */
+
+#define BMAP_NR		2048
+
+/* Iterate all the extent block mappings between the key and fork end. */
+bool
+xfs_iterate_filemaps(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	int			fd,
+	int			whichfork,
+	struct xfs_bmap		*key,
+	xfs_bmap_iter_fn	fn,
+	void			*arg)
+{
+	struct fsxattr		fsx;
+	struct getbmapx		*map;
+	struct getbmapx		*p;
+	struct xfs_bmap		bmap;
+	char			bmap_descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_off_t		new_off;
+	int			getxattr_type;
+	int			i;
+	int			error;
+
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s attr"), descr);
+		break;
+	case XFS_COW_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s CoW"), descr);
+		break;
+	case XFS_DATA_FORK:
+		snprintf(bmap_descr, DESCR_BUFSZ, _("%s data"), descr);
+		break;
+	default:
+		abort();
+	}
+
+	map = calloc(BMAP_NR, sizeof(struct getbmapx));
+	if (!map) {
+		str_errno(ctx, bmap_descr);
+		return false;
+	}
+
+	map->bmv_offset = BTOBB(key->bm_offset);
+	map->bmv_block = BTOBB(key->bm_physical);
+	if (key->bm_length == 0)
+		map->bmv_length = ULLONG_MAX;
+	else
+		map->bmv_length = BTOBB(key->bm_length);
+	map->bmv_count = BMAP_NR;
+	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
+			  BMV_IF_NO_HOLES;
+	switch (whichfork) {
+	case XFS_ATTR_FORK:
+		getxattr_type = XFS_IOC_FSGETXATTRA;
+		map->bmv_iflags |= BMV_IF_ATTRFORK;
+		break;
+	case XFS_COW_FORK:
+		map->bmv_iflags |= BMV_IF_COWFORK;
+		getxattr_type = FS_IOC_FSGETXATTR;
+		break;
+	case XFS_DATA_FORK:
+		getxattr_type = FS_IOC_FSGETXATTR;
+		break;
+	default:
+		abort();
+	}
+
+	error = ioctl(fd, getxattr_type, &fsx);
+	if (error < 0) {
+		str_errno(ctx, bmap_descr);
+		moveon = false;
+		goto out;
+	}
+
+	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
+		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
+			bmap.bm_offset = BBTOB(p->bmv_offset);
+			bmap.bm_physical = BBTOB(p->bmv_block);
+			bmap.bm_length = BBTOB(p->bmv_length);
+			bmap.bm_flags = p->bmv_oflags;
+			moveon = fn(ctx, bmap_descr, fd, whichfork, &fsx,
+					&bmap, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
+		}
+
+		if (map->bmv_entries == 0)
+			break;
+		p = map + map->bmv_entries;
+		if (p->bmv_oflags & BMV_OF_LAST)
+			break;
+
+		new_off = p->bmv_offset + p->bmv_length;
+		map->bmv_length -= new_off - map->bmv_offset;
+		map->bmv_offset = new_off;
+	}
+
+	/*
+	 * Pre-reflink filesystems don't know about CoW forks, so don't
+	 * be too surprised if it fails.
+	 */
+	if (whichfork == XFS_COW_FORK && error && errno == EINVAL)
+		error = 0;
+
+	if (error)
+		str_errno(ctx, bmap_descr);
+out:
+	memcpy(key, map, sizeof(struct getbmapx));
+	free(map);
+	return moveon;
+}
diff --git a/scrub/filemap.h b/scrub/filemap.h
new file mode 100644
index 0000000..17c0be7
--- /dev/null
+++ b/scrub/filemap.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef XFS_SCRUB_FILEMAP_H_
+#define XFS_SCRUB_FILEMAP_H_
+
+/* inode fork block mapping */
+struct xfs_bmap {
+	uint64_t	bm_offset;	/* file offset of segment in bytes */
+	uint64_t	bm_physical;	/* physical starting byte  */
+	uint64_t	bm_length;	/* length of segment, bytes */
+	uint32_t	bm_flags;	/* output flags */
+};
+
+typedef bool (*xfs_bmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+		int fd, int whichfork, struct fsxattr *fsx,
+		struct xfs_bmap *bmap, void *arg);
+
+bool xfs_iterate_filemaps(struct scrub_ctx *ctx, const char *descr, int fd,
+		int whichfork, struct xfs_bmap *key, xfs_bmap_iter_fn fn,
+		void *arg);
+
+#endif /* XFS_SCRUB_FILEMAP_H_ */


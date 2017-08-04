Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33694 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAIb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:08:31 -0400
Subject: [PATCH 08/22] xfs_scrub: scan inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:08:25 -0700
Message-ID: <150180530561.18784.2389811356084111676.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Scan all the inodes in the system for problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile |    1 
 scrub/ioctl.c  |  366 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/ioctl.h  |    1 
 scrub/phase3.c |  140 +++++++++++++++++++++
 scrub/scrub.c  |    1 
 scrub/xfs.c    |   88 +++++++++++++
 scrub/xfs.h    |    4 +
 7 files changed, 601 insertions(+)
 create mode 100644 scrub/phase3.c


diff --git a/scrub/Makefile b/scrub/Makefile
index 5ac4962..e583cb9 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -30,6 +30,7 @@ disk.c \
 ioctl.c \
 phase1.c \
 phase2.c \
+phase3.c \
 scrub.c \
 xfs.c
 
diff --git a/scrub/ioctl.c b/scrub/ioctl.c
index 2fb039c..a3b7c04 100644
--- a/scrub/ioctl.c
+++ b/scrub/ioctl.c
@@ -29,6 +29,186 @@
 #include "common.h"
 #include "ioctl.h"
 
+#define FSMAP_NR		65536
+#define BMAP_NR			2048
+
+/* Call the handler function. */
+static int
+xfs_iterate_inode_func(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn,
+	struct xfs_bstat	*bs,
+	struct xfs_handle	*handle,
+	void			*arg)
+{
+	int			error;
+
+	handle->ha_fid.fid_ino = bs->bs_ino;
+	handle->ha_fid.fid_gen = bs->bs_gen;
+	error = fn(ctx, handle, bs, arg);
+	if (error)
+		return error;
+	if (xfs_scrub_excessive_errors(ctx))
+		return XFS_ITERATE_INODES_ABORT;
+	return 0;
+}
+
+/*
+ * Iterate a range of inodes.
+ *
+ * This is a little more involved than repeatedly asking BULKSTAT for a
+ * buffer's worth of stat data for some number of inodes.  We want to
+ * scan as many of the inodes that the inobt thinks there are, including
+ * the ones that are broken, but if we ask for n inodes start at x,
+ * it'll skip the bad ones and fill from beyond the range (x + n).
+ *
+ * Therefore, we ask INUMBERS to return one inobt chunk's worth of inode
+ * bitmap information.  Then we try to BULKSTAT only the inodes that
+ * were present in that chunk, and compare what we got against what
+ * INUMBERS said was there.  If there's a mismatch, we know that we have
+ * an inode that fails the verifiers but so we can inject the bulkstat
+ * information to force the scrub code to deal with the broken inodes.
+ *
+ * If the iteration function returns ESTALE, that means that the inode
+ * has been deleted and possibly recreated since the BULKSTAT call.  We
+ * wil refresh the stat information and try again up to 30 times before
+ * reporting the staleness as an error.
+ */
+bool
+xfs_iterate_inodes(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	void			*fshandle,
+	uint64_t		first_ino,
+	uint64_t		last_ino,
+	xfs_inode_iter_fn	fn,
+	void			*arg)
+{
+	struct xfs_fsop_bulkreq	igrpreq = {0};
+	struct xfs_fsop_bulkreq	bulkreq = {0};
+	struct xfs_fsop_bulkreq	onereq = {0};
+	struct xfs_handle	handle;
+	struct xfs_inogrp	inogrp;
+	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK] = {0};
+	char			idescr[DESCR_BUFSZ];
+	char			buf[DESCR_BUFSZ];
+	struct xfs_bstat	*bs;
+	__u64			last_stale = first_ino - 1;
+	__u64			igrp_ino;
+	__u64			oneino;
+	__u64			ino;
+	__s32			bulklen = 0;
+	__s32			onelen = 0;
+	__s32			igrplen = 0;
+	bool			moveon = true;
+	int			i;
+	int			error;
+	int			stale_count = 0;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_BULKSTAT"));
+
+	onereq.lastip  = &oneino;
+	onereq.icount  = 1;
+	onereq.ocount  = &onelen;
+
+	bulkreq.lastip  = &ino;
+	bulkreq.icount  = XFS_INODES_PER_CHUNK;
+	bulkreq.ubuffer = &bstat;
+	bulkreq.ocount  = &bulklen;
+
+	igrpreq.lastip  = &igrp_ino;
+	igrpreq.icount  = 1;
+	igrpreq.ubuffer = &inogrp;
+	igrpreq.ocount  = &igrplen;
+
+	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
+	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+			sizeof(handle.ha_fid.fid_len);
+	handle.ha_fid.fid_pad = 0;
+
+	/* Find the inode chunk & alloc mask */
+	igrp_ino = first_ino;
+	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	while (!error && igrplen) {
+		/* Load the inodes. */
+		ino = inogrp.xi_startino - 1;
+		bulkreq.icount = inogrp.xi_alloccount;
+		error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+		if (error)
+			str_warn(ctx, descr, "%s", strerror_r(errno,
+						buf, DESCR_BUFSZ));
+
+		/* Did we get exactly the inodes we expected? */
+		for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
+			if (!(inogrp.xi_allocmask & (1ULL << i)))
+				continue;
+			if (bs->bs_ino == inogrp.xi_startino + i) {
+				bs++;
+				continue;
+			}
+
+			/* Load the one inode. */
+			oneino = inogrp.xi_startino + i;
+			onereq.ubuffer = bs;
+			error = ioctl(ctx->mnt_fd, XFS_IOC_FSBULKSTAT_SINGLE,
+					&onereq);
+			if (error || bs->bs_ino != inogrp.xi_startino + i) {
+				memset(bs, 0, sizeof(struct xfs_bstat));
+				bs->bs_ino = inogrp.xi_startino + i;
+				bs->bs_blksize = ctx->mnt_sv.f_frsize;
+			}
+			bs++;
+		}
+
+		/* Iterate all the inodes. */
+		for (i = 0, bs = bstat; i < inogrp.xi_alloccount; i++, bs++) {
+			if (bs->bs_ino > last_ino)
+				goto out;
+
+			error = xfs_iterate_inode_func(ctx, fn, bs, &handle,
+					arg);
+			switch (error) {
+			case 0:
+				break;
+			case ESTALE:
+				if (last_stale == inogrp.xi_startino)
+					stale_count++;
+				else {
+					last_stale = inogrp.xi_startino;
+					stale_count = 0;
+				}
+				if (stale_count < 30) {
+					igrp_ino = inogrp.xi_startino;
+					goto igrp_retry;
+				}
+				snprintf(idescr, DESCR_BUFSZ, "inode %llu",
+						bs->bs_ino);
+				str_warn(ctx, idescr, "%s", strerror_r(error,
+						buf, DESCR_BUFSZ));
+				break;
+			case XFS_ITERATE_INODES_ABORT:
+				error = 0;
+				/* fall thru */
+			default:
+				moveon = false;
+				errno = error;
+				goto err;
+			}
+		}
+
+igrp_retry:
+		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	}
+
+err:
+	if (error) {
+		str_errno(ctx, descr);
+		moveon = false;
+	}
+out:
+	return moveon;
+}
+
 /* Does the kernel support bulkstat? */
 bool
 xfs_can_iterate_inodes(
@@ -53,6 +233,135 @@ xfs_can_iterate_inodes(
 	return error == -1 && errno == EINVAL;
 }
 
+/*
+ * Open a file by handle, or return a negative error code.
+ */
+int
+xfs_open_handle(
+	struct xfs_handle	*handle)
+{
+	return open_by_fshandle(handle, sizeof(*handle),
+			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
+}
+
+/* Iterate all the extent block mappings between the key and fork end. */
+bool
+xfs_iterate_bmap(
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
+	assert(!debug_tweak_on("XFS_SCRUB_NO_BMAP"));
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
+		assert(0);
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
+			  BMV_OF_DELALLOC | BMV_IF_NO_HOLES;
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
+
 /* Does the kernel support getbmapx? */
 bool
 xfs_can_iterate_bmap(
@@ -71,6 +380,63 @@ xfs_can_iterate_bmap(
 	return error == 0;
 }
 
+/* Iterate all the fs block mappings between the two keys. */
+bool
+xfs_iterate_fsmap(
+	struct scrub_ctx	*ctx,
+	const char		*descr,
+	struct fsmap		*keys,
+	xfs_fsmap_iter_fn	fn,
+	void			*arg)
+{
+	struct fsmap_head	*head;
+	struct fsmap		*p;
+	bool			moveon = true;
+	int			i;
+	int			error;
+
+	assert(!debug_tweak_on("XFS_SCRUB_NO_FSMAP"));
+
+	head = malloc(fsmap_sizeof(FSMAP_NR));
+	if (!head) {
+		str_errno(ctx, descr);
+		return false;
+	}
+
+	memset(head, 0, sizeof(*head));
+	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
+	head->fmh_count = FSMAP_NR;
+
+	while ((error = ioctl(ctx->mnt_fd, FS_IOC_GETFSMAP, head)) == 0) {
+		for (i = 0, p = head->fmh_recs;
+		     i < head->fmh_entries;
+		     i++, p++) {
+			moveon = fn(ctx, descr, p, arg);
+			if (!moveon)
+				goto out;
+			if (xfs_scrub_excessive_errors(ctx)) {
+				moveon = false;
+				goto out;
+			}
+		}
+
+		if (head->fmh_entries == 0)
+			break;
+		p = &head->fmh_recs[head->fmh_entries - 1];
+		if (p->fmr_flags & FMR_OF_LAST)
+			break;
+		fsmap_advance(head);
+	}
+
+	if (error) {
+		str_errno(ctx, descr);
+		moveon = false;
+	}
+out:
+	free(head);
+	return moveon;
+}
+
 /* Does the kernel support getfsmap? */
 bool
 xfs_can_iterate_fsmap(
diff --git a/scrub/ioctl.h b/scrub/ioctl.h
index c255bbb..ee2ac26 100644
--- a/scrub/ioctl.h
+++ b/scrub/ioctl.h
@@ -45,6 +45,7 @@ bool xfs_iterate_bmap(struct scrub_ctx *ctx, const char *descr, int fd,
 		int whichfork, struct xfs_bmap *key, xfs_bmap_iter_fn fn,
 		void *arg);
 bool xfs_can_iterate_bmap(struct scrub_ctx *ctx);
+int xfs_open_handle(struct xfs_handle *handle);
 
 /* filesystem reverse mapping */
 typedef bool (*xfs_fsmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
diff --git a/scrub/phase3.c b/scrub/phase3.c
new file mode 100644
index 0000000..cdd8a7c
--- /dev/null
+++ b/scrub/phase3.c
@@ -0,0 +1,140 @@
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
+#include "libxfs.h"
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include "disk.h"
+#include "../repair/threads.h"
+#include "handle.h"
+#include "path.h"
+#include "scrub.h"
+#include "common.h"
+#include "ioctl.h"
+#include "xfs_fs.h"
+#include "xfs.h"
+
+/* Phase 3: Scan all inodes. */
+
+/*
+ * Scrub part of a file.  If the user passes in a valid fd we assume
+ * that's the file to check; otherwise, pass in the inode number and
+ * generation from bstat and let the kernel sort it out.
+ */
+static bool
+xfs_scrub_fd(
+	struct scrub_ctx	*ctx,
+	bool			(*fn)(struct scrub_ctx *, uint64_t,
+				      uint32_t, int),
+	struct xfs_bstat	*bs,
+	int			fd)
+{
+	if (fd < 0)
+		fd = ctx->mnt_fd;
+	return fn(ctx, bs->bs_ino, bs->bs_gen, ctx->mnt_fd);
+}
+
+/* Verify the contents, xattrs, and extent maps of an inode. */
+static int
+xfs_scrub_inode(
+	struct scrub_ctx	*ctx,
+	struct xfs_handle	*handle,
+	struct xfs_bstat	*bstat,
+	void			*arg)
+{
+	char			descr[DESCR_BUFSZ];
+	bool			moveon = true;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			fd = -1;
+	int			error = 0;
+
+	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	snprintf(descr, DESCR_BUFSZ, _("inode %llu (%u/%u)"), bstat->bs_ino,
+			agno, agino);
+	background_sleep();
+
+	/* Try to open the inode to pin it. */
+	if (S_ISREG(bstat->bs_mode)) {
+		fd = xfs_open_handle(handle);
+		if (fd < 0) {
+			error = errno;
+			if (error != ESTALE)
+				str_errno(ctx, descr);
+			goto out;
+		}
+	}
+
+	/* Scrub the inode. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, fd);
+	if (!moveon)
+		goto out;
+
+	/* Scrub all block mappings. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, fd);
+	if (!moveon)
+		goto out;
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, fd);
+	if (!moveon)
+		goto out;
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, fd);
+	if (!moveon)
+		goto out;
+
+	if (S_ISLNK(bstat->bs_mode)) {
+		/* Check symlink contents. */
+		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino,
+				bstat->bs_gen, ctx->mnt_fd);
+	} else if (S_ISDIR(bstat->bs_mode)) {
+		/* Check the directory entries. */
+		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, fd);
+	}
+	if (!moveon)
+		goto out;
+
+	/* Check all the extended attributes. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, fd);
+	if (!moveon)
+		goto out;
+
+	/* Check parent pointers. */
+	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat, fd);
+	if (!moveon)
+		goto out;
+
+out:
+	if (fd >= 0)
+		close(fd);
+	if (error)
+		return error;
+	return moveon ? 0 : XFS_ITERATE_INODES_ABORT;
+}
+
+/* Verify all the inodes in a filesystem. */
+bool
+xfs_scan_inodes(
+	struct scrub_ctx	*ctx)
+{
+	if (!xfs_scan_all_inodes(ctx, xfs_scrub_inode))
+		return false;
+	xfs_scrub_report_preen_triggers(ctx);
+	return true;
+}
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c068835..4638281 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -417,6 +417,7 @@ run_scrub_phases(
 		},
 		{
 			.descr = _("Scan all inodes."),
+			.fn = xfs_scan_inodes,
 		},
 		{
 			.descr = _("Defer filesystem repairs."),
diff --git a/scrub/xfs.c b/scrub/xfs.c
index e9ad15c..882bd28 100644
--- a/scrub/xfs.c
+++ b/scrub/xfs.c
@@ -42,3 +42,91 @@ xfs_shutdown_fs(
 	if (ioctl(ctx->mnt_fd, XFS_IOC_GOINGDOWN, &flag))
 		str_errno(ctx, ctx->mntpoint);
 }
+
+/* BULKSTAT wrapper routines. */
+struct xfs_scan_inodes {
+	xfs_inode_iter_fn	fn;
+	void			*arg;
+	size_t			array_arg_size;
+	bool			moveon;
+};
+
+/* Scan all the inodes in an AG. */
+static void
+xfs_scan_ag_inodes(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_scan_inodes	*si = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->mp;
+	void			*fn_arg;
+	char			descr[DESCR_BUFSZ];
+	uint64_t		ag_ino;
+	uint64_t		next_ag_ino;
+	bool			moveon;
+
+	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
+				major(ctx->fsinfo.fs_datadev),
+				minor(ctx->fsinfo.fs_datadev),
+				agno);
+
+	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+
+	fn_arg = ((char *)si->arg) + si->array_arg_size * agno;
+	moveon = xfs_iterate_inodes(ctx, descr, ctx->fshandle, ag_ino,
+			next_ag_ino - 1, si->fn, fn_arg);
+	if (!moveon)
+		si->moveon = false;
+}
+
+/* How many array elements should we create to scan all the inodes? */
+static inline size_t
+xfs_scan_all_inodes_array_size(
+	struct scrub_ctx	*ctx)
+{
+	return ctx->geo.agcount;
+}
+
+/* Scan all the inodes in a filesystem. */
+static bool
+xfs_scan_all_inodes_array_arg(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn,
+	void			*arg,
+	size_t			array_arg_size)
+{
+	struct xfs_scan_inodes	si;
+	xfs_agnumber_t		agno;
+	struct work_queue	wq;
+
+	si.moveon = true;
+	si.fn = fn;
+	si.arg = arg;
+	si.array_arg_size = array_arg_size;
+
+	create_work_queue(&wq, (struct xfs_mount *)ctx, scrub_nproc(ctx));
+	for (agno = 0; agno < ctx->geo.agcount; agno++)
+		queue_work(&wq, xfs_scan_ag_inodes, agno, &si);
+	destroy_work_queue(&wq);
+
+	return si.moveon;
+}
+
+bool
+xfs_scan_all_inodes(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn)
+{
+	return xfs_scan_all_inodes_array_arg(ctx, fn, NULL, 0);
+}
+
+bool
+xfs_scan_all_inodes_arg(
+	struct scrub_ctx	*ctx,
+	xfs_inode_iter_fn	fn,
+	void			*arg)
+{
+	return xfs_scan_all_inodes_array_arg(ctx, fn, arg, 0);
+}
diff --git a/scrub/xfs.h b/scrub/xfs.h
index d3c5782..8c442be 100644
--- a/scrub/xfs.h
+++ b/scrub/xfs.h
@@ -21,10 +21,14 @@
 #define XFS_SCRUB_XFS_H_
 
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
+bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn);
+bool xfs_scan_all_inodes_arg(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
+		void *arg);
 
 /* Phase-specific functions. */
 bool xfs_cleanup(struct scrub_ctx *ctx);
 bool xfs_scan_fs(struct scrub_ctx *ctx);
 bool xfs_scan_metadata(struct scrub_ctx *ctx);
+bool xfs_scan_inodes(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_XFS_H_ */


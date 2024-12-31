Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E135E1B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688723; cv=none; b=DlA/QyEYMqBzEaKAT+cVK+tBevV/wmZtkaO+B7zY4BrubRWkwJ6uxwHve7rX9I7WMfvgBdBUa8VCKEXPZ7nSTqqRx0DwUJsNAAPydYGWHErUG8wQyvjUZNf4jd+bm7m/O2nk1HZvYpx4ICiKgicpKPr4X10z7G6dMZsg2O1wqoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688723; c=relaxed/simple;
	bh=OblL/dLkuUwoe8muFK3ADuTLxL7PFJ/3UKqXXvCuB4M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFzrWC9lhfkzFesqKF7wG9zIN2wcRRsmLyg7UviL7Wtku0f4efL4LxDd8RaW4FpGnr9MOjiRGG6jJVHuRAb5X1mNnFWpQGgeGMfoGOGKDS7/JEA1BW/BkgdzuP+pDd5ijlXdognj0UjGLYC7PdQn63xmB6n5zyJamaQz5MTK5AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTRwPXk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTRwPXk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A663C4CED2;
	Tue, 31 Dec 2024 23:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688722;
	bh=OblL/dLkuUwoe8muFK3ADuTLxL7PFJ/3UKqXXvCuB4M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GTRwPXk3N8JmQalXD7xpNwTWQTZakoMUkQrMBhT5jQee6ACVTeva3kYoK7UJuLOh2
	 Xk77UlawVl1e2l3TcDKI6Huw6lDB8XOaoRigV0/NUdXuRf7HqBQxEGA3wJg+VhOzDn
	 owHCt1Uk67P8zKbHuq5bLUwRJl2kroaL7fuAeLb7l6JDBLngUepxCfvD2NRAzP2R6u
	 Zz3iChRfChOMhOchtYJU9bBzUdjMLYQ31O9WmZz5OVgQurxLF7YL7RlkyBxJetiQLq
	 dRu7zPqt0L29o0aqnDNDI458tXA+UXH0USdECG9XO8/FidhZtQ6ywE/7wZ5daUumIb
	 Kz0IjJg8K9MeQ==
Date: Tue, 31 Dec 2024 15:45:21 -0800
Subject: [PATCH 02/11] xfs: add an ioctl to map free space into a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777900.2709794.4653807334110054797.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
References: <173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new ioctl to map free physical space into a file, at the same file
offset as if the file were a sparse image of the physical device backing
the filesystem.  The intent here is to use this to prototype a free
space defragmentation tool.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/xfs_trace.h             |    4 ++
 libxfs/libxfs_priv.h            |    9 ++++
 libxfs/xfs_alloc.c              |   88 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.h              |    3 +
 libxfs/xfs_fs.h                 |   14 ++++++
 man/man2/ioctl_xfs_map_freesp.2 |   76 ++++++++++++++++++++++++++++++++++
 6 files changed, 194 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_map_freesp.2


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 7778366c5e3319..178497c8770d37 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -26,6 +26,8 @@
 #define trace_xfs_alloc_exact_done(a)		((void) 0)
 #define trace_xfs_alloc_exact_notfound(a)	((void) 0)
 #define trace_xfs_alloc_exact_error(a)		((void) 0)
+#define trace_xfs_alloc_find_freesp(...)	((void) 0)
+#define trace_xfs_alloc_find_freesp_done(...)	((void) 0)
 #define trace_xfs_alloc_near_first(a)		((void) 0)
 #define trace_xfs_alloc_near_greater(a)		((void) 0)
 #define trace_xfs_alloc_near_lesser(a)		((void) 0)
@@ -197,6 +199,8 @@
 
 #define trace_xfs_bmap_pre_update(a,b,c,d)	((void) 0)
 #define trace_xfs_bmap_post_update(a,b,c,d)	((void) 0)
+#define trace_xfs_bmapi_freesp(...)		((void) 0)
+#define trace_xfs_bmapi_freesp_done(...)	((void) 0)
 #define trace_xfs_bunmap(a,b,c,d,e)		((void) 0)
 #define trace_xfs_read_extent(a,b,c,d)		((void) 0)
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ac2f64a9a75d82..932a45d734d460 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -446,6 +446,15 @@ xfs_buf_readahead(
 #define xfs_filestream_new_ag(ip,ag)		(0)
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
+struct xfs_trans;
+
+static inline int
+xfs_rtallocate_extent(struct xfs_trans *tp, xfs_rtxnum_t start,
+		xfs_rtxlen_t maxlen, xfs_rtxlen_t *len, xfs_rtxnum_t *rtx)
+{
+	return -EOPNOTSUPP;
+}
+
 #define xfs_trans_inode_buf(tp, bp)		((void) 0)
 
 /* quota bits */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 9aebe7227a6148..e21b694420e309 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -4164,3 +4164,91 @@ xfs_extfree_intent_destroy_cache(void)
 	kmem_cache_destroy(xfs_extfree_item_cache);
 	xfs_extfree_item_cache = NULL;
 }
+
+/*
+ * Find the next chunk of free space in @pag starting at @agbno and going no
+ * higher than @end_agbno.  Set @agbno and @len to whatever free space we find,
+ * or to @end_agbno if we find no space.
+ */
+int
+xfs_alloc_find_freesp(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		*agbno,
+	xfs_agblock_t		end_agbno,
+	xfs_extlen_t		*len)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agf_bp = NULL;
+	xfs_agblock_t		found_agbno;
+	xfs_extlen_t		found_len;
+	int			found;
+	int			error;
+
+	trace_xfs_alloc_find_freesp(pag_group(pag), *agbno,
+			end_agbno - *agbno);
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+	if (error)
+		return error;
+
+	cur = xfs_bnobt_init_cursor(mp, tp, agf_bp, pag);
+
+	/* Try to find a free extent that starts before here. */
+	error = xfs_alloc_lookup_le(cur, *agbno, 0, &found);
+	if (error)
+		goto out_cur;
+	if (found) {
+		error = xfs_alloc_get_rec(cur, &found_agbno, &found_len,
+				&found);
+		if (error)
+			goto out_cur;
+		if (XFS_IS_CORRUPT(mp, !found)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		if (found_agbno + found_len > *agbno)
+			goto found;
+	}
+
+	/* Examine the next record if free extent not in range. */
+	error = xfs_btree_increment(cur, 0, &found);
+	if (error)
+		goto out_cur;
+	if (!found)
+		goto next_ag;
+
+	error = xfs_alloc_get_rec(cur, &found_agbno, &found_len, &found);
+	if (error)
+		goto out_cur;
+	if (XFS_IS_CORRUPT(mp, !found)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto out_cur;
+	}
+
+	if (found_agbno >= end_agbno)
+		goto next_ag;
+
+found:
+	/* Found something, so update the mapping. */
+	trace_xfs_alloc_find_freesp_done(pag_group(pag), found_agbno,
+			found_len);
+	if (found_agbno < *agbno) {
+		found_len -= *agbno - found_agbno;
+		found_agbno = *agbno;
+	}
+	*len = found_len;
+	*agbno = found_agbno;
+	goto out_cur;
+next_ag:
+	/* Found nothing, so advance the cursor beyond the end of the range. */
+	*agbno = end_agbno;
+	*len = 0;
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 50ef79a1ed41a1..069077d9ad2f8c 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -286,5 +286,8 @@ void xfs_extfree_intent_destroy_cache(void);
 
 xfs_failaddr_t xfs_validate_ag_length(struct xfs_buf *bp, uint32_t seqno,
 		uint32_t length);
+int xfs_alloc_find_freesp(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_agblock_t *agbno, xfs_agblock_t end_agbno,
+		xfs_extlen_t *len);
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 936f719236944f..f4128dbdf3b9a2 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1087,6 +1087,19 @@ xfs_getfsrefs_advance(
 /* fcr_flags values - returned for each non-header segment */
 #define FCR_OF_LAST		(1U << 0) /* last record in the dataset */
 
+/* map free space to file */
+
+/*
+ * XFS_IOC_MAP_FREESP maps all the free physical space in the filesystem into
+ * the file at the same offsets.  This ioctl requires CAP_SYS_ADMIN.
+ */
+struct xfs_map_freesp {
+	__s64	offset;		/* disk address to map, in bytes */
+	__s64	len;		/* length in bytes */
+	__u64	flags;		/* must be zero */
+	__u64	pad;		/* must be zero */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1127,6 +1140,7 @@ xfs_getfsrefs_advance(
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_GETFSREFCOUNTS	_IOWR('X', 66, struct xfs_getfsrefs_head)
+#define XFS_IOC_MAP_FREESP	_IOW ('X', 67, struct xfs_map_freesp)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/man/man2/ioctl_xfs_map_freesp.2 b/man/man2/ioctl_xfs_map_freesp.2
new file mode 100644
index 00000000000000..ecd2d08f3fdeee
--- /dev/null
+++ b/man/man2/ioctl_xfs_map_freesp.2
@@ -0,0 +1,76 @@
+.\" Copyright (c) 2023-2025 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-MAP-FREESP 2 2023-11-17 "XFS"
+.SH NAME
+ioctl_xfs_map_freesp \- map free space into a file
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_MAP_FREESP, struct xfs_map_freesp *" arg );
+.SH DESCRIPTION
+Maps free space into the sparse ranges of a regular file.
+This ioctl uses
+.B struct xfs_map_freesp
+to specify the range of free space to be mapped:
+.PP
+.in +4n
+.nf
+struct xfs_map_freesp {
+	__s64   offset;
+	__s64   len;
+	__s64   flags;
+	__s64   pad;
+};
+.fi
+.in
+.PP
+.I offset
+is the physical disk address, in bytes, of the start of the range to scan.
+Each free space extent in this range will be mapped to the file if the
+corresponding range of the file is sparse.
+.PP
+.I len
+is the number of bytes in the range to scan.
+.PP
+.I flags
+must be zero; there are no flags defined yet.
+.PP
+.I pad
+must be zero.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFAULT
+The kernel was not able to copy into the userspace buffer.
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+One of the arguments was not valid,
+or the file was not sparse.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B ENOMEM
+There was insufficient memory to perform the query.
+.TP
+.B ENOSPC
+There was insufficient disk space to commit the space mappings.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)


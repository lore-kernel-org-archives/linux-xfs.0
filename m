Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4DEC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjlvPDIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4424C433C8;
	Sun, 31 Dec 2023 23:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064078;
	bh=RflnodAJshQ2Xv6LlzKhiCVA/0SKTkLBzuj8LUf0y9M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NjlvPDIJnK2DahzTi74iRySsrQTpyhu5d7zGFJyPKdLew95e3VRv7kIuAheoqFAB1
	 pPy3OJdu5O+ar8KRvu1dLDdIX0+9c5srWADsNKlFfI3deWzYL/iTxfS9wyGCiOyDPB
	 sn+2iFWpptxDarnYkJ85ZqGxXBE7cnh35V1nZp/CaOrv2vTqJDvh9SYeJciKxcVeRh
	 5A4OC+6dMtSaoC8dh5clJMDbtS4oEldyqH7C0Gc00KcJqLW+Vtz3IdxhzvvPBDh3me
	 AVIN7x1ztfNJ42NkToaD5lzXeG1ea3NMxu7TOTk+I5l9t60iCB8lVsPOXhBIkvDQ8I
	 nMG6ZSWlYczpw==
Date: Sun, 31 Dec 2023 15:07:58 -0800
Subject: [PATCH 11/32] xfs: Add parent pointer ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006249.1804688.11477606075426879369.stgit@frogsfrogsfrogs>
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

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move new ioctl to xfs_fs_staging.h, adjust to new ondisk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                 |    1 
 libxfs/xfs_fs_staging.h         |   66 +++++++++++
 libxfs/xfs_ondisk.h             |    4 +
 libxfs/xfs_parent.c             |   62 +++++++++++
 libxfs/xfs_parent.h             |   25 ++++
 man/man2/ioctl_xfs_getparents.2 |  227 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 385 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_getparents.2


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 63a145e5035..e92b6a9612a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -811,6 +811,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+/*	XFS_IOC_GETPARENTS ---- staging 62         */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index e3d9f3b32b0..e0650af0558 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -104,4 +104,70 @@ struct xfs_exch_range {
 
 #define XFS_IOC_EXCHANGE_RANGE	_IOWR('X', 129, struct xfs_exch_range)
 
+/* Iterating parent pointers of files. */
+
+/* return parents of the handle, not the open fd */
+#define XFS_GETPARENTS_IFLAG_HANDLE	(1U << 0)
+
+/* target was the root directory */
+#define XFS_GETPARENTS_OFLAG_ROOT	(1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_GETPARENTS_OFLAG_DONE	(1U << 2)
+
+#define XFS_GETPARENTS_FLAG_ALL		(XFS_GETPARENTS_IFLAG_HANDLE | \
+					 XFS_GETPARENTS_OFLAG_ROOT | \
+					 XFS_GETPARENTS_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_getparents_rec {
+	__u64		gpr_ino;	/* Inode number */
+	__u32		gpr_gen;	/* Inode generation */
+	__u32		gpr_pad;	/* Reserved */
+	__u64		gpr_rsvd;	/* Reserved */
+	__u8		gpr_name[];	/* File name and null terminator */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_getparents {
+	/* File handle, if XFS_GETPARENTS_IFLAG_HANDLE is set */
+	struct xfs_handle		gp_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	gp_cursor;
+
+	/* Operational flags: XFS_GETPARENTS_*FLAG* */
+	__u32				gp_flags;
+
+	/* Must be set to zero */
+	__u32				gp_reserved;
+
+	/* Size of the buffer in bytes, including this header */
+	__u32				gp_bufsize;
+
+	/* # of entries filled in (output) */
+	__u32				gp_count;
+
+	/* Must be set to zero */
+	__u64				gp_reserved2[5];
+
+	/* Byte offset of each record within the buffer */
+	__u32				gp_offsets[];
+};
+
+static inline struct xfs_getparents_rec*
+xfs_getparents_rec(
+	struct xfs_getparents	*info,
+	unsigned int		idx)
+{
+	return (struct xfs_getparents_rec *)((char *)info +
+					     info->gp_offsets[idx]);
+}
+
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index d9c988c5ad6..bffd39242d4 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -155,6 +155,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		96);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 6c98f95f274..92b541737cb 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -305,3 +305,65 @@ xfs_parent_args_free(
 {
 	kmem_cache_free(xfs_parent_args_cache, ppargs);
 }
+
+/* Convert an ondisk parent pointer to the incore format. */
+void
+xfs_parent_irec_from_disk(
+	struct xfs_parent_name_irec	*irec,
+	const struct xfs_parent_name_rec *rec,
+	const void			*value,
+	unsigned int			valuelen)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_namehash = be32_to_cpu(rec->p_namehash);
+	irec->p_namelen = valuelen;
+	memcpy(irec->p_name, value, valuelen);
+}
+
+/* Convert an incore parent pointer to the ondisk attr name format. */
+void
+xfs_parent_irec_to_disk(
+	struct xfs_parent_name_rec	*rec,
+	const struct xfs_parent_name_irec *irec)
+{
+	rec->p_ino = cpu_to_be64(irec->p_ino);
+	rec->p_gen = cpu_to_be32(irec->p_gen);
+	rec->p_namehash = cpu_to_be32(irec->p_namehash);
+}
+
+/* Is this a valid incore parent pointer? */
+bool
+xfs_parent_verify_irec(
+	struct xfs_mount		*mp,
+	const struct xfs_parent_name_irec *irec)
+{
+	struct xfs_name			dname = {
+		.name			= irec->p_name,
+		.len			= irec->p_namelen,
+	};
+
+	if (!xfs_verify_dir_ino(mp, irec->p_ino))
+		return false;
+	if (!xfs_parent_valuecheck(mp, irec->p_name, irec->p_namelen))
+		return false;
+	if (!xfs_dir2_namecheck(irec->p_name, irec->p_namelen))
+		return false;
+	if (irec->p_namehash != xfs_dir2_hashname(mp, &dname))
+		return false;
+	return true;
+}
+
+/* Compute p_namehash for the this parent pointer. */
+void
+xfs_parent_irec_hashname(
+	struct xfs_mount		*mp,
+	struct xfs_parent_name_irec	*irec)
+{
+	struct xfs_name			dname = {
+		.name			= irec->p_name,
+		.len			= irec->p_namelen,
+	};
+
+	irec->p_namehash = xfs_dir2_hashname(mp, &dname);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index c68c501388e..e43ae5a7df8 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -127,4 +127,29 @@ xfs_parent_finish(
 		xfs_parent_args_free(mp, ppargs);
 }
 
+/*
+ * Incore version of a parent pointer, also contains dirent name so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	/* Parent pointer attribute name fields */
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dahash_t		p_namehash;
+
+	/* Parent pointer attribute value fields */
+	uint8_t			p_namelen;
+	unsigned char		p_name[MAXNAMELEN];
+};
+
+void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
+		const struct xfs_parent_name_rec *rec, const void *value,
+		unsigned int valuelen);
+void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec,
+		const struct xfs_parent_name_irec *irec);
+void xfs_parent_irec_hashname(struct xfs_mount *mp,
+		struct xfs_parent_name_irec *irec);
+bool xfs_parent_verify_irec(struct xfs_mount *mp,
+		const struct xfs_parent_name_irec *irec);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/man/man2/ioctl_xfs_getparents.2 b/man/man2/ioctl_xfs_getparents.2
new file mode 100644
index 00000000000..d6987979e85
--- /dev/null
+++ b/man/man2/ioctl_xfs_getparents.2
@@ -0,0 +1,227 @@
+.\" Copyright (c) 2019-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GETPARENTS 2 2023-08-18 "XFS"
+.SH NAME
+ioctl_xfs_getparents \- query XFS directory parent information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.br
+.B #include <xfs/xfs_fs_staging.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETPARENTS, struct xfs_getparents *" arg );
+.SH DESCRIPTION
+This command is used to get a file's parent pointers.
+Parent pointers point upwards in the directory tree from a child file towards a
+parent directories.
+Each entry in a parent directory must have a corresponding parent pointer in
+the child.
+
+Calling programs should allocate a large memory buffer and initialize the
+beginning of the buffer to a header of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_getparents {
+	struct xfs_handle		gp_handle;
+	struct xfs_attrlist_cursor	gp_cursor;
+	__u32				gp_flags;
+	__u32				gp_reserved;
+	__u32				gp_bufsize;
+	__u32				gp_count;
+	__u64				gp_reserved2[5];
+	__u32				gp_offsets[];
+};
+.fi
+.in
+
+.PP
+If the flag
+.B XFS_GETPARENTS_IFLAG_HANDLE
+is set,
+the field
+.I gp_handle
+will be interpreted as if it contains file handle information.
+If the file handle is not stale, the file represented by the handle will be the
+target of the query.
+If the flag is not set, the file represented by
+.I fd
+will be queried instead.
+
+.PP
+The field
+.I gp_cursor
+tracks the progress of iterating through the parent pointers.
+Calling programs must initialize this to zero before the first system call
+and must not touch it after that.
+
+.PP
+The field
+.I gp_flags
+control the behavior of the query operation and provide more information
+about the outcome of the operation.
+.RS 0.4i
+.TP
+.B XFS_GETPARENTS_IFLAG_HANDLE
+If the caller sets this flag, the kernel driver will interpret the
+.I gp_handle
+field as if it were a file handle.
+If the handle maps to an allocated file, that file will be queried for
+parents instead of the open file descriptor.
+.TP
+.B XFS_GETPARENTS_OFLAG_ROOT
+The file queried was the root directory.
+.TP
+.B XFS_GETPARENTS_OFLAG_DONE
+There are no more parent pointers to query.
+.RE
+
+.PP
+The fields
+.I gp_reserved
+and
+.I gp_reserved2
+must be zero.
+
+.PP
+The field
+.I gp_bufsize
+should be set to the size of the buffer, in bytes.
+
+.PP
+The field
+.I gp_count
+will be set to the number of parent pointer records returned.
+
+.PP
+Each element of the array
+.I gp_offsets
+will be set to the byte offset within the buffer of each parent record.
+
+Parent pointer records are returned in the following form:
+.PP
+.in +4n
+.nf
+
+struct xfs_getparents_rec {
+	__u64		gpr_ino;
+	__u32		gpr_gen;
+	__u32		gpr_pad;
+	__u64		gpr_rsvd;
+	__u8			gpr_name[];
+};
+.fi
+.in
+
+.PP
+The field
+.I gpr_ino
+and
+.I gpr_gen
+will be set to the inode number and generation number of the parent.
+
+.PP
+The fields
+.I gpr_pad
+and
+.I gpr_rsvd
+will be set to zero.
+
+.PP
+The array
+.I gpr_name
+will be set to a NULL-terminated byte sequence representing the filename
+stored in the parent pointer.
+
+.SH SAMPLE PROGRAM
+Calling programs should allocate a large memory buffer, initialize the head
+structure to zeroes, set gp_bufsize to the size of the buffer, and call the
+ioctl.
+The kernel will fill out the gp_offsets array with integer offsets to
+struct xfs_getparents_rec objects that are written within the provided memory
+buffer.
+The size of the gp_offsets array is given by gp_count.
+The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_flags when there are no
+more parent pointers to be read.
+The below code is an example of XFS_IOC_GETPARENTS usage:
+
+.nf
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <xfs/linux.h>
+#include <xfs/xfs.h>
+#include <xfs/xfs_types.h>
+#include <xfs/xfs_fs.h>
+#include <xfs/xfs_fs_staging.h>
+
+int main() {
+	struct xfs_getparents		*pi;
+	struct xfs_getparents_rec	*p;
+	int				i, error, fd, nr_ptrs = 4;
+
+	error = malloc(65536);
+	if (!error) {
+		perror("malloc");
+		return 1;
+	}
+
+	memset(pi, 0, sizeof(*pi));
+	pi->gp_bufsize = 65536;
+
+	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
+	if (fd  == -1)
+		return errno;
+
+	do {
+		error = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+		if (error)
+			return error;
+
+		for (i = 0; i < pi->gp_count; i++) {
+			p = xfs_getparents_rec(pi, i);
+			printf("inode		= %llu\\n", (unsigned long long)p->gpr_ino);
+			printf("generation	= %u\\n", (unsigned int)p->gpr_gen);
+			printf("name		= \\"%s\\"\\n\\n", (char *)p->gpr_name);
+		}
+	} while (!(pi->gp_flags & XFS_GETPARENTS_OFLAG_DONE));
+
+	return 0;
+}
+.fi
+
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+One or more of the arguments specified is invalid.
+.TP
+.B EOPNOTSUPP
+Repairs of the requested metadata object are not supported.
+.TP
+.B EROFS
+Filesystem is read-only and a repair was requested.
+.TP
+.B ESHUTDOWN
+Filesystem is shut down due to previous errors.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)


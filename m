Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCC8BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rO6rsOCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741BEC433C7;
	Sun, 31 Dec 2023 20:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055929;
	bh=CyZZyNtnV/us7AU51pC3DSordnXTeTT0Dkc4jJqrIKc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rO6rsOCdBhCCUs8s72TUMY15jB58uSqkFbG1HCLNQnhoD4/j2cwbGmoYamm7izz+C
	 PpQ6RuAELxu5rhagmENrhl7re6THaQCyMXczEc0iDh7A6PTNW5EKm0TKsqdR2GWMog
	 kw5c0HazPdO+g2vmSiPFHbV1ODq/nPVRQFRXaK/u5Bn+T1+1T6H0zYqsZf8hvgXLVZ
	 HxOSXx5Hj9mCX3AABkHPHgTNHTBr3fX4Lb17akOP8GpaQAKbMEAP2t+R7qTReP0T+h
	 7SQTTumfbDwth8gseDvMhEs6+FGOGgyiae/wvPvoIFClxHcfUwKz9kdkdDODg8i3cU
	 gc6vwghwIvsHQ==
Date: Sun, 31 Dec 2023 12:52:08 -0800
Subject: [PATCH 14/18] xfs: Add parent pointer ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841263.1756905.7211684066520577589.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_fs.h         |    1 
 fs/xfs/libxfs/xfs_fs_staging.h |   66 ++++++++++++++++
 fs/xfs/libxfs/xfs_ondisk.h     |    4 +
 fs/xfs/libxfs/xfs_parent.c     |   62 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |   25 ++++++
 fs/xfs/xfs_ioctl.c             |  145 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.c      |  161 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h      |   20 +++++
 fs/xfs/xfs_trace.c             |    1 
 fs/xfs/xfs_trace.h             |   73 ++++++++++++++++++
 11 files changed, 558 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5a358113ad9d7..49480c81eaeab 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -89,6 +89,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 63a145e50350b..e92b6a9612a95 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -811,6 +811,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+/*	XFS_IOC_GETPARENTS ---- staging 62         */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index e3d9f3b32b078..e0650af055895 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
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
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index d9c988c5ad692..bffd39242d487 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
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
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 1bff67f8f1176..48a2dfcc465fa 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -304,3 +304,65 @@ xfs_parent_args_free(
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index c68c501388e82..e43ae5a7df826 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 968412c0ba59e..5db70a11151dd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_xchgrange.h"
@@ -1669,6 +1670,147 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_getparents,
+ * followed by a region large enough to contain an array of struct
+ * xfs_getparents_rec of a size specified in gp_bufsize.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned gp_cursor to resume iteration.  The
+ * number of xfs_getparents_rec returned will be stored in gp_count.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_getparents		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*file_ip = XFS_I(file_inode(filp));
+	struct xfs_inode		*call_ip = file_ip;
+	struct xfs_mount		*mp = file_ip->i_mount;
+	void				__user *o_pptr;
+	struct xfs_getparents_rec	*i_pptr;
+	unsigned int			bytes;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_getparents to put the user data */
+	ppi = kvmalloc(sizeof(struct xfs_getparents), GFP_KERNEL);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_getparents));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (ppi->gp_bufsize > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+	if (ppi->gp_bufsize < sizeof(struct xfs_getparents)) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (ppi->gp_flags & ~XFS_GETPARENTS_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->gp_flags &= ~(XFS_GETPARENTS_OFLAG_ROOT | XFS_GETPARENTS_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_getparents to be the same size
+	 */
+	ppi = kvrealloc(ppi, sizeof(struct xfs_getparents), ppi->gp_bufsize,
+			GFP_KERNEL | __GFP_ZERO);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->gp_flags & XFS_GETPARENTS_IFLAG_HANDLE) {
+		struct xfs_handle	*hanp = &ppi->gp_handle;
+
+		if (memcmp(&hanp->ha_fsid, mp->m_fixedfsid,
+							sizeof(xfs_fsid_t))) {
+			error = -EINVAL;
+			goto out;
+		}
+
+		if (hanp->ha_fid.fid_ino != file_ip->i_ino) {
+			error = xfs_iget(mp, NULL, hanp->ha_fid.fid_ino,
+					XFS_IGET_UNTRUSTED, 0, &call_ip);
+			if (error)
+				goto out;
+
+			/*
+			 * Reload the incore unlinked list to avoid failure in
+			 * inodegc.  Use an unlocked check here because
+			 * unrecovered unlinked inodes should be somewhat rare.
+			 */
+			if (xfs_inode_unlinked_incomplete(call_ip)) {
+				error = xfs_inode_reload_unlinked(call_ip);
+				if (error)
+					goto out;
+			}
+		}
+
+		if (VFS_I(call_ip)->i_generation != hanp->ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
+	}
+
+	/* Get the parent pointers */
+	error = xfs_getparent_pointers(call_ip, ppi);
+	if (error)
+		goto out;
+
+	/*
+	 * If we ran out of buffer space before copying any parent pointers at
+	 * all, the caller's buffer was too short.  Tell userspace that, erm,
+	 * the message is too long.
+	 */
+	if (ppi->gp_count == 0 && !(ppi->gp_flags & XFS_GETPARENTS_OFLAG_DONE)) {
+		error = -EMSGSIZE;
+		goto out;
+	}
+
+	/* Copy the parent pointer head back to the user */
+	bytes = xfs_getparents_arraytop(ppi, ppi->gp_count);
+	error = copy_to_user(arg, ppi, bytes);
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	if (ppi->gp_count == 0)
+		goto out;
+
+	/* Copy the parent pointer records back to the user. */
+	o_pptr = (__user char*)arg + ppi->gp_offsets[ppi->gp_count - 1];
+	i_pptr = xfs_getparents_rec(ppi, ppi->gp_count - 1);
+	bytes = ((char *)ppi + ppi->gp_bufsize) - (char *)i_pptr;
+	error = copy_to_user(o_pptr, i_pptr, bytes);
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	if (call_ip != file_ip)
+		xfs_irele(call_ip);
+	kvfree(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	struct xfs_swapext	*sxp)
@@ -1947,7 +2089,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 0000000000000..95eeac1e79c21
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+#include "xfs_parent_utils.h"
+#include "xfs_health.h"
+
+struct xfs_getparent_ctx {
+	struct xfs_attr_list_context	context;
+	struct xfs_parent_name_irec	pptr_irec;
+	struct xfs_getparents		*ppi;
+};
+
+static inline unsigned int
+xfs_getparents_rec_sizeof(
+	const struct xfs_parent_name_irec	*irec)
+{
+	return round_up(sizeof(struct xfs_getparents_rec) + irec->p_namelen + 1,
+			sizeof(uint32_t));
+}
+
+static void
+xfs_getparent_listent(
+	struct xfs_attr_list_context	*context,
+	int				flags,
+	unsigned char			*name,
+	int				namelen,
+	void				*value,
+	int				valuelen)
+{
+	struct xfs_getparent_ctx	*gp;
+	struct xfs_getparents		*ppi;
+	struct xfs_getparents_rec	*pptr;
+	struct xfs_parent_name_rec	*rec = (void *)name;
+	struct xfs_parent_name_irec	*irec;
+	struct xfs_mount		*mp = context->dp->i_mount;
+	int				arraytop;
+
+	gp = container_of(context, struct xfs_getparent_ctx, context);
+	ppi = gp->ppi;
+	irec = &gp->pptr_irec;
+
+	/* Ignore non-parent xattrs */
+	if (!(flags & XFS_ATTR_PARENT))
+		return;
+
+	/*
+	 * Report corruption for anything that doesn't look like a parent
+	 * pointer.  The attr list functions filtered out INCOMPLETE attrs.
+	 */
+	if (XFS_IS_CORRUPT(mp,
+			!xfs_parent_namecheck(mp, rec, namelen, flags)) ||
+	    XFS_IS_CORRUPT(mp,
+			!xfs_parent_valuecheck(mp, value, valuelen)) ||
+	    XFS_IS_CORRUPT(mp,
+			!xfs_parent_hashcheck(mp, rec, value, valuelen))) {
+		xfs_inode_mark_sick(context->dp, XFS_SICK_INO_PARENT);
+		context->seen_enough = -EFSCORRUPTED;
+		return;
+	}
+
+	xfs_parent_irec_from_disk(&gp->pptr_irec, rec, value, valuelen);
+
+	/*
+	 * We found a parent pointer, but we've filled up the buffer.  Signal
+	 * to the caller that we did /not/ reach the end of the parent pointer
+	 * recordset.
+	 */
+	arraytop = xfs_getparents_arraytop(ppi, ppi->gp_count + 1);
+	context->firstu -= xfs_getparents_rec_sizeof(irec);
+	if (context->firstu < arraytop) {
+		context->seen_enough = 1;
+		return;
+	}
+
+	trace_xfs_getparent_listent(context->dp, ppi, irec);
+
+	/* Format the parent pointer directly into the caller buffer. */
+	ppi->gp_offsets[ppi->gp_count] = context->firstu;
+	pptr = xfs_getparents_rec(ppi, ppi->gp_count);
+	pptr->gpr_ino = irec->p_ino;
+	pptr->gpr_gen = irec->p_gen;
+	pptr->gpr_pad = 0;
+	pptr->gpr_rsvd = 0;
+
+	memcpy(pptr->gpr_name, irec->p_name, irec->p_namelen);
+	pptr->gpr_name[irec->p_namelen] = 0;
+	ppi->gp_count++;
+}
+
+/* Retrieve the parent pointers for a given inode. */
+int
+xfs_getparent_pointers(
+	struct xfs_inode		*ip,
+	struct xfs_getparents		*ppi)
+{
+	struct xfs_getparent_ctx	*gp;
+	int				error;
+
+	gp = kzalloc(sizeof(struct xfs_getparent_ctx), GFP_KERNEL);
+	if (!gp)
+		return -ENOMEM;
+	gp->ppi = ppi;
+	gp->context.dp = ip;
+	gp->context.resynch = 1;
+	gp->context.put_listent = xfs_getparent_listent;
+	gp->context.bufsize = round_down(ppi->gp_bufsize, sizeof(uint32_t));
+	gp->context.firstu = gp->context.bufsize;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&gp->context.cursor, &ppi->gp_cursor,
+			sizeof(struct xfs_attrlist_cursor));
+	ppi->gp_count = 0;
+
+	trace_xfs_getparent_pointers(ip, ppi, &gp->context.cursor);
+
+	error = xfs_attr_list(&gp->context);
+	if (error)
+		goto out_free;
+	if (gp->context.seen_enough < 0) {
+		error = gp->context.seen_enough;
+		goto out_free;
+	}
+
+	/* Is this the root directory? */
+	if (ip->i_ino == ip->i_mount->m_sb.sb_rootino)
+		ppi->gp_flags |= XFS_GETPARENTS_OFLAG_ROOT;
+
+	/*
+	 * If we did not run out of buffer space, then we reached the end of
+	 * the pptr recordset, so set the DONE flag.
+	 */
+	if (gp->context.seen_enough == 0)
+		ppi->gp_flags |= XFS_GETPARENTS_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->gp_cursor, &gp->context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+out_free:
+	kfree(gp);
+	return error;
+}
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 0000000000000..2a1d5306a02c2
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+static inline unsigned int
+xfs_getparents_arraytop(
+	const struct xfs_getparents	*ppi,
+	unsigned int			nr)
+{
+	return sizeof(struct xfs_getparents) +
+			(nr * sizeof(ppi->gp_offsets[0]));
+}
+
+int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_getparents *ppi);
+
+#endif	/* __XFS_PARENT_UTILS_H__ */
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index e38814f4380c8..7ccb7b3473943 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -42,6 +42,7 @@
 #include "xfs_bmap.h"
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
+#include "xfs_parent.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1dac853aa659e..070c76f443737 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -83,6 +83,9 @@ struct xfs_perag;
 struct xfs_bmap_intent;
 struct xfs_swapext_intent;
 struct xfs_swapext_req;
+struct xfs_getparents;
+struct xfs_parent_name_irec;
+struct xfs_attrlist_cursor_kern;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -4981,6 +4984,76 @@ TRACE_EVENT(xfs_swapext_delta_nextents,
 		  __entry->d_nexts1, __entry->d_nexts2)
 );
 
+TRACE_EVENT(xfs_getparent_listent,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
+	         const struct xfs_parent_name_irec *irec),
+	TP_ARGS(ip, ppi, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, count)
+		__field(unsigned int, bufsize)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, irec->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->count = ppi->gp_count;
+		__entry->bufsize = ppi->gp_bufsize;
+		__entry->parent_ino = irec->p_ino;
+		__entry->parent_gen = irec->p_gen;
+		__entry->namelen = irec->p_namelen;
+		memcpy(__get_str(name), irec->p_name, irec->p_namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx bufsize %u count %u: parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->bufsize,
+		  __entry->count,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
+TRACE_EVENT(xfs_getparent_pointers,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
+		 const struct xfs_attrlist_cursor_kern *cur),
+	TP_ARGS(ip, ppi, cur),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, flags)
+		__field(unsigned int, bufsize)
+		__field(unsigned int, hashval)
+		__field(unsigned int, blkno)
+		__field(unsigned int, offset)
+		__field(int, initted)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->flags = ppi->gp_flags;
+		__entry->bufsize = ppi->gp_bufsize;
+		__entry->hashval = cur->hashval;
+		__entry->blkno = cur->blkno;
+		__entry->offset = cur->offset;
+		__entry->initted = cur->initted;
+	),
+	TP_printk("dev %d:%d ino 0x%llx flags 0x%x bufsize %u cur_init? %d hashval 0x%x blkno %u offset %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->flags,
+		  __entry->bufsize,
+		  __entry->initted,
+		  __entry->hashval,
+		  __entry->blkno,
+		  __entry->offset)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH


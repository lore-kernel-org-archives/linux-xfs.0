Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180028F47
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928716; cv=none; b=TcCWG7VYrcSm7EYkwDtRDJ2WZr3S71y+JkDAB43tgamQIm6txtDtdtN+QRwd4GoqhXwDYooyaUrstOhP/21Abt7xobCpWz/kK6Fp6waoecMPeHu75ps9v2nPGLuoyN6rgdO0do34cn31XbkS0lmknlarBs8DvICDsi0BmjbZ0fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928716; c=relaxed/simple;
	bh=W91bopHl/BJC1rp/FKceE3/VUx353pFjCESaaxEcHEs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSZUROQp8Ahmby4Qp7dhYg8Gew61rV5EY6PGPexOx85W9MCY9T8M9xZAM61MyHIB15XUGhiVnK+ZswM2BnoTQwNH/EgobU3CnmCwhQgV5Bubjx/kycIrhBf5HVbHCDxDP5HG2/LNgn2el2qtzXz701c3x7rmB4mVLc+ExkvFs5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITudY690; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITudY690"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1516C116B1;
	Wed, 24 Apr 2024 03:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928715;
	bh=W91bopHl/BJC1rp/FKceE3/VUx353pFjCESaaxEcHEs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ITudY690ziQOCzz1pzG2sbJxu0sgmDvnTn57aV234VuAGl7xB9zTlFTE3BMUvx8IR
	 kKXd+U/neaHp8ePIO+8aJXhAjGOdLdOFCQzdOWk4qAPCmcKDY2mcR6kiP+zm2783nI
	 22G3+0KR15Yq4IzmaUB88jDVh+Pkd+/b0viYIbAU1f12JvRcrBQrpkh7+rwP4UWM3z
	 EEIsZ0+SEevQ20iCVzYvS/9W85XxS8Ujj+e8odSlOVkqwh9M+eGoZPMrgqW9DdPo9Q
	 cxmyppqAqI0C1bdqRUbGsGuI8ucfjyKxpWDpz8omxWzVUJa2Wlm+o+fm7lovlxJzvb
	 e1VxBM83gEa+A==
Date: Tue, 23 Apr 2024 20:18:35 -0700
Subject: [PATCH 23/30] xfs: move handle ioctl code to xfs_handle.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783657.1905110.17416689610322493292.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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

Move the handle managemnet code (and the attrmulti code that uses it) to
xfs_handle.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/xfs_handle.c  |  618 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_handle.h  |   28 ++
 fs/xfs/xfs_ioctl.c   |  592 ------------------------------------------------
 fs/xfs/xfs_ioctl.h   |   28 --
 fs/xfs/xfs_ioctl32.c |    1 
 6 files changed, 649 insertions(+), 619 deletions(-)
 create mode 100644 fs/xfs/xfs_handle.c
 create mode 100644 fs/xfs/xfs_handle.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0c1a0b67af93..c969b11ce0f4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -78,6 +78,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_fsmap.o \
 				   xfs_fsops.o \
 				   xfs_globals.o \
+				   xfs_handle.o \
 				   xfs_health.o \
 				   xfs_icache.o \
 				   xfs_ioctl.o \
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
new file mode 100644
index 000000000000..13c2479a3053
--- /dev/null
+++ b/fs/xfs/xfs_handle.c
@@ -0,0 +1,618 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
+#include "xfs_handle.h"
+#include "xfs_health.h"
+#include "xfs_icache.h"
+#include "xfs_export.h"
+#include "xfs_xattr.h"
+#include "xfs_acl.h"
+
+#include <linux/namei.h>
+
+/*
+ * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
+ * a file or fs handle.
+ *
+ * XFS_IOC_PATH_TO_FSHANDLE
+ *    returns fs handle for a mount point or path within that mount point
+ * XFS_IOC_FD_TO_HANDLE
+ *    returns full handle for a FD opened in user space
+ * XFS_IOC_PATH_TO_HANDLE
+ *    returns full handle for a path
+ */
+int
+xfs_find_handle(
+	unsigned int		cmd,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	int			hsize;
+	xfs_handle_t		handle;
+	struct inode		*inode;
+	struct fd		f = {NULL};
+	struct path		path;
+	int			error;
+	struct xfs_inode	*ip;
+
+	if (cmd == XFS_IOC_FD_TO_HANDLE) {
+		f = fdget(hreq->fd);
+		if (!f.file)
+			return -EBADF;
+		inode = file_inode(f.file);
+	} else {
+		error = user_path_at(AT_FDCWD, hreq->path, 0, &path);
+		if (error)
+			return error;
+		inode = d_inode(path.dentry);
+	}
+	ip = XFS_I(inode);
+
+	/*
+	 * We can only generate handles for inodes residing on a XFS filesystem,
+	 * and only for regular files, directories or symbolic links.
+	 */
+	error = -EINVAL;
+	if (inode->i_sb->s_magic != XFS_SB_MAGIC)
+		goto out_put;
+
+	error = -EBADF;
+	if (!S_ISREG(inode->i_mode) &&
+	    !S_ISDIR(inode->i_mode) &&
+	    !S_ISLNK(inode->i_mode))
+		goto out_put;
+
+
+	memcpy(&handle.ha_fsid, ip->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
+
+	if (cmd == XFS_IOC_PATH_TO_FSHANDLE) {
+		/*
+		 * This handle only contains an fsid, zero the rest.
+		 */
+		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
+		hsize = sizeof(xfs_fsid_t);
+	} else {
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+					sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_gen = inode->i_generation;
+		handle.ha_fid.fid_ino = ip->i_ino;
+		hsize = sizeof(xfs_handle_t);
+	}
+
+	error = -EFAULT;
+	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
+	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32)))
+		goto out_put;
+
+	error = 0;
+
+ out_put:
+	if (cmd == XFS_IOC_FD_TO_HANDLE)
+		fdput(f);
+	else
+		path_put(&path);
+	return error;
+}
+
+/*
+ * No need to do permission checks on the various pathname components
+ * as the handle operations are privileged.
+ */
+STATIC int
+xfs_handle_acceptable(
+	void			*context,
+	struct dentry		*dentry)
+{
+	return 1;
+}
+
+/*
+ * Convert userspace handle data into a dentry.
+ */
+struct dentry *
+xfs_handle_to_dentry(
+	struct file		*parfilp,
+	void __user		*uhandle,
+	u32			hlen)
+{
+	xfs_handle_t		handle;
+	struct xfs_fid64	fid;
+
+	/*
+	 * Only allow handle opens under a directory.
+	 */
+	if (!S_ISDIR(file_inode(parfilp)->i_mode))
+		return ERR_PTR(-ENOTDIR);
+
+	if (hlen != sizeof(xfs_handle_t))
+		return ERR_PTR(-EINVAL);
+	if (copy_from_user(&handle, uhandle, hlen))
+		return ERR_PTR(-EFAULT);
+	if (handle.ha_fid.fid_len !=
+	    sizeof(handle.ha_fid) - sizeof(handle.ha_fid.fid_len))
+		return ERR_PTR(-EINVAL);
+
+	memset(&fid, 0, sizeof(struct fid));
+	fid.ino = handle.ha_fid.fid_ino;
+	fid.gen = handle.ha_fid.fid_gen;
+
+	return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
+			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
+			xfs_handle_acceptable, NULL);
+}
+
+STATIC struct dentry *
+xfs_handlereq_to_dentry(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen);
+}
+
+int
+xfs_open_by_handle(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	const struct cred	*cred = current_cred();
+	int			error;
+	int			fd;
+	int			permflag;
+	struct file		*filp;
+	struct inode		*inode;
+	struct dentry		*dentry;
+	fmode_t			fmode;
+	struct path		path;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+	inode = d_inode(dentry);
+
+	/* Restrict xfs_open_by_handle to directories & regular files. */
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
+		error = -EPERM;
+		goto out_dput;
+	}
+
+#if BITS_PER_LONG != 32
+	hreq->oflags |= O_LARGEFILE;
+#endif
+
+	permflag = hreq->oflags;
+	fmode = OPEN_FMODE(permflag);
+	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
+	    (fmode & FMODE_WRITE) && IS_APPEND(inode)) {
+		error = -EPERM;
+		goto out_dput;
+	}
+
+	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
+		error = -EPERM;
+		goto out_dput;
+	}
+
+	/* Can't write directories. */
+	if (S_ISDIR(inode->i_mode) && (fmode & FMODE_WRITE)) {
+		error = -EISDIR;
+		goto out_dput;
+	}
+
+	fd = get_unused_fd_flags(0);
+	if (fd < 0) {
+		error = fd;
+		goto out_dput;
+	}
+
+	path.mnt = parfilp->f_path.mnt;
+	path.dentry = dentry;
+	filp = dentry_open(&path, hreq->oflags, cred);
+	dput(dentry);
+	if (IS_ERR(filp)) {
+		put_unused_fd(fd);
+		return PTR_ERR(filp);
+	}
+
+	if (S_ISREG(inode->i_mode)) {
+		filp->f_flags |= O_NOATIME;
+		filp->f_mode |= FMODE_NOCMTIME;
+	}
+
+	fd_install(fd, filp);
+	return fd;
+
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
+int
+xfs_readlink_by_handle(
+	struct file		*parfilp,
+	xfs_fsop_handlereq_t	*hreq)
+{
+	struct dentry		*dentry;
+	__u32			olen;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	/* Restrict this handle operation to symlinks only. */
+	if (!d_is_symlink(dentry)) {
+		error = -EINVAL;
+		goto out_dput;
+	}
+
+	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
+		error = -EFAULT;
+		goto out_dput;
+	}
+
+	error = vfs_readlink(dentry, hreq->ohandle, olen);
+
+ out_dput:
+	dput(dentry);
+	return error;
+}
+
+/*
+ * Format an attribute and copy it out to the user's buffer.
+ * Take care to check values and protect against them changing later,
+ * we may be reading them directly out of a user buffer.
+ */
+static void
+xfs_ioc_attr_put_listent(
+	struct xfs_attr_list_context *context,
+	int			flags,
+	unsigned char		*name,
+	int			namelen,
+	void			*value,
+	int			valuelen)
+{
+	struct xfs_attrlist	*alist = context->buffer;
+	struct xfs_attrlist_ent	*aep;
+	int			arraytop;
+
+	ASSERT(!context->seen_enough);
+	ASSERT(context->count >= 0);
+	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
+	ASSERT(context->firstu >= sizeof(*alist));
+	ASSERT(context->firstu <= context->bufsize);
+
+	/*
+	 * Only list entries in the right namespace.
+	 */
+	if (context->attr_filter != (flags & XFS_ATTR_NSP_ONDISK_MASK))
+		return;
+
+	arraytop = sizeof(*alist) +
+			context->count * sizeof(alist->al_offset[0]);
+
+	/* decrement by the actual bytes used by the attr */
+	context->firstu -= round_up(offsetof(struct xfs_attrlist_ent, a_name) +
+			namelen + 1, sizeof(uint32_t));
+	if (context->firstu < arraytop) {
+		trace_xfs_attr_list_full(context);
+		alist->al_more = 1;
+		context->seen_enough = 1;
+		return;
+	}
+
+	aep = context->buffer + context->firstu;
+	aep->a_valuelen = valuelen;
+	memcpy(aep->a_name, name, namelen);
+	aep->a_name[namelen] = 0;
+	alist->al_offset[context->count++] = context->firstu;
+	alist->al_count = context->count;
+	trace_xfs_attr_list_add(context);
+}
+
+static unsigned int
+xfs_attr_filter(
+	u32			ioc_flags)
+{
+	if (ioc_flags & XFS_IOC_ATTR_ROOT)
+		return XFS_ATTR_ROOT;
+	if (ioc_flags & XFS_IOC_ATTR_SECURE)
+		return XFS_ATTR_SECURE;
+	return 0;
+}
+
+static inline enum xfs_attr_update
+xfs_xattr_flags(
+	u32			ioc_flags,
+	void			*value)
+{
+	if (!value)
+		return XFS_ATTRUPDATE_REMOVE;
+	if (ioc_flags & XFS_IOC_ATTR_CREATE)
+		return XFS_ATTRUPDATE_CREATE;
+	if (ioc_flags & XFS_IOC_ATTR_REPLACE)
+		return XFS_ATTRUPDATE_REPLACE;
+	return XFS_ATTRUPDATE_UPSERT;
+}
+
+int
+xfs_ioc_attr_list(
+	struct xfs_inode		*dp,
+	void __user			*ubuf,
+	size_t				bufsize,
+	int				flags,
+	struct xfs_attrlist_cursor __user *ucursor)
+{
+	struct xfs_attr_list_context	context = { };
+	struct xfs_attrlist		*alist;
+	void				*buffer;
+	int				error;
+
+	if (bufsize < sizeof(struct xfs_attrlist) ||
+	    bufsize > XFS_XATTR_LIST_MAX)
+		return -EINVAL;
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
+		return -EINVAL;
+	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
+		return -EINVAL;
+
+	/*
+	 * Validate the cursor.
+	 */
+	if (copy_from_user(&context.cursor, ucursor, sizeof(context.cursor)))
+		return -EFAULT;
+	if (context.cursor.pad1 || context.cursor.pad2)
+		return -EINVAL;
+	if (!context.cursor.initted &&
+	    (context.cursor.hashval || context.cursor.blkno ||
+	     context.cursor.offset))
+		return -EINVAL;
+
+	buffer = kvzalloc(bufsize, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context.dp = dp;
+	context.resynch = 1;
+	context.attr_filter = xfs_attr_filter(flags);
+	context.buffer = buffer;
+	context.bufsize = round_down(bufsize, sizeof(uint32_t));
+	context.firstu = context.bufsize;
+	context.put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context.buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context.bufsize;
+
+	error = xfs_attr_list(&context);
+	if (error)
+		goto out_free;
+
+	if (copy_to_user(ubuf, buffer, bufsize) ||
+	    copy_to_user(ucursor, &context.cursor, sizeof(context.cursor)))
+		error = -EFAULT;
+out_free:
+	kvfree(buffer);
+	return error;
+}
+
+int
+xfs_attrlist_by_handle(
+	struct file		*parfilp,
+	struct xfs_fsop_attrlist_handlereq __user *p)
+{
+	struct xfs_fsop_attrlist_handlereq al_hreq;
+	struct dentry		*dentry;
+	int			error = -ENOMEM;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(&al_hreq, p, sizeof(al_hreq)))
+		return -EFAULT;
+
+	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
+				  al_hreq.buflen, al_hreq.flags, &p->pos);
+	dput(dentry);
+	return error;
+}
+
+static int
+xfs_attrmulti_attr_get(
+	struct inode		*inode,
+	unsigned char		*name,
+	unsigned char		__user *ubuf,
+	uint32_t		*len,
+	uint32_t		flags)
+{
+	struct xfs_da_args	args = {
+		.dp		= XFS_I(inode),
+		.attr_filter	= xfs_attr_filter(flags),
+		.name		= name,
+		.namelen	= strlen(name),
+		.valuelen	= *len,
+	};
+	int			error;
+
+	if (*len > XFS_XATTR_SIZE_MAX)
+		return -EINVAL;
+
+	error = xfs_attr_get(&args);
+	if (error)
+		goto out_kfree;
+
+	*len = args.valuelen;
+	if (copy_to_user(ubuf, args.value, args.valuelen))
+		error = -EFAULT;
+
+out_kfree:
+	kvfree(args.value);
+	return error;
+}
+
+static int
+xfs_attrmulti_attr_set(
+	struct inode		*inode,
+	unsigned char		*name,
+	const unsigned char	__user *ubuf,
+	uint32_t		len,
+	uint32_t		flags)
+{
+	struct xfs_da_args	args = {
+		.dp		= XFS_I(inode),
+		.attr_filter	= xfs_attr_filter(flags),
+		.name		= name,
+		.namelen	= strlen(name),
+	};
+	int			error;
+
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+		return -EPERM;
+
+	if (ubuf) {
+		if (len > XFS_XATTR_SIZE_MAX)
+			return -EINVAL;
+		args.value = memdup_user(ubuf, len);
+		if (IS_ERR(args.value))
+			return PTR_ERR(args.value);
+		args.valuelen = len;
+	}
+
+	error = xfs_attr_change(&args, xfs_xattr_flags(flags, args.value));
+	if (!error && (flags & XFS_IOC_ATTR_ROOT))
+		xfs_forget_acl(inode, name);
+	kfree(args.value);
+	return error;
+}
+
+int
+xfs_ioc_attrmulti_one(
+	struct file		*parfilp,
+	struct inode		*inode,
+	uint32_t		opcode,
+	void __user		*uname,
+	void __user		*value,
+	uint32_t		*len,
+	uint32_t		flags)
+{
+	unsigned char		*name;
+	int			error;
+
+	if ((flags & XFS_IOC_ATTR_ROOT) && (flags & XFS_IOC_ATTR_SECURE))
+		return -EINVAL;
+
+	name = strndup_user(uname, MAXNAMELEN);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	switch (opcode) {
+	case ATTR_OP_GET:
+		error = xfs_attrmulti_attr_get(inode, name, value, len, flags);
+		break;
+	case ATTR_OP_REMOVE:
+		value = NULL;
+		*len = 0;
+		fallthrough;
+	case ATTR_OP_SET:
+		error = mnt_want_write_file(parfilp);
+		if (error)
+			break;
+		error = xfs_attrmulti_attr_set(inode, name, value, *len, flags);
+		mnt_drop_write_file(parfilp);
+		break;
+	default:
+		error = -EINVAL;
+		break;
+	}
+
+	kfree(name);
+	return error;
+}
+
+int
+xfs_attrmulti_by_handle(
+	struct file		*parfilp,
+	void			__user *arg)
+{
+	int			error;
+	xfs_attr_multiop_t	*ops;
+	xfs_fsop_attrmulti_handlereq_t am_hreq;
+	struct dentry		*dentry;
+	unsigned int		i, size;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
+		return -EFAULT;
+
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
+		return -E2BIG;
+
+	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	error = -E2BIG;
+	size = am_hreq.opcount * sizeof(xfs_attr_multiop_t);
+	if (!size || size > 16 * PAGE_SIZE)
+		goto out_dput;
+
+	ops = memdup_user(am_hreq.ops, size);
+	if (IS_ERR(ops)) {
+		error = PTR_ERR(ops);
+		goto out_dput;
+	}
+
+	error = 0;
+	for (i = 0; i < am_hreq.opcount; i++) {
+		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
+				d_inode(dentry), ops[i].am_opcode,
+				ops[i].am_attrname, ops[i].am_attrvalue,
+				&ops[i].am_length, ops[i].am_flags);
+	}
+
+	if (copy_to_user(am_hreq.ops, ops, size))
+		error = -EFAULT;
+
+	kfree(ops);
+ out_dput:
+	dput(dentry);
+	return error;
+}
diff --git a/fs/xfs/xfs_handle.h b/fs/xfs/xfs_handle.h
new file mode 100644
index 000000000000..e39eaf4689da
--- /dev/null
+++ b/fs/xfs/xfs_handle.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_HANDLE_H__
+#define	__XFS_HANDLE_H__
+
+int xfs_attrlist_by_handle(struct file *parfilp,
+		struct xfs_fsop_attrlist_handlereq __user *p);
+int xfs_attrmulti_by_handle(struct file *parfilp, void __user *arg);
+
+int xfs_find_handle(unsigned int cmd, struct xfs_fsop_handlereq *hreq);
+int xfs_open_by_handle(struct file *parfilp, struct xfs_fsop_handlereq *hreq);
+int xfs_readlink_by_handle(struct file *parfilp,
+		struct xfs_fsop_handlereq *hreq);
+
+int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
+		uint32_t opcode, void __user *uname, void __user *value,
+		uint32_t *len, uint32_t flags);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
+
+struct dentry *xfs_handle_to_dentry(struct file *parfilp, void __user *uhandle,
+		u32 hlen);
+
+#endif	/* __XFS_HANDLE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7a2a5cf06a5c..ed05fcd6261d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -23,11 +23,9 @@
 #include "xfs_fsops.h"
 #include "xfs_discard.h"
 #include "xfs_quota.h"
-#include "xfs_export.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_trans.h"
-#include "xfs_acl.h"
 #include "xfs_btree.h"
 #include <linux/fsmap.h>
 #include "xfs_fsmap.h"
@@ -37,602 +35,14 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
-#include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_file.h"
 #include "xfs_exchrange.h"
+#include "xfs_handle.h"
 
 #include <linux/mount.h>
-#include <linux/namei.h>
 #include <linux/fileattr.h>
 
-/*
- * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
- * a file or fs handle.
- *
- * XFS_IOC_PATH_TO_FSHANDLE
- *    returns fs handle for a mount point or path within that mount point
- * XFS_IOC_FD_TO_HANDLE
- *    returns full handle for a FD opened in user space
- * XFS_IOC_PATH_TO_HANDLE
- *    returns full handle for a path
- */
-int
-xfs_find_handle(
-	unsigned int		cmd,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	int			hsize;
-	xfs_handle_t		handle;
-	struct inode		*inode;
-	struct fd		f = {NULL};
-	struct path		path;
-	int			error;
-	struct xfs_inode	*ip;
-
-	if (cmd == XFS_IOC_FD_TO_HANDLE) {
-		f = fdget(hreq->fd);
-		if (!f.file)
-			return -EBADF;
-		inode = file_inode(f.file);
-	} else {
-		error = user_path_at(AT_FDCWD, hreq->path, 0, &path);
-		if (error)
-			return error;
-		inode = d_inode(path.dentry);
-	}
-	ip = XFS_I(inode);
-
-	/*
-	 * We can only generate handles for inodes residing on a XFS filesystem,
-	 * and only for regular files, directories or symbolic links.
-	 */
-	error = -EINVAL;
-	if (inode->i_sb->s_magic != XFS_SB_MAGIC)
-		goto out_put;
-
-	error = -EBADF;
-	if (!S_ISREG(inode->i_mode) &&
-	    !S_ISDIR(inode->i_mode) &&
-	    !S_ISLNK(inode->i_mode))
-		goto out_put;
-
-
-	memcpy(&handle.ha_fsid, ip->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
-
-	if (cmd == XFS_IOC_PATH_TO_FSHANDLE) {
-		/*
-		 * This handle only contains an fsid, zero the rest.
-		 */
-		memset(&handle.ha_fid, 0, sizeof(handle.ha_fid));
-		hsize = sizeof(xfs_fsid_t);
-	} else {
-		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-					sizeof(handle.ha_fid.fid_len);
-		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_gen = inode->i_generation;
-		handle.ha_fid.fid_ino = ip->i_ino;
-		hsize = sizeof(xfs_handle_t);
-	}
-
-	error = -EFAULT;
-	if (copy_to_user(hreq->ohandle, &handle, hsize) ||
-	    copy_to_user(hreq->ohandlen, &hsize, sizeof(__s32)))
-		goto out_put;
-
-	error = 0;
-
- out_put:
-	if (cmd == XFS_IOC_FD_TO_HANDLE)
-		fdput(f);
-	else
-		path_put(&path);
-	return error;
-}
-
-/*
- * No need to do permission checks on the various pathname components
- * as the handle operations are privileged.
- */
-STATIC int
-xfs_handle_acceptable(
-	void			*context,
-	struct dentry		*dentry)
-{
-	return 1;
-}
-
-/*
- * Convert userspace handle data into a dentry.
- */
-struct dentry *
-xfs_handle_to_dentry(
-	struct file		*parfilp,
-	void __user		*uhandle,
-	u32			hlen)
-{
-	xfs_handle_t		handle;
-	struct xfs_fid64	fid;
-
-	/*
-	 * Only allow handle opens under a directory.
-	 */
-	if (!S_ISDIR(file_inode(parfilp)->i_mode))
-		return ERR_PTR(-ENOTDIR);
-
-	if (hlen != sizeof(xfs_handle_t))
-		return ERR_PTR(-EINVAL);
-	if (copy_from_user(&handle, uhandle, hlen))
-		return ERR_PTR(-EFAULT);
-	if (handle.ha_fid.fid_len !=
-	    sizeof(handle.ha_fid) - sizeof(handle.ha_fid.fid_len))
-		return ERR_PTR(-EINVAL);
-
-	memset(&fid, 0, sizeof(struct fid));
-	fid.ino = handle.ha_fid.fid_ino;
-	fid.gen = handle.ha_fid.fid_gen;
-
-	return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
-			FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
-			xfs_handle_acceptable, NULL);
-}
-
-STATIC struct dentry *
-xfs_handlereq_to_dentry(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen);
-}
-
-int
-xfs_open_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	const struct cred	*cred = current_cred();
-	int			error;
-	int			fd;
-	int			permflag;
-	struct file		*filp;
-	struct inode		*inode;
-	struct dentry		*dentry;
-	fmode_t			fmode;
-	struct path		path;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	inode = d_inode(dentry);
-
-	/* Restrict xfs_open_by_handle to directories & regular files. */
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
-		error = -EPERM;
-		goto out_dput;
-	}
-
-#if BITS_PER_LONG != 32
-	hreq->oflags |= O_LARGEFILE;
-#endif
-
-	permflag = hreq->oflags;
-	fmode = OPEN_FMODE(permflag);
-	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
-	    (fmode & FMODE_WRITE) && IS_APPEND(inode)) {
-		error = -EPERM;
-		goto out_dput;
-	}
-
-	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
-		error = -EPERM;
-		goto out_dput;
-	}
-
-	/* Can't write directories. */
-	if (S_ISDIR(inode->i_mode) && (fmode & FMODE_WRITE)) {
-		error = -EISDIR;
-		goto out_dput;
-	}
-
-	fd = get_unused_fd_flags(0);
-	if (fd < 0) {
-		error = fd;
-		goto out_dput;
-	}
-
-	path.mnt = parfilp->f_path.mnt;
-	path.dentry = dentry;
-	filp = dentry_open(&path, hreq->oflags, cred);
-	dput(dentry);
-	if (IS_ERR(filp)) {
-		put_unused_fd(fd);
-		return PTR_ERR(filp);
-	}
-
-	if (S_ISREG(inode->i_mode)) {
-		filp->f_flags |= O_NOATIME;
-		filp->f_mode |= FMODE_NOCMTIME;
-	}
-
-	fd_install(fd, filp);
-	return fd;
-
- out_dput:
-	dput(dentry);
-	return error;
-}
-
-int
-xfs_readlink_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq)
-{
-	struct dentry		*dentry;
-	__u32			olen;
-	int			error;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	/* Restrict this handle operation to symlinks only. */
-	if (!d_is_symlink(dentry)) {
-		error = -EINVAL;
-		goto out_dput;
-	}
-
-	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
-		error = -EFAULT;
-		goto out_dput;
-	}
-
-	error = vfs_readlink(dentry, hreq->ohandle, olen);
-
- out_dput:
-	dput(dentry);
-	return error;
-}
-
-/*
- * Format an attribute and copy it out to the user's buffer.
- * Take care to check values and protect against them changing later,
- * we may be reading them directly out of a user buffer.
- */
-static void
-xfs_ioc_attr_put_listent(
-	struct xfs_attr_list_context *context,
-	int			flags,
-	unsigned char		*name,
-	int			namelen,
-	void			*value,
-	int			valuelen)
-{
-	struct xfs_attrlist	*alist = context->buffer;
-	struct xfs_attrlist_ent	*aep;
-	int			arraytop;
-
-	ASSERT(!context->seen_enough);
-	ASSERT(context->count >= 0);
-	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
-	ASSERT(context->firstu >= sizeof(*alist));
-	ASSERT(context->firstu <= context->bufsize);
-
-	/*
-	 * Only list entries in the right namespace.
-	 */
-	if (context->attr_filter != (flags & XFS_ATTR_NSP_ONDISK_MASK))
-		return;
-
-	arraytop = sizeof(*alist) +
-			context->count * sizeof(alist->al_offset[0]);
-
-	/* decrement by the actual bytes used by the attr */
-	context->firstu -= round_up(offsetof(struct xfs_attrlist_ent, a_name) +
-			namelen + 1, sizeof(uint32_t));
-	if (context->firstu < arraytop) {
-		trace_xfs_attr_list_full(context);
-		alist->al_more = 1;
-		context->seen_enough = 1;
-		return;
-	}
-
-	aep = context->buffer + context->firstu;
-	aep->a_valuelen = valuelen;
-	memcpy(aep->a_name, name, namelen);
-	aep->a_name[namelen] = 0;
-	alist->al_offset[context->count++] = context->firstu;
-	alist->al_count = context->count;
-	trace_xfs_attr_list_add(context);
-}
-
-static unsigned int
-xfs_attr_filter(
-	u32			ioc_flags)
-{
-	if (ioc_flags & XFS_IOC_ATTR_ROOT)
-		return XFS_ATTR_ROOT;
-	if (ioc_flags & XFS_IOC_ATTR_SECURE)
-		return XFS_ATTR_SECURE;
-	return 0;
-}
-
-static inline enum xfs_attr_update
-xfs_xattr_flags(
-	u32			ioc_flags,
-	void			*value)
-{
-	if (!value)
-		return XFS_ATTRUPDATE_REMOVE;
-	if (ioc_flags & XFS_IOC_ATTR_CREATE)
-		return XFS_ATTRUPDATE_CREATE;
-	if (ioc_flags & XFS_IOC_ATTR_REPLACE)
-		return XFS_ATTRUPDATE_REPLACE;
-	return XFS_ATTRUPDATE_UPSERT;
-}
-
-int
-xfs_ioc_attr_list(
-	struct xfs_inode		*dp,
-	void __user			*ubuf,
-	size_t				bufsize,
-	int				flags,
-	struct xfs_attrlist_cursor __user *ucursor)
-{
-	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
-	void				*buffer;
-	int				error;
-
-	if (bufsize < sizeof(struct xfs_attrlist) ||
-	    bufsize > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
-		return -EINVAL;
-	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
-		return -EINVAL;
-
-	/*
-	 * Validate the cursor.
-	 */
-	if (copy_from_user(&context.cursor, ucursor, sizeof(context.cursor)))
-		return -EFAULT;
-	if (context.cursor.pad1 || context.cursor.pad2)
-		return -EINVAL;
-	if (!context.cursor.initted &&
-	    (context.cursor.hashval || context.cursor.blkno ||
-	     context.cursor.offset))
-		return -EINVAL;
-
-	buffer = kvzalloc(bufsize, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
-
-	error = xfs_attr_list(&context);
-	if (error)
-		goto out_free;
-
-	if (copy_to_user(ubuf, buffer, bufsize) ||
-	    copy_to_user(ucursor, &context.cursor, sizeof(context.cursor)))
-		error = -EFAULT;
-out_free:
-	kvfree(buffer);
-	return error;
-}
-
-STATIC int
-xfs_attrlist_by_handle(
-	struct file		*parfilp,
-	struct xfs_fsop_attrlist_handlereq __user *p)
-{
-	struct xfs_fsop_attrlist_handlereq al_hreq;
-	struct dentry		*dentry;
-	int			error = -ENOMEM;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (copy_from_user(&al_hreq, p, sizeof(al_hreq)))
-		return -EFAULT;
-
-	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
-				  al_hreq.buflen, al_hreq.flags, &p->pos);
-	dput(dentry);
-	return error;
-}
-
-static int
-xfs_attrmulti_attr_get(
-	struct inode		*inode,
-	unsigned char		*name,
-	unsigned char		__user *ubuf,
-	uint32_t		*len,
-	uint32_t		flags)
-{
-	struct xfs_da_args	args = {
-		.dp		= XFS_I(inode),
-		.attr_filter	= xfs_attr_filter(flags),
-		.name		= name,
-		.namelen	= strlen(name),
-		.valuelen	= *len,
-	};
-	int			error;
-
-	if (*len > XFS_XATTR_SIZE_MAX)
-		return -EINVAL;
-
-	error = xfs_attr_get(&args);
-	if (error)
-		goto out_kfree;
-
-	*len = args.valuelen;
-	if (copy_to_user(ubuf, args.value, args.valuelen))
-		error = -EFAULT;
-
-out_kfree:
-	kvfree(args.value);
-	return error;
-}
-
-static int
-xfs_attrmulti_attr_set(
-	struct inode		*inode,
-	unsigned char		*name,
-	const unsigned char	__user *ubuf,
-	uint32_t		len,
-	uint32_t		flags)
-{
-	struct xfs_da_args	args = {
-		.dp		= XFS_I(inode),
-		.attr_filter	= xfs_attr_filter(flags),
-		.name		= name,
-		.namelen	= strlen(name),
-	};
-	int			error;
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return -EPERM;
-
-	if (ubuf) {
-		if (len > XFS_XATTR_SIZE_MAX)
-			return -EINVAL;
-		args.value = memdup_user(ubuf, len);
-		if (IS_ERR(args.value))
-			return PTR_ERR(args.value);
-		args.valuelen = len;
-	}
-
-	error = xfs_attr_change(&args, xfs_xattr_flags(flags, args.value));
-	if (!error && (flags & XFS_IOC_ATTR_ROOT))
-		xfs_forget_acl(inode, name);
-	kfree(args.value);
-	return error;
-}
-
-int
-xfs_ioc_attrmulti_one(
-	struct file		*parfilp,
-	struct inode		*inode,
-	uint32_t		opcode,
-	void __user		*uname,
-	void __user		*value,
-	uint32_t		*len,
-	uint32_t		flags)
-{
-	unsigned char		*name;
-	int			error;
-
-	if ((flags & XFS_IOC_ATTR_ROOT) && (flags & XFS_IOC_ATTR_SECURE))
-		return -EINVAL;
-
-	name = strndup_user(uname, MAXNAMELEN);
-	if (IS_ERR(name))
-		return PTR_ERR(name);
-
-	switch (opcode) {
-	case ATTR_OP_GET:
-		error = xfs_attrmulti_attr_get(inode, name, value, len, flags);
-		break;
-	case ATTR_OP_REMOVE:
-		value = NULL;
-		*len = 0;
-		fallthrough;
-	case ATTR_OP_SET:
-		error = mnt_want_write_file(parfilp);
-		if (error)
-			break;
-		error = xfs_attrmulti_attr_set(inode, name, value, *len, flags);
-		mnt_drop_write_file(parfilp);
-		break;
-	default:
-		error = -EINVAL;
-		break;
-	}
-
-	kfree(name);
-	return error;
-}
-
-STATIC int
-xfs_attrmulti_by_handle(
-	struct file		*parfilp,
-	void			__user *arg)
-{
-	int			error;
-	xfs_attr_multiop_t	*ops;
-	xfs_fsop_attrmulti_handlereq_t am_hreq;
-	struct dentry		*dentry;
-	unsigned int		i, size;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
-		return -EFAULT;
-
-	/* overflow check */
-	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
-		return -E2BIG;
-
-	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-
-	error = -E2BIG;
-	size = am_hreq.opcount * sizeof(xfs_attr_multiop_t);
-	if (!size || size > 16 * PAGE_SIZE)
-		goto out_dput;
-
-	ops = memdup_user(am_hreq.ops, size);
-	if (IS_ERR(ops)) {
-		error = PTR_ERR(ops);
-		goto out_dput;
-	}
-
-	error = 0;
-	for (i = 0; i < am_hreq.opcount; i++) {
-		ops[i].am_error = xfs_ioc_attrmulti_one(parfilp,
-				d_inode(dentry), ops[i].am_opcode,
-				ops[i].am_attrname, ops[i].am_attrvalue,
-				&ops[i].am_length, ops[i].am_flags);
-	}
-
-	if (copy_to_user(am_hreq.ops, ops, size))
-		error = -EFAULT;
-
-	kfree(ops);
- out_dput:
-	dput(dentry);
-	return error;
-}
-
 /* Return 0 on success or positive error */
 int
 xfs_fsbulkstat_one_fmt(
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 38be600b5e1e..12124946f347 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -14,34 +14,6 @@ int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp);
 
-extern int
-xfs_find_handle(
-	unsigned int		cmd,
-	xfs_fsop_handlereq_t	*hreq);
-
-extern int
-xfs_open_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq);
-
-extern int
-xfs_readlink_by_handle(
-	struct file		*parfilp,
-	xfs_fsop_handlereq_t	*hreq);
-
-int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
-		uint32_t opcode, void __user *uname, void __user *value,
-		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
-		      size_t bufsize, int flags,
-		      struct xfs_attrlist_cursor __user *ucursor);
-
-extern struct dentry *
-xfs_handle_to_dentry(
-	struct file		*parfilp,
-	void __user		*uhandle,
-	u32			hlen);
-
 extern int
 xfs_fileattr_get(
 	struct dentry		*dentry,
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index ee35eea1ecce..b64785dc4354 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -24,6 +24,7 @@
 #include "xfs_ioctl32.h"
 #include "xfs_trace.h"
 #include "xfs_sb.h"
+#include "xfs_handle.h"
 
 #define  _NATIVE_IOC(cmd, type) \
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))


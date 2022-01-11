Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40F0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 23:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346778AbiAKXWr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 18:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiAKXWr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 18:22:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ABDC06173F
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 15:22:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D0561019
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 23:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C48C36AE3;
        Tue, 11 Jan 2022 23:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641943366;
        bh=G98oCK9V/KeqHoLCvrvqW9vEzMBj7gE6G68PcfiSY6s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jx0WHxRnH/KqstVf//O0umPJyA66aEGEz5I7TNpM6JD0RGBkR8oGbEAWjJnjjgo6K
         5MhUpy3OC15/ooFqwXR6GWD+KVHFDgfNLrNU/W9D1PdfZF6WMMwPq9X/r/h5QpGjvp
         oIbSt8QJTOGCalp41rsh1QBX6jM6mzrDwdz2E7gJbrClzGb0tfYYDtLMKukdIczLgd
         zkSIKtrseei8SqZiFdXfkgjfoYRagwZfgFlIrUP9Yc8mTf3LCFrfH5ufrXfbZMWOcZ
         DJ1iu7AflSqoktHW6YPtHlFwthBlBJ0hJSUdsPxzPAfFWPmYowNDbR5ainsVQJO4ft
         hKgJw7mFIzq7A==
Subject: [PATCH 1/3] xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 11 Jan 2022 15:22:46 -0800
Message-ID: <164194336605.3069025.17152203611076954599.stgit@magnolia>
In-Reply-To: <164194336019.3069025.16691952615002573445.stgit@magnolia>
References: <164194336019.3069025.16691952615002573445.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

According to the glibc compat header for Irix 4, these ioctls originated
in April 1991 as a (somewhat clunky) way to preallocate space at the end
of a file on an EFS filesystem.  XFS, which was released in Irix 5.3 in
December 1993, picked up these ioctls to maintain compatibility and they
were ported to Linux in the early 2000s.

Recently it was pointed out to me they still lurk in the kernel, even
though the Linux fallocate syscall supplanted the functionality a long
time ago.  fstests doesn't seem to include any real functional or stress
tests for these ioctls, which means that the code quality is ... very
questionable.  Most notably, it was a stale disk block exposure vector
for 21 years and nobody noticed or complained.  As mature programmers
say, "If you're not testing it, it's broken."

Given all that, let's withdraw these ioctls from the XFS userspace API.
Normally we'd set a long deprecation process, but I estimate that there
aren't any real users, so let's trigger a warning in dmesg and return
-ENOTTY.

See: CVE-2021-4155

Augments: 983d8e60f508 ("xfs: map unwritten blocks in XFS_IOC_{ALLOC,FREE}SP just like fallocate")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |    7 ++--
 fs/xfs/xfs_bmap_util.h |    2 +
 fs/xfs/xfs_file.c      |    3 +-
 fs/xfs/xfs_ioctl.c     |   93 +++---------------------------------------------
 fs/xfs/xfs_ioctl.h     |    6 ---
 fs/xfs/xfs_ioctl32.c   |   27 --------------
 6 files changed, 10 insertions(+), 128 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73a36b7be3bd..575060a7c768 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -771,8 +771,7 @@ int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len,
-	int			alloc_type)
+	xfs_off_t		len)
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
@@ -865,8 +864,8 @@ xfs_alloc_file_space(
 			goto error;
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-					allocatesize_fsb, alloc_type, 0, imapp,
-					&nimaps);
+				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				&nimaps);
 		if (error)
 			goto error;
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 9f993168b55b..24b37d211f1d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -54,7 +54,7 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-			     xfs_off_t len, int alloc_type);
+			     xfs_off_t len);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
 			    xfs_off_t len);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 27594738b0d1..d81a28cada35 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1052,8 +1052,7 @@ xfs_file_fallocate(
 		}
 
 		if (!xfs_is_always_cow_inode(ip)) {
-			error = xfs_alloc_file_space(ip, offset, len,
-						     XFS_BMAPI_PREALLOC);
+			error = xfs_alloc_file_space(ip, offset, len);
 			if (error)
 				goto out_unlock;
 		}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8ea47a9d5aad..64a7ef4a7298 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -627,87 +627,6 @@ xfs_attrmulti_by_handle(
 	return error;
 }
 
-int
-xfs_ioc_space(
-	struct file		*filp,
-	xfs_flock64_t		*bf)
-{
-	struct inode		*inode = file_inode(filp);
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct iattr		iattr;
-	enum xfs_prealloc_flags	flags = XFS_PREALLOC_CLEAR;
-	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
-	int			error;
-
-	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
-		return -EPERM;
-
-	if (!(filp->f_mode & FMODE_WRITE))
-		return -EBADF;
-
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
-	if (xfs_is_always_cow_inode(ip))
-		return -EOPNOTSUPP;
-
-	if (filp->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-	if (filp->f_mode & FMODE_NOCMTIME)
-		flags |= XFS_PREALLOC_INVISIBLE;
-
-	error = mnt_want_write_file(filp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
-	if (error)
-		goto out_unlock;
-	inode_dio_wait(inode);
-
-	switch (bf->l_whence) {
-	case 0: /*SEEK_SET*/
-		break;
-	case 1: /*SEEK_CUR*/
-		bf->l_start += filp->f_pos;
-		break;
-	case 2: /*SEEK_END*/
-		bf->l_start += XFS_ISIZE(ip);
-		break;
-	default:
-		error = -EINVAL;
-		goto out_unlock;
-	}
-
-	if (bf->l_start < 0 || bf->l_start > inode->i_sb->s_maxbytes) {
-		error = -EINVAL;
-		goto out_unlock;
-	}
-
-	if (bf->l_start > XFS_ISIZE(ip)) {
-		error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-				bf->l_start - XFS_ISIZE(ip),
-				XFS_BMAPI_PREALLOC);
-		if (error)
-			goto out_unlock;
-	}
-
-	iattr.ia_valid = ATTR_SIZE;
-	iattr.ia_size = bf->l_start;
-	error = xfs_vn_setattr_size(file_mnt_user_ns(filp), file_dentry(filp),
-				    &iattr);
-	if (error)
-		goto out_unlock;
-
-	error = xfs_update_prealloc_flags(ip, flags);
-
-out_unlock:
-	xfs_iunlock(ip, iolock);
-	mnt_drop_write_file(filp);
-	return error;
-}
-
 /* Return 0 on success or positive error */
 int
 xfs_fsbulkstat_one_fmt(
@@ -1965,13 +1884,11 @@ xfs_file_ioctl(
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
 	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64: {
-		xfs_flock64_t		bf;
-
-		if (copy_from_user(&bf, arg, sizeof(bf)))
-			return -EFAULT;
-		return xfs_ioc_space(filp, &bf);
-	}
+	case XFS_IOC_FREESP64:
+		xfs_warn_once(mp,
+	"%s should use fallocate; XFS_IOC_{ALLOC,FREE}SP ioctl unsupported",
+				current->comm);
+		return -ENOTTY;
 	case XFS_IOC_DIOINFO: {
 		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
 		struct dioattr		da;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 845d3bcab74b..d4abba2c13c1 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -10,12 +10,6 @@ struct xfs_bstat;
 struct xfs_ibulk;
 struct xfs_inogrp;
 
-
-extern int
-xfs_ioc_space(
-	struct file		*filp,
-	xfs_flock64_t		*bf);
-
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 8783af203cfc..004ed2a251e8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -27,22 +27,6 @@
 	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
 
 #ifdef BROKEN_X86_ALIGNMENT
-STATIC int
-xfs_compat_flock64_copyin(
-	xfs_flock64_t		*bf,
-	compat_xfs_flock64_t	__user *arg32)
-{
-	if (get_user(bf->l_type,	&arg32->l_type) ||
-	    get_user(bf->l_whence,	&arg32->l_whence) ||
-	    get_user(bf->l_start,	&arg32->l_start) ||
-	    get_user(bf->l_len,		&arg32->l_len) ||
-	    get_user(bf->l_sysid,	&arg32->l_sysid) ||
-	    get_user(bf->l_pid,		&arg32->l_pid) ||
-	    copy_from_user(bf->l_pad,	&arg32->l_pad,	4*sizeof(u32)))
-		return -EFAULT;
-	return 0;
-}
-
 STATIC int
 xfs_compat_ioc_fsgeometry_v1(
 	struct xfs_mount	  *mp,
@@ -445,17 +429,6 @@ xfs_file_compat_ioctl(
 
 	switch (cmd) {
 #if defined(BROKEN_X86_ALIGNMENT)
-	case XFS_IOC_ALLOCSP_32:
-	case XFS_IOC_FREESP_32:
-	case XFS_IOC_ALLOCSP64_32:
-	case XFS_IOC_FREESP64_32: {
-		struct xfs_flock64	bf;
-
-		if (xfs_compat_flock64_copyin(&bf, arg))
-			return -EFAULT;
-		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
-		return xfs_ioc_space(filp, &bf);
-	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
 		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
 	case XFS_IOC_FSGROWFSDATA_32: {


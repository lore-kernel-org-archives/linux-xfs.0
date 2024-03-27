Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88871C6A8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504590; cv=none; b=Fr/YYfIK/ss5RuqefDvmT0w8XBMFJZy/Y5XruPWsj5rX8Op7sYiRggfHe9ndrvHNdWWAg4Bd6zJxsH/5OLc0CyBAqrWp1yg/rPNVQHrNdrgIeu5cMhyRvDNChYzbWC36tWwT9TyPOHnPqTXHasDrF/znwLl2j/Q6DdBN4oAR0Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504590; c=relaxed/simple;
	bh=vMPwR4JickDEIrueJnZDUCkd0NblgzQAbXQzOIizC4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIbvhHl9glydNYb7UkHYsPm0qrWjeVRzu3vqtG0S3dtcawkOFRvAjkTzpsVBvyAId/tt2RWejoCDllXYPQhlSrVw7NRjHHbN8t2NkLgV861B6RJXqSMmwhJqeTJmUgY9GUS2FnVWQLwoM/B/IFSfPf3b6scY8vU0ORArYxCbXj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfwhbneA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfwhbneA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA38C433C7;
	Wed, 27 Mar 2024 01:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504589;
	bh=vMPwR4JickDEIrueJnZDUCkd0NblgzQAbXQzOIizC4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qfwhbneAWSNWWdfTpoXCOXmhB4uuJ4Lfr9JvlZrQEEa+QMLbMmXAGaMTRB8JeYR+J
	 CCJAfxRSJFY+nR1fcvEpK8q8OQYZyxpbwATWpeoc+5HaA8h6SlMgwKhvg7RYdDrGwO
	 U+aN7QgdE2qPeFzUcWMpLKg/ytuNwY8GXY30rGNohxTbCcuHx5ncrFiJFvmXTHG49U
	 wuBO7kBYxL6k3SRSGpp26M8K61HqSNsvFklQlDmCvz0sQ1+/J771SvqrzjD+iukKsz
	 BBMUwpLnvFNzpq4tz/MGHLTFNouUlXU7Bf8UGNKrLqJNlDzDHr0OK/ms7NvG5ZrsMO
	 67Y+GpJEgo/jw==
Date: Tue, 26 Mar 2024 18:56:29 -0700
Subject: [PATCH 14/15] xfs: introduce new file range commit ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380898.3216674.17747658861040725823.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
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

This patch introduces two more new ioctls to manage atomic updates to
file contents -- XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE.  The
commit mechanism here is exactly the same as what XFS_IOC_EXCHANGE_RANGE
does, but with the additional requirement that file2 cannot have changed
since some sampling point.  The start-commit ioctl performs the sampling
of file attributes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |   26 ++++++++++++++
 fs/xfs/xfs_exchrange.c |   54 +++++++++++++++++++++++++++++
 fs/xfs/xfs_exchrange.h |    7 +++-
 fs/xfs/xfs_ioctl.c     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 +-
 5 files changed, 175 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ea07fb7b89722..dffc7322c48d1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -790,6 +790,30 @@ struct xfs_exchange_range {
 	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
 };
 
+/*
+ * Using the same definition of file2 as struct xfs_exchange_range, commit the
+ * contents of file1 into file2 if file2 has the same inode number, mtime, and
+ * ctime as the arguments provided to the call.  The old contents of file2 will
+ * be moved to file1.
+ *
+ * Returns -EBUSY if there isn't an exact match for the file2 fields.
+ *
+ * Filesystems must be able to restart and complete the operation even after
+ * the system goes down.
+ */
+struct xfs_commit_range {
+	__s32		file1_fd;
+	__u32		pad;		/* must be zeroes */
+	__u64		file1_offset;	/* file1 offset, bytes */
+	__u64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
+
+	/* opaque file2 metadata for freshness checks */
+	__u64		file2_freshness[5];
+};
+
 /*
  * Exchange file data all the way to the ends of both files, and then exchange
  * the file sizes.  This flag can be used to replace a file's contents with a
@@ -887,6 +911,8 @@ struct xfs_exchange_range {
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 #define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_START_COMMIT	     _IOWR('X', 130, struct xfs_commit_range)
+#define XFS_IOC_COMMIT_RANGE	     _IOWR('X', 131, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 2d33c7de04f4c..73eae27a23016 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -131,6 +131,33 @@ xfs_exchrange_estimate(
 	return error;
 }
 
+/*
+ * Check that file2's metadata agree with the snapshot that we took for the
+ * range commit request.
+ *
+ * This should be called after the filesystem has locked /all/ inode metadata
+ * against modification.
+ */
+STATIC int
+xfs_exchrange_check_freshness(
+	const struct xfs_exchrange	*fxr,
+	struct xfs_inode		*ip2)
+{
+	struct inode			*inode2 = VFS_I(ip2);
+	struct timespec64		ctime = inode_get_ctime(inode2);
+	struct timespec64		mtime = inode_get_mtime(inode2);
+
+	trace_xfs_exchrange_freshness(fxr, ip2);
+
+	/* Check that file2 hasn't otherwise been modified. */
+	if (fxr->file2_ino != ip2->i_ino ||
+	    !timespec64_equal(&fxr->file2_ctime, &ctime) ||
+	    !timespec64_equal(&fxr->file2_mtime, &mtime))
+		return -EBUSY;
+
+	return 0;
+}
+
 #define QRETRY_IP1	(0x1)
 #define QRETRY_IP2	(0x2)
 
@@ -666,6 +693,12 @@ xfs_exchrange_prep(
 	if (error || fxr->length == 0)
 		return error;
 
+	if (fxr->flags & __XFS_EXCHANGE_RANGE_CHECK_FRESH2) {
+		error = xfs_exchrange_check_freshness(fxr, ip2);
+		if (error)
+			return error;
+	}
+
 	/* Attach dquots to both inodes before changing block maps. */
 	error = xfs_qm_dqattach(ip2);
 	if (error)
@@ -780,7 +813,8 @@ xfs_exchange_range(
 	if (fxr->file1->f_path.mnt != fxr->file2->f_path.mnt)
 		return -EXDEV;
 
-	if (fxr->flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+	if (fxr->flags & ~(XFS_EXCHANGE_RANGE_ALL_FLAGS |
+			 __XFS_EXCHANGE_RANGE_CHECK_FRESH2))
 		return -EINVAL;
 
 	/* Userspace requests only honored for regular files. */
@@ -828,3 +862,21 @@ xfs_exchange_range(
 		fsnotify_modify(fxr->file2);
 	return 0;
 }
+
+/* Sample freshness data from fxr->file2 for a commit range operation. */
+void
+xfs_exchrange_freshness(
+	struct xfs_exchrange	*fxr)
+{
+	struct inode		*inode2 = file_inode(fxr->file2);
+	struct xfs_inode	*ip2 = XFS_I(inode2);
+	unsigned int		lockflags = XFS_IOLOCK_SHARED |
+					    XFS_MMAPLOCK_SHARED |
+					    XFS_ILOCK_SHARED;
+
+	xfs_ilock(ip2, lockflags);
+	fxr->file2_ino = ip2->i_ino;
+	fxr->file2_ctime = inode_get_ctime(inode2);
+	fxr->file2_mtime = inode_get_mtime(inode2);
+	xfs_iunlock(ip2, lockflags);
+}
diff --git a/fs/xfs/xfs_exchrange.h b/fs/xfs/xfs_exchrange.h
index 804bb92cb5c29..80f8aa5239ef1 100644
--- a/fs/xfs/xfs_exchrange.h
+++ b/fs/xfs/xfs_exchrange.h
@@ -13,8 +13,12 @@ int xfs_exchrange_enable(struct xfs_mount *mp);
 #define __XFS_EXCHANGE_RANGE_UPD_CMTIME1	(1ULL << 63)
 #define __XFS_EXCHANGE_RANGE_UPD_CMTIME2	(1ULL << 62)
 
+/* Freshness check required */
+#define __XFS_EXCHANGE_RANGE_CHECK_FRESH2	(1ULL << 61)
+
 #define XFS_EXCHANGE_RANGE_PRIV_FLAGS	(__XFS_EXCHANGE_RANGE_UPD_CMTIME1 | \
-					 __XFS_EXCHANGE_RANGE_UPD_CMTIME2)
+					 __XFS_EXCHANGE_RANGE_UPD_CMTIME2 | \
+					 __XFS_EXCHANGE_RANGE_CHECK_FRESH2)
 
 struct xfs_exchrange {
 	struct file		*file1;
@@ -32,6 +36,7 @@ struct xfs_exchrange {
 	struct timespec64	file2_ctime;
 };
 
+void xfs_exchrange_freshness(struct xfs_exchrange *fxr);
 int xfs_exchange_range(struct xfs_exchrange *fxr);
 
 struct xfs_exchmaps_req;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b11077b12f5fd..d2fc710d2d506 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1965,6 +1965,90 @@ xfs_ioc_exchange_range(
 	return error;
 }
 
+/* Opaque freshness blob for XFS_IOC_COMMIT_RANGE */
+struct xfs_commit_range_fresh {
+	__u64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+	__u64		pad;		/* zero */
+};
+
+static long
+xfs_ioc_start_commit(
+	struct file			*file,
+	struct xfs_commit_range __user	*argp)
+{
+	struct xfs_exchrange		fxr = {
+		.file2			= file,
+	};
+	struct xfs_commit_range		args;
+	struct xfs_commit_range_fresh	*kern_f;
+	struct xfs_commit_range_fresh	__user *user_f;
+
+	BUILD_BUG_ON(sizeof(struct xfs_commit_range_fresh) !=
+		     sizeof(args.file2_freshness));
+
+	xfs_exchrange_freshness(&fxr);
+
+	kern_f = (struct xfs_commit_range_fresh *)&args.file2_freshness;
+	memset(kern_f, 0, sizeof(*kern_f));
+	kern_f->file2_ino		= fxr.file2_ino;
+	kern_f->file2_mtime		= fxr.file2_mtime.tv_sec;
+	kern_f->file2_mtime_nsec	= fxr.file2_mtime.tv_nsec;
+	kern_f->file2_ctime		= fxr.file2_ctime.tv_sec;
+	kern_f->file2_ctime_nsec	= fxr.file2_ctime.tv_nsec;
+
+	user_f = (struct xfs_commit_range_fresh __user *)&argp->file2_freshness;
+	if (copy_to_user(user_f, kern_f, sizeof(*kern_f)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long
+xfs_ioc_commit_range(
+	struct file			*file,
+	struct xfs_commit_range __user	*argp)
+{
+	struct xfs_exchrange		fxr = {
+		.file2			= file,
+	};
+	struct xfs_commit_range		args;
+	struct xfs_commit_range_fresh	*kern_f;
+	struct fd			file1;
+	int				error;
+
+	kern_f = (struct xfs_commit_range_fresh *)&args.file2_freshness;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+	if (memchr_inv(&kern_f->pad, 0, sizeof(kern_f->pad)))
+		return -EINVAL;
+	if (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+		return -EINVAL;
+
+	fxr.file1_offset	= args.file1_offset;
+	fxr.file2_offset	= args.file2_offset;
+	fxr.length		= args.length;
+	fxr.flags		= args.flags | __XFS_EXCHANGE_RANGE_CHECK_FRESH2;
+	fxr.file2_ino		= kern_f->file2_ino;
+	fxr.file2_mtime.tv_sec	= kern_f->file2_mtime;
+	fxr.file2_mtime.tv_nsec	= kern_f->file2_mtime_nsec;
+	fxr.file2_ctime.tv_sec	= kern_f->file2_ctime;
+	fxr.file2_ctime.tv_nsec	= kern_f->file2_ctime_nsec;
+
+	file1 = fdget(args.file1_fd);
+	if (!file1.file)
+		return -EBADF;
+	fxr.file1 = file1.file;
+
+	error = xfs_exchange_range(&fxr);
+	fdput(file1);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2207,6 +2291,10 @@ xfs_file_ioctl(
 
 	case XFS_IOC_EXCHANGE_RANGE:
 		return xfs_ioc_exchange_range(filp, arg);
+	case XFS_IOC_START_COMMIT:
+		return xfs_ioc_start_commit(filp, arg);
+	case XFS_IOC_COMMIT_RANGE:
+		return xfs_ioc_commit_range(filp, arg);
 
 	default:
 		return -ENOTTY;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d688b9e5e08a6..39f7784823cbf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4835,7 +4835,8 @@ DEFINE_INODE_ERROR_EVENT(xfs_exchrange_error);
 	{ XFS_EXCHANGE_RANGE_DRY_RUN,		"DRY_RUN" }, \
 	{ XFS_EXCHANGE_RANGE_FILE1_WRITTEN,	"F1_WRITTEN" }, \
 	{ __XFS_EXCHANGE_RANGE_UPD_CMTIME1,	"CMTIME1" }, \
-	{ __XFS_EXCHANGE_RANGE_UPD_CMTIME2,	"CMTIME2" }
+	{ __XFS_EXCHANGE_RANGE_UPD_CMTIME2,	"CMTIME2" }, \
+	{ __XFS_EXCHANGE_RANGE_CHECK_FRESH2,	"FRESH2" }
 
 /* file exchange-range tracepoint class */
 DECLARE_EVENT_CLASS(xfs_exchrange_class,


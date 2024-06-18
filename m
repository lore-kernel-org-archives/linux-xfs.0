Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBD8568A;
	Tue, 18 Jun 2024 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671715; cv=none; b=tPGXrbI3ccpDCkTWSjWl96nftcOnWOkOvGQ6eQmVp28DlLsATJ46jkqjsBDg6m37wez2KJEaLz0J9K5kQpzTyUxNkNbaRe3/d+4mBmKc1szy3DCcdI7EoZYtNmDqDH2jNIyLv3BG6IbaeCdH1EiR7wtXf8fLDg+87F0pz6zKXGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671715; c=relaxed/simple;
	bh=BzThRy86r8ztwFGUdUJsU/bHYNo+ZhWfd0g7yMF4+JI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbvqSNVw4St6yJTrvCJejCt0vsD76hd9WyJNXQ/3+xeVIPvoQAqV2fYAnHOvmkaeayaZO086VLPg5BoeZ2E8rMa0hIBVbQq+VW2naxqk1jXR7aPfj7XY4Dv3ny/zcp0tG6M2BAEQ+WvWnzScpdh2yhsZmvqcjrzRACxplKs4J+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVFtpwBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVFtpwBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81977C2BD10;
	Tue, 18 Jun 2024 00:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671715;
	bh=BzThRy86r8ztwFGUdUJsU/bHYNo+ZhWfd0g7yMF4+JI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QVFtpwBB/u1D2U5/Z7PrNjFdz7pAuRy0kCFOGWaC70eJsmt7DQh4Nk6lqjfU3mU2G
	 2BzMTo9EDDvAeyMfrl76ectHevcCaCbn88cDqH6TRjfTmdPRo/RBVRz40zxXykEYW8
	 eMbVGm5Od3VGhZgc7G9J5KJNsFXpYI60q9tXgC9/PzZf3oTJuUQqreiXrgSTZE2Lzc
	 0s6s6GB7m6Xl95upfDlpYrf1ZJYjBv8TN01+o8MvbbHCNX14ZobM+fD0P5flO6mZSk
	 u7Ki9IqjKxmrYEgjmT850oC5ajgRNYpiiF4FmA2CPcwRVYxctAp9NWxjr3vIpHSNHB
	 i30Vg6SSdpHjw==
Date: Mon, 17 Jun 2024 17:48:35 -0700
Subject: [PATCH 07/10] src/fiexchange.h: update XFS_IOC_EXCHANGE_RANGE
 definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <171867145405.793463.11941083120880917446.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
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

Update to use our new file content exchange ioctl definitions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 ltp/fsstress.c        |   10 +-----
 ltp/fsx.c             |   19 ++---------
 m4/package_xfslibs.m4 |    2 +
 src/fiexchange.h      |   84 ++++++++++++-------------------------------------
 src/global.h          |   10 ++++++
 src/xfsfind.c         |    1 -
 tests/generic/724     |    2 +
 tests/xfs/791         |    2 +
 8 files changed, 37 insertions(+), 93 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 70e0616521..3749da0e9a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2609,8 +2609,7 @@ exchangerange_f(
 	long			r)
 {
 #ifdef XFS_IOC_EXCHANGE_RANGE
-	struct xfs_exch_range	fxr = { 0 };
-	static __u64		swap_flags = 0;
+	struct xfs_exchange_range	fxr = { 0 };
 	struct pathname		fpath1;
 	struct pathname		fpath2;
 	struct stat64		stat1;
@@ -2734,16 +2733,9 @@ exchangerange_f(
 	fxr.file1_offset = off1;
 	fxr.length = len;
 	fxr.file2_offset = off2;
-	fxr.flags = swap_flags;
 
-retry:
 	ret = ioctl(fd2, XFS_IOC_EXCHANGE_RANGE, &fxr);
 	e = ret < 0 ? errno : 0;
-	if (e == EOPNOTSUPP && !(swap_flags & XFS_EXCH_RANGE_NONATOMIC)) {
-		swap_flags = XFS_EXCH_RANGE_NONATOMIC;
-		fxr.flags |= swap_flags;
-		goto retry;
-	}
 	if (v1 || v2) {
 		printf("%d/%lld: exchangerange %s%s [%lld,%lld] -> %s%s [%lld,%lld]",
 			procid, opno,
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 6ff5e3720f..2dc59b06fc 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1390,29 +1390,17 @@ do_insert_range(unsigned offset, unsigned length)
 #endif
 
 #ifdef XFS_IOC_EXCHANGE_RANGE
-static __u64 swap_flags = 0;
-
 int
 test_exchange_range(void)
 {
-	struct xfs_exch_range	fsr = {
+	struct xfs_exchange_range	fsr = {
 		.file1_fd = fd,
-		.flags = XFS_EXCH_RANGE_DRY_RUN | swap_flags,
+		.flags = XFS_EXCHANGE_RANGE_DRY_RUN,
 	};
 	int ret, e;
 
-retry:
 	ret = ioctl(fd, XFS_IOC_EXCHANGE_RANGE, &fsr);
 	e = ret < 0 ? errno : 0;
-	if (e == EOPNOTSUPP && !(swap_flags & XFS_EXCH_RANGE_NONATOMIC)) {
-		/*
-		 * If the call fails with atomic mode, try again with non
-		 * atomic mode.
-		 */
-		swap_flags = XFS_EXCH_RANGE_NONATOMIC;
-		fsr.flags |= swap_flags;
-		goto retry;
-	}
 	if (e == EOPNOTSUPP || errno == ENOTTY) {
 		if (!quiet)
 			fprintf(stderr,
@@ -1427,12 +1415,11 @@ test_exchange_range(void)
 void
 do_exchange_range(unsigned offset, unsigned length, unsigned dest)
 {
-	struct xfs_exch_range	fsr = {
+	struct xfs_exchange_range	fsr = {
 		.file1_fd = fd,
 		.file1_offset = offset,
 		.file2_offset = dest,
 		.length = length,
-		.flags = swap_flags,
 	};
 	void *p;
 
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 3cc88a27d2..5604989e34 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -99,7 +99,7 @@ AC_DEFUN([AC_NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE],
 #define _GNU_SOURCE
 #include <xfs/xfs.h>
     ]], [[
-         struct xfs_exch_range obj;
+         struct xfs_exchange_range obj;
          ioctl(-1, XFS_IOC_EXCHANGE_RANGE, &obj);
     ]])],[AC_MSG_RESULT(yes)],
          [need_internal_xfs_ioc_exchange_range=yes
diff --git a/src/fiexchange.h b/src/fiexchange.h
index 6a3ae8964d..1f556e69dc 100644
--- a/src/fiexchange.h
+++ b/src/fiexchange.h
@@ -16,86 +16,42 @@
  * called against (which we'll call file2).  Filesystems must be able to
  * restart and complete the operation even after the system goes down.
  */
-struct xfs_exch_range {
-	__s64		file1_fd;
-	__s64		file1_offset;	/* file1 offset, bytes */
-	__s64		file2_offset;	/* file2 offset, bytes */
-	__s64		length;		/* bytes to exchange */
+struct xfs_exchange_range {
+	__s32		file1_fd;
+	__u32		pad;		/* must be zeroes */
+	__u64		file1_offset;	/* file1 offset, bytes */
+	__u64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
 
-	__u64		flags;		/* see XFS_EXCH_RANGE_* below */
-
-	/* file2 metadata for optional freshness checks */
-	__s64		file2_ino;	/* inode number */
-	__s64		file2_mtime;	/* modification time */
-	__s64		file2_ctime;	/* change time */
-	__s32		file2_mtime_nsec; /* mod time, nsec */
-	__s32		file2_ctime_nsec; /* change time, nsec */
-
-	__u64		pad[6];		/* must be zeroes */
+	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
 };
 
-/*
- * Atomic exchange operations are not required.  This relaxes the requirement
- * that the filesystem must be able to complete the operation after a crash.
- */
-#define XFS_EXCH_RANGE_NONATOMIC	(1 << 0)
-
-/*
- * Check that file2's inode number, mtime, and ctime against the values
- * provided, and return -EBUSY if there isn't an exact match.
- */
-#define XFS_EXCH_RANGE_FILE2_FRESH	(1 << 1)
-
-/*
- * Check that the file1's length is equal to file1_offset + length, and that
- * file2's length is equal to file2_offset + length.  Returns -EDOM if there
- * isn't an exact match.
- */
-#define XFS_EXCH_RANGE_FULL_FILES	(1 << 2)
-
 /*
  * Exchange file data all the way to the ends of both files, and then exchange
  * the file sizes.  This flag can be used to replace a file's contents with a
  * different amount of data.  length will be ignored.
  */
-#define XFS_EXCH_RANGE_TO_EOF		(1 << 3)
+#define XFS_EXCHANGE_RANGE_TO_EOF	(1ULL << 0)
 
 /* Flush all changes in file data and file metadata to disk before returning. */
-#define XFS_EXCH_RANGE_FSYNC		(1 << 4)
+#define XFS_EXCHANGE_RANGE_DSYNC	(1ULL << 1)
 
 /* Dry run; do all the parameter verification but do not change anything. */
-#define XFS_EXCH_RANGE_DRY_RUN		(1 << 5)
+#define XFS_EXCHANGE_RANGE_DRY_RUN	(1ULL << 2)
 
 /*
- * Only exchange ranges where file1's range maps to a written extent.  This can
- * be used to emulate scatter-gather atomic writes with a temp file.
+ * Exchange only the parts of the two files where the file allocation units
+ * mapped to file1's range have been written to.  This can accelerate
+ * scatter-gather atomic writes with a temp file if all writes are aligned to
+ * the file allocation unit.
  */
-#define XFS_EXCH_RANGE_FILE1_WRITTEN	(1 << 6)
+#define XFS_EXCHANGE_RANGE_FILE1_WRITTEN (1ULL << 3)
 
-/*
- * Commit the contents of file1 into file2 if file2 has the same inode number,
- * mtime, and ctime as the arguments provided to the call.  The old contents of
- * file2 will be moved to file1.
- *
- * With this flag, all committed information can be retrieved even if the
- * system crashes or is rebooted.  This includes writing through or flushing a
- * disk cache if present.  The call blocks until the device reports that the
- * commit is complete.
- *
- * This flag should not be combined with NONATOMIC.  It can be combined with
- * FILE1_WRITTEN.
- */
-#define XFS_EXCH_RANGE_COMMIT		(XFS_EXCH_RANGE_FILE2_FRESH | \
-					 XFS_EXCH_RANGE_FSYNC)
-
-#define XFS_EXCH_RANGE_ALL_FLAGS	(XFS_EXCH_RANGE_NONATOMIC | \
-					 XFS_EXCH_RANGE_FILE2_FRESH | \
-					 XFS_EXCH_RANGE_FULL_FILES | \
-					 XFS_EXCH_RANGE_TO_EOF | \
-					 XFS_EXCH_RANGE_FSYNC | \
-					 XFS_EXCH_RANGE_DRY_RUN | \
-					 XFS_EXCH_RANGE_FILE1_WRITTEN)
+#define XFS_EXCHANGE_RANGE_ALL_FLAGS	(XFS_EXCHANGE_RANGE_TO_EOF | \
+					 XFS_EXCHANGE_RANGE_DSYNC | \
+					 XFS_EXCHANGE_RANGE_DRY_RUN | \
+					 XFS_EXCHANGE_RANGE_FILE1_WRITTEN)
 
-#define XFS_IOC_EXCHANGE_RANGE	_IOWR('X', 129, struct xfs_exch_range)
+#define XFS_IOC_EXCHANGE_RANGE	     _IOWR('X', 129, struct xfs_exchange_range)
 
 #endif /* _LINUX_FIEXCHANGE_H */
diff --git a/src/global.h b/src/global.h
index 157c898065..fc48d82e03 100644
--- a/src/global.h
+++ b/src/global.h
@@ -9,10 +9,20 @@
 
 #include <config.h>
 
+#ifdef NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
+/* Override struct xfs_exchange_range in xfslibs */
+# define xfs_exchange_range		sys_xfs_exchange_range
+#endif
+
 #ifdef HAVE_XFS_XFS_H
 #include <xfs/xfs.h>
 #endif
 
+#ifdef NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
+# undef xfs_exchange_range
+# undef XFS_IOC_EXCHANGE_RANGE
+#endif
+
 #ifdef HAVE_XFS_LIBXFS_H
 #include <xfs/libxfs.h>
 #endif
diff --git a/src/xfsfind.c b/src/xfsfind.c
index 6b0a93e793..c81deaf64f 100644
--- a/src/xfsfind.c
+++ b/src/xfsfind.c
@@ -10,7 +10,6 @@
 #include <unistd.h>
 #include <ftw.h>
 #include <linux/fs.h>
-#include <xfs/xfs.h>
 
 #include "global.h"
 
diff --git a/tests/generic/724 b/tests/generic/724
index 4cc02946dd..2d58ccb9d5 100755
--- a/tests/generic/724
+++ b/tests/generic/724
@@ -5,7 +5,7 @@
 # FS QA Test No. 724
 #
 # Test scatter-gather atomic file writes.  We create a temporary file, write
-# sparsely to it, then use XFS_EXCHRANGE_FILE1_WRITTEN flag to swap
+# sparsely to it, then use XFS_EXCHANGE_RANGE_FILE1_WRITTEN flag to swap
 # atomicallly only the ranges that we wrote.
 
 . ./common/preamble
diff --git a/tests/xfs/791 b/tests/xfs/791
index 37f58972c4..62d89f71bc 100755
--- a/tests/xfs/791
+++ b/tests/xfs/791
@@ -5,7 +5,7 @@
 # FS QA Test No. 791
 #
 # Test scatter-gather atomic file writes.  We create a temporary file, write
-# sparsely to it, then use XFS_EXCHRANGE_FILE1_WRITTEN flag to swap
+# sparsely to it, then use XFS_EXCHANGE_RANGE_FILE1_WRITTEN flag to swap
 # atomicallly only the ranges that we wrote.  Inject an error so that we can
 # test that log recovery finishes the swap.
 


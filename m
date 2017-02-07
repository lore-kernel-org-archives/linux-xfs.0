Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22031 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbdBGBEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2017 20:04:22 -0500
Date: Mon, 6 Feb 2017 17:04:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: use system FICLONE/FICLONERANGE/FIDEDUPERANGE
 definitions
Message-ID: <20170207010415.GI3580@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

The clone and dedupe ioctls have been hoisted into the VFS headers, so
there's no need to rely on our private version unless we're compiling on
a system with old kernel headers.  Also, these three ioctls only exist
on Linux so there's no point in compiling with them elsewhere.

So, move the ioctl definitions to include/linux.h, use the generic names
everywhere, and shut it off on !Linux.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac          |    3 ++
 include/builddefs.in  |   15 +++++++++++-
 include/linux.h       |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/Makefile           |    7 +++++
 io/io.h               |    4 +++
 io/reflink.c          |   42 ++++++++++++++++-----------------
 libxfs/xfs_fs.h       |   41 --------------------------------
 m4/package_libcdev.m4 |   56 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 167 insertions(+), 64 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1506b5e..7c4e560 100644
--- a/configure.ac
+++ b/configure.ac
@@ -142,6 +142,9 @@ AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
+AC_HAVE_SYS_FICLONE
+AC_HAVE_SYS_FICLONERANGE
+AC_HAVE_SYS_FIDEDUPERANGE
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index 94d25fc..263e64f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -112,16 +112,20 @@ HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
+HAVE_SYS_FICLONE = @have_sys_ficlone@
+HAVE_SYS_FICLONERANGE = @have_sys_ficlonerange@
+HAVE_SYS_FIDEDUPERANGE = @have_sys_fideduperange@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
 ifeq ($(PKG_PLATFORM),linux)
-PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
+PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS) -DHAVE_CLONE
 ifeq ($(HAVE_UMODE_T),yes)
 PCFLAGS += -DHAVE_UMODE_T
 endif
 DEPENDFLAGS = -D__linux__
+HAVE_CLONE = yes
 endif
 ifeq ($(PKG_PLATFORM),gnukfreebsd)
 PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
@@ -150,6 +154,15 @@ endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
+ifeq ($(PKG_PLATFORM)_$(HAVE_SYS_FICLONE),linux_)
+PCFLAGS+= -DOVERRIDE_FICLONE
+endif
+ifeq ($(PKG_PLATFORM)_$(HAVE_SYS_FICLONERANGE),linux_)
+PCFLAGS+= -DOVERRIDE_FICLONERANGE
+endif
+ifeq ($(PKG_PLATFORM)_$(HAVE_SYS_FIDEDUPERANGE),linux_)
+PCFLAGS+= -DOVERRIDE_FIDEDUPERANGE
+endif
 
 
 GCFLAGS = $(DEBUG) \
diff --git a/include/linux.h b/include/linux.h
index 6a676ca..2a140d2 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -35,7 +35,21 @@
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # define fsxattr sys_fsxattr
 #endif
+#ifdef OVERRIDE_FICLONERANGE
+# define file_clone_range sys_file_clone_range
+#endif
+#ifdef OVERRIDE_FIDEDUPERANGE
+# define file_dedupe_range sys_file_dedupe_range
+# define file_dedupe_range_info sys_file_dedupe_range_info
+#endif
 #include <linux/fs.h> /* fsxattr defintion for new kernels */
+#ifdef OVERRIDE_FIDEDUPERANGE
+# undef file_dedupe_range
+# undef file_dedupe_range_info
+#endif
+#ifdef OVERRIDE_FICLONERANGE
+# undef file_clone_range
+#endif
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # undef fsxattr
 #endif
@@ -222,4 +236,53 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+#ifdef OVERRIDE_FICLONE
+# define FICLONE		_IOW(0x94, 9, int)
+#endif
+
+#ifdef OVERRIDE_FICLONERANGE
+struct file_clone_range {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
+#define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
+#endif /* OVERRIDE_FICLONERANGE */
+
+#ifdef OVERRIDE_FIDEDUPERANGE
+
+/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
+#define FILE_DEDUPE_RANGE_SAME		0
+#define FILE_DEDUPE_RANGE_DIFFERS	1
+
+/* from struct btrfs_ioctl_file_extent_same_info */
+struct file_dedupe_range_info {
+	__s64 dest_fd;		/* in - destination file */
+	__u64 dest_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file. */
+	/* status of this dedupe operation:
+	 * < 0 for error
+	 * == FILE_DEDUPE_RANGE_SAME if dedupe succeeds
+	 * == FILE_DEDUPE_RANGE_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;		/* must be zero */
+};
+
+/* from struct btrfs_ioctl_file_extent_same_args */
+struct file_dedupe_range {
+	__u64 src_offset;	/* in - start of extent in source */
+	__u64 src_length;	/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;	/* must be zero */
+	__u32 reserved2;	/* must be zero */
+	struct file_dedupe_range_info info[0];
+};
+
+#define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
+#endif /* OVERRIDE_FIDEDUPERANGE */
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/io/Makefile b/io/Makefile
index 32df568..62cf28c 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,7 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
 	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
-	pwrite.c reflink.c seek.c shutdown.c sync.c truncate.c utimes.c
+	pwrite.c seek.c shutdown.c sync.c truncate.c utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
@@ -99,6 +99,11 @@ ifeq ($(HAVE_MREMAP),yes)
 LCFLAGS += -DHAVE_MREMAP
 endif
 
+ifeq ($(HAVE_CLONE),yes)
+CFILES += reflink.c
+LCFLAGS += -DHAVE_CLONE
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/io.h b/io/io.h
index c40aad0..2cc2bfc 100644
--- a/io/io.h
+++ b/io/io.h
@@ -170,6 +170,10 @@ extern void		readdir_init(void);
 #define readdir_init()		do { } while (0)
 #endif
 
+#ifdef HAVE_CLONE
 extern void		reflink_init(void);
+#else
+#define reflink_init()		do { } while (0)
+#endif
 
 extern void		cowextsize_init(void);
diff --git a/io/reflink.c b/io/reflink.c
index fe05d1e..dee08be 100644
--- a/io/reflink.c
+++ b/io/reflink.c
@@ -55,24 +55,24 @@ dedupe_ioctl(
 	uint64_t	len,
 	int		*ops)
 {
-	struct xfs_extent_data		*args;
-	struct xfs_extent_data_info	*info;
+	struct file_dedupe_range	*args;
+	struct file_dedupe_range_info	*info;
 	int				error;
 	uint64_t			deduped = 0;
 
-	args = calloc(1, sizeof(struct xfs_extent_data) +
-			 sizeof(struct xfs_extent_data_info));
+	args = calloc(1, sizeof(struct file_dedupe_range) +
+			 sizeof(struct file_dedupe_range_info));
 	if (!args)
 		goto done;
-	info = (struct xfs_extent_data_info *)(args + 1);
-	args->logical_offset = soffset;
-	args->length = len;
+	info = (struct file_dedupe_range_info *)(args + 1);
+	args->src_offset = soffset;
+	args->src_length = len;
 	args->dest_count = 1;
-	info->fd = file->fd;
-	info->logical_offset = doffset;
+	info->dest_fd = file->fd;
+	info->dest_offset = doffset;
 
-	while (args->length > 0 || !*ops) {
-		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
+	while (args->src_length > 0 || !*ops) {
+		error = ioctl(fd, FIDEDUPERANGE, args);
 		if (error) {
 			perror("XFS_IOC_FILE_EXTENT_SAME");
 			goto done;
@@ -82,21 +82,21 @@ dedupe_ioctl(
 					_(strerror(-info->status)));
 			goto done;
 		}
-		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
+		if (info->status == FILE_DEDUPE_RANGE_DIFFERS) {
 			fprintf(stderr, "XFS_IOC_FILE_EXTENT_SAME: %s\n",
 					_("Extents did not match."));
 			goto done;
 		}
-		if (args->length != 0 &&
+		if (args->src_length != 0 &&
 		    (info->bytes_deduped == 0 ||
-		     info->bytes_deduped > args->length))
+		     info->bytes_deduped > args->src_length))
 			break;
 
 		(*ops)++;
-		args->logical_offset += info->bytes_deduped;
-		info->logical_offset += info->bytes_deduped;
-		if (args->length >= info->bytes_deduped)
-			args->length -= info->bytes_deduped;
+		args->src_offset += info->bytes_deduped;
+		info->dest_offset += info->bytes_deduped;
+		if (args->src_length >= info->bytes_deduped)
+			args->src_length -= info->bytes_deduped;
 		deduped += info->bytes_deduped;
 	}
 done:
@@ -203,11 +203,11 @@ reflink_ioctl(
 	uint64_t		len,
 	int			*ops)
 {
-	struct xfs_clone_args	args;
+	struct file_clone_range	args;
 	int			error;
 
 	if (soffset == 0 && doffset == 0 && len == 0) {
-		error = ioctl(file->fd, XFS_IOC_CLONE, fd);
+		error = ioctl(file->fd, FICLONE, fd);
 		if (error)
 			perror("XFS_IOC_CLONE");
 	} else {
@@ -215,7 +215,7 @@ reflink_ioctl(
 		args.src_offset = soffset;
 		args.src_length = len;
 		args.dest_offset = doffset;
-		error = ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
+		error = ioctl(file->fd, FICLONERANGE, &args);
 		if (error)
 			perror("XFS_IOC_CLONE_RANGE");
 	}
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index df58c1c..b828853 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -557,47 +557,6 @@ typedef struct xfs_swapext
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
-/* reflink ioctls; these MUST match the btrfs ioctl definitions */
-/* from struct btrfs_ioctl_clone_range_args */
-struct xfs_clone_args {
-	__s64 src_fd;
-	__u64 src_offset;
-	__u64 src_length;
-	__u64 dest_offset;
-};
-
-/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
-#define XFS_EXTENT_DATA_SAME	0
-#define XFS_EXTENT_DATA_DIFFERS	1
-
-/* from struct btrfs_ioctl_file_extent_same_info */
-struct xfs_extent_data_info {
-	__s64 fd;		/* in - destination file */
-	__u64 logical_offset;	/* in - start of extent in destination */
-	__u64 bytes_deduped;	/* out - total # of bytes we were able
-				 * to dedupe from this file */
-	/* status of this dedupe operation:
-	 * < 0 for error
-	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
-	 * == XFS_EXTENT_DATA_DIFFERS if data differs
-	 */
-	__s32 status;		/* out - see above description */
-	__u32 reserved;
-};
-
-/* from struct btrfs_ioctl_file_extent_same_args */
-struct xfs_extent_data {
-	__u64 logical_offset;	/* in - start of extent in source */
-	__u64 length;		/* in - length of extent */
-	__u16 dest_count;	/* in - total elements in info array */
-	__u16 reserved1;
-	__u32 reserved2;
-	struct xfs_extent_data_info info[0];
-};
-
-#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
-#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
-#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index bc3b4ce..0a6401b 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -277,3 +277,59 @@ AC_DEFUN([AC_NEED_INTERNAL_FSXATTR],
     )
     AC_SUBST(need_internal_fsxattr)
   ])
+
+#
+# Check if we have a FICLONE ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_SYS_FICLONE],
+  [ AC_MSG_CHECKING([for FICLONE])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <linux/fs.h>
+    ], [
+         unsigned long x = FICLONE;
+    ], have_sys_ficlone=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_sys_ficlone)
+  ])
+
+#
+# Check if we have a FICLONERANGE ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_SYS_FICLONERANGE],
+  [ AC_MSG_CHECKING([for FICLONERANGE])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <linux/fs.h>
+    ], [
+         unsigned long x = FICLONERANGE;
+         struct file_clone_range fcr;
+    ], have_sys_ficlonerange=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_sys_ficlonerange)
+  ])
+
+#
+# Check if we have a FIDEDUPERANGE ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_SYS_FIDEDUPERANGE],
+  [ AC_MSG_CHECKING([for FIDEDUPERANGE])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <linux/fs.h>
+    ], [
+         unsigned long x = FIDEDUPERANGE;
+         struct file_dedupe_range fdr;
+    ], have_sys_fideduperange=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_sys_fideduperange)
+  ])

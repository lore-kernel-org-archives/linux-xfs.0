Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56540 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948729AbdEZVUv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 May 2017 17:20:51 -0400
Subject: Re: [PATCH 0.9/9] xfs: introduce the XFS_IOC_GETFSMAP ioctl
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <20170508194755.GK5973@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9d94c89f-f730-955c-bde3-eb9264737303@sandeen.net>
Date: Fri, 26 May 2017 16:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <20170508194755.GK5973@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 5/8/17 2:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new ioctl that uses the reverse mapping btree to return
> information about the physical layout of the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, howzabout this:

Changes from your version:

- remove libxfs stuff, I synced that separately already
- rename sys_fsmap just fsmap (it's not a syscall)
- change meaning of "have_fsmap" - it now means we have it on the
  system, not that this platform (linux) might support it.*
- remove OVERRIDE_GETFSMAP - we aren't overriding anything now,
  we are using our own definition only if the system doesn't have it
- #include <linux/fs.h> before fsmap.h in autoconf or it'll /never/
  build and be detected

* we didn't bother with this for i.e. fiemap or anything else,
  afaict, and I'd like to just kill off the other platforms anyway.
  (I guess they didn't carry along their own copy, though, but meh,
  I have no idea if they even build at this point)

See what you think?


diff --git a/configure.ac b/configure.ac
index aa102e4..9534986 100644
--- a/configure.ac
+++ b/configure.ac
@@ -142,6 +142,7 @@ AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
+AC_HAVE_GETFSMAP
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index 4d6bb2d..675bedf 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -112,6 +112,7 @@ HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
+HAVE_GETFSMAP = @have_getfsmap@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -150,6 +151,9 @@ endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
+ifeq ($(HAVE_FSMAP),yes)
+PCFLAGS+= -DHAVE_FSMAP
+endif
 
 
 GCFLAGS = $(DEBUG) \
diff --git a/include/linux.h b/include/linux.h
index 6a676ca..38969d1 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -222,4 +222,107 @@ struct fsxattr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+#ifndef HAVE_GETFSMAP
+/*
+ *	Structure for FS_IOC_GETFSMAP.
+ *
+ *	The memory layout for this call are the scalar values defined in
+ *	struct fsmap_head, followed by two struct fsmap that describe
+ *	the lower and upper bound of mappings to return, followed by an
+ *	array of struct fsmap mappings.
+ *
+ *	fmh_iflags control the output of the call, whereas fmh_oflags report
+ *	on the overall record output.  fmh_count should be set to the
+ *	length of the fmh_recs array, and fmh_entries will be set to the
+ *	number of entries filled out during each call.  If fmh_count is
+ *	zero, the number of reverse mappings will be returned in
+ *	fmh_entries, though no mappings will be returned.  fmh_reserved
+ *	must be set to zero.
+ *
+ *	The two elements in the fmh_keys array are used to constrain the
+ *	output.  The first element in the array should represent the
+ *	lowest disk mapping ("low key") that the user wants to learn
+ *	about.  If this value is all zeroes, the filesystem will return
+ *	the first entry it knows about.  For a subsequent call, the
+ *	contents of fsmap_head.fmh_recs[fsmap_head.fmh_count - 1] should be
+ *	copied into fmh_keys[0] to have the kernel start where it left off.
+ *
+ *	The second element in the fmh_keys array should represent the
+ *	highest disk mapping ("high key") that the user wants to learn
+ *	about.  If this value is all ones, the filesystem will not stop
+ *	until it runs out of mapping to return or runs out of space in
+ *	fmh_recs.
+ *
+ *	fmr_device can be either a 32-bit cookie representing a device, or
+ *	a 32-bit dev_t if the FMH_OF_DEV_T flag is set.  fmr_physical,
+ *	fmr_offset, and fmr_length are expressed in units of bytes.
+ *	fmr_owner is either an inode number, or a special value if
+ *	FMR_OF_SPECIAL_OWNER is set in fmr_flags.
+ */
+struct fsmap {
+	__u32		fmr_device;	/* device id */
+	__u32		fmr_flags;	/* mapping flags */
+	__u64		fmr_physical;	/* device offset of segment */
+	__u64		fmr_owner;	/* owner id */
+	__u64		fmr_offset;	/* file offset of segment */
+	__u64		fmr_length;	/* length of segment */
+	__u64		fmr_reserved[3];	/* must be zero */
+};
+
+struct fsmap_head {
+	__u32		fmh_iflags;	/* control flags */
+	__u32		fmh_oflags;	/* output flags */
+	__u32		fmh_count;	/* # of entries in array incl. input */
+	__u32		fmh_entries;	/* # of entries filled in (output). */
+	__u64		fmh_reserved[6];	/* must be zero */
+
+	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
+	struct fsmap	fmh_recs[];	/* returned records */
+};
+
+/* Size of an fsmap_head with room for nr records. */
+static inline size_t
+fsmap_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
+}
+
+/* Start the next fsmap query at the end of the current query results. */
+static inline void
+fsmap_advance(
+	struct fsmap_head	*head)
+{
+	head->fmh_keys[0] = head->fmh_recs[head->fmh_entries - 1];
+}
+
+/*	fmh_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
+/* no flags defined yet */
+#define FMH_IF_VALID		0
+
+/*	fmh_oflags values - returned in the header segment only. */
+#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
+
+/*	fmr_flags values - returned for each non-header segment */
+#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
+#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
+#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
+#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
+#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
+#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
+
+/* Each FS gets to define its own special owner codes. */
+#define FMR_OWNER(type, code)	(((__u64)type << 32) | \
+				 ((__u64)code & 0xFFFFFFFFULL))
+#define FMR_OWNER_TYPE(owner)	((__u32)((__u64)owner >> 32))
+#define FMR_OWNER_CODE(owner)	((__u32)(((__u64)owner & 0xFFFFFFFFULL)))
+#define FMR_OWN_FREE		FMR_OWNER(0, 1) /* free space */
+#define FMR_OWN_UNKNOWN		FMR_OWNER(0, 2) /* unknown owner */
+#define FMR_OWN_METADATA	FMR_OWNER(0, 3) /* metadata */
+
+#define FS_IOC_GETFSMAP		_IOWR('X', 59, struct fsmap_head)
+
+#define HAVE_GETFSMAP
+#endif /* HAVE_GETFSMAP */
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index bc3b4ce..fa5b639 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -277,3 +277,23 @@ AC_DEFUN([AC_NEED_INTERNAL_FSXATTR],
     )
     AC_SUBST(need_internal_fsxattr)
   ])
+
+#
+# Check if we have a FS_IOC_GETFSMAP ioctl (Linux)
+#
+AC_DEFUN([AC_HAVE_GETFSMAP],
+  [ AC_MSG_CHECKING([for GETFSMAP])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+#include <linux/fs.h>
+#include <linux/fsmap.h>
+    ], [
+         unsigned long x = FS_IOC_GETFSMAP;
+         struct fsmap_head fh;
+    ], have_getfsmap=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_getfsmap)
+  ])


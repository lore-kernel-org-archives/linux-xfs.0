Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836644B04B1;
	Wed, 16 Sep 2026 11:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559525; cv=none; b=lroNFMQiTpaUAooWHkxfx2QTX1vGGlEo84JCiq+H2nzztwASk07nErUJVK0LLZ7jYBINuH3CaboziSZklfdaKM9ZeEiU4zT0l3a+IIWIzi/l09hWT4ag3qFZng1mbI4vbP0x5t6//gSGKScXVDEAwUdvtMFg06r7ICgXa2pdC98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559525; c=relaxed/simple;
	bh=COg8cO39C0HaoBxwM1gFEEOpCm3EDGD+AIS+u4pXkKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVBxtnzvYEimilZ1Tr67lRgxMjtnz6xBifbHRH8qQQu9ZvHMCviadhNDx65lKgE4ksOBqHGdtG44Tg6JwTl75JrEgffetlQI19GJqnoZp41Kg4UKG8d+Mas40vht0OmGUp2iTXM0BsR0rN5dZrEQs04eXZk4bFgbzwFBL8bvR24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJJtf+b6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJJtf+b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874EB1F000FF;
	Wed, 16 Sep 2026 11:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789559512;
	bh=yCAthROx0KYOMlJTk1Lsv9disR6/i3DPilBQqCRVBjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJJtf+b6V5j9G5jSILo26GVwskFrV5+aZEiKr2arJH55EUD2Xt5ERUL98VXfPoMS+
	 6G1ZQ62Bt1/mRrjL63mFIhWoQJFPmXR1/FUYb8OHsxTrEoa+3woEzEUEsF+SGkdtDj
	 ym5dN/bDEAIgQj23c3eT1v0O5y3vmMRcz+7+Hub89mi/bX+HLnwbikvdhwayz64ZHP
	 oGPB5BwmPmB65qBcyiesp5RAS16QphQMpXsFNWbeXuJegeMVQabw4Dh2zHS9Jy0fVP
	 MwKWQWG9XXcg1GOv51UoshianF4FlZypPOo/6c9i7CtTghOm8C7ZvnzALS5mGCw6DD
	 jRtAhIa/GDLbA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	djwong@kernel.org
Subject: [PATCH v4] man/man2: introduce man page for file_getattr/file_setattr syscalls
Date: Wed, 16 Sep 2026 13:51:39 +0200
Message-ID: <20260916115141.3500780-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260914111107.1735564-1-aalbersh@kernel.org>
References: <20260914111107.1735564-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add manual pages for file_getattr() and file_setattr() syscalls and
struct file_attr used as input/output argument.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/

---
Changes from v3:
- dropped VERSIONS section in file_attr.2type
- reference arguments and errors from file_setattr to file_getattr
- Minor wording fixes
- Minor formatting fixes
- Removed zero-initialized requirement
- Interdiff with v3 below

Changes from v2:
- a few grammar fixes
- styling fixes
- sashiko.dev fixes (wrong AT_FDCWD combined with AT_EMPTY_PATH
  description, unused "dfd")
- dropped requirement to zero fattr before using file_setattr()
- Pathname -> path
- Dropped description of why FS_IOC_ aren't usable with special files
- Fixed backslashes in the code examples
---
 man/man2/file_getattr.2      | 254 +++++++++++++++++++++++++++++++++++
 man/man2/file_setattr.2      | 180 +++++++++++++++++++++++++
 man/man2type/file_attr.2type | 151 +++++++++++++++++++++
 3 files changed, 585 insertions(+)
 create mode 100644 man/man2/file_getattr.2
 create mode 100644 man/man2/file_setattr.2
 create mode 100644 man/man2type/file_attr.2type

diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
new file mode 100644
index 000000000000..fe804d97976b
--- /dev/null
+++ b/man/man2/file_getattr.2
@@ -0,0 +1,254 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH file_getattr 2 (date) "Linux man-pages (unreleased)"
+.SH NAME
+file_getattr \- get filesystem file attributes
+.SH SYNOPSIS
+.nf
+.BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
+.BR "#include <linux/fs.h>" "         /* " FS_XFLAG_* " constants */"
+.BR "#include <sys/syscall.h>" "      /* " SYS_* " constants */"
+.B #include <unistd.h>
+.P
+.B long syscall(SYS_file_getattr,
+.BI "               int " dirfd ", const char *" path ,
+.BI "               struct file_attr *" fattr ", size_t " size ,
+.BI "               unsigned int " flags );
+.fi
+.SH DESCRIPTION
+The
+.BR file_getattr ()
+system call retrieves filesystem file attributes
+specified by path.
+.P
+As with
+.BR openat (2),
+if
+.I path
+is relative,
+then it is interpreted relative to the directory
+referred to by the file descriptor
+.IR dirfd .
+The special
+.I dirfd
+value
+.B AT_FDCWD
+can be used to refer to the current working directory of the calling process.
+If
+.I path
+is absolute,
+then
+.I dirfd
+is ignored.
+.P
+The
+.I fattr
+argument is a pointer to a
+.I file_attr
+structure.
+This structure will be filled with file attributes.
+This structure is described in
+.BR file_attr (2type).
+.P
+The
+.I size
+argument specifies the size of the structure pointed to by
+.IR fattr .
+The size indicates version of the structure in use, refer to
+.B file_attr (2type)
+for more information on versioning.
+.P
+The
+.I flags
+argument contains a bitwise OR of zero or more of the following constants:
+.TP
+.B AT_EMPTY_PATH
+If
+.I path
+is an empty string,
+operate on the file referred to by
+.IR dirfd .
+In this case,
+.I dirfd
+can refer to any type of file,
+not just a directory.
+.TP
+.B AT_SYMLINK_NOFOLLOW
+If
+.I path
+is a symbolic link,
+do not dereference it;
+instead get attributes of the symbolic link inode itself.
+By default, symbolic links are dereferenced.
+.SH RETURN VALUE
+On success,
+zero is returned.
+On error,
+\-1 is returned,
+and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.TP
+.B E2BIG
+.I size
+is too big (larger than
+.BR PAGE_SIZE ).
+.TP
+.B EACCES
+Search permission is denied for one of the directories
+in the path prefix of
+.IR path .
+.TP
+.B EBADF
+.I path
+is relative but
+.I dirfd
+is neither
+.B AT_FDCWD
+nor a valid file descriptor.
+.TP
+.B EBADF
+.I path
+is an empty string,
+.B AT_EMPTY_PATH
+was specified,
+but
+.I dirfd
+is neither
+.B AT_FDCWD
+nor a valid file descriptor.
+.TP
+.B EFAULT
+.I path
+or
+.I fattr
+is an invalid pointer.
+.TP
+.B EINVAL
+Unknown flag specified in
+.IR flags .
+.TP
+.B EINVAL
+.I size
+is smaller than
+.BR FILE_ATTR_SIZE_VER0 .
+.TP
+.B ELOOP
+Too many symbolic links encountered while resolving
+.IR path .
+.TP
+.B ENAMETOOLONG
+.I path
+is too long.
+.TP
+.B ENOENT
+A component of
+.I path
+does not exist,
+or
+.I path
+is an empty string and
+.B AT_EMPTY_PATH
+was not specified in
+.IR flags .
+.TP
+.B ENOMEM
+Insufficient kernel memory was available.
+.TP
+.B ENOTDIR
+A component of the path prefix of
+.I path
+is not a directory, or
+.I path
+is relative and
+.I dirfd
+is a file descriptor referring to a file other than a directory.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support getting attributes on this type of inode.
+.SH HISTORY
+.SS Linux 6.17
+This system call is introduced.
+.SH NOTES
+This system call is designed to be extensible.
+The
+.I size
+argument allows user-space applications to indicate
+which version of the
+.I file_attr
+structure they are using,
+enabling the kernel to support both old and new versions
+of the structure simultaneously.
+.P
+If
+.I size
+is smaller than the structure size the kernel expects,
+only the fields that fit within
+.I size
+will be filled in.
+If
+.I size
+is larger than the kernel's structure size,
+the extra bytes are zeroed.
+.SH EXAMPLES
+The program below demonstrates the use of
+.BR file_getattr ()
+to retrieve and display file attributes.
+.P
+.in +4n
+.EX
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#ifndef SYS_file_getattr
+#define SYS_file_getattr 467
+#endif
+
+int
+main(int argc, char *argv[])
+{
+    struct file_attr fa;
+    long ret;
+
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+
+    ret = syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa, sizeof(fa), 0);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+
+    printf("File attributes:\[rs]n");
+    printf("  xflags:     0x%llx\[rs]n", (unsigned long long) fa.fa_xflags);
+    printf("  extsize:    %u\[rs]n", fa.fa_extsize);
+    printf("  nextents:   %u\[rs]n", fa.fa_nextents);
+    printf("  projid:     %u\[rs]n", fa.fa_projid);
+    printf("  cowextsize: %u\[rs]n", fa.fa_cowextsize);
+
+    /*
+     * Try setting NODUMP flag with chattr +d ./foo to see the difference
+     */
+    if (fa.fa_xflags & FS_XFLAG_NODUMP)
+        printf("  NODUMP flag is set\[rs]n");
+
+    exit(EXIT_SUCCESS);
+}
+.EE
+.in
+.SH SEE ALSO
+.BR file_setattr (2),
+.BR file_attr (2type),
+.BR ioctl (2),
+.BR ioctl_fs (2),
+.BR openat (2),
+.BR ioctl_xfs_fssetxattr (2)
diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
new file mode 100644
index 000000000000..0389f42afb50
--- /dev/null
+++ b/man/man2/file_setattr.2
@@ -0,0 +1,180 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH file_setattr 2 (date) "Linux man-pages (unreleased)"
+.SH NAME
+file_setattr \- set filesystem file attributes
+.SH SYNOPSIS
+.nf
+.BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " constants */"
+.BR "#include <linux/fs.h>" "         /* Definition of " FS_XFLAG_* " constants */"
+.BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " constants */"
+.B #include <unistd.h>
+.P
+.B long syscall(SYS_file_setattr,
+.BI "               int " dirfd ", const char *" path ,
+.BI "               struct file_attr *" fattr ", size_t " size ,
+.BI "               unsigned int " flags );
+.fi
+.P
+.SH DESCRIPTION
+The
+.BR file_setattr ()
+system call sets filesystem file attributes
+on the file specified by path.
+.P
+The
+.IR dirfd ,
+.IR path ,
+.IR fattr ,
+.IR size ,
+and
+.I flags
+arguments behaves in the same way as in
+.BR file_getattr (2).
+The only difference is that
+user-space applications should use
+.BR file_getattr (2)
+to initialize
+.I fattr
+argument beforehand.
+.SH RETURN VALUE
+On success,
+zero is returned.
+On error,
+\-1 is returned,
+and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+.P
+The errors are the same as returned by
+.BR file_getattr (2)
+with the addition of following ones:
+.TP
+.B E2BIG
+.I size
+indicates a version which the kernel doesn't support
+(the size is larger than the kernel expects)
+and new fields are non-zero.
+.TP
+.B EINVAL
+Invalid combination of parameters provided in
+.I fattr
+for this type of file or filesystem.
+.TP
+.B EPERM
+The caller does not have the necessary permissions
+to change the file attributes.
+.TP
+.B EROFS
+The file is on a read-only filesystem.
+.SH HISTORY
+.SS Linux 6.17
+This system call is introduced.
+.SH NOTES
+This system call is designed to be extensible.
+The
+.I size
+argument allows user-space applications to indicate
+which version of the
+.I file_attr
+structure they are using,
+enabling the kernel to support both old and new versions
+of the structure simultaneously.
+.P
+If
+.I size
+is smaller than the structure size the kernel expects,
+the kernel treats the missing fields as having zero values
+(which is a no-op).
+If
+.I size
+is larger than expected,
+the kernel checks that all unknown (to the kernel) fields are zero;
+if not,
+the call fails with
+.BR E2BIG .
+.SH EXAMPLES
+The program below demonstrates the use of
+.BR file_setattr ()
+to set the
+.B FS_XFLAG_NODUMP
+flag on a file.
+.P
+.in +4n
+.EX
+#include <fcntl.h>
+#include <linux/fcntl.h>
+#include <linux/fs.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#ifndef SYS_file_getattr
+#define SYS_file_getattr 467
+#endif
+
+#ifndef SYS_file_setattr
+#define SYS_file_setattr 468
+#endif
+
+int
+main(int argc, char *argv[])
+{
+    struct file_attr fa;
+    int dfd;
+    long ret;
+
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+
+    dfd = open(argv[1], O_RDONLY);
+    if (dfd == \-1) {
+        perror("open");
+        exit(EXIT_FAILURE);
+    }
+
+    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa), AT_EMPTY_PATH);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+
+    printf("Current flags: 0x%llx\[rs]n", (unsigned long long) fa.fa_xflags);
+
+    fa.fa_xflags |= FS_XFLAG_NODUMP;
+
+    ret = syscall(SYS_file_setattr, dfd, "", &fa, sizeof(fa), AT_EMPTY_PATH);
+    if (ret == \-1) {
+        perror("file_setattr");
+        exit(EXIT_FAILURE);
+    }
+
+    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa), AT_EMPTY_PATH);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+
+    if (fa.fa_xflags & FS_XFLAG_NODUMP)
+        printf("flags 0x%llx (NODUMP flag is set)\[rs]n",
+            (unsigned long long) fa.fa_xflags);
+
+    exit(EXIT_SUCCESS);
+}
+.EE
+.in
+.SH SEE ALSO
+.BR file_getattr (2),
+.BR ioctl (2),
+.BR ioctl_fs (2),
+.BR openat (2),
+.BR file_attr (2type),
+.BR path_resolution (7),
+.BR ioctl_xfs_fssetxattr (2)
diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
new file mode 100644
index 000000000000..221d97b5220d
--- /dev/null
+++ b/man/man2type/file_attr.2type
@@ -0,0 +1,151 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH file_attr 2type (date) "Linux man-pages (unreleased)"
+.SH NAME
+file_attr \- describe filesystem file attributes to get or set
+.SH SYNOPSIS
+.EX
+.B #include <linux/fs.h>
+.P
+.B struct file_attr {
+.BR "    u64  fa_xflags;" "     /* Extended flags */"
+.BR "    u32  fa_extsize;" "    /* Extent size hint */"
+.BR "    u32  fa_nextents;" "   /* Number of extents (read-only) */"
+.BR "    u32  fa_projid;" "     /* Project identifier */"
+.BR "    u32  fa_cowextsize;" " /* CoW extent size hint */"
+.B };
+.EE
+.SH DESCRIPTION
+Describes filesystem file attributes
+for use with the
+.BR file_getattr (2)
+and
+.BR file_setattr (2)
+system calls.
+.P
+The fields are as follows:
+.TP
+.I fa_xflags
+This field contains file attribute flags.
+It is a bit mask consisting of zero or more of the
+.B FS_XFLAG_*
+flags.
+Refer to the section
+.B FLAGS
+below for a list of all flags.
+.TP
+.I fa_extsize
+Extent size allocator hint in bytes.
+This value suggests a preferred extent size
+for new allocations to this file.
+.TP
+.I fa_nextents
+Number of data extents in the file (read-only).
+This field is filled in by
+.BR file_getattr (2)
+and is ignored by
+.BR file_setattr (2).
+.TP
+.I fa_projid
+Project identifier.
+Used by quota systems to group related files.
+.TP
+.I fa_cowextsize
+Copy-on-Write (CoW) extent size hint in bytes.
+This value suggests a preferred extent size
+for CoW operations.
+.SH FLAGS
+Flags can be:
+.RS
+.TP
+.B FS_XFLAG_REALTIME
+Data is stored in a realtime volume.
+.TP
+.B FS_XFLAG_IMMUTABLE
+File cannot be modified.
+.TP
+.B FS_XFLAG_APPEND
+All writes must append to the end of the file.
+.TP
+.B FS_XFLAG_SYNC
+All writes are synchronous.
+.TP
+.B FS_XFLAG_NOATIME
+Do not update file access time on reads.
+.TP
+.B FS_XFLAG_NODUMP
+Do not include file in backups.
+.TP
+.B FS_XFLAG_DAX
+Use Direct Access (DAX) for I/O operations.
+.TP
+.B FS_XFLAG_NODEFRAG
+Exclude this file from defragmentation operations.
+.TP
+.B FS_XFLAG_FILESTREAM
+Use filestream allocator for this file.
+.TP
+.B FS_XFLAG_EXTSIZE
+Use the extent size hint from the
+.I fa_extsize
+field.
+.TP
+.B FS_XFLAG_COWEXTSIZE
+Use the CoW extent size hint from the
+.I fa_cowextsize
+field.
+.RE
+.P
+Directory only flags:
+.RS
+.TP
+.B FS_XFLAG_RTINHERIT
+New files created in this directory inherit the realtime flag.
+.TP
+.B FS_XFLAG_NOSYMLINKS
+Disallow creation of symbolic links in this directory.
+.TP
+.B FS_XFLAG_EXTSZINHERIT
+New files created in this directory inherit the extent size hint.
+.TP
+.B FS_XFLAG_PROJINHERIT
+New files created in this directory inherit the project identifier.
+.RE
+.P
+The following flags are read-only:
+.RS
+.TP
+.B FS_XFLAG_PREALLOC
+File has preallocated extents.
+.TP
+.B FS_XFLAG_HASATTR
+File has extended attributes.
+.TP
+.B FS_XFLAG_VERITY
+File has fs-verity enabled.
+.TP
+.B FS_XFLAG_CASEFOLD
+The filesystem performs case-insensitive lookups (file and directory name
+comparisons ignore case).
+.TP
+.B FS_XFLAG_CASENONPRESERVING
+The filesystem does not preserve the case of file and directory names.
+.RE
+.P
+Not all filesystems support all flags.
+Setting unsupported flags may result in an
+.B EINVAL
+or
+.B EOPNOTSUPP
+error.
+.SH HISTORY
+.SS Linux v6.17
+This structure is introduced.
+.SS Linux v7.2
+The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to enable
+upper layers, such as NFSD, to retrieve case sensitivity information.
+.SH SEE ALSO
+.BR file_getattr (2),
+.BR file_setattr (2)

Interdiff against v3:
  diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
  index 1168b23c5ce5..fe804d97976b 100644
  --- a/man/man2/file_getattr.2
  +++ b/man/man2/file_getattr.2
  @@ -4,7 +4,7 @@
   .\"
   .TH file_getattr 2 (date) "Linux man-pages (unreleased)"
   .SH NAME
  -file_getattr \- get filesystem inode attributes
  +file_getattr \- get filesystem file attributes
   .SH SYNOPSIS
   .nf
   .BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
  @@ -21,7 +21,7 @@ file_getattr \- get filesystem inode attributes
   The
   .BR file_getattr ()
   system call retrieves filesystem file attributes
  -from the file.
  +specified by path.
   .P
   As with
   .BR openat (2),
  @@ -31,9 +31,11 @@ is relative,
   then it is interpreted relative to the directory
   referred to by the file descriptor
   .IR dirfd .
  -The special value
  +The special
  +.I dirfd
  +value
   .B AT_FDCWD
  -could be used to refer to the current working directory of the calling process.
  +can be used to refer to the current working directory of the calling process.
   If
   .I path
   is absolute,
  @@ -55,16 +57,9 @@ The
   argument specifies the size of the structure pointed to by
   .IR fattr .
   The size indicates version of the structure in use, refer to
  -.B file_attr(2type)
  +.B file_attr (2type)
   for more information on versioning.
   .P
  -Userspace applications should zero-initialize
  -.I struct file_attr
  -before calling
  -.BR file_getattr ()
  -to ensure that fields not filled in by older kernels
  -will have predictable values.
  -.P
   The
   .I flags
   argument contains a bitwise OR of zero or more of the following constants:
  @@ -176,15 +171,12 @@ is a file descriptor referring to a file other than a directory.
   The filesystem does not support getting attributes on this type of inode.
   .SH HISTORY
   .SS Linux 6.17
  -This system call is introduced as a more flexible alternative to the
  -FS_IOC_FSGETXATTR
  -.BR ioctl (2)
  -which could work on any type of file.
  +This system call is introduced.
   .SH NOTES
   This system call is designed to be extensible.
   The
   .I size
  -argument allows userspace applications to indicate
  +argument allows user-space applications to indicate
   which version of the
   .I file_attr
   structure they are using,
  @@ -222,7 +214,7 @@ to retrieve and display file attributes.
   int
   main(int argc, char *argv[])
   {
  -    struct file_attr fa = { 0 };
  +    struct file_attr fa;
       long ret;
   
       if (argc != 2) {
  diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
  index 2b30f25c64de..0389f42afb50 100644
  --- a/man/man2/file_setattr.2
  +++ b/man/man2/file_setattr.2
  @@ -4,12 +4,11 @@
   .\"
   .TH file_setattr 2 (date) "Linux man-pages (unreleased)"
   .SH NAME
  -file_setattr \- set filesystem inode attributes
  +file_setattr \- set filesystem file attributes
   .SH SYNOPSIS
   .nf
   .BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " constants */"
  -.BR "#include <linux/fs.h>" "         /* Definition of " FILE_ATTR_* \
  -" and " FS_XFLAG_* " constants */"
  +.BR "#include <linux/fs.h>" "         /* Definition of " FS_XFLAG_* " constants */"
   .BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " constants */"
   .B #include <unistd.h>
   .P
  @@ -23,77 +22,23 @@ file_setattr \- set filesystem inode attributes
   The
   .BR file_setattr ()
   system call sets filesystem file attributes
  -on the file.
  -.P
  -As with
  -.BR openat (2),
  -if
  -.I path
  -is relative,
  -then it is interpreted relative to the directory
  -referred to by the file descriptor
  -.I dirfd
  -(or the current working directory of the calling process,
  -if
  -.I dirfd
  -is the special value
  -.BR AT_FDCWD ).
  -If
  -.I path
  -is absolute,
  -then
  -.I dirfd
  -is ignored.
  -.P
  -The
  -.I fattr
  -argument is a pointer to a
  -.I file_attr
  -structure,
  -which specifies the attributes to set on the file.
  -This structure is described in
  -.BR file_attr (2type).
  -Userspace applications should use
  -.B file_getattr(2)
  -to initialize
  -.I struct fattr
  -beforehand.
  -.P
  -The
  -.I size
  -argument specifies the size of the structure pointed to by
  -.IR fattr .
  -The size indicates version of the structure in use, refer to
  -.B file_attr(2type)
  -for more information on versioning.
  +on the file specified by path.
   .P
   The
  +.IR dirfd ,
  +.IR path ,
  +.IR fattr ,
  +.IR size ,
  +and
   .I flags
  -argument contains a bitwise OR of zero or more of the following constants:
  -.TP
  -.B AT_EMPTY_PATH
  -If
  -.I path
  -is an empty string,
  -operate on the file referred to by
  -.I dirfd
  -(which may have been obtained using the
  -.BR open (2)
  -.B O_PATH
  -flag).
  -In this case,
  -.I dirfd
  -can refer to any type of file,
  -not just a directory.
  -.TP
  -.B AT_SYMLINK_NOFOLLOW
  -If
  -.I path
  -is a symbolic link,
  -do not dereference it:
  -instead set attributes on the symbolic link itself.
  -By default (i.e., if this flag is not specified),
  -symbolic links are dereferenced.
  +arguments behaves in the same way as in
  +.BR file_getattr (2).
  +The only difference is that
  +user-space applications should use
  +.BR file_getattr (2)
  +to initialize
  +.I fattr
  +argument beforehand.
   .SH RETURN VALUE
   On success,
   zero is returned.
  @@ -103,98 +48,22 @@ and
   .I errno
   is set to indicate the error.
   .SH ERRORS
  +.P
  +The errors are the same as returned by
  +.BR file_getattr (2)
  +with the addition of following ones:
   .TP
   .B E2BIG
   .I size
  -is larger than
  -.BR PAGE_SIZE .
  -.TP
  -.B E2BIG
  -.I size
  -indicates the version which kernel doesn't support (the size is larger than the
  -kernel expects) and new fields are non-zero.
  -.TP
  -.B EACCES
  -Search permission is denied for one of the directories
  -in the path prefix of
  -.IR path .
  -(See also
  -.BR path_resolution (7).)
  -.TP
  -.B EBADF
  -.I path
  -is relative but
  -.I dirfd
  -is neither
  -.B AT_FDCWD
  -nor a valid file descriptor.
  -.TP
  -.B EBADF
  -.I path
  -is an empty string,
  -.B AT_EMPTY_PATH
  -was specified in
  -.IR flags ,
  -and
  -.I dirfd
  -is neither
  -.B AT_FDCWD
  -nor a valid file descriptor.
  -.TP
  -.B EFAULT
  -.I path
  -or
  -.I fattr
  -is an invalid pointer.
  -.TP
  -.B EINVAL
  -Unknown flag specified in
  -.IR flags .
  -.TP
  -.B EINVAL
  -.I size
  -is smaller than
  -.BR FILE_ATTR_SIZE_VER0 .
  +indicates a version which the kernel doesn't support
  +(the size is larger than the kernel expects)
  +and new fields are non-zero.
   .TP
   .B EINVAL
   Invalid combination of parameters provided in
   .I fattr
   for this type of file or filesystem.
   .TP
  -.B ELOOP
  -Too many symbolic links encountered while resolving
  -.IR path .
  -.TP
  -.B ENAMETOOLONG
  -.I path
  -is too long.
  -.TP
  -.B ENOENT
  -A component of
  -.I path
  -does not exist,
  -or
  -.I path
  -is an empty string and
  -.B AT_EMPTY_PATH
  -was not specified in
  -.IR flags .
  -.TP
  -.B ENOMEM
  -Insufficient kernel memory was available.
  -.TP
  -.B ENOTDIR
  -A component of the path prefix of
  -.I path
  -is not a directory, or
  -.I path
  -is relative and
  -.I dirfd
  -is a file descriptor referring to a file other than a directory.
  -.TP
  -.B EOPNOTSUPP
  -The filesystem does not support setting attributes on this type of inode.
  -.TP
   .B EPERM
   The caller does not have the necessary permissions
   to change the file attributes.
  @@ -203,10 +72,7 @@ to change the file attributes.
   The file is on a read-only filesystem.
   .SH HISTORY
   .SS Linux 6.17
  -This system call is introduced as a more flexible alternative to the
  -FS_IOC_FSSETXATTR
  -.BR ioctl (2)
  -which could work on any type of files.
  +This system call is introduced.
   .SH NOTES
   This system call is designed to be extensible.
   The
  @@ -259,7 +125,7 @@ flag on a file.
   int
   main(int argc, char *argv[])
   {
  -    struct file_attr fa = { 0 };
  +    struct file_attr fa;
       int dfd;
       long ret;
   
  diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
  index fd426c19f5f0..221d97b5220d 100644
  --- a/man/man2type/file_attr.2type
  +++ b/man/man2type/file_attr.2type
  @@ -140,45 +140,9 @@ Setting unsupported flags may result in an
   or
   .B EOPNOTSUPP
   error.
  -.SH VERSIONS
  -.SS Structure size
  -The structure size is defined by
  -.B FILE_ATTR_SIZE_VER*
  -which is also a version of the structure being used.
  -The
  -.I size
  -parameter passed to
  -.BR file_getattr (2)
  -and
  -.BR file_setattr (2)
  -indicates the version of
  -.I struct file_attr\fP.
  -.SS FILE_ATTR_SIZE_VER0
  -Size is 24 bytes.
   .SH HISTORY
   .SS Linux v6.17
   This structure is introduced.
  -The
  -.I struct file_attr
  -provides similar functionality to
  -.I struct fsxattr
  -used by the
  -.B FS_IOC_FSGETXATTR
  -and
  -.B FS_IOC_FSSETXATTR
  -.BR ioctl (2)
  -operations,
  -but is designed to be extensible through the
  -.I size
  -parameter of the system calls.
  -.P
  -Extra fields may be appended to the structure in future kernel versions.
  -The kernel will expect new fields to be zeros
  -for older versions of the structure.
  -Therefore, a user
  -.I must
  -zero-fill the structure on initialization to keep compatibility with older
  -kernels.
   .SS Linux v7.2
   The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to enable
   upper layers, such as NFSD, to retrieve case sensitivity information.
-- 
2.55.0


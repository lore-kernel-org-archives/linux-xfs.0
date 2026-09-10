Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DE240FDAD;
	Thu, 10 Sep 2026 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036890; cv=none; b=LAWQCW2pJHzo1w3Cjz8IJi6kw1b+Obwv5a8oZ+h63AHbaN+Bfl5wYH2n4cQV6DY93W6GERIzseD6RimS/eeueDM3l+7+A+8Svged3loa7+kwzgMVLTJuWqq2Kk4v536K75gQ3V1KVQMFaPQDA9jqDDMiKb2sokgDC8Y3TTH+H1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036890; c=relaxed/simple;
	bh=aDBarSzFGcm6vF3EC2viNSix9BOAWIhwI6TEEkKDBmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VnRO43WI6yMx50odbC+2QrQBjjp4KUM29g08qloHT/jWY/HLto/uOKlKe+8I6t66S4uN6VXdpdbJqdV6LMUHfkkDRTUDhP/LYQtKznCo2EgfphmyCjEjo1UxBzKTuHFeKNL2c604AgGoI29oa8vcyxnuqnoRrWG6UfmA4+NMBFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bky9JWno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bky9JWno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4B81F000FF;
	Thu, 10 Sep 2026 10:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036887;
	bh=Hb0W0URrOfoZKmwuaieQ/cUfjV8WYmqMIiT7bKCyoLU=;
	h=From:To:Cc:Subject:Date;
	b=Bky9JWnoQHtzSwhCZyo4iUj+JXg8NIttE4uVbop7xjdE3ALCCR8dCT69JnEEEc6h4
	 yopuM8ZZePdpbsqAQIl/JjOa7A8ZV0NNDikuF/1dhxia6T+Gb1kOU7pcggFIhizz5g
	 WWLg0c1r+3WftxfXT3ABbxhOvnnzRFPCsLs7r8EUkI6AnnlVm0wYRefOTrYHSAEiRO
	 zwvJnvss3jA/YYpwP7GxHkkNNJdHJOA++eiJZud2nn+SeSOd/xmmChhJQnZzrcnI5D
	 DB+o4iF3wzB2nWcFyuCAvaCteIIr04hikbvWA6k3gSUJ+VjdwnbbjDsDpEKH8UodAl
	 YkAhu20tXwCvQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	djwong@kernel.org
Subject: [PATCH v2] man/man2: introduce man page for file_getattr/file_setattr syscalls
Date: Thu, 10 Sep 2026 12:41:18 +0200
Message-ID: <20260910104120.3964799-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
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
v2: a few grammar fixes, sashiko.dev fixes (wrong AT_FDCWD combined with
AT_EMPTY_PATH description, unused "dfd") and dropped requirement to zero
fattr before using file_setattr().
---
 man/man2/file_getattr.2      | 279 +++++++++++++++++++++++++++++
 man/man2/file_setattr.2      | 333 +++++++++++++++++++++++++++++++++++
 man/man2type/file_attr.2type | 187 ++++++++++++++++++++
 3 files changed, 799 insertions(+)
 create mode 100644 man/man2/file_getattr.2
 create mode 100644 man/man2/file_setattr.2
 create mode 100644 man/man2type/file_attr.2type

diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
new file mode 100644
index 000000000000..2d9a6d338a5e
--- /dev/null
+++ b/man/man2/file_getattr.2
@@ -0,0 +1,279 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH file_getattr 2 (date) "Linux man-pages (unreleased)"
+.SH NAME
+file_getattr \- get filesystem inode attributes
+.SH SYNOPSIS
+.nf
+.BR "#include <linux/fcntl.h>" "      /* " AT_* " constants */"
+.BR "#include <linux/fs.h>" "         /* struct " file_attr " and " FS_XFLAG_* " constants */"
+.BR "#include <sys/syscall.h>" "      /* " SYS_* " constants */"
+.B #include <unistd.h>
+.P
+.B long syscall(SYS_file_getattr,
+.BI "               int " dirfd ", const char *" pathname ,
+.BI "               struct file_attr *" fattr ", size_t " size ,
+.BI "               unsigned int " flags );
+.fi
+.P
+.IR Note :
+glibc provides no wrapper for
+.BR file_getattr (),
+use
+.BR syscall (2)
+instead.
+.SH DESCRIPTION
+The
+.BR file_getattr ()
+system call retrieves filesystem file attributes
+from the file specified by
+.IR pathname .
+.P
+This system call provides functionality similar to the
+.B FS_IOC_FSGETXATTR
+.BR ioctl (2)
+operation,
+but with the advantage that the file does not need to be opened.
+By using a pathname,
+.BR file_getattr ()
+can retrieve filesystem file attributes
+from all file types,
+including special files such as FIFOs, sockets, block devices, character
+devices, and symlinks, where opening the targeted inode may not be possible.
+.P
+As with
+.BR openat (2),
+if
+.I pathname
+is relative,
+then it is interpreted relative to the directory
+referred to by the file descriptor
+.IR dirfd .
+The special value
+.B AT_FDCWD
+could be used to refer to the current working directory of the calling process.
+If
+.I pathname
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
+.BR file_attr(2type) .
+.P
+The
+.I size
+argument specifies the size of the buffer pointed to by
+.IR fattr .
+The size indicates version of the structure in use, refer to
+.B file_attr(2type)
+for more information on versioning.
+.P
+Userspace applications should zero-initialize
+.I struct file_attr
+before calling
+.BR file_getattr ()
+to ensure that fields not filled in by older kernels
+will have predictable values.
+.P
+The
+.I flags
+argument is a bit mask, available flags are:
+.TP
+.B AT_EMPTY_PATH
+If
+.I pathname
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
+.I pathname
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
+.IR pathname .
+.TP
+.B EBADF
+.I pathname
+is relative but
+.I dirfd
+is neither
+.B AT_FDCWD
+nor a valid file descriptor.
+.TP
+.B EBADF
+.I pathname
+is an empty string,
+.B AT_EMPTY_PATH
+was specified,
+but
+.I dirfd
+is an invalid file descriptor.
+.TP
+.B EFAULT
+.I pathname
+or
+.I fattr
+is an invalid pointer.
+.TP
+.B EINVAL
+Invalid flag specified in
+.IR flags .
+.TP
+.B EINVAL
+.I size
+is smaller than
+.BR FILE_ATTR_SIZE_VER0 .
+.TP
+.B ELOOP
+Too many symbolic links encountered while resolving
+.IR pathname .
+.TP
+.B ENAMETOOLONG
+.I pathname
+is too long.
+.TP
+.B ENOENT
+A component of
+.I pathname
+does not exist,
+or
+.I pathname
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
+.I pathname
+is not a directory or,
+.I pathname
+is relative and
+.I dirfd
+is a file descriptor referring to a file other than a directory.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support getting attributes on this type of inode.
+.SH HISTORY
+.SS Linux 6.17
+This system call is introduced as a more flexible alternative to the
+FS_IOC_FSGETXATTR
+.BR ioctl (2)
+which could work on any type of file.
+.SH NOTES
+This system call is designed to be extensible.
+The
+.I size
+argument allows userspace applications to indicate
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
+    struct file_attr fa = { 0 };
+    long ret;
+
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s <filename>\\n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+
+    ret = syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa, sizeof(fa), 0);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+
+    printf("File attributes:\\n");
+    printf("  xflags:     0x%llx\\n", (unsigned long long)fa.fa_xflags);
+    printf("  extsize:    %u\\n", fa.fa_extsize);
+    printf("  nextents:   %u\\n", fa.fa_nextents);
+    printf("  projid:     %u\\n", fa.fa_projid);
+    printf("  cowextsize: %u\\n", fa.fa_cowextsize);
+
+    /*
+     * Try setting NODUMP flag with chattr +d ./foo to see the difference
+     */
+    if (fa.fa_xflags & FS_XFLAG_NODUMP)
+        printf("  NODUMP flag is set\\n");
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
+.BR openat (2)
diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
new file mode 100644
index 000000000000..c340bdcab065
--- /dev/null
+++ b/man/man2/file_setattr.2
@@ -0,0 +1,333 @@
+.\" Copyright, the authors of the Linux man-pages project
+.\"
+.\" SPDX-License-Identifier: Linux-man-pages-copyleft
+.\"
+.TH file_setattr 2 (date) "Linux man-pages (unreleased)"
+.SH NAME
+file_setattr \- set filesystem inode attributes
+.SH SYNOPSIS
+.nf
+.BR "#include <linux/fcntl.h>" "      /* Definition of " AT_* " constants */"
+.BR "#include <linux/fs.h>" "         /* Definition of " FILE_ATTR_* \
+" and " FS_XFLAG_* " constants */"
+.BR "#include <sys/syscall.h>" "      /* Definition of " SYS_* " constants */"
+.B #include <unistd.h>
+.P
+.B long syscall(SYS_file_setattr,
+.BI "               int " dirfd ", const char *" pathname ,
+.BI "               struct file_attr *" fattr ", size_t " size ,
+.BI "               unsigned int " flags );
+.fi
+.P
+.IR Note :
+glibc provides no wrapper for
+.BR file_setattr (),
+necessitating the use of
+.BR syscall (2).
+.SH DESCRIPTION
+The
+.BR file_setattr ()
+system call sets filesystem inode attributes
+on the file specified by
+.IR pathname .
+.P
+This system call provides functionality similar to the
+.B FS_IOC_FSSETXATTR
+.BR ioctl (2)
+operation,
+but with the advantage that the file does not need to be opened.
+By using a pathname instead of requiring an open file descriptor,
+.BR file_setattr ()
+can manipulate filesystem inode attributes
+on all file types,
+including special files (FIFOs, sockets, block devices, character devices)
+where opening the file may have side effects or may not be possible.
+With
+.BR ioctl (2),
+it is not always possible to obtain a file descriptor that refers
+directly to the filesystem inode for special files.
+.P
+As with
+.BR openat (2),
+if
+.I pathname
+is relative,
+then it is interpreted relative to the directory
+referred to by the file descriptor
+.I dirfd
+(or the current working directory of the calling process,
+if
+.I dirfd
+is the special value
+.BR AT_FDCWD ).
+If
+.I pathname
+is absolute,
+then
+.I dirfd
+is ignored.
+.P
+The
+.I fattr
+argument is a pointer to a
+.I file_attr
+structure,
+which specifies the attributes to set on the file.
+This structure is described in
+.BR file_attr (2type).
+User-space applications should use
+.B file_getattr(2)
+to initialize
+.I struct fattr
+beforehand.
+.P
+The
+.I size
+argument specifies the size of the buffer pointed to by
+.IR fattr .
+The size indicates version of the structure in use, refer to
+.B file_attr(2type)
+for more information on versioning.
+.P
+The
+.I flags
+argument is a bit mask that can include zero or more of the following values:
+.TP
+.B AT_EMPTY_PATH
+If
+.I pathname
+is an empty string,
+operate on the file referred to by
+.I dirfd
+(which may have been obtained using the
+.BR open (2)
+.B O_PATH
+flag).
+In this case,
+.I dirfd
+can refer to any type of file,
+not just a directory.
+.TP
+.B AT_SYMLINK_NOFOLLOW
+If
+.I pathname
+is a symbolic link,
+do not dereference it:
+instead set attributes on the symbolic link itself.
+By default (i.e., if this flag is not specified),
+symbolic links are dereferenced.
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
+is larger than
+.BR PAGE_SIZE .
+.TP
+.B E2BIG
+.I size
+indicates the version which kernel doesn't support (the size is larger than the
+kernel expects) and new fields are non-zero.
+.TP
+.B EACCES
+Search permission is denied for one of the directories
+in the path prefix of
+.IR pathname .
+(See also
+.BR path_resolution (7).)
+.TP
+.B EBADF
+.I pathname
+is relative but
+.I dirfd
+is neither
+.B AT_FDCWD
+nor a valid file descriptor.
+.TP
+.B EBADF
+.I pathname
+is an empty string,
+.B AT_EMPTY_PATH
+was specified in
+.IR flags ,
+and
+.I dirfd
+is an invalid file descriptor.
+.TP
+.B EFAULT
+.I pathname
+or
+.I fattr
+is an invalid pointer.
+.TP
+.B EINVAL
+Invalid flag specified in
+.IR flags .
+.TP
+.B EINVAL
+.I size
+is smaller than
+.BR FILE_ATTR_SIZE_VER0 .
+.TP
+.B EINVAL
+Invalid combination of parameters provided in
+.I fattr
+for this type of file or filesystem.
+.TP
+.B ELOOP
+Too many symbolic links encountered while resolving
+.IR pathname .
+.TP
+.B ENAMETOOLONG
+.I pathname
+is too long.
+.TP
+.B ENOENT
+A component of
+.I pathname
+does not exist,
+or
+.I pathname
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
+.I pathname
+is not a directory or,
+.I pathname
+is relative and
+.I dirfd
+is a file descriptor referring to a file other than a directory.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support setting attributes on this type of inode.
+.TP
+.B EPERM
+The caller does not have the necessary permissions
+to change the file attributes.
+.TP
+.B EROFS
+The file is on a read-only filesystem.
+.SH HISTORY
+.SS Linux 6.17
+This system call is introduced as a more flexible alternative to the
+FS_IOC_FSSETXATTR
+.BR ioctl (2)
+which could work on any type of files.
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
+    struct file_attr fa = { 0 };
+    int dfd;
+    long ret;
+
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s <filename>\\n", argv[0]);
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
+    printf("Current flags: 0x%llx\\n", (unsigned long long)fa.fa_xflags);
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
+        printf("flags 0x%llx (NODUMP flag is set)\\n",
+            (unsigned long long)fa.fa_xflags);
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
+.BR path_resolution (7)
diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
new file mode 100644
index 000000000000..fd426c19f5f0
--- /dev/null
+++ b/man/man2type/file_attr.2type
@@ -0,0 +1,187 @@
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
+.SH VERSIONS
+.SS Structure size
+The structure size is defined by
+.B FILE_ATTR_SIZE_VER*
+which is also a version of the structure being used.
+The
+.I size
+parameter passed to
+.BR file_getattr (2)
+and
+.BR file_setattr (2)
+indicates the version of
+.I struct file_attr\fP.
+.SS FILE_ATTR_SIZE_VER0
+Size is 24 bytes.
+.SH HISTORY
+.SS Linux v6.17
+This structure is introduced.
+The
+.I struct file_attr
+provides similar functionality to
+.I struct fsxattr
+used by the
+.B FS_IOC_FSGETXATTR
+and
+.B FS_IOC_FSSETXATTR
+.BR ioctl (2)
+operations,
+but is designed to be extensible through the
+.I size
+parameter of the system calls.
+.P
+Extra fields may be appended to the structure in future kernel versions.
+The kernel will expect new fields to be zeros
+for older versions of the structure.
+Therefore, a user
+.I must
+zero-fill the structure on initialization to keep compatibility with older
+kernels.
+.SS Linux v7.2
+The FS_XFLAG_CASEFOLD and FS_XFLAG_CASENONPRESERVING are introduced to enable
+upper layers, such as NFSD, to retrieve case sensitivity information.
+.SH SEE ALSO
+.BR file_getattr (2),
+.BR file_setattr (2)
-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C3C528425;
	Tue, 29 Sep 2026 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686994; cv=none; b=YkWgWWFHnRq8bFY6pDd9xSIOpsJ5CA8swOaw2LwbCs0RDtXe2IGtsxCGqpmuFUVOOibN6AVFWBv9m1GpXt3TmNiKSAqH7lmO33aZh0VK0MLqIsnn1g19JXQYYix2ZGtvSTXtVT/dSZv+NV+TSCbfiFGxY2pQVPXPEXF2wUk1asw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686994; c=relaxed/simple;
	bh=SWgR6cLd3TMMCzLvlRvkoP4TAgZfFpCMZJ2b75vLmDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn3WUvUomPF6AJuVqjMsY9fo7vJvrRXEYFH86k3XVtmWjBYHHAqpJaqBreluVzj3TIAV/WTYXRB/SMn1ENLDgMWHbS7ERi8GZMJeo9G23lZYeOW4/alS+zkK/rKRrqF3YTYQ8atrzu1/mFjyZLU3OzQMo+cVEief7U6Wa/5lmDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts4qQ3k4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts4qQ3k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4233A1F000FF;
	Tue, 29 Sep 2026 13:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790686993;
	bh=gnH/VFo22Z/bZEE+QdH6LtbrPt86V5OrSFl8q4GTPbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ts4qQ3k4FTMBr36SjUHjCj3AlmL749+EkdZGT1qhDkdunKRzF3VpHjfZtvFz1rs4S
	 J0jcAiE/CZ/K/xssvXKxfOVsunY2kwuf+0k8DibOzyGzq5rsYs98czZXtkT3oi2bm+
	 pXc94IOl1gWcBi+JZ0MaUMY5EnQsEpnmM4LUZ8KzLWUD0JDe+rdEdTKkjfrhJtyRjv
	 FL06f/z+Bv6RWaMWBv1LPumKLAjMdBWoHXrNP5HdkHx8ClwE3nnAJL15FR9BkHfdZp
	 Y0xBkbZ5IsRAwgWCA/ILSxpFNC69B7pdBUZo0yngBg/pPize3EkXJwndooaPC0awe0
	 pp6DH8GbZzCfQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	djwong@kernel.org
Subject: [PATCH v5 2/3] man/man2: introduce man page for file_getattr(2) syscall
Date: Tue, 29 Sep 2026 15:02:31 +0200
Message-ID: <20260929130234.3547891-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916115141.3500780-1-aalbersh@kernel.org>
References: <20260916115141.3500780-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add manual page for file_getattr().

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
---
 man/man2/file_getattr.2 | 262 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 262 insertions(+)
 create mode 100644 man/man2/file_getattr.2

diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
new file mode 100644
index 000000000000..e3c86fc45711
--- /dev/null
+++ b/man/man2/file_getattr.2
@@ -0,0 +1,262 @@
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
+of the file
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
+The size indicates the version of the structure in use,
+and should always be specified as
+.IR sizeof(struct file_attr) .
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
+instead,
+get attributes of the symbolic link inode itself.
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
+Unknown flags specified in
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
+does not exist.
+.TP
+.B ENOENT
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
+is not a directory.
+.TP
+.B ENOTDIR
+.I path
+is relative and
+.I dirfd
+is a file descriptor referring to a file other than a directory.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support getting attributes on this type of inode.
+.SH HISTORY
+Linux 6.17
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
+.\" SRC BEGIN (file_getattr.c)
+.EX
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+\&
+#ifndef SYS_file_getattr
+#define SYS_file_getattr 467
+#endif
+\&
+int
+main(int argc, char *argv[])
+{
+    struct file_attr fa;
+    long ret;
+\&
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+\&
+    ret = syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa,
+                  sizeof(fa), 0);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+\&
+    printf("File attributes:\[rs]n");
+    printf("  xflags:     0x%w64x\[rs]n", fa.fa_xflags);
+    printf("  extsize:    %w32u\[rs]n", fa.fa_extsize);
+    printf("  nextents:   %w32u\[rs]n", fa.fa_nextents);
+    printf("  projid:     %w32u\[rs]n", fa.fa_projid);
+    printf("  cowextsize: %w32u\[rs]n", fa.fa_cowextsize);
+\&
+    /*
+     * Try setting NODUMP flag with chattr +d ./foo to see
+     * the difference.
+     */
+    if (fa.fa_xflags & FS_XFLAG_NODUMP)
+        printf("  NODUMP flag is set\[rs]n");
+\&
+    exit(EXIT_SUCCESS);
+}
+.EE
+.\" SRC END
+.in
+.SH SEE ALSO
+.BR file_setattr (2),
+.BR file_attr (2type),
+.BR ioctl (2),
+.BR ioctl_fs (2),
+.BR openat (2),
+.BR ioctl_xfs_fssetxattr (2)
-- 
2.55.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591851;
	b=ievsPbAQoiPGHQrYqS1ddr4Ru8N8hQ9het+5H1m4tucbmLrB9cH+VJgqU/2P/hxsqJoI
	 yfLfO1BpMAp0xJhwdrb+uso8bBp6MxtNPilIGqpz0wAZC6JRGTbLXJaKGUeTZTcH+60W/
	 BoEGfoHAhI5t/IAxkiNauiyDE+LEfgfLPrxrDCEiBWwS0PPjA48qddfJSfzLnKUcliiLP
	 qHJQ//ikB56/AKk1uKFfP3yYxnGYCF9tQLjX1q0kqv+SwZjTPYzWhay3Zdn1eZdbiY3LX
	 OTghwPFt0ZT1yuvFaT0WFeu2qJMvPQyzqzyaoyg0TbpKKII47vo8M0Y1J1gvZXqPJOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MSABpqj1Ohy7ulNDCRgGEe/dwzVOLZgn3x/i5PrDtzk=;
	b=RfguaPNgrMW7qNnkaeRnJ9VCTu7cheik7gnArxm5kFgnGrsddLvluNtZAMdvLoT3gSbg
	 pbVEN8et/VNidFtYPtXdzuU5EvcLVddy3yVyI2PSxkZ1c9Rgq0LS3rWUX9x1F1HlSpsAf
	 AJQLlizxvgDyU28Ij4V+58+CwQVD5HpJV/HgTlg3Xg2FkPNSNAIlcp1GVbfn3p3ko12i7
	 Im4bKDHpM7WzxSA9o4LGtcGCsvlmVeOdUAD2A5gKZ6h517zLbke80onWzRu+9FWayflt0
	 kUDo+7jLvvyhqXblV1namMyxER6pHwFraOwkLv7nZtw62uzo3QbCRwzIV3Vf5Pd1UMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=isnTP4ZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C6F606A31B;
	Wed, 21 Oct 2026 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=isnTP4ZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06151F000C5;
	Wed, 21 Oct 2026 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792591850;
	bh=MSABpqj1Ohy7ulNDCRgGEe/dwzVOLZgn3x/i5PrDtzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isnTP4ZWCwcirc6tQ1FrMSB9yqT8ogrrTCdOqezD7xCzpSoqkO0+mSvFhGMtyVcG3
	 AIGWCxyuGu0YINIFQng1a6ssPUbZ3yYSA0G64cBTsCRYYNLt91bko0eTHf0EGy9r6L
	 IombRWYkHZfUPWmGlwC3fnKKmpVjffRZSnQeZIPigLHgH3QzDk1Qr26KE5Zq85s6iU
	 ZEqkwSX+TIPQqWMwq8pCo5FnSruN4oVjhS/7WWGev0TCRcWiXN9UYQiWd1qBpBLex3
	 rbrvSLMLFAR0dr0n7bn71cECmkWDv/CvfNduRAdy9n3bu31whtOUnFOO8N/JK6kVLQ
	 iS0Is7iVs+k4w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 1/2] man/man2: introduce man page for file_getattr(2) syscall
Date: Wed, 21 Oct 2026 16:10:04 +0200
Message-ID: <20261021141010.314835-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261021141010.314835-1-aalbersh@kernel.org>
References: <20261021141010.314835-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add manual page for file_getattr().

Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
Reviewed-by: Alejandro Colomar <alx@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 man/man2/file_getattr.2 | 252 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 252 insertions(+)
 create mode 100644 man/man2/file_getattr.2

diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
new file mode 100644
index 000000000000..9963eeaa7caf
--- /dev/null
+++ b/man/man2/file_getattr.2
@@ -0,0 +1,252 @@
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
+The
+.I dirfd
+and
+.I path
+arguments behave in the same way as in
+.BR openat (2),
+with the difference that
+.I path
+can be NULL meaning an empty string.
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
2.56.0


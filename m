Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42F3525A8C;
	Tue, 29 Sep 2026 13:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686996; cv=none; b=uG1gpRfKp6Vh+kep+w3PoU3w79KK3FdI+ww48848wxEYTy/ODz8+A/XQfQYoYR/xYHZKxItz/vbjNzoPHhR/aLNkH/4x8g7x2onereRVmd+Xr0j8cCqHmn3Z2RJTiF5n8XWteBqhWKrP7J8CQc+7LY3oKq2xC5ll/40hT5qC+44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686996; c=relaxed/simple;
	bh=oh9escWT2Ml6SMrHcKlnYWGnlyGHBRpaRkTdW44k0So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aC5ou0GD1afMYuutZUJmaNuNFFCHr6Yirdg3eaONFCvJWcQtrVkwfzseNvJ8smpxhnpLA0AGjC59EE1bO/cBlftlvHgOP1YNGBxiPS5rDP4m37MjNPeISFyJP9R84MFkWUHgA3jbCTIBJJreykj+1Aa9ljXEYdShxsTt1p3HJm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKeB3Kqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKeB3Kqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B11F00893;
	Tue, 29 Sep 2026 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790686995;
	bh=ax6pfWAI5PeWYzSSMLzWnxZ9aR7qY8aLr0uqVOIlNTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKeB3KqcCHnmbbQoi66DiEFHMwh+Nk3H7U2rN+2IxvofJxNO+xnpDnp2sGaV7zYO1
	 gJC1I3r+/pi6PHe56OvrC5Fa/I1wmtluKnhUCYSOmiejXnyszHcdeAw/CdlCWjX1BC
	 LKkErhWxrYDoZT698cMyAaP6I4+NcvbCCQGOUGRGP1v3sfnSCPVfl51/j4jacqaPnx
	 FHFaXiBu4UcsQDOzjuqikhA6X+FUtNZyfL08H+v9tEJwJ1bNyBgpkRmVcZhHOAkmlM
	 +dHXZoAG4DPEOlmCDZzkLYV6C3eewvawaVFljDFt+MF5ADT5bmKjYXN7Ghm3mkwhiW
	 JK9QrwHRoKrYA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	djwong@kernel.org
Subject: [PATCH v5 3/3] man/man2: introduce man page for file_setattr(2) syscall
Date: Tue, 29 Sep 2026 15:02:32 +0200
Message-ID: <20260929130234.3547891-4-aalbersh@kernel.org>
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

Add manual pages for file_setattr() syscall.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
---
 man/man2/file_setattr.2 | 183 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)
 create mode 100644 man/man2/file_setattr.2

diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
new file mode 100644
index 000000000000..b11c9ff9277f
--- /dev/null
+++ b/man/man2/file_setattr.2
@@ -0,0 +1,183 @@
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
+.BI "               const struct file_attr *" fattr ", size_t " size ,
+.BI "               unsigned int " flags );
+.fi
+.SH DESCRIPTION
+The
+.BR file_setattr ()
+system call sets filesystem file attributes
+on the file specified by path.
+.P
+The
+.IR dirfd ,
+.IR path ,
+.IR size ,
+and
+.I flags
+arguments behave in the same way as in
+.BR file_getattr (2).
+The
+.IR fattr ,
+is read-only argument with
+file attributes to set.
+User-space applications should use
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
+.\" SRC BEGIN (file_setattr.c)
+.EX
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <linux/fs.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+\&
+#ifndef SYS_file_getattr
+#define SYS_file_getattr 467
+#endif
+\&
+#ifndef SYS_file_setattr
+#define SYS_file_setattr 468
+#endif
+\&
+int
+main(int argc, char *argv[])
+{
+    struct file_attr fa;
+    int dfd;
+    long ret;
+\&
+    if (argc != 2) {
+        fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
+        exit(EXIT_FAILURE);
+    }
+\&
+    dfd = open(argv[1], O_RDONLY);
+    if (dfd == \-1) {
+        perror("open");
+        exit(EXIT_FAILURE);
+    }
+\&
+    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa),
+                  AT_EMPTY_PATH);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+\&
+    printf("Current flags: 0x%w64x\[rs]n", fa.fa_xflags);
+\&
+    fa.fa_xflags |= FS_XFLAG_NODUMP;
+\&
+    ret = syscall(SYS_file_setattr, dfd, "", &fa, sizeof(fa),
+                  AT_EMPTY_PATH);
+    if (ret == \-1) {
+        perror("file_setattr");
+        exit(EXIT_FAILURE);
+    }
+\&
+    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa),
+                  AT_EMPTY_PATH);
+    if (ret == \-1) {
+        perror("file_getattr");
+        exit(EXIT_FAILURE);
+    }
+\&
+    if (fa.fa_xflags & FS_XFLAG_NODUMP)
+        printf("flags 0x%w64x (NODUMP flag is set)\[rs]n", fa.fa_xflags);
+\&
+    exit(EXIT_SUCCESS);
+}
+.EE
+.\" SRC END
+.in
+.SH SEE ALSO
+.BR file_getattr (2),
+.BR ioctl (2),
+.BR ioctl_fs (2),
+.BR openat (2),
+.BR file_attr (2type),
+.BR path_resolution (7),
+.BR ioctl_xfs_fssetxattr (2)
-- 
2.55.0


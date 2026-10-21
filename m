Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591853;
	b=je+gdg7fq56Tmi2og0AbQvS5cJ6NaRTEHaNkd2NSmYpEkpjyiJAqXVHPDudPnkXpXph9
	 oLAheU0OMl43yk9CyTGHLkpulU4xQwsBRC6LMWDote/8pMyj475yV7EjP1O9fS3+vtiWh
	 fpcReF/DOZLCBRj023iTaSwX0rTG1Eln6nHC0oba8WxjywtJAZjdQ5C6uZoiTwg5oUUh1
	 ibNXPcZBhj1nrc6XEMvS0lB2J6Mjyl7yp182AnqMIhkSaeXdaG8O8yzw6h7UWq7JEnAeJ
	 P6IgkHURlYvKpJpZb3DQKFltm5LjL5XZjNGRzN/dyh28ivjDqUAAKFOJYU+UvPm0oWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TDeC0eRTKreZTLMWvR9LY3kDP8b0X3HPPOmaydNAyfU=;
	b=mzMLitOVlKbK2Eya2Iii+oW1xi6DYVz/P1pisE9gHj8QzAno2Y4dX15/02Lx/c4gQvMR
	 jbB2RWlq8nxQtwfV85iXaucxdqNZTr2xpltE4CWGuefMDOZQUU1G+TRSepirzNG/6FQBx
	 HyD4dB5KatpcjkZ6sbWMXZKXHFr/5ruT45dG3Vhg0SdwCAzDNZHGrlmCgAFpKsggGvq3S
	 9qXwjvu3w9jW8X55XvBgUpkoey1jHCspS++4bvPujGMYfXramGqZPVb2zswB83dralhQT
	 3HEdWaBL3dnxNm9dlcby8tk6P78OHBsuTZJfKydgV2hO0S/+vPmoW32KV4gbFz55EUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGGjoLCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0137606A320;
	Wed, 21 Oct 2026 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGGjoLCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E291F000C6;
	Wed, 21 Oct 2026 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792591852;
	bh=TDeC0eRTKreZTLMWvR9LY3kDP8b0X3HPPOmaydNAyfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGGjoLCqxKuMsS/CGe/ZkckiZkmeRx2QWJ+9BxwGtX07YWzmpAt4TB2hXTfIdZ74p
	 kj1Jqug1jSEjlP8kuZPTcxcDPv9MxKqoE0G92h35yBOln09XL5UiHMqNoEqK8gbVGN
	 AXEMmJ3aqnR+zlO34Z3o8O10WHQvGAnM1y0E4LVMAdfWO+JsB1V5IY9Ln+l9c3gdFL
	 1FQqs7vKXnwafKGqg8ZHsGxiGYaJoVprWl55qLg9GcubwSDLX4QfNyBvaAB+nk/xtS
	 nZZDAoaa/JceE4xCNdjZ0WmnD3L8nmKLcL3uCKDP7Tc8hs/MENIo63/SwtbaZ9cms2
	 2ZZ8z31FohmbQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 2/2] man/man2: introduce man page for file_setattr(2) syscall
Date: Wed, 21 Oct 2026 16:10:05 +0200
Message-ID: <20261021141010.314835-3-aalbersh@kernel.org>
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

Add manual pages for file_setattr() syscall.

Link: https://lore.kernel.org/all/20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org/
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
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
2.56.0


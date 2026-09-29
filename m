Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A909526A85;
	Tue, 29 Sep 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686990; cv=none; b=JKZp+PkVNxEWexLcsWq0BKRZgYt/x9XQ7/8VzR1w7NXcHaZTuPWh8X9DOFXZeL9t8IU/xKpo20RC125EY4VwQMoNZhg8X7hsx52WaMQ0oQU7f6U+Iv9UQRhNFUZFff5x5X7REQBT8j5IxLnnNyCfQxgqsWgsHiRBqaXYzwm+AB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686990; c=relaxed/simple;
	bh=1noLLYLgKsdPkSgbQ5oEqG5u0IxgtUmUTgvsc8jMzCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKsqMkRrpgMtTAKsW35FoBHuMzfKsXyZ/OpxgqyLDIfDn/jJrJTuxrbqujnKZqN+nnbV67wfSiNAUDtpe0/7/4FSHmP1JAasDyWFocU6s8NhQBFFW8iMTh337FJcooPgtZsoR5VpyMQdLAbcilWrhZKwAygZpodblLPR4yec8PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ixb6LEeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixb6LEeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607D91F000FF;
	Tue, 29 Sep 2026 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790686988;
	bh=0eGshAiCx2DPMmKieMEBhmMv9saVqllOoc3nNCljZds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixb6LEeCZPBzyq7LYBkKNz8UxXG0UaP/vH2YVKFwgfeWsFQIawCYX8xVOgFpX9kZr
	 kfsGH/ISQJMGHefk5rvVDEeRst2FW6hRIpSzbrb+HDroEyPw3TV85y+6WE8G2M8Y0k
	 iFaQOgDuFOZGJ2KUlMoIgyqA+55TRmMwXYED1AyiPVHxjBV9RemnM9rhYH6kThe1Eu
	 byswwiM5mfafU9E7vaPE/j/FBjdIuBJw9xAxvKVhz2k+fJ/wIyzgsOLQTJV+0VBrKi
	 IEXRTRFDeX1YVQHOc2oALY4ldHniYC/e5rDW0m+apup69Dcbs/ku+KDmNRy0WLEzeM
	 KYYsu3pA7J+WA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-api@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	djwong@kernel.org
Subject: [PATCH v5 0/3] Introduce man pages for file_getattr() and file_setattr()
Date: Tue, 29 Sep 2026 15:02:29 +0200
Message-ID: <20260929130234.3547891-1-aalbersh@kernel.org>
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

Hi folks,

This series introduce 3 man pages for file_getattr() and file_setattr()
syscalls and struct file_attr used as an argument for these syscalls.

Changes from v4:
- Split single patch into 3 separate ones
- Mark examples for linters
- Use special char for empty lines in examples
- Use w64/w32 in printf() in examples
- Use const fattr in file_setattr() definition
- Other minor fixes
- A few fixes found by lint in examples

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

Andrey Albershteyn (3):
  man/man2: introduce man page for struct file_attr
  man/man2: introduce man page for file_getattr(2) syscall
  man/man2: introduce man page for file_setattr(2) syscall

 man/man2/file_getattr.2      | 262 +++++++++++++++++++++++++++++++++++
 man/man2/file_setattr.2      | 183 ++++++++++++++++++++++++
 man/man2type/file_attr.2type | 153 ++++++++++++++++++++
 3 files changed, 598 insertions(+)
 create mode 100644 man/man2/file_getattr.2
 create mode 100644 man/man2/file_setattr.2
 create mode 100644 man/man2type/file_attr.2type

Interdiff against v4:
diff --git a/man/man2/file_getattr.2 b/man/man2/file_getattr.2
index fe804d97976b..e3c86fc45711 100644
--- a/man/man2/file_getattr.2
+++ b/man/man2/file_getattr.2
@@ -21,6 +21,7 @@ file_getattr \- get filesystem file attributes
 The
 .BR file_getattr ()
 system call retrieves filesystem file attributes
+of the file
 specified by path.
 .P
 As with
@@ -56,9 +57,9 @@ The
 .I size
 argument specifies the size of the structure pointed to by
 .IR fattr .
-The size indicates version of the structure in use, refer to
-.B file_attr (2type)
-for more information on versioning.
+The size indicates the version of the structure in use,
+and should always be specified as
+.IR sizeof(struct file_attr) .
 .P
 The
 .I flags
@@ -80,8 +81,8 @@ If
 .I path
 is a symbolic link,
 do not dereference it;
-instead get attributes of the symbolic link inode itself.
-By default, symbolic links are dereferenced.
+instead,
+get attributes of the symbolic link inode itself.
 .SH RETURN VALUE
 On success,
 zero is returned.
@@ -128,7 +129,7 @@ or
 is an invalid pointer.
 .TP
 .B EINVAL
-Unknown flag specified in
+Unknown flags specified in
 .IR flags .
 .TP
 .B EINVAL
@@ -147,8 +148,9 @@ is too long.
 .B ENOENT
 A component of
 .I path
-does not exist,
-or
+does not exist.
+.TP
+.B ENOENT
 .I path
 is an empty string and
 .B AT_EMPTY_PATH
@@ -161,7 +163,9 @@ Insufficient kernel memory was available.
 .B ENOTDIR
 A component of the path prefix of
 .I path
-is not a directory, or
+is not a directory.
+.TP
+.B ENOTDIR
 .I path
 is relative and
 .I dirfd
@@ -170,8 +174,7 @@ is a file descriptor referring to a file other than a directory.
 .B EOPNOTSUPP
 The filesystem does not support getting attributes on this type of inode.
 .SH HISTORY
-.SS Linux 6.17
-This system call is introduced.
+Linux 6.17
 .SH NOTES
 This system call is designed to be extensible.
 The
@@ -199,51 +202,56 @@ The program below demonstrates the use of
 to retrieve and display file attributes.
 .P
 .in +4n
+.\" SRC BEGIN (file_getattr.c)
 .EX
+#define _GNU_SOURCE
 #include <fcntl.h>
 #include <linux/fs.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/syscall.h>
 #include <unistd.h>
-
+\&
 #ifndef SYS_file_getattr
 #define SYS_file_getattr 467
 #endif
-
+\&
 int
 main(int argc, char *argv[])
 {
     struct file_attr fa;
     long ret;
-
+\&
     if (argc != 2) {
         fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
         exit(EXIT_FAILURE);
     }
-
-    ret = syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa, sizeof(fa), 0);
+\&
+    ret = syscall(SYS_file_getattr, AT_FDCWD, argv[1], &fa,
+                  sizeof(fa), 0);
     if (ret == \-1) {
         perror("file_getattr");
         exit(EXIT_FAILURE);
     }
-
+\&
     printf("File attributes:\[rs]n");
-    printf("  xflags:     0x%llx\[rs]n", (unsigned long long) fa.fa_xflags);
-    printf("  extsize:    %u\[rs]n", fa.fa_extsize);
-    printf("  nextents:   %u\[rs]n", fa.fa_nextents);
-    printf("  projid:     %u\[rs]n", fa.fa_projid);
-    printf("  cowextsize: %u\[rs]n", fa.fa_cowextsize);
-
+    printf("  xflags:     0x%w64x\[rs]n", fa.fa_xflags);
+    printf("  extsize:    %w32u\[rs]n", fa.fa_extsize);
+    printf("  nextents:   %w32u\[rs]n", fa.fa_nextents);
+    printf("  projid:     %w32u\[rs]n", fa.fa_projid);
+    printf("  cowextsize: %w32u\[rs]n", fa.fa_cowextsize);
+\&
     /*
-     * Try setting NODUMP flag with chattr +d ./foo to see the difference
+     * Try setting NODUMP flag with chattr +d ./foo to see
+     * the difference.
      */
     if (fa.fa_xflags & FS_XFLAG_NODUMP)
         printf("  NODUMP flag is set\[rs]n");
-
+\&
     exit(EXIT_SUCCESS);
 }
 .EE
+.\" SRC END
 .in
 .SH SEE ALSO
 .BR file_setattr (2),
diff --git a/man/man2/file_setattr.2 b/man/man2/file_setattr.2
index 0389f42afb50..b11c9ff9277f 100644
--- a/man/man2/file_setattr.2
+++ b/man/man2/file_setattr.2
@@ -14,10 +14,9 @@ file_setattr \- set filesystem file attributes
 .P
 .B long syscall(SYS_file_setattr,
 .BI "               int " dirfd ", const char *" path ,
-.BI "               struct file_attr *" fattr ", size_t " size ,
+.BI "               const struct file_attr *" fattr ", size_t " size ,
 .BI "               unsigned int " flags );
 .fi
-.P
 .SH DESCRIPTION
 The
 .BR file_setattr ()
@@ -27,14 +26,16 @@ on the file specified by path.
 The
 .IR dirfd ,
 .IR path ,
-.IR fattr ,
 .IR size ,
 and
 .I flags
-arguments behaves in the same way as in
+arguments behave in the same way as in
 .BR file_getattr (2).
-The only difference is that
-user-space applications should use
+The
+.IR fattr ,
+is read-only argument with
+file attributes to set.
+User-space applications should use
 .BR file_getattr (2)
 to initialize
 .I fattr
@@ -48,7 +49,6 @@ and
 .I errno
 is set to indicate the error.
 .SH ERRORS
-.P
 The errors are the same as returned by
 .BR file_getattr (2)
 with the addition of following ones:
@@ -71,8 +71,7 @@ to change the file attributes.
 .B EROFS
 The file is on a read-only filesystem.
 .SH HISTORY
-.SS Linux 6.17
-This system call is introduced.
+Linux 6.17
 .SH NOTES
 This system call is designed to be extensible.
 The
@@ -104,71 +103,75 @@ to set the
 flag on a file.
 .P
 .in +4n
+.\" SRC BEGIN (file_setattr.c)
 .EX
+#define _GNU_SOURCE
 #include <fcntl.h>
-#include <linux/fcntl.h>
 #include <linux/fs.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <sys/syscall.h>
 #include <unistd.h>
-
+\&
 #ifndef SYS_file_getattr
 #define SYS_file_getattr 467
 #endif
-
+\&
 #ifndef SYS_file_setattr
 #define SYS_file_setattr 468
 #endif
-
+\&
 int
 main(int argc, char *argv[])
 {
     struct file_attr fa;
     int dfd;
     long ret;
-
+\&
     if (argc != 2) {
         fprintf(stderr, "Usage: %s <filename>\[rs]n", argv[0]);
         exit(EXIT_FAILURE);
     }
-
+\&
     dfd = open(argv[1], O_RDONLY);
     if (dfd == \-1) {
         perror("open");
         exit(EXIT_FAILURE);
     }
-
-    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa), AT_EMPTY_PATH);
+\&
+    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa),
+                  AT_EMPTY_PATH);
     if (ret == \-1) {
         perror("file_getattr");
         exit(EXIT_FAILURE);
     }
-
-    printf("Current flags: 0x%llx\[rs]n", (unsigned long long) fa.fa_xflags);
-
+\&
+    printf("Current flags: 0x%w64x\[rs]n", fa.fa_xflags);
+\&
     fa.fa_xflags |= FS_XFLAG_NODUMP;
-
-    ret = syscall(SYS_file_setattr, dfd, "", &fa, sizeof(fa), AT_EMPTY_PATH);
+\&
+    ret = syscall(SYS_file_setattr, dfd, "", &fa, sizeof(fa),
+                  AT_EMPTY_PATH);
     if (ret == \-1) {
         perror("file_setattr");
         exit(EXIT_FAILURE);
     }
-
-    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa), AT_EMPTY_PATH);
+\&
+    ret = syscall(SYS_file_getattr, dfd, "", &fa, sizeof(fa),
+                  AT_EMPTY_PATH);
     if (ret == \-1) {
         perror("file_getattr");
         exit(EXIT_FAILURE);
     }
-
+\&
     if (fa.fa_xflags & FS_XFLAG_NODUMP)
-        printf("flags 0x%llx (NODUMP flag is set)\[rs]n",
-            (unsigned long long) fa.fa_xflags);
-
+        printf("flags 0x%w64x (NODUMP flag is set)\[rs]n", fa.fa_xflags);
+\&
     exit(EXIT_SUCCESS);
 }
 .EE
+.\" SRC END
 .in
 .SH SEE ALSO
 .BR file_getattr (2),
diff --git a/man/man2type/file_attr.2type b/man/man2type/file_attr.2type
index 221d97b5220d..3a1aabbc9e7d 100644
--- a/man/man2type/file_attr.2type
+++ b/man/man2type/file_attr.2type
@@ -50,7 +50,9 @@ and is ignored by
 .TP
 .I fa_projid
 Project identifier.
-Used by quota systems to group related files.
+Used by quota systems
+.BR quotactl (2)
+to group related files.
 .TP
 .I fa_cowextsize
 Copy-on-Write (CoW) extent size hint in bytes.
-- 
2.55.0


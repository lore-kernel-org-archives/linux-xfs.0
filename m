Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:23697
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726001AbeLCIj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 03:39:59 -0500
Date: Mon, 3 Dec 2018 19:39:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/11] man-pages: copy_file_range updates
Message-ID: <20181203083952.GC6311@dastard>
References: <20181203083416.28978-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203083416.28978-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Update with all the missing errors the syscall can return, the
behaviour the syscall should have w.r.t. to copies within single
files, etc.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 man2/copy_file_range.2 | 94 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 77 insertions(+), 17 deletions(-)

diff --git a/man2/copy_file_range.2 b/man2/copy_file_range.2
index 20374abb21f0..23b00c2f3fea 100644
--- a/man2/copy_file_range.2
+++ b/man2/copy_file_range.2
@@ -42,9 +42,9 @@ without the additional cost of transferring data from the kernel to user space
 and then back into the kernel.
 It copies up to
 .I len
-bytes of data from file descriptor
+bytes of data from the source file descriptor
 .I fd_in
-to file descriptor
+to target file descriptor
 .IR fd_out ,
 overwriting any data that exists within the requested range of the target file.
 .PP
@@ -74,6 +74,11 @@ is not changed, but
 .I off_in
 is adjusted appropriately.
 .PP
+.I fd_in
+and
+.I fd_out
+can refer to the same file. If they refer to the same file, then the source and
+target ranges are not allowed to overlap.
 .PP
 The
 .I flags
@@ -93,34 +98,73 @@ is set to indicate the error.
 .SH ERRORS
 .TP
 .B EBADF
-One or more file descriptors are not valid; or
+One or more file descriptors are not valid.
+.TP
+.B EBADF
 .I fd_in
 is not open for reading; or
 .I fd_out
-is not open for writing; or
-the
+is not open for writing.
+.TP
+.B EBADF
+The
 .B O_APPEND
 flag is set for the open file description referred to by
 .IR fd_out .
 .TP
 .B EFBIG
-An attempt was made to write a file that exceeds the implementation-defined
-maximum file size or the process's file size limit,
-or to write at a position past the maximum allowed offset.
+An attempt was made to write at a position past the maximum file offset the
+kernel supports.
+.TP
+.B EFBIG
+An attempt was made to write a range that exceeds the allowed maximum file size.
+The maximum file size differs between filesystem implemenations and can be
+different to the maximum allowed file offset.
+.TP
+.B EFBIG
+An attempt was made to write beyond the process's file size resource
+limit. This may also result in the process receiving a
+.I SIGXFSZ
+signal.
 .TP
 .B EINVAL
-Requested range extends beyond the end of the source file; or the
-.I flags
-argument is not 0.
+.I (off_in + len)
+spans the end of the source file.
 .TP
-.B EIO
-A low-level I/O error occurred while copying.
+.B EINVAL
+.I fd_in
+and
+.I fd_out
+refer to the same file and the source and target ranges overlap.
+.TP
+.B EINVAL
+.I fd_in
+or
+.I fd_out
+is not a regular file.
 .TP
 .B EISDIR
 .I fd_in
 or
 .I fd_out
 refers to a directory.
+.B EINVAL
+The
+.I flags
+argument is not 0.
+.TP
+.B EINVAL
+.I off_in
+or
+.I (off_in + len)
+is beyond the maximum valid file offset.
+.TP
+.B EOVERFLOW
+The requested source or destination range is too large to represent in the
+specified data types.
+.TP
+.B EIO
+A low-level I/O error occurred while copying.
 .TP
 .B ENOMEM
 Out of memory.
@@ -128,16 +172,32 @@ Out of memory.
 .B ENOSPC
 There is not enough space on the target filesystem to complete the copy.
 .TP
-.B EXDEV
-The files referred to by
-.IR file_in " and " file_out
-are not on the same mounted filesystem.
+.B TXTBSY
+.I fd_in
+or
+.I fd_out
+refers to an active swap file.
+.TP
+.B EPERM
+.I fd_out
+refers to an immutable file.
+.TP
+.B EACCES
+The user does not have write permissions for the destination file.
 .SH VERSIONS
 The
 .BR copy_file_range ()
 system call first appeared in Linux 4.5, but glibc 2.27 provides a user-space
 emulation when it is not available.
 .\" https://sourceware.org/git/?p=glibc.git;a=commit;f=posix/unistd.h;h=bad7a0c81f501fbbcc79af9eaa4b8254441c4a1f
+.PP
+A major rework of the kernel implementation occurred in 4.21. Areas of the API
+that weren't clearly defined were clarified and the API bounds are much more
+strictly checked than on earlier kernels. Applications should target the
+behaviour and requirements of 4.21 kernels.
+.PP
+First support for cross-filesystem copies was introduced in Linux 4.21. Older
+kernels will return -EXDEV when cross-filesystem copies are attempted.
 .SH CONFORMING TO
 The
 .BR copy_file_range ()

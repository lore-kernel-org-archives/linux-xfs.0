Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43010 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfEZGLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 02:11:31 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 9/8] man-pages: copy_file_range updates
Date: Sun, 26 May 2019 09:11:00 +0300
Message-Id: <20190526061100.21761-10-amir73il@gmail.com>
In-Reply-To: <20190526061100.21761-1-amir73il@gmail.com>
References: <20190526061100.21761-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

Update with all the missing errors the syscall can return, the
behaviour the syscall should have w.r.t. to copies within single
files, etc.

[Amir] Copying beyond EOF returns zero.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 man2/copy_file_range.2 | 93 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 16 deletions(-)

diff --git a/man2/copy_file_range.2 b/man2/copy_file_range.2
index 2438b63c8..fab11f977 100644
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
@@ -84,6 +89,11 @@ Upon successful completion,
 .BR copy_file_range ()
 will return the number of bytes copied between files.
 This could be less than the length originally requested.
+If the file offset of
+.I fd_in
+is at or past the end of file, no bytes are copied, and
+.BR copy_file_range ()
+returns zero.
 .PP
 On error,
 .BR copy_file_range ()
@@ -93,12 +103,16 @@ is set to indicate the error.
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
 flag is set for the open file description (see
 .BR open (2))
@@ -106,17 +120,36 @@ referred to by the file descriptor
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
+The
 .I flags
 argument is not 0.
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
@@ -124,22 +157,50 @@ or
 .I fd_out
 refers to a directory.
 .TP
+.B EOVERFLOW
+The requested source or destination range is too large to represent in the
+specified data types.
+.TP
+.B EIO
+A low-level I/O error occurred while copying.
+.TP
 .B ENOMEM
 Out of memory.
 .TP
-.B ENOSPC
-There is not enough space on the target filesystem to complete the copy.
-.TP
 .B EXDEV
 The files referred to by
 .IR file_in " and " file_out
-are not on the same mounted filesystem.
+are not on the same mounted filesystem (pre Linux 5.3).
+.TP
+.B ENOSPC
+There is not enough space on the target filesystem to complete the copy.
+.TP
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
+A major rework of the kernel implementation occurred in 5.3. Areas of the API
+that weren't clearly defined were clarified and the API bounds are much more
+strictly checked than on earlier kernels. Applications should target the
+behaviour and requirements of 5.3 kernels.
+.PP
+First support for cross-filesystem copies was introduced in Linux 5.3. Older
+kernels will return -EXDEV when cross-filesystem copies are attempted.
 .SH CONFORMING TO
 The
 .BR copy_file_range ()
@@ -224,7 +285,7 @@ main(int argc, char **argv)
         }
 
         len \-= ret;
-    } while (len > 0);
+    } while (len > 0 && ret > 0);
 
     close(fd_in);
     close(fd_out);
-- 
2.17.1

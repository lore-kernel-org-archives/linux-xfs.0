Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7249529E13
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 09:49:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 35E3A304043
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:49:56 -0800 (PST)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id 19lVExagBTDeCxgF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:49:54 -0800 (PST)
Received: by pablf10 with SMTP id lf10so15759558pab.6
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:49:54 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v10 12/12] manpage: update FALLOC_FL_INSERT_RANGE flag in
	fallocate
Date: Sun, 22 Feb 2015 00:45:54 +0900
Message-Id: <1424533554-28024-13-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-man@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update FALLOC_FL_INSERT_RANGE flag in fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 man2/fallocate.2 |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 6 deletions(-)

diff --git a/man2/fallocate.2 b/man2/fallocate.2
index adf42db..9b3c460 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -8,7 +8,7 @@
 .\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
 .\" 2011-09-19: Substantial restructuring of the page
 .\"
-.TH FALLOCATE 2 2015-01-22 "Linux" "Linux Programmer's Manual"
+.TH FALLOCATE 2 2015-02-14 "Linux" "Linux Programmer's Manual"
 .SH NAME
 fallocate \- manipulate file space
 .SH SYNOPSIS
@@ -225,6 +225,56 @@ XFS (since Linux 3.14)
 .IP *
 ext4, for extent-based files (since Linux 3.14)
 .\" commit b8a8684502a0fc852afa0056c6bb2a9273f6fcc0
+.SS Increasing file space
+.\" TODO: Mention commit id and supporting Linux version
+Specifying the
+.BR FALLOC_FL_INSERT_RANGE
+flag in
+.I mode
+will increase the file space by inserting a hole within the file size without
+overwriting any existing data. The hole will start at
+.I offset
+and continue for
+.I len
+bytes. For inserting hole inside file, the contents of the file starting at
+.I offset
+will be shifted towards right by
+.I len
+bytes. Inserting a hole inside the file will increase the file size by
+.I len
+bytes.
+
+This mode has the same limitation as
+.BR FALLOC_FL_COLLAPSE_RANGE
+regarding the
+granularity of the operation.
+If the granulrity requirements are not met,
+.BR fallocate ()
+will fail with the error
+.BR EINVAL.
+If the
+.I offset
+overlaps with end of file OR if it is greater than end of file, an error is
+returned. For such type of operations, i.e. inserting a hole at the end of
+file,
+.BR ftruncate(2)
+should be used.
+In case
+.IR offset + len
+exceeds the maximum file size, errno will be set to
+.B EFBIG.
+
+No other flags may be specified in
+.IR mode
+in conjunction with
+.BR FALLOC_FL_INSERT_RANGE .
+
+As of Linux XXXX,
+.\" TODO: Mention commit id and supporting Linux version
+.B FALLOC_FL_INSERT_RANGE
+is supported by
+ext4 (only for extent-based files) and XFS.
+
 .SH RETURN VALUE
 On success,
 .BR fallocate ()
@@ -242,6 +292,12 @@ is not a valid file descriptor, or is not opened for writing.
 .IR offset + len
 exceeds the maximum file size.
 .TP
+.B EFBIG
+.I mode
+is
+.BR FALLOC_FL_INSERT_RANGE ,
+the current file size+len excceds the maximum file size.
+.TP
 .B EINTR
 A signal was caught during execution.
 .TP
@@ -270,7 +326,17 @@ reaches or passes the end of the file.
 .B EINVAL
 .I mode
 is
-.BR FALLOC_FL_COLLAPSE_RANGE ,
+.BR FALLOC_FL_INSERT_RANGE
+and the range specified by
+.I offset
+reaches or passes the end of the file.
+.TP
+.B EINVAL
+.I mode
+is
+.BR FALLOC_FL_COLLAPSE_RANGE
+or
+.BR FALLOC_FL_INSERT_RANGE ,
 but either
 .I offset
 or
@@ -279,18 +345,24 @@ is not a multiple of the filesystem block size.
 .TP
 .B EINVAL
 .I mode
-contains both
+contains either of
 .B FALLOC_FL_COLLAPSE_RANGE
+or
+.B FALLOC_FL_INSERT_RANGE
 and other flags;
 no other flags are permitted with
-.BR FALLOC_FL_COLLAPSE_RANGE .
+.BR FALLOC_FL_COLLAPSE_RANGE
+or
+.BR FALLOC_FL_INSERT_RANGE .
 .TP
 .B EINVAL
 .I mode
 is
 .BR FALLOC_FL_COLLAPSE_RANGE
 or
-.BR FALLOC_FL_ZERO_RANGE ,
+.BR FALLOC_FL_ZERO_RANGE
+or
+.BR FALLOC_FL_INSERT_RANGE ,
 but the file referred to by
 .I fd
 is not a regular file.
@@ -342,6 +414,8 @@ specifies
 .BR FALLOC_FL_PUNCH_HOLE
 or
 .BR FALLOC_FL_COLLAPSE_RANGE
+or
+.BR FALLOC_FL_INSERT_RANGE
 and
 the file referred to by
 .I fd
@@ -360,7 +434,9 @@ refers to a pipe or FIFO.
 .B ETXTBSY
 .I mode
 specifies
-.BR FALLOC_FL_COLLAPSE_RANGE ,
+.BR FALLOC_FL_COLLAPSE_RANGE
+or
+.BR FALLOC_FL_INSERT_RANGE ,
 but the file referred to by
 .IR fd
 is currently being executed.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

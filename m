Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8KqnLC055196 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 14:52:49 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jywBHLEttuSD7bvc for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 12:55:15 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 2DB6763C3E3F
	for <xfs@oss.sgi.com>; Sat,  8 Dec 2012 14:55:15 -0600 (CST)
Message-ID: <50C3A936.1050805@sandeen.net>
Date: Sat, 08 Dec 2012 14:55:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs: document all commands in xfs_io
References: <50C39123.6050303@sandeen.net>
In-Reply-To: <50C39123.6050303@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Add missing command documentation to xfs_io(8) manpage.
fiemap, fpunch, chproj, lsproj, and setfl are all missing.

setfl seems to not work today in any case, and nothing
in xfstests uses it; I will send another patch to simply
remove it from xfs_io, as I don't think it's terribly useful,
and hasn't worked forever anyway.

Also fix references to the fallocate manpage, which is (now?)
in section 2, not section 3 of the man pages.  (Since it's
a syscall, not a library function).

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f7c6935..33a5944 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -245,6 +245,12 @@ Prints the block mapping for the current open file. Refer to the
 .BR xfs_bmap (8)
 manual page for complete documentation.
 .TP
+.BI "fiemap [ \-alv ] [ \-n " nx " ]"
+Prints the block mapping for the current open file using the fiemap
+ioctl.  Options behave as described in the
+.BR xfs_bmap (8)
+manual page.
+.TP
 .BI "extsize [ \-R | \-D ] [ " value " ]"
 Display and/or modify the preferred extent size used when allocating
 space for the currently open file. If the
@@ -355,17 +361,23 @@ manual page.
 .BI "falloc [ \-k ]" " offset length"
 Allocates reserved, unwritten space for part of a file using the
 fallocate routine as described in the
-.BR fallocate (3)
+.BR fallocate (2)
 manual page.
 .RS 1.0i
 .PD 0
 .TP 0.4i
 .B \-k
 will set the FALLOC_FL_KEEP_SIZE flag as described in
-.BR fallocate (3).
+.BR fallocate (2).
 .PD
 .RE
 .TP
+.BI fpunch " offset length"
+Punches (de-allocates) blocks in the file by calling fallocate with 
+the FALLOC_FL_PUNCH_HOLE flag as described in the
+.BR fallocate (2)
+manual page.
+.TP
 .BI truncate " offset"
 Truncates the current file at the given offset using
 .BR ftruncate (2).
@@ -575,6 +587,24 @@ Selected statistics from
 and the XFS_IOC_FSGEOMETRY
 system call on the filesystem where the current file resides.
 .TP
+.BR chproj " [ " \-R | \-D " ]"
+Modifies the project identifier associated with the current path. The 
+.B \-R
+option will recursively descend if the current path is a directory. The 
+.B \-D
+option will also recursively descend, only setting modifying projects 
+on subdirectories.  See the
+.BR xfs_quota (8)
+manual page for more information about project identifiers.
+.TP
+.BR lsproj " [ " \-R | \-D " ]"
+Displays the project identifier associated with the current path. The 
+.B \-R
+and
+.B \-D
+options behave as described above, in
+.B chproj.
+.TP
 .BR parent " [ " \-cpv " ]"
 By default this command prints out the parent inode numbers,
 inode generation numbers and basenames of all the hardlinks which

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

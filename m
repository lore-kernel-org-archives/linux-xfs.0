Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8JA6Vk050503 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 13:10:06 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lZYgRTJfexUZFFQ3 for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 11:12:32 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6F6E163C3E3F
	for <xfs@oss.sgi.com>; Sat,  8 Dec 2012 13:12:32 -0600 (CST)
Message-ID: <50C39123.6050303@sandeen.net>
Date: Sat, 08 Dec 2012 13:12:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: document fpunch command in xfs_io
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

Add manpage documentation for the new fpunch command in xfs_io.

Also fix references to the fallocate manpage, which is (now?)
in section 2, not section 3 of the man pages.  (Since it's
a syscall, not a library function).

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index f7c6935..9b9ece8 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -355,17 +355,23 @@ manual page.
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC3707F37
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 15:58:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3A80304048
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 13:58:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DOmyegnFsRbE2iHf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 13:58:12 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 3AF558F270
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 21:58:10 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tB4Lw83J019204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 4 Dec 2015 16:58:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: document zero and help commands in manpage
Message-ID: <56620C70.7030707@redhat.com>
Date: Fri, 4 Dec 2015 15:58:08 -0600
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

zero & fzero are 2 different commands using 2 different interfaces
to do the same thing, but may as well document them both.

Also explicitly document "help" to be consistent, and to satisfy
the xfstest which checks for all commands being documented.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 7fd7478..33fbe6a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -420,6 +420,13 @@ Call fallocate with FALLOC_FL_ZERO_RANGE flag as described in the
 .BR fallocate (2)
 manual page to allocate and zero blocks within the range.
 .TP
+.BI zero " offset length"
+Call xfsctl with
+.B XFS_IOC_ZERO_RANGE
+as described in the
+.BR xfsctl (3)
+manual page to allocate and zero blocks within the range.
+.TP
 .BI truncate " offset"
 Truncates the current file at the given offset using
 .BR ftruncate (2).
@@ -681,6 +688,9 @@ for the current memory mapping.
 
 .SH OTHER COMMANDS
 .TP
+.BR "help [ " command " ]"
+Display a brief description of one or all commands.
+.TP
 .B print
 Display a list of all open files and memory mapped regions.
 The current file and current mapping are distinguishable from


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

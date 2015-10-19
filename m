Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47CE07F54
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 09:15:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0C25AC004
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 07:15:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sf4tXVM8jQBzWlP9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 07:15:43 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 00D42C0B786B
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 14:15:42 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t9JEFfhm032330
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 10:15:42 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_io: inode command manpage V1
Date: Mon, 19 Oct 2015 16:15:37 +0200
Message-Id: <1445264137-329-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

This is the first try to update xfs_io manpage to include information about
'inode' command usage.

Improvements and grammar corrections are welcome :-)

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/xfs_io.8 | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 416206f..457f0eb 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -490,7 +490,31 @@ Recursively display all the specified segments starting at the specified
 .B \-s
 Display the starting lseek(2) offset. This offset will be a calculated value when
 both data and holes are displayed together or performing a recusively display.
+.RE
+.PD
+.TP
+.TP
+.BI "inode  \-s | \-l | \-n [num] | [num]"
+Query physical inode information from a xfs filesystem.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-s
+Display the physical size of the largest inode existing in the filesystem (32 or
+64 bit).
+.TP
+.B -l
+Display the largest allocated and used inode (inodes can be allocated in the
+filesystem, but not used by any file). See
+.B ikeep
+xfs mount option).
+.TP
+.B -n [num]
+Return the next existing inode after [num], even if [num] is not allocated in
+the filesystem.
 .TP
+.B [num]
+Check if the inode [num] exists or not.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

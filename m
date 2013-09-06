Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 05D9329E03
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 15:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D76888F8035
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 13:59:38 -0700 (PDT)
Received: from mail-vb0-f46.google.com (mail-vb0-f46.google.com
	[209.85.212.46]) by cuda.sgi.com with ESMTP id 6W5gtqWKZQgnQ3rT
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Sep 2013 13:59:37 -0700 (PDT)
Received: by mail-vb0-f46.google.com with SMTP id p13so2504647vbe.19
	for <xfs@oss.sgi.com>; Fri, 06 Sep 2013 13:59:37 -0700 (PDT)
Message-ID: <522A4238.8050906@gmail.com>
Date: Fri, 06 Sep 2013 16:59:36 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfstests: Add JFS support to _scratch_mkfs_sized
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
To: xfs-oss <xfs@oss.sgi.com>

This code works, with a little bit of tinkering.  I wanted to shovel 
it off to another function but didn't know what to do with the 
arguments.  In particular, the number_of_blocks value has to come 
after the dev name.

Thanks!

Michael

>From cb46931b9313d001813be459f829f551d955d781 Mon Sep 17 00:00:00 2001
From: "Michael L. Semon" <mlsemon35@gmail.com>
Date: Fri, 6 Sep 2013 05:50:05 -0400
Subject: [PATCH 2/2] xfstests: Add JFS support to _scratch_mkfs_sized

Add _scratch_mkfs_sized support for JFS.  Calculations are here
due to a jfs_mkfs log calculation issue when the file system size
is smaller than the partition size.  This issue is avoided by
specifying the log size (in megabytes) on the command line.
---
 common/rc | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/rc b/common/rc
index 191e9e5..58997d7 100644
--- a/common/rc
+++ b/common/rc
@@ -612,6 +612,15 @@ _scratch_mkfs_sized()
     btrfs)
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
 	;;
+    jfs)
+	_scratch_options mkfs
+        jfs_log_sized=`expr $fssize / 16777216`
+	if `expr $jfs_log_sized \> 128`; then
+	    jfs_log_sized=128
+	fi
+	$MKFS_JFS_PROG -s $jfs_log_sized $SCRATCH_OPTIONS $MKFS_OPTIONS \
+	     $SCRATCH_DEV `expr $fssize / 4096` > /dev/null
+        ;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
 	;;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

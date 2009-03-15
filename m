Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FAocxH003925 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 05:50:58 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFD3F199E17
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:49:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail09.adl2.internode.on.net
	[203.16.214.73]) by cuda.sgi.com with ESMTP id dvUrVM7DyDZ5MIn3
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 03:49:54 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	58258979-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:19:52 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LinuX-0004nw-RM
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 21:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] [XFSQA] Test writing to ENOSPC
Date: Sun, 15 Mar 2009 21:49:41 +1100
Message-Id: <1237114181-18431-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1237114181-18431-1-git-send-email-david@fromorbit.com>
References: <1237114181-18431-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Use larger files and different writing styles to fill
a 100MB filesystem to being full. In each case we should
get very close to the filesystem being full before getting
ENOSPC. THis tests different types of ENOSPC failures to
test 203 and requires more changes to pass.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 015           |   11 ---------
 204           |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 204.out       |    4 +++
 common.filter |   11 +++++++++
 group         |    1 +
 5 files changed, 82 insertions(+), 11 deletions(-)
 mode change 100644 => 100755 141
 mode change 100644 => 100755 164
 mode change 100644 => 100755 165
 mode change 100644 => 100755 166
 mode change 100644 => 100755 167
 mode change 100644 => 100755 170
 mode change 100644 => 100755 171
 mode change 100644 => 100755 172
 mode change 100644 => 100755 173
 mode change 100644 => 100755 174
 mode change 100644 => 100755 179
 mode change 100644 => 100755 180
 mode change 100644 => 100755 182
 mode change 100644 => 100755 183
 mode change 100644 => 100755 184
 mode change 100644 => 100755 185
 mode change 100644 => 100755 188
 mode change 100644 => 100755 189
 mode change 100644 => 100755 194
 mode change 100644 => 100755 195
 mode change 100644 => 100755 196
 mode change 100644 => 100755 197
 mode change 100644 => 100755 199
 mode change 100644 => 100755 200
 create mode 100755 204
 create mode 100644 204.out

diff --git a/015 b/015
index 9b78837..f999732 100755
--- a/015
+++ b/015
@@ -33,17 +33,6 @@ _free()
     _df_dir $SCRATCH_MNT | $AWK_PROG '{ print $5 }'
 }
 
-_filter_dd()
-{
-    $AWK_PROG '
-        /records in/                { next }
-        /records out/               { next }
-        /No space left on device/   { print "   !!! disk full (expected)" 
-                                      next }
-                                    { print "   *** " $0 }
-    '
-}
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
diff --git a/141 b/141
old mode 100644
new mode 100755
diff --git a/164 b/164
old mode 100644
new mode 100755
diff --git a/165 b/165
old mode 100644
new mode 100755
diff --git a/166 b/166
old mode 100644
new mode 100755
diff --git a/167 b/167
old mode 100644
new mode 100755
diff --git a/170 b/170
old mode 100644
new mode 100755
diff --git a/171 b/171
old mode 100644
new mode 100755
diff --git a/172 b/172
old mode 100644
new mode 100755
diff --git a/173 b/173
old mode 100644
new mode 100755
diff --git a/174 b/174
old mode 100644
new mode 100755
diff --git a/179 b/179
old mode 100644
new mode 100755
diff --git a/180 b/180
old mode 100644
new mode 100755
diff --git a/182 b/182
old mode 100644
new mode 100755
diff --git a/183 b/183
old mode 100644
new mode 100755
diff --git a/184 b/184
old mode 100644
new mode 100755
diff --git a/185 b/185
old mode 100644
new mode 100755
diff --git a/188 b/188
old mode 100644
new mode 100755
diff --git a/189 b/189
old mode 100644
new mode 100755
diff --git a/194 b/194
old mode 100644
new mode 100755
diff --git a/195 b/195
old mode 100644
new mode 100755
diff --git a/196 b/196
old mode 100644
new mode 100755
diff --git a/197 b/197
old mode 100644
new mode 100755
diff --git a/199 b/199
old mode 100644
new mode 100755
diff --git a/200 b/200
old mode 100644
new mode 100755
diff --git a/204 b/204
new file mode 100755
index 0000000..2a0b94e
--- /dev/null
+++ b/204
@@ -0,0 +1,66 @@
+#! /bin/sh
+# FS QA Test No. 203
+#
+# Test out ENOSPC flushiung on small filesystems.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Dave Chinner
+#-----------------------------------------------------------------------
+#
+# creator
+owner=david@fromorbit.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+_scratch_mkfs_xfs -d size=16m -b size=512 >/dev/null
+_scratch_mount
+
+# on a 16MB filesystem, there's 32768x512byte blocks. used is:
+#	- 4944 in the log,
+#	- 32+1 for the root inode cluster
+#	- 4 for the AG header
+#	- 2 for free space btrees
+#	- 4 for the AGFL
+#	- min(%5, 1024) = 1024 blocks for the reserve pool
+#	- about 15 blocks I can't account for right now.
+# That leaves ~26,745 blocks free to use.
+#
+# Writing the following three files fill the fs almost exactly.
+#
+# $ df -k /mnt/scratch
+# Filesystem           1K-blocks      Used Available Use% Mounted on
+# /dev/ubdc                13912     13908         4 100% /mnt/scratch
+#
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=512 count=25000 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred2 bs=512 count=500 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred3 bs=512 count=245 2>&1 | _filter_dd
+rm -f $SCRATCH_MNT/fred*
+
+echo "*** one file"
+# now try a single file of that size
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=512 count=26745 2>&1 | _filter_dd
+#rm -f $SCRATCH_MNT/fred*
+
+echo "*** one file, a few bytes at a time"
+# now try a single file of that size
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=15 count=$[26745/15*512] 2>&1 | _filter_dd
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
diff --git a/204.out b/204.out
new file mode 100644
index 0000000..0962619
--- /dev/null
+++ b/204.out
@@ -0,0 +1,4 @@
+QA output created by 204
+*** one file
+*** one file, a few bytes at a time
+*** done
diff --git a/common.filter b/common.filter
index d1d4cb5..0e2d7ff 100644
--- a/common.filter
+++ b/common.filter
@@ -167,5 +167,16 @@ _filter_growfs()
     }'
 }
 
+_filter_dd()
+{
+    $AWK_PROG '
+        /records in/                { next }
+        /records out/               { next }
+        /No space left on device/   { print "   !!! disk full (expected)" 
+                                      next }
+                                    { print "   *** " $0 }
+    '
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/group b/group
index 0a51d9a..63c4dad 100644
--- a/group
+++ b/group
@@ -308,3 +308,4 @@ atime
 201 metadata auto quick
 202 repair auto quick
 203 metadata rw auto
+204 metadata rw auto
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

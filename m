Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5H2i9IB153579 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 21:44:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 320A914E67E2
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 19:46:44 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	7DLioufLVU9xGF4Z for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 19:46:44 -0700 (PDT)
Received: from dastard (unverified [121.44.96.63])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	28078465-1927428
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 12:16:43 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OP57p-0006OH-Vy
	for xfs@oss.sgi.com; Thu, 17 Jun 2010 12:46:42 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OP57o-0002ZF-7k
	for xfs@oss.sgi.com; Thu, 17 Jun 2010 12:46:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsqa: test open_by_handle() on unlinked and freed inode
	clusters V2
Date: Thu, 17 Jun 2010 12:46:40 +1000
Message-Id: <1276742800-9845-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When Christoph and I were discussing bulkstat coherency on IRC, we
realised that inode lookup from bulkstat was not actually looking up
the inode allocation btree in xfs_imap() before reading the inode
buffer from disk in xfs_iread(). Bulkstat uses the same lookup
mechanism as handle validation to avoid shutting down the filesystem
if inode numbers that point to non-inode buffers (i.e. invalid) are
passed in the handle.

The problem with this is that when we delete inodes from disk and we
remove the inode chunk (i.e. deallocate inodes) we mark both the
inodes in memory and the cluster buffer as stale, thereby preventing
it from being written back to disk. The result of this is that some
number of inodes remain on disk looking like allocated, in use
inodes (i.e.  di_mode is not zero).

Hence if we get a cold cache lookup from a stale handle that
references such an inode, we can read the inode off disk even though
it has been deleted because we don't check if the inode is allocated
or not.  If the inode chunk has not been overwritten, then the inode
read will succeed and the handle-to-dentry conversion will not error
out like it is supposed to. The result is that stale NFS filehandles
and open_by_handle() will succeed incorrectly on unlinked files for
cold cache lookups.

This is a bug that has been present ever since the inode chunk
deletion code was implemented. This test exercises the problem and
documents the hoops you have to jump through to reproduce it.

Version 2:

o suppress mkfs output that was unnoticed due to failure noise
o fix exit value so test reports success correctly (e.g. when run
  with MOUNT_OPTIONS="-o ikeep")

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 238          |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 238.out      |    2 ++
 group        |    1 +
 src/Makefile |    3 ++-
 4 files changed, 62 insertions(+), 1 deletions(-)
 create mode 100755 238
 create mode 100644 238.out

diff --git a/238 b/238
new file mode 100755
index 0000000..67146b6
--- /dev/null
+++ b/238
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. $id
+#
+# what am I here for?
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dchinner@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+echo "Silence is golden"
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount > /dev/null 2>&1
+src/stale_handle $SCRATCH_MNT
+status=$?
+exit
diff --git a/238.out b/238.out
new file mode 100644
index 0000000..9d5b672
--- /dev/null
+++ b/238.out
@@ -0,0 +1,2 @@
+QA output created by 238
+Silence is golden
diff --git a/group b/group
index 5c2d252..ee835d6 100644
--- a/group
+++ b/group
@@ -351,3 +351,4 @@ deprecated
 235 auto quota quick
 236 auto quick metadata
 237 auto quick acl
+238 auto quick metadata ioctl
diff --git a/src/Makefile b/src/Makefile
index 976133d..e878cff 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -15,7 +15,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
-	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable
+	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
+	stale_handle
 
 SUBDIRS =
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

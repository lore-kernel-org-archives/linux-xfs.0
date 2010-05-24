Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECGs5183240 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:17 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02F33369D3E
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:38 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id igxPNlC7gyQCvw2h for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:38 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] Add test for quota accounting after remount read only
Date: Mon, 24 May 2010 16:14:19 +0200
Message-Id: <1274710459-11446-9-git-send-email-jack@suse.cz>
In-Reply-To: <1274710459-11446-1-git-send-email-jack@suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>

Check that quota accounting works after remounting read-only and
then back read-write.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 235     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 235.out |   34 +++++++++++++++++++++++++
 group   |    1 +
 3 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100755 235
 create mode 100644 235.out

diff --git a/235 b/235
new file mode 100755
index 0000000..97632e5
--- /dev/null
+++ b/235
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 235
+#
+# Test whether quota gets properly reenabled after remount read-write
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Jan Kara.  All Rights Reserved.
+#
+# Based on test 219,
+# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
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
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=jack@suse.cz
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+filter_scratch()
+{
+	perl -ne "
+s,$SCRATCH_MNT,[SCR_MNT],;
+s,$SCRATCH_DEV,[SCR_DEV],;
+	print;"
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux #IRIX
+_require_scratch
+_require_quota
+_require_user
+_need_to_be_root
+
+# real QA test starts here
+rm -f $seq.full
+
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon $SCRATCH_MNT 2>/dev/null
+
+touch $SCRATCH_MNT/testfile
+chown $qa_user:$qa_user $SCRATCH_MNT/testfile
+
+repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+
+mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seq.full | filter_scratch
+touch $SCRATCH_MNT/failed 2>&1 | tee -a $seq.full | filter_scratch
+mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seq.full | filter_scratch
+
+$XFS_IO_PROG -F -c 'pwrite 0 16k' -c 'fsync' \
+			$SCRATCH_MNT/testfile >>$seq.full 2>&1
+repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+
+umount $SCRATCH_DEV 2>/dev/null
+
+status=0
+exit
diff --git a/235.out b/235.out
new file mode 100644
index 0000000..8d3eb1f
--- /dev/null
+++ b/235.out
@@ -0,0 +1,34 @@
+QA output created by 235
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 7days; Inode grace time: 7days
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     --       0       0       0              1     0     0       
+
+
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 7days; Inode grace time: 7days
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     --       0       0       0              1     0     0       
+
+
+touch: cannot touch `[SCR_MNT]/failed': Read-only file system
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 7days; Inode grace time: 7days
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     --      16       0       0              1     0     0       
+
+
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 7days; Inode grace time: 7days
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     --      16       0       0              1     0     0       
+
+
diff --git a/group b/group
index 3a95e48..6b915b2 100644
--- a/group
+++ b/group
@@ -348,3 +348,4 @@ deprecated
 232 auto quota
 233 auto quota
 234 auto quota
+235 auto quota quick
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECGbm183241 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:17 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D728369D41
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:37 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Luwyb8zQHDUJRgjA for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/8] Test basic quota enforcement
Date: Mon, 24 May 2010 16:14:14 +0200
Message-Id: <1274710459-11446-4-git-send-email-jack@suse.cz>
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

Add a test which checks whether basic quota enforcement works.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 230     |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 230.out |  131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 group   |    1 +
 3 files changed, 277 insertions(+), 0 deletions(-)
 create mode 100755 230
 create mode 100644 230.out

diff --git a/230 b/230
new file mode 100755
index 0000000..e75a828
--- /dev/null
+++ b/230
@@ -0,0 +1,145 @@
+#! /bin/bash
+# FS QA Test No. 230
+#
+# Simple quota enforcement test.
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
+test_files()
+{
+	echo; echo "### create files, setting up ownership (type=$type)"
+	touch $SCRATCH_MNT/file{1,2} 2>/dev/null
+	chown $qa_user $SCRATCH_MNT/file{1,2} 2>/dev/null
+	chgrp $qa_user $SCRATCH_MNT/file{1,2} 2>/dev/null
+	chmod 777 $SCRATCH_MNT 2>/dev/null
+}
+
+test_enforcement()
+{
+	echo "### some buffered IO (type=$type)"
+	echo "--- initiating IO..." >>$seq.full
+	# Firstly fit below block soft limit
+	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 4096' -c fsync \
+		$SCRATCH_MNT/file1" 2>&1 >>$seq.full | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	# Secondly overcome block soft limit
+	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 4097' -c fsync \
+		$SCRATCH_MNT/file1" 2>&1 >>$seq.full | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	# Now try to overcome block hardlimit
+	su $qa_user -c "$XFS_IO_PROG -F -c 'pwrite 0 4097' -c fsync \
+		$SCRATCH_MNT/file2" 2>&1 >>$seq.full | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	# Now sleep for grace time and check that softlimit got enforced
+	sleep $grace
+	su $qa_user -c "$XFS_IO_PROG -F -c 'truncate 0' -c 'pwrite 0 1' \
+		$SCRATCH_MNT/file2" 2>&1 >>$seq.full | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	# And now the softlimit test for inodes
+	su $qa_user -c "touch $SCRATCH_MNT/file3" 2>&1 >>$seq.full |
+		filter_scratch | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	# Try to exceed inode hardlimit
+	su $qa_user -c "touch $SCRATCH_MNT/file4 $SCRATCH_MNT/file5" 2>&1 \
+		>>$seq.full | filter_scratch | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	# Wait and check grace time enforcement
+	rm -f $SCRATCH_MNT/file4 >>$seq.full 2>&1
+	sleep $grace
+	su $qa_user -c "touch $SCRATCH_MNT/file4" 2>&1 >>$seq.full |
+		filter_scratch | tee -a $seq.full
+	repquota -$type $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+	echo "--- completed IO ($type)" >>$seq.full
+}
+
+cleanup_files()
+{
+	rm -f $SCRATCH_MNT/file{1,2,3,4,5}
+}
+
+# real QA test starts here
+rm -f $seq.full
+
+grace=2
+
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon $SCRATCH_MNT 2>/dev/null
+setquota -u $qa_user 4 12 2 4 $SCRATCH_MNT
+setquota -u -t $grace $grace $SCRATCH_MNT
+setquota -g $qa_user 4 12 2 4 $SCRATCH_MNT
+setquota -g -t $grace $grace $SCRATCH_MNT
+umount $SCRATCH_DEV
+
+echo; echo "### test user limit enforcement"
+_scratch_mount "-o usrquota"
+quotaon $SCRATCH_MNT 2>/dev/null
+type=u
+test_files
+test_enforcement
+cleanup_files
+umount $SCRATCH_DEV 2>/dev/null
+
+echo; echo "### test group limit enforcement"
+_scratch_mount "-o grpquota"
+quotaon $SCRATCH_MNT 2>/dev/null
+type=g
+test_files
+test_enforcement
+cleanup_files
+umount $SCRATCH_DEV 2>/dev/null
+
+status=0
+exit
diff --git a/230.out b/230.out
new file mode 100644
index 0000000..e62d88f
--- /dev/null
+++ b/230.out
@@ -0,0 +1,131 @@
+QA output created by 230
+
+### test user limit enforcement
+
+### create files, setting up ownership (type=u)
+### some buffered IO (type=u)
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     --       4       4      12              2     2     4       
+
+
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     +-       8       4      12  00:00       2     2     4       
+
+
+pwrite64: Disk quota exceeded
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     +-      12       4      12  00:00       2     2     4       
+
+
+pwrite64: Disk quota exceeded
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     +-       8       4      12   none       2     2     4       
+
+
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     ++       8       4      12   none       3     2     4  00:00
+
+
+touch: cannot touch `[SCR_MNT]/file5': Disk quota exceeded
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     ++       8       4      12   none       4     2     4  00:00
+
+
+touch: cannot touch `[SCR_MNT]/file4': Disk quota exceeded
+*** Report for user quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+User            used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     ++       8       4      12   none       3     2     4   none
+
+
+
+### test group limit enforcement
+
+### create files, setting up ownership (type=g)
+### some buffered IO (type=g)
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     --       4       4      12              2     2     4       
+
+
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     +-       8       4      12  00:00       2     2     4       
+
+
+pwrite64: Disk quota exceeded
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     +-      12       4      12  00:00       2     2     4       
+
+
+pwrite64: Disk quota exceeded
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     +-       8       4      12   none       2     2     4       
+
+
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     ++       8       4      12   none       3     2     4  00:00
+
+
+touch: cannot touch `[SCR_MNT]/file5': Disk quota exceeded
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     ++       8       4      12   none       4     2     4  00:00
+
+
+touch: cannot touch `[SCR_MNT]/file4': Disk quota exceeded
+*** Report for group quotas on device [SCR_DEV]
+Block grace time: 00:00; Inode grace time: 00:00
+                        Block limits                File limits
+Group           used    soft    hard  grace    used  soft  hard  grace
+----------------------------------------------------------------------
+fsgqa     ++       8       4      12   none       3     2     4   none
+
+
diff --git a/group b/group
index 2c1ac50..441e0e9 100644
--- a/group
+++ b/group
@@ -343,3 +343,4 @@ deprecated
 227 auto fsr
 228 rw auto prealloc quick
 229 auto rw
+230 auto quota quick
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

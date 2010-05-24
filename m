Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECGUh183220 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:16 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 211EE369D39
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:37 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id K3hwEXeGqwhV93Ao for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/8] Add test of quota accounting using fsx
Date: Mon, 24 May 2010 16:14:15 +0200
Message-Id: <1274710459-11446-5-git-send-email-jack@suse.cz>
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

Run fsx (and also several fsx threads in parallel) and verify that
quota accounting is correct after they finish.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 231     |  141 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 231.out |   10 ++++
 group   |    1 +
 3 files changed, 152 insertions(+), 0 deletions(-)
 create mode 100755 231
 create mode 100644 231.out

diff --git a/231 b/231
new file mode 100755
index 0000000..ebbe11e
--- /dev/null
+++ b/231
@@ -0,0 +1,141 @@
+#! /bin/bash
+# FSQA Test No. 231
+#
+# Run fsx with quotas enabled and verify accounted quotas in the end
+#
+# Derived from test 127
+#-----------------------------------------------------------------------
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
+FSX_FILE_SIZE=64000000
+FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -N 20000"
+
+filter_scratch()
+{
+        perl -ne "
+s,$SCRATCH_MNT,[SCR_MNT],;
+s,$SCRATCH_DEV,[SCR_DEV],;
+        print;"
+}
+
+check_usage()
+{
+	quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
+	repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
+		>$tmp.orig
+	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+	repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch \
+		>$tmp.checked
+	quotaon -u -g $SCRATCH_MNT 2>/dev/null
+	diff $tmp.orig $tmp.checked
+}
+
+_fsx()
+{
+	tasks=$1
+	echo "=== FSX Standard Mode, Memory Mapping, $tasks Tasks ==="
+	for (( i = 1; i <= $tasks; i++ )); do
+		SEED=$RANDOM
+		echo "ltp/fsx $FSX_ARGS -S $SEED $SCRATCH_MNT/fsx_file$i" >>$seq.full
+		su $qa_user -c "ltp/fsx $FSX_ARGS -S $SEED \
+			$SCRATCH_MNT/fsx_file$i" >$tmp.output$i 2>&1 &
+	done
+
+	for (( i = 1; i <= $tasks; i++ )); do
+		if ! wait %$i; then
+			cat $tmp.output$i | tee -a $seq.full
+			wait
+			return 1
+		fi
+		$XFS_IO_PROG -F -c 'fsync' $SCRATCH_MNT/fsx_file$i
+		cat $tmp.output$i | tee -a $seq.full
+	done
+	return 0
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_quota
+_require_user
+_need_to_be_root
+
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+chmod 777 $SCRATCH_MNT
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon -u -g $SCRATCH_MNT 2>/dev/null
+
+if ! _fsx 1; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+
+if ! check_usage; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+
+if ! _fsx 4; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+
+if ! check_usage; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+
+#flush cache after write
+FSX_ARGS="-f $FSX_ARGS"
+if ! _fsx 1; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+
+if ! check_usage; then
+	umount $SCRATCH_DEV 2>/dev/null
+	status=1
+	exit
+fi
+
+umount $SCRATCH_DEV 2>/dev/null
+status=0
+exit
diff --git a/231.out b/231.out
new file mode 100644
index 0000000..2f2d072
--- /dev/null
+++ b/231.out
@@ -0,0 +1,10 @@
+QA output created by 231
+=== FSX Standard Mode, Memory Mapping, 1 Tasks ===
+All operations completed A-OK!
+=== FSX Standard Mode, Memory Mapping, 4 Tasks ===
+All operations completed A-OK!
+All operations completed A-OK!
+All operations completed A-OK!
+All operations completed A-OK!
+=== FSX Standard Mode, Memory Mapping, 1 Tasks ===
+All operations completed A-OK!
diff --git a/group b/group
index 441e0e9..6b59c69 100644
--- a/group
+++ b/group
@@ -344,3 +344,4 @@ deprecated
 228 rw auto prealloc quick
 229 auto rw
 230 auto quota quick
+231 auto quota
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

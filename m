Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OECGPH183222 for <xfs@oss.sgi.com>; Mon, 24 May 2010 09:12:16 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23C62369D3A
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 07:14:37 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id zmOcPt9QuFqHAe7B for <xfs@oss.sgi.com>;
	Mon, 24 May 2010 07:14:37 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/8] Add quota accounting test when fsstress is run and quota
	limits are set low
Date: Mon, 24 May 2010 16:14:17 +0200
Message-Id: <1274710459-11446-7-git-send-email-jack@suse.cz>
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

Test various error recovery paths whether they properly handle EDQUOT failures.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 233     |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 233.out |    6 +++
 group   |    1 +
 3 files changed, 131 insertions(+), 0 deletions(-)
 create mode 100755 233
 create mode 100644 233.out

diff --git a/233 b/233
new file mode 100755
index 0000000..b967e0d
--- /dev/null
+++ b/233
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FSQA Test No. 233
+#
+# Run fsstress with quotas enabled and limits set low and verify accounted
+# quotas in the end
+#
+# Derived from test 231
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
+FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
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
+	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.orig
+	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+		sort >$tmp.checked
+	quotaon -u -g $SCRATCH_MNT 2>/dev/null
+	diff $tmp.orig $tmp.checked
+}
+
+_filter_num()
+{
+	tee -a $here/$seq.full |\
+	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
+	    -e 's/[0-9][0-9]* paths/P paths/g' \
+	    -e 's/seed = [0-9][0-9]*/seed = S/'
+}
+
+_fsstress()
+{
+	echo ""
+	echo "Testing fsstress"
+	echo ""
+
+	out=$SCRATCH_MNT/fsstress.$$
+	count=5000
+	args="-z \
+-f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 \
+-f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
+-n $count -d $out -p 7"
+
+	echo "fsstress $args" | tee -a $here/$seq.full | sed -e "s#$out#outdir#"
+	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seq.full | _filter_num
+	then
+		echo "    fsstress $args returned $?"
+		cat $tmp.out | tee -a $here/$seq.full
+		status=1
+	fi
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
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+chmod 777 $SCRATCH_MNT
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon -u -g $SCRATCH_MNT 2>/dev/null
+setquota -u $qa_user 32000 32000 1000 1000 $SCRATCH_MNT 2>/dev/null
+
+if ! _fsstress; then
+	umount $SCRATCH_DEV 2>/dev/null
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
diff --git a/233.out b/233.out
new file mode 100644
index 0000000..208910d
--- /dev/null
+++ b/233.out
@@ -0,0 +1,6 @@
+QA output created by 233
+
+Testing fsstress
+
+fsstress -z -f rmdir=20 -f link=10 -f creat=10 -f mkdir=10 -f unlink=20 -f symlink=10 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 -n 5000 -d outdir -p 7
+seed = S
diff --git a/group b/group
index c8cd774..cc9bdb2 100644
--- a/group
+++ b/group
@@ -346,3 +346,4 @@ deprecated
 230 auto quota quick
 231 auto quota
 232 auto quota
+233 auto quota
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

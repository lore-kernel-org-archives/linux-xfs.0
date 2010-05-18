Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4INY9Ow083582 for <xfs@oss.sgi.com>; Tue, 18 May 2010 18:34:10 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B422C13F6CA9
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 16:36:27 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vjgR2TDBPK3EGFVJ for <xfs@oss.sgi.com>;
	Tue, 18 May 2010 16:36:27 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] Add quota test with fsstress
Date: Wed, 19 May 2010 01:36:16 +0200
Message-Id: <1274225776-26987-4-git-send-email-jack@suse.cz>
In-Reply-To: <1274225776-26987-1-git-send-email-jack@suse.cz>
References: <1274225776-26987-1-git-send-email-jack@suse.cz>
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

Run fsstress and verify that quota accounting is correct after it finishes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 232     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 232.out |    6 +++
 group   |    1 +
 3 files changed, 124 insertions(+), 0 deletions(-)
 create mode 100755 232
 create mode 100644 232.out

diff --git a/232 b/232
new file mode 100755
index 0000000..064f07b
--- /dev/null
+++ b/232
@@ -0,0 +1,117 @@
+#! /bin/bash
+# FSQA Test No. 232
+#
+# Run fsstress with quotas enabled and verify accounted quotas in the end
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
+	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }' | sort >$tmp.orig
+	quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+	repquota -u -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }' | sort >$tmp.checked
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
+	count=2000
+	args="-n $count -d $out -p 7"
+
+	echo "fsstress $args" | sed -e "s#$out#outdir#"
+	if ! $FSSTRESS_PROG $args | _filter_num
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
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+chmod 777 $SCRATCH_MNT
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon -u -g $SCRATCH_MNT 2>/dev/null
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
diff --git a/232.out b/232.out
new file mode 100644
index 0000000..744192e
--- /dev/null
+++ b/232.out
@@ -0,0 +1,6 @@
+QA output created by 232
+
+Testing fsstress
+
+fsstress -n 2000 -d outdir -p 7
+seed = S
diff --git a/group b/group
index 6b59c69..c8cd774 100644
--- a/group
+++ b/group
@@ -345,3 +345,4 @@ deprecated
 229 auto rw
 230 auto quota quick
 231 auto quota
+232 auto quota
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

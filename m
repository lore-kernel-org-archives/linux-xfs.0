Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC48B7F59
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 07:59:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 539A9AC006
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 05:59:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id LC2vtGlKgHlmgqqC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Feb 2014 05:59:22 -0800 (PST)
From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2 3/3] btrfs/035: add new clone overwrite regression test
Date: Thu,  6 Feb 2014 14:59:14 +0100
Message-Id: <1391695154-2039-4-git-send-email-ddiss@suse.de>
In-Reply-To: <1391695154-2039-1-git-send-email-ddiss@suse.de>
References: <1391695154-2039-1-git-send-email-ddiss@suse.de>
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
Cc: David Disseldorp <ddiss@suse.de>, dsterba@suse.cz, linux-btrfs@vger.kernel.org

This test uses the newly added cloner binary to dispatch full file and
range specific clone (reflink) requests.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 tests/btrfs/035     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 81 insertions(+)
 create mode 100755 tests/btrfs/035
 create mode 100644 tests/btrfs/035.out

diff --git a/tests/btrfs/035 b/tests/btrfs/035
new file mode 100755
index 0000000..49d9ece
--- /dev/null
+++ b/tests/btrfs/035
@@ -0,0 +1,77 @@
+#!/bin/bash
+# FS QA Test No. btrfs/035
+#
+# Regression test for overwriting clones
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+CLONER_PROG=$here/src/cloner
+[ -x $CLONER_PROG ] || _notrun "cloner binary not present at $CLONER_PROG"
+
+src_str="aaaaaaaaaa"
+
+echo -n "$src_str" > $SCRATCH_MNT/src || echo "failed to create src"
+
+$CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
+
+src_str="bbbbbbbbbbcccccccccc"
+
+echo -n "$src_str" > $SCRATCH_MNT/src || echo "failed to create src"
+
+$CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
+
+snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
+echo "attempting ioctl (src.clone1 src)"
+$CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
+	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
+
+snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone2 | awk '{print $5}'`
+echo "attempting ioctl (src.clone2 src)"
+$CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
+	$SCRATCH_MNT/src.clone2 $SCRATCH_MNT/src
+
+status=0 ; exit
diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
new file mode 100644
index 0000000..f86cadf
--- /dev/null
+++ b/tests/btrfs/035.out
@@ -0,0 +1,3 @@
+QA output created by 035
+attempting ioctl (src.clone1 src)
+attempting ioctl (src.clone2 src)
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f9f062f..bee57cb 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -37,3 +37,4 @@
 032 auto quick
 033 auto quick
 034 auto quick
+035 auto quick
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

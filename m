Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4C23F7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:24:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 254BE30406A
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 18:24:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FGsUoqQ5KBfM6Qoq for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 18:24:35 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1C2OYat001687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 21:24:34 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1C2OXHe016574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 21:24:34 -0500
Message-ID: <52FADB61.8020904@redhat.com>
Date: Tue, 11 Feb 2014 20:24:33 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: ensure bad primary sb crc fails mount
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

the commit:
10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
broke primary sb CRC validation, not erroring out the mount
if the crc was bad.

This tests that it's fixed, and properly fails the mount on
a bad crc.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/308 b/tests/xfs/308
new file mode 100755
index 0000000..0806fcd
--- /dev/null
+++ b/tests/xfs/308
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test No. 308
+#
+# Test that a bad crc on a primary V5 superblock will fail the mount
+#
+# 10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
+# inadvertently caused primary SB CRC failures to not error out, this
+# is a regression test for that fix.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+. ./common/rc
+. ./common/filter
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_mkfs_crc
+
+rm -f $seqres.full
+
+_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
+
+# Zap the crc.  xfs_db updates the CRC post-write, so poke it directly
+$XFS_IO_PROG -c "pwrite 224 4" $SCRATCH_DEV | _filter_xfs_io
+
+# should FAIL, the crc is bad; golden output contains mount failure
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/308.out b/tests/xfs/308.out
new file mode 100644
index 0000000..3d19595
--- /dev/null
+++ b/tests/xfs/308.out
@@ -0,0 +1,4 @@
+QA output created by 308
+wrote 4/4 bytes at offset 224
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+mount: Structure needs cleaning
diff --git a/tests/xfs/group b/tests/xfs/group
index fbcd3e3..23bc4e9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -187,3 +187,4 @@
 305 auto quota
 306 auto stress log metadata repair
 307 auto quick growfs
+308 auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F3277F5F
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:03:38 -0500 (CDT)
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8449630408C
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 13:03:35 -0700 (PDT)
Received: from xfsqa-xe6.americas.sgi.com (xfsqa-xe6.americas.sgi.com
	[128.162.242.7])
	by estes.americas.sgi.com (Postfix) with ESMTP id 61F0B700295D
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:03:35 -0500 (CDT)
Received: by xfsqa-xe6.americas.sgi.com (Postfix, from userid 48222)
	id 5A85D620E7; Mon, 21 Oct 2013 15:03:35 -0500 (CDT)
Message-Id: <20131021193930.144165179@sgi.com>
Date: Mon, 21 Oct 2013 15:02:31 -0500
From: rjohnston@sgi.com
Subject: [PATCH V4 1/2] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <20131021193830.885912820@sgi.com>
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

Verify extended attributes are not lost after multi-stream
xfsdump/xfsrestore of wholly-sparse files.  The restore succeeds,
however the extended attributes for that file are lost.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

diff --git a/tests/xfs/350 b/tests/xfs/350
new file mode 100755
index 0000000..df4c258
--- /dev/null
+++ b/tests/xfs/350
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 350
+#
+# Verify multi-stream xfsdump/restore preserves extended attributes
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+. ./common/dump
+. ./common/attr
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+# Extended attributes
+attr_name=attrname
+attr_value=1234
+
+rm -f $seqres.full
+
+_create_dumpdir_fill_ea
+
+# Create and add wholly-sparse file to the dump directory
+$XFS_IO_PROG -f -c "truncate 1t" $dump_dir/sparsefile >> $seqres.full 2>&1 \
+	|| _fail "could not create \"$dump_dir\"/sparsefile"
+
+# Set the xattr on sparsefile
+$ATTR_PROG -s $attr_name -V $attr_value $dump_dir/sparsefile >> $seqres.full 2>&1 \
+	|| _fail "could not set ATTR for \"$dump_dir\"/sparsefile"
+
+_do_dump_multi_file --multi 4  >> $seqres.full 2>&1
+_do_restore_multi_file --multi 4 >> $seqres.full 2>&1
+_diff_compare_eas
+
+status=0
+exit
diff --git a/tests/xfs/350.out b/tests/xfs/350.out
new file mode 100644
index 0000000..31a88b8
--- /dev/null
+++ b/tests/xfs/350.out
@@ -0,0 +1,46 @@
+QA output created by 350
+Creating directory system to dump using src/fill.
+Setup Attribute "attr1" set to a 9 byte value for smalll:
+some_text
+.Attribute "attr2" set to a 10 byte value for biggg:
+some_text2
+.Attribute "attr3" set to a 10 byte value for sub/smalll:
+some_text3
+.Attribute "attr4" set to a 10 byte value for sub/biggg:
+some_text4
+.Attribute "attr5" set to a 8 byte value for dir:
+dir_text
+...............
+Comparing dump directory with restore directory
+Looking at the extended attributes (EAs)
+EAs on dump
+User names
+Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
+dir_text
+Attribute "attr1" had a 9 byte value for DUMP_DIR/smalll:
+some_text
+Attribute "attrname" had a 4 byte value for DUMP_DIR/sparsefile:
+1234
+Attribute "attr3" had a 10 byte value for DUMP_DIR/sub/smalll:
+some_text3
+Root names
+Attribute "attr2" had a 10 byte value for DUMP_DIR/biggg:
+some_text2
+Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
+some_text4
+EAs on restore
+User names
+Attribute "attr5" had a 8 byte value for DUMP_DIR/dir:
+dir_text
+Attribute "attr1" had a 9 byte value for DUMP_DIR/smalll:
+some_text
+Attribute "attrname" had a 4 byte value for DUMP_DIR/sparsefile:
+1234
+Attribute "attr3" had a 10 byte value for DUMP_DIR/sub/smalll:
+some_text3
+Root names
+Attribute "attr2" had a 10 byte value for DUMP_DIR/biggg:
+some_text2
+Attribute "attr4" had a 10 byte value for DUMP_DIR/sub/biggg:
+some_text4
+Files 350.ea1 and 350.ea2 are identical
diff --git a/tests/xfs/group b/tests/xfs/group
index 17fff27..efa025d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -179,3 +179,4 @@
 297 auto freeze
 298 auto attr symlink quick
 299 auto quota
+350 auto dump

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

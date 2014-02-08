Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62C877F3F
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 02:30:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48AD08F8050
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 00:30:48 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vy2O9Gx4jEOTNUjn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Feb 2014 00:30:46 -0800 (PST)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH v2] xfstests: Btrfs: add test for large metadata blocks
Date: Sat,  8 Feb 2014 09:30:30 +0100
Message-Id: <1391848230-26761-1-git-send-email-koen.de.wit@oracle.com>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs@vger.kernel.org

Tests Btrfs filesystems with all possible metadata block sizes, by
setting large extended attributes on files.

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
---

v1->v2: 
    - Fix indentation: 8 spaces instead of 4
    - Move _scratch_unmount to end of loop, add _check_scratch_fs
    - Sending failure messages of mkfs.btrfs to output instead of
      $seqres.full

diff --git a/tests/btrfs/036 b/tests/btrfs/036
new file mode 100644
index 0000000..b14697d
--- /dev/null
+++ b/tests/btrfs/036
@@ -0,0 +1,137 @@
+#! /bin/bash
+# FS QA Test No. 036
+#
+# Tests large metadata blocks in btrfs, which allows large extended
+# attributes.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+
+rm -f $seqres.full
+
+pagesize=`$here/src/feature -s`
+pagesize_kb=`expr $pagesize / 1024`
+
+# Test all valid leafsizes
+for leafsize in `seq $pagesize_kb $pagesize_kb 64`; do
+        _scratch_mkfs -l ${leafsize}K >/dev/null
+        _scratch_mount
+        # Calculate the size of the extended attribute value, leaving
+        # 512 bytes for other metadata.
+        xattr_size=`expr $leafsize \* 1024 - 512`
+
+        touch $SCRATCH_MNT/emptyfile
+        # smallfile will be inlined, bigfile not.
+        $XFS_IO_PROG -f -c "pwrite 0 100" $SCRATCH_MNT/smallfile \
+                >/dev/null
+        $XFS_IO_PROG -f -c "pwrite 0 9000" $SCRATCH_MNT/bigfile \
+                >/dev/null
+        ln -s $SCRATCH_MNT/bigfile $SCRATCH_MNT/bigfile_softlink
+
+        files=(emptyfile smallfile bigfile bigfile_softlink)
+        chars=(a b c d)
+        for i in `seq 0 1 3`; do
+                char=${chars[$i]}
+                file=$SCRATCH_MNT/${files[$i]}
+                lnkfile=${file}_hardlink
+                ln $file $lnkfile
+                xattr_value=`head -c $xattr_size < /dev/zero \
+                        | tr '\0' $char`
+
+                set_md5=`echo -n "$xattr_value" | md5sum`
+                ${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
+                get_md5=`${ATTR_PROG} -Lq -g attr_$char $file | md5sum`
+                get_ln_md5=`${ATTR_PROG} -Lq -g attr_$char $lnkfile \
+                        | md5sum`
+
+                # Using md5sums for comparison instead of the values
+                # themselves because bash command lines cannot be larger
+                # than 64K chars.
+                if [ "$set_md5" != "$get_md5" ]; then
+                        echo -n "Got unexpected xattr value for "
+                        echo -n "attr_$char from file ${file}. "
+                        echo "(leafsize is ${leafsize}K)"
+                fi
+                if [ "$set_md5" != "$get_ln_md5" ]; then
+                        echo -n "Value for attr_$char differs for "
+                        echo -n "$file and ${lnkfile}. "
+                        echo "(leafsize is ${leafsize}K)"
+                fi
+        done
+
+        # Test attributes with a size larger than the leafsize.
+        # Should result in an error.
+        if [ "$leafsize" -lt "64" ]; then
+                # Bash command lines cannot be larger than 64K
+                # characters, so we do not test attribute values
+                # with a size >64KB.
+                xattr_size=`expr $leafsize \* 1024 + 512`
+                xattr_value=`head -c $xattr_size < /dev/zero | tr '\0' x`
+                ${ATTR_PROG} -q -s attr_toobig -V $xattr_value \
+                        $SCRATCH_MNT/emptyfile >> $seqres.full 2>&1
+                if [ "$?" -eq "0" ]; then
+                        echo -n "Expected error, xattr_size is bigger "
+                        echo "than ${leafsize}K"
+                fi
+        fi
+
+        _scratch_unmount >/dev/null 2>&1
+        _check_scratch_fs
+done
+
+_scratch_mount
+
+# Illegal attribute name (more than 256 characters)
+attr_name=`head -c 260 < /dev/zero | tr '\0' n`
+${ATTR_PROG} -s $attr_name -V attribute_name_too_big \
+        $SCRATCH_MNT/emptyfile 2>&1 | head -n 1
+
+_scratch_unmount
+
+_filter_size_numbers() {
+        sed "s/$pagesize/PAGESIZE/g" | sed "s/$1/LEAFSIZE/g"
+}
+
+# Some illegal leafsizes
+_scratch_mkfs -l 0 2>&1 | _filter_size_numbers 0
+_scratch_mkfs -l 5678 2>&1 | _filter_size_numbers 5678
+lsize=`expr $pagesize / 2 + $pagesize`
+_scratch_mkfs -l $lsize 2>&1 | _filter_size_numbers $lsize
+_scratch_mkfs -l 128K 2>&1 | _filter_size_numbers 131072
+_scratch_mkfs -l K
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/036.out b/tests/btrfs/036.out
new file mode 100644
index 0000000..7e88d54
--- /dev/null
+++ b/tests/btrfs/036.out
@@ -0,0 +1,7 @@
+QA output created by 036
+attr_set: Invalid argument
+Illegal leafsize (or nodesize) LEAFSIZE (smaller than PAGESIZE)
+Illegal leafsize (or nodesize) LEAFSIZE (not align to PAGESIZE)
+Illegal leafsize (or nodesize) LEAFSIZE (not align to PAGESIZE)
+Illegal leafsize (or nodesize) LEAFSIZE (larger than 65536)
+ERROR: size value is empty
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f9f062f..2ca2225 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -37,3 +37,4 @@
 032 auto quick
 033 auto quick
 034 auto quick
+036 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

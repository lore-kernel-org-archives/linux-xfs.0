Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A2797F50
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 15:39:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4228AC00B
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:39:34 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EGBp83LfQWQxsJgz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 13:39:32 -0800 (PST)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH v3] xfstests: Btrfs: add test for large metadata blocks
Date: Mon, 10 Feb 2014 22:39:22 +0100
Message-Id: <1392068362-14049-1-git-send-email-koen.de.wit@oracle.com>
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
v2->v3:
    - Sending the md5sums of the retrieved attribute values to the
      output instead of comparing them to the md5sum of the original
      value
    - Always testing attribute values of 4, 8, 12, ... up to 64 KB
      regardless of the pagesize, to make the golden output independent
      of the pagesize
    - Sending the output of mkfs.btrfs with illegal leafsize to
      $seqres.full and checking the return code
    - Using more uniform variable names: pagesize/pagesize_kb, leafsize/
      leafsize_kb, attrsize/attrsize_kb

diff --git a/tests/btrfs/036 b/tests/btrfs/036
new file mode 100644
index 0000000..fb3e987
--- /dev/null
+++ b/tests/btrfs/036
@@ -0,0 +1,125 @@
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
+_require_math
+_need_to_be_root
+
+rm -f $seqres.full
+
+pagesize=`$here/src/feature -s`
+pagesize_kb=`expr $pagesize / 1024`
+
+# Test all valid leafsizes
+for attrsize_kb in `seq 4 4 64`; do
+        # The leafsize should be a multiple of the pagesize, equal to or
+        # greater than the attribute size.
+        leafsize_kb=$(_math "($attrsize_kb + $pagesize_kb - 1) / \
+                $pagesize_kb * $pagesize_kb");
+        echo "Testing with attrsize ${attrsize_kb}K :"
+
+        _scratch_mkfs -l ${leafsize_kb}K >/dev/null
+        _scratch_mount
+        # Calculate the size of the extended attribute value, leaving
+        # 512 bytes for other metadata.
+        attrsize=`expr $attrsize_kb \* 1024 - 512`
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
+                xattr_value=`head -c $attrsize < /dev/zero \
+                        | tr '\0' $char`
+
+                echo -n "$xattr_value" | md5sum
+                ${ATTR_PROG} -Lq -s attr_$char -V $xattr_value $file
+                ${ATTR_PROG} -Lq -g attr_$char $file | md5sum
+                ${ATTR_PROG} -Lq -g attr_$char $lnkfile | md5sum
+        done
+
+        # Test attributes with a size larger than the leafsize.
+        # Should result in an error.
+        if [ "$leafsize_kb" -lt "64" ]; then
+                # Bash command lines cannot be larger than 64K
+                # characters, so we do not test attribute values
+                # with a size >64KB.
+                attrsize=`expr $attrsize_kb \* 1024 + 512`
+                xattr_value=`head -c $attrsize < /dev/zero | tr '\0' x`
+                ${ATTR_PROG} -q -s attr_toobig -V $xattr_value \
+                        $SCRATCH_MNT/emptyfile 2>&1 | _filter_scratch
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
+_test_illegal_leafsize() {
+        _scratch_mkfs -l $1 >>$seqres.full 2>&1
+        [ $? -ne 0 ] || _fail "'$1' is an illegal value for the" \
+                "leafsize option, mkfs should have failed."
+}
+
+_test_illegal_leafsize 0
+_test_illegal_leafsize 5678
+_test_illegal_leafsize `expr $pagesize / 2 + $pagesize`
+_test_illegal_leafsize 128K
+_test_illegal_leafsize K
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/036.out b/tests/btrfs/036.out
new file mode 100644
index 0000000..6aac130
--- /dev/null
+++ b/tests/btrfs/036.out
@@ -0,0 +1,240 @@
+QA output created by 036
+Testing with attrsize 4K :
+cfd9804701b4688eea03a591e8080a4a  -
+cfd9804701b4688eea03a591e8080a4a  -
+cfd9804701b4688eea03a591e8080a4a  -
+f03e80010f6ec85f22d0878a1bf0cefb  -
+f03e80010f6ec85f22d0878a1bf0cefb  -
+f03e80010f6ec85f22d0878a1bf0cefb  -
+dc6989943b336af30eb1450db5a088a9  -
+dc6989943b336af30eb1450db5a088a9  -
+dc6989943b336af30eb1450db5a088a9  -
+fe7f043e550b24e407c858525738421d  -
+fe7f043e550b24e407c858525738421d  -
+fe7f043e550b24e407c858525738421d  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 8K :
+81b19af3532798bc48f87bf1663c1f8a  -
+81b19af3532798bc48f87bf1663c1f8a  -
+81b19af3532798bc48f87bf1663c1f8a  -
+50c2c3e1880fa668e7fcf0412212c75a  -
+50c2c3e1880fa668e7fcf0412212c75a  -
+50c2c3e1880fa668e7fcf0412212c75a  -
+16f4983a3054146d17db7ffbdd822eac  -
+16f4983a3054146d17db7ffbdd822eac  -
+16f4983a3054146d17db7ffbdd822eac  -
+a473f6f08fb49a87d29709ac96bc00cb  -
+a473f6f08fb49a87d29709ac96bc00cb  -
+a473f6f08fb49a87d29709ac96bc00cb  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 12K :
+e995dd85d70f986870c04792c994ffb3  -
+e995dd85d70f986870c04792c994ffb3  -
+e995dd85d70f986870c04792c994ffb3  -
+3e97576dc431352918f9d9dde79bab69  -
+3e97576dc431352918f9d9dde79bab69  -
+3e97576dc431352918f9d9dde79bab69  -
+d959722407bb883024367c2dd68988a5  -
+d959722407bb883024367c2dd68988a5  -
+d959722407bb883024367c2dd68988a5  -
+80dd272def753eb780914c53668ababa  -
+80dd272def753eb780914c53668ababa  -
+80dd272def753eb780914c53668ababa  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 16K :
+901bb72491d6c24ff6af5ead1d8a4141  -
+901bb72491d6c24ff6af5ead1d8a4141  -
+901bb72491d6c24ff6af5ead1d8a4141  -
+d50b90fe7c85c8e78c9ef63ceed1218d  -
+d50b90fe7c85c8e78c9ef63ceed1218d  -
+d50b90fe7c85c8e78c9ef63ceed1218d  -
+feee9c22b75703f34bc03c02b0ff0255  -
+feee9c22b75703f34bc03c02b0ff0255  -
+feee9c22b75703f34bc03c02b0ff0255  -
+d289bbec3b5b240e1f5522a13b56ae9f  -
+d289bbec3b5b240e1f5522a13b56ae9f  -
+d289bbec3b5b240e1f5522a13b56ae9f  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 20K :
+3d2483c71acf8dad094169035ad4662d  -
+3d2483c71acf8dad094169035ad4662d  -
+3d2483c71acf8dad094169035ad4662d  -
+4e537f6df10c2cba8eee122d4248a615  -
+4e537f6df10c2cba8eee122d4248a615  -
+4e537f6df10c2cba8eee122d4248a615  -
+9a364d89bc488808d56b57c3e3a848c4  -
+9a364d89bc488808d56b57c3e3a848c4  -
+9a364d89bc488808d56b57c3e3a848c4  -
+936fdedc29145f173748298a31bd564e  -
+936fdedc29145f173748298a31bd564e  -
+936fdedc29145f173748298a31bd564e  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 24K :
+9075147c38947bb2e1521f6b29245749  -
+9075147c38947bb2e1521f6b29245749  -
+9075147c38947bb2e1521f6b29245749  -
+54941aad3b3e0d0ac6c1370378201fbf  -
+54941aad3b3e0d0ac6c1370378201fbf  -
+54941aad3b3e0d0ac6c1370378201fbf  -
+c07a6a58a22cf0c52d53f06765202ed3  -
+c07a6a58a22cf0c52d53f06765202ed3  -
+c07a6a58a22cf0c52d53f06765202ed3  -
+5e3c0d921883a94d544bcb1c3aeef7d2  -
+5e3c0d921883a94d544bcb1c3aeef7d2  -
+5e3c0d921883a94d544bcb1c3aeef7d2  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 28K :
+9da5fef85e68ac1e6aeb4cd372fdd218  -
+9da5fef85e68ac1e6aeb4cd372fdd218  -
+9da5fef85e68ac1e6aeb4cd372fdd218  -
+932269d973eb814eb823ab2a5e353d78  -
+932269d973eb814eb823ab2a5e353d78  -
+932269d973eb814eb823ab2a5e353d78  -
+435ae2a64d978ce450b1eb459c3c0b7a  -
+435ae2a64d978ce450b1eb459c3c0b7a  -
+435ae2a64d978ce450b1eb459c3c0b7a  -
+65e4160b1151c04965bdaae14e0b834b  -
+65e4160b1151c04965bdaae14e0b834b  -
+65e4160b1151c04965bdaae14e0b834b  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 32K :
+ec100845bd08f7ad9d2c2bce2f7c7b64  -
+ec100845bd08f7ad9d2c2bce2f7c7b64  -
+ec100845bd08f7ad9d2c2bce2f7c7b64  -
+f45dda2932aa8679beb4262a6f164965  -
+f45dda2932aa8679beb4262a6f164965  -
+f45dda2932aa8679beb4262a6f164965  -
+a45ed994e1f6004234e66df90232bcc9  -
+a45ed994e1f6004234e66df90232bcc9  -
+a45ed994e1f6004234e66df90232bcc9  -
+68daf7d11e5ff45cd48dbced8a1b7a85  -
+68daf7d11e5ff45cd48dbced8a1b7a85  -
+68daf7d11e5ff45cd48dbced8a1b7a85  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 36K :
+91b3d0a8b79035956ae6fdcfa5761776  -
+91b3d0a8b79035956ae6fdcfa5761776  -
+91b3d0a8b79035956ae6fdcfa5761776  -
+a3351a3c98d8c221aab72cab327dc343  -
+a3351a3c98d8c221aab72cab327dc343  -
+a3351a3c98d8c221aab72cab327dc343  -
+96cdadef6d37f3836744b559729185d1  -
+96cdadef6d37f3836744b559729185d1  -
+96cdadef6d37f3836744b559729185d1  -
+f04862abfea4d4d0b2881e786ac3144b  -
+f04862abfea4d4d0b2881e786ac3144b  -
+f04862abfea4d4d0b2881e786ac3144b  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 40K :
+a272b29abb9aa246fb60a9afaed970f9  -
+a272b29abb9aa246fb60a9afaed970f9  -
+a272b29abb9aa246fb60a9afaed970f9  -
+d82b172365236cb3f521a879fd5a5bb3  -
+d82b172365236cb3f521a879fd5a5bb3  -
+d82b172365236cb3f521a879fd5a5bb3  -
+fdf1e421de5b3fe7757110850deec43c  -
+fdf1e421de5b3fe7757110850deec43c  -
+fdf1e421de5b3fe7757110850deec43c  -
+b869d7ec21cbce959d90c15784590410  -
+b869d7ec21cbce959d90c15784590410  -
+b869d7ec21cbce959d90c15784590410  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 44K :
+da753f920d68c902d5326bd483a94c32  -
+da753f920d68c902d5326bd483a94c32  -
+da753f920d68c902d5326bd483a94c32  -
+f7ce0fc468a710fe5fb871f5b35338aa  -
+f7ce0fc468a710fe5fb871f5b35338aa  -
+f7ce0fc468a710fe5fb871f5b35338aa  -
+715dac824dbaff0b473450694f6ec780  -
+715dac824dbaff0b473450694f6ec780  -
+715dac824dbaff0b473450694f6ec780  -
+abf7c2ce395c83a66d8b8c3c5e6730d9  -
+abf7c2ce395c83a66d8b8c3c5e6730d9  -
+abf7c2ce395c83a66d8b8c3c5e6730d9  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 48K :
+15d180e7faf17e68afb6d57d2e116ca9  -
+15d180e7faf17e68afb6d57d2e116ca9  -
+15d180e7faf17e68afb6d57d2e116ca9  -
+8058f6e97a59ef8dc03c66c748ff5bed  -
+8058f6e97a59ef8dc03c66c748ff5bed  -
+8058f6e97a59ef8dc03c66c748ff5bed  -
+10f3af2c5730bb08b2cda5faadbf2ae7  -
+10f3af2c5730bb08b2cda5faadbf2ae7  -
+10f3af2c5730bb08b2cda5faadbf2ae7  -
+73121869378f8230c76d80629f1166e8  -
+73121869378f8230c76d80629f1166e8  -
+73121869378f8230c76d80629f1166e8  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 52K :
+9570259c04209a9b72000b00f663527c  -
+9570259c04209a9b72000b00f663527c  -
+9570259c04209a9b72000b00f663527c  -
+bbfc9b5f82705eae11f4e8cb15efe07f  -
+bbfc9b5f82705eae11f4e8cb15efe07f  -
+bbfc9b5f82705eae11f4e8cb15efe07f  -
+dbca53553dea30b8f16718757571a116  -
+dbca53553dea30b8f16718757571a116  -
+dbca53553dea30b8f16718757571a116  -
+e67b60ac37c9329b5749f5e9c2e380fa  -
+e67b60ac37c9329b5749f5e9c2e380fa  -
+e67b60ac37c9329b5749f5e9c2e380fa  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 56K :
+4bf9ed3371aca147b46753b9ccedc297  -
+4bf9ed3371aca147b46753b9ccedc297  -
+4bf9ed3371aca147b46753b9ccedc297  -
+748eddd2c06dcac7f02f5f097ced469d  -
+748eddd2c06dcac7f02f5f097ced469d  -
+748eddd2c06dcac7f02f5f097ced469d  -
+5e55fbe60506992f3fc3f6e555886d19  -
+5e55fbe60506992f3fc3f6e555886d19  -
+5e55fbe60506992f3fc3f6e555886d19  -
+c1473db0315b89f5df01783d073e2250  -
+c1473db0315b89f5df01783d073e2250  -
+c1473db0315b89f5df01783d073e2250  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 60K :
+8334b6a2716fac34d1154d08345e65ce  -
+8334b6a2716fac34d1154d08345e65ce  -
+8334b6a2716fac34d1154d08345e65ce  -
+195db321d491c6fc981400e39571f30b  -
+195db321d491c6fc981400e39571f30b  -
+195db321d491c6fc981400e39571f30b  -
+aa1e05b84420bcf236a40a51f5c4da72  -
+aa1e05b84420bcf236a40a51f5c4da72  -
+aa1e05b84420bcf236a40a51f5c4da72  -
+28c02926de8948b7e19a09ab9a05ba97  -
+28c02926de8948b7e19a09ab9a05ba97  -
+28c02926de8948b7e19a09ab9a05ba97  -
+attr_set: No space left on device
+Could not set "attr_toobig" for SCRATCH_MNT/emptyfile
+Testing with attrsize 64K :
+1a7d174602addecc31942ad67d3bb873  -
+1a7d174602addecc31942ad67d3bb873  -
+1a7d174602addecc31942ad67d3bb873  -
+9f6513ac33d6b0e0686dd4abedb1bf55  -
+9f6513ac33d6b0e0686dd4abedb1bf55  -
+9f6513ac33d6b0e0686dd4abedb1bf55  -
+fd628ec085a2cd3b05ab59b12cf0f498  -
+fd628ec085a2cd3b05ab59b12cf0f498  -
+fd628ec085a2cd3b05ab59b12cf0f498  -
+dfdd3a6559e239a5728434fdd5f779c6  -
+dfdd3a6559e239a5728434fdd5f779c6  -
+dfdd3a6559e239a5728434fdd5f779c6  -
+attr_set: Invalid argument
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

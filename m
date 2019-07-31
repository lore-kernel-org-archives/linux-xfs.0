Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16800 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725877AbfGaCaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 22:30:03 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [PATCH v2] common/rc: check 'chattr +/-x' on dax device.
Date: Wed, 31 Jul 2019 10:29:49 +0800
Message-ID: <20190731022949.2463-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: ruansy.fnst@cn.fujitsu.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

'chattr +/-x' only works on a dax device.  When checking if the 'x'
attribute is supported by XFS_IO_PROG:
    _require_xfs_io_command "chattr" "x"    (called by xfs/260)
it's better to do the check on a dax device.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 common/rc | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/rc b/common/rc
index e0b087c1..91ab2900 100644
--- a/common/rc
+++ b/common/rc
@@ -2094,11 +2094,23 @@ _require_xfs_io_command()
 		if [ -z "$param" ]; then
 			param=s
 		fi
+
+		# Attribute "x" should be tested on a dax device
+		if [ "$param" = "x" ]; then
+			_require_scratch_dax
+			_scratch_mount
+			testfile=$SCRATCH_MNT/$$.xfs_io
+		fi
+
 		# Test xfs_io chattr support AND
 		# filesystem FS_IOC_FSSETXATTR support
 		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
 		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
 		param_checked="+$param"
+
+		if [ "$param" = "x" ]; then
+			_scratch_unmount
+		fi
 		;;
 	"chproj")
 		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
-- 
2.17.0

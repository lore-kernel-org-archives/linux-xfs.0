Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35739 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728354AbfG3IkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 04:40:17 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [PATCH] common/rc: check 'chattr +/-x' on dax device.
Date: Tue, 30 Jul 2019 16:40:09 +0800
Message-ID: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
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
it's better to do the check on a dax device mounted with dax option.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 common/rc | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/common/rc b/common/rc
index e0b087c1..73ee5563 100644
--- a/common/rc
+++ b/common/rc
@@ -2094,11 +2094,22 @@ _require_xfs_io_command()
 		if [ -z "$param" ]; then
 			param=s
 		fi
+
+		# Attribute "x" should be tested on a dax device
+		if [ "$param" == "x" ]; then
+			_scratch_mount "-o dax"
+			testfile=$SCRATCH_MNT/$$.xfs_io
+		fi
+
 		# Test xfs_io chattr support AND
 		# filesystem FS_IOC_FSSETXATTR support
 		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
 		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
 		param_checked="+$param"
+
+		if [ "$param" == "x" ]; then
+			_scratch_unmount
+		fi
 		;;
 	"chproj")
 		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
-- 
2.17.0

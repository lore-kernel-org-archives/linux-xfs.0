Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39447 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbfGOMzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:25 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 1/3] common/rc: check support for xfs_io copy_range -f N
Date: Mon, 15 Jul 2019 15:55:14 +0300
Message-Id: <20190715125516.7367-2-amir73il@gmail.com>
In-Reply-To: <20190715125516.7367-1-amir73il@gmail.com>
References: <20190715125516.7367-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Implement "_require_xfs_io_command copy_range -f" to check for
the option added by following xfsprogs commit:

  xfs_io: allow passing an open file to copy_range

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index 000a7cc8..f1cec5ad 100644
--- a/common/rc
+++ b/common/rc
@@ -2105,9 +2105,16 @@ _require_xfs_io_command()
 		;;
 	"copy_range")
 		local testcopy=$TEST_DIR/$$.copy.xfs_io
+		local copy_opts=$testfile
+		if [ "$param" == "-f" ]; then
+			# source file is the open destination file
+			testcopy=$testfile
+			copy_opts="0 -d 4k"
+		fi
 		$XFS_IO_PROG -F -f -c "pwrite 0 4k" $testfile > /dev/null 2>&1
-		testio=`$XFS_IO_PROG -F -f -c "copy_range $testfile" $testcopy 2>&1`
+		testio=`$XFS_IO_PROG -F -f -c "copy_range $param $copy_opts" $testcopy 2>&1`
 		rm -f $testcopy > /dev/null 2>&1
+		param_checked="$param"
 		;;
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
-- 
2.17.1

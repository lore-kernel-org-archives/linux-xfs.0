Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 489707F4E
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 02:10:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF5AFAC005
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 00:10:09 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 6xEMj5eSVTDEV5mr for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 00:10:08 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] xfstests: fix wrong return check for case 022
Date: Mon, 6 Jan 2014 16:08:57 +0800
Message-Id: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Here we expect 0 as return value, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>
---
 tests/btrfs/022 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 tests/btrfs/022

diff --git a/tests/btrfs/022 b/tests/btrfs/022
old mode 100644
new mode 100755
index 5b18643..142aaf9
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -106,7 +106,7 @@ _limit_test()
 	[ $? -ne 0 ] || _fail "quota should have limited us"
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
 		$seqres.full 2>&1
-	[ $? -eq 0 ] || _fail "should have been allowed to write"
+	[ $? -ne 0 ] || _fail "should have been allowed to write"
 }
 
 _scratch_mkfs > /dev/null 2>&1
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

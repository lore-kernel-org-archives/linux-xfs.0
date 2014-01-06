Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2CD5A7F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 03:18:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B8A27AC004
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 01:18:51 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Yv9pc00FZ8Cy3FvW for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 01:18:50 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v2] xfstests: fix failed 022 case with qgroup limit test
Date: Mon, 6 Jan 2014 17:17:50 +0800
Message-Id: <1388999870-14842-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
Cc: jbacik@fb.com, t-itoh@jp.fujitsu.com, linux-btrfs@vger.kernel.org

To have noexceed test, we should clear data before and then retry.
However, when we are near to quota limit, we may fail to truncate/remove
data before, so we restart everthing here.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
changelog v1->v2:
	on the right way to fix failed case(Thanks to Tsutomu Itoh)
---
 tests/btrfs/022 | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/022 b/tests/btrfs/022
index 5b18643..41d8588 100644
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -94,8 +94,8 @@ _rescan_test()
 		_fail "exclusive values don't match after rescan"
 }
 
-#basic limit testing
-_limit_test()
+#basic exceed limit testing
+_limit_test_exceed()
 {
 	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
 	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
@@ -104,6 +104,15 @@ _limit_test()
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=10M count=1 >> \
 		$seqres.full 2>&1
 	[ $? -ne 0 ] || _fail "quota should have limited us"
+}
+
+#basic noexceed limit testing
+_limit_test_noexceed()
+{
+	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
+	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
+	run_check $BTRFS_UTIL_PROG qgroup limit 5M 0/$subvolid $SCRATCH_MNT
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
 		$seqres.full 2>&1
 	[ $? -eq 0 ] || _fail "should have been allowed to write"
@@ -121,7 +130,12 @@ _scratch_unmount
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
-_limit_test
+_limit_test_exceed
+_scratch_unmount
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+_limit_test_noexceed
 
 # success, all done
 echo "Silence is golden"
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

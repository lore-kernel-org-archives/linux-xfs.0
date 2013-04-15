Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 482D17F4C
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 22:38:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14672304048
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 20:38:43 -0700 (PDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [119.145.14.64])
	by cuda.sgi.com with ESMTP id h8GICbL9gmaJWitW (version=TLSv1
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Apr 2013 20:38:41 -0700 (PDT)
Message-ID: <516B75E9.40605@huawei.com>
Date: Mon, 15 Apr 2013 11:37:13 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
MIME-Version: 1.0
Subject: [PATCH] capture the failure result of 310
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
To: rjohnston@sgi.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Capture the failuer by the way of count error dmesg and give the description
how i run the test to trigger problems.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 tests/generic/310 |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 tests/generic/310

diff --git a/tests/generic/310 b/tests/generic/310
old mode 100644
new mode 100755
index ef51422..f44799a
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -4,6 +4,17 @@
 #Check if there are two threads,one keeps calling read() or lseek(), and
 #the other calling readdir(), both on the same directory fd.
 #
+#When I ran this on ext3 (can be replaced with ext2/ext4) which has dir_index
+#feature disabled, I got this:
+#
+#EXT3-fs error (device sdb): ext3_readdir: bad entry in directory #1134241:
+#rec_len % 4 != 0 - offset=2704, inode=16973836, rec_len=12850, name_len=52
+#EXT3-fs error (device sdb): ext3_readdir: bad entry in directory #1134241:
+#directory entry across blocks - offset=1672, inode=16973836, rec_len=14132,
+#name_len=57
+#
+#If we configured errors=remount-ro, the filesystem will become read-only.
+#
 # Based on a testcase from Li Zefan <lizefan@huawei.com>.
 #
 # http://marc.info/?l=linux-kernel&m=136123703211869&w=2
@@ -47,6 +58,37 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+dmesg -c > /dev/null
+
+nr_bug=`dmesg | grep -c "kernel BUG"`
+nr_error=`dmesg | grep -c "error"`
+nr_null=`dmesg | grep -c "kernel NULL pointer dereference"`
+nr_warning=`dmesg | grep -c "^WARNING"`
+nr_lockdep=`dmesg | grep -c "possible recursive locking detected"`
+
+#check if some kind of kernel bug happened
+check_kernel_bug()
+{
+	new_bug=`dmesg | grep -c "kernel BUG"`	
+	new_error=`dmesg | grep -c "error"`
+	new_null=`dmesg | grep -c "kernel NULL pointer dereference"`
+	new_warning=`dmesg | grep -c "^WARNING"`
+	new_lockdep=`dmesg | grep -c "possible recursive locking detected"`
+
+
+	# no kernel bug is detected
+	if [ $new_bug -eq $nr_bug -a $new_error -eq $nr_error -a \
+	     $new_null -eq $nr_null -a $new_warning -eq $nr_warning -a \
+	     $new_lockdep -eq $nr_lockdep ]; then
+		return 1
+	fi
+
+	nr_bug=$new_bug
+	nr_error=$new_error
+	nr_null=$new_null
+	nr_warning=$new_warning
+	nr_lockdep=$new_lockdep
+}
 mkdir $TEST_DIR/tmp
 for n in {1..4096}; do
 	touch $TEST_DIR/tmp/$n
@@ -57,6 +99,13 @@ _test_read()
 	src/t_readdir_1 $TEST_DIR/tmp &
 	sleep 100
 	killall src/t_readdir_1
+	check_kernel_bug
+	if [ $? -eq 1 ]; then
+		status=0
+	else
+		echo "error: kernel bug was found, you can see the
+			dmesg for more infomation."
+	fi
 }
 
 _test_lseek()
@@ -64,6 +113,13 @@ _test_lseek()
 	src/t_readdir_2 $TEST_DIR/tmp &
 	sleep 100
 	killall src/t_readdir_2
+	check_kernel_bug
+	if [ $? -eq 1 ]; then
+		status=0
+	else
+		echo "error: kernel bug was found, you can see the
+			dmesg for more infomation."
+	fi
 }
 
 _test_read
@@ -72,5 +128,4 @@ _test_lseek
 # success, all done
 echo "*** done"
 rm -f $seq.full
-status=0
 exit
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

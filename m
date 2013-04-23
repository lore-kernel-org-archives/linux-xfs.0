Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1FADC7F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 22:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F28D78F8037
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 20:18:34 -0700 (PDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [119.145.14.64])
	by cuda.sgi.com with ESMTP id Jb1Cv19O7BaMMSCX (version=TLSv1
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 20:18:33 -0700 (PDT)
Message-ID: <5175FC5C.5020607@huawei.com>
Date: Tue, 23 Apr 2013 11:13:32 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfstests: capture the failure result of 310
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

eguan@redhat.com fix common file path and other cleanups

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 tests/generic/310 |   72 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 63 insertions(+), 9 deletions(-)
 mode change 100644 => 100755 tests/generic/310

diff --git a/tests/generic/310 b/tests/generic/310
old mode 100644
new mode 100755
index ef51422..b18aa79
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -1,10 +1,22 @@
 #! /bin/bash
 # FS QA Test No. 310
 #
-#Check if there are two threads,one keeps calling read() or lseek(), and
-#the other calling readdir(), both on the same directory fd.
+# Check if there are two threads,one keeps calling read() or lseek(), and
+# the other calling readdir(), both on the same directory fd.
 #
-# Based on a testcase from Li Zefan <lizefan@huawei.com>.
+# Testing on ext3: with dir_index disabled results in the following
+# dmesg output: (also occurs when testing ext2 and ext4) 
+#
+# EXT3-fs error (device sdb): ext3_readdir: bad entry in directory #1134241:
+# rec_len % 4 != 0 - offset=2704, inode=16973836, rec_len=12850, name_len=52
+# EXT3-fs error (device sdb): ext3_readdir: bad entry in directory #1134241:
+# directory entry across blocks - offset=1672, inode=16973836, rec_len=14132,
+# name_len=57
+#
+# The filesystem mount option 'errors=' will define the behavior 
+# when an error is encountered. (see mount manpage) 
+#
+# The test is based on a testcase from Li Zefan <lizefan@huawei.com>.
 #
 # http://marc.info/?l=linux-kernel&m=136123703211869&w=2
 #
@@ -25,10 +37,9 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #-----------------------------------------------------------------------
 #
-# creator
-owner=zhaohongjiang@huawei.com
 
 seq=`basename $0`
+seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 status=1	# failure is the default!
@@ -40,13 +51,44 @@ _cleanup()
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
-. ./common.rc
-. ./common.filter
+. ./common/rc
+. ./common/filter
 
 # real QA test starts here
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
@@ -71,6 +127,4 @@ _test_lseek
 
 # success, all done
 echo "*** done"
-rm -f $seq.full
-status=0
 exit
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

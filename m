Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 936BB29DF8
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 08:37:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AE4CAC002
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 06:37:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QvW57rsCxXkjSX1G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 06:37:02 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] xfstests: Check fs consistency on TEST_DEV only when
	needed
Date: Tue, 24 Jun 2014 15:36:54 +0200
Message-Id: <1403617014-17870-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1403617014-17870-1-git-send-email-lczerner@redhat.com>
References: <1403617014-17870-1-git-send-email-lczerner@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Currently we're checking file system consistency on TEST_DEV after every
successful test run even though the TEST_DEV might not even be used in
that test.

Fix it by checking for number of write io on TEST_DEV device before the
test and compare it with the value after the test.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check     |  6 +++++-
 common/rc | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/check b/check
index 40f99d7..66d0f72 100755
--- a/check
+++ b/check
@@ -544,6 +544,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		rm -f core $seqres.notrun
 
 		scratch_atime=`stat -c %X $SCRATCH_DEV`
+		test_write_io=`_get_write_io_count $TEST_DEV`
 		start=`_wallclock`
 		$timestamp && echo -n "	["`date "+%T"`"]"
 		[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
@@ -626,7 +627,10 @@ for section in $HOST_OPTIONS_SECTIONS; do
 	    then
 		try="$try $seqnum"
 		n_try=`expr $n_try + 1`
-		_check_test_fs
+		write_io=`_get_write_io_count $TEST_DEV`
+		if [ -z $test_write_io ] || [ $write_io -ne $test_write_io ]; then
+			_check_test_fs
+		fi
 		atime=`stat -c %X $SCRATCH_DEV`
 		if [ $atime -ne $scratch_atime ]; then
 			_check_scratch_fs
diff --git a/common/rc b/common/rc
index 95030ae..83e8734 100644
--- a/common/rc
+++ b/common/rc
@@ -2165,6 +2165,17 @@ _scale_fsstress_args()
     echo $args
 }
 
+_get_write_io_count()
+{
+	if [ -z $1 ]; then
+		echo "Missing device argument for _get_write_io_count"
+		exit 1
+	fi
+	major_minor=$(printf "%d:%d" `stat -c "0x%t" $1` `stat -c "0x%T" $1`)
+	sync
+	cat /sys/dev/block/${major_minor}/stat 2> /dev/null | awk '{print $5}'
+}
+
 #
 # Return the logical block size if running on a block device,
 # else substitute the page size.
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E626E7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 14:46:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0588304032
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:32 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id p0Xqy9qw66SiiaSI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:31 -0800 (PST)
Subject: [PATCH 3/3] xfs/24[356]: check for -c switch to xfs_io bmap command
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Feb 2016 12:46:27 -0800
Message-ID: <20160215204627.7977.93549.stgit@birch.djwong.org>
In-Reply-To: <20160215204608.7977.2802.stgit@birch.djwong.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Extend _require_xfs_io_command so that we can pass it a command line
argument to look for, and then use new capabililty in the relevant
tests to ensure that bmap knows how to dump CoW fork contents (bmap -c)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc     |    9 +++++++--
 tests/xfs/243 |    1 +
 tests/xfs/245 |    1 +
 tests/xfs/246 |    1 +
 4 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index b11f170..e810062 100644
--- a/common/rc
+++ b/common/rc
@@ -1831,12 +1831,13 @@ _user_do()
 
 _require_xfs_io_command()
 {
-	if [ $# -ne 1 ]
+	if [ -z "$1" ]
 	then
-		echo "Usage: _require_xfs_io_command command" 1>&2
+		echo "Usage: _require_xfs_io_command command [switch]" 1>&2
 		exit 1
 	fi
 	command=$1
+	param=$2
 
 	testfile=$TEST_DIR/$$.xfs_io
 	case $command in
@@ -1866,6 +1867,10 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command support is missing"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+
+	test -z "$param" && return
+	$XFS_IO_PROG -c "help $command" | grep -q "^ $param --" || \
+		_notrun "xfs_io $command doesn't support $param"
 }
 
 # check that xfs_db supports a specific command
diff --git a/tests/xfs/243 b/tests/xfs/243
index 629173e..d75cfd8 100755
--- a/tests/xfs/243
+++ b/tests/xfs/243
@@ -56,6 +56,7 @@ _supported_fs xfs
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fpunch"
+_require_xfs_io_command "bmap" "-c"
 _require_cp_reflink
 
 rm -f $seqres.full
diff --git a/tests/xfs/245 b/tests/xfs/245
index 6da701d..7f80260 100755
--- a/tests/xfs/245
+++ b/tests/xfs/245
@@ -49,6 +49,7 @@ _supported_os Linux
 _supported_fs xfs
 _require_scratch_reflink
 _require_xfs_io_command "falloc"
+_require_xfs_io_command "bmap" "-c"
 _require_cp_reflink
 
 rm -f $seqres.full
diff --git a/tests/xfs/246 b/tests/xfs/246
index 13b0c98..bf471cc 100755
--- a/tests/xfs/246
+++ b/tests/xfs/246
@@ -42,6 +42,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_xfs_io_command "bmap" "-c"
 
 rm -f $seqres.full
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

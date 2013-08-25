Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 481277F4E
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 10:06:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9AB5AC001
	for <xfs@oss.sgi.com>; Sun, 25 Aug 2013 08:06:19 -0700 (PDT)
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141]) by
	cuda.sgi.com with ESMTP id TGVK6M0d7TWdQp6d (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Aug 2013 08:06:17 -0700 (PDT)
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Mon, 26 Aug 2013 01:02:58 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id BE5D12BB0055
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 01:06:08 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7PEnuZ149283086
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 00:49:57 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r7PF67fH032152 for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 01:06:07 +1000
From: chandan <chandan@linux.vnet.ibm.com>
Subject: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
Date: Sun, 25 Aug 2013 20:36 +0530
Message-ID: <2909046.09LYLQvZ6q@localhost.localdomain>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: sekharan@linux.vnet.ibm.com

The patch adds the function _require_le_4k_blocksize to perform the
block size check on $TEST_DEV and $SCRATCH_DEV.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 common/rc         | 10 ++++++++++
 tests/generic/255 |  1 +
 2 files changed, 11 insertions(+)

diff --git a/common/rc b/common/rc
index ae80b12..d8ee132 100644
--- a/common/rc
+++ b/common/rc
@@ -2106,6 +2106,16 @@ _require_dumpe2fs()
 	fi
 }
 
+_require_le_4k_blocksize()
+{
+	test_dev_bs=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
+	scratch_dev_bs=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
+
+	if (( $test_dev_bs > 4096 || $scratch_dev_bs > 4096 )); then
+		_notrun "This test requires a filesystem with a block size less than or equal to 4k."
+	fi
+}
+
 _create_loop_device()
 {
 	file=$1
diff --git a/tests/generic/255 b/tests/generic/255
index dd329b4..763e861 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -49,6 +49,7 @@ _supported_os Linux
 _require_xfs_io_falloc_punch
 _require_xfs_io_falloc
 _require_xfs_io_fiemap
+_require_le_4k_blocksize
 
 testfile=$TEST_DIR/255.$$
 
-- 
1.8.3.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

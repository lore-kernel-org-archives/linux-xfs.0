Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99EF029DFB
	for <xfs@oss.sgi.com>; Sat, 31 Aug 2013 12:17:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78BA1304077
	for <xfs@oss.sgi.com>; Sat, 31 Aug 2013 10:17:46 -0700 (PDT)
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144]) by
	cuda.sgi.com with ESMTP id LDV6vpJ0sMt4xWwX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 Aug 2013 10:17:41 -0700 (PDT)
Received: from /spool/local
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <chandan@linux.vnet.ibm.com>;
	Sun, 1 Sep 2013 03:06:08 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id ABF242CE804D
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 03:17:33 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7VH1Nq666912358
	for <xfs@oss.sgi.com>; Sun, 1 Sep 2013 03:01:23 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r7VHHWQH028132 for <xfs@oss.sgi.com>; Sun, 1 Sep 2013 03:17:33 +1000
From: chandan <chandan@linux.vnet.ibm.com>
Subject: [PATCH v2] xfstests: generic/255: Execute only if blocksize is 4k
Date: Sat, 31 Aug 2013 22:47:25 +0530
Message-ID: <1913969.O33RdLFALv@localhost.localdomain>
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
To: xfs@oss.sgi.com, Eric Sandeen <sandeen@redhat.com>, david@fromorbit.com
Cc: Eric Sandeen <sandeen@sandeen.net>, sekharan@linux.vnet.ibm.com

This patch adds the function _require_4k_blocksize() to perform the
block size check on the filesystem hosted by $TEST_DEV and $SCRATCH_DEV.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 common/rc         | 10 ++++++++++
 tests/generic/255 |  1 +
 2 files changed, 11 insertions(+)

diff --git a/common/rc b/common/rc
index 77e96c4..fa2bbe0 100644
--- a/common/rc
+++ b/common/rc
@@ -2118,6 +2118,16 @@ _require_dumpe2fs()
 	fi
 }
 
+_require_4k_blocksize()
+{
+	test_dev_bs=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
+	scratch_dev_bs=`stat -f $SCRATCH_MNT | grep "Block size" | cut -d " " -f3`
+
+	if (( $test_dev_bs != 4096 || $scratch_dev_bs != 4096 )); then
+		_notrun "This test requires a filesystem with 4k block size."
+	fi
+}
+
 _create_loop_device()
 {
 	file=$1
diff --git a/tests/generic/255 b/tests/generic/255
index dd329b4..ce617dc 100755
--- a/tests/generic/255
+++ b/tests/generic/255
@@ -49,6 +49,7 @@ _supported_os Linux
 _require_xfs_io_falloc_punch
 _require_xfs_io_falloc
 _require_xfs_io_fiemap
+_require_4k_blocksize
 
 testfile=$TEST_DIR/255.$$
 
-- 
1.8.3.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

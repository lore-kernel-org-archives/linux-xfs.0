Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7EDA7F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 11:17:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1EF930407B
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 09:17:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Thb1GZgDJOhsKAJY for
	<xfs@oss.sgi.com>; Thu, 22 May 2014 09:17:32 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/005: filter _scratch_mount output and fix golden output
	to match it
Date: Fri, 23 May 2014 00:17:09 +0800
Message-Id: <1400775429-30015-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Failure message of _scratch_mount is something like:

mount: mount /dev/sda5 on /mnt/scratch failed: Structure needs cleaning

not

mount: Structure needs cleaning

Filter the output and fix the golden image to match the new output.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/005     | 2 +-
 tests/xfs/005.out | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/005 b/tests/xfs/005
index 94157c4..534f910 100755
--- a/tests/xfs/005
+++ b/tests/xfs/005
@@ -59,7 +59,7 @@ _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
 $XFS_IO_PROG -c "pwrite 224 4" $SCRATCH_DEV | _filter_xfs_io
 
 # should FAIL, the crc is bad; golden output contains mount failure
-_scratch_mount
+_scratch_mount 2>&1 | _filter_scratch
 
 # success, all done
 status=0
diff --git a/tests/xfs/005.out b/tests/xfs/005.out
index 13d0125..853e446 100644
--- a/tests/xfs/005.out
+++ b/tests/xfs/005.out
@@ -1,4 +1,4 @@
 QA output created by 005
 wrote 4/4 bytes at offset 224
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-mount: Structure needs cleaning
+mount: mount SCRATCH_DEV on SCRATCH_MNT failed: Structure needs cleaning
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 99DE47F3F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 16:43:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85E74304051
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:43:13 -0700 (PDT)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	EV1gHRnB6hpaVXBz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Apr 2014 14:43:12 -0700 (PDT)
Received: by mail-qc0-f174.google.com with SMTP id c9so6502953qcz.19
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 14:43:11 -0700 (PDT)
Date: Fri, 11 Apr 2014 17:43:07 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic: add fallocate() checks to generic/300
Message-ID: <20140411214307.GC10174@wallace>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

Generic/300 fails when run on a test filesystem that does not support
fallocate(). It uses fio's falloc ioengine to generate part of its I/O
load and both allocates blocks and punches holes.  This causes EOPNOTSUPP
failures when the test is run on indirect block-mapped ext4 filesystems
or pre-3.14 ext4 filesystems created with bigalloc.

Verify that the test filesystem supports fallocate() before proceeding
with the test, checking for both block allocation and hole punching
capabilities.  Also, delete any pre-existing test output.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..4e07f8a 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -44,6 +44,13 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 
+# xfs_io is not required for this test, but it's the best way to verify
+# the test system supports fallocate() for allocation and hole punching
+_require_xfs_io_falloc
+_require_xfs_io_falloc_punch
+
+rm -f $seqres.full
+
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 if [ $((BLK_DEV_SIZE)) -gt 1048576 ]
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

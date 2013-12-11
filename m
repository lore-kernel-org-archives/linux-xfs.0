Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 872C77FEE
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22088AC00B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id RHtYNPmzBQn3ow1o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073627.081037580@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/12] 124: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0007-124-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

The test does not require a fresh file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/124 |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/tests/generic/124 b/tests/generic/124
index 93ec4a1..132f2bf 100755
--- a/tests/generic/124
+++ b/tests/generic/124
@@ -48,12 +48,10 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_require_scratch
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
+rm -f $TEST_DIR/rw_pattern.$seq $TEST_DIR/rw_pattern.$seq
 
 # Run preallo_rw_pattern on both test and scratch partitions
-for TESTFILE in $TEST_DIR/rw_pattern.tmp $SCRATCH_MNT/rw_pattern.tmp
+for TESTFILE in $TEST_DIR/rw_pattern.$seq $TEST_DIR/rw_pattern.$seq
   do
   count=1
   while (( count < 101 ))
@@ -74,9 +72,4 @@ if (test $? -eq 0 ) then
     status=0
 fi
 
-umount $SCRATCH_DEV
-
-_check_test_fs
-_check_scratch_fs
-
 exit 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

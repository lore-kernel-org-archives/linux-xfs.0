Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E43DE7CAA
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 11:14:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70590AC001
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:03 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 1ctudPxtjc7hI91G (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2016 09:14:01 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] xfstests: fix scratch device filtering in 139
Date: Thu, 28 Jan 2016 18:13:53 +0100
Message-Id: <1454001236-2600-2-git-send-email-hch@lst.de>
In-Reply-To: <1454001236-2600-1-git-send-email-hch@lst.de>
References: <1454001236-2600-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com, xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/139     | 4 ++--
 tests/xfs/139.out | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
 mode change 100644 => 100755 tests/xfs/139

diff --git a/tests/xfs/139 b/tests/xfs/139
old mode 100644
new mode 100755
index 7400cf8..51c903e
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -69,8 +69,8 @@ _pwrite_byte 0x62 0 $sz "$testdir/file1" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$testdir/file1" | _filter_test_dir
-md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
 #filefrag -v "$testdir/file1" "$testdir/file2"
 
 echo "Check scratch fs"
diff --git a/tests/xfs/139.out b/tests/xfs/139.out
index 729e2d6..090e3af 100644
--- a/tests/xfs/139.out
+++ b/tests/xfs/139.out
@@ -3,6 +3,6 @@ Format and mount
 Create the original files
 CoW every other block
 Compare files
-673c759fb131ccf3336c4f8c549a497e  /opt/test-139/file1
-dc802351f6717547cbf4c951b294f952  /opt/test-139/file2
+673c759fb131ccf3336c4f8c549a497e  SCRATCH_MNT/test-139/file1
+dc802351f6717547cbf4c951b294f952  SCRATCH_MNT/test-139/file2
 Check scratch fs
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

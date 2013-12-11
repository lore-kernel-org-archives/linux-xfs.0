Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96A667FEE
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D9538F8050
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AROOF8rGsahhrDGh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Message-Id: <20131211073627.948866470@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/12] 319: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0012-319-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/319     |   12 +++++-------
 tests/generic/319.out |    4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tests/generic/319 b/tests/generic/319
index 046969f..c382bae 100755
--- a/tests/generic/319
+++ b/tests/generic/319
@@ -51,20 +51,18 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_os Linux
 _supported_fs generic
 _require_acls
-_require_scratch
 _need_to_be_root
 
 rm -f $seqres.full
 
-_scratch_mkfs > /dev/null 2>&1
-_scratch_mount
+testdir="$TEST_DIR/testdir319"
 
-mkdir $SCRATCH_MNT/testdir
-setfacl -d --set u::rwx,g::rwx,o::- $SCRATCH_MNT/testdir
-getfacl --absolute-names $SCRATCH_MNT/testdir | _filter_scratch
+mkdir $testdir
+setfacl -d --set u::rwx,g::rwx,o::- $testdir
+getfacl --absolute-names $testdir | _filter_test_dir
 
 mkdir $SCRATCH_MNT/testdir/testsubdir
-getfacl --absolute-names $SCRATCH_MNT/testdir/testsubdir | _filter_scratch
+getfacl --absolute-names $testdir/testsubdir | _filter_test_dir
 
 # success, all done
 status=0
diff --git a/tests/generic/319.out b/tests/generic/319.out
index b090bfa..7897647 100644
--- a/tests/generic/319.out
+++ b/tests/generic/319.out
@@ -1,5 +1,5 @@
 QA output created by 319
-# file: SCRATCH_MNT/testdir
+# file: TEST_DIR/testdir319
 # owner: root
 # group: root
 user::rwx
@@ -9,7 +9,7 @@ default:user::rwx
 default:group::rwx
 default:other::---
 
-# file: SCRATCH_MNT/testdir/testsubdir
+# file: TEST_DIR/testdir319/testsubdir
 # owner: root
 # group: root
 user::rwx
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

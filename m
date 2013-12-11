Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8957D7FEC
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64EA08F804C
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Il4HRUr9JzlYI62x (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Message-Id: <20131211073627.744337105@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/12] 225: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0011-225-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/225 |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tests/generic/225 b/tests/generic/225
index 73b125a..c77c37f 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -43,14 +43,10 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_require_scratch
-
-_scratch_mkfs > /dev/null 2>&1
-_scratch_mount > /dev/null 2>&1
 
 rm -f $seqres.full
-fiemapfile=$SCRATCH_MNT/$seq.fiemap
-fiemaplog=$SCRATCH_MNT/$seq.log
+fiemapfile=$TEST_DIR/$seq.fiemap
+fiemaplog=$TEST_DIR/$seq.log
 
 [ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 138607FE6
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01BDC8F804C
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iYVsGt4be1KW1VC4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Message-Id: <20131211073627.592156701@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/12] 141: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0010-141-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/141 |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tests/generic/141 b/tests/generic/141
index fa08484..3509c4a 100755
--- a/tests/generic/141
+++ b/tests/generic/141
@@ -39,16 +39,11 @@ trap "exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-_require_scratch
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
-
 # create file, mmap a region and mmap read it
-file=$SCRATCH_MNT/mmap
-
-$XFS_IO_PROG -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
+file=$TEST_DIR/mmap.$seq
 
 rm -f $file
+$XFS_IO_PROG -f -c "pwrite 0 1024k" -c "mmap 64k 64k" -c "mread -r" $file > /dev/null
 
 status=0
 exit 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

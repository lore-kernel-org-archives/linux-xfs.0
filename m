Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20FF17FE6
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ECCE8F804B
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id PYSoQfJ8sTrd7EYo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073626.669934747@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/12] 100: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6925293708830972263=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

--===============6925293708830972263==
Content-Disposition: inline; filename=0004-100-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch

The test does not require a fresh file system.  In addition make sure we always
prepare the tarball outside the tested file system to get a better chance to
catch differences between the tested filesystem and otherṡ.  We currently skip
that if running on xfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/100 |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/tests/generic/100 b/tests/generic/100
index 05d766f..2e73c1a 100755
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -47,7 +47,6 @@ _supported_os IRIX Linux
 
 # Use _populate_fs() in common/rc to create a directory structure.
 TEMP_DIR=/tmp
-[ "$FSTYP" == "xfs" ] && TEMP_DIR=$TEST_DIR
 TAR_FILE=temp.tar
 NDIRS=3
 NFILES=6
@@ -67,9 +66,6 @@ _populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$seqres
 # Then tar up the directory structure
 tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$seqres.full 2>&1
 
-# create f/s
-_require_scratch
-
 # untar on f/s
 cd $TEST_DIR
 tar -xRvf $TEMP_DIR/$TAR_FILE >>$seqres.full 2>&1
@@ -79,8 +75,5 @@ cd $here
 ls -R -l ${TEST_DIR}${POPULATED_DIR} >>$seqres.full 2>&1
 diff -qr $POPULATED_DIR ${TEST_DIR}${POPULATED_DIR}
 
-cd /
-_check_scratch_fs
-
 status=0
 exit
-- 
1.7.10.4



--===============6925293708830972263==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6925293708830972263==--

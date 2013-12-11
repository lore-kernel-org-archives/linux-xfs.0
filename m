Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B54C7FEC
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2ABFC304066
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PirqAQpROnEckSUC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073626.804868050@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/12] 105: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0005-105-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/105 |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/tests/generic/105 b/tests/generic/105
index 2f99401..341d0b8 100755
--- a/tests/generic/105
+++ b/tests/generic/105
@@ -52,48 +52,39 @@ _supported_os IRIX Linux
 
 rm -f $seqres.full
 
-_require_scratch
 _require_acls
 
 _acl_setup_ids
 
-umount $SCRATCH_DEV >/dev/null 2>&1
-echo "*** MKFS ***"                         >>$seqres.full
-echo ""                                     >>$seqres.full
-_scratch_mkfs                               >>$seqres.full 2>&1 \
-	|| _fail "mkfs failed"
-_scratch_mount                              >>$seqres.full 2>&1 \
-	|| _fail "mount failed"
-
-cd $SCRATCH_MNT
+cd $TESTDIR
 
 # create a dir with out execute perms
-mkdir -m 600 subdir
+mkdir -m 600 subdir105
 
 # make it owned by $acl1
-chown $acl1 subdir
+chown $acl1 subdir105
 
 # put a file in the directory
-echo data > subdir/file
-_ls_l subdir/file | awk '{ print $1, $3 }'
+echo data > subdir105/file
+_ls_l subdir105/file | awk '{ print $1, $3 }'
 
 # add an ACL with a user ACE which has no exec permission 
 if [ "$HOSTOS" == "Linux" ]; then
-    setfacl -m u:$acl1:r subdir
+    setfacl -m u:$acl1:r subdir105
 elif [ "$HOSTOS" == "IRIX" ]; then
-    chacl u:$acl:r--,g::---,o::--- subdir
+    chacl u:$acl:r--,g::---,o::--- subdir105
 else
     echo "Unknown OS!"
     exit 1
 fi
 
-# With the bug this gives: `ls: subdir/file: Permission denied'
+# With the bug this gives: `ls: subdir105/file: Permission denied'
 # because one needs at least an exec perm somewhere in acl
 # However, this should not hold true for directories.
-_ls_l subdir/file | awk '{ print $1, $3 }'
+_ls_l subdir105/file | awk '{ print $1, $3 }'
 
-# With the bug this gives: `subdir/file2: Permission denied'.
-echo data2 > subdir/file2
+# With the bug this gives: `subdir105/file2: Permission denied'.
+echo data2 > subdir105/file2
 
 # success, all done
 status=0
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

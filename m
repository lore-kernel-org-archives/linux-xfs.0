Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D4EB7F50
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 10:38:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0DF968F8066
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 08:38:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BC46Qo53AikBPs20 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 May 2015 08:38:33 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs/007: use gquotino for project quotas on pre-v5 superblocks
Date: Mon, 18 May 2015 11:38:29 -0400
Message-Id: <1431963509-54017-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

This test checks block usage on quota inodes based on the inode number
values stored in the superblock. Version 5 superblocks (crc=1) have an
independent project quota inode field to support concurrent group and
project quotas. Older superblocks do not have the pquotino field. The
gquotino field is reused for project quotas.

The test currently unconditionally uses the pquotino field to determine
the project quota inode. This causes failures on pre-v5 superblocks as
the test queries the block usage of an incorrect inode number. Update
the test to use gquotino as the project quota inode on such filesystems.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/007 | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/007 b/tests/xfs/007
index 01cc421..76c100f 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -50,7 +50,8 @@ _require_xfs_quota
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs_xfs | _filter_mkfs > /dev/null 2> $tmp.mkfs
+. $tmp.mkfs
 
 do_test()
 {
@@ -88,11 +89,16 @@ _qmount_option "uquota,gquota"
 _qmount
 do_test uquotino gquotino ug
 
-# Test user and project
+# Test user and project. Note that pquotino only exists on v5 (crc=1)
+# superblocks. Older supers reuse gquotino.
+PQUOTINO=pquotino
+if [ $_fs_has_crcs == 0 ]; then
+	PQUOTINO=gquotino
+fi
 _qmount_option "uquota,pquota"
 _qmount
 _require_prjquota $SCRATCH_DEV
-do_test uquotino pquotino up
+do_test uquotino $PQUOTINO up
 
 # success, all done
 status=0
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

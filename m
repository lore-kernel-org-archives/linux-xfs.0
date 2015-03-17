Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2F187F47
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 10:19:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B11B1304039
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 08:19:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id coFbEfM6xz75akEG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 08:19:08 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 50E46AAF3
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:19:07 +0000 (UTC)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs/007: Fix failure for old superblocks
Date: Tue, 17 Mar 2015 16:19:00 +0100
Message-Id: <1426605540-12438-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

The commit 13c2dcbe2716 (xfs/007: check correct quota inodes) fixed
testing for new superblocks but broken testing for old superblocks where
project quota inode is stored in place of group quota inode. Fix that
case as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 tests/xfs/007 | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/007 b/tests/xfs/007
index 01cc42101097..c203566076e7 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -52,6 +52,12 @@ rm -f $seqres.full
 
 _scratch_mkfs_xfs >/dev/null 2>&1
 
+get_ino()
+{
+	qino=$1
+	xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | grep $qino | awk '{print $NF}'
+}
+
 do_test()
 {
 	qino_1=$1
@@ -61,10 +67,14 @@ do_test()
 	echo "*** umount"
 	umount $SCRATCH_MNT
 
-	QINO_1=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | \
-			grep $qino_1 | awk '{print $NF}'`
-	QINO_2=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | \
-			grep $qino_2 | awk '{print $NF}'`
+	QINO_1=`get_ino $qino_1`
+	QINO_2=`get_ino $qino_2`
+	# Fall back to group inode for project quotas
+	if [ $QINO_2 -eq 0 ]; then
+		if [ $qino_2 = "pquotino" ]; then
+			QINO_2=`get_ino gquotino`
+		fi
+	fi
 
 	echo "*** Usage before quotarm ***"
 	xfs_db -c "inode $QINO_1" -c "p core.nblocks" $SCRATCH_DEV
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

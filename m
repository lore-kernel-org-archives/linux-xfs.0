Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36589 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752133AbdFUV5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 17:57:33 -0400
Subject: [PATCH 2/8] xfs/274: flip shared bits to reflect xfsprogs usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 21 Jun 2017 14:57:20 -0700
Message-ID: <149808224050.8924.8528476315643334436.stgit@birch.djwong.org>
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_io's fsmap command flipped the attrfork and shared bits, so we
have to change them here too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/274 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/274 b/tests/xfs/274
index 209c067..ee433e0 100755
--- a/tests/xfs/274
+++ b/tests/xfs/274
@@ -70,7 +70,7 @@ $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 | grep '^[[:space:]]*[0-9]*:' | grep -
 
 echo "Check f1 bmap and fsmap" | tee -a $seqres.full
 cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 1000000$"
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
 	echo "${qstr}" >> $seqres.full
 	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
 	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
@@ -83,7 +83,7 @@ $XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 | grep '^[[:space:]]*[0-9]*:' | grep -
 
 echo "Check f2 bmap and fsmap" | tee -a $seqres.full
 cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
-	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 1000000$"
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 0100000$"
 	echo "${qstr}" >> $seqres.full
 	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
 	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)


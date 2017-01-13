Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdAMRFp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 12:05:45 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs/004: account for XFS reservations changes in 4.10-rc
Date: Fri, 13 Jan 2017 18:05:40 +0100
Message-Id: <1484327140-13654-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

And drop support for some really old kernels to clean things up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/004 | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/tests/xfs/004 b/tests/xfs/004
index 09da2fe..bbc1aee 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -83,29 +83,18 @@ eval `$XFS_IO_PROG -x -c resblks $SCRATCH_MNT 2>&1 \
 echo "resblks gave: resblks=$resblks" >>$seqres.full
 
 # check the 'blocks' field from freesp command is OK
-# since 2.6.18, df does not report the 4 blocks per AG that cannot
-# be allocated, hence we check for that exact mismatch.
-# since ~2.6.22, reserved blocks are used by default and df does
-# not report them, hence check for an exact mismatch.
+#  - starting with Linux 4.10-rc the bmbt split reservation moved to be per-AG
 perl -ne '
-	BEGIN	{ $avail ='$avail' * 512;
+	BEGIN	{ $avail ='$avail' * 512 + ('$resblks' * '$dbsize');
 		  $answer="(no xfs_db free blocks line?)" }
 	/free blocks (\d+)$/	|| next;
 	$freesp = $1 * '$dbsize';
-	if ($freesp == $avail) {
+	if ($freesp == $avail + ('$agcount') * '$dbsize' * 8) {
+		$answer = "yes";
+	} elsif ($freesp == $avail + (('$agcount' + 1) * '$dbsize' * 4)) {
 		$answer = "yes";
 	} else {
-		$avail = $avail + (('$agcount' + 1) * '$dbsize' * 4);
-		if ($freesp == $avail) {
-			$answer = "yes";
-		} else {
-			$avail = $avail + ('$resblks' * '$dbsize');
-			if ($freesp == $avail) {
-				$answer = "yes";
-			} else {
-				$answer = "no ($freesp != $avail)";
-			}
-		}
+		$answer = "no ($freesp != $avail)";
 	}
 	END	{ print "$answer\n" }
 	' <$tmp.xfs_db >$tmp.ans
-- 
2.1.4


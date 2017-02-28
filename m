Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57416 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdB1BPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 20:15:37 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs/004: relax freespace check
Date: Mon, 27 Feb 2017 16:52:35 -0800
Message-Id: <20170228005235.9839-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Just check for a greater equals relation so that we don't have
to adjust the test for every new reservation scheme we add..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/004 | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tests/xfs/004 b/tests/xfs/004
index bbc1aee3..f27f4b79 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -83,18 +83,15 @@ eval `$XFS_IO_PROG -x -c resblks $SCRATCH_MNT 2>&1 \
 echo "resblks gave: resblks=$resblks" >>$seqres.full
 
 # check the 'blocks' field from freesp command is OK
-#  - starting with Linux 4.10-rc the bmbt split reservation moved to be per-AG
 perl -ne '
 	BEGIN	{ $avail ='$avail' * 512 + ('$resblks' * '$dbsize');
 		  $answer="(no xfs_db free blocks line?)" }
 	/free blocks (\d+)$/	|| next;
 	$freesp = $1 * '$dbsize';
-	if ($freesp == $avail + ('$agcount') * '$dbsize' * 8) {
-		$answer = "yes";
-	} elsif ($freesp == $avail + (('$agcount' + 1) * '$dbsize' * 4)) {
+	if ($freesp >= $avail) {
 		$answer = "yes";
 	} else {
-		$answer = "no ($freesp != $avail)";
+		$answer = "no ($freesp < $avail)";
 	}
 	END	{ print "$answer\n" }
 	' <$tmp.xfs_db >$tmp.ans
-- 
2.11.0


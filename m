Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37872 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDVTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Mar 2019 16:19:38 -0500
Subject: [PATCH 3/5] shared/298: unmount filesystem before examining
 underlying storage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 04 Mar 2019 13:19:29 -0800
Message-ID: <155173436903.767.2030031690929754940.stgit@magnolia>
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, enwlinux@gmail.com

From: Darrick J. Wong <darrick.wong@oracle.com>

This test does some weird things with live filesystems -- it seems to be
validating the behavior of fstrim by comparing the filesystem's free
space map to holes in the file image that backs the filesystem.
However, this doesn't account for the fact that some filesystems
maintain in-core preallocations and/or can perturb the free space data
during unmount.  This causes sporadic test failures when the two become
out of sync.

Therefore, make sure we unmount the filesystem before we start running
tools against the filesystem image file to eliminate the possibility of
changes to the free space map.  This was found by running shared/298 on
xfs with a 1k block size.

cc: enwlinux@gmail.com
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/shared/298 |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/tests/shared/298 b/tests/shared/298
index aafdc25f..5d6c6ccf 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -46,13 +46,21 @@ _cleanup()
 
 get_holes()
 {
+	# It's not a good idea to be running tools against the image file
+	# backing a live filesystem because the filesystem could be maintaining
+	# in-core state that will perturb the free space map on umount.  Stick
+	# to established convention which requires the filesystem to be
+	# unmounted while we probe the underlying file.
+	$UMOUNT_PROG $loop_mnt
 	$XFS_IO_PROG -F -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
+	_mount $loop_dev $loop_mnt
 }
 
 get_free_sectors()
 {
 	case $FSTYP in
 	ext4)
+	$UMOUNT_PROG $loop_mnt
 	$DUMPE2FS_PROG $img_file  2>&1 | grep " Free blocks" | cut -d ":" -f2- | \
 		tr ',' '\n' | $SED_PROG 's/^ //' | \
 		$AWK_PROG -v spb=$sectors_per_block 'BEGIN{FS="-"};
@@ -195,6 +203,16 @@ while read line; do
 		END { if(found) exit 0; else exit 1}' $merged_sectors
 	then
 		echo "Sectors $from-$to are not marked as free!"
+
+		# Dump the state to make it easier to debug this...
+		echo free_sectors >> $seqres.full
+		sort -g < $free_sectors >> $seqres.full
+		echo fiemap_ref >> $seqres.full
+		sort -g < $fiemap_ref >> $seqres.full
+		echo merged_sectors >> $seqres.full
+		sort -g < $merged_sectors >> $seqres.full
+		echo fiemap_after >> $seqres.full
+		sort -g < $fiemap_after >> $seqres.full
 		exit
 	fi
 done < $fiemap_after

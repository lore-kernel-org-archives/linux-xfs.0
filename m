Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfB1X3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Feb 2019 18:29:10 -0500
Date: Thu, 28 Feb 2019 15:29:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: sporadic shared/298 failures?
Message-ID: <20190228232901.GC6471@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

Hi Eric,

On this morning's ext4 concall you mentioned that you saw sporadic
failures in shared/298, and I mentioned that I'd seen similar symptoms
on xfs.  I had a look at 298 and discovered that it probes the file
image for holes while the filesystem is loop-mounted!  Yikes!  I don't
remember the exact circumstances of your testing (I think you said it
was related to bigalloc?) but this reproduces on XFS with blocksize = 1k
every time.

Does the following patch fix your sporadic failures?

(This isn't the last word on this test -- both ext4 and XFS now /do/
support live queries of the freep space map, so we're probably going
to want a similar test that doesn't clunkily unmount the fs so much.)

I'll send this patch out with proper subject line and whatnot next week
after I give it more thorough testing on xfs.

--D

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

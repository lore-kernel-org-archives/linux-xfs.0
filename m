Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfCTAo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:44:58 -0400
Subject: [PATCH 03/12] generic/042: fix stale disk contents check
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:44:55 -0700
Message-ID: <155304269533.31707.10962791945845709289.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test doesn't call fsync or sync to force writeback of the first 60k
of the file, which means that we could end up with a file full of
zeroes or an empty file.  Since this is a regression test that looks for
stale disk contents slipping through, change the test to look for the
stale bytes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/042 |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/tests/generic/042 b/tests/generic/042
index 1aa18f9b..6c62eb63 100755
--- a/tests/generic/042
+++ b/tests/generic/042
@@ -44,7 +44,7 @@ _crashtest()
 
 	# Create an fs on a small, initialized image. The pattern is written to
 	# the image to detect stale data exposure.
-	$XFS_IO_PROG -f -c "truncate 0" -c "pwrite 0 25M" $img \
+	$XFS_IO_PROG -f -c "truncate 0" -c "pwrite -S 0xCD 0 25M" $img \
 		>> $seqres.full 2>&1
 	_mkfs_dev $img >> $seqres.full 2>&1
 
@@ -61,8 +61,12 @@ _crashtest()
 	$UMOUNT_PROG $mnt
 	_mount $img $mnt
 
-	# we generally expect a zero-sized file (this should be silent)
-	hexdump $file
+	# We should /never/ see 0xCD in the file, because we wrote that pattern
+	# to the filesystem image to expose stale data.
+	if hexdump -v -e '/1 "%02X "' $file | grep -q "CD"; then
+		echo "Saw stale data!!!"
+		hexdump $file
+	fi
 
 	$UMOUNT_PROG $mnt
 }

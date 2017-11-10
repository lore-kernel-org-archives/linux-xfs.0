Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22606 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbdKJAoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 19:44:54 -0500
Subject: [PATCH 4/4] generic/204: use available blocks to determine the
 number of files to create
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 09 Nov 2017 16:44:46 -0800
Message-ID: <151027468665.13147.9686450267905584799.stgit@magnolia>
In-Reply-To: <151027466195.13147.10381301768189156101.stgit@magnolia>
References: <151027466195.13147.10381301768189156101.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the available block count to compute the number of files we think
we can create, rather than hardcoding a particular size.  This fixes
the ENOSPC failures for xfs filesystems with rmap/reflink support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)


diff --git a/tests/generic/204 b/tests/generic/204
index 4c203a2..71bee83 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -69,7 +69,7 @@ _scratch_mount
 # work out correctly. Space usages is based 22500 files and 1024 reserved blocks
 # on a 4k block size 256 byte inode size filesystem.
 resv_blks=1024
-space=97920000
+space=$(stat -f -c '%f * %S' $SCRATCH_MNT | $BC_PROG)
 
 # decrease files for inode size.
 #	22500 * (256 + 4k) = ~97MB
@@ -78,10 +78,20 @@ space=97920000
 
 files=$((space / (isize + dbsize)))
 
+# Now do it again, but factor in the filename sizes too.
+# We naïvely assume 8 bytes for inode number, 1 byte for ftype,
+# and 1 more byte for namelen, then round up to the nearest 8
+# bytes.
+
+namelen="$(echo -n "$files" | wc -c)"
+direntlen="$(echo "(10 + $namelen + 7) / 8 * 8" | $BC_PROG)"
+
+files=$((space / (direntlen + isize + dbsize)))
+
 echo files $files, resvblks $resv_blks >> $seqres.full
 _scratch_resvblks $resv_blks >> $seqres.full 2>&1
 
-for i in `seq 1 $files`; do
+for i in `seq -w 1 $files`; do
     echo -n > $SCRATCH_MNT/$i
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
 done


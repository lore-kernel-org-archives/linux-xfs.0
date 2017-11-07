Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22629 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbdKGByZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 20:54:25 -0500
Date: Mon, 6 Nov 2017 17:54:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 12/14] generic/204: break out of fs-filling loop early if
 we ENOSPC
Message-ID: <20171107015411.GA28335@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
 <150957286222.18388.3253654888670864191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <150957286222.18388.3253654888670864191.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the available block count to compute the number of files we think
we can create, rather than hardcoding a particular size.  This fixes
the ENOSPC failures for xfs filesystems with rmap/reflink support.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: factor in space used for file names
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

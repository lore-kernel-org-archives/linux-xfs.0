Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20167 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933631AbdKAVrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:46 -0400
Subject: [PATCH 12/14] generic/204: break out of fs-filling loop early if we
 ENOSPC
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:42 -0700
Message-ID: <150957286222.18388.3253654888670864191.stgit@magnolia>
In-Reply-To: <150957278824.18388.17975162441125293654.stgit@magnolia>
References: <150957278824.18388.17975162441125293654.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If filling up the filesystem causes us to hit ENOSPC earlier than we
thought we would (the sizing estimates become less and less accurate as
we add more metadata) then just bail out -- we're checking that the fs
is robust enough to cut us off before we actually run out of space for
writing metadata and crash the fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/tests/generic/204 b/tests/generic/204
index 4c203a2..1e2c1e1 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -82,8 +82,15 @@ echo files $files, resvblks $resv_blks >> $seqres.full
 _scratch_resvblks $resv_blks >> $seqres.full 2>&1
 
 for i in `seq 1 $files`; do
-    echo -n > $SCRATCH_MNT/$i
-    echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
+	# Open/truncate file, write stuff.  If we run out of space early,
+	# we can bail out of the loop.
+	out="$($XFS_IO_PROG \
+		-c "open -f -t $SCRATCH_MNT/$i" \
+		-c 'close' \
+		-c "open -f -t $SCRATCH_MNT/$i" \
+		-c 'pwrite -q -S 0x58 0 36' 2>&1 | _filter_scratch)"
+	echo "${out}" | grep -q 'No space left on device' && break
+	test -n "${out}" && echo "${out}"
 done
 
 # success, all done


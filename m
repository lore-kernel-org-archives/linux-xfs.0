Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20113 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933631AbdKAVrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:47:40 -0400
Subject: [PATCH 11/14] xfs/010: filter and record the unknown block state
 messages
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 01 Nov 2017 14:47:36 -0700
Message-ID: <150957285613.18388.298600850675665534.stgit@magnolia>
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

Record the unknown block state messages that xfs_repair produces when
we nuke the finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/repair |    9 +++++++++
 tests/xfs/010 |    2 +-
 tests/xfs/030 |    2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/common/repair b/common/repair
index 2b1583b..b569541 100644
--- a/common/repair
+++ b/common/repair
@@ -95,9 +95,18 @@ s/(stripe unit) \(.*\) (and width) \(.*\)/\1 (SU) \2 (SW)/;
 s/(superblock) (\d+)/\1 AGNO/;
 s/(AG \#)(\d+)/\1AGNO/;
 s/(reset bad sb for ag) (\d+)/\1 AGNO/;
+s/(unknown block state, ag )(\d+)(, block )(\d+)/\1AGNO\3AGBNO/;
 	print;'
 }
 
+# Filter out unknown block state messages that appear when rmap is enabled
+# and we erase a btree root pointer (such that repair never finds the
+# tree and fails to reconcile the metadata reverse mappings against the
+# metadata).
+_filter_repair_lostblocks() {
+	_filter_repair | sed -e '/unknown block state, ag AGNO, block AGBNO/d'
+}
+
 _filter_dd()
 {
 	fgrep -v records	# lose records in/out lines
diff --git a/tests/xfs/010 b/tests/xfs/010
index b9f2891..17607d6 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -129,7 +129,7 @@ _check_scratch_fs
 # nuke the finobt root, repair will have to regenerate from the inobt
 _corrupt_finobt_root $SCRATCH_DEV
 
-_scratch_xfs_repair 2>&1 | _filter_repair
+_scratch_xfs_repair 2>&1 | _filter_repair_lostblocks
 
 status=0
 exit
diff --git a/tests/xfs/030 b/tests/xfs/030
index bc80775..fcea754 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -58,7 +58,7 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for rmapbt/d' \
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
-			    -e '/^unknown block state, ag 0, block.*/d'
+			    -e '/^unknown block state, ag AGNO, block.*/d'
 	done
 }
 


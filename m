Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43898 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfBZDqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 22:46:38 -0500
Date: Mon, 25 Feb 2019 19:46:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/2] xfs/010: use correct type for finobt corrupting
Message-ID: <20190226034628.GB7159@magnolia>
References: <155114852926.9683.4048206997940455508.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155114852926.9683.4048206997940455508.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use 'type finobt' for corrupting the finobt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/010 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/010 b/tests/xfs/010
index ee1595c8..e220a651 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -63,14 +63,14 @@ _corrupt_finobt_records()
 			_filter_dbval`
 
 	# Corrupt a freecount value. This should never exceed 64.
-	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
 		-c "write recs[1].freecount 70" $dev
 
 	# Create a corrupted non-free record, which should never appear in the
 	# finobt.
-	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
 		 -c "write recs[2].freecount 0" $dev
-	$XFS_DB_PROG -x -c "fsb $free_root" -c "type inobt" \
+	$XFS_DB_PROG -x -c "fsb $free_root" -c "type finobt" \
 		-c "write recs[2].free 0" $dev
 }
 

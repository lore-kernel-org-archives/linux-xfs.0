Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfCETmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Mar 2019 14:42:46 -0500
Date: Tue, 5 Mar 2019 11:42:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/5] ext4/032: SCRATCH_DIR -> SCRATCH_MNT
Message-ID: <20190305194241.GA4660@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155173434205.767.15128498725168844621.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use SCRATCH_MNT, not SCRATCH_DIR.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/032 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/ext4/032 b/tests/ext4/032
index 8534ddd6..277ddef0 100755
--- a/tests/ext4/032
+++ b/tests/ext4/032
@@ -19,8 +19,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 BLK_SIZ=4096
 CLUSTER_SIZ=4096
 
-IMG_FILE=$SCRATCH_DIR/$seq.fs
-IMG_MNT=$SCRATCH_DIR/$seq.mnt
+IMG_FILE=$SCRATCH_MNT/$seq.fs
+IMG_MNT=$SCRATCH_MNT/$seq.mnt
 
 ## Num clusters to blocks.
 c2b()

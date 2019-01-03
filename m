Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfACWdn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 17:33:43 -0500
Date: Thu, 3 Jan 2019 14:33:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: fix off by one error when rebuilding high keys
Message-ID: <20190103223333.GI20475@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix an off-by-one error when scanning a rmap btree block for high keys
as part of rebuilding rmap btrees during phase 5.  This causes
xfs_repair to emit a corrupt filesystem, which is bad.

This can be reproduced pretty easily by exporting
TEST_XFS_REPAIR_REBUILD=1 and running generic/051 with a 1k block size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 85d1f4fb..1bacfc7f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1500,7 +1500,7 @@ prop_rmap_highkey(
 		bt_key->rm_offset = cpu_to_be64(
 				libxfs_rmap_irec_offset_pack(&high_key));
 
-		for (i = 1; i < numrecs - 1; i++) {
+		for (i = 1; i <= numrecs; i++) {
 			bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, i);
 			key.rm_startblock = be32_to_cpu(bt_key->rm_startblock);
 			key.rm_owner = be64_to_cpu(bt_key->rm_owner);

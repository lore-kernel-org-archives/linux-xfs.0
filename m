Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51676 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751441AbeFECnX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 22:43:23 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ1wJ-0001lf-RQ
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 12:43:15 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ1wJ-0004uw-QL
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 12:43:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: catch bad stripe alignment configurations
Date: Tue,  5 Jun 2018 12:43:11 +1000
Message-Id: <20180605024313.18737-2-david@fromorbit.com>
In-Reply-To: <20180605024313.18737-1-david@fromorbit.com>
References: <20180605024313.18737-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When stripe alignments are invalid, data alignment algorithms in the
allocator may not work correctly. Ensure we catch superblocks with
invalid stripe alignment setups at mount time. These data alignment
mismatches are now detected at mount time like this:

XFS (loop0): SB stripe unit sanity check failed
XFS (loop0): Metadata corruption detected at xfs_sb_read_verify+0xab/0x110, xfs_sb block 0xffffffffffffffff
XFS (loop0): Unmount and run xfs_repair
XFS (loop0): First 128 bytes of corrupted metadata buffer:
0000000091c2de02: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 10 00  XFSB............
0000000023bff869: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000000cdd8c893: 17 32 37 15 ff ca 46 3d 9a 17 d3 33 04 b5 f1 a2  .27...F=...3....
000000009fd2844f: 00 00 00 00 00 00 00 04 00 00 00 00 00 00 06 d0  ................
0000000088e9b0bb: 00 00 00 00 00 00 06 d1 00 00 00 00 00 00 06 d2  ................
00000000ff233a20: 00 00 00 01 00 00 10 00 00 00 00 01 00 00 00 00  ................
000000009db0ac8b: 00 00 03 60 e1 34 02 00 08 00 00 02 00 00 00 00  ...`.4..........
00000000f7022460: 00 00 00 00 00 00 00 00 0c 09 0b 01 0c 00 00 19  ................
XFS (loop0): SB validate failed with error -117.

And the mount fails.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 54c5e14fdfda..fe9448862667 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -266,6 +266,22 @@ xfs_mount_validate_sb(
 		return -EFSCORRUPTED;
 	}
 
+	if (sbp->sb_unit) {
+		if (!xfs_sb_version_hasdalign(sbp) ||
+		    sbp->sb_unit > sbp->sb_width ||
+		    (sbp->sb_width % sbp->sb_unit) != 0) {
+			xfs_notice(mp, "SB stripe unit sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	} else if (xfs_sb_version_hasdalign(sbp)) {
+		xfs_notice(mp, "SB stripe alignment sanity check failed");
+		return -EFSCORRUPTED;
+	} else if (sbp->sb_width) {
+		xfs_notice(mp, "SB stripe width sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
+
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
 		xfs_notice(mp, "v5 SB sanity check failed");
-- 
2.17.0


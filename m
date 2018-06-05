Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5837 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751281AbeFEGYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 02:24:30 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-00022S-RU
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fQ5OM-0001JH-QX
        for linux-xfs@vger.kernel.org; Tue, 05 Jun 2018 16:24:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: verify COW extent size hint is valid in inode verifier
Date: Tue,  5 Jun 2018 16:24:20 +1000
Message-Id: <20180605062423.4877-4-david@fromorbit.com>
In-Reply-To: <20180605062423.4877-1-david@fromorbit.com>
References: <20180605062423.4877-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There are rules for vald extent size hints. We enforce them when
applications set them, but fuzzers violate those rules and that
screws us over. Validate COW extent size hint rules in the inode
verifier to catch this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index be197c91307b..ea64be7cbd98 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -504,7 +504,7 @@ xfs_dinode_verify(
 
 	/* extent size hint validation */
 	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
-					mode, be32_to_cpu(dip->di_flags));
+					mode, flags);
 	if (fa)
 		return fa;
 
@@ -516,7 +516,7 @@ xfs_dinode_verify(
 
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
-            !xfs_sb_version_hasreflink(&mp->m_sb))
+	     !xfs_sb_version_hasreflink(&mp->m_sb))
 		return __this_address;
 
 	/* only regular files get reflink */
@@ -531,6 +531,12 @@ xfs_dinode_verify(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
 		return __this_address;
 
+	/* COW extent size hint validation */
+	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
+					mode, flags, flags2);
+	if (fa)
+		return fa;
+
 	return NULL;
 }
 
-- 
2.17.0


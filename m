Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:55831 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932335AbdJZIdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:42 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003DC-QC
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005Mj-Oh
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/14] xfs: convert remaingin xfs_sb_version_... checks to bool
Date: Thu, 26 Oct 2017 19:33:20 +1100
Message-Id: <20171026083322.20428-13-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Some were missed in the pass that converted the function return
values from int to bool. Update the remaining ones for consistency.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d4d9bef20c3a..3fb6d2a96d36 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -505,12 +505,12 @@ xfs_sb_has_incompat_log_feature(
 /*
  * V5 superblock specific feature checks
  */
-static inline int xfs_sb_version_hascrc(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
-static inline int xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
-- 
2.15.0.rc0


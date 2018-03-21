Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5280 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751546AbeCUHwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 03:52:55 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eyYYF-0003W5-Ad
        for linux-xfs@vger.kernel.org; Wed, 21 Mar 2018 18:52:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.90_1)
        (envelope-from <david@fromorbit.com>)
        id 1eyYYF-00021P-9B
        for linux-xfs@vger.kernel.org; Wed, 21 Mar 2018 18:52:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: remove dead inode version setting code
Date: Wed, 21 Mar 2018 18:52:48 +1100
Message-Id: <20180321075248.7677-3-david@fromorbit.com>
In-Reply-To: <20180321075248.7677-1-david@fromorbit.com>
References: <20180321075248.7677-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We can only get into the branch if CRCs are enabled, so there's no
need to check inside the branch for CRCs being enabled....

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4fe17b368316..b646bf633f66 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -564,10 +564,7 @@ xfs_iread(
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
 		VFS_I(ip)->i_generation = prandom_u32();
-		if (xfs_sb_version_hascrc(&mp->m_sb))
-			ip->i_d.di_version = 3;
-		else
-			ip->i_d.di_version = 2;
+		ip->i_d.di_version = 3;
 		return 0;
 	}
 
-- 
2.16.1


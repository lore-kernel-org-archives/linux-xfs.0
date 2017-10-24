Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34150 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbdJXDA1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 23:00:27 -0400
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
References: <20170829235052.21050-1-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6cb1a1fa-15b2-6280-ba58-af39f496eb56@sandeen.net>
Date: Mon, 23 Oct 2017 22:00:26 -0500
MIME-Version: 1.0
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Ok more review, sorry this is so dispersed.

[PATCH 14/42] mkfs: factor printing of mkfs config

Oh good.  :)

[PATCH 15/42] mkfs: factor in memory superblock setup

Heh, I read that as factor in vs factor out ;)

This seems to change logic slightly, is it intentional?

from:

-	if (sb_feat.inode_align) {
-		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
-		if (sb_feat.crcs_enabled)
-			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
-		sbp->sb_inoalignmt = cluster_size >> blocklog;
-		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
-	}

to

+	if (cfg->sb_feat.inode_align) {
+		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
+		if (cfg->sb_feat.crcs_enabled)
+			cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;
+		sbp->sb_inoalignmt = cluster_size >> cfg->blocklog;
+	}

it loses the test for inalignmt being 0 and turning off inode_align...
if you deemed that impossible, a commit log comment would be helpful.
If not, maybe it's a bug.  :)  The test & set goes back to the mists
of time, so I'm not sure of its purpose.



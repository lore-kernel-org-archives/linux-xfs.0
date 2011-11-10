Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAKZi8i127029 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:35:44 -0600
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 3/8] xfsprogs: xfs_repair: don't set the root inode pointer
Date: Thu, 10 Nov 2011 14:35:13 -0600
Message-Id: <6833e89ecf7daa3ba69676fb98a4538ee6c3a1b5.1320955675.git.aelder@sgi.com>
In-Reply-To: <1320957318-16269-1-git-send-email-aelder@sgi.com>
References: <1320957318-16269-1-git-send-email-aelder@sgi.com>
In-Reply-To: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Kevan Rehm <kfr@sgi.com>, Alex Elder <aelder@sgi.com>

From: Kevan Rehm <kfr@sgi.com>

In phase 6, in mk_root_dir(), xfs_repair initializes the mount
point's m_rootip pointer without accounting for that reference.
This field never really used or needed in repair otherwise, and the
assigned pointer doesn't really represent a real reference to an
inode that needs to be cached.  So just kill off this assignment.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 repair/phase6.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 1c82cb1..81d7fe6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -797,8 +797,6 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->i_df.if_bytes = ip->i_df.if_real_bytes = 0;
 	ip->i_df.if_u1.if_extents = NULL;
 
-	mp->m_rootip = ip;
-
 	/*
 	 * initialize the directory
 	 */
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

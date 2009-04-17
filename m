Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3HLCrwh155667 for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 16:12:53 -0500
From: Felix Blyakher <felixb@sgi.com>
Subject: [PATCH] xfs: add more checks to superblock validation
Date: Fri, 17 Apr 2009 16:12:45 -0500
Message-Id: <1240002765-20279-1-git-send-email-felixb@sgi.com>
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

From: Olaf Weber <olaf@sgi.com>

There had been reports where xfs filesystem was randomly
corrupted with fsfuzzer, and xfs failed to handle it
gracefully. This patch fixes couple of reported problem
by providing additional checks in the superblock
validation routine.

Signed-off-by: Felix Blyakher <felixb@sgi.com>
---
 fs/xfs/xfs_mount.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b101990..65a9972 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -291,14 +291,17 @@ xfs_mount_validate_sb(
 	    sbp->sb_sectsize > XFS_MAX_SECTORSIZE			||
 	    sbp->sb_sectlog < XFS_MIN_SECTORSIZE_LOG			||
 	    sbp->sb_sectlog > XFS_MAX_SECTORSIZE_LOG			||
+	    sbp->sb_sectsize != (1 << sbp->sb_sectlog)			||
 	    sbp->sb_blocksize < XFS_MIN_BLOCKSIZE			||
 	    sbp->sb_blocksize > XFS_MAX_BLOCKSIZE			||
 	    sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG			||
 	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG			||
+	    sbp->sb_blocksize != (1 << sbp->sb_blocklog)		||
 	    sbp->sb_inodesize < XFS_DINODE_MIN_SIZE			||
 	    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE			||
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
 	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
+	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
 	    (sbp->sb_blocklog - sbp->sb_inodelog != sbp->sb_inopblog)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE)	||
 	    (sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)	||
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

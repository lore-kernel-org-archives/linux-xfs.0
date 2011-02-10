Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1AEMZoZ137642 for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 08:22:35 -0600
Received: from mx1.vsecurity.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA80E96D790
	for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 06:25:09 -0800 (PST)
Received: from mx1.vsecurity.com (mx1.vsecurity.com [209.67.252.12]) by
	cuda.sgi.com with ESMTP id 5DhbBGLYsM65oYmX for
	<xfs@oss.sgi.com>; Thu, 10 Feb 2011 06:25:09 -0800 (PST)
Subject: [PATCH] xfs: prevent leaking uninitialized stack memory in
	FSGEOMETRY_V1
From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Thu, 10 Feb 2011 09:25:04 -0500
Message-ID: <1297347904.13370.9.camel@dan>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: security@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org

The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
xfs_fs_geometry() with a version number of 3.  This code path does not
fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
the leaking of four bytes of uninitialized stack data to potentially
unprivileged callers.  Since all other members are filled in all code
paths and there are no padding bytes in this structure, it's safe to
avoid an expensive memset() in favor of just clearing this one field.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 fs/xfs/xfs_fsops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cec89dd..17c4785 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -102,6 +102,7 @@ xfs_fs_geometry(
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
 		geo->dirblocksize = mp->m_dirblksize;
+		geo->logsunit = 0;
 	}
 	if (new_version >= 4) {
 		geo->flags |=


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B265729E10
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:38:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F1E18F8035
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:38:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hSipnY67BH9wJhHE for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 23:38:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugr4p-0008Fr-Vt
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:40 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugr4p-0003xc-RL
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/9] xfs: add fsgeom flag for v5 superblock support.
Date: Mon, 27 May 2013 16:38:26 +1000
Message-Id: <1369636707-15150-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Currently userspace has no way of determining that a filesystem is
CRC enabled. Add a flag to the XFS_IOC_FSGEOMETRY ioctl output to
indicate that the filesystem has v5 superblock support enabled.
This will allow xfs_info to correctly report the state of the
filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fs.h    |    1 +
 fs/xfs/xfs_fsops.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 6dda3f9..d046955 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -236,6 +236,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
 #define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
+#define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 
 
 /*
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 87595b2..3c3644e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -99,7 +99,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasattr2(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
 			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0);
+				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
+			(xfs_sb_version_hascrc(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_V5SB : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

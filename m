Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 014C07F87
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:08:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D21458F8040
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TIFqRAS0vMw47KTy for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:41 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AG8eVw002909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:40 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3AG8dJo022375
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 10/11] xfs: report finobt status in fs geometry
Date: Thu, 10 Apr 2014 12:08:35 -0400
Message-Id: <1397146116-42546-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
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

Define the XFS_FSOP_GEOM_FLAGS_FINOBT fs geometry flag and set the
associated bit if the filesystem supports the free inode btree.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h    | 1 +
 fs/xfs/xfs_fsops.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c5fc116..d34703d 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -238,6 +238,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
+#define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 96e4eb0..3445ead 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -104,7 +104,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hascrc(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
 			(xfs_sb_version_hasftype(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FTYPE : 0);
+				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
+			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_FINOBT : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

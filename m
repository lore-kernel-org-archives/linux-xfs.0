Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 15BC07F53
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:37:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A998BAC00B
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 06:37:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tuTpDyHeFeBIGJIa for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 06:37:11 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADEb93D020842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:37:10 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rADEb9f1011980
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:37:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 10/11] xfs: report finobt status in fs geometry
Date: Wed, 13 Nov 2013 09:37:06 -0500
Message-Id: <1384353427-36205-11-git-send-email-bfoster@redhat.com>
In-Reply-To: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
References: <1384353427-36205-1-git-send-email-bfoster@redhat.com>
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
index 63d9424..5f78ba9 100644
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
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

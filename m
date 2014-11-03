Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D5FF7F47
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:58:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BBD8304032
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:58:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IK9M8osoGcT24D6f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:58:26 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GwPSS018263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:58:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCSvw017056
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 16/17] xfs: add fs geometry bit for sparse inode chunks
Date: Mon,  3 Nov 2014 11:12:25 -0500
Message-Id: <1415031146-9107-17-git-send-email-bfoster@redhat.com>
In-Reply-To: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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

Define an fs geometry bit for sparse inode chunks such that the
characteristic of the fs can be identified by userspace.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h    | 1 +
 fs/xfs/xfs_fsops.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 18dc721..89689c6 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_V5SB	0x8000	/* version 5 superblock */
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
+#define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index c05ac8b..8d925e8 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -103,7 +103,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasftype(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
 			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_FINOBT : 0);
+				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
+			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_SPINODES : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

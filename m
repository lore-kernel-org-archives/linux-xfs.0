Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAF8E8304
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:56:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53DDDAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:15 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9MrE1g4dU4wjj0RS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:56:13 -0700 (PDT)
Subject: [PATCH 08/24] xfs: scrub the AGI
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:56:09 -0700
Message-ID: <147216936933.6398.15480725503545971412.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Add a forgotten check to the AGI verifier, then wire up the scrub
infrastructure to check the AGI contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_fs.h     |    3 ++-
 libxfs/xfs_ialloc.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index dbdd346..daf8f5d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -562,7 +562,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_SB	0	/* superblock */
 #define XFS_SCRUB_TYPE_AGF	1	/* AG free header */
 #define XFS_SCRUB_TYPE_AGFL	2	/* AG free list */
-#define XFS_SCRUB_TYPE_MAX	2
+#define XFS_SCRUB_TYPE_AGI	3	/* AG inode header */
+#define XFS_SCRUB_TYPE_MAX	3
 
 #define XFS_SCRUB_FLAGS_ALL	0x0	/* no flags yet */
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5c88b0b..c533d5c 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2508,6 +2508,11 @@ xfs_agi_verify(
 
 	if (be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
 		return false;
+
+	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
+	    be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

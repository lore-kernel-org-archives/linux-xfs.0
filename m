Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 739CE7F8D
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E608AC007
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ndlU8wGi58TAO6go (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:43 -0700 (PDT)
Subject: [PATCH 04/14] libxfs: block-mapper changes to support reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:37 -0700
Message-ID: <20150625233937.4992.75935.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Modify the XFS block mapper routine to know how to "allocate" blocks
that already exist, for the purpose of mapping them into a second
file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   19 +++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    2 ++
 2 files changed, 21 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3f5e8da..05e8346 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3897,6 +3897,13 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
+	if (ap->flags & XFS_BMAPI_REFLINK) {
+		ap->blkno = *ap->firstblock;
+		ap->ip->i_d.di_nblocks += ap->length;
+		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+		return 0;
+	}
+
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
@@ -4519,6 +4526,12 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(!(flags & XFS_BMAPI_REFLINK));
+	if (flags & XFS_BMAPI_REFLINK) {
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4568,6 +4581,12 @@ xfs_bmapi_write(
 		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
 
 		/*
+		 * Make sure we only reflink into a hole.
+		 */
+		if (flags & XFS_BMAPI_REFLINK)
+			ASSERT(inhole);
+
+		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 674819f..908caaf 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -110,6 +110,8 @@ typedef	struct xfs_bmap_free
  */
 #define XFS_BMAPI_CONVERT	0x040
 
+#define XFS_BMAPI_REFLINK	0x080	/* map the inode to this exact block. */
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

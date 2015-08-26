Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 458F429E04
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:33:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 179B68F8040
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:33:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jLWrWrfNvN65fxWv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:33:01 -0700 (PDT)
Subject: [PATCH 06/11] xfs_repair: check v5 filesystem attr block header sanity
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:59 -0700
Message-ID: <20150826003259.23973.34038.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
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

Check the v5 fields (uuid, blocknr, owner) of attribute blocks for
obvious errors while scanning xattr blocks.  If the ownership info
is incorrect, kill the block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index c2b7c3a..8d03161 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -1508,6 +1508,44 @@ process_node_attr(
 	return (process_leaf_attr_level(mp, &da_cursor));
 }
 
+/* check v5 metadata */
+static int
+__check_attr_header(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	xfs_ino_t		ino)
+{
+	struct xfs_da3_blkinfo	*info = bp->b_addr;
+
+	if (info->hdr.magic != cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) &&
+	    info->hdr.magic != cpu_to_be16(XFS_DA3_NODE_MAGIC))
+		return 0;
+
+	/* verify owner */
+	if (be64_to_cpu(info->owner) != ino) {
+		do_warn(
+_("expected owner inode %" PRIu64 ", got %llu, attr block %" PRIu64 "\n"),
+			ino, be64_to_cpu(info->owner), bp->b_bn);
+		return 1;
+	}
+	/* verify block number */
+	if (be64_to_cpu(info->blkno) != bp->b_bn) {
+		do_warn(
+_("expected block %" PRIu64 ", got %llu, inode %" PRIu64 "attr block\n"),
+			bp->b_bn, be64_to_cpu(info->blkno), ino);
+		return 1;
+	}
+	/* verify uuid */
+	if (platform_uuid_compare(&info->uuid, &mp->m_sb.sb_meta_uuid) != 0) {
+		do_warn(
+_("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
+			ino, bp->b_bn);
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Start processing for a leaf or fuller btree.
  * A leaf directory is one where the attribute fork is too big for
@@ -1564,6 +1602,13 @@ process_longform_attr(
 	if (bp->b_error == -EFSBADCRC)
 		(*repair)++;
 
+	/* is this block sane? */
+	if (__check_attr_header(mp, bp, ino)) {
+		*repair = 0;
+		libxfs_putbuf(bp);
+		return 1;
+	}
+
 	/* verify leaf block */
 	leaf = (xfs_attr_leafblock_t *)XFS_BUF_PTR(bp);
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

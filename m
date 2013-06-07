Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 762B37F8A
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 639238F8059
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cdtGyVSAxlAZzrNw for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:30 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkvjG-0005TC-Fc
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ukvj6-000312-Aw
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/12] xfs: xfs_attr_shortform_allfit() does not handle attr3
	format.
Date: Fri,  7 Jun 2013 22:24:52 +1000
Message-Id: <1370607901-11538-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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

xfstests generic/117 fails with:

XFS: Assertion failed: leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC)

indicating a function that does not handle the attr3 format
correctly. Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_attr_leaf.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index b28266a..881f417 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -720,20 +720,22 @@ out:
  */
 int
 xfs_attr_shortform_allfit(
-	struct xfs_buf	*bp,
-	struct xfs_inode *dp)
+	struct xfs_buf		*bp,
+	struct xfs_inode	*dp)
 {
-	xfs_attr_leafblock_t *leaf;
-	xfs_attr_leaf_entry_t *entry;
+	struct xfs_attr_leafblock *leaf;
+	struct xfs_attr_leaf_entry *entry;
 	xfs_attr_leaf_name_local_t *name_loc;
-	int bytes, i;
+	struct xfs_attr3_icleaf_hdr leafhdr;
+	int			bytes;
+	int			i;
 
 	leaf = bp->b_addr;
-	ASSERT(leaf->hdr.info.magic == cpu_to_be16(XFS_ATTR_LEAF_MAGIC));
+	xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
 
-	entry = &leaf->entries[0];
 	bytes = sizeof(struct xfs_attr_sf_hdr);
-	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
+	for (i = 0; i < leafhdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
 			continue;		/* don't copy partial entries */
 		if (!(entry->flags & XFS_ATTR_LOCAL))
@@ -743,15 +745,15 @@ xfs_attr_shortform_allfit(
 			return(0);
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return(0);
-		bytes += sizeof(struct xfs_attr_sf_entry)-1
+		bytes += sizeof(struct xfs_attr_sf_entry) - 1
 				+ name_loc->namelen
 				+ be16_to_cpu(name_loc->valuelen);
 	}
 	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
 	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
-		return(-1);
-	return(xfs_attr_shortform_bytesfit(dp, bytes));
+		return -1;
+	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 052BF7F61
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 15:50:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CF2DE8F8033
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 13:50:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QD2PbZaUeTEEPq0A for <xfs@oss.sgi.com>;
	Sun, 06 Mar 2016 13:50:12 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1acgYt-0000YA-My
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:50:03 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1acgYh-0004oO-VL
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:49:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: pad xfs_attr_leaf_name_remote to avoid tripping on
	m68k
Date: Mon,  7 Mar 2016 08:49:50 +1100
Message-Id: <1457300990-18300-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1457300990-18300-1-git-send-email-david@fromorbit.com>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Pad the xfs_attr_leaf_name_remote so that we don't trip the structure
size checker on m68k.

[dchinner: add comment, XFS_ATTR_LEAF_NAME_BYTES constant and make sure
	   xfs_attr_leaf_entsize_remote() does the right thing. ]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 8d4d8bc..b6d58f6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -686,11 +686,19 @@ typedef struct xfs_attr_leaf_name_local {
 	__u8	nameval[1];		/* name/value bytes */
 } xfs_attr_leaf_name_local_t;
 
+/*
+ * some platforms (like m68k) don't like non-word sized structures and pad them
+ * out inappropriately. To work around this, we set the name array to the size
+ * that pads out to a 4 byte word size. We need to take this away from the size
+ * of the structure when calculating the length of the entry in
+ * xfs_attr_leaf_entsize_remote(), hence we define a constant for this value.
+ */
+#define XFS_ATTR_LEAF_NAME_BYTES	3
 typedef struct xfs_attr_leaf_name_remote {
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	name[1];		/* name bytes */
+	__u8	name[XFS_ATTR_LEAF_NAME_BYTES];	/* name bytes */
 } xfs_attr_leaf_name_remote_t;
 
 typedef struct xfs_attr_leafblock {
@@ -847,8 +855,10 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
-		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
+	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) -
+		      XFS_ATTR_LEAF_NAME_BYTES + nlen +
+		      XFS_ATTR_LEAF_NAME_ALIGN - 1) &
+	       ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

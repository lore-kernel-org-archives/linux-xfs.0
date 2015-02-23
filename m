Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 14B587F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 14:07:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8F80304032
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 12:07:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GtDoSEK0eCsg5wA4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 12:07:32 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1NK7Vk9010612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 15:07:31 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1NK7Uqd010794
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 15:07:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: avoid firstused overflow in attr3 leaf header with 64k
	blocks
Date: Mon, 23 Feb 2015 15:07:30 -0500
Message-Id: <1424722050-24149-1-git-send-email-bfoster@redhat.com>
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

The attr3 leaf header has a 16-bit firstused field that tracks the first
used entry offset. This field is initialized to the block size in
xfs_attr3_leaf_create() and updated accordingly in
xfs_attr3_leaf_add_work() when new attributes are added.

The initialization of firstused overflows if the block size exceeds
16-bits. E.g., xfstests test generic/117 causes assert failures on a
-bsize=64k fs on ppc64 because ichdr.firstused evaluates to 0.

Update the firstused initialization to not exceed the maximum value of
an unsigned short. This avoids the overflow to 0 and allows firstused to
be updated appropriately on subsequent xattr addition. Also update the
freemap size calculation to use the actual block size rather than the
potentially minimized version stored in firstused.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 15105db..dc7bda3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -970,7 +970,8 @@ xfs_attr3_leaf_create(
 	memset(leaf, 0, args->geo->blksize);
 
 	memset(&ichdr, 0, sizeof(ichdr));
-	ichdr.firstused = args->geo->blksize;
+	/* firstused is 16-bit */
+	ichdr.firstused = min_t(int, USHRT_MAX, args->geo->blksize);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
@@ -986,7 +987,7 @@ xfs_attr3_leaf_create(
 		ichdr.magic = XFS_ATTR_LEAF_MAGIC;
 		ichdr.freemap[0].base = sizeof(struct xfs_attr_leaf_hdr);
 	}
-	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
+	ichdr.freemap[0].size = args->geo->blksize - ichdr.freemap[0].base;
 
 	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp, 0, args->geo->blksize - 1);
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

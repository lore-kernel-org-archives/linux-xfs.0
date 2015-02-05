Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2EC777FEF
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 15:50:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E176304039
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 13:50:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jRNwBO7nOVr0Zl9y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 13:50:25 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t15LoO6Y009546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 16:50:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t15LoOr7008232
	for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 16:50:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] repair: fix v5 sb ino alignment calculation for large
	blocksizes
Date: Thu,  5 Feb 2015 16:50:22 -0500
Message-Id: <1423173023-54866-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423173023-54866-1-git-send-email-bfoster@redhat.com>
References: <1423173023-54866-1-git-send-email-bfoster@redhat.com>
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

xfs_repair validates the superblock inode alignment field against
several possible valid values. On v5 superblocks, the inode alignment
can be scaled up based on the inode size in relation to the minimum
inode size.

If the block size is larger than the default cluster size (consider
large page size arches such as ppc64), the initial alignment value
calculates to zero. If the inode size is large enough such that
sb_inoalignmt is not zero, sb_validate_ino_align() scales the align
value by the factor of inode size increase. If align is zero, however,
we multiply by zero, the subsequent check incorrectly fails and the
overall superblock verification fails as well. To reproduce, format an
fs as follows on ppc64 and run xfs_repair:

	mkfs.xfs -f -m crc=1 -b size=64k -i size=2k <dev>

Fix the scaled alignment calculation by scaling the default cluster size
appropriately to avoid a multiplication by zero.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/sb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/repair/sb.c b/repair/sb.c
index ad27756..2805fbd 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -196,7 +196,8 @@ sb_validate_ino_align(struct xfs_sb *sb)
 	if (!xfs_sb_version_hascrc(sb))
 		return false;
 
-	align *= sb->sb_inodesize / XFS_DINODE_MIN_SIZE;
+	align = (XFS_INODE_BIG_CLUSTER_SIZE *
+		 sb->sb_inodesize / XFS_DINODE_MIN_SIZE) >> sb->sb_blocklog;
 	if (align == sb->sb_inoalignmt)
 		return true;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

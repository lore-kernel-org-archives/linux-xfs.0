Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDF637F6B
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9EF04304051
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XCdG35ezr7It4aHV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 926B13672A3
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:05 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig572019624
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 26/28] repair: handle sparse inode alignment
Date: Tue,  2 Jun 2015 14:41:59 -0400
Message-Id: <1433270521-62026-27-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

Sparse inode support requires inode alignment to match inode chunk size.
xfs_repair currently expects inode alignment to match the default
cluster size or a scaled factor thereof.

Update sb_validate_ino_align() to consider the superblock valid if
sparse inode support is enabled and alignment matches the chunk size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/sb.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index 03be5e8..a291b3e 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -170,12 +170,13 @@ find_secondary_sb(xfs_sb_t *rsb)
 }
 
 /*
- * Calculate what inode alignment field ought to be
- * based on internal superblock info and determine if it is valid.
+ * Calculate what the inode alignment field ought to be based on internal
+ * superblock info and determine if it is valid.
  *
- * For v5 superblocks, the inode alignment will either match that of the
- * standard XFS_INODE_BIG_CLUSTER_SIZE, or it will be scaled based on the inode
- * size. Either value is valid in this case.
+ * For standard v5 superblocks, the inode alignment must either match
+ * XFS_INODE_BIG_CLUSTER_SIZE or a multiple based on the inode size. For v5
+ * superblocks with sparse inode chunks enabled, inode alignment must match the
+ * inode chunk size.
  *
  * Return true if the alignment is valid, false otherwise.
  */
@@ -201,6 +202,20 @@ sb_validate_ino_align(struct xfs_sb *sb)
 	if (align == sb->sb_inoalignmt)
 		return true;
 
+	/*
+	 * Sparse inodes requires inoalignmt to match full inode chunk size and
+	 * spino_align to match the scaled alignment (as calculated above).
+	 */
+	if (xfs_sb_version_hassparseinodes(sb)) {
+		if (align != sb->sb_spino_align)
+			return false;
+
+		align = (sb->sb_inodesize * XFS_INODES_PER_CHUNK)
+			>> sb->sb_blocklog;
+		if (align == sb->sb_inoalignmt)
+			return true;
+	}
+
 	return false;
 }
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

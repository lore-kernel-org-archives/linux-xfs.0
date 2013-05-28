Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9265A7CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 03:37:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7142F8F8049
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 01:37:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NiO9tApbkQApf0nV for <xfs@oss.sgi.com>;
	Tue, 28 May 2013 01:37:20 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UhFPB-0002bk-9N
	for xfs@oss.sgi.com; Tue, 28 May 2013 18:37:17 +1000
Date: Tue, 28 May 2013 18:37:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/9] xfs: fix dir3 freespace block corruption
Message-ID: <20130528083717.GU29466@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When the directory freespace index grows to a second block (2017
4k data blocks in the directory), the initialisation of the second
new block header goes wrong. The write verifier fires a corruption
error indicating that the block number in the header is zero. This
was being tripped by xfs/110.

The problem is that the initialisation of the new block is done just
fine in xfs_dir3_free_get_buf(), but the caller then users a dirv2
structure to zero on-disk header fields that xfs_dir3_free_get_buf()
has already zeroed. These lined up with the block number in the dir
v3 header format.

While looking at this, I noticed that the struct xfs_dir3_free_hdr()
had 4 bytes of padding in it that wasn't defined as padding or being
zeroed by the initialisation. Add a pad field declaration and fully
zero the on disk and in-core headers in xfs_dir3_free_get_buf() so
that this is never an issue in the future. Note that this doesn't
change the on-disk layout, just makes the 32 bits of padding in the
layout explicit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_format.h |    1 +
 fs/xfs/xfs_dir2_node.c   |   13 ++++++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index a3b1bd8..995f1f5 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -715,6 +715,7 @@ struct xfs_dir3_free_hdr {
 	__be32			firstdb;	/* db of first entry */
 	__be32			nvalid;		/* count of valid entries */
 	__be32			nused;		/* count of used entries */
+	__be32			pad;		/* 64 bit alignment. */
 };
 
 struct xfs_dir3_free {
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 5246de4..2226a00 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -263,18 +263,19 @@ xfs_dir3_free_get_buf(
 	 * Initialize the new block to be empty, and remember
 	 * its first slot as our empty slot.
 	 */
-	hdr.magic = XFS_DIR2_FREE_MAGIC;
-	hdr.firstdb = 0;
-	hdr.nused = 0;
-	hdr.nvalid = 0;
+	memset(bp->b_addr, 0, sizeof(struct xfs_dir3_free_hdr));
+	memset(&hdr, 0, sizeof(hdr));
+
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		hdr.magic = XFS_DIR3_FREE_MAGIC;
+
 		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
 		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
-	}
+	} else
+		hdr.magic = XFS_DIR2_FREE_MAGIC;
 	xfs_dir3_free_hdr_to_disk(bp->b_addr, &hdr);
 	*bpp = bp;
 	return 0;
@@ -1921,8 +1922,6 @@ xfs_dir2_node_addname_int(
 			 */
 			freehdr.firstdb = (fbno - XFS_DIR2_FREE_FIRSTDB(mp)) *
 					xfs_dir3_free_max_bests(mp);
-			free->hdr.nvalid = 0;
-			free->hdr.nused = 0;
 		} else {
 			free = fbp->b_addr;
 			bests = xfs_dir3_free_bests_p(mp, free);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E192B7CB1
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CDE28F8040
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sCMmM0Vcp14bEQPr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:03 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 13/45] btrfs: update __btrfs_map_block for REQ_OP transition
Date: Sun,  5 Jun 2016 14:31:53 -0500
Message-Id: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
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
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

We no longer pass in a bitmap of rq_flag_bits bits to __btrfs_map_block.
It will always be a REQ_OP, or the btrfs specific REQ_GET_READ_MIRRORS,
so this drops the bit tests.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/volumes.c     | 55 +++++++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h     |  4 ++--
 4 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a400951..70af591 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2043,7 +2043,7 @@ int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
 
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(root->fs_info, REQ_DISCARD,
+	ret = btrfs_map_block(root->fs_info, REQ_OP_DISCARD,
 			      bytenr, &num_bytes, &bbio, 0);
 	/* Error condition is -ENOMEM */
 	if (!ret) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b07e1d9..1575944 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1838,7 +1838,7 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 
 	length = bio->bi_iter.bi_size;
 	map_length = length;
-	ret = btrfs_map_block(root->fs_info, rw, logical,
+	ret = btrfs_map_block(root->fs_info, bio_op(bio), logical,
 			      &map_length, NULL, 0);
 	/* Will always return 0 with map_multi == NULL */
 	BUG_ON(ret < 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4dc2249..345b183 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5248,7 +5248,7 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
 		kfree(bbio);
 }
 
-static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
+static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 			     u64 logical, u64 *length,
 			     struct btrfs_bio **bbio_ret,
 			     int mirror_num, int need_raid_map)
@@ -5334,7 +5334,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		raid56_full_stripe_start *= full_stripe_len;
 	}
 
-	if (rw & REQ_DISCARD) {
+	if (op == REQ_OP_DISCARD) {
 		/* we don't discard raid56 yet */
 		if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 			ret = -EOPNOTSUPP;
@@ -5347,7 +5347,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		   For other RAID types and for RAID[56] reads, just allow a single
 		   stripe (on a single disk). */
 		if ((map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
-		    (rw & REQ_WRITE)) {
+		    (op == REQ_OP_WRITE)) {
 			max_len = stripe_len * nr_data_stripes(map) -
 				(offset - raid56_full_stripe_start);
 		} else {
@@ -5372,8 +5372,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
-	    !(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)) &&
-	    dev_replace->tgtdev != NULL) {
+	    op != REQ_OP_WRITE && op != REQ_OP_DISCARD &&
+	    op != REQ_GET_READ_MIRRORS && dev_replace->tgtdev != NULL) {
 		/*
 		 * in dev-replace case, for repair case (that's the only
 		 * case where the mirror is selected explicitly when
@@ -5460,15 +5460,17 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			    (offset + *length);
 
 	if (map->type & BTRFS_BLOCK_GROUP_RAID0) {
-		if (rw & REQ_DISCARD)
+		if (op == REQ_OP_DISCARD)
 			num_stripes = min_t(u64, map->num_stripes,
 					    stripe_nr_end - stripe_nr_orig);
 		stripe_nr = div_u64_rem(stripe_nr, map->num_stripes,
 				&stripe_index);
-		if (!(rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)))
+		if (op != REQ_OP_WRITE && op != REQ_OP_DISCARD &&
+		    op != REQ_GET_READ_MIRRORS)
 			mirror_num = 1;
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS))
+		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD ||
+		    op == REQ_GET_READ_MIRRORS)
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -5481,7 +5483,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_DUP) {
-		if (rw & (REQ_WRITE | REQ_DISCARD | REQ_GET_READ_MIRRORS)) {
+		if (op == REQ_OP_WRITE || REQ_OP_DISCARD ||
+		    op == REQ_GET_READ_MIRRORS) {
 			num_stripes = map->num_stripes;
 		} else if (mirror_num) {
 			stripe_index = mirror_num - 1;
@@ -5495,9 +5498,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		stripe_nr = div_u64_rem(stripe_nr, factor, &stripe_index);
 		stripe_index *= map->sub_stripes;
 
-		if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
+		if (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS)
 			num_stripes = map->sub_stripes;
-		else if (rw & REQ_DISCARD)
+		else if (op == REQ_OP_DISCARD)
 			num_stripes = min_t(u64, map->sub_stripes *
 					    (stripe_nr_end - stripe_nr_orig),
 					    map->num_stripes);
@@ -5515,7 +5518,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	} else if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
 		if (need_raid_map &&
-		    ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
+		    (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS ||
 		     mirror_num > 1)) {
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = div_u64(raid56_full_stripe_start,
@@ -5543,8 +5546,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			/* We distribute the parity blocks across stripes */
 			div_u64_rem(stripe_nr + stripe_index, map->num_stripes,
 					&stripe_index);
-			if (!(rw & (REQ_WRITE | REQ_DISCARD |
-				    REQ_GET_READ_MIRRORS)) && mirror_num <= 1)
+			if ((op != REQ_OP_WRITE && op != REQ_OP_DISCARD &&
+			    op != REQ_GET_READ_MIRRORS) && mirror_num <= 1)
 				mirror_num = 1;
 		}
 	} else {
@@ -5567,9 +5570,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	num_alloc_stripes = num_stripes;
 	if (dev_replace_is_ongoing) {
-		if (rw & (REQ_WRITE | REQ_DISCARD))
+		if (op == REQ_OP_WRITE || op == REQ_OP_DISCARD)
 			num_alloc_stripes <<= 1;
-		if (rw & REQ_GET_READ_MIRRORS)
+		if (op == REQ_GET_READ_MIRRORS)
 			num_alloc_stripes++;
 		tgtdev_indexes = num_stripes;
 	}
@@ -5584,7 +5587,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	/* build raid_map */
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK &&
-	    need_raid_map && ((rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) ||
+	    need_raid_map &&
+	    ((op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS) ||
 	    mirror_num > 1)) {
 		u64 tmp;
 		unsigned rot;
@@ -5609,7 +5613,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				RAID6_Q_STRIPE;
 	}
 
-	if (rw & REQ_DISCARD) {
+	if (op == REQ_OP_DISCARD) {
 		u32 factor = 0;
 		u32 sub_stripes = 0;
 		u64 stripes_per_dev = 0;
@@ -5689,14 +5693,15 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		}
 	}
 
-	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
+	if (op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS)
 		max_errors = btrfs_chunk_max_errors(map);
 
 	if (bbio->raid_map)
 		sort_parity_stripes(bbio, num_stripes);
 
 	tgtdev_indexes = 0;
-	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)) &&
+	if (dev_replace_is_ongoing &&
+	   (op == REQ_OP_WRITE || op == REQ_OP_DISCARD) &&
 	    dev_replace->tgtdev != NULL) {
 		int index_where_to_add;
 		u64 srcdev_devid = dev_replace->srcdev->devid;
@@ -5731,7 +5736,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			}
 		}
 		num_stripes = index_where_to_add;
-	} else if (dev_replace_is_ongoing && (rw & REQ_GET_READ_MIRRORS) &&
+	} else if (dev_replace_is_ongoing && (op == REQ_GET_READ_MIRRORS) &&
 		   dev_replace->tgtdev != NULL) {
 		u64 srcdev_devid = dev_replace->srcdev->devid;
 		int index_srcdev = 0;
@@ -5806,21 +5811,21 @@ out:
 	return ret;
 }
 
-int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		      u64 logical, u64 *length,
 		      struct btrfs_bio **bbio_ret, int mirror_num)
 {
-	return __btrfs_map_block(fs_info, rw, logical, length, bbio_ret,
+	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret,
 				 mirror_num, 0);
 }
 
 /* For Scrub/replace */
-int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int rw,
+int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int op,
 		     u64 logical, u64 *length,
 		     struct btrfs_bio **bbio_ret, int mirror_num,
 		     int need_raid_map)
 {
-	return __btrfs_map_block(fs_info, rw, logical, length, bbio_ret,
+	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret,
 				 mirror_num, need_raid_map);
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0ac90f8..3b78700 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -375,10 +375,10 @@ int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 void btrfs_get_bbio(struct btrfs_bio *bbio);
 void btrfs_put_bbio(struct btrfs_bio *bbio);
-int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
+int btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 		    u64 logical, u64 *length,
 		    struct btrfs_bio **bbio_ret, int mirror_num);
-int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int rw,
+int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int op,
 		     u64 logical, u64 *length,
 		     struct btrfs_bio **bbio_ret, int mirror_num,
 		     int need_raid_map);
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

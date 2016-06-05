Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A3BDB7CB6
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14BDFAC004
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Lwg9IDOgm5Ffwfxc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:14 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 18/45] hfsplus: use bio op accessors
Date: Sun,  5 Jun 2016 14:31:58 -0500
Message-Id: <1465155145-10812-19-git-send-email-mchristi@redhat.com>
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

Separate the op from the rq_flag_bits and have gfs2
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/hfsplus/hfsplus_fs.h |  2 +-
 fs/hfsplus/part_tbl.c   |  5 +++--
 fs/hfsplus/super.c      |  6 ++++--
 fs/hfsplus/wrapper.c    | 14 ++++++++------
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index fdc3446..047245b 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -526,7 +526,7 @@ int hfsplus_compare_dentry(const struct dentry *parent,
 
 /* wrapper.c */
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector, void *buf,
-		       void **data, int rw);
+		       void **data, int op, int op_flags);
 int hfsplus_read_wrapper(struct super_block *sb);
 
 /* time macros */
diff --git a/fs/hfsplus/part_tbl.c b/fs/hfsplus/part_tbl.c
index eb355d8..63164eb 100644
--- a/fs/hfsplus/part_tbl.c
+++ b/fs/hfsplus/part_tbl.c
@@ -112,7 +112,8 @@ static int hfs_parse_new_pmap(struct super_block *sb, void *buf,
 		if ((u8 *)pm - (u8 *)buf >= buf_size) {
 			res = hfsplus_submit_bio(sb,
 						 *part_start + HFS_PMAP_BLK + i,
-						 buf, (void **)&pm, READ);
+						 buf, (void **)&pm, REQ_OP_READ,
+						 0);
 			if (res)
 				return res;
 		}
@@ -136,7 +137,7 @@ int hfs_part_find(struct super_block *sb,
 		return -ENOMEM;
 
 	res = hfsplus_submit_bio(sb, *part_start + HFS_PMAP_BLK,
-				 buf, &data, READ);
+				 buf, &data, REQ_OP_READ, 0);
 	if (res)
 		goto out;
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 755bf30..11854dd 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -220,7 +220,8 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 
 	error2 = hfsplus_submit_bio(sb,
 				   sbi->part_start + HFSPLUS_VOLHEAD_SECTOR,
-				   sbi->s_vhdr_buf, NULL, WRITE_SYNC);
+				   sbi->s_vhdr_buf, NULL, REQ_OP_WRITE,
+				   WRITE_SYNC);
 	if (!error)
 		error = error2;
 	if (!write_backup)
@@ -228,7 +229,8 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 
 	error2 = hfsplus_submit_bio(sb,
 				  sbi->part_start + sbi->sect_count - 2,
-				  sbi->s_backup_vhdr_buf, NULL, WRITE_SYNC);
+				  sbi->s_backup_vhdr_buf, NULL, REQ_OP_WRITE,
+				  WRITE_SYNC);
 	if (!error)
 		error2 = error;
 out:
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index d026bb3..ebb85e5 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -30,7 +30,8 @@ struct hfsplus_wd {
  * @sector: block to read or write, for blocks of HFSPLUS_SECTOR_SIZE bytes
  * @buf: buffer for I/O
  * @data: output pointer for location of requested data
- * @rw: direction of I/O
+ * @op: direction of I/O
+ * @op_flags: request op flags
  *
  * The unit of I/O is hfsplus_min_io_size(sb), which may be bigger than
  * HFSPLUS_SECTOR_SIZE, and @buf must be sized accordingly. On reads
@@ -44,7 +45,7 @@ struct hfsplus_wd {
  * will work correctly.
  */
 int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
-		void *buf, void **data, int rw)
+		       void *buf, void **data, int op, int op_flags)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -65,9 +66,9 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
-	bio->bi_rw = rw;
+	bio_set_op_attrs(bio, op, op_flags);
 
-	if (!(rw & WRITE) && data)
+	if (op != WRITE && data)
 		*data = (u8 *)buf + offset;
 
 	while (io_size > 0) {
@@ -182,7 +183,7 @@ int hfsplus_read_wrapper(struct super_block *sb)
 reread:
 	error = hfsplus_submit_bio(sb, part_start + HFSPLUS_VOLHEAD_SECTOR,
 				   sbi->s_vhdr_buf, (void **)&sbi->s_vhdr,
-				   READ);
+				   REQ_OP_READ, 0);
 	if (error)
 		goto out_free_backup_vhdr;
 
@@ -214,7 +215,8 @@ reread:
 
 	error = hfsplus_submit_bio(sb, part_start + part_size - 2,
 				   sbi->s_backup_vhdr_buf,
-				   (void **)&sbi->s_backup_vhdr, READ);
+				   (void **)&sbi->s_backup_vhdr, REQ_OP_READ,
+				   0);
 	if (error)
 		goto out_free_backup_vhdr;
 
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

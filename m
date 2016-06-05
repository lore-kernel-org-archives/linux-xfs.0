Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDAA77CED
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:33:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79126AC002
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:33:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MTxramBMKfIVL70e (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:33:07 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 15/45] f2fs: use bio op accessors
Date: Sun,  5 Jun 2016 14:31:55 -0500
Message-Id: <1465155145-10812-16-git-send-email-mchristi@redhat.com>
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

Separate the op from the rq_flag_bits and have f2fs
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/f2fs/checkpoint.c        | 10 ++++++----
 fs/f2fs/data.c              | 47 ++++++++++++++++++++++++++-------------------
 fs/f2fs/f2fs.h              |  5 +++--
 fs/f2fs/gc.c                |  9 ++++++---
 fs/f2fs/inline.c            |  3 ++-
 fs/f2fs/node.c              |  8 +++++---
 fs/f2fs/segment.c           | 12 +++++++-----
 fs/f2fs/trace.c             |  7 ++++---
 include/trace/events/f2fs.h | 34 +++++++++++++++++++-------------
 9 files changed, 81 insertions(+), 54 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 3891600..b6d600e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -63,14 +63,15 @@ static struct page *__get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC | REQ_META | REQ_PRIO,
 		.old_blkaddr = index,
 		.new_blkaddr = index,
 		.encrypted_page = NULL,
 	};
 
 	if (unlikely(!is_meta))
-		fio.rw &= ~REQ_META;
+		fio.op_flags &= ~REQ_META;
 repeat:
 	page = f2fs_grab_cache_page(mapping, index, false);
 	if (!page) {
@@ -157,13 +158,14 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = sync ? (READ_SYNC | REQ_META | REQ_PRIO) : READA,
+		.op = REQ_OP_READ,
+		.op_flags = sync ? (READ_SYNC | REQ_META | REQ_PRIO) : READA,
 		.encrypted_page = NULL,
 	};
 	struct blk_plug plug;
 
 	if (unlikely(type == META_POR))
-		fio.rw &= ~REQ_META;
+		fio.op_flags &= ~REQ_META;
 
 	blk_start_plug(&plug);
 	for (; nrpages-- > 0; blkno++) {
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c595c8f..8769e83 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -97,12 +97,10 @@ static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
 	return bio;
 }
 
-static inline void __submit_bio(struct f2fs_sb_info *sbi, int rw,
-						struct bio *bio)
+static inline void __submit_bio(struct f2fs_sb_info *sbi, struct bio *bio)
 {
-	if (!is_read_io(rw))
+	if (!is_read_io(bio_op(bio)))
 		atomic_inc(&sbi->nr_wb_bios);
-	bio->bi_rw = rw;
 	submit_bio(bio);
 }
 
@@ -113,12 +111,14 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	if (!io->bio)
 		return;
 
-	if (is_read_io(fio->rw))
+	if (is_read_io(fio->op))
 		trace_f2fs_submit_read_bio(io->sbi->sb, fio, io->bio);
 	else
 		trace_f2fs_submit_write_bio(io->sbi->sb, fio, io->bio);
 
-	__submit_bio(io->sbi, fio->rw, io->bio);
+	bio_set_op_attrs(io->bio, fio->op, fio->op_flags);
+
+	__submit_bio(io->sbi, io->bio);
 	io->bio = NULL;
 }
 
@@ -184,10 +184,12 @@ static void __f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 	/* change META to META_FLUSH in the checkpoint procedure */
 	if (type >= META_FLUSH) {
 		io->fio.type = META_FLUSH;
+		io->fio.op = REQ_OP_WRITE;
 		if (test_opt(sbi, NOBARRIER))
-			io->fio.rw = WRITE_FLUSH | REQ_META | REQ_PRIO;
+			io->fio.op_flags = WRITE_FLUSH | REQ_META | REQ_PRIO;
 		else
-			io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
+			io->fio.op_flags = WRITE_FLUSH_FUA | REQ_META |
+								REQ_PRIO;
 	}
 	__submit_merged_bio(io);
 out:
@@ -229,14 +231,16 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	f2fs_trace_ios(fio, 0);
 
 	/* Allocate a new bio */
-	bio = __bio_alloc(fio->sbi, fio->new_blkaddr, 1, is_read_io(fio->rw));
+	bio = __bio_alloc(fio->sbi, fio->new_blkaddr, 1, is_read_io(fio->op));
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		bio_put(bio);
 		return -EFAULT;
 	}
+	bio->bi_rw = fio->op_flags;
+	bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
-	__submit_bio(fio->sbi, fio->rw, bio);
+	__submit_bio(fio->sbi, bio);
 	return 0;
 }
 
@@ -245,7 +249,7 @@ void f2fs_submit_page_mbio(struct f2fs_io_info *fio)
 	struct f2fs_sb_info *sbi = fio->sbi;
 	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
 	struct f2fs_bio_info *io;
-	bool is_read = is_read_io(fio->rw);
+	bool is_read = is_read_io(fio->op);
 	struct page *bio_page;
 
 	io = is_read ? &sbi->read_io : &sbi->write_io[btype];
@@ -257,7 +261,7 @@ void f2fs_submit_page_mbio(struct f2fs_io_info *fio)
 	down_write(&io->io_rwsem);
 
 	if (io->bio && (io->last_block_in_bio != fio->new_blkaddr - 1 ||
-						io->fio.rw != fio->rw))
+	    (io->fio.op != fio->op || io->fio.op_flags != fio->op_flags)))
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
@@ -391,7 +395,7 @@ int f2fs_get_block(struct dnode_of_data *dn, pgoff_t index)
 }
 
 struct page *get_read_data_page(struct inode *inode, pgoff_t index,
-						int rw, bool for_write)
+						int op_flags, bool for_write)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct dnode_of_data dn;
@@ -401,7 +405,8 @@ struct page *get_read_data_page(struct inode *inode, pgoff_t index,
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.type = DATA,
-		.rw = rw,
+		.op = REQ_OP_READ,
+		.op_flags = op_flags,
 		.encrypted_page = NULL,
 	};
 
@@ -1052,7 +1057,7 @@ got_it:
 		 */
 		if (bio && (last_block_in_bio != block_nr - 1)) {
 submit_and_realloc:
-			__submit_bio(F2FS_I_SB(inode), READ, bio);
+			__submit_bio(F2FS_I_SB(inode), bio);
 			bio = NULL;
 		}
 		if (bio == NULL) {
@@ -1081,7 +1086,7 @@ submit_and_realloc:
 			bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(block_nr);
 			bio->bi_end_io = f2fs_read_end_io;
 			bio->bi_private = ctx;
-			bio->bi_rw = READ;
+			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		}
 
 		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
@@ -1096,7 +1101,7 @@ set_error_page:
 		goto next_page;
 confused:
 		if (bio) {
-			__submit_bio(F2FS_I_SB(inode), READ, bio);
+			__submit_bio(F2FS_I_SB(inode), bio);
 			bio = NULL;
 		}
 		unlock_page(page);
@@ -1106,7 +1111,7 @@ next_page:
 	}
 	BUG_ON(pages && !list_empty(pages));
 	if (bio)
-		__submit_bio(F2FS_I_SB(inode), READ, bio);
+		__submit_bio(F2FS_I_SB(inode), bio);
 	return 0;
 }
 
@@ -1223,7 +1228,8 @@ static int f2fs_write_data_page(struct page *page,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = DATA,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
+		.op = REQ_OP_WRITE,
+		.op_flags = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0,
 		.page = page,
 		.encrypted_page = NULL,
 	};
@@ -1664,7 +1670,8 @@ repeat:
 		struct f2fs_io_info fio = {
 			.sbi = sbi,
 			.type = DATA,
-			.rw = READ_SYNC,
+			.op = REQ_OP_READ,
+			.op_flags = READ_SYNC,
 			.old_blkaddr = blkaddr,
 			.new_blkaddr = blkaddr,
 			.page = page,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 916e7c2..23ae6a8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -686,14 +686,15 @@ enum page_type {
 struct f2fs_io_info {
 	struct f2fs_sb_info *sbi;	/* f2fs_sb_info pointer */
 	enum page_type type;	/* contains DATA/NODE/META/META_FLUSH */
-	int rw;			/* contains R/RS/W/WS with REQ_META/REQ_PRIO */
+	int op;			/* contains REQ_OP_ */
+	int op_flags;		/* rq_flag_bits */
 	block_t new_blkaddr;	/* new block address to be written */
 	block_t old_blkaddr;	/* old block address before Cow */
 	struct page *page;	/* page to be written */
 	struct page *encrypted_page;	/* encrypted page */
 };
 
-#define is_read_io(rw)	(((rw) & 1) == READ)
+#define is_read_io(rw) (rw == READ)
 struct f2fs_bio_info {
 	struct f2fs_sb_info *sbi;	/* f2fs superblock */
 	struct bio *bio;		/* bios to merge */
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 38d56f6..3649d86 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -538,7 +538,8 @@ static void move_encrypted_block(struct inode *inode, block_t bidx)
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.type = DATA,
-		.rw = READ_SYNC,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC,
 		.encrypted_page = NULL,
 	};
 	struct dnode_of_data dn;
@@ -612,7 +613,8 @@ static void move_encrypted_block(struct inode *inode, block_t bidx)
 	/* allocate block address */
 	f2fs_wait_on_page_writeback(dn.node_page, NODE, true);
 
-	fio.rw = WRITE_SYNC;
+	fio.op = REQ_OP_WRITE;
+	fio.op_flags = WRITE_SYNC;
 	fio.new_blkaddr = newaddr;
 	f2fs_submit_page_mbio(&fio);
 
@@ -649,7 +651,8 @@ static void move_data_page(struct inode *inode, block_t bidx, int gc_type)
 		struct f2fs_io_info fio = {
 			.sbi = F2FS_I_SB(inode),
 			.type = DATA,
-			.rw = WRITE_SYNC,
+			.op = REQ_OP_WRITE,
+			.op_flags = WRITE_SYNC,
 			.page = page,
 			.encrypted_page = NULL,
 		};
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index a4bb155..c15e53c 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -108,7 +108,8 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(dn->inode),
 		.type = DATA,
-		.rw = WRITE_SYNC | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_PRIO,
 		.page = page,
 		.encrypted_page = NULL,
 	};
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1f21aae..e534039 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1070,14 +1070,15 @@ fail:
  * 0: f2fs_put_page(page, 0)
  * LOCKED_PAGE or error: f2fs_put_page(page, 1)
  */
-static int read_node_page(struct page *page, int rw)
+static int read_node_page(struct page *page, int op_flags)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	struct node_info ni;
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = NODE,
-		.rw = rw,
+		.op = REQ_OP_READ,
+		.op_flags = op_flags,
 		.page = page,
 		.encrypted_page = NULL,
 	};
@@ -1568,7 +1569,8 @@ static int f2fs_write_node_page(struct page *page,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = NODE,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
+		.op = REQ_OP_WRITE,
+		.op_flags = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0,
 		.page = page,
 		.encrypted_page = NULL,
 	};
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3fe2fab..4c2d1fa 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -257,7 +257,8 @@ static int __commit_inmem_pages(struct inode *inode,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = DATA,
-		.rw = WRITE_SYNC | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_PRIO,
 		.encrypted_page = NULL,
 	};
 	bool submit_bio = false;
@@ -406,7 +407,7 @@ repeat:
 		fcc->dispatch_list = llist_reverse_order(fcc->dispatch_list);
 
 		bio->bi_bdev = sbi->sb->s_bdev;
-		bio->bi_rw = WRITE_FLUSH;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_FLUSH);
 		ret = submit_bio_wait(bio);
 
 		llist_for_each_entry_safe(cmd, next,
@@ -439,7 +440,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 		int ret;
 
 		bio->bi_bdev = sbi->sb->s_bdev;
-		bio->bi_rw = WRITE_FLUSH;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_FLUSH);
 		ret = submit_bio_wait(bio);
 		bio_put(bio);
 		return ret;
@@ -1403,7 +1404,8 @@ void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = WRITE_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_META | REQ_PRIO,
 		.old_blkaddr = page->index,
 		.new_blkaddr = page->index,
 		.page = page,
@@ -1411,7 +1413,7 @@ void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 	};
 
 	if (unlikely(page->index >= MAIN_BLKADDR(sbi)))
-		fio.rw &= ~REQ_META;
+		fio.op_flags &= ~REQ_META;
 
 	set_page_writeback(page);
 	f2fs_submit_page_mbio(&fio);
diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index 562ce08..73b4e1d 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -25,11 +25,11 @@ static inline void __print_last_io(void)
 	if (!last_io.len)
 		return;
 
-	trace_printk("%3x:%3x %4x %-16s %2x %5x %12x %4x\n",
+	trace_printk("%3x:%3x %4x %-16s %2x %5x %5x %12x %4x\n",
 			last_io.major, last_io.minor,
 			last_io.pid, "----------------",
 			last_io.type,
-			last_io.fio.rw,
+			last_io.fio.op, last_io.fio.op_flags,
 			last_io.fio.new_blkaddr,
 			last_io.len);
 	memset(&last_io, 0, sizeof(last_io));
@@ -101,7 +101,8 @@ void f2fs_trace_ios(struct f2fs_io_info *fio, int flush)
 	if (last_io.major == major && last_io.minor == minor &&
 			last_io.pid == pid &&
 			last_io.type == __file_type(inode, pid) &&
-			last_io.fio.rw == fio->rw &&
+			last_io.fio.op == fio->op &&
+			last_io.fio.op_flags == fio->op_flags &&
 			last_io.fio.new_blkaddr + last_io.len ==
 							fio->new_blkaddr) {
 		last_io.len++;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 3a09bb4..733b896 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -56,17 +56,21 @@ TRACE_DEFINE_ENUM(CP_DISCARD);
 		{ IPU,		"IN-PLACE" },				\
 		{ OPU,		"OUT-OF-PLACE" })
 
-#define F2FS_BIO_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
+#define F2FS_BIO_FLAG_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
 #define F2FS_BIO_EXTRA_MASK(t)	(t & (REQ_META | REQ_PRIO))
 
-#define show_bio_type(type)	show_bio_base(type), show_bio_extra(type)
+#define show_bio_type(op, op_flags) show_bio_op(op),			\
+			show_bio_op_flags(op_flags), show_bio_extra(op_flags)
 
-#define show_bio_base(type)						\
-	__print_symbolic(F2FS_BIO_MASK(type),				\
+#define show_bio_op(op)							\
+	__print_symbolic(op,						\
 		{ READ, 		"READ" },			\
+		{ WRITE,		"WRITE" })
+
+#define show_bio_op_flags(flags)					\
+	__print_symbolic(F2FS_BIO_FLAG_MASK(flags),			\
 		{ READA, 		"READAHEAD" },			\
 		{ READ_SYNC, 		"READ_SYNC" },			\
-		{ WRITE, 		"WRITE" },			\
 		{ WRITE_SYNC, 		"WRITE_SYNC" },			\
 		{ WRITE_FLUSH,		"WRITE_FLUSH" },		\
 		{ WRITE_FUA, 		"WRITE_FUA" },			\
@@ -734,7 +738,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__field(pgoff_t, index)
 		__field(block_t, old_blkaddr)
 		__field(block_t, new_blkaddr)
-		__field(int, rw)
+		__field(int, op)
+		__field(int, op_flags)
 		__field(int, type)
 	),
 
@@ -744,17 +749,18 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__entry->index		= page->index;
 		__entry->old_blkaddr	= fio->old_blkaddr;
 		__entry->new_blkaddr	= fio->new_blkaddr;
-		__entry->rw		= fio->rw;
+		__entry->op		= fio->op;
+		__entry->op_flags	= fio->op_flags;
 		__entry->type		= fio->type;
 	),
 
 	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
-		"oldaddr = 0x%llx, newaddr = 0x%llx rw = %s%s, type = %s",
+		"oldaddr = 0x%llx, newaddr = 0x%llx rw = %s%si%s, type = %s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
 		(unsigned long long)__entry->old_blkaddr,
 		(unsigned long long)__entry->new_blkaddr,
-		show_bio_type(__entry->rw),
+		show_bio_type(__entry->op, __entry->op_flags),
 		show_block_type(__entry->type))
 );
 
@@ -785,7 +791,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(int,	rw)
+		__field(int,	op)
+		__field(int,	op_flags)
 		__field(int,	type)
 		__field(sector_t,	sector)
 		__field(unsigned int,	size)
@@ -793,15 +800,16 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->rw		= fio->rw;
+		__entry->op		= fio->op;
+		__entry->op_flags	= fio->op_flags;
 		__entry->type		= fio->type;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->size		= bio->bi_iter.bi_size;
 	),
 
-	TP_printk("dev = (%d,%d), %s%s, %s, sector = %lld, size = %u",
+	TP_printk("dev = (%d,%d), %s%s%s, %s, sector = %lld, size = %u",
 		show_dev(__entry),
-		show_bio_type(__entry->rw),
+		show_bio_type(__entry->op, __entry->op_flags),
 		show_block_type(__entry->type),
 		(unsigned long long)__entry->sector,
 		__entry->size)
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

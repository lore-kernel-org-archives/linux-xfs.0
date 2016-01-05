Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA43129E26
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:54:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 844448F804C
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:54:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3YWG30UvP1OamL74 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 12:54:16 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 11/35] f2fs: set bi_op to REQ_OP
Date: Tue,  5 Jan 2016 14:53:14 -0600
Message-Id: <1452027218-32303-12-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
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

This patch has f2fs set the bio bi_op to a REQ_OP, and
rq_flag_bits to bi_rw.

This patch is compile tested only.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/f2fs/checkpoint.c        | 10 ++++++----
 fs/f2fs/data.c              | 33 ++++++++++++++++++++-------------
 fs/f2fs/f2fs.h              |  5 +++--
 fs/f2fs/gc.c                |  9 ++++++---
 fs/f2fs/inline.c            |  3 ++-
 fs/f2fs/node.c              |  8 +++++---
 fs/f2fs/segment.c           | 10 +++++++---
 fs/f2fs/trace.c             |  8 +++++---
 include/trace/events/f2fs.h | 34 +++++++++++++++++++++-------------
 9 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index fdd43f7..92d05d8 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -55,13 +55,14 @@ static struct page *__get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = READ_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC | REQ_META | REQ_PRIO,
 		.blk_addr = index,
 		.encrypted_page = NULL,
 	};
 
 	if (unlikely(!is_meta))
-		fio.rw &= ~REQ_META;
+		fio.op_flags &= ~REQ_META;
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
@@ -149,12 +150,13 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = sync ? (READ_SYNC | REQ_META | REQ_PRIO) : READA,
+		.op = REQ_OP_READ,
+		.op_flags = sync ? (READ_SYNC | REQ_META | REQ_PRIO) : READA,
 		.encrypted_page = NULL,
 	};
 
 	if (unlikely(type == META_POR))
-		fio.rw &= ~REQ_META;
+		fio.op_flags &= ~REQ_META;
 
 	for (; nrpages-- > 0; blkno++) {
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5325408..14757cb 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -107,11 +107,12 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 	if (!io->bio)
 		return;
 
-	if (is_read_io(fio->rw))
+	if (is_read_io(fio->op))
 		trace_f2fs_submit_read_bio(io->sbi->sb, fio, io->bio);
 	else
 		trace_f2fs_submit_write_bio(io->sbi->sb, fio, io->bio);
-	io->bio->bi_rw |= fio->rw;
+	io->bio->bi_op = fio->op;
+	io->bio->bi_rw |= fio->op_flags;
 
 	submit_bio(io->bio);
 	io->bio = NULL;
@@ -130,10 +131,12 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
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
 	up_write(&io->io_rwsem);
@@ -152,13 +155,14 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	f2fs_trace_ios(fio, 0);
 
 	/* Allocate a new bio */
-	bio = __bio_alloc(fio->sbi, fio->blk_addr, 1, is_read_io(fio->rw));
+	bio = __bio_alloc(fio->sbi, fio->blk_addr, 1, is_read_io(fio->op));
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
 		return -EFAULT;
 	}
-	bio->bi_rw |= fio->rw;
+	bio->bi_op = fio->op;
+	bio->bi_rw |= fio->op_flags;
 
 	submit_bio(bio);
 	return 0;
@@ -169,7 +173,7 @@ void f2fs_submit_page_mbio(struct f2fs_io_info *fio)
 	struct f2fs_sb_info *sbi = fio->sbi;
 	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
 	struct f2fs_bio_info *io;
-	bool is_read = is_read_io(fio->rw);
+	bool is_read = is_read_io(fio->op);
 	struct page *bio_page;
 
 	io = is_read ? &sbi->read_io : &sbi->write_io[btype];
@@ -182,7 +186,7 @@ void f2fs_submit_page_mbio(struct f2fs_io_info *fio)
 		inc_page_count(sbi, F2FS_WRITEBACK);
 
 	if (io->bio && (io->last_block_in_bio != fio->blk_addr - 1 ||
-						io->fio.rw != fio->rw))
+	    (io->fio.op != fio->op || io->fio.op_flags != fio->op_flags)))
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
@@ -278,7 +282,7 @@ int f2fs_get_block(struct dnode_of_data *dn, pgoff_t index)
 }
 
 struct page *get_read_data_page(struct inode *inode, pgoff_t index,
-						int rw, bool for_write)
+						int op_flags, bool for_write)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct dnode_of_data dn;
@@ -288,7 +292,8 @@ struct page *get_read_data_page(struct inode *inode, pgoff_t index,
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.type = DATA,
-		.rw = rw,
+		.op = REQ_OP_READ,
+		.op_flags = op_flags,
 		.encrypted_page = NULL,
 	};
 
@@ -984,7 +989,7 @@ submit_and_realloc:
 			bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(block_nr);
 			bio->bi_end_io = f2fs_read_end_io;
 			bio->bi_private = ctx;
-			bio->bi_rw |= READ;
+			bio->bi_op = REQ_OP_READ;
 		}
 
 		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
@@ -1118,7 +1123,8 @@ static int f2fs_write_data_page(struct page *page,
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = DATA,
-		.rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE,
+		.op = REQ_OP_WRITE,
+		.op_flags = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : 0,
 		.page = page,
 		.encrypted_page = NULL,
 	};
@@ -1489,7 +1495,8 @@ put_next:
 		struct f2fs_io_info fio = {
 			.sbi = sbi,
 			.type = DATA,
-			.rw = READ_SYNC,
+			.op = REQ_OP_READ,
+			.op_flags = READ_SYNC,
 			.blk_addr = dn.data_blkaddr,
 			.page = page,
 			.encrypted_page = NULL,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fda0831..6e8227b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -683,13 +683,14 @@ enum page_type {
 struct f2fs_io_info {
 	struct f2fs_sb_info *sbi;	/* f2fs_sb_info pointer */
 	enum page_type type;	/* contains DATA/NODE/META/META_FLUSH */
-	int rw;			/* contains R/RS/W/WS with REQ_META/REQ_PRIO */
+	int op;			/* contains REQ_OP_ */
+	int op_flags;		/* rq_flag_bits */
 	block_t blk_addr;	/* block address to be written */
 	struct page *page;	/* page to be written */
 	struct page *encrypted_page;	/* encrypted page */
 };
 
-#define is_read_io(rw)	(((rw) & 1) == READ)
+#define is_read_io(rw)	(rw == READ)
 struct f2fs_bio_info {
 	struct f2fs_sb_info *sbi;	/* f2fs superblock */
 	struct bio *bio;		/* bios to merge */
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ce350c4..8561cf5 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -540,7 +540,8 @@ static void move_encrypted_block(struct inode *inode, block_t bidx)
 	struct f2fs_io_info fio = {
 		.sbi = F2FS_I_SB(inode),
 		.type = DATA,
-		.rw = READ_SYNC,
+		.op = REQ_OP_READ,
+		.op_flags = READ_SYNC,
 		.encrypted_page = NULL,
 	};
 	struct dnode_of_data dn;
@@ -607,7 +608,8 @@ static void move_encrypted_block(struct inode *inode, block_t bidx)
 	f2fs_wait_on_page_writeback(dn.node_page, NODE);
 	allocate_data_block(fio.sbi, NULL, fio.blk_addr,
 					&fio.blk_addr, &sum, CURSEG_COLD_DATA);
-	fio.rw = WRITE_SYNC;
+	fio.op = REQ_OP_WRITE;
+	fio.op_flags = WRITE_SYNC;
 	f2fs_submit_page_mbio(&fio);
 
 	dn.data_blkaddr = fio.blk_addr;
@@ -641,7 +643,8 @@ static void move_data_page(struct inode *inode, block_t bidx, int gc_type)
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
index bda7126..d8c89f8 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -112,7 +112,8 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
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
index d842b19..7261a29 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1001,14 +1001,15 @@ fail:
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
@@ -1309,7 +1310,8 @@ static int f2fs_write_node_page(struct page *page,
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
index 6ebdbb3..f2ceb8a 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -200,7 +200,8 @@ int commit_inmem_pages(struct inode *inode, bool abort)
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = DATA,
-		.rw = WRITE_SYNC | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_PRIO,
 		.encrypted_page = NULL,
 	};
 	int err = 0;
@@ -318,6 +319,7 @@ repeat:
 		fcc->dispatch_list = llist_reverse_order(fcc->dispatch_list);
 
 		bio->bi_bdev = sbi->sb->s_bdev;
+		bio->bi_op = REQ_OP_WRITE;
 		bio->bi_rw |= WRITE_FLUSH;
 		ret = submit_bio_wait(bio);
 
@@ -351,6 +353,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 		int ret;
 
 		bio->bi_bdev = sbi->sb->s_bdev;
+		bio->bi_op = REQ_OP_WRITE;
 		bio->bi_rw |= WRITE_FLUSH;
 		ret = submit_bio_wait(bio);
 		bio_put(bio);
@@ -1290,14 +1293,15 @@ void write_meta_page(struct f2fs_sb_info *sbi, struct page *page)
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.type = META,
-		.rw = WRITE_SYNC | REQ_META | REQ_PRIO,
+		.op = REQ_OP_WRITE,
+		.op_flags = WRITE_SYNC | REQ_META | REQ_PRIO,
 		.blk_addr = page->index,
 		.page = page,
 		.encrypted_page = NULL,
 	};
 
 	if (unlikely(page->index >= MAIN_BLKADDR(sbi)))
-		fio.rw &= ~REQ_META;
+		fio.op_flags &= ~REQ_META;
 
 	set_page_writeback(page);
 	f2fs_submit_page_mbio(&fio);
diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index 145fb65..5b7edca 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -25,11 +25,12 @@ static inline void __print_last_io(void)
 	if (!last_io.len)
 		return;
 
-	trace_printk("%3x:%3x %4x %-16s %2x %5x %12x %4x\n",
+	trace_printk("%3x:%3x %4x %-16s %2x %5x %5x %12x %4x\n",
 			last_io.major, last_io.minor,
 			last_io.pid, "----------------",
 			last_io.type,
-			last_io.fio.rw, last_io.fio.blk_addr,
+			last_io.fio.op, last_io.fio.op_flags,
+			last_io.fio.blk_addr,
 			last_io.len);
 	memset(&last_io, 0, sizeof(last_io));
 }
@@ -100,7 +101,8 @@ void f2fs_trace_ios(struct f2fs_io_info *fio, int flush)
 	if (last_io.major == major && last_io.minor == minor &&
 			last_io.pid == pid &&
 			last_io.type == __file_type(inode, pid) &&
-			last_io.fio.rw == fio->rw &&
+			last_io.fio.op == fio->op &&
+			last_io.fio.op_flags == fio->op_flags &&
 			last_io.fio.blk_addr + last_io.len == fio->blk_addr) {
 		last_io.len++;
 		return;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index a1b4888..ddf4144 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -55,17 +55,21 @@ TRACE_DEFINE_ENUM(CP_DISCARD);
 		{ IPU,		"IN-PLACE" },				\
 		{ OPU,		"OUT-OF-PLACE" })
 
-#define F2FS_BIO_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
+#define F2FS_BIO_FLAG_MASK(t)	(t & (READA | WRITE_FLUSH_FUA))
 #define F2FS_BIO_EXTRA_MASK(t)	(t & (REQ_META | REQ_PRIO))
 
-#define show_bio_type(type)	show_bio_base(type), show_bio_extra(type)
+#define show_bio_type(op, op_flags) show_bio_op(op), 			\
+			show_bio_op_flags(op_flags), show_bio_extra(op_flags)
 
-#define show_bio_base(type)						\
-	__print_symbolic(F2FS_BIO_MASK(type),				\
+#define show_bio_op(op)							\
+	__print_symbolic(op,						\
 		{ READ, 		"READ" },			\
+		{ WRITE, 		"WRITE" })
+
+#define show_bio_op_flags(flags)					\
+	__print_symbolic(F2FS_BIO_FLAG_MASK(flags),			\
 		{ READA, 		"READAHEAD" },			\
 		{ READ_SYNC, 		"READ_SYNC" },			\
-		{ WRITE, 		"WRITE" },			\
 		{ WRITE_SYNC, 		"WRITE_SYNC" },			\
 		{ WRITE_FLUSH,		"WRITE_FLUSH" },		\
 		{ WRITE_FUA, 		"WRITE_FUA" },			\
@@ -728,7 +732,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__field(ino_t, ino)
 		__field(pgoff_t, index)
 		__field(block_t, blkaddr)
-		__field(int, rw)
+		__field(int, op)
+		__field(int, op_flags)
 		__field(int, type)
 	),
 
@@ -737,16 +742,17 @@ DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
 		__entry->ino		= page->mapping->host->i_ino;
 		__entry->index		= page->index;
 		__entry->blkaddr	= fio->blk_addr;
-		__entry->rw		= fio->rw;
+		__entry->op		= fio->op;
+		__entry->op_flags	= fio->op_flags;
 		__entry->type		= fio->type;
 	),
 
 	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
-		"blkaddr = 0x%llx, rw = %s%s, type = %s",
+		"blkaddr = 0x%llx, rw = %s%s%s, type = %s",
 		show_dev_ino(__entry),
 		(unsigned long)__entry->index,
 		(unsigned long long)__entry->blkaddr,
-		show_bio_type(__entry->rw),
+		show_bio_type(__entry->op, __entry->op_flags),
 		show_block_type(__entry->type))
 );
 
@@ -777,7 +783,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(int,	rw)
+		__field(int,	op)
+		__field(int,	op_flags)
 		__field(int,	type)
 		__field(sector_t,	sector)
 		__field(unsigned int,	size)
@@ -785,15 +792,16 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

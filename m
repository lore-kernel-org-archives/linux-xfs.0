Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4SHbOT9118229 for <xfs@oss.sgi.com>; Sat, 28 May 2011 12:37:24 -0500
From: Joe Perches <joe@perches.com>
Subject: [TRIVIAL PATCH next 13/15] fs: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:33 -0700
Message-Id: <4561db676a209fff984a75ade2f552ddbfabb95b.1306603968.git.joe@perches.com>
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, Jiri Kosina <trivial@kernel.org>
Cc: codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Alex Elder <aelder@sgi.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/coda/coda_linux.h    |    5 ++---
 fs/reiserfs/journal.c   |    9 +++------
 fs/reiserfs/resize.c    |    4 +---
 fs/xfs/linux-2.6/kmem.h |    7 +------
 4 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
index 9b0c532..7807025 100644
--- a/fs/coda/coda_linux.h
+++ b/fs/coda/coda_linux.h
@@ -59,12 +59,11 @@ void coda_sysctl_clean(void);
 
 #define CODA_ALLOC(ptr, cast, size) do { \
     if (size < PAGE_SIZE) \
-        ptr = kmalloc((unsigned long) size, GFP_KERNEL); \
+        ptr = kzalloc((unsigned long) size, GFP_KERNEL); \
     else \
-        ptr = (cast)vmalloc((unsigned long) size); \
+        ptr = (cast)vzalloc((unsigned long) size); \
     if (!ptr) \
         printk("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
-    else memset( ptr, 0, size ); \
 } while (0)
 
 
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index c5e82ec..40d8b0a 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -291,14 +291,13 @@ int reiserfs_allocate_list_bitmaps(struct super_block *sb,
 	for (i = 0; i < JOURNAL_NUM_BITMAPS; i++) {
 		jb = jb_array + i;
 		jb->journal_list = NULL;
-		jb->bitmaps = vmalloc(mem);
+		jb->bitmaps = vzalloc(mem);
 		if (!jb->bitmaps) {
 			reiserfs_warning(sb, "clm-2000", "unable to "
 					 "allocate bitmaps for journal lists");
 			failed = 1;
 			break;
 		}
-		memset(jb->bitmaps, 0, mem);
 	}
 	if (failed) {
 		free_list_bitmaps(sb, jb_array);
@@ -353,11 +352,10 @@ static struct reiserfs_journal_cnode *allocate_cnodes(int num_cnodes)
 	if (num_cnodes <= 0) {
 		return NULL;
 	}
-	head = vmalloc(num_cnodes * sizeof(struct reiserfs_journal_cnode));
+	head = vzalloc(num_cnodes * sizeof(struct reiserfs_journal_cnode));
 	if (!head) {
 		return NULL;
 	}
-	memset(head, 0, num_cnodes * sizeof(struct reiserfs_journal_cnode));
 	head[0].prev = NULL;
 	head[0].next = head + 1;
 	for (i = 1; i < num_cnodes; i++) {
@@ -2695,14 +2693,13 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	 * dependency inversion warnings.
 	 */
 	reiserfs_write_unlock(sb);
-	journal = SB_JOURNAL(sb) = vmalloc(sizeof(struct reiserfs_journal));
+	journal = SB_JOURNAL(sb) = vzalloc(sizeof(struct reiserfs_journal));
 	if (!journal) {
 		reiserfs_warning(sb, "journal-1256",
 				 "unable to get memory for journal structure");
 		reiserfs_write_lock(sb);
 		return 1;
 	}
-	memset(journal, 0, sizeof(struct reiserfs_journal));
 	INIT_LIST_HEAD(&journal->j_bitmap_nodes);
 	INIT_LIST_HEAD(&journal->j_prealloc_list);
 	INIT_LIST_HEAD(&journal->j_working_list);
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index b3a94d2..cfb5196 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -111,15 +111,13 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 		/* allocate additional bitmap blocks, reallocate array of bitmap
 		 * block pointers */
 		bitmap =
-		    vmalloc(sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
+		    vzalloc(sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
 		if (!bitmap) {
 			/* Journal bitmaps are still supersized, but the memory isn't
 			 * leaked, so I guess it's ok */
 			printk("reiserfs_resize: unable to allocate memory.\n");
 			return -ENOMEM;
 		}
-		memset(bitmap, 0,
-		       sizeof(struct reiserfs_bitmap_info) * bmap_nr_new);
 		for (i = 0; i < bmap_nr; i++)
 			bitmap[i] = old_bitmap[i];
 
diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
index f7c8f7a..292eff1 100644
--- a/fs/xfs/linux-2.6/kmem.h
+++ b/fs/xfs/linux-2.6/kmem.h
@@ -61,12 +61,7 @@ extern void  kmem_free(const void *);
 
 static inline void *kmem_zalloc_large(size_t size)
 {
-	void *ptr;
-
-	ptr = vmalloc(size);
-	if (ptr)
-		memset(ptr, 0, size);
-	return ptr;
+	return vzalloc(size);
 }
 static inline void kmem_free_large(void *ptr)
 {
-- 
1.7.5.rc3.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

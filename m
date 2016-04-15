Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0606B7D01
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:17:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF321304048
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:17:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wYfvgmYapGvH9MGq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:17:03 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 18/42] pm: set bi_op to REQ_OP
Date: Fri, 15 Apr 2016 14:15:53 -0500
Message-Id: <1460747777-8479-19-git-send-email-mchristi@redhat.com>
In-Reply-To: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
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

This patch has the pm code use bio->bi_op for REQ_OPs and rq_flag_bits
to bio->bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 kernel/power/swap.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 4d050eb..adbcb1b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -250,7 +250,7 @@ static void hib_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
+static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
 		struct hib_bio_batch *hb)
 {
 	struct page *page = virt_to_page(addr);
@@ -260,7 +260,8 @@ static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
 	bio = bio_alloc(__GFP_RECLAIM | __GFP_HIGH, 1);
 	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = hib_resume_bdev;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
@@ -296,7 +297,8 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 {
 	int error;
 
-	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(REQ_OP_READ, READ_SYNC, swsusp_resume_block,
+		      swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -305,8 +307,8 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 		swsusp_header->flags = flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 = handle->crc32;
-		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
-					swsusp_header, NULL);
+		error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+				      swsusp_resume_block, swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
 		error = -ENODEV;
@@ -379,7 +381,7 @@ static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 	} else {
 		src = buf;
 	}
-	return hib_submit_io(WRITE_SYNC, offset, src, hb);
+	return hib_submit_io(REQ_OP_WRITE, WRITE_SYNC, offset, src, hb);
 }
 
 static void release_swap_writer(struct swap_map_handle *handle)
@@ -982,7 +984,8 @@ static int get_swap_reader(struct swap_map_handle *handle,
 			return -ENOMEM;
 		}
 
-		error = hib_submit_io(READ_SYNC, offset, tmp->map, NULL);
+		error = hib_submit_io(REQ_OP_READ, READ_SYNC, offset,
+				      tmp->map, NULL);
 		if (error) {
 			release_swap_reader(handle);
 			return error;
@@ -1006,7 +1009,7 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 	offset = handle->cur->entries[handle->k];
 	if (!offset)
 		return -EFAULT;
-	error = hib_submit_io(READ_SYNC, offset, buf, hb);
+	error = hib_submit_io(REQ_OP_READ, READ_SYNC, offset, buf, hb);
 	if (error)
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
@@ -1508,7 +1511,8 @@ int swsusp_check(void)
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-		error = hib_submit_io(READ_SYNC, swsusp_resume_block,
+		error = hib_submit_io(REQ_OP_READ, READ_SYNC,
+					swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
 			goto put;
@@ -1516,7 +1520,8 @@ int swsusp_check(void)
 		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
-			error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
+			error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+						swsusp_resume_block,
 						swsusp_header, NULL);
 		} else {
 			error = -EINVAL;
@@ -1560,10 +1565,12 @@ int swsusp_unmark(void)
 {
 	int error;
 
-	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(REQ_OP_READ, READ_SYNC, swsusp_resume_block,
+		      swsusp_header, NULL);
 	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
-		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
+		error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+					swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

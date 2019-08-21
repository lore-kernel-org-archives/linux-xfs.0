Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094BDC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 08:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D96E922D6D
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 08:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfHUIi2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 04:38:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48997 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727425AbfHUIi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 04:38:28 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 32CB343D932
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 18:38:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0M7H-0004zj-26
        for linux-xfs@vger.kernel.org; Wed, 21 Aug 2019 18:37:15 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0M8N-000372-Pf
        for linux-xfs@vger.kernel.org; Wed, 21 Aug 2019 18:38:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: alignment check bio buffers
Date:   Wed, 21 Aug 2019 18:38:20 +1000
Message-Id: <20190821083820.11725-4-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190821083820.11725-1-david@fromorbit.com>
References: <20190821083820.11725-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=8OlXC7SjtNva-ERv-I8A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Add memory buffer alignment validation checks to bios built in XFS
to catch bugs that will result in silent data corruption in block
drivers that cannot handle unaligned memory buffers but don't
validate the incoming buffer alignment is correct.

Known drivers with these issues are xenblk, brd and pmem.

Despite there being nothing XFS specific to xfs_bio_add_page(), this
function was created to do the required validation because the block
layer developers that keep telling us that is not possible to
validate buffer alignment in bio_add_page(), and even if it was
possible it would be too much overhead to do at runtime.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bio_io.c | 32 +++++++++++++++++++++++++++++---
 fs/xfs/xfs_buf.c    |  2 +-
 fs/xfs/xfs_linux.h  |  3 +++
 fs/xfs/xfs_log.c    |  6 +++++-
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index e2148f2d5d6b..fbaea643c000 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -9,6 +9,27 @@ static inline unsigned int bio_max_vecs(unsigned int count)
 	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
 }
 
+int
+xfs_bio_add_page(
+	struct bio	*bio,
+	struct page	*page,
+	unsigned int	len,
+	unsigned int	offset)
+{
+	struct request_queue	*q = bio->bi_disk->queue;
+	bool		same_page = false;
+
+	if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
+		return -EIO;
+
+	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
+		if (bio_full(bio, len))
+			return 0;
+		__bio_add_page(bio, page, len, offset);
+	}
+	return len;
+}
+
 int
 xfs_rw_bdev(
 	struct block_device	*bdev,
@@ -20,7 +41,7 @@ xfs_rw_bdev(
 {
 	unsigned int		is_vmalloc = is_vmalloc_addr(data);
 	unsigned int		left = count;
-	int			error;
+	int			error, ret = 0;
 	struct bio		*bio;
 
 	if (is_vmalloc && op == REQ_OP_WRITE)
@@ -36,9 +57,12 @@ xfs_rw_bdev(
 		unsigned int	off = offset_in_page(data);
 		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
 
-		while (bio_add_page(bio, page, len, off) != len) {
+		while ((ret = xfs_bio_add_page(bio, page, len, off)) != len) {
 			struct bio	*prev = bio;
 
+			if (ret < 0)
+				goto submit;
+
 			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
@@ -48,14 +72,16 @@ xfs_rw_bdev(
 			submit_bio(prev);
 		}
 
+		ret = 0;
 		data += len;
 		left -= len;
 	} while (left > 0);
 
+submit:
 	error = submit_bio_wait(bio);
 	bio_put(bio);
 
 	if (is_vmalloc && op == REQ_OP_READ)
 		invalidate_kernel_vmap_range(data, count);
-	return error;
+	return ret ? ret : error;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7bd1f31febfc..a2d499baee9c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1294,7 +1294,7 @@ xfs_buf_ioapply_map(
 		if (nbytes > size)
 			nbytes = size;
 
-		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
+		rbytes = xfs_bio_add_page(bio, bp->b_pages[page_index], nbytes,
 				      offset);
 		if (rbytes < nbytes)
 			break;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ca15105681ca..e71c7bf3e714 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -145,6 +145,9 @@ static inline void delay(long ticks)
 	schedule_timeout_uninterruptible(ticks);
 }
 
+int xfs_bio_add_page(struct bio *bio, struct page *page, unsigned int len,
+			unsigned int offset);
+
 /*
  * XFS wrapper structure for sysfs support. It depends on external data
  * structures and is embedded in various internal data structures to implement
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1830d185d7fc..52f7d840d09e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1673,8 +1673,12 @@ xlog_map_iclog_data(
 		struct page	*page = kmem_to_page(data);
 		unsigned int	off = offset_in_page(data);
 		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
+		int		ret;
 
-		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
+		ret = xfs_bio_add_page(bio, page, len, off);
+		WARN_ON_ONCE(ret != len);
+		if (ret < 0)
+			break;
 
 		data += len;
 		count -= len;
-- 
2.23.0.rc1


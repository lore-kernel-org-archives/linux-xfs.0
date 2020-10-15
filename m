Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBBBC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05892224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgJOHWI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:08 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34908 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728946AbgJOHWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:07 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 16B9358C4DC
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvB-EE
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLU-6Q
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/27] libxfs: get rid of b_bcount from xfs_buf
Date:   Thu, 15 Oct 2020 18:21:31 +1100
Message-Id: <20201015072155.1631135-4-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=KO-pRdIDgRnZEUEkmTgA:9
        a=NOFCXurRfEqalbqf:21 a=1YvfqwfbD0sKCBxA:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We no longer use it in the kernel - it has been replaced by b_length
and it only exists in userspace because we haven't converted it
over. Do that now before we introduce a heap of code that doesn't
ever set it and so breaks all the progs code.

WHile we are doing this, kill the XFS_BUF_SIZE macro that has also
been removed from the kernel, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c             |  2 +-
 libxfs/libxfs_io.h        |  4 +---
 libxfs/logitem.c          |  4 ++--
 libxfs/rdwr.c             | 20 ++++++++++----------
 libxfs/trans.c            |  2 +-
 libxlog/xfs_log_recover.c |  6 +++---
 mkfs/proto.c              |  9 ++++++---
 repair/attr_repair.c      |  4 ++--
 repair/dino_chunks.c      |  2 +-
 repair/prefetch.c         | 14 ++++++++------
 10 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index e5cb3aa57ade..2e9e2b6a0f92 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -204,7 +204,7 @@ write_buf(
 			print_warning(
 			    "obfuscation corrupted block at %s bno 0x%llx/0x%x",
 				bp->b_ops->name,
-				(long long)bp->b_bn, bp->b_bcount);
+				(long long)bp->b_bn, BBTOB(bp->b_length));
 		}
 	}
 
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 9e65f4a63bfb..9d65cf808c6a 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -61,7 +61,6 @@ typedef struct xfs_buf {
 	struct cache_node	b_node;
 	unsigned int		b_flags;
 	xfs_daddr_t		b_bn;
-	unsigned		b_bcount;
 	unsigned int		b_length;
 	struct xfs_buftarg	*b_target;
 #define b_dev		b_target->dev
@@ -98,7 +97,6 @@ typedef unsigned int xfs_buf_flags_t;
 
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
-#define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
 
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
 
@@ -191,7 +189,7 @@ static inline int
 xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 {
 	bp->b_addr = mem;
-	bp->b_bcount = len;
+	bp->b_length = BTOBB(len);
 	return 0;
 }
 
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 40f9400f1903..e4ad748ed6e1 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -47,7 +47,7 @@ xfs_trans_buf_item_match(
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
 		    blip->bli_buf->b_target->dev == btp->dev &&
 		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
-		    blip->bli_buf->b_bcount == BBTOB(len)) {
+		    blip->bli_buf->b_length == len) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
 			return blip->bli_buf;
 		}
@@ -105,7 +105,7 @@ xfs_buf_item_init(
 	bip->bli_buf = bp;
 	bip->__bli_format.blf_type = XFS_LI_BUF;
 	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
-	bip->__bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
+	bip->__bli_format.blf_len = (unsigned short)bp->b_length;
 	bp->b_log_item = bip;
 }
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 11ff7f44b32a..81ab4dd76f19 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -141,7 +141,7 @@ static char *next(
 	struct xfs_buf	*buf = (struct xfs_buf *)private;
 
 	if (buf &&
-	    (buf->b_bcount < (int)(ptr - (char *)buf->b_addr) + offset))
+	    (BBTOB(buf->b_length) < (int)(ptr - (char *)buf->b_addr) + offset))
 		abort();
 
 	return ptr + offset;
@@ -203,7 +203,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 
 	if (bp->b_target->dev == bkey->buftarg->dev &&
 	    bp->b_bn == bkey->blkno) {
-		if (bp->b_bcount == BBTOB(bkey->bblen))
+		if (bp->b_length == bkey->bblen)
 			return CACHE_HIT;
 #ifdef IO_BCOMPARE_CHECK
 		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
@@ -211,7 +211,8 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 	"%lx: Badness in key lookup (length)\n"
 	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
 				pthread_self(),
-				(unsigned long long)bp->b_bn, (int)bp->b_bcount,
+				(unsigned long long)bp->b_bn, 
+				BBTOB(bp->b_length),
 				(unsigned long long)bkey->blkno,
 				BBTOB(bkey->bblen));
 		}
@@ -227,7 +228,6 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 {
 	bp->b_flags = 0;
 	bp->b_bn = bno;
-	bp->b_bcount = bytes;
 	bp->b_length = BTOBB(bytes);
 	bp->b_target = btp;
 	bp->b_mount = btp->bt_mount;
@@ -306,7 +306,7 @@ __libxfs_getbufr(int blen)
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
 	if (!list_empty(&xfs_buf_freelist.cm_list)) {
 		list_for_each_entry(bp, &xfs_buf_freelist.cm_list, b_node.cn_mru) {
-			if (bp->b_bcount == blen) {
+			if (bp->b_length == BTOBB(blen)) {
 				list_del_init(&bp->b_node.cn_mru);
 				break;
 			}
@@ -581,13 +581,13 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 	int	bytes = BBTOB(len);
 	int	error;
 
-	ASSERT(BBTOB(len) <= bp->b_bcount);
+	ASSERT(len <= bp->b_length);
 
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
 	    bp->b_target->dev == btp->dev &&
 	    bp->b_bn == blkno &&
-	    bp->b_bcount == bytes)
+	    bp->b_length == len)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 	bp->b_error = error;
 	return error;
@@ -824,13 +824,13 @@ libxfs_bwrite(
 			fprintf(stderr,
 	_("%s: write verifier failed on %s bno 0x%llx/0x%x\n"),
 				__func__, bp->b_ops->name,
-				(long long)bp->b_bn, bp->b_bcount);
+				(long long)bp->b_bn, bp->b_length);
 			return bp->b_error;
 		}
 	}
 
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
-		bp->b_error = __write_buf(fd, bp->b_addr, bp->b_bcount,
+		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
 				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
 	} else {
 		int	i;
@@ -852,7 +852,7 @@ libxfs_bwrite(
 		fprintf(stderr,
 	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
 			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
-			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
+			(long long)bp->b_bn, bp->b_length, -bp->b_error);
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 51ce83021e87..a9d7aa39751c 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -721,7 +721,7 @@ libxfs_trans_ordered_buf(
 	bool			ret;
 
 	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
+	libxfs_trans_log_buf(tp, bp, 0, BBTOB(bp->b_length));
 	return ret;
 }
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index ec6533991f0f..b02743dcf024 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -112,10 +112,10 @@ xlog_bread_noalign(
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
 	ASSERT(nbblks > 0);
-	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
+	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	bp->b_bcount = BBTOB(nbblks);
+	bp->b_length = nbblks;
 	bp->b_error = 0;
 
 	return libxfs_readbufr(log->l_dev, XFS_BUF_ADDR(bp), bp, nbblks, 0);
@@ -152,7 +152,7 @@ xlog_bread_offset(
 	char		*offset)
 {
 	char		*orig_offset = bp->b_addr;
-	int		orig_len = bp->b_bcount;
+	int		orig_len = BBTOB(bp->b_length);
 	int		error, error2;
 
 	error = xfs_buf_associate_memory(bp, offset, BBTOB(nbblks));
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 20a7cc3bb5d5..0fa6ffb0107e 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -241,6 +241,8 @@ newfile(
 		ip->i_df.if_format = XFS_DINODE_FMT_LOCAL;
 		flags = XFS_ILOG_DDATA;
 	} else if (len > 0) {
+		int	bcount;
+
 		nb = XFS_B_TO_FSB(mp, len);
 		nmap = 1;
 		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
@@ -269,10 +271,11 @@ newfile(
 			exit(1);
 		}
 		memmove(bp->b_addr, buf, len);
-		if (len < bp->b_bcount)
-			memset((char *)bp->b_addr + len, 0, bp->b_bcount - len);
+		bcount = BBTOB(bp->b_length);
+		if (len < bcount)
+			memset((char *)bp->b_addr + len, 0, bcount - len);
 		if (logit)
-			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
+			libxfs_trans_log_buf(tp, bp, 0, bcount - 1);
 		else {
 			libxfs_buf_mark_dirty(bp);
 			libxfs_buf_relse(bp);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index d92909e1c831..40cf81ee7ac3 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -424,9 +424,9 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			break;
 		}
 
-		ASSERT(mp->m_sb.sb_blocksize == bp->b_bcount);
+		ASSERT(mp->m_sb.sb_blocksize == BBTOB(bp->b_length));
 
-		length = min(bp->b_bcount - hdrsize, valuelen - amountdone);
+		length = min(BBTOB(bp->b_length) - hdrsize, valuelen - amountdone);
 		memmove(value, bp->b_addr + hdrsize, length);
 		amountdone += length;
 		value += length;
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index e4a95ff635c8..0c60ab431e13 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -687,7 +687,7 @@ process_inode_chunk(
 
 		pftrace("readbuf %p (%llu, %d) in AG %d", bplist[bp_index],
 			(long long)XFS_BUF_ADDR(bplist[bp_index]),
-			bplist[bp_index]->b_bcount, agno);
+			bplist[bp_index]->b_length, agno);
 
 		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 686bf7be5374..9bb9c5b9c0b9 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -411,7 +411,9 @@ pf_read_inode_dirs(
 	if (error)
 		return;
 
-	for (icnt = 0; icnt < (bp->b_bcount >> mp->m_sb.sb_inodelog); icnt++) {
+	for (icnt = 0;
+	     icnt < (BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog);
+	     icnt++) {
 		dino = xfs_make_iptr(mp, bp, icnt);
 
 		/*
@@ -523,21 +525,21 @@ pf_batch_read(
 		 */
 		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
 		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
-			XFS_BUF_SIZE(bplist[num-1]);
+			BBTOB(bplist[num-1]->b_length);
 		while (num > 1 && last_off - first_off > pf_max_bytes) {
 			num--;
 			last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
-				XFS_BUF_SIZE(bplist[num-1]);
+				BBTOB(bplist[num-1]->b_length);
 		}
 		if (num < ((last_off - first_off) >> (mp->m_sb.sb_blocklog + 3))) {
 			/*
 			 * not enough blocks for one big read, so determine
 			 * the number of blocks that are close enough.
 			 */
-			last_off = first_off + XFS_BUF_SIZE(bplist[0]);
+			last_off = first_off + BBTOB(bplist[0]->b_length);
 			for (i = 1; i < num; i++) {
 				next_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) +
-						XFS_BUF_SIZE(bplist[i]);
+						BBTOB(bplist[i]->b_length);
 				if (next_off - last_off > pf_batch_bytes)
 					break;
 				last_off = next_off;
@@ -596,7 +598,7 @@ pf_batch_read(
 			for (i = 0; i < num; i++) {
 
 				pbuf = ((char *)buf) + (LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[i])) - first_off);
-				size = XFS_BUF_SIZE(bplist[i]);
+				size = BBTOB(bplist[i]->b_length);
 				if (len < size)
 					break;
 				memcpy(bplist[i]->b_addr, pbuf, size);
-- 
2.28.0


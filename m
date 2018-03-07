Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933048AbeCGJFR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:05:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AC0580AD238
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:17 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3B4110B0F49
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:16 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/4] get rid of XFS_BUF_COUNT() macro
Date: Wed,  7 Mar 2018 10:05:05 +0100
Message-Id: <20180307090506.30199-4-cmaiolino@redhat.com>
In-Reply-To: <20180307090506.30199-1-cmaiolino@redhat.com>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	Fix conflicts with changes on patch 1

 libxfs/libxfs_io.h   | 1 -
 libxfs/logitem.c     | 2 +-
 libxfs/rdwr.c        | 2 +-
 libxfs/trans.c       | 2 +-
 mkfs/proto.c         | 7 +++----
 repair/attr_repair.c | 4 ++--
 repair/dino_chunks.c | 2 +-
 repair/prefetch.c    | 2 +-
 8 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 04bbc9b7..f429d667 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -100,7 +100,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SIZE(bp)		((bp)->b_bcount)
-#define XFS_BUF_COUNT(bp)		((bp)->b_bcount)
 #define XFS_BUF_SET_PTR(bp,p,cnt)	({	\
 	(bp)->b_addr = (char *)(p);		\
 	XFS_BUF_SET_COUNT(bp,cnt);		\
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 39ac1923..afe1570c 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -120,7 +120,7 @@ xfs_buf_item_init(
 	bip->bli_buf = bp;
 	bip->bli_format.blf_type = XFS_LI_BUF;
 	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (unsigned short)BTOBB(XFS_BUF_COUNT(bp));
+	bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
 	bp->b_log_item = bip;
 }
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9acdb98c..60880de4 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -143,7 +143,7 @@ static char *next(
 	struct xfs_buf	*buf = (struct xfs_buf *)private;
 
 	if (buf &&
-	    (XFS_BUF_COUNT(buf) < (int)(ptr - (char *)buf->b_addr) + offset))
+	    (buf->b_bcount < (int)(ptr - (char *)buf->b_addr) + offset))
 		abort();
 
 	return ptr + offset;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 0e7b7ae0..3e80e0cb 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -402,7 +402,7 @@ libxfs_trans_log_buf(
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
+	ASSERT((first <= last) && (last < bp->b_bcount));
 
 	xfs_trans_dirty_buf(tp, bp);
 	xfs_buf_item_log(bip, first, last);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 15545ad1..c925edb2 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -276,11 +276,10 @@ newfile(
 		bp = libxfs_trans_get_buf(logit ? tp : 0, mp->m_dev, d,
 			nb << mp->m_blkbb_log, 0);
 		memmove(bp->b_addr, buf, len);
-		if (len < XFS_BUF_COUNT(bp))
-			memset((char *)bp->b_addr + len, 0,
-			       XFS_BUF_COUNT(bp) - len);
+		if (len < bp->b_bcount)
+			memset((char *)bp->b_addr + len, 0, bp->b_bcount - len);
 		if (logit)
-			libxfs_trans_log_buf(tp, bp, 0, XFS_BUF_COUNT(bp) - 1);
+			libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount - 1);
 		else
 			libxfs_writebuf(bp, LIBXFS_EXIT_ON_FAILURE);
 	}
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8b1b8a75..39569ebe 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -437,9 +437,9 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			break;
 		}
 
-		ASSERT(mp->m_sb.sb_blocksize == XFS_BUF_COUNT(bp));
+		ASSERT(mp->m_sb.sb_blocksize == bp->b_bcount);
 
-		length = MIN(XFS_BUF_COUNT(bp) - hdrsize, valuelen - amountdone);
+		length = MIN(bp->b_bcount - hdrsize, valuelen - amountdone);
 		memmove(value, bp->b_addr + hdrsize, length);
 		amountdone += length;
 		value += length;
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 17de95f5..1c7f9c8d 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -689,7 +689,7 @@ process_inode_chunk(
 
 		pftrace("readbuf %p (%llu, %d) in AG %d", bplist[bp_index],
 			(long long)XFS_BUF_ADDR(bplist[bp_index]),
-			XFS_BUF_COUNT(bplist[bp_index]), agno);
+			bplist[bp_index]->b_bcount, agno);
 
 		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 0783d225..ff40d18d 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -403,7 +403,7 @@ pf_read_inode_dirs(
 	if (bp->b_error)
 		return;
 
-	for (icnt = 0; icnt < (XFS_BUF_COUNT(bp) >> mp->m_sb.sb_inodelog); icnt++) {
+	for (icnt = 0; icnt < (bp->b_bcount >> mp->m_sb.sb_inodelog); icnt++) {
 		dino = xfs_make_iptr(mp, bp, icnt);
 
 		/*
-- 
2.14.3


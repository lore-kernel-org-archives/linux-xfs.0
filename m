Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59589C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 05:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbiKQF6S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 00:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiKQF6R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 00:58:17 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B51667139
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 21:58:16 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 136so1105827pga.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 21:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7lmP4xnyYz/b/CoEiJ3KZaX12Y7GreC0MrOlP0yh80=;
        b=VqBFBgWcP7Ea5Fran7WNVps5v3ibH8GhKyvkS45S/7QfanpAQIqTfz4CQeUYEROSdT
         45uCSuEx/FNkd+dis1YMdyUq9RDAScToI8bthfQB0qMafB6Nnmw8yjSja/+EdSW/FxYW
         fHSvh6DNtjr66IfG2s0Xm5EtLSRq/xZn1D5F2z9EHWSrgn0HfY54IuUeqD9aSRSgBxLp
         z4xmaC1T1tqgxa2x717s786TQCrZrZcZLmBKqCjx67vtqLbqeAlA5tVinKek1877Dr37
         kfh/lRre6Gnab5I8rxLns95YBPqxg8nFQe5Ne25liQut+9RgQCkVUP0zgMuLDi9IxpZ9
         5qKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q7lmP4xnyYz/b/CoEiJ3KZaX12Y7GreC0MrOlP0yh80=;
        b=WSsHVkdFc11P5FbuqUfyKKCU9cHhRUezgUdamxvMyg+2ewQxQzHsRIZgcSTkTE7sUK
         et/LCdrWof6N8a8M1kabB4cpvyFnYsbQ0Z3huv4zhGA80BIazjTcpr2raLPJ9Vpp3ppj
         BL9gfgbIfty4CXUNzc5eAFsR+022wOi0ev89k84LCdepMouaIbdwfT0sBIk4LoSImwRo
         LG8+QoHPRiFtpmnHPrNLaR4eRNjrbszr3un8B8ISbeV/Pt6DFpNM8ucPFBhyA5CYALPd
         mfwU+cfkthRh3tBWhM1i2OMIS+nTEv87NqyDgqfcfXiA35Nkik61oHBnfUd3n3Elq6/M
         SwTw==
X-Gm-Message-State: ANoB5pleX91316yDhC8p+HSKFrucEqCha9ieZ8q3h3I0OCi8Mjt8mLNE
        L+3UhnUwU0+kxsRBVFpwAGuyrs38Cwf4Pg==
X-Google-Smtp-Source: AA0mqf4rY2IIxoq3higKiypDMCBPWRgywD6Z4K4WFOBcCIoUAuxvJgk1pq21crTDRP6/tuPdS7M+VQ==
X-Received: by 2002:a62:b417:0:b0:56b:b838:a4de with SMTP id h23-20020a62b417000000b0056bb838a4demr1444168pfn.73.1668664695433;
        Wed, 16 Nov 2022 21:58:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902e88300b00186985198a4sm208987plg.169.2022.11.16.21.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 21:58:14 -0800 (PST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ovXue-00FBpJ-86; Thu, 17 Nov 2022 16:58:12 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1ovXue-0025cO-0c;
        Thu, 17 Nov 2022 16:58:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/9] xfs,iomap: move delalloc punching to iomap
Date:   Thu, 17 Nov 2022 16:58:05 +1100
Message-Id: <20221117055810.498014-5-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221117055810.498014-1-david@fromorbit.com>
References: <20221117055810.498014-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because that's what Christoph wants for this error handling path
only XFS uses.

It requires a new iomap export for handling errors over delalloc
ranges. This is basically the XFS code as is stands, but even though
Christoph wants this as iomap funcitonality, we still have
to call it from the filesystem specific ->iomap_end callback, and
call into the iomap code with yet another filesystem specific
callback to punch the delalloc extent within the defined ranges.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap/buffered-io.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c     | 47 ++++++---------------------------
 include/linux/iomap.h  |  6 +++++
 3 files changed, 74 insertions(+), 39 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91ee0b308e13..77f391fd90ca 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -832,6 +832,66 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+/*
+ * When a short write occurs, the filesystem may need to remove reserved space
+ * that was allocated in ->iomap_begin from it's ->iomap_end method. For
+ * filesystems that use delayed allocation, we need to punch out delalloc
+ * extents from the range that are not dirty in the page cache. As the write can
+ * race with page faults, there can be dirty pages over the delalloc extent
+ * outside the range of a short write but still within the delalloc extent
+ * allocated for this iomap.
+ *
+ * This function uses [start_byte, end_byte) intervals (i.e. open ended) to
+ * simplify range iterations, but converts them back to {offset,len} tuples for
+ * the punch callback.
+ */
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t offset, loff_t length,
+		ssize_t written,
+		int (*punch)(struct inode *inode, loff_t offset, loff_t length))
+{
+	loff_t			start_byte;
+	loff_t			end_byte;
+	int			blocksize = 1 << inode->i_blkbits;
+	int			error = 0;
+
+	if (iomap->type != IOMAP_DELALLOC)
+		return 0;
+
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (!(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
+	/*
+	 * start_byte refers to the first unused block after a short write. If
+	 * nothing was written, round offset down to point at the first block in
+	 * the range.
+	 */
+	if (unlikely(!written))
+		start_byte = round_down(offset, blocksize);
+	else
+		start_byte = round_up(offset + written, blocksize);
+	end_byte = round_up(offset + length, blocksize);
+
+	/* Nothing to do if we've written the entire delalloc extent */
+	if (start_byte >= end_byte)
+		return 0;
+
+	/*
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite between the page cache
+	 * truncation and the delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache_range(inode, start_byte, end_byte - 1);
+	error = punch(inode, start_byte, end_byte - start_byte);
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
+
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7bb55dbc19d3..ea96e8a34868 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1123,12 +1123,12 @@ xfs_buffered_write_iomap_begin(
 static int
 xfs_buffered_write_delalloc_punch(
 	struct inode		*inode,
-	loff_t			start_byte,
-	loff_t			end_byte)
+	loff_t			offset,
+	loff_t			length)
 {
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
 				end_fsb - start_fsb);
@@ -1143,13 +1143,9 @@ xfs_buffered_write_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	loff_t			start_byte;
-	loff_t			end_byte;
-	int			error = 0;
 
-	if (iomap->type != IOMAP_DELALLOC)
-		return 0;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	int			error;
 
 	/*
 	 * Behave as if the write failed if drop writes is enabled. Set the NEW
@@ -1160,35 +1156,8 @@ xfs_buffered_write_iomap_end(
 		written = 0;
 	}
 
-	/* If we didn't reserve the blocks, we're not allowed to punch them. */
-	if (!(iomap->flags & IOMAP_F_NEW))
-		return 0;
-
-	/*
-	 * start_fsb refers to the first unused block after a short write. If
-	 * nothing was written, round offset down to point at the first block in
-	 * the range.
-	 */
-	if (unlikely(!written))
-		start_byte = round_down(offset, mp->m_sb.sb_blocksize);
-	else
-		start_byte = round_up(offset + written, mp->m_sb.sb_blocksize);
-	end_byte = round_up(offset + length, mp->m_sb.sb_blocksize);
-
-	/* Nothing to do if we've written the entire delalloc extent */
-	if (start_byte >= end_byte)
-		return 0;
-
-	/*
-	 * Lock the mapping to avoid races with page faults re-instantiating
-	 * folios and dirtying them via ->page_mkwrite between the page cache
-	 * truncation and the delalloc extent removal. Failing to do this can
-	 * leave dirty pages with no space reservation in the cache.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(inode, start_byte, end_byte - 1);
-	error = xfs_buffered_write_delalloc_punch(inode, start_byte, end_byte);
-	filemap_invalidate_unlock(inode->i_mapping);
+	error = iomap_file_buffered_write_punch_delalloc(inode, iomap, offset,
+			length, written, &xfs_buffered_write_delalloc_punch);
 	if (error && !xfs_is_shutdown(mp)) {
 		xfs_alert(mp, "%s: unable to clean up ino 0x%llx",
 			__func__, XFS_I(inode)->i_ino);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17..6bbed915c83a 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -226,6 +226,12 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t offset, loff_t length,
+		ssize_t written,
+		int (*punch)(struct inode *inode,
+				loff_t offset, loff_t length));
+
 int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
-- 
2.37.2


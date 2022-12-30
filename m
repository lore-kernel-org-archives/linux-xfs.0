Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8988DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiLaB7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbiLaB7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:59:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB461C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C79DB81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD86C433EF;
        Sat, 31 Dec 2022 01:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451966;
        bh=NDa7sWjMOAth0FgBAHhpqBHDbEcdpUHtN5FZiLgG2Y4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZWp8QTg8MftwvumbMiEz/1lBLXOzNrRrOwgBMzZe3P05xv1kVo38M/Jzq7cAjQW7+
         3jrjGbUNWam7dm+j0HU4chfe+32r0YtbtRMWpoVkyvQOcMQSQUf2v+Qj/JeGlDnLOF
         6Xies/RIU+bYXIiyg4HktvYqs3w8Y8caSL7QRTDpcjxmUmoUMgcc8AWtoByFxV/RIP
         B8WIYvgHABCJsxJ/XSCRKBghRkYfbbkWyNb44bgHFczI/lcbwfrZEsIKYZF/c+Ltl9
         TALUGF7zEqsNtzKVWnfLjQGRMTsdMgHXsYkkG63xKWXwYORDXEGrNBC1y6/UDf+8aI
         owbn6bj7XajAw==
Subject: [PATCH 2/9] iomap: set up for COWing around pages
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871832.718512.8291440482430734344.stgit@magnolia>
In-Reply-To: <167243871792.718512.13170681692847163098.stgit@magnolia>
References: <167243871792.718512.13170681692847163098.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In anticipation of enabling reflink on the realtime volume where the
allocation unit is larger than a page, create an iomap function to dirty
arbitrary parts of a file's page cache so that when we dirty part of a
file that could undergo a COW extent, we can dirty an entire allocation
unit's worth of pages.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h  |    2 ++
 2 files changed, 57 insertions(+)


diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 356193e44cf0..da5a5d28e2ee 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1141,6 +1141,61 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 }
 EXPORT_SYMBOL_GPL(iomap_file_unshare);
 
+static loff_t iomap_dirty_iter(struct iomap_iter *iter)
+{
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	long status = 0;
+	loff_t written = 0;
+
+	do {
+		unsigned long offset = offset_in_page(pos);
+		unsigned long bytes = min_t(loff_t, PAGE_SIZE - offset, length);
+		struct folio *folio;
+
+		status = iomap_write_begin(iter, pos, bytes, &folio);
+		if (unlikely(status))
+			return status;
+
+		folio_mark_accessed(folio);
+
+		status = iomap_write_end(iter, pos, bytes, bytes, folio);
+		if (WARN_ON_ONCE(status == 0))
+			return -EIO;
+
+		cond_resched();
+
+		pos += status;
+		written += status;
+		length -= status;
+
+		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
+	} while (length);
+
+	return written;
+}
+
+int
+iomap_dirty_range(struct inode *inode, loff_t pos, u64 len,
+		const struct iomap_ops *ops)
+{
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= pos,
+		.len		= len,
+		.flags		= IOMAP_WRITE,
+	};
+	int ret;
+
+	if (IS_DAX(inode))
+		return -EINVAL;
+
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_dirty_iter(&iter);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_dirty_range);
+
 static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0983dfc9a203..4d911d780165 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -264,6 +264,8 @@ bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
+int iomap_dirty_range(struct inode *inode, loff_t pos, u64 len,
+		const struct iomap_ops *ops);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,


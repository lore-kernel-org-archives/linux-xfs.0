Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8B3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiLaCAS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E49C1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D827AB81DF8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97696C433EF;
        Sat, 31 Dec 2022 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452013;
        bh=N7FfoUGu7e4T+0ipGOtxdhtzzvJEIL6t7LRRRrO4C0I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MQj/pw6gYC7JxakuZcpfh6Ym4DA9MpceqJpHl6Pe0sTv+Uh/27My7ulUd8bODvGXb
         8Bq0zXx0y5rlFlwPD2ra+L7sx2L3T8uuoZ0Z67gJavmPZNYmPeIkNhHiR0QY1BAdg8
         5KGrIAWu5Do1qB/5PgIcinzVVKaJtarNmZHmrY7QtTTqrW8XyjS4W1HkzUPqh7iNmE
         EoMaxu4kPyQt5podvbwr6EZ7IZkGxmpPqsw4C04qs9waOhQBPiTpRzU9hunAxZ+wAk
         x7c+9o+RKBVt+9+ux/whc00oCxZcP6xCaKnBKQGfghuhH1NcZAXcJtMX1oaxAbOnWC
         6ySem9IaUpC6A==
Subject: [PATCH 5/9] xfs: extend writeback requests to handle rt cow correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871875.718512.10357363440477128738.stgit@magnolia>
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

If we have shared realtime files and the rt extent size is larger than a
single fs block, we need to extend writeback requests to be aligned to
rt extent size granularity because we cannot share partial rt extents.
The front end should have set us up for this by dirtying the relevant
ranges.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c3a9df0c0eab..af5c854a72dc 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -488,12 +488,41 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
 	.discard_folio		= xfs_discard_folio,
 };
 
+/*
+ * Extend the writeback range to allocation unit granularity and alignment.
+ * This is a requirement for blocksize > pagesize scenarios such as realtime
+ * copy on write, since we can only share full rt extents.
+ */
+static void
+xfs_vm_writepage_extend(
+	struct xfs_inode		*ip,
+	struct writeback_control	*wbc)
+{
+	unsigned int			bsize = xfs_inode_alloc_unitsize(ip);
+	long long int			pages_to_write;
+
+	wbc->range_start = rounddown_64(wbc->range_start, bsize);
+	if (wbc->range_end != LLONG_MAX)
+		wbc->range_end = roundup_64(wbc->range_end, bsize);
+
+	if (wbc->nr_to_write == LONG_MAX)
+		return;
+
+	pages_to_write = roundup_64(wbc->range_end - wbc->range_start,
+				    PAGE_SIZE);
+	if (pages_to_write >= LONG_MAX)
+		pages_to_write = LONG_MAX;
+	if (wbc->nr_to_write < pages_to_write)
+		wbc->nr_to_write = pages_to_write;
+}
+
 STATIC int
 xfs_vm_writepages(
-	struct address_space	*mapping,
-	struct writeback_control *wbc)
+	struct address_space		*mapping,
+	struct writeback_control	*wbc)
 {
-	struct xfs_writepage_ctx wpc = { };
+	struct xfs_writepage_ctx	wpc = { };
+	struct xfs_inode		*ip = XFS_I(mapping->host);
 
 	/*
 	 * Writing back data in a transaction context can result in recursive
@@ -502,7 +531,10 @@ xfs_vm_writepages(
 	if (WARN_ON_ONCE(current->journal_info))
 		return 0;
 
-	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	if (xfs_inode_needs_cow_around(ip))
+		xfs_vm_writepage_extend(ip, wbc);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 


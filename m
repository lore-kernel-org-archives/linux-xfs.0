Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E003C4CECC
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 19:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB05205C9
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 19:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgD0Tdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 15:33:51 -0400
Received: from verein.lst.de ([213.95.11.211]:50808 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgD0Tdv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Apr 2020 15:33:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0CC9A68CF0; Mon, 27 Apr 2020 21:33:50 +0200 (CEST)
Date:   Mon, 27 Apr 2020 21:33:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/2] xfs: simplify xlog_recover_inode_ra_pass2
Message-ID: <20200427193349.GB24934@lst.de>
References: <20200427135229.1480993-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135229.1480993-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Don't bother to allocate memory and convert the log item when we
only need the block number and the length.  Just extract them directly
and call xlog_buf_readahead separately in each branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4cb8f24f3aa63..fe4dad5b77a95 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3890,22 +3890,17 @@ xlog_recover_inode_ra_pass2(
 	struct xlog                     *log,
 	struct xlog_recover_item        *item)
 {
-	struct xfs_inode_log_format	ilf_buf;
-	struct xfs_inode_log_format	*ilfp;
-	int			error;
-
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
-		ilfp = item->ri_buf[0].i_addr;
+		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
+
+		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+				   &xfs_inode_buf_ra_ops);
 	} else {
-		ilfp = &ilf_buf;
-		memset(ilfp, 0, sizeof(*ilfp));
-		error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
-		if (error)
-			return;
-	}
+		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
 
-	xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
-			   &xfs_inode_buf_ra_ops);
+		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+				   &xfs_inode_buf_ra_ops);
+	}
 }
 
 STATIC void
-- 
2.26.1


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C67C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687F3610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbhINCo7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237725AbhINCoz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC78606A5;
        Tue, 14 Sep 2021 02:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587419;
        bh=2N3rnH7ZMYAPSxQPlbx4bB1HUZmbEq4QFBWc5Y6EJV0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uyWpogF9AQEHAzSlKy4aEVz/o5ihp4d0LgV30H1kEBG7aHNKbLTtT+/ZCgbBAiDII
         9y0sPywUOy5TaYTJmp8vRg+hRBaB0/pfemiGmWdYOxPHTlqMuAUDq7hzLPGvhli2I9
         dSb3SCJ3TVrULrClpDBW6ISI6Gk6gISGTsmg4vLTRRxuVA0h5bzrwGH80o/u0qSNjh
         gr0DzPJtH5G1agCssBYizKRiFRA6fwSQQc0C1wDaFIPuM7Qa/SyCKseQbrflnpIAIj
         7n9fTaBVNRSeJly+Mce2WLgM7ySj8i7dnkR83sin+uZ7qFwD0ZRY927pxEYLpQ9R5f
         ZKN+1hlEmIwxg==
Subject: [PATCH 40/43] libxfs: replace XFS_BUF_SET_ADDR with a function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:38 -0700
Message-ID: <163158741878.1604118.17091065004793020901.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace XFS_BUF_SET_ADDR with a new function that will set the buffer
block number correctly, then port the two users to it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_io.h        |    5 ++++-
 libxlog/xfs_log_recover.c |    2 +-
 mkfs/xfs_mkfs.c           |    4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 3cc4f4ee..bf489259 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -116,7 +116,10 @@ typedef unsigned int xfs_buf_flags_t;
 #define xfs_buf_offset(bp, offset)	((bp)->b_addr + (offset))
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 
-#define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
+static inline void xfs_buf_set_daddr(struct xfs_buf *bp, xfs_daddr_t blkno)
+{
+	bp->b_bn = blkno;
+}
 
 void libxfs_buf_set_priority(struct xfs_buf *bp, int priority);
 int libxfs_buf_priority(struct xfs_buf *bp);
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index d43914b9..3c24c021 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -114,7 +114,7 @@ xlog_bread_noalign(
 	ASSERT(nbblks > 0);
 	ASSERT(nbblks <= bp->b_length);
 
-	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
+	xfs_buf_set_daddr(bp, log->l_logBBstart + blk_no);
 	bp->b_length = nbblks;
 	bp->b_error = 0;
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 63895f28..057b3b09 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3505,8 +3505,8 @@ alloc_write_buf(
 				error);
 		exit(1);
 	}
-	bp->b_bn = daddr;
-	bp->b_maps[0].bm_bn = daddr;
+
+	xfs_buf_set_daddr(bp, daddr);
 	return bp;
 }
 


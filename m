Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5746C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345101AbiATAVS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73484C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DD8AB81B2B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01764C004E1;
        Thu, 20 Jan 2022 00:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638075;
        bh=2N3rnH7ZMYAPSxQPlbx4bB1HUZmbEq4QFBWc5Y6EJV0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aEAPPGvFbYrNrBL1tMcZAGYhKTe9l9zcGrvMXs7CRm3XKJVk8MQUnoDJlCzqjwvvy
         99VAKZ6EFm1DADhaJKIo9BU98AT5PRgYe+bY9V6bxjQzZ8ncawH4uzrrXemULQGSK8
         vDrJDGMM3qT3H4/7fVoYKXiCjpvRCyLt6A0yxvMfX/o0L0GOlh5d2mMr7yW6d++BPd
         Xr3i/4RQsiB8I+rLANun6mKSv0d8kAmAsq1ZvnrpgoYYZyjx97vAdslehGj+khGK2c
         gKxu7ltyjImmh+csfiRFQTAcqcV3tpbko8/JXtwKmhWSz5O9eR6+VPJH0DRCDZ4P0t
         qEX91lpEbjbQA==
Subject: [PATCH 42/45] libxfs: replace XFS_BUF_SET_ADDR with a function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:21:14 -0800
Message-ID: <164263807467.860211.13040036268013928337.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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
 


Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EBCC43461
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D66822098B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 15:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="opU4Rx0S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgIAPuw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 11:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731296AbgIAPul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE3CC061247
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=QU+6k9eP9T9bxciFZ6FjDCa2hgjwoOnO+bUSXvneHQI=; b=opU4Rx0SS8HYKLVDbBE6swqhkr
        zlt3vfCD8aS3A3idnX1Q8cV0uZNu33Rev6ZkniMSodbZi9NCAWAEdaf4d+qkD9l1OfWEQ3FPlrmc6
        e0jEbZ/2b/iwPKm9ZwCnnIKURImXvf/SDhwX+minQdgxJaIXnqVBrPFFcgBTwmf064EoJeqloVBnm
        Z+YacJ/nTDLg8keKa5XU3ukZUeZ0H1yO6Ta7MxsolZdQm+DZa/zV79VGGsfgYLZWksfSXGxuubmiO
        rFXzQSMaYboNRGbqMDcOewWwchWiMz4cjGy3PngjyAk9DFAuhTfHeSSSidIc4xwvATvaZOAWVrLEf
        GoURsABg==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YR-0003n1-Dm
        for linux-xfs@vger.kernel.org; Tue, 01 Sep 2020 15:50:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/15] xfs: simplify xfs_trans_getsb
Date:   Tue,  1 Sep 2020 17:50:16 +0200
Message-Id: <20200901155018.2524-14-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901155018.2524-1-hch@lst.de>
References: <20200901155018.2524-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the mp argument as this function is only called in transaction
context, and open code xfs_getsb given that the function already accesses
the buffer pointer in the mount point directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c |  4 ++--
 fs/xfs/xfs_trans.c     |  2 +-
 fs/xfs/xfs_trans.h     |  2 +-
 fs/xfs/xfs_trans_buf.c | 46 ++++++++++++++----------------------------
 4 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ae9aaf1f34bfcc..15d03d96753769 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -954,7 +954,7 @@ xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
+	struct xfs_buf		*bp = xfs_trans_getsb(tp);
 
 	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
@@ -1084,7 +1084,7 @@ xfs_sync_sb_buf(
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp, mp);
+	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ed72867b1a1937..ca18a040336a1d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -468,7 +468,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_buf_t	*bp;
 	int		whole = 0;
 
-	bp = xfs_trans_getsb(tp, tp->t_mountp);
+	bp = xfs_trans_getsb(tp);
 	sbp = bp->b_addr;
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index b752501818d257..f46534b7523698 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -209,7 +209,7 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
-struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
+struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 11cd666cd99a63..42d63b830cb9c8 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -166,50 +166,34 @@ xfs_trans_get_buf_map(
 }
 
 /*
- * Get and lock the superblock buffer of this file system for the
- * given transaction.
- *
- * We don't need to use incore_match() here, because the superblock
- * buffer is a private buffer which we keep a pointer to in the
- * mount structure.
+ * Get and lock the superblock buffer for the given transaction.
  */
-xfs_buf_t *
+struct xfs_buf *
 xfs_trans_getsb(
-	xfs_trans_t		*tp,
-	struct xfs_mount	*mp)
+	struct xfs_trans	*tp)
 {
-	xfs_buf_t		*bp;
-	struct xfs_buf_log_item	*bip;
+	struct xfs_buf		*bp = tp->t_mountp->m_sb_bp;
 
 	/*
-	 * Default to just trying to lock the superblock buffer
-	 * if tp is NULL.
+	 * Just increment the lock recursion count if the buffer is already
+	 * attached to this transaction.
 	 */
-	if (tp == NULL)
-		return xfs_getsb(mp);
-
-	/*
-	 * If the superblock buffer already has this transaction
-	 * pointer in its b_fsprivate2 field, then we know we already
-	 * have it locked.  In this case we just increment the lock
-	 * recursion count and return the buffer to the caller.
-	 */
-	bp = mp->m_sb_bp;
 	if (bp->b_transp == tp) {
-		bip = bp->b_log_item;
+		struct xfs_buf_log_item	*bip = bp->b_log_item;
+
 		ASSERT(bip != NULL);
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
+
 		trace_xfs_trans_getsb_recur(bip);
-		return bp;
-	}
+	} else {
+		xfs_buf_lock(bp);
+		xfs_buf_hold(bp);
+		_xfs_trans_bjoin(tp, bp, 1);
 
-	bp = xfs_getsb(mp);
-	if (bp == NULL)
-		return NULL;
+		trace_xfs_trans_getsb(bp->b_log_item);
+	}
 
-	_xfs_trans_bjoin(tp, bp, 1);
-	trace_xfs_trans_getsb(bp->b_log_item);
 	return bp;
 }
 
-- 
2.28.0


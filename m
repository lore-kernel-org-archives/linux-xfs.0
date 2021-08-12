Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911CAC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B7DA60724
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhHLIte (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbhHLIte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:49:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD89C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=wPjKYAvQXQeYmVB6pACd5PoS7Il6KCTkWjfINiAcmwk=; b=nw15zekYXZGu0dyYpvKRuH1n0D
        LVdTQHiTIRAYvtKBZ7j5e1ar3IkfqB2Ox7aOgIzhvhp5rQDDOvxcisPA4DRm3WZamLIGlXBv/4Ydo
        zbSIhq0SrflPlBJIGDMmV9pisAIrfW2olf2XHZCgT70bje8dr8JPynJqjB8h4ZTSkzMokbox83pox
        PyENmhRC28PaPXBHz/dxDukgL8F+3vCWXdLyJp+Nuk5MQrmuMyKzz1ilcudMrKGrUGcmiQsW6Wkmd
        2I1CuAFoFjkYE00zos8Vi3UYWycqegnp6MMecMz1l2I//wNo94OlOezg/KWYTGYnrRAalP/LGMKX9
        +hIsYSTA==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6Lu-00EMBz-7u
        for linux-xfs@vger.kernel.org; Thu, 12 Aug 2021 08:46:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: remove the xfs_dsb_t typedef
Date:   Thu, 12 Aug 2021 10:43:42 +0200
Message-Id: <20210812084343.27934-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812084343.27934-1-hch@lst.de>
References: <20210812084343.27934-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the few leftover instances of the xfs_dinode_t typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 5 ++---
 fs/xfs/libxfs/xfs_sb.c     | 4 ++--
 fs/xfs/xfs_trans.c         | 8 ++++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f601049b65f465..5819c25c1478d0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -184,7 +184,7 @@ typedef struct xfs_sb {
  * Superblock - on disk version.  Must match the in core version above.
  * Must be padded to 64 bit alignment.
  */
-typedef struct xfs_dsb {
+struct xfs_dsb {
 	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	__be32		sb_blocksize;	/* logical block size, bytes */
 	__be64		sb_dblocks;	/* number of data blocks */
@@ -263,8 +263,7 @@ typedef struct xfs_dsb {
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
 	/* must be padded to 64 bit alignment */
-} xfs_dsb_t;
-
+};
 
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 04f5386446dbb0..56d241cb17ee1b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -391,7 +391,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 static void
 __xfs_sb_from_disk(
 	struct xfs_sb	*to,
-	xfs_dsb_t	*from,
+	struct xfs_dsb	*from,
 	bool		convert_xquota)
 {
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
@@ -466,7 +466,7 @@ __xfs_sb_from_disk(
 void
 xfs_sb_from_disk(
 	struct xfs_sb	*to,
-	xfs_dsb_t	*from)
+	struct xfs_dsb	*from)
 {
 	__xfs_sb_from_disk(to, from, true);
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 83abaa21961605..7f4f431bc256ce 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -477,7 +477,7 @@ STATIC void
 xfs_trans_apply_sb_deltas(
 	xfs_trans_t	*tp)
 {
-	xfs_dsb_t	*sbp;
+	struct xfs_dsb	*sbp;
 	struct xfs_buf	*bp;
 	int		whole = 0;
 
@@ -541,14 +541,14 @@ xfs_trans_apply_sb_deltas(
 		/*
 		 * Log the whole thing, the fields are noncontiguous.
 		 */
-		xfs_trans_log_buf(tp, bp, 0, sizeof(xfs_dsb_t) - 1);
+		xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
 	else
 		/*
 		 * Since all the modifiable fields are contiguous, we
 		 * can get away with this.
 		 */
-		xfs_trans_log_buf(tp, bp, offsetof(xfs_dsb_t, sb_icount),
-				  offsetof(xfs_dsb_t, sb_frextents) +
+		xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
+				  offsetof(struct xfs_dsb, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-- 
2.30.2


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7F7C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712C361059
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhHLIuw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHLIuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:50:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8E1C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=wjxkpss9mO6snbed/88z9SLRWpLHPsFuZHWeoVeWj8s=; b=VwR+4UQ8hQRpexzQDqAn15qTBl
        MwN6VtnJeKK1BqfXEOj2YkWSEwhJbjqYSBU520M8Exd3qOIG3waXGThQoU12NSt3tYMULznM08dpG
        hoIlJxozM5N2MOHHFQLY0R4vNMkdUpnE74fbw164gICYcSnQBqrGtpQVi1sisHQ49vCtaGeJ9nXV/
        xl+kpq85k4vmRc7BqTYJpaTHsW6U1zB0mlKh6o6dM8jsgEZuRfTAgHA3lQVSJwVOWoTLcsJjSc8zp
        Mlhhg5b4VY9jfifXL2A6b2muW774JzVDmGPiPyPQP0dUAR3FL5aAT7g6vjD/uFF34gVwTf8rapkaW
        iqiPKfkw==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6OA-00EMLf-M0
        for linux-xfs@vger.kernel.org; Thu, 12 Aug 2021 08:49:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: remove the xfs_dqblk_t typedef
Date:   Thu, 12 Aug 2021 10:43:43 +0200
Message-Id: <20210812084343.27934-4-hch@lst.de>
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
 fs/xfs/libxfs/xfs_dquot_buf.c | 4 ++--
 fs/xfs/libxfs/xfs_format.h    | 4 ++--
 fs/xfs/xfs_dquot.c            | 2 +-
 fs/xfs/xfs_qm.c               | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 6766417d5ba448..7691e44d38b9ac 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -22,7 +22,7 @@ xfs_calc_dquots_per_chunk(
 	unsigned int		nbblks)	/* basic block units */
 {
 	ASSERT(nbblks > 0);
-	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
+	return BBTOB(nbblks) / sizeof(struct xfs_dqblk);
 }
 
 /*
@@ -127,7 +127,7 @@ xfs_dqblk_repair(
 	 * Typically, a repair is only requested by quotacheck.
 	 */
 	ASSERT(id != -1);
-	memset(dqb, 0, sizeof(xfs_dqblk_t));
+	memset(dqb, 0, sizeof(struct xfs_dqblk));
 
 	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
 	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5819c25c1478d0..61e454e4381e42 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1411,7 +1411,7 @@ struct xfs_disk_dquot {
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
  * carrying the unnecessary padding would be a waste of memory.
  */
-typedef struct xfs_dqblk {
+struct xfs_dqblk {
 	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
 	char			dd_fill[4];/* filling for posterity */
 
@@ -1421,7 +1421,7 @@ typedef struct xfs_dqblk {
 	__be32		  dd_crc;	/* checksum */
 	__be64		  dd_lsn;	/* last modification in log */
 	uuid_t		  dd_uuid;	/* location information */
-} xfs_dqblk_t;
+};
 
 #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c301b18b7685b1..a86665bdd4afb5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -471,7 +471,7 @@ xfs_dquot_alloc(
 	 * Offset of dquot in the (fixed sized) dquot chunk.
 	 */
 	dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
-			sizeof(xfs_dqblk_t);
+			sizeof(struct xfs_dqblk);
 
 	/*
 	 * Because we want to use a counting completion, complete
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2bef4735d03031..95fdbe1b7016da 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -850,7 +850,7 @@ xfs_qm_reset_dqcounts(
 	 */
 #ifdef DEBUG
 	j = (int)XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) /
-		sizeof(xfs_dqblk_t);
+		sizeof(struct xfs_dqblk);
 	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
 #endif
 	dqb = bp->b_addr;
-- 
2.30.2


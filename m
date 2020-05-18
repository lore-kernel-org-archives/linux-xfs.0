Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E74C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC7320758
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tx974qWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgERREx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101B5C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=/3dRbjitqxcOE5pwhsmfsyWfbxZKLD1n/67fh4aCBVQ=; b=tx974qWwwyx61xSAImsaqWM9TR
        LCdWuPuHR26gRk54b7hdllDUbPT1pQwEgN0qwPNHyzvev5qeFhZw1t7xgL3yn2ikfFcGmrFRyMTID
        p4zMH4QATmbrjjyVg28WuS4FmK3dh0PABuUpWGOLoBLQGslVDOrF5mU1jm3sEXH/lozmDWZ3sIJPa
        HeTeH+3f4XL2TAHKWYqXsh5KffHTB7viJY20v94fPwOaOOLx4A4UCvXLlgtBXbHKxLhT67aF9MV1G
        Vu5bDoKn8FyfitAj8Dd8YBFftVd2DH+miGOhL1vOwlzA3+PBIzmXzB4TOibRaK0JR/DmlxF8ybLyw
        I6rYgzag==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajC8-0001x4-J9
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: add a flags argument to xfs_icache_free_cowblocks
Date:   Mon, 18 May 2020 19:04:36 +0200
Message-Id: <20200518170437.1218883-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518170437.1218883-1-hch@lst.de>
References: <20200518170437.1218883-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Pass the SYNC_* flags directly instead of hiding the information in the
eofblocks structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c   |  2 +-
 fs/xfs/xfs_icache.c | 11 ++++-------
 fs/xfs/xfs_icache.h |  3 ++-
 fs/xfs/xfs_super.c  |  2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a1a62647f3935..6fc1a4a2f1966 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -663,7 +663,7 @@ xfs_file_buffered_aio_write(
 		xfs_iunlock(ip, iolock);
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		xfs_icache_free_cowblocks(ip->i_mount, &eofb, SYNC_WAIT);
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index aa664be49fd50..43273b809fa34 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -944,7 +944,7 @@ xfs_cowblocks_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_cowblocks(mp, NULL);
+	xfs_icache_free_cowblocks(mp, NULL, SYNC_TRYLOCK);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_cowblocks(mp);
@@ -1557,7 +1557,7 @@ xfs_inode_free_quota_blocks(
 
 	if (scan) {
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		xfs_icache_free_cowblocks(ip->i_mount, &eofb, SYNC_WAIT);
 	}
 
 	return scan;
@@ -1767,12 +1767,9 @@ xfs_inode_free_cowblocks(
 int
 xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_eofblocks	*eofb,
+	int			flags)
 {
-	int flags = SYNC_TRYLOCK;
-
-	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
-		flags = SYNC_WAIT;
 	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_cowblocks, flags,
 					 eofb, XFS_ICI_COWBLOCKS_TAG);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3e4a8b3913f51..a850142769226 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -66,7 +66,8 @@ void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_icache_free_cowblocks(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+		int flags);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aae469f73efeb..67efcc5c87929 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1670,7 +1670,7 @@ xfs_remount_ro(
 	xfs_stop_block_reaping(mp);
 
 	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
+	error = xfs_icache_free_cowblocks(mp, NULL, SYNC_TRYLOCK);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
-- 
2.26.2


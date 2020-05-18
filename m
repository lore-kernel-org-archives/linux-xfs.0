Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB49C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09890207D8
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BaOUJDcY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgERREz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEA9C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=5EMy9+oYbYg12SE1lZRiHId/u/E9CKToIIVzmaovMlc=; b=BaOUJDcYvLMKa/MKeoBM8P2z6v
        sHKfdDrQD3IggKUdEm1mQAmHmT1ZLikQeN/42SwiRtTmRXOadlzxRTzAD7uO1glCtg4gDuIBu3W6c
        WNBbR5VpUbQL3Bgd7faVWCO70blcvSz2XpHqG5O5CwCu5Hi0flDdWzBvxeW0UZ23SJeXHaUyBlCE3
        jwNWDXiBxVy14emXcN7GXc/iGEznMSfyxofQLJWNZlHDaMJ422LqpFTV4JzuO1dCiGNb8bjJD09UA
        JgrUVbyQiHNwsyMXOyMobIkqLaqwxws1N8SnKX5jfOoeJziA5kVrKZRjwHfk/yuinmtNHu6rjSbk3
        3Q7Bknqw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajCA-0001xU-Vd
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: add a flags argument to xfs_icache_free_eofblocks
Date:   Mon, 18 May 2020 19:04:37 +0200
Message-Id: <20200518170437.1218883-7-hch@lst.de>
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
 fs/xfs/xfs_file.c   |  3 +--
 fs/xfs/xfs_icache.c | 11 ++++-------
 fs/xfs/xfs_icache.h |  3 ++-
 fs/xfs/xfs_ioctl.c  |  4 +++-
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6fc1a4a2f1966..62fbc0105e45d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -661,8 +661,7 @@ xfs_file_buffered_aio_write(
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		xfs_icache_free_eofblocks(ip->i_mount, &eofb, SYNC_WAIT);
 		xfs_icache_free_cowblocks(ip->i_mount, &eofb, SYNC_WAIT);
 		goto write_retry;
 	}
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 43273b809fa34..11bef3e349a68 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -912,7 +912,7 @@ xfs_eofblocks_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_eofblocks(mp, NULL);
+	xfs_icache_free_eofblocks(mp, NULL, SYNC_TRYLOCK);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_eofblocks(mp);
@@ -1507,12 +1507,9 @@ xfs_inode_free_eofblocks(
 int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_eofblocks	*eofb,
+	int			flags)
 {
-	int flags = SYNC_TRYLOCK;
-
-	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
-		flags = SYNC_WAIT;
 	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
 					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
@@ -1556,7 +1553,7 @@ xfs_inode_free_quota_blocks(
 	}
 
 	if (scan) {
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		xfs_icache_free_eofblocks(ip->i_mount, &eofb, SYNC_WAIT);
 		xfs_icache_free_cowblocks(ip->i_mount, &eofb, SYNC_WAIT);
 	}
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a850142769226..a82ff6457993b 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -59,7 +59,8 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
+int xfs_icache_free_eofblocks(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+		int flags);
 int xfs_inode_free_quota_blocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4ee0d13232f3f..4aed4df98722f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2330,7 +2330,9 @@ xfs_file_ioctl(
 			return error;
 
 		sb_start_write(mp->m_super);
-		error = xfs_icache_free_eofblocks(mp, &keofb);
+		error = xfs_icache_free_eofblocks(mp, &keofb,
+			(keofb.eof_flags & XFS_EOF_FLAGS_SYNC) ?
+			 SYNC_WAIT : SYNC_TRYLOCK);
 		sb_end_write(mp->m_super);
 		return error;
 	}
-- 
2.26.2


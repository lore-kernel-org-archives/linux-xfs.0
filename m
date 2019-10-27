Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F24CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D190214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Smn78bow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfJ0O4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=29b4t1+YjihrV8rAvlQND9DZSupBvOGHpYHAIF/sdiI=; b=Smn78bowI9SaM4Zk1btBwH5Ubt
        IwRdEhg2khFAiWEWdkvPeU/kaUp8OOx8XZzZsfY2ciX+av+v7F/1yWPj0z1cmXYT8qi/X2nrrhr8T
        TIWsset3+qFMoGe3qzb6NeidrNHSOcTguSRuqpH37Vo24ExZ9d2uwW1C9U0FGrrR5Fd1mkB5Ydtmu
        8dln3NCyxGe0N5ecpGNGFjqcJrRiEvJCCgPJlQM10ONMeYg3T0l3W4sLhK+7vGPEj2UH890xGYEoZ
        1LFFxguT5IcmeODPit6xJUu7IiGkMYDqO3TDpqPAyeJLctZh2bVNN7Q9bLJXHeIES1uxrR6vWLX/x
        yncSSJnQ==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxc-0005N8-5o; Sun, 27 Oct 2019 14:56:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 05/12] xfs: remove the m_readio_* fields in struct xfs_mount
Date:   Sun, 27 Oct 2019 15:55:40 +0100
Message-Id: <20191027145547.25157-6-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027145547.25157-1-hch@lst.de>
References: <20191027145547.25157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

m_readio_blocks is entirely unused, and m_readio_blocks is only used in
xfs_stat_blksize in a max statements that is a no-op as it always has
the same value as m_writeio_log.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c  |  2 +-
 fs/xfs/xfs_mount.c | 18 ++++--------------
 fs/xfs/xfs_mount.h |  5 +----
 fs/xfs/xfs_super.c |  1 -
 4 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b6dbfd8eb6a1..271fcbe04d48 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -514,7 +514,7 @@ xfs_stat_blksize(
 		if (mp->m_swidth)
 			return mp->m_swidth << mp->m_sb.sb_blocklog;
 		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-			return 1U << max(mp->m_readio_log, mp->m_writeio_log);
+			return 1U << mp->m_writeio_log;
 	}
 
 	return PAGE_SIZE;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b423033e14f4..359fcfb494d4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -437,25 +437,15 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
 	xfs_sb_t	*sbp = &(mp->m_sb);
 	int		readio_log, writeio_log;
 
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
-		readio_log = XFS_READIO_LOG_LARGE;
+	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
 		writeio_log = XFS_WRITEIO_LOG_LARGE;
-	} else {
-		readio_log = mp->m_readio_log;
+	else
 		writeio_log = mp->m_writeio_log;
-	}
 
-	if (sbp->sb_blocklog > readio_log) {
-		mp->m_readio_log = sbp->sb_blocklog;
-	} else {
-		mp->m_readio_log = readio_log;
-	}
-	mp->m_readio_blocks = 1 << (mp->m_readio_log - sbp->sb_blocklog);
-	if (sbp->sb_blocklog > writeio_log) {
+	if (sbp->sb_blocklog > writeio_log)
 		mp->m_writeio_log = sbp->sb_blocklog;
-	} else {
+	} else
 		mp->m_writeio_log = writeio_log;
-	}
 	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dc81e5c264ce..fba818d5c540 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -98,8 +98,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_readio_log;	/* min read size log bytes */
-	uint			m_readio_blocks; /* min read size blocks */
 	uint			m_writeio_log;	/* min write size log bytes */
 	uint			m_writeio_blocks; /* min write size blocks */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
@@ -248,9 +246,8 @@ typedef struct xfs_mount {
 
 
 /*
- * Default minimum read and write sizes.
+ * Default write size.
  */
-#define XFS_READIO_LOG_LARGE	16
 #define XFS_WRITEIO_LOG_LARGE	16
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4089de3daded..a477348ab68b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -405,7 +405,6 @@ xfs_parseargs(
 		}
 
 		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = iosizelog;
 		mp->m_writeio_log = iosizelog;
 	}
 
-- 
2.20.1


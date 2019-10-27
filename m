Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B771ACA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BDB1214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AHLCvTQY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfJ0O4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=883m6tZVgpUkEPneynojHiSYkdYaVdUVijaCu3EAgx8=; b=AHLCvTQYkZIqha7IsNcT+kMW1z
        KJtYI0qlrt3eGK6TzpZMYCDx4U/vb2KasB3UpfY2YEBgnAG1+lKthp5r07QKnBQBf1GV+H0IWvKrb
        /h9/7+F5vtwnkKU+djmnuceOASxMyPYcXrAYe1hVHNQs+DDQXJs7oatpgBFqPALwLKwjNow97b+lo
        0SVmI/Y4rhNr2SUI7a2s9L+eX00ijbZYiqOvetazk0mqwsKYCCkEUJEvZU/RDOvUTxqdoIWkKMBo+
        K1M1EgwRx4uGGMcXRxaAsyBE4oNmeLf3hf6u/4prABJ5lIO159IWMzWdebJtg62Pm0q1u9xVYTfVg
        sXRNO2Og==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxZ-0005Mn-AR; Sun, 27 Oct 2019 14:56:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 04/12] xfs: don't use a different allocsice for -o wsync mounts
Date:   Sun, 27 Oct 2019 15:55:39 +0100
Message-Id: <20191027145547.25157-5-hch@lst.de>
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

The -o wsync allocsize overwrite overwrite was part of a special hack
for NFSv2 servers in IRIX and has no real purpose in modern Linux, so
remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 9 ++-------
 fs/xfs/xfs_mount.h | 7 -------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3b2b88..b423033e14f4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -438,13 +438,8 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
 	int		readio_log, writeio_log;
 
 	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
-		if (mp->m_flags & XFS_MOUNT_WSYNC) {
-			readio_log = XFS_WSYNC_READIO_LOG;
-			writeio_log = XFS_WSYNC_WRITEIO_LOG;
-		} else {
-			readio_log = XFS_READIO_LOG_LARGE;
-			writeio_log = XFS_WRITEIO_LOG_LARGE;
-		}
+		readio_log = XFS_READIO_LOG_LARGE;
+		writeio_log = XFS_WRITEIO_LOG_LARGE;
 	} else {
 		readio_log = mp->m_readio_log;
 		writeio_log = mp->m_writeio_log;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f69e370db341..dc81e5c264ce 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -260,13 +260,6 @@ typedef struct xfs_mount {
 #define XFS_MAX_IO_LOG		30	/* 1G */
 #define XFS_MIN_IO_LOG		PAGE_SHIFT
 
-/*
- * Synchronous read and write sizes.  This should be
- * better for NFSv2 wsync filesystems.
- */
-#define	XFS_WSYNC_READIO_LOG	15	/* 32k */
-#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
-
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
 				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
-- 
2.20.1


Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBFFCA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2496222BD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="INiib9oI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505956AbfJYRlh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:41:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505952AbfJYRlh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VCF9hpBzd7i42LXFuFU46mmpbU0fm1rU5nr46SqSNcI=; b=INiib9oIEgO0IjnxBVPM2q9lne
        4SL+/Qj9Jc7NHCKGKd8DdeipQmgWzwJ/ZHKGf+cunps5NpbBhQ2ACJ8xjG8z5cHaNt7TutTY0Suc5
        Y37sTw8dEB2hPaPHgFhuNdS35GlP+CMkbwntMoguw4drl5GBd7sxxND1kYoy1d+sN7mDFSraONoPz
        5ugjkTIcRRtBoIn3wBp4Xhi4W6REIL25wTbk7sEPhzDz0YubGx/oQklpTrOCJHiR9SFCyd2ScawqO
        Ii7xgmuuvxL3+p+MLpx7hz3aWMTG/JOSN0ltHAQYMDYF5e6QVnoKhLyxsriWfnbrkByRv4EjaZNyn
        Nokc+koA==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3ah-0005bT-Tk; Fri, 25 Oct 2019 17:41:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 6/7] xfs: clean up setting m_readio_* / m_writeio_*
Date:   Fri, 25 Oct 2019 19:40:25 +0200
Message-Id: <20191025174026.31878-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025174026.31878-1-hch@lst.de>
References: <20191025174026.31878-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fill in the default _log values in xfs_parseargs similar to other
defaults, and open code the updates based on the on-disk superblock
in xfs_mountfs now that they are completely trivial.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 36 +++++-------------------------------
 fs/xfs/xfs_super.c |  5 +++++
 2 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9800401a7d6f..bae53fdd5d51 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -425,35 +425,6 @@ xfs_update_alignment(xfs_mount_t *mp)
 	return 0;
 }
 
-/*
- * Set the default minimum read and write sizes unless
- * already specified in a mount option.
- * We use smaller I/O sizes when the file system
- * is being used for NFS service (wsync mount option).
- */
-STATIC void
-xfs_set_rw_sizes(xfs_mount_t *mp)
-{
-	xfs_sb_t	*sbp = &(mp->m_sb);
-	int		writeio_log;
-
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
-		if (mp->m_flags & XFS_MOUNT_WSYNC)
-			writeio_log = XFS_WRITEIO_LOG_WSYNC;
-		else
-			writeio_log = XFS_WRITEIO_LOG_LARGE;
-	} else {
-		writeio_log = mp->m_writeio_log;
-	}
-
-	if (sbp->sb_blocklog > writeio_log) {
-		mp->m_writeio_log = sbp->sb_blocklog;
-	} else {
-		mp->m_writeio_log = writeio_log;
-	}
-	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
-}
-
 /*
  * precalculate the low space thresholds for dynamic speculative preallocation.
  */
@@ -718,9 +689,12 @@ xfs_mountfs(
 		goto out_remove_errortag;
 
 	/*
-	 * Set the minimum read and write sizes
+	 * Update the preferred write size based on the information from the
+	 * on-disk superblock.
 	 */
-	xfs_set_rw_sizes(mp);
+	mp->m_writeio_log =
+		max_t(uint32_t, mp->m_sb.sb_blocklog, mp->m_writeio_log);
+	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - mp->m_sb.sb_blocklog);
 
 	/* set the low space thresholds for dynamic preallocation */
 	xfs_set_low_space_thresholds(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1467f4bebc41..83dbfcc5a02d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -405,6 +405,11 @@ xfs_parseargs(
 				XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
 			return -EINVAL;
 		}
+	} else {
+		if (mp->m_flags & XFS_MOUNT_WSYNC)
+			mp->m_writeio_log = XFS_WRITEIO_LOG_WSYNC;
+		else
+			mp->m_writeio_log = XFS_WRITEIO_LOG_LARGE;
 	}
 
 	return 0;
-- 
2.20.1


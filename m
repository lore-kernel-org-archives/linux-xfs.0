Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108A7CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7223222BD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TqG81/ci"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505957AbfJYRlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:41:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505952AbfJYRlk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sf48E0ZilmJkJ/aUHFEQWI8VkToVrgdIBVrdlyozehI=; b=TqG81/ciDwUiysTDcOhnDGnNzk
        Vcgudo/N6wOnca+AWN3uLpx08iiv24n/04p/40Ln58E1uyZGLpL6AaveXyIjbxVdAYzhEjPgYo4D5
        7Ry6nBtKD1raSjUfl8/VpVJjpjRkC/WqdjwO14Dv68dsemtsOdud2NEx/iKXKqhuR7BtMf3eEchoY
        emmS6b6pj8d8ryvmIUAoBTsGJT+cFQghrvDbL0M2EeETSrqKSeJWl5vBEf+SAMGT0LNWWpeZXPSHt
        9J2gs4mjjcy2Y3y2BCPLbOEu60Wl4M2yMvtu2bT0IbT7/XYCPFq8IT45SVDQ81vGds4JruHtzikzK
        eMouQ0gw==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3al-0005bs-Ia; Fri, 25 Oct 2019 17:41:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 7/7] xfs: reverse the polarity of XFS_MOUNT_COMPAT_IOSIZE
Date:   Fri, 25 Oct 2019 19:40:26 +0200
Message-Id: <20191025174026.31878-8-hch@lst.de>
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

Replace XFS_MOUNT_COMPAT_IOSIZE with an inverted XFS_MOUNT_LARGEIO flag
that makes the usage more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c  |  2 +-
 fs/xfs/xfs_mount.h |  2 +-
 fs/xfs/xfs_super.c | 12 +++---------
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 271fcbe04d48..98e30a300c64 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -510,7 +510,7 @@ xfs_stat_blksize(
 	 * default buffered I/O size, return that, otherwise return the compat
 	 * default.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)) {
+	if (mp->m_flags & XFS_MOUNT_LARGEIO) {
 		if (mp->m_swidth)
 			return mp->m_swidth << mp->m_sb.sb_blocklog;
 		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fb3a36a048cc..dde45d5664f4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -236,7 +236,7 @@ typedef struct xfs_mount {
 						 * allocation */
 #define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
 #define XFS_MOUNT_DIRSYNC	(1ULL << 21)	/* synchronous directory ops */
-#define XFS_MOUNT_COMPAT_IOSIZE	(1ULL << 22)	/* don't report large preferred
+#define XFS_MOUNT_LARGEIO	(1ULL << 22)	/* report large preferred
 						 * I/O size in stat() */
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 83dbfcc5a02d..52f4629278b0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -181,12 +181,6 @@ xfs_parseargs(
 	if (sb->s_flags & SB_SYNCHRONOUS)
 		mp->m_flags |= XFS_MOUNT_WSYNC;
 
-	/*
-	 * Set some default flags that could be cleared by the mount option
-	 * parsing.
-	 */
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-
 	/*
 	 * These can be overridden by the mount option parsing.
 	 */
@@ -275,10 +269,10 @@ xfs_parseargs(
 			mp->m_flags &= ~XFS_MOUNT_IKEEP;
 			break;
 		case Opt_largeio:
-			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
+			mp->m_flags |= XFS_MOUNT_LARGEIO;
 			break;
 		case Opt_nolargeio:
-			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+			mp->m_flags &= ~XFS_MOUNT_LARGEIO;
 			break;
 		case Opt_attr2:
 			mp->m_flags |= XFS_MOUNT_ATTR2;
@@ -438,12 +432,12 @@ xfs_showargs(
 		{ XFS_MOUNT_GRPID,		",grpid" },
 		{ XFS_MOUNT_DISCARD,		",discard" },
 		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
+		{ XFS_MOUNT_LARGEIO,		",largeio" },
 		{ XFS_MOUNT_DAX,		",dax" },
 		{ 0, NULL }
 	};
 	static struct proc_xfs_info xfs_info_unset[] = {
 		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_COMPAT_IOSIZE,	",largeio" },
 		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
 		{ 0, NULL }
 	};
-- 
2.20.1


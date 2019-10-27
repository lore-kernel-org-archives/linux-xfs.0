Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CC2CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C469214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HwtdwZKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfJ0O4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VcKaw5F5PYI4COMHEBVTIQitKi5wFwRxvD88ehBlpmQ=; b=HwtdwZKVnfTmZRTod/rTqqaOyp
        X2TbFdAbW/wi71FA5i7BivImJhUx+kW1bCnStuMLk032oz7XRPCjf1pDRDn5NvaPfsmCgW76YKefh
        Hm9I2dnHVSt2YIcYNjpc3LcmMQYVQHlVhHRTf4sNFT7N8v7L+XsMDGq2/34zg75qQljdEUG5/FlGc
        2f3/rc4XnccNtRsps9osUQ2bv+jnCQWekqY6Qr2OosLkdOav99FWkemEaZHAXWNmH9cduMO1t0Zsb
        pIo96WrppoylF0pSHF37aPOk3zNQyBDZfec3eKELIYzS6C8T7cFpEwwzawU0cCMia3mcLhg12zcli
        clGNPdhw==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxn-0005Ol-IC; Sun, 27 Oct 2019 14:56:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 09/12] xfs: reverse the polarity of XFS_MOUNT_COMPAT_IOSIZE
Date:   Sun, 27 Oct 2019 15:55:44 +0100
Message-Id: <20191027145547.25157-10-hch@lst.de>
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

Replace XFS_MOUNT_COMPAT_IOSIZE with an inverted XFS_MOUNT_LARGEIO flag
that makes the usage more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_iops.c  |  2 +-
 fs/xfs/xfs_mount.h |  2 +-
 fs/xfs/xfs_super.c | 12 +++---------
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9e1f89cdcc82..18e45e3a3f9f 100644
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
 		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e5c364f1605e..a46cb3fd24b1 100644
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
index a7d89b87ed22..f21c59822a38 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -180,12 +180,6 @@ xfs_parseargs(
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
@@ -274,10 +268,10 @@ xfs_parseargs(
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
@@ -430,12 +424,12 @@ xfs_showargs(
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


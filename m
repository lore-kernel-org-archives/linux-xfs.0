Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86634C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F58F2076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rLfUlI/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgEXJSW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbgEXJSU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A8AC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=aEwP2bZPSR3pY3wCiPAUjqxdjQDdOwUs2gJK2mJP1HU=; b=rLfUlI/D0NWJxSsaNUlpPDPpS3
        lreqREdkufM4h1q4S9cl0NJVeUEbBu8xXlUi+pmIoIAPNaJzuSl9b+HfqFVrKu3KJztAN14qJT1PU
        WY+q0sEDgObl6xQ9rqATp42F/nmfK9uwOUz1lF+H80FtAf/2eoZW3Tq2NWXttESmuzI5thVwRyBQL
        nBjOjOmaDBdUEjn1NgAPRM93shuh9xdSzVvYa+JZE+BR69p0xxsO0HeQoYssLL9BAXJdR9S0CWrL6
        diAZrWsNF2C2uWeRMqltADY4cMAetwPRW2LWBtmjLjs/8WZzuyJuQeBHpAWEDyKogNciZBkeWUdW1
        SonrNASg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmlv-0004rv-Or
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/14] xfs: move the di_flushiter field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:50 +0200
Message-Id: <20200524091757.128995-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524091757.128995-1-hch@lst.de>
References: <20200524091757.128995-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the
flushiter field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h |  1 -
 fs/xfs/xfs_icache.c           |  2 +-
 fs/xfs/xfs_inode.c            | 19 +++++++++----------
 fs/xfs/xfs_inode.h            |  1 +
 fs/xfs/xfs_inode_item.c       |  2 +-
 6 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 860e35611e001..03bd7cdd0ddc8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -205,7 +205,7 @@ xfs_inode_from_disk(
 	 * inode. If the inode is unused, mode is zero and we shouldn't mess
 	 * with the unitialized part of it.
 	 */
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 	if (!inode->i_mode)
@@ -329,7 +329,7 @@ xfs_inode_to_disk(
 		to->di_flushiter = 0;
 	} else {
 		to->di_version = 2;
-		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 663a97fa78f05..8cc96f2766ff4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint16_t	di_flushiter;	/* incremented on flush */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e24f98712ee46..5cd36486af1ef 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -521,7 +521,7 @@ xfs_iget_cache_miss(
 	 * simply build the new inode core with a random generation number.
 	 *
 	 * For version 4 (and older) superblocks, log recovery is dependent on
-	 * the di_flushiter field being initialised from the current on-disk
+	 * the i_flushiter field being initialised from the current on-disk
 	 * value and hence we must also read the inode off disk even when
 	 * initializing new inodes.
 	 */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ef6a4c313ebbd..805f63fb3c8b4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3763,16 +3763,15 @@ xfs_iflush_int(
 	}
 
 	/*
-	 * Inode item log recovery for v2 inodes are dependent on the
-	 * di_flushiter count for correct sequencing. We bump the flush
-	 * iteration count so we can detect flushes which postdate a log record
-	 * during recovery. This is redundant as we now log every change and
-	 * hence this can't happen but we need to still do it to ensure
-	 * backwards compatibility with old kernels that predate logging all
-	 * inode changes.
+	 * Inode item log recovery for v2 inodes are dependent on the flushiter
+	 * count for correct sequencing.  We bump the flush iteration count so
+	 * we can detect flushes which postdate a log record during recovery.
+	 * This is redundant as we now log every change and hence this can't
+	 * happen but we need to still do it to ensure backwards compatibility
+	 * with old kernels that predate logging all inode changes.
 	 */
 	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
-		ip->i_d.di_flushiter++;
+		ip->i_flushiter++;
 
 	/*
 	 * If there are inline format data / attr forks attached to this inode,
@@ -3793,8 +3792,8 @@ xfs_iflush_int(
 	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
-	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
-		ip->i_d.di_flushiter = 0;
+	if (ip->i_flushiter == DI_MAX_FLUSH)
+		ip->i_flushiter = 0;
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f6aa97fde63cb..91259403ba741 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -59,6 +59,7 @@ typedef struct xfs_inode {
 	uint32_t		i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
 	uint32_t		i_cowextsize;	/* basic cow extent size */
+	uint16_t		i_flushiter;	/* incremented on flush */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index ab0d8cf8ceb6a..8357fe37d3eb8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -351,7 +351,7 @@ xfs_inode_to_log_dinode(
 		to->di_flushiter = 0;
 	} else {
 		to->di_version = 2;
-		to->di_flushiter = from->di_flushiter;
+		to->di_flushiter = ip->i_flushiter;
 	}
 }
 
-- 
2.26.2


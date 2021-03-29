Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063C6C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A696196D
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhC2Fkb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhC2FkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F35DC061756
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6JFz+QgeV0v/PwU4SsoTguzFKtuEu8lVqHrUG+6VqEg=; b=Txhxtau8HvC1wMNrNDaVd+JM/H
        6+OrxN1aO29soWsgVJgyB/l4VS+Zzz3YXiojArdbaNtFa5vqGd090oeVTFOENw5DrQWTEmmNrH0/y
        6MllbzGNuGSfFquvlG1EvoJ3xJi5RX71Tm184lqLFLm7DmFQkiwp5kGwllNGEwfKuWzJBmPP67g9p
        DGjVM26kcF1ErVi1sPsmotwjFD7UaRESbd2WwWPiD6TFls/N6wXKG2DyCfoqSSBlw8TCMoailDwAY
        u4JtMD2TvrN5kr3w3xIOFubF2/YwRcFvnmWhmf8uh4wTguJXJ8C2c6qvFehu0vkt3GwSMTtHJNsuG
        hL9V+TmQ==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkc9-006oPu-IV; Mon, 29 Mar 2021 05:39:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 12/20] xfs: move the di_flushiter field to struct xfs_inode
Date:   Mon, 29 Mar 2021 07:38:21 +0200
Message-Id: <20210329053829.1851318-13-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the
flushiter field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h |  1 -
 fs/xfs/xfs_icache.c           |  2 +-
 fs/xfs/xfs_inode.c            | 19 +++++++++----------
 fs/xfs/xfs_inode.h            |  1 +
 fs/xfs/xfs_inode_item.c       |  2 +-
 6 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 2656acbb95e608..3c7eb01c66ace4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -193,7 +193,7 @@ xfs_inode_from_disk(
 	 * inode. If the inode is unused, mode is zero and we shouldn't mess
 	 * with the uninitialized part of it.
 	 */
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 	if (!inode->i_mode)
@@ -327,7 +327,7 @@ xfs_inode_to_disk(
 		to->di_flushiter = 0;
 	} else {
 		to->di_version = 2;
-		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 77d250dbe96848..e41a11bef04436 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint16_t	di_flushiter;	/* incremented on flush */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 354ae973000305..afb705d1aef54e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -499,7 +499,7 @@ xfs_iget_cache_miss(
 	 * simply build the new inode core with a random generation number.
 	 *
 	 * For version 4 (and older) superblocks, log recovery is dependent on
-	 * the di_flushiter field being initialised from the current on-disk
+	 * the i_flushiter field being initialised from the current on-disk
 	 * value and hence we must also read the inode off disk even when
 	 * initializing new inodes.
 	 */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cfd589c64ad9c3..06d779c9334b80 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3454,16 +3454,15 @@ xfs_iflush(
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
@@ -3484,8 +3483,8 @@ xfs_iflush(
 	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
-	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
-		ip->i_d.di_flushiter = 0;
+	if (ip->i_flushiter == DI_MAX_FLUSH)
+		ip->i_flushiter = 0;
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6d8ec38f252081..abe5b44b46220a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -59,6 +59,7 @@ typedef struct xfs_inode {
 	prid_t			i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
 	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
+	uint16_t		i_flushiter;	/* incremented on flush */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index ebb2ce03f8e04c..b5fbff17e9e4dd 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -396,7 +396,7 @@ xfs_inode_to_log_dinode(
 		to->di_flushiter = 0;
 	} else {
 		to->di_version = 2;
-		to->di_flushiter = from->di_flushiter;
+		to->di_flushiter = ip->i_flushiter;
 	}
 }
 
-- 
2.30.1


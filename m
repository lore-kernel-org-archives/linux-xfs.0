Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AECC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 362F92076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K06RlxQH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgEXJSj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgEXJSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE0FC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=MwmhA+qDnuSpCqJcGpf3BStUnMHLADI+PHZEKeK+JhE=; b=K06RlxQHRrmJc9viUIBWv6FOFg
        Mos6K2lWYLeOwr8KeU5RZPBvxRIFPbG2XDf9oiUCnp55hEPGWsrefBdcZAEGUIzUACOhb2KF48lsv
        nE5jYNNO4yDXD+AgkOk9aJFGVHigYoFPeZOnsjPL9kuJNgJc7bhxo3eSVSbCB7nLF0uBwGdP5D4Fq
        KUzrQBW27FSyXxgLU8SVcNpQ7734DMI0m8CQ+fInweRAPlCHHNzNV4kq9ptZ+nyG0T1KSlokvP1qe
        II1dcCnCPWdAp6Q4pfbAk54m19QhtT8mOm64lr10GMjx8UL8B1H6PgHHb8bp7GuHPdQD9mbnDPMoY
        GGgtlzkg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmmF-0004zp-2R
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/14] xfs: move the di_dmstate field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:57 +0200
Message-Id: <20200524091757.128995-15-hch@lst.de>
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

Move the di_dmstate into struct xfs_inode, and thus finally kill of
the xfs_icdinode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  6 ++----
 fs/xfs/libxfs/xfs_inode_buf.h | 10 ----------
 fs/xfs/xfs_inode.c            |  2 +-
 fs/xfs/xfs_inode.h            |  3 +--
 fs/xfs/xfs_inode_item.c       |  3 +--
 fs/xfs/xfs_itable.c           |  3 ---
 6 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d361803102d0e..e4e96a47e0bab 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -185,7 +185,6 @@ xfs_inode_from_disk(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
 {
-	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 	int			error;
 	xfs_failaddr_t		fa;
@@ -247,7 +246,7 @@ xfs_inode_from_disk(
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	ip->i_forkoff = from->di_forkoff;
 	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
-	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
+	ip->i_dmstate	= be16_to_cpu(from->di_dmstate);
 	ip->i_diflags	= be16_to_cpu(from->di_flags);
 
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
@@ -282,7 +281,6 @@ xfs_inode_to_disk(
 	struct xfs_dinode	*to,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
@@ -313,7 +311,7 @@ xfs_inode_to_disk(
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
-	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_dmstate = cpu_to_be16(ip->i_dmstate);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
 
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 0cfc1aaff6c6f..834c8b3e91737 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -9,16 +9,6 @@
 struct xfs_inode;
 struct xfs_dinode;
 
-/*
- * In memory representation of the XFS inode. This is held in the in-core struct
- * xfs_inode and represents the current on disk values but the structure is not
- * in on-disk format.  That is, this structure is always translated to on-disk
- * format specific structures at the appropriate time.
- */
-struct xfs_icdinode {
-	uint16_t	di_dmstate;	/* DMIG state info */
-};
-
 /*
  * Inode location information.  Stored in the inode and passed to
  * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0b92ce18cf957..1269b3c7b3a6b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -834,7 +834,7 @@ xfs_ialloc(
 
 	ip->i_extsize = 0;
 	ip->i_dmevmask = 0;
-	ip->i_d.di_dmstate = 0;
+	ip->i_dmstate = 0;
 	ip->i_diflags = 0;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 46dc9612af138..7b167a6159929 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -68,8 +68,7 @@ typedef struct xfs_inode {
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
 	uint32_t		i_dmevmask;	/* DMIG event mask */
-
-	struct xfs_icdinode	i_d;		/* most of ondisk inode */
+	uint16_t		i_dmstate;	/* DMIG state info */
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9b7860025c497..628f8190abddc 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -301,7 +301,6 @@ xfs_inode_to_log_dinode(
 	struct xfs_log_dinode	*to,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
@@ -331,7 +330,7 @@ xfs_inode_to_log_dinode(
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = ip->i_dmevmask;
-	to->di_dmstate = from->di_dmstate;
+	to->di_dmstate = ip->i_dmstate;
 	to->di_flags = ip->i_diflags;
 
 	/* log a dummy value to ensure log structure is fully initialised */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7945c6c484494..cd1f09e57b948 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -58,7 +58,6 @@ xfs_bulkstat_one_int(
 	xfs_ino_t		ino,
 	struct xfs_bstat_chunk	*bc)
 {
-	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
@@ -79,8 +78,6 @@ xfs_bulkstat_one_int(
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
 
-	dic = &ip->i_d;
-
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-- 
2.26.2


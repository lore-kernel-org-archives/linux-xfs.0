Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00032C433F2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF02D6197F
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC2Fkd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhC2FkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FAEC061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IGyeMRUOg5V2A18C84+v6bt8kELf7N0ybGlYJ9IjsFM=; b=QTyg0KWoCGn3gt6MLXtoOBBpEo
        ZkRIk17iYBKzoe2OPB/3jW2q7TrDb3VV9PE2PW19PFyxzfYCH4pHF4f0JYJJx/dnxgyRE1EWndwBu
        bTm/4JJ32XaHbuMe9oYinFq+nJkQpOgOV42eYLn7qhNZxW5w070QJWU+teX3H7EJNKe2lW8r2cJxy
        c+z7N3Vi66sisTEJOCc5ufGT+E4bnW9BKJ0FHvh5IM7lguKkg9EkTVIwB10+8FK45x5cAm4ph0zxp
        tQnklYzMdTQyR684UzP4dzsczjRWoAZ7YDzs+2wQ+eJj/XHOo4roAemZ8rzhPeABuqM4ysauyuUOG
        6jsv9YEQ==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkcO-006oQK-RQ; Mon, 29 Mar 2021 05:39:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 19/20] xfs: move the di_crtime field to struct xfs_inode
Date:   Mon, 29 Mar 2021 07:38:28 +0200
Message-Id: <20210329053829.1851318-20-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the crtime field from struct xfs_icdinode into stuct xfs_inode and
remove the now entirely unused struct xfs_icdinode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h      |  5 ++---
 fs/xfs/libxfs/xfs_inode_buf.c   |  6 ++----
 fs/xfs/libxfs/xfs_inode_buf.h   | 10 ----------
 fs/xfs/libxfs/xfs_trans_inode.c |  2 +-
 fs/xfs/xfs_inode.c              |  2 +-
 fs/xfs/xfs_inode.h              |  3 +--
 fs/xfs/xfs_inode_item.c         |  3 +--
 fs/xfs/xfs_iops.c               |  2 +-
 fs/xfs/xfs_itable.c             |  7 ++-----
 9 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 630388b72dbe3f..76e2461b9e663f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -955,9 +955,8 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
  * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
  * below.
  *
- * There is a very similar struct icdinode in xfs_inode which matches the
- * layout of the first 96 bytes of this structure, but is kept in native
- * format instead of big endian.
+ * There is a very similar struct xfs_log_dinode which matches the layout of
+ * this structure, but is kept in native format instead of big endian.
  *
  * Note: di_flushiter is only used by v1/2 inodes - it's effectively a zeroed
  * padding field for v3 inodes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 82ee4b6ca7874f..5c9a7440d9e4ed 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -173,7 +173,6 @@ xfs_inode_from_disk(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
 {
-	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 	int			error;
 	xfs_failaddr_t		fa;
@@ -239,7 +238,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
+		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
 		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
 		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -286,7 +285,6 @@ xfs_inode_to_disk(
 	struct xfs_dinode	*to,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
@@ -318,7 +316,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
+		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
 		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 2f6015acfda81b..7f865bb4df840b 100644
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
-	struct timespec64 di_crtime;	/* time created */
-};
-
 /*
  * Inode location information.  Stored in the inode and passed to
  * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 102920303454df..78324e043e2572 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -70,7 +70,7 @@ xfs_trans_ichgtime(
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
 	if (flags & XFS_ICHGTIME_CREATE)
-		ip->i_d.di_crtime = tv;
+		ip->i_crtime = tv;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5aff2f9db751a9..3006cfbd072617 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -843,7 +843,7 @@ xfs_init_new_inode(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_cowextsize = 0;
-		ip->i_d.di_crtime = tv;
+		ip->i_crtime = tv;
 	}
 
 	flags = XFS_ILOG_CORE;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 02cb0e1a56f62b..74ffca251e0d0b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -66,8 +66,7 @@ typedef struct xfs_inode {
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
-
-	struct xfs_icdinode	i_d;		/* most of ondisk inode */
+	struct timespec64	i_crtime;	/* time created */
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1284672fda02b3..c1b32680f71c73 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -350,7 +350,6 @@ xfs_inode_to_log_dinode(
 	struct xfs_log_dinode	*to,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
@@ -386,7 +385,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, from->di_crtime);
+		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
 		to->di_flags2 = ip->i_diflags2;
 		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 4f9bb7e54fd30d..607b3f263b0644 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -599,7 +599,7 @@ xfs_vn_getattr(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
-			stat->btime = ip->i_d.di_crtime;
+			stat->btime = ip->i_crtime;
 		}
 	}
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 8799e38bd466c6..f331975a16dea7 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -60,7 +60,6 @@ xfs_bulkstat_one_int(
 	struct xfs_bstat_chunk	*bc)
 {
 	struct user_namespace	*sb_userns = mp->m_super->s_user_ns;
-	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
@@ -81,8 +80,6 @@ xfs_bulkstat_one_int(
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
 
-	dic = &ip->i_d;
-
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
@@ -111,8 +108,8 @@ xfs_bulkstat_one_int(
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
-		buf->bs_btime = dic->di_crtime.tv_sec;
-		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
+		buf->bs_btime = ip->i_crtime.tv_sec;
+		buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = ip->i_cowextsize;
 	}
-- 
2.30.1


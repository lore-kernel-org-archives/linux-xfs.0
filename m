Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EC0C433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D1861A07
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbhCXOWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbhCXOWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:22:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210CDC061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=vR3J6bQ0KoGDwypIkgbmfGfVrb8w074si4XgRA60z3Y=; b=mJYpOgeE62r/OpuDGtFmLe743y
        hvjYEKwBVJoqbSvGAEaXLb1LgGtfGz15aeN6CUBgM4jjUn/irxLrfKuuKw06oVcmqPWLnaFHmTPv7
        zRQhBDSaLWh6nArcp8U60+athRoLh7B2xQW82eSCGNit7T4UorAc5DG3PtZsJyd3XC0HlsAVli5IV
        IwJEZeK4pYE9Tu62nH5dG/h1s4b7mNoh1rlFgLIx8IENr1SPz4fGc0vPDAxW7hJy6y8AClawmjofM
        HYTXegbmZYeKaAN0ixllB561dOjsyZp3waYvid6lvA/UI1mVh7WhXvanBWEsqSK2WIPNOkfx4Oo5K
        QDskoHvQ==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4Oo-0045YL-Cm
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:22:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/18] xfs: move the di_crtime field to struct xfs_inode
Date:   Wed, 24 Mar 2021 15:21:29 +0100
Message-Id: <20210324142129.1011766-19-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the crtime
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 630388b72dbe3f..c73378a4f8624d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -955,9 +955,8 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
  * attribute use the XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR macros
  * below.
  *
- * There is a very similar struct icdinode in xfs_inode which matches the
- * layout of the first 96 bytes of this structure, but is kept in native
- * format instead of big endian.
+ * There is a very similar struct xfs_log_inode which matches the layout of the
+ * this structure, but is kept in native format instead of big endian.
  *
  * Note: di_flushiter is only used by v1/2 inodes - it's effectively a zeroed
  * padding field for v3 inodes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f3df60e3452e1e..36d6d46be8e7d4 100644
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
index 28d57353bdfa57..21765ddc329861 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -842,7 +842,7 @@ xfs_init_new_inode(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_cowextsize = 0;
-		ip->i_d.di_crtime = tv;
+		ip->i_crtime = tv;
 	}
 
 	flags = XFS_ILOG_CORE;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8fb87d3d98d174..767da7eaf696d0 100644
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
index 912c453b6fe46d..a79a3c52d105b0 100644
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
index df958611e854af..1bf4f37dc78806 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -567,7 +567,7 @@ xfs_vn_getattr(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
-			stat->btime = ip->i_d.di_crtime;
+			stat->btime = ip->i_crtime;
 		}
 	}
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1f33f13d33a901..39a2352428626b 100644
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


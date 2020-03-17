Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D7FC1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05F820735
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uzMuCQI9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgCQTEg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:04:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57308 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgCQTEg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:04:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=arhBM7ODFTcSa5+qFFe5tvRABS+f3ocF1NHE3qWZLHw=; b=uzMuCQI9oiAiJXmV2poCGyFAUd
        Kcwe2oJL03qLrh69sk0HGCtU1LcqqVKvq9ZNgg9J4vH4vfmfmiwihiAbEMAYfmOlHi5Gd+95ssGQ0
        2lD1mZ493v4hzOX2HcHHWI7HI1FzTGoIJ8nEKniM8DacOrfaF5SnhRc+2AaOEmnwtPqgrkxwC/rQA
        8X4KV+l3wWc6VF7Kqfu+bkbyHaIUWn3QBuxwecfPwgP56dYAvXfO629W04zfzdDw51DBSPNf94ex5
        +VXgcERsFPF6bu5/ca4STzoppNSxZ0s7UTvVhGE/9XbxXBZlfDlUmKM24PueZzL8Fy2Zv9PiAhOfo
        W9+WZs7g==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHVz-0003Dw-Gh; Tue, 17 Mar 2020 19:04:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 2/5] xfs: only check the superblock version for dinode size calculation
Date:   Tue, 17 Mar 2020 19:57:53 +0100
Message-Id: <20200317185756.1063268-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317185756.1063268-1-hch@lst.de>
References: <20200317185756.1063268-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The size of the dinode structure is only dependent on the file system
version, so instead of checking the individual inode version just use
the newly added xfs_sb_version_has_large_dinode helper, and simplify
various calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
 fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
 fs/xfs/libxfs/xfs_format.h     | 16 ++++++++--------
 fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
 fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
 fs/xfs/xfs_inode_item.c        |  4 ++--
 fs/xfs/xfs_log_recover.c       |  2 +-
 fs/xfs/xfs_symlink.c           |  2 +-
 11 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6eda1828a079..863444e2dda7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -537,7 +537,7 @@ xfs_attr_shortform_bytesfit(
 	int			offset;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
+	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -604,8 +604,7 @@ xfs_attr_shortform_bytesfit(
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
-			XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8057486c02b5..fda13cd7add0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -193,14 +193,12 @@ xfs_default_attroffset(
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			offset;
 
-	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp, ip->i_d.di_version) -
-				XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	} else {
+	if (mp->m_sb.sb_inodesize == 256)
+		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	else
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
-	}
 
-	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
+	ASSERT(offset < XFS_LITINO(mp));
 	return offset;
 }
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 19899d48517c..045556e78ee2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -954,8 +954,12 @@ enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_LITINO(mp, version) \
-	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
+#define XFS_DINODE_SIZE(sbp) \
+	(xfs_sb_version_has_v3inode(sbp) ? \
+		sizeof(struct xfs_dinode) : \
+		offsetof(struct xfs_dinode, di_crc))
+#define XFS_LITINO(mp) \
+	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
 
 /*
  * Inode data & attribute fork sizes, per inode.
@@ -964,13 +968,9 @@ enum xfs_dinode_fmt {
 #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp, (dip)->di_version))
+	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
 #define XFS_DFORK_ASIZE(dip,mp) \
-	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
-		0)
+	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_DFORK_DSIZE(dip, mp) : \
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4de61af3b840..7fcf62b324b0 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -339,7 +339,7 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = xfs_dinode_size(version);
+			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c862c8f1aaa9..240d74840306 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -417,7 +417,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
+		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
 		break;
 	default:
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ad2b9c313fd2..518c6f0ec3a6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -183,7 +183,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
+	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 500333d0101e..668ee942be22 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -46,14 +46,9 @@ struct xfs_ifork {
 			(ip)->i_afp : \
 			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
+	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
-	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
-			XFS_IFORK_BOFF(ip) : \
-		0)
+	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 9bac0d2e56dc..e3400c9c71cd 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -424,12 +424,10 @@ struct xfs_log_dinode {
 	/* structure must be padded to 64 bit alignment */
 };
 
-static inline uint xfs_log_dinode_size(int version)
-{
-	if (version == 3)
-		return sizeof(struct xfs_log_dinode);
-	return offsetof(struct xfs_log_dinode, di_next_unlinked);
-}
+#define xfs_log_dinode_size(mp)						\
+	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
+		sizeof(struct xfs_log_dinode) :				\
+		offsetof(struct xfs_log_dinode, di_next_unlinked))
 
 /*
  * Buffer Log Format definitions
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f021b55a0301..451f9b6b2806 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -125,7 +125,7 @@ xfs_inode_item_size(
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_log_dinode_size(ip->i_d.di_version);
+		   xfs_log_dinode_size(ip->i_mount);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
 	if (XFS_IFORK_Q(ip))
@@ -370,7 +370,7 @@ xfs_inode_item_format_core(
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
-	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
+	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
 }
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c467488212c2..308cc5dcac14 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3068,7 +3068,7 @@ xlog_recover_inode_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	isize = xfs_log_dinode_size(ldip->di_version);
+	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
 				     XFS_ERRLEVEL_LOW, mp, ldip,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ea42e25ec1bf..fa0fa3c70f1a 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -192,7 +192,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
+	if (pathlen <= XFS_LITINO(mp))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
-- 
2.24.1


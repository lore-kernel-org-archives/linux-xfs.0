Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3F4C4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D00208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jPd8nhPr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgEGMVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:21:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FCFC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=10feJf+/ohgp3zFKwhqgALSqPI5EIpKGDdRAe324Ibo=; b=jPd8nhPrPXX8SxcRrW7BuzBW5s
        jnoCHNaIEZ6nlgVVHZX2A967LxVL3t/uPyQonbA+iy/VtNf1SR5sws6hHWD4Lm7CYghuNTU3z6FDO
        OgzhuWho5f6xwbtZZ7KvimFflBRSheeXafUh4G6qidlxRDQpRG24Whn/0cqFxWCTMPmYpttWaGtMK
        +FUr7iUdUBdY7KQqQVXDBex99aQgvuCEEKoSw5M0hUWC6xn+Men7ZH4/0IfQDALL1H3Yt6uCQA2Fv
        STqPrOrIYKGHVOhKVBSzQHrAguuztgaNQPh0p4z6/tcHd2PUyT7OyWaVyhoCJ+ol4xNkp7dqhXa9D
        xXdJADYg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWY-00085S-Mz; Thu, 07 May 2020 12:21:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 56/58] xfs: only check the superblock version for dinode size calculation
Date:   Thu,  7 May 2020 14:18:49 +0200
Message-Id: <20200507121851.304002-57-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: e9e2eae89ddb658ea332295153fdca78c12c1e0d

The size of the dinode structure is only dependent on the file system
version, so instead of checking the individual inode version just use
the newly added xfs_sb_version_has_large_dinode helper, and simplify
various calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c               |  3 +--
 db/metadump.c            |  6 ++----
 libxfs/xfs_attr_leaf.c   |  5 ++---
 libxfs/xfs_bmap.c        | 10 ++++------
 libxfs/xfs_format.h      | 16 ++++++++--------
 libxfs/xfs_ialloc.c      |  2 +-
 libxfs/xfs_inode_buf.c   |  2 +-
 libxfs/xfs_inode_fork.c  |  2 +-
 libxfs/xfs_inode_fork.h  |  9 ++-------
 libxfs/xfs_log_format.h  | 10 ++++------
 logprint/log_misc.c      |  5 ++++-
 logprint/log_print_all.c |  6 ++++--
 repair/dinode.c          | 13 ++++++-------
 repair/prefetch.c        |  2 +-
 14 files changed, 41 insertions(+), 50 deletions(-)

diff --git a/db/check.c b/db/check.c
index 6ade70b3..a8b96836 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2771,8 +2771,7 @@ process_inode(
 		error++;
 		return;
 	}
-	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >=
-					XFS_LITINO(mp, xino.i_d.di_version))  {
+	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >= XFS_LITINO(mp))  {
 		if (v)
 			dbprintf(_("bad fork offset %d for inode %lld\n"),
 				xino.i_d.di_forkoff, id->ino);
diff --git a/db/metadump.c b/db/metadump.c
index ac0e28b2..e5cb3aa5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2382,8 +2382,7 @@ process_inode(
 	if (free_inode) {
 		if (zero_stale_data) {
 			/* Zero all of the inode literal area */
-			memset(XFS_DFORK_DPTR(dip), 0,
-			       XFS_LITINO(mp, dip->di_version));
+			memset(XFS_DFORK_DPTR(dip), 0, XFS_LITINO(mp));
 		}
 		goto done;
 	}
@@ -2416,8 +2415,7 @@ process_inode(
 	nametable_clear();
 
 	/* copy extended attributes if they exist and forkoff is valid */
-	if (success &&
-	    XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp, dip->di_version)) {
+	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 832979c9..92a2abe1 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -534,7 +534,7 @@ xfs_attr_shortform_bytesfit(
 	int			offset;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
+	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -601,8 +601,7 @@ xfs_attr_shortform_bytesfit(
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
-			XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c00133ac..11f3f5f9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -186,14 +186,12 @@ xfs_default_attroffset(
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
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f00012c0..a738cd8b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index fd102ab3..d2e80d0a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -334,7 +334,7 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = xfs_dinode_size(version);
+			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 496aadc0..857e5ea6 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -414,7 +414,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
+		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
 		break;
 	default:
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 819faa63..80ba6c12 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -181,7 +181,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
+	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
 			(unsigned long long) ip->i_ino, size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 500333d0..668ee942 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
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
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 9bac0d2e..e3400c9c 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 45f697fc..4a90b58c 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -563,7 +563,10 @@ xlog_print_trans_inode(
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += xfs_log_dinode_size(dino.di_version);
+    if (dino.di_version >= 3)
+	*ptr += sizeof(struct xfs_log_dinode);
+    else
+	*ptr += offsetof(struct xfs_log_dinode, di_next_unlinked);
     skip_count--;
 
     switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 32d13719..97c46aef 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -285,8 +285,10 @@ xlog_recover_print_inode(
 	       f->ilf_dsize);
 
 	/* core inode comes 2nd */
-	ASSERT(item->ri_buf[1].i_len == xfs_log_dinode_size(2) ||
-		item->ri_buf[1].i_len == xfs_log_dinode_size(3));
+	ASSERT(item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode) ||
+	       item->ri_buf[1].i_len ==
+	       offsetof(struct xfs_log_dinode, di_next_unlinked));
+
 	xlog_recover_print_inode_core((struct xfs_log_dinode *)
 				      item->ri_buf[1].i_addr);
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 3367c40e..d06e38c0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -143,7 +143,7 @@ clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
 	clear_dinode_unlinked(mp, dino);
 
 	/* and clear the forks */
-	memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp, dino->di_version));
+	memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp));
 	return;
 }
 
@@ -1017,7 +1017,7 @@ process_lclinode(
 	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_size) >
 						XFS_DFORK_DSIZE(dip, mp)) {
 		do_warn(
-	_("local inode %" PRIu64 " data fork is too large (size = %lld, max = %d)\n"),
+	_("local inode %" PRIu64 " data fork is too large (size = %lld, max = %zd)\n"),
 		       lino, (unsigned long long) be64_to_cpu(dip->di_size),
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
@@ -1025,7 +1025,7 @@ process_lclinode(
 		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			do_warn(
-	_("local inode %" PRIu64 " attr fork too large (size %d, max = %d)\n"),
+	_("local inode %" PRIu64 " attr fork too large (size %d, max = %zd)\n"),
 				lino, be16_to_cpu(asf->hdr.totsize),
 				XFS_DFORK_ASIZE(dip, mp));
 			return(1);
@@ -1797,12 +1797,11 @@ _("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dino->di_forkoff >=
-				(XFS_LITINO(mp, dino->di_version) >> 3)) {
+		if (dino->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
 			do_warn(
-_("bad attr fork offset %d in inode %" PRIu64 ", max=%d\n"),
+_("bad attr fork offset %d in inode %" PRIu64 ", max=%zd\n"),
 				dino->di_forkoff, lino,
-				XFS_LITINO(mp, dino->di_version) >> 3);
+				XFS_LITINO(mp) >> 3);
 			return 1;
 		}
 		break;
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 2eff6e07..3ac49db1 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -445,7 +445,7 @@ pf_read_inode_dirs(
 			continue;
 
 		if ((dino->di_forkoff != 0) &&
-		    (dino->di_forkoff >= XFS_LITINO(mp, dino->di_version) >> 3))
+		    (dino->di_forkoff >= XFS_LITINO(mp) >> 3))
 			continue;
 
 		switch (dino->di_format) {
-- 
2.26.2


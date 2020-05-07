Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFFEC38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53EB820CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HIC/IwT5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgEGMVJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:21:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E86C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dWO83nY6sYYF3F4Ea2gkLA9wNh5eAPf5Pn6evF93UF4=; b=HIC/IwT5hpaMo2EAt9DgRc93Kr
        aKNmTflzyw71apVjG8ENCMKpYDfDTpLPvSpr9dRaaIFSKk0h+9Zz4h3dT30wr7AXnWJ9GIkAobhLa
        TO4WW/Q2gc/K0bhOeEdae7okeqohPdX6XnMpnXhinO/xdP5ZsrOLWJq4x7TPrSq6Slmxh+vYFWVZi
        xqDnXq8jSHdC2h4Fj5iQUYsy9/EL4Rqi6EQWLJyY1RKm2B9WZBgCmiJ15xF4zkk04YI7mtciN1hCE
        eDgWL3fM0//PupVvwiP0MUnpdktxJhhlRRk2m1Ou1aRyDyX0Q8bQ3Qdcq97YJur57UdT82ntS9mUN
        scin6mXw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWW-00084e-85; Thu, 07 May 2020 12:21:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 55/58] xfs: add a new xfs_sb_version_has_v3inode helper
Date:   Thu,  7 May 2020 14:18:48 +0200
Message-Id: <20200507121851.304002-56-hch@lst.de>
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

Source kernel commit: b81b79f4eda2ea98ae5695c0b6eb384c8d90b74d

Add a new wrapper to check if a file system supports the v3 inode format
with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
that, which is technically correct but a little confusing to read.

Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
so that we have one place that documents the superblock version to
inode version relationship.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c              |  2 +-
 libxfs/xfs_format.h     | 17 +++++++++++++++++
 libxfs/xfs_ialloc.c     |  4 ++--
 libxfs/xfs_inode_buf.c  | 17 +++--------------
 libxfs/xfs_inode_buf.h  |  2 --
 libxfs/xfs_trans_resv.c |  2 +-
 repair/dinode.c         |  2 +-
 repair/prefetch.c       |  2 +-
 8 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/db/check.c b/db/check.c
index 217060b5..6ade70b3 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2723,7 +2723,7 @@ process_inode(
 		error++;
 		return;
 	}
-	if (!libxfs_dinode_good_version(mp, xino.i_d.di_version)) {
+	if (!libxfs_dinode_good_version(&mp->m_sb, xino.i_d.di_version)) {
 		if (isfree || v)
 			dbprintf(_("bad version number %#x for inode %lld\n"),
 				xino.i_d.di_version, ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 09fd5d23..f00012c0 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -497,6 +497,23 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+/*
+ * v5 file systems support V3 inodes only, earlier file systems support
+ * v2 and v1 inodes.
+ */
+static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
+		uint8_t version)
+{
+	if (xfs_sb_version_has_v3inode(sbp))
+		return version == 3;
+	return version == 1 || version == 2;
+}
+
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 616256b4..fd102ab3 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -299,7 +299,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -2867,7 +2867,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 64651d4e..496aadc0 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -41,17 +41,6 @@ xfs_inobp_check(
 }
 #endif
 
-bool
-xfs_dinode_good_version(
-	struct xfs_mount *mp,
-	__u8		version)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return version == 3;
-
-	return version == 1 || version == 2;
-}
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -90,7 +79,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(mp, dip->di_version) &&
+			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
@@ -451,7 +440,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -626,7 +615,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
 		ip->i_d.di_version = 3;
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 2683e1e2..66de5964 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -59,8 +59,6 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
-bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
-
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 5f3279d4..9ce7d8f9 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -186,7 +186,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_has_v3inode(&mp->m_sb))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
diff --git a/repair/dinode.c b/repair/dinode.c
index 8da224db..3367c40e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2317,7 +2317,7 @@ process_dinode_int(xfs_mount_t *mp,
 		}
 	}
 
-	if (!libxfs_dinode_good_version(mp, dino->di_version)) {
+	if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version)) {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 2b7ac36f..2eff6e07 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -438,7 +438,7 @@ pf_read_inode_dirs(
 		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
 			continue;
 
-		if (!libxfs_dinode_good_version(mp, dino->di_version))
+		if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version))
 			continue;
 
 		if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))
-- 
2.26.2


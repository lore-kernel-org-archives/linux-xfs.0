Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D960CC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B01A421582
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="awQ1o9jH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEGMVO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:21:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F2AC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wK/E/ehQPRhZK8ORDBeYjmvjmw2SiNyhyeoirJqetX0=; b=awQ1o9jHtqjpuIipsXhL+PQWay
        ELtVFsjUr2kwC43xjpcPbI4SNFHVgBxVgP6WCrEcPsMorgoAKLSprO4LinO7kF4ORP0aGidC8xTJI
        Xt0LsqDJhYTh73aPY2k9CfTREFbhrPOPDlsjoGLTTBtF5/8j7sioQ4539vVAEVI1fwBud/WIpDORG
        N+OQy5tM34SzkXGeS7XdBOBYnO/7BVaAkDs8ds1T+k1FBib3/kNJ/QFyC2QH2t+w/kjK1PjDZJgwv
        red3MNeL5a0165rkKhDjRSkLlC4EJe7SF5X1e8gD15yxq1iiFC6ZEwCvSwNyftFJS3JXK/kdsj+kx
        /AWYThbg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWb-00087Y-Cx; Thu, 07 May 2020 12:21:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 57/58] xfs: remove the di_version field from struct icdinode
Date:   Thu,  7 May 2020 14:18:50 +0200
Message-Id: <20200507121851.304002-58-hch@lst.de>
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

Source kernel commit: 6471e9c5e7a109a952be8e3e80b8d9e262af239d

We know the version is 3 if on a v5 file system.   For earlier file
systems formats we always upgrade the remaining v1 inodes to v2 and
thus only use v2 inodes.  Use the xfs_sb_version_has_large_dinode
helper to check if we deal with small or large dinodes, and thus
remove the need for the di_version field in struct icdinode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c             |  4 ++--
 libxfs/util.c          | 20 +++-----------------
 libxfs/xfs_inode_buf.c | 16 ++++++----------
 libxfs/xfs_inode_buf.h |  1 -
 repair/phase6.c        | 15 +++------------
 5 files changed, 14 insertions(+), 42 deletions(-)

diff --git a/db/check.c b/db/check.c
index a8b96836..a57a692a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2723,10 +2723,10 @@ process_inode(
 		error++;
 		return;
 	}
-	if (!libxfs_dinode_good_version(&mp->m_sb, xino.i_d.di_version)) {
+	if (!libxfs_dinode_good_version(&mp->m_sb, dip->di_version)) {
 		if (isfree || v)
 			dbprintf(_("bad version number %#x for inode %lld\n"),
-				xino.i_d.di_version, ino);
+				dip->di_version, ino);
 		error++;
 		return;
 	}
diff --git a/libxfs/util.c b/libxfs/util.c
index 88ed67f7..dba83e76 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -228,6 +228,7 @@ libxfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
 	uint		flags;
@@ -259,20 +260,6 @@ libxfs_ialloc(
 	ip->i_d.di_projid = pip ? 0 : fsx->fsx_projid;
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
-	/*
-	 * We only support filesystems that understand v2 format inodes. So if
-	 * this is currently an old format inode, then change the inode version
-	 * number now.  This way we only do the conversion here rather than here
-	 * and in the flush/logging code.
-	 */
-	if (ip->i_d.di_version == 1) {
-		ip->i_d.di_version = 2;
-		/*
-		 * old link count, projid_lo/hi field, pad field
-		 * already zeroed
-		 */
-	}
-
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
 		VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
@@ -289,7 +276,7 @@ libxfs_ialloc(
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		ASSERT(ip->i_d.di_ino == ino);
 		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
 		VFS_I(ip)->i_version = 1;
@@ -382,7 +369,6 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 		ip->i_d.di_nextents > ip->i_df.if_ext_max);
-	ASSERT(ip->i_d.di_version > 1);
 
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
@@ -403,7 +389,7 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 	ASSERT(ip->i_d.di_forkoff <= mp->m_sb.sb_inodesize);
 
 	/* bump the change count on v3 inodes */
-	if (ip->i_d.di_version == 3)
+	if (xfs_sb_version_has_v3inode(&mp->m_sb))
 		VFS_I(ip)->i_version++;
 
 	/* Check the inline fork data before we write out. */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 857e5ea6..b65cd0b1 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -191,16 +191,14 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
+	 * They will also be unconditionally written back to disk as v2 inodes.
 	 */
-	to->di_version = from->di_version;
-	if (to->di_version == 1) {
+	if (unlikely(from->di_version == 1)) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid = 0;
-		to->di_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
@@ -238,7 +236,7 @@ xfs_inode_from_disk(
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
-	if (to->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
@@ -260,7 +258,6 @@ xfs_inode_to_disk(
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
@@ -289,7 +286,8 @@ xfs_inode_to_disk(
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
@@ -301,6 +299,7 @@ xfs_inode_to_disk(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
@@ -618,7 +617,6 @@ xfs_iread(
 	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
-		ip->i_d.di_version = 3;
 		return 0;
 	}
 
@@ -660,7 +658,6 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_version = dip->di_version;
 		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
@@ -674,7 +671,6 @@ xfs_iread(
 		VFS_I(ip)->i_mode = 0;
 	}
 
-	ASSERT(ip->i_d.di_version >= 2);
 	ip->i_delayed_blks = 0;
 
 	/*
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 66de5964..9b373dcf 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_projid;	/* owner's project id */
diff --git a/repair/phase6.c b/repair/phase6.c
index beceea9a..a938e802 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -519,7 +519,6 @@ mk_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		vers;
 	int		times;
 	uint		blocks;
 
@@ -538,18 +537,16 @@ mk_rbmino(xfs_mount_t *mp)
 			error);
 	}
 
-	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	VFS_I(ip)->i_mode = S_IFREG;
-	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
@@ -765,7 +762,6 @@ mk_rsumino(xfs_mount_t *mp)
 	int		nsumblocks;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		vers;
 	int		times;
 	uint		blocks;
 
@@ -784,18 +780,16 @@ mk_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
-	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	VFS_I(ip)->i_mode = S_IFREG;
-	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
@@ -870,7 +864,6 @@ mk_root_dir(xfs_mount_t *mp)
 	int		error;
 	const mode_t	mode = 0755;
 	ino_tree_node_t	*irec;
-	int		vers;
 	int		times;
 
 	ip = NULL;
@@ -887,18 +880,16 @@ mk_root_dir(xfs_mount_t *mp)
 	/*
 	 * take care of the core -- initialization from xfs_ialloc()
 	 */
-	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	VFS_I(ip)->i_mode = mode|S_IFDIR;
-	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	set_nlink(VFS_I(ip), 2);	/* account for . and .. */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		VFS_I(ip)->i_version = 1;
 		ip->i_d.di_flags2 = 0;
 		times |= XFS_ICHGTIME_CREATE;
-- 
2.26.2


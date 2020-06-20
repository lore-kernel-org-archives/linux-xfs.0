Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04A8C433E2
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6DE5224DF
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uSmbEG9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFTHLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgFTHLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9F1C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=IQc7gOfIcmJyYfYz6ZbZgPvo2TELlUv2R/q9tp2cKJ4=; b=uSmbEG9YHJ+PpYS2lchgtAs/tC
        LdrGiqaaVbc85wc4CPn7+uu13zwL00bhuxSMWWqYFszmMzD632kwAF1EYSHqyVeE79I1su5j5eMdY
        YQAdJnfyfjXWIIc3xJGfRmGdE8BUWlFFtvDNH7cXAOdor8dQ8R1xQMHsEENqR+rwaDECvtrZP3aNT
        4xtO/l+ADvU3PFS34uq1rmBU1kX/l1U139iUIVaFnbwF03YzAihxv9cKeayHZ+Teyls8B8FTaSjcX
        iSY5mNVlKjnCQEAImL3W+T4kIjYtLOXyIDaJQCMKuo+r07bZgQjycwIJi+0tX8SL1CCVE40feOauK
        5kyMR7Pg==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXeh-0000xi-Eb
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] xfs: move the di_projid field to struct xfs_inode
Date:   Sat, 20 Jun 2020 09:10:49 +0200
Message-Id: <20200620071102.462554-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the projid
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.h | 1 -
 fs/xfs/xfs_bmap_util.c        | 2 +-
 fs/xfs/xfs_dquot.c            | 2 +-
 fs/xfs/xfs_icache.c           | 4 ++--
 fs/xfs/xfs_inode.c            | 6 +++---
 fs/xfs/xfs_inode.h            | 3 ++-
 fs/xfs/xfs_inode_item.c       | 4 ++--
 fs/xfs/xfs_ioctl.c            | 8 ++++----
 fs/xfs/xfs_iops.c             | 2 +-
 fs/xfs/xfs_itable.c           | 2 +-
 fs/xfs/xfs_qm.c               | 8 ++++----
 fs/xfs/xfs_qm_bhv.c           | 2 +-
 13 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6f84ea85fdd837..b064cb8072c84a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -218,10 +218,10 @@ xfs_inode_from_disk(
 	 */
 	if (unlikely(from->di_version == 1)) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
-		to->di_projid = 0;
+		ip->i_projid = 0;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
-		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
+		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
 					be16_to_cpu(from->di_projid_lo);
 	}
 
@@ -290,8 +290,8 @@ xfs_inode_to_disk(
 	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
-	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
-	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
+	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
+	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 865ac493c72a24..b826d81b356956 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,6 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f37f5cc4b19ffe..e42553884c23cf 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1217,7 +1217,7 @@ xfs_swap_extents_check_format(
 	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
 	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
 	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
-	     ip->i_d.di_projid != tip->i_d.di_projid))
+	     ip->i_projid != tip->i_projid))
 		return -EINVAL;
 
 	/* Should never get a local format */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d5b7f03e93c8db..912b978a6a72d5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -868,7 +868,7 @@ xfs_qm_id_for_quotatype(
 	case XFS_DQ_GROUP:
 		return i_gid_read(VFS_I(ip));
 	case XFS_DQ_PROJ:
-		return ip->i_d.di_projid;
+		return ip->i_projid;
 	}
 	ASSERT(0);
 	return 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 660e7abd4e8b76..a3bbd6e4bb6fc8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1439,7 +1439,7 @@ xfs_inode_match_id(
 		return false;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    ip->i_d.di_projid != eofb->eof_prid)
+	    ip->i_projid != eofb->eof_prid)
 		return false;
 
 	return true;
@@ -1463,7 +1463,7 @@ xfs_inode_match_id_union(
 		return true;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    ip->i_d.di_projid == eofb->eof_prid)
+	    ip->i_projid == eofb->eof_prid)
 		return true;
 
 	return false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 88a9e496480216..40e4d3ed29a798 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -806,7 +806,7 @@ xfs_ialloc(
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
-	ip->i_d.di_projid = prid;
+	ip->i_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		inode->i_gid = VFS_I(pip)->i_gid;
@@ -1398,7 +1398,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
+		     tdp->i_projid != sip->i_projid)) {
 		error = -EXDEV;
 		goto error_return;
 	}
@@ -3264,7 +3264,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
+		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index dadcf19458960d..51ea9d53407863 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -54,6 +54,7 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
+	uint32_t		i_projid;	/* owner's project id */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
@@ -175,7 +176,7 @@ static inline prid_t
 xfs_get_initial_prid(struct xfs_inode *dp)
 {
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		return dp->i_d.di_projid;
+		return dp->i_projid;
 
 	return XFS_PROJID_DEFAULT;
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index ba47bf65b772be..e546b4b58ce2e0 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = i_uid_read(inode);
 	to->di_gid = i_gid_read(inode);
-	to->di_projid_lo = from->di_projid & 0xffff;
-	to->di_projid_hi = from->di_projid >> 16;
+	to->di_projid_lo = ip->i_projid & 0xffff;
+	to->di_projid_hi = ip->i_projid >> 16;
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a40f88cf3ab786..d93f4fc40fd99e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1110,7 +1110,7 @@ xfs_fill_fsxattr(
 	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_projid = ip->i_d.di_projid;
+	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
 	else
@@ -1518,7 +1518,7 @@ xfs_ioctl_setattr(
 	}
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
-	    ip->i_d.di_projid != fa->fsx_projid) {
+	    ip->i_projid != fa->fsx_projid) {
 		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
@@ -1555,12 +1555,12 @@ xfs_ioctl_setattr(
 		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
 
 	/* Change the ownerships and register project quota modifications */
-	if (ip->i_d.di_projid != fa->fsx_projid) {
+	if (ip->i_projid != fa->fsx_projid) {
 		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
-		ip->i_d.di_projid = fa->fsx_projid;
+		ip->i_projid = fa->fsx_projid;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d66528fa365707..5440f555c9cc2c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -696,7 +696,7 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 16ca97a7ff00fb..97b3b794dd4ada 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -84,7 +84,7 @@ xfs_bulkstat_one_int(
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_projectid = ip->i_d.di_projid;
+	buf->bs_projectid = ip->i_projid;
 	buf->bs_ino = ino;
 	buf->bs_uid = i_uid_read(inode);
 	buf->bs_gid = i_gid_read(inode);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d6cd833173447a..ea22dcf868b474 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -346,7 +346,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
+		error = xfs_qm_dqattach_one(ip, ip->i_projid, XFS_DQ_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
@@ -1711,7 +1711,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (ip->i_d.di_projid != prid) {
+		if (ip->i_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
 					true, &pq);
@@ -1844,7 +1844,7 @@ xfs_qm_vop_chown_reserve(
 	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
+	    ip->i_projid != be32_to_cpu(pdqp->q_core.d_id)) {
 		pdq_delblks = pdqp;
 		if (delblks) {
 			ASSERT(ip->i_pdquot);
@@ -1942,7 +1942,7 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
+		ASSERT(ip->i_projid == be32_to_cpu(pdqp->q_core.d_id));
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index fc2fa418919f7f..b616ad772a6df8 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,7 @@ xfs_qm_statvfs(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*dqp;
 
-	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
-- 
2.26.2


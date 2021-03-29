Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB259C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15D661968
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhC2Fk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC2Fj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:39:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0FBC061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=XVIOQdSCx2cDZxwy3qWQGAmvUvdgAkNWQ8pqwOlnaLs=; b=yPC0RhwCUQDIjOenbpCgu2lurp
        lg9ook3c35VMyiz4TW2OwIs4f/rc9askKGRpevUvf7off7+P8u8KyVEp2abXXOeA2DR6/eDhbQiOR
        9e7bdV+hHmfqC39GM6kA4zXHMA0EmSleqJAsszYxIffopykH3+PX5/u/0/GaI7QmSwfaKIrpPh4Yd
        vVEctR5sTODSLZ1mGrCiIfncG+3uuyxhtDgf+d9LqzAbsTth0VKzDp3goqghett6DoLT6JGvFMFNq
        5q1CHFD+ds233hrkh95ZefRU4iD8jypAVg6R70hBhL3ozDhgEA1z6/2hrakqsAkYyWqg12okHfVIs
        WVlhwNHA==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkby-006oPI-1j
        for linux-xfs@vger.kernel.org; Mon, 29 Mar 2021 05:38:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/20] xfs: move the di_projid field to struct xfs_inode
Date:   Mon, 29 Mar 2021 07:38:16 +0200
Message-Id: <20210329053829.1851318-8-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
 fs/xfs/xfs_ioctl.c            | 6 +++---
 fs/xfs/xfs_iops.c             | 2 +-
 fs/xfs/xfs_itable.c           | 2 +-
 fs/xfs/xfs_qm.c               | 4 ++--
 fs/xfs/xfs_qm_bhv.c           | 2 +-
 13 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 917a41828ffbe3..671aeb012e3f59 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -206,10 +206,10 @@ xfs_inode_from_disk(
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
 
@@ -294,8 +294,8 @@ xfs_inode_to_disk(
 	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
-	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
-	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
+	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
+	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index d7a019df05d647..406f667992883f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,6 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	prid_t		di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e7d68318e6a55c..0a63728cc8f25c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1208,7 +1208,7 @@ xfs_swap_extents_check_format(
 	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
 	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
 	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
-	     ip->i_d.di_projid != tip->i_d.di_projid))
+	     ip->i_projid != tip->i_projid))
 		return -EINVAL;
 
 	/* Should never get a local format */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bd8379b98374f8..7fb63a04400fab 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -953,7 +953,7 @@ xfs_qm_id_for_quotatype(
 	case XFS_DQTYPE_GROUP:
 		return i_gid_read(VFS_I(ip));
 	case XFS_DQTYPE_PROJ:
-		return ip->i_d.di_projid;
+		return ip->i_projid;
 	}
 	ASSERT(0);
 	return 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fae6392f7c5650..47dfc70d4ed1a6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1204,7 +1204,7 @@ xfs_inode_match_id(
 		return false;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    ip->i_d.di_projid != eofb->eof_prid)
+	    ip->i_projid != eofb->eof_prid)
 		return false;
 
 	return true;
@@ -1228,7 +1228,7 @@ xfs_inode_match_id_union(
 		return true;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    ip->i_d.di_projid == eofb->eof_prid)
+	    ip->i_projid == eofb->eof_prid)
 		return true;
 
 	return false;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9c8fd11a53622a..7f2762a6c4c68e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -809,7 +809,7 @@ xfs_init_new_inode(
 	inode = VFS_I(ip);
 	set_nlink(inode, nlink);
 	inode->i_rdev = rdev;
-	ip->i_d.di_projid = prid;
+	ip->i_projid = prid;
 
 	if (dir && !(dir->i_mode & S_ISGID) &&
 	    (mp->m_flags & XFS_MOUNT_GRPID)) {
@@ -1288,7 +1288,7 @@ xfs_link(
 	 * the tree quota mechanism could be circumvented.
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
+		     tdp->i_projid != sip->i_projid)) {
 		error = -EXDEV;
 		goto error_return;
 	}
@@ -3126,7 +3126,7 @@ xfs_rename(
 	 * tree quota mechanism would be circumvented.
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
+		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d3369c0bcd9de7..3e55cb878162f2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -54,6 +54,7 @@ typedef struct xfs_inode {
 	/* Miscellaneous state. */
 	unsigned long		i_flags;	/* see defined flags below */
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
+	prid_t			i_projid;	/* owner's project id */
 
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
index 16e758a689217e..ddc4b456864a39 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -357,8 +357,8 @@ xfs_inode_to_log_dinode(
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
index 99dfe89a8d08b8..8d22127284d360 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1123,7 +1123,7 @@ xfs_fill_fsxattr(
 	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_projid = ip->i_d.di_projid;
+	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
 	else
@@ -1505,12 +1505,12 @@ xfs_ioctl_setattr(
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
index 5b8ac9b6cef8e7..710d9ee42e35f9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -737,7 +737,7 @@ xfs_setattr_nonsize(
 		 */
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
-		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_d.di_projid,
+		error = xfs_qm_vop_dqalloc(ip, uid, gid, ip->i_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 5593d50835c72e..81d34a525593ed 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,7 +86,7 @@ xfs_bulkstat_one_int(
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_projectid = ip->i_d.di_projid;
+	buf->bs_projectid = ip->i_projid;
 	buf->bs_ino = ino;
 	buf->bs_uid = from_kuid(sb_userns, i_uid_into_mnt(mnt_userns, inode));
 	buf->bs_gid = from_kgid(sb_userns, i_gid_into_mnt(mnt_userns, inode));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6fde318b9fed27..0a22b947897bc7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1716,7 +1716,7 @@ xfs_qm_vop_dqalloc(
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(O_pdqpp);
-		if (ip->i_d.di_projid != prid) {
+		if (ip->i_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, prid,
 					XFS_DQTYPE_PROJ, true, &pq);
@@ -1877,7 +1877,7 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(ip->i_d.di_projid == pdqp->q_id);
+		ASSERT(ip->i_projid == pdqp->q_id);
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 639398091ad6ba..df00dfbf5c9d19 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,7 @@ xfs_qm_statvfs(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*dqp;
 
-	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
-- 
2.30.1


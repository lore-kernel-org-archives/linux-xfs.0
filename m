Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C0DC433EB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217E461A0F
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhCXOWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbhCXOWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:22:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD45C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=b8KqM9ukmLf7xLerNGUdnJVET902+HPOLR2J9/dySdg=; b=Q9FpCf+xth8J9dAsBNmuxTbnSE
        MDxT3/RHhCluZ766UlXa11KdiEbvHo2Fdzq+pg43eQtAuf/PSU1LlUnZJ1kmS8GJLkrhArHrPd041
        mZ7HTvIT9RCZ9AWFTmUfTCX4gx/W3DEg41iKQKH+vd1gxzFQdvbetiTXs/iQrf/R3mWSGpwf4/PB5
        Y+FRbF6tQ5OPMwAfqGHFou9vjj4Tgv0lo69ljt+avZh7mx81nUMPZUE6l2IiHXFdh/J0IdBskz3w3
        sqDvy6JrKFr0sLj2F2hlTYBhdFy0f4M916dXGL71dIqnz8UwEzhSPxfkf9CFaKgvqfTfuNdebtheH
        tT9tt3vw==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4OW-0045Xd-Ev
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:22:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/18] xfs: move the di_cowextsize field to struct xfs_inode
Date:   Wed, 24 Mar 2021 15:21:22 +0100
Message-Id: <20210324142129.1011766-12-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the
cowextsize field into the containing xfs_inode structure.  Also
switch to use the xfs_extlen_t instead of a uint32_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h | 1 -
 fs/xfs/xfs_file.c             | 2 +-
 fs/xfs/xfs_inode.c            | 6 +++---
 fs/xfs/xfs_inode.h            | 1 +
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_ioctl.c            | 8 +++-----
 fs/xfs/xfs_itable.c           | 2 +-
 fs/xfs/xfs_reflink.c          | 2 +-
 9 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fa21fb84c2d232..9f208d2c8ddb4d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -240,7 +240,7 @@ xfs_inode_from_disk(
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
-		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
+		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 
 	error = xfs_iformat_data_fork(ip, from);
@@ -319,7 +319,7 @@ xfs_inode_to_disk(
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 6bc78856373e31..77d250dbe96848 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -21,7 +21,6 @@ struct xfs_icdinode {
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	uint64_t	di_flags2;	/* more random flags */
-	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 
 	struct timespec64 di_crtime;	/* time created */
 };
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4c930078f45d82..d755fbf3640bee 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1162,7 +1162,7 @@ xfs_file_remap_range(
 	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
 	    pos_out == 0 && len >= i_size_read(inode_out) &&
 	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		cowextsize = src->i_d.di_cowextsize;
+		cowextsize = src->i_cowextsize;
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ccd179900f21cf..b8f38423f8c451 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -81,7 +81,7 @@ xfs_get_cowextsz_hint(
 
 	a = 0;
 	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_d.di_cowextsize;
+		a = ip->i_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
 	a = max(a, b);
@@ -754,7 +754,7 @@ xfs_inode_inherit_flags2(
 {
 	if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
 		ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-		ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+		ip->i_cowextsize = pip->i_cowextsize;
 	}
 	if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
 		ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
@@ -843,7 +843,7 @@ xfs_init_new_inode(
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
-		ip->i_d.di_cowextsize = 0;
+		ip->i_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 84cc2e74ba1961..36eb33d9bcbdcc 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -58,6 +58,7 @@ typedef struct xfs_inode {
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	uint32_t		i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
+	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8a1411effd327d..44902fd513eb0b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -388,7 +388,7 @@ xfs_inode_to_log_dinode(
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, from->di_crtime);
 		to->di_flags2 = from->di_flags2;
-		to->di_cowextsize = from->di_cowextsize;
+		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ec769219e435e9..e45bce9b11082c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1121,8 +1121,7 @@ xfs_fill_fsxattr(
 
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
 	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
-			ip->i_mount->m_sb.sb_blocklog;
+	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
@@ -1524,10 +1523,9 @@ xfs_ioctl_setattr(
 		ip->i_extsize = 0;
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
-				mp->m_sb.sb_blocklog;
+		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
 	else
-		ip->i_d.di_cowextsize = 0;
+		ip->i_cowextsize = 0;
 
 	error = xfs_trans_commit(tp);
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ce95cb1a9bc9f5..43f8a89c9786c7 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -114,7 +114,7 @@ xfs_bulkstat_one_int(
 		buf->bs_btime = dic->di_crtime.tv_sec;
 		buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-			buf->bs_cowextsize_blks = dic->di_cowextsize;
+			buf->bs_cowextsize_blks = ip->i_cowextsize;
 	}
 
 	switch (ip->i_df.if_format) {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 306f13dfbfd856..d8735b3ee0f807 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -934,7 +934,7 @@ xfs_reflink_update_dest(
 	}
 
 	if (cowextsize) {
-		dest->i_d.di_cowextsize = cowextsize;
+		dest->i_cowextsize = cowextsize;
 		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
-- 
2.30.1


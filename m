Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6963BC433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E172076C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SLg0dI74"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgEXJSS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgEXJSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA63C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=51YmiywOg7hYwOToITVv7akfQbFBcOUtBIltxvPHcjc=; b=SLg0dI74cw+7UXaJS2pEQLWC1m
        cot9ZQXopMhcMMe6OoavDVU3tHzNivURU+jGkrQn1Z2CefG0eYB+iqJVvCGEwGop4YkLi102K+81r
        n5KV78HxN1EdgBQmjhe2fJmECUg0lMQr2lyPuMaDZzeoBonYcvT3/2rMj+rUIZgz3AtbmP1l+kti3
        wXWRsviYv7Wd862chh+fvcr3sitzTOHZPdfNxpNtX1yNfF58dHPZ9JdS1ahc+UbQ7dD8XBocCP4dc
        DxwLWQXA1i1BRNiz9nP5SAMGCigAR/eFnahG3dA2yDhdyYvbw1Jalz2hGwA2kzSuzxhUtEcAchjfB
        0S3wDgJA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmls-0004rd-Vq
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/14] xfs: move the di_cowextsize field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:49 +0200
Message-Id: <20200524091757.128995-7-hch@lst.de>
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

In preparation of removing the historic icinode struct, move the
cowextsize field into the containing xfs_inode structure.

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
index e51b15c44bb3e..860e35611e001 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -255,7 +255,7 @@ xfs_inode_from_disk(
 		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
-		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
+		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 
 	error = xfs_iformat_data_fork(ip, from);
@@ -321,7 +321,7 @@ xfs_inode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index d420ea835c839..663a97fa78f05 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -23,7 +23,6 @@ struct xfs_icdinode {
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	uint64_t	di_flags2;	/* more random flags */
-	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 
 	struct timespec64 di_crtime;	/* time created */
 };
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 14b533a8ce8e6..b0384306d6622 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1055,7 +1055,7 @@ xfs_file_remap_range(
 	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
 	    pos_out == 0 && len >= i_size_read(inode_out) &&
 	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		cowextsize = src->i_d.di_cowextsize;
+		cowextsize = src->i_cowextsize;
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 777dadc3fd531..ef6a4c313ebbd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -82,7 +82,7 @@ xfs_get_cowextsz_hint(
 
 	a = 0;
 	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_d.di_cowextsize;
+		a = ip->i_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
 	a = max(a, b);
@@ -842,7 +842,7 @@ xfs_ialloc(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
-		ip->i_d.di_cowextsize = 0;
+		ip->i_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
 
@@ -901,7 +901,7 @@ xfs_ialloc(
 		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
 				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+				ip->i_cowextsize = pip->i_cowextsize;
 			}
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
 				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index af90c6f745549..f6aa97fde63cb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -58,6 +58,7 @@ typedef struct xfs_inode {
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	uint32_t		i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
+	uint32_t		i_cowextsize;	/* basic cow extent size */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8b8c99809f273..ab0d8cf8ceb6a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -343,7 +343,7 @@ xfs_inode_to_log_dinode(
 		to->di_crtime.t_sec = from->di_crtime.tv_sec;
 		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
 		to->di_flags2 = from->di_flags2;
-		to->di_cowextsize = from->di_cowextsize;
+		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index aeb1de3aec60f..a9b31ae3c28c0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1108,8 +1108,7 @@ xfs_fill_fsxattr(
 
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
 	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
-			ip->i_mount->m_sb.sb_blocklog;
+	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
 	fa->fsx_projid = ip->i_projid;
 	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
 		fa->fsx_nextents = xfs_iext_count(ifp);
@@ -1574,10 +1573,9 @@ xfs_ioctl_setattr(
 		ip->i_extsize = 0;
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
-				mp->m_sb.sb_blocklog;
+		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
 	else
-		ip->i_d.di_cowextsize = 0;
+		ip->i_cowextsize = 0;
 
 	code = xfs_trans_commit(tp);
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index b0f0c19fd7822..7937af9f2ea77 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -112,7 +112,7 @@ xfs_bulkstat_one_int(
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-			buf->bs_cowextsize_blks = dic->di_cowextsize;
+			buf->bs_cowextsize_blks = ip->i_cowextsize;
 	}
 
 	switch (ip->i_df.if_format) {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8598896156e29..0e07fa7e43117 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -942,7 +942,7 @@ xfs_reflink_update_dest(
 	}
 
 	if (cowextsize) {
-		dest->i_d.di_cowextsize = cowextsize;
+		dest->i_cowextsize = cowextsize;
 		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
-- 
2.26.2


Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17212C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFB7B207D8
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="trmPW5QC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgEXJSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgEXJSe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1797BC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=B9rXlgBci+TY0Ws5c8AkUPsRMSFTTNCoQSkihRcYoXQ=; b=trmPW5QCdB7OwFGnXjpr9G5cV4
        xnGnifxKlMJgEeRZPvE49NaxeFcYlKugBEJbVw7vBXGBSGGb7d6C9WJtf8oUKcgXgXGdX2Ev7b4lz
        oquEAqOMuL8mEP/VA00xvZwfErwM/S1qOCqpby/S9G7HlykvNKSPeJEPh18HCQ3X8sYKwg5tdIBCI
        1qTzdsrDWbtu26CrwcsYTplzvo0poTWQU/C6qumK0ftnYn4T8kUBwBQiX+jX6gptUaWGCx0A0PzJi
        /neArzgslHckdPoAXpdecivjOVtqFV3xeY+9WQuYJ3Uw8h8TGjF76h8Rz2t+GXJF+BKSqdLqS43eL
        cz7w11mA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmm9-0004vp-Ia
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/14] xfs: move the di_crtime field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:55 +0200
Message-Id: <20200524091757.128995-13-hch@lst.de>
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

In preparation of removing the historic icinode struct, move the crtime
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c   | 8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.h   | 2 --
 fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
 fs/xfs/xfs_inode.c              | 2 +-
 fs/xfs/xfs_inode.h              | 1 +
 fs/xfs/xfs_inode_item.c         | 4 ++--
 fs/xfs/xfs_iops.c               | 2 +-
 fs/xfs/xfs_itable.c             | 4 ++--
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 79e470933abfa..af595ee23635a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -253,8 +253,8 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		ip->i_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
+		ip->i_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
 		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -319,8 +319,8 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		to->di_crtime.t_sec = cpu_to_be32(ip->i_crtime.tv_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(ip->i_crtime.tv_nsec);
 		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 4bfad6d6d5710..2a8e7a7ed8d18 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -18,8 +18,6 @@ struct xfs_dinode;
 struct xfs_icdinode {
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
-
-	struct timespec64 di_crtime;	/* time created */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index b5dfb66548422..3c690829634cd 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -67,7 +67,7 @@ xfs_trans_ichgtime(
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
 	if (flags & XFS_ICHGTIME_CREATE)
-		ip->i_d.di_crtime = tv;
+		ip->i_crtime = tv;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4a98c7d46a302..aa91217b0fd7f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -841,7 +841,7 @@ xfs_ialloc(
 		inode_set_iversion(inode, 1);
 		ip->i_diflags2 = 0;
 		ip->i_cowextsize = 0;
-		ip->i_d.di_crtime = tv;
+		ip->i_crtime = tv;
 	}
 
 	flags = XFS_ILOG_CORE;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c3ff0f2536dd8..c77ecde5e6e0d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -66,6 +66,7 @@ typedef struct xfs_inode {
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
+	struct timespec64	i_crtime;	/* time created */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 04e671d2957ca..dff3bc6a33720 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -340,8 +340,8 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
+		to->di_crtime.t_sec = ip->i_crtime.tv_sec;
+		to->di_crtime.t_nsec = ip->i_crtime.tv_nsec;
 		to->di_flags2 = ip->i_diflags2;
 		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 3642f9935cae3..6aace9c6586ca 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -559,7 +559,7 @@ xfs_vn_getattr(
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
-			stat->btime = ip->i_d.di_crtime;
+			stat->btime = ip->i_crtime;
 		}
 	}
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4d1509437c357..7945c6c484494 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -97,8 +97,8 @@ xfs_bulkstat_one_int(
 	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
 	buf->bs_ctime = inode->i_ctime.tv_sec;
 	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
-	buf->bs_btime = dic->di_crtime.tv_sec;
-	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
+	buf->bs_btime = ip->i_crtime.tv_sec;
+	buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
 	buf->bs_gen = inode->i_generation;
 	buf->bs_mode = inode->i_mode;
 
-- 
2.26.2


Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1003FC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D3E238E1
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 07:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oUuz/j2g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgFTHLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 03:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFTHLp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD443C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=6RxVIuxJugZxFn7fg2VZBMLKFXidMtKMGW/77CAO+L4=; b=oUuz/j2g0+P7CjWotZJtB6AfYW
        baUHaxjXq/MavOOWXeUzyfjbph9AV+9S9t9Us8de/GkLR1QCnFjUL1fSLoCg1kYGChmaUQ1Z9oDNl
        1Cq0462gHdKLsa4MyJLgcBHhESS0BexDhF/G+E3Efm0spKW0iHuY3X37lHKOrQFesIZatEd8kcTqD
        /UACtMfyjgsrj2kUZCL1o8zVaZ8H7vW1BxNvCqP6UTunuWQPw2vWVyjjeGvbuMWVfGSWU7Uw1drlV
        ySKRjkdC2fzTBNx1Wll6ktkPpA59l6bkplUlggARHo9Tc5I3khw2BQiYv/U7JsoGKVreYvBnkAmq9
        wDX+INqA==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXfE-000122-AW
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/15] xfs: move the di_crtime field to struct xfs_inode
Date:   Sat, 20 Jun 2020 09:11:00 +0200
Message-Id: <20200620071102.462554-14-hch@lst.de>
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
index 79e470933abfa8..af595ee23635aa 100644
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
index 4bfad6d6d5710a..2a8e7a7ed8d18d 100644
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
index b5dfb665484223..3c690829634cdc 100644
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
index 593e8c5c2fd658..59f11314750a46 100644
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
index 709f04fadde65e..106a8d6cc010cb 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -66,6 +66,7 @@ typedef struct xfs_inode {
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
+	struct timespec64	i_crtime;	/* time created */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 04e671d2957ca2..dff3bc6a33720a 100644
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
index 3642f9935cae3f..6aace9c6586ca5 100644
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
index 4d1509437c3576..7945c6c4844940 100644
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


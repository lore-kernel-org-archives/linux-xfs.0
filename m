Return-Path: <SRS0=FSF3=YN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16C4CA9EA0
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 08:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCF1221928
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 08:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A0gE0bgv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJTIVv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:21:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIVv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Oct 2019 04:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SPAHzQuxB6vD3WbiX6tkFeiLcmLWkhQInZ1pRFDxuts=; b=A0gE0bgvBULBA1T2FCKy0reKV
        i6xLpfbmUl+eTvTjw3JAdRIhmJoHgdar3m4qOBC7F8RLwzLcXYowkZq7AfLP8Pcg+I5P4Z84lid6i
        cW2hdLjJHCBaCIyt7zgouNzmMHz0HnmNTx7cxUT5E2t4ZneGBJsXvp52lM5xhT2f8cxYGaKmknBt/
        N4SPdheBoOmG/uoffMcOxULWJXtd8pRISBrMCewZ2riYFlHVCPqWlSK6UK1pw28PB4ky6z5GPpSXV
        dsdA6TJNfYRoev6nyJiLzhec7WQ44IGgU5ldDTgUahb+1fwguvq7Ahuq6N9MvQpnh3EurHc1yfKOj
        FmQ7gjXSg==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iM6TG-0004d3-Fk
        for linux-xfs@vger.kernel.org; Sun, 20 Oct 2019 08:21:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: use a struct timespec64 for the in-core crtime
Date:   Sun, 20 Oct 2019 10:21:42 +0200
Message-Id: <20191020082145.32515-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191020082145.32515-1-hch@lst.de>
References: <20191020082145.32515-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

struct xfs_icdinode is purely an in-memory data structure, so don't use
a log on-disk structure for it.  This simplifies the code a bit, and
also reduces our include hell slightly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c   | 8 ++++----
 fs/xfs/libxfs/xfs_inode_buf.h   | 2 +-
 fs/xfs/libxfs/xfs_trans_inode.c | 6 ++----
 fs/xfs/xfs_inode.c              | 3 +--
 fs/xfs/xfs_inode_item.c         | 4 ++--
 fs/xfs/xfs_iops.c               | 3 +--
 fs/xfs/xfs_itable.c             | 4 ++--
 7 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 28ab3c5255e1..d31156718b20 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -256,8 +256,8 @@ xfs_inode_from_disk(
 	if (to->di_version == 3) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
+		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -306,8 +306,8 @@ xfs_inode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index ab0f84165317..c9ac69c82d21 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -37,7 +37,7 @@ struct xfs_icdinode {
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 
-	xfs_ictimestamp_t di_crtime;	/* time created */
+	struct timespec64 di_crtime;	/* time created */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index a9ad90926b87..b7b81c5de2de 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -66,10 +66,8 @@ xfs_trans_ichgtime(
 		inode->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
-	if (flags & XFS_ICHGTIME_CREATE) {
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
-	}
+	if (flags & XFS_ICHGTIME_CREATE)
+		ip->i_d.di_crtime = tv;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 18f4b262e61c..24efdbf534c7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -845,8 +845,7 @@ xfs_ialloc(
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
+		ip->i_d.di_crtime = tv;
 	}
 
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index bb8f076805b9..a15db5d679ac 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -340,8 +340,8 @@ xfs_inode_to_log_dinode(
 
 	if (from->di_version == 3) {
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.t_sec;
-		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
+		to->di_crtime.t_sec = from->di_crtime.tv_sec;
+		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index fe285d123d69..47d8cdb86e5c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -516,8 +516,7 @@ xfs_vn_getattr(
 	if (ip->i_d.di_version == 3) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
-			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
-			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
+			stat->btime = ip->i_d.di_crtime;
 		}
 	}
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 884950adbd16..11771112a634 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -97,8 +97,8 @@ xfs_bulkstat_one_int(
 	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
 	buf->bs_ctime = inode->i_ctime.tv_sec;
 	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
-	buf->bs_btime = dic->di_crtime.t_sec;
-	buf->bs_btime_nsec = dic->di_crtime.t_nsec;
+	buf->bs_btime = dic->di_crtime.tv_sec;
+	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
 	buf->bs_gen = inode->i_generation;
 	buf->bs_mode = inode->i_mode;
 
-- 
2.20.1


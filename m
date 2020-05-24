Return-Path: <SRS0=zOU/=7G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B274DC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91E5E207D8
	for <linux-xfs@archiver.kernel.org>; Sun, 24 May 2020 09:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a+kzNMzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgEXJSh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 05:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgEXJSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4216C061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=q5iFpQvP84bbx8UwWlq2VfUS+q2NBDISnnrByLxFwkU=; b=a+kzNMzXjZI6vGQy/aCUOmtgy6
        OJuAI9WV8bpeL5B/XR2hPqg+jTw1Xe5Jmyv7tOHqArobZwYzY9WBX9sMV2ca2KEg8dnVdacoN0JjW
        xONWtuE5GRyPYX7FF+V2LCvSUzTNIGkrhlJZxCG2t7tnRDQf8i2uo12exosU0sIR5bFFm1a6AUo7n
        PWMefulHYfP4e6PlwM7EejikciwDlW3M3bK9ACSQYS1tiNSSyiBFqq89brmGn2TPvw5GBwMArFE4v
        DKTAv9a/aRSfaUXUZzTPf+HN1aq2j5E+MpSUu8JayiM6/z25KGTp9yIZhgtgcMMb5ksBRxkcQSJUX
        3B9WGw8A==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmmC-0004y6-BJ
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/14] xfs: move the di_dmevmask field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:56 +0200
Message-Id: <20200524091757.128995-14-hch@lst.de>
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
dmevmask field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h | 1 -
 fs/xfs/xfs_inode.c            | 4 ++--
 fs/xfs/xfs_inode.h            | 1 +
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_log_recover.c      | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index af595ee23635a..d361803102d0e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -246,7 +246,7 @@ xfs_inode_from_disk(
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	ip->i_forkoff = from->di_forkoff;
-	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
+	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	ip->i_diflags	= be16_to_cpu(from->di_flags);
 
@@ -312,7 +312,7 @@ xfs_inode_to_disk(
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
-	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 2a8e7a7ed8d18..0cfc1aaff6c6f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
 };
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aa91217b0fd7f..0b92ce18cf957 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -833,7 +833,7 @@ xfs_ialloc(
 	inode->i_ctime = tv;
 
 	ip->i_extsize = 0;
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
 	ip->i_diflags = 0;
 
@@ -2753,7 +2753,7 @@ xfs_ifree(
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_diflags = 0;
 	ip->i_diflags2 = 0;
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c77ecde5e6e0d..46dc9612af138 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -67,6 +67,7 @@ typedef struct xfs_inode {
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
+	uint32_t		i_dmevmask;	/* DMIG event mask */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index dff3bc6a33720..9b7860025c497 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -330,7 +330,7 @@ xfs_inode_to_log_dinode(
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
-	to->di_dmevmask = from->di_dmevmask;
+	to->di_dmevmask = ip->i_dmevmask;
 	to->di_dmstate = from->di_dmstate;
 	to->di_flags = ip->i_diflags;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec015df55b77a..d096b8c401381 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2720,7 +2720,7 @@ xlog_recover_process_one_iunlink(
 	 * Prevent any DMAPI event from being sent when the reference on
 	 * the inode is dropped.
 	 */
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 
 	xfs_irele(ip);
 	return agino;
-- 
2.26.2


Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20875C54E7E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2DF2208D6
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rq3/HNev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEHGef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgEHGef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C73DC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=3ylWhjhg3jYDaVKNyXXY9gM2c/ELrRK0dvG2AtSjYFY=; b=Rq3/HNevjr8YCX9LYgxqHk1tnw
        La6Q+S7wx74ez6oIq8zPyQncAy5Saj4gVeKyNIHzxKHvoOqrXYufXNm0BNWYcXCQJFe0FxUi1uRcX
        wOVZSinfkypQOTJ8FV8utaf9IZuBXI0za0mk+RdHHMH2dlKJ0RLeYPCVf3stqZh3cqNT90gAuJ5wu
        3x9trJTbGllhzVBStSgSsVKwA9qXxNV/JUft7oqSaUR3olS2WoF1qWF1b35qxngazD4++awE21pkk
        yzY4NQ5fDZCi0l0XJuwhvRIdXvFzhJ6HbplojdaxYZ0ADR43A/wZJ3ggOLEaGn3hXkn5AaSEhm6SO
        zXuRtZ/w==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwag-0002uQ-R1
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: handle unallocated inodes in xfs_inode_from_disk
Date:   Fri,  8 May 2020 08:34:15 +0200
Message-Id: <20200508063423.482370-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Handle inodes with a 0 di_mode in xfs_inode_from_disk, instead of partially
duplicating inode reading in xfs_iread.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 50 ++++++++++-------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index abdecc80579e3..686a026b5f6ed 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -192,6 +192,17 @@ xfs_inode_from_disk(
 	ASSERT(ip->i_cowfp == NULL);
 	ASSERT(ip->i_afp == NULL);
 
+	/*
+	 * First get the permanent information that is needed to allocate an
+	 * inode. If the inode is unused, mode is zero and we shouldn't mess
+	 * with the unitialized part of it.
+	 */
+	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+	inode->i_generation = be32_to_cpu(from->di_gen);
+	inode->i_mode = be16_to_cpu(from->di_mode);
+	if (!inode->i_mode)
+		return 0;
+
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
@@ -209,7 +220,6 @@ xfs_inode_from_disk(
 	to->di_format = from->di_format;
 	i_uid_write(inode, be32_to_cpu(from->di_uid));
 	i_gid_write(inode, be32_to_cpu(from->di_gid));
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
 	 * Time is signed, so need to convert to signed 32 bit before
@@ -223,8 +233,6 @@ xfs_inode_from_disk(
 	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
 	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
 	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
-	inode->i_generation = be32_to_cpu(from->di_gen);
-	inode->i_mode = be16_to_cpu(from->di_mode);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -653,39 +661,9 @@ xfs_iread(
 		goto out_brelse;
 	}
 
-	/*
-	 * If the on-disk inode is already linked to a directory
-	 * entry, copy all of the inode into the in-core inode.
-	 * xfs_iformat_fork() handles copying in the inode format
-	 * specific information.
-	 * Otherwise, just get the truly permanent information.
-	 */
-	if (dip->di_mode) {
-		error = xfs_inode_from_disk(ip, dip);
-		if (error)  {
-#ifdef DEBUG
-			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
-				__func__, error);
-#endif /* DEBUG */
-			goto out_brelse;
-		}
-	} else {
-		/*
-		 * Partial initialisation of the in-core inode. Just the bits
-		 * that xfs_ialloc won't overwrite or relies on being correct.
-		 */
-		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
-		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
-
-		/*
-		 * Make sure to pull in the mode here as well in
-		 * case the inode is released without being used.
-		 * This ensures that xfs_inactive() will see that
-		 * the inode is already free and not try to mess
-		 * with the uninitialized part of it.
-		 */
-		VFS_I(ip)->i_mode = 0;
-	}
+	error = xfs_inode_from_disk(ip, dip);
+	if (error)
+		goto out_brelse;
 
 	ip->i_delayed_blks = 0;
 
-- 
2.26.2


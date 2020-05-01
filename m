Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963B1C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72E652071C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B2zYuopD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgEAIOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIOg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D27C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=wN0W+c4TzQb7La8OxQvxA3Qckl9qU3mNlP54KJ5d2qI=; b=B2zYuopDNNAaGj7vn7CflpForQ
        50/OsC83V7oS5ZtCGcR1383q5UjpYcgQAflvDzy3vTR4R6adMyAZ0EQGxz/b5dZJWjQabpUUwP017
        l9sHhVtrdetbsqzx8JdHc2JTWazWYneNo6dVx/Eu8IljYW4mMp4qgdPjo/Mrr2vj7NImZN4xruEpm
        YOO3cLhlX5D2OPp/0Ag76EgaswROeSpsEXckBcqgx/Myml8hRSt4Chr+RJy8BizCIfKJkuqtW0pRY
        Lr8Gwmv9zHYk6XcnXZokA5ZHC60wQzY/40u1JSmSkGZHRGeRbL0uGKdsSuwqdwu0vTj3ccyWlGIeT
        7ZCL2Oqw==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQod-0002tP-ON
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/12] xfs: handle unallocated inodes in xfs_inode_from_disk
Date:   Fri,  1 May 2020 10:14:16 +0200
Message-Id: <20200501081424.2598914-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_inode_buf.c | 54 ++++++++++++-----------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 983beb680e81a..b136f29f7d9d3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -198,6 +198,21 @@ xfs_inode_from_disk(
 	ASSERT(ip->i_cowfp == NULL);
 	ASSERT(ip->i_afp == NULL);
 
+	/*
+	 * Get the truly permanent information first that is not overwritten by
+	 * xfs_ialloc first.  This also includes i_mode so that a newly read
+	 * in inode structure for an allocation is marked as already free.
+	 */
+	inode->i_generation = be32_to_cpu(from->di_gen);
+	inode->i_mode = be16_to_cpu(from->di_mode);
+	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+
+	/*
+	 * Only copy the rest if the inode is actually allocated.
+	 */
+	if (!inode->i_mode)
+		return 0;
+
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
@@ -215,7 +230,6 @@ xfs_inode_from_disk(
 	to->di_format = from->di_format;
 	i_uid_write(inode, be32_to_cpu(from->di_uid));
 	i_gid_write(inode, be32_to_cpu(from->di_gid));
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
 	 * Time is signed, so need to convert to signed 32 bit before
@@ -229,8 +243,6 @@ xfs_inode_from_disk(
 	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
 	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
 	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
-	inode->i_generation = be32_to_cpu(from->di_gen);
-	inode->i_mode = be16_to_cpu(from->di_mode);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -659,39 +671,9 @@ xfs_iread(
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


Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7EEC47257
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F9BF2173E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SOhzswR0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgEAIOi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CBFC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=ITmGzC/N3ZM7UC+rM66t7HsoZe5PNwv9Bj1HaWZoauY=; b=SOhzswR0IhP4jiynbGkYUPqEwo
        9lEshHT56tIcwPLute9qY4dwcEQqLkY48gwq4bxe7Sb3TgbhcGo94jxEQnlkXaj1q+uPm89wH54C8
        sPUs4PN58GFLz1dZuBqYafWQGZ1U7CVniFQ3p5O9d/3K+IOjF0Lt6CVzEjXCImdxJVwlB0Qf8Rtsk
        mrtpt+fb+UIvNiyIBXR+Cvqbg48WbmV2oJX2nl2d66pksSnDoI+d+sE+fwlgSnekiy61BKuqR4Ivt
        4f62kKMppmhuruaXULfZqhZOofSpuD5ym+b0snz50Zvhp+w89Y7Vs6MxdmD4pVPdueBChoVV/Ig6p
        NfQkA4mw==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQog-0002tk-44
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/12] xfs: call xfs_dinode_verify from xfs_inode_from_disk
Date:   Fri,  1 May 2020 10:14:17 +0200
Message-Id: <20200501081424.2598914-6-hch@lst.de>
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

Keep the code dealing with the dinode together, and also ensure we verify
the dinode in the onwer change log recovery case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../xfs-self-describing-metadata.txt           | 10 +++++-----
 fs/xfs/libxfs/xfs_inode_buf.c                  | 18 ++++++++----------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.txt
index 8db0121d0980c..e912699d74301 100644
--- a/Documentation/filesystems/xfs-self-describing-metadata.txt
+++ b/Documentation/filesystems/xfs-self-describing-metadata.txt
@@ -337,11 +337,11 @@ buffer.
 
 The structure of the verifiers and the identifiers checks is very similar to the
 buffer code described above. The only difference is where they are called. For
-example, inode read verification is done in xfs_iread() when the inode is first
-read out of the buffer and the struct xfs_inode is instantiated. The inode is
-already extensively verified during writeback in xfs_iflush_int, so the only
-addition here is to add the LSN and CRC to the inode as it is copied back into
-the buffer.
+example, inode read verification is done in xfs_inode_from_disk() when the inode
+is first read out of the buffer and the struct xfs_inode is instantiated. The
+inode is already extensively verified during writeback in xfs_iflush_int, so the
+only addition here is to add the LSN and CRC to the inode as it is copied back
+into the buffer.
 
 XXX: inode unlinked list modification doesn't recalculate the inode CRC! None of
 the unlinked list modifications check or update CRCs, neither during unlink nor
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b136f29f7d9d3..a00001a2336ef 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -194,10 +194,18 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 	int			error;
+	xfs_failaddr_t		fa;
 
 	ASSERT(ip->i_cowfp == NULL);
 	ASSERT(ip->i_afp == NULL);
 
+	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", from,
+				sizeof(*from), fa);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Get the truly permanent information first that is not overwritten by
 	 * xfs_ialloc first.  This also includes i_mode so that a newly read
@@ -637,7 +645,6 @@ xfs_iread(
 {
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
-	xfs_failaddr_t	fa;
 	int		error;
 
 	/*
@@ -662,15 +669,6 @@ xfs_iread(
 	if (error)
 		return error;
 
-	/* even unallocated inodes are verified */
-	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
-	if (fa) {
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
-				sizeof(*dip), fa);
-		error = -EFSCORRUPTED;
-		goto out_brelse;
-	}
-
 	error = xfs_inode_from_disk(ip, dip);
 	if (error)
 		goto out_brelse;
-- 
2.26.2


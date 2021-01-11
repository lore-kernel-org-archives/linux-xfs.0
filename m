Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5390C43381
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 781A122CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbhAKQNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbhAKQNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 11:13:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C10FC061794
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 08:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gGxNK/h9Y1/j4uvmF24gRfmGfmqL9pBLMkdHLK9GWwY=; b=NSkKnjXY0606fFw8JYqUQYZ4En
        l067bFiSi6ZOTgfz/WM/+YOBbP0pyPInc/XY1HjXBRTDmyLW9WjudaaL6qLfzUjwWmRevfAREy2B0
        I+P0Ccdj2sgxrmmQHVeSJLxCohoT9BeJq+xIZEUvPSzux6aQ0gsUf04Zj52MK6KyflZ2404vRb4g/
        /ZzvUbwGPgkAZD6wTH14XNFZXk+otzNtw2nPf+X9YTcyFyEIqflmTKBopeA95BZb4A45rfTELInth
        15fwDfkYRzSd+0kO0nVUR97MfKWzTcBhGbeH1A9CH7fQZtg1hhKh67kEYgnnaJqze9wJPjEJpEj6/
        U+xDof3Q==;
Received: from [2001:4bb8:19b:e528:814e:4181:3d37:5818] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyzo3-003TV9-3F; Mon, 11 Jan 2021 16:12:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Avi Kivity <avi@scylladb.com>
Subject: [PATCH 1/3] xfs: factor out a xfs_ilock_iocb helper
Date:   Mon, 11 Jan 2021 17:12:10 +0100
Message-Id: <20210111161212.1414034-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111161212.1414034-1-hch@lst.de>
References: <20210111161212.1414034-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a helper to factor out the nowait locking logical for the read/write
helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 55 +++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ba02780dee6439..aa3fe89628f0f1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -217,6 +217,23 @@ xfs_file_fsync(
 	return error;
 }
 
+static int
+xfs_ilock_iocb(
+	struct kiocb		*iocb,
+	unsigned int		lock_mode)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!xfs_ilock_nowait(ip, lock_mode))
+			return -EAGAIN;
+	} else {
+		xfs_ilock(ip, lock_mode);
+	}
+
+	return 0;
+}
+
 STATIC ssize_t
 xfs_file_dio_aio_read(
 	struct kiocb		*iocb,
@@ -233,12 +250,9 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
-			return -EAGAIN;
-	} else {
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
+	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	if (ret)
+		return ret;
 	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
 			is_sync_kiocb(iocb));
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -260,13 +274,9 @@ xfs_file_dax_read(
 	if (!count)
 		return 0; /* skip atime */
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
-			return -EAGAIN;
-	} else {
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-
+	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	if (ret)
+		return ret;
 	ret = dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
@@ -284,12 +294,9 @@ xfs_file_buffered_aio_read(
 
 	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
-			return -EAGAIN;
-	} else {
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
+	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
+	if (ret)
+		return ret;
 	ret = generic_file_read_iter(iocb, to);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
@@ -628,13 +635,9 @@ xfs_file_dax_write(
 	size_t			count;
 	loff_t			pos;
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (!xfs_ilock_nowait(ip, iolock))
-			return -EAGAIN;
-	} else {
-		xfs_ilock(ip, iolock);
-	}
-
+	ret = xfs_ilock_iocb(iocb, iolock);
+	if (ret)
+		return ret;
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
-- 
2.29.2


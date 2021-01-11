Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325B3C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9075225AB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 16:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbhAKQNm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbhAKQNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 11:13:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8F3C061795
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 08:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=REpi5jI9hKWckQo2Y2mGJRHn0muXtF1IqG/p3I1yNoY=; b=HRqd45nO6ujxdE+Z0S2GXHkBrE
        76BL0EGFYaQx4afgXxktfNXzwILFm6UVw+WHVXguP2UNNh3Gzri6bZIQHxXcm58OD6PQQoASbZtxZ
        p+xp3L6J03kQmZkQll/8Oyhb94PFS67m+mrLvW3ggUJgqZB7g1XbEbjR+fGkGQOll9aicUMxwfEvR
        vEP01tn9YPOjW4PRnEuwSx+Be42isDbHlMo9Ya6DTYa0z7YLnKzJGisJLRuSUvSt168oIAObwxYbk
        9H/0xTebiMWRhoKb9l5AtuKjQubl77K1XJjgoczHIcwL9G5kJ7gxjHeF8UjKq+4DJAmTWcUZikJU/
        rTtM5Q3g==;
Received: from [2001:4bb8:19b:e528:814e:4181:3d37:5818] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyzoJ-003TVS-3m; Mon, 11 Jan 2021 16:12:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Avi Kivity <avi@scylladb.com>
Subject: [PATCH 2/3] xfs: make xfs_file_aio_write_checks IOCB_NOWAIT-aware
Date:   Mon, 11 Jan 2021 17:12:11 +0100
Message-Id: <20210111161212.1414034-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111161212.1414034-1-hch@lst.de>
References: <20210111161212.1414034-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ensure we don't block on the iolock, or waiting for I/O in
xfs_file_aio_write_checks if the caller asked to avoid that.

Fixes: 29a5d29ec181 ("xfs: nowait aio support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa3fe89628f0f1..1470fc4f2e0255 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -355,7 +355,14 @@ xfs_file_aio_write_checks(
 	if (error <= 0)
 		return error;
 
-	error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		error = break_layout(inode, false);
+		if (error == -EWOULDBLOCK)
+			error = -EAGAIN;
+	} else {
+		error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
+	}
+
 	if (error)
 		return error;
 
@@ -366,7 +373,11 @@ xfs_file_aio_write_checks(
 	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
 		xfs_iunlock(ip, *iolock);
 		*iolock = XFS_IOLOCK_EXCL;
-		xfs_ilock(ip, *iolock);
+		error = xfs_ilock_iocb(iocb, *iolock);
+		if (error) {
+			*iolock = 0;
+			return error;
+		}
 		goto restart;
 	}
 	/*
@@ -388,6 +399,10 @@ xfs_file_aio_write_checks(
 	isize = i_size_read(inode);
 	if (iocb->ki_pos > isize) {
 		spin_unlock(&ip->i_flags_lock);
+
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+
 		if (!drained_dio) {
 			if (*iolock == XFS_IOLOCK_SHARED) {
 				xfs_iunlock(ip, *iolock);
@@ -613,7 +628,8 @@ xfs_file_dio_aio_write(
 			   &xfs_dio_write_ops,
 			   is_sync_kiocb(iocb) || unaligned_io);
 out:
-	xfs_iunlock(ip, iolock);
+	if (iolock)
+		xfs_iunlock(ip, iolock);
 
 	/*
 	 * No fallback to buffered IO after short writes for XFS, direct I/O
@@ -652,7 +668,8 @@ xfs_file_dax_write(
 		error = xfs_setfilesize(ip, pos, ret);
 	}
 out:
-	xfs_iunlock(ip, iolock);
+	if (iolock)
+		xfs_iunlock(ip, iolock);
 	if (error)
 		return error;
 
-- 
2.29.2


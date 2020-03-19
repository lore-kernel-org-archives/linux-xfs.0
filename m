Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB753C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900D021556
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 13:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eNg8JGD3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCSNJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:09:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbgCSNJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 09:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=zgDIBXmHb4z1tu/TYBKb4FWq376tg68ZXUTar9LUOlE=; b=eNg8JGD39sDajC37TJv6v25B3H
        ZhE25gyyTYZg9oXVbF6eJbyoXZAPJKF4ASfAPm3EwnJok46oc1+8850T5xNXOShazmnSDohfuOp12
        L5jZThTjrexvFjkLFLErmhKGWT8XiDJL8BCXbcIV4tCtlRzSZ/KBl6mheig4fwtD0lYE+hkYuktmG
        Jrv9bcx63oYN6VJLfIzNy5NIJUzNh0ntaESdUBvqSSX0OIE2usHquckBOP0HTwe8qHKB1VPtgZOIE
        PYGrMZF8icKUWHDzK9g+l0d6XkPon/4xAPzMvSLobdS5QNdfc2LVF1ooNcaOv8zhhqu2uioq2wVv+
        E6ZCLjDQ==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEuv1-0006wp-DE
        for linux-xfs@vger.kernel.org; Thu, 19 Mar 2020 13:09:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove unused SHUTDOWN_ flags
Date:   Thu, 19 Mar 2020 14:06:50 +0100
Message-Id: <20200319130650.1141068-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove two flags to xfs_force_shutdown that aren't used anywhere.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 5 +----
 fs/xfs/xfs_mount.h | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 3e61d0cc23f8..ef1d5bb88b93 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -504,10 +504,7 @@ xfs_do_force_shutdown(
 	} else if (logerror) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
 			"Log I/O Error Detected. Shutting down filesystem");
-	} else if (flags & SHUTDOWN_DEVICE_REQ) {
-		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
-			"All device paths lost. Shutting down filesystem");
-	} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
+	} else {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
 			"I/O Error Detected. Shutting down filesystem");
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 88ab09ed29e7..847f6f85c4fc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -254,8 +254,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
 #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
-#define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
-#define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
 
 /*
  * Flags for xfs_mountfs
-- 
2.24.1


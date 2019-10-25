Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2A7CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFA5222BE
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mcf0K9ty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505953AbfJYRld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:41:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbfJYRld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1UYeoP4C1vj1AK5xd0sNJMeuZ3C5kqVxD6HFuOebm70=; b=mcf0K9tyU7Zr3zlJMS6QmDSw4M
        5tYT2sNWFCflGyYZbyfVqN7lafKicrMVKu1vZcVjzCZklgtGZ8RZJgDK3gO1V1Id+7ueUy7fxSycK
        E2zTWJG423dEx4bdrMCHdh8us3VZQLt7I9br4BgcPNIKisEEUz9s/2X5+k6K0Pz8K3XvoavAqRr+f
        xFt/y/5SJ26hqK/VRMSYGMceyEJgPtCk3EegUUfUpFza4y6c0I7vPmLiFqiHNeUPcz0mb2ppAPKFp
        LgFBL35jtCPa6GBel4H+aUw+0vC5YWzYvvvy7XBGHcNM4IOl4uOxhwYUKAIQizoNrDlcwGsVPmpzx
        xWkSuW+w==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3ae-0005aw-9L; Fri, 25 Oct 2019 17:41:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 5/7] xfs: remove the iosizelog variable in xfs_parseargs
Date:   Fri, 25 Oct 2019 19:40:24 +0200
Message-Id: <20191025174026.31878-6-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025174026.31878-1-hch@lst.de>
References: <20191025174026.31878-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no real need for a local variables here - either the I/O size
is valid and gets applied to the mount structure, or it is invalid and
the mount will fail entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee2dde897fb7..1467f4bebc41 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -161,7 +161,6 @@ xfs_parseargs(
 	char			*p;
 	substring_t		args[MAX_OPT_ARGS];
 	int			iosize = 0;
-	uint8_t			iosizelog = 0;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -229,7 +228,8 @@ xfs_parseargs(
 		case Opt_biosize:
 			if (suffix_kstrtoint(args, 10, &iosize))
 				return -EINVAL;
-			iosizelog = ffs(iosize) - 1;
+			mp->m_writeio_log = ffs(iosize) - 1;
+			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
 			break;
 		case Opt_grpid:
 		case Opt_bsdgroups:
@@ -397,17 +397,14 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if (iosizelog) {
-		if (iosizelog > XFS_MAX_IO_LOG ||
-		    iosizelog < XFS_MIN_IO_LOG) {
+	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) {
+		if (mp->m_writeio_log > XFS_MAX_IO_LOG ||
+		    mp->m_writeio_log < XFS_MIN_IO_LOG) {
 			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				iosizelog, XFS_MIN_IO_LOG,
-				XFS_MAX_IO_LOG);
+				mp->m_writeio_log,
+				XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
 			return -EINVAL;
 		}
-
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_writeio_log = iosizelog;
 	}
 
 	return 0;
-- 
2.20.1


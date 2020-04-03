Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072FAC2BA16
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 12:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F112078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 12:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ETZ4wzqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgDCMz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:55:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCMz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 08:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=XLcXgz58LvVz3m2uNWDiuhEI0c28ERZXeBwRUyBCKBc=; b=ETZ4wzqLjJMjJWTXRZwvXdwyJ2
        1rmLC7kb15+IJ/vDynTDJc53kMM3A8Rw/mkAC+els1oRH02cUKkUE9XRzgaaNUow+ByS9lh23/8k9
        jj0+rVMkMpGulOSUBr7WUwq4Fgx1CxFZyou208oMDbIfumAzfiJJ8d5j84ZBzXPaMLTNfIl/lNPtW
        xcO3sEf5hOiWdvbAqHu5XZiHgoM55hjFmJjALDNWWHhsqWVfluW5aOqB9JuElaAl7CvukvHHwru61
        qEr7ADuSamJ5tpMbjuykrLfTrrxZkG99iM1uyVXSK+pBVh23kwmgNtx9li54eW+d1EloAnWt/kpIn
        iNRWJEOQ==;
Received: from 089144198148.atnat0007.highway.a1.net ([89.144.198.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKLr5-0002rE-Lq
        for linux-xfs@vger.kernel.org; Fri, 03 Apr 2020 12:55:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: reflink should force the log out if mounted with wsync
Date:   Fri,  3 Apr 2020 14:55:22 +0200
Message-Id: <20200403125522.450299-2-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403125522.450299-1-hch@lst.de>
References: <20200403125522.450299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reflink should force the log out to disk if the filesystem was mounted
with wsync, the same as most other operations in xfs.

Fixes: 3fc9f5e409319 ("xfs: remove xfs_reflink_remap_range")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 68e1cbb3cfcc..4b8bdecc3863 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1059,7 +1059,11 @@ xfs_file_remap_range(
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
+	if (ret)
+		goto out_unlock;
 
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
-- 
2.25.1


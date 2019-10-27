Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0FFCA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EED214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xb8l4wW3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfJ0O4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfJ0O4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zwp/u+bpE5IqZyGaxA97YQUoZ3oQKvcErOh5Lm0uPmo=; b=Xb8l4wW3jm54Ut5Z0jhV1sA4DP
        fhCGTeQ/41Npqhdi9swWziRxiyImam9MdlaQO7OXzpIk0DuoZ6h7rcSMpfLmY/15qCZ85ojBgIt1J
        nLCNPGIGpjaXDGWSAazELSdR65N7c/j1t/4OB1VKArum97lwwx4UpoopifSQn2CZPYu08fNkLnIl6
        7K+KlyJqATgmDVKxqYKmOBStD+iURnevWKQmHXphWrZzaRFT1+0IZbissCCUQSwZ1FgtcBAqFqFdS
        EOh4fh/SXG7okCK7lkvc5J4lFcq1DMw7TdFtbj8VuppF8Lxiq794hzzikeqZctzozuFvdKpKIolHN
        rCUZ4sgQ==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxt-0005PY-CP; Sun, 27 Oct 2019 14:56:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 11/12] xfs: clean up printing inode32/64 in xfs_showargs
Date:   Sun, 27 Oct 2019 15:55:46 +0100
Message-Id: <20191027145547.25157-12-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027145547.25157-1-hch@lst.de>
References: <20191027145547.25157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

inode64 is the only value remaining in the unset array.  Special case
the inode32/64 options with an explicit seq_printf that prints either
inode32 or inode64, and remove the unset array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 93ed0871b1cf..0e8942bbf840 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -423,26 +423,19 @@ xfs_showargs(
 		{ XFS_MOUNT_FILESTREAMS,	",filestreams" },
 		{ XFS_MOUNT_GRPID,		",grpid" },
 		{ XFS_MOUNT_DISCARD,		",discard" },
-		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
 		{ XFS_MOUNT_LARGEIO,		",largeio" },
 		{ XFS_MOUNT_DAX,		",dax" },
 		{ 0, NULL }
 	};
-	static struct proc_xfs_info xfs_info_unset[] = {
-		/* the few simple ones we can get from the mount struct */
-		{ XFS_MOUNT_SMALL_INUMS,	",inode64" },
-		{ 0, NULL }
-	};
 	struct proc_xfs_info	*xfs_infop;
 
 	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
 		if (mp->m_flags & xfs_infop->flag)
 			seq_puts(m, xfs_infop->str);
 	}
-	for (xfs_infop = xfs_info_unset; xfs_infop->flag; xfs_infop++) {
-		if (!(mp->m_flags & xfs_infop->flag))
-			seq_puts(m, xfs_infop->str);
-	}
+
+	seq_printf(m, ",inode%d",
+		(mp->m_flags & XFS_MOUNT_SMALL_INUMS) ? 32 : 64);
 
 	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
 		seq_printf(m, ",allocsize=%dk",
-- 
2.20.1


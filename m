Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B5CC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9B121670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EQuYeqHw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfH3KYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:24:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfH3KYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d1jGVAacrxxCekQNOC6YwDQy/3hxhm5+fYI7LMrZv68=; b=EQuYeqHweHRP/Ja7W1zoUgK8P
        1vlwNRHvwQDWwiX+4XKQZ5w/Cbp8WvwsyNdmvi+D4UKxoRMewcCF6olWSrNMxtZAgkaoJM9YiPaYI
        KlEMaDa89/l/K6OV5QbohIzp9wXH2AkFeeWUpF+m0Klb9VcR0aRiaGX13vCK2RspvJo8X7M7H1UEQ
        bFf1qOwtGz0eTcHa/1jAUubBdAWSJVRhN4OUyNwGYER6rrpSChL2SY4CQFZ8S+u4a/LBG6xXX3t8d
        RAFcoXxykoPe9MUnvQzUNuYFZvNcLSLIcRdjlGoaJe0FvJdt2SEu4oJ8wKGDT8DD6MA7gPTk9Q0xF
        CDcEx+APA==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3e4t-0003p6-1m
        for linux-xfs@vger.kernel.org; Fri, 30 Aug 2019 10:24:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: remove the unused XFS_ALLOC_USERDATA flag
Date:   Fri, 30 Aug 2019 12:24:11 +0200
Message-Id: <20190830102411.519-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190830102411.519-1-hch@lst.de>
References: <20190830102411.519-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.h | 7 +++----
 fs/xfs/libxfs/xfs_bmap.c  | 8 ++------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d6ed5d2c07c2..58fa85cec325 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -81,10 +81,9 @@ typedef struct xfs_alloc_arg {
 /*
  * Defines for datatype
  */
-#define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
-#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
-#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
-#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
+#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 0)/* special case start of file */
+#define XFS_ALLOC_USERDATA_ZERO		(1 << 1)/* zero extent on allocation */
+#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
 
 static inline bool
 xfs_alloc_is_userdata(int datatype)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 80b25e21e708..054b4ce30033 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4042,12 +4042,8 @@ xfs_bmapi_allocate(
 	 */
 	if (!(bma->flags & XFS_BMAPI_METADATA)) {
 		bma->datatype = XFS_ALLOC_NOBUSY;
-		if (whichfork == XFS_DATA_FORK) {
-			if (bma->offset == 0)
-				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-			else
-				bma->datatype |= XFS_ALLOC_USERDATA;
-		}
+		if (whichfork == XFS_DATA_FORK && bma->offset == 0)
+			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
 		if (bma->flags & XFS_BMAPI_ZERO)
 			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
 	}
-- 
2.20.1


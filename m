Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C64CC3A5A6
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 02:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51254207FC
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 02:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iOM6ee9K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393796AbfITCTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 22:19:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390999AbfITCTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 22:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gPvDXZn47+Xh5Ucl7BKhIp8In3MLDCt7iLEkaKnrDGs=; b=iOM6ee9KPt3WpOrl8sIbGjjNb
        bG/GqhVpq1FBq3FKHqK2kl+ae6+rMM6VAk2R8INWcADKTF3nahzAdd3BZ1HBW38qXnVfDLHdQcSRB
        j8DVgDJA2LwETkx6yzXsoI0zhdGohJF5zJNOFmmZ7MAu2uLcZjyEkrhq9+FbgRaTHUTj8JNLP0Wii
        6ahUC4w4NIB4WqOwwLExCUB/A8gPoWIoJQjZoD2r0Mmp/tKIs/kLPG1BY+GP0FkQZZQINKr6iKLcG
        DJUbb6k2EXyoHpXvQY917x0RxrX3mYNDlgqXFfAsUQqAcr4zQeDehlNrgkzuWqfqzbcIhHbSCKjQ/
        41vCtZnpQ==;
Received: from [216.9.110.10] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iB8WP-00015A-5j; Fri, 20 Sep 2019 02:19:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     kernel test robot <rong.a.chen@intel.com>
Subject: [PATCH] xfs: fix userdata allocation detection regression
Date:   Thu, 19 Sep 2019 19:19:43 -0700
Message-Id: <20190920021943.26930-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The XFS_ALLOC_USERDATA was not directly used, but indirectly in the
xfs_alloc_is_userdata function that check for any bit that is not
XFS_ALLOC_NOBUSY being set.  But XFS_ALLOC_NOBUSY is equivalent to
a user data allocation, so rename that flag and check for that instead
to reduce the confusion.

Fixes: 1baa2800e62d ("xfs: remove the unused XFS_ALLOC_USERDATA flag")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.h | 7 ++++---
 fs/xfs/libxfs/xfs_bmap.c  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 58fa85cec325..24710746cecb 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -83,18 +83,19 @@ typedef struct xfs_alloc_arg {
  */
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 0)/* special case start of file */
 #define XFS_ALLOC_USERDATA_ZERO		(1 << 1)/* zero extent on allocation */
-#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
+#define XFS_ALLOC_USERDATA		(1 << 2)/* allocation is for user data*/
 
 static inline bool
 xfs_alloc_is_userdata(int datatype)
 {
-	return (datatype & ~XFS_ALLOC_NOBUSY) != 0;
+	return (datatype & XFS_ALLOC_USERDATA);
 }
 
 static inline bool
 xfs_alloc_allow_busy_reuse(int datatype)
 {
-	return (datatype & XFS_ALLOC_NOBUSY) == 0;
+	/* Busy extents not allowed for user data */
+	return (datatype & XFS_ALLOC_USERDATA) == 0;
 }
 
 /* freespace limit calculations */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 054b4ce30033..a2d8c4e4cad5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4041,7 +4041,7 @@ xfs_bmapi_allocate(
 	 * the busy list.
 	 */
 	if (!(bma->flags & XFS_BMAPI_METADATA)) {
-		bma->datatype = XFS_ALLOC_NOBUSY;
+		bma->datatype = XFS_ALLOC_USERDATA;
 		if (whichfork == XFS_DATA_FORK && bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
 		if (bma->flags & XFS_BMAPI_ZERO)
-- 
2.20.1


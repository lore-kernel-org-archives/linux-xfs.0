Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF66C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70AEB20716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hrcFpjfo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCLOR2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:17:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLOR1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=F0+JlZXvg+HvvDPgHo3U74jb5ZOoMRpvvo+b/qPui5k=; b=hrcFpjfo32z9WjXgNEWcDbQfAy
        A3gsXB21FBtOXGWJwI7JzPGHqwZeRDs5A6QKFUUzpgY5saNgn8Arh55uws2U0+WAhgPEPSw1RqTG0
        P93SNavftoSdtKOrRejJ4jdhtt8wBB83NNnLNsIzxIMVP+Ndcog2QQHSuEVTB9s5IxjmXGNSTZcAv
        Yu/wk/AB/Ry0B5OJDE/1frdCSoqWx2pYh4tylDUsrBWV+3LDFojrkU5PL77VWbYQSQ30RN0sBcBy/
        ybI5Q/PHQ50s0YZ9tNVszi3DV68byY3ZOL+lxw6WqsCH+9zyA4GQMyX6/PzoD6rARnjcSGVpypH6t
        aHlqLPbg==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOeN-0001z0-90
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:17:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: remove XFS_BUF_SET_BDSTRAT_FUNC
Date:   Thu, 12 Mar 2020 15:17:14 +0100
Message-Id: <20200312141715.550387-4-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312141715.550387-1-hch@lst.de>
References: <20200312141715.550387-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function doesn't exist in the kernel and is purely a stub in
xfsprogs, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 1 -
 libxfs/logitem.c     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 723dddcd..d07d8f32 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -367,7 +367,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define XBF_DONE			0
 #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
-#define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
 
 static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index b11df4fa..d0819dcb 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -84,7 +84,6 @@ xfs_buf_item_init(
 	 * the first.  If we do already have one, there is
 	 * nothing to do here so return.
 	 */
-	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
 	if (bp->b_log_item != NULL) {
 		lip = bp->b_log_item;
 		if (lip->li_type == XFS_LI_BUF) {
-- 
2.24.1


Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6569C35240
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 09:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A6C52071E
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 09:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZjlnSVLL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgAZJRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 04:17:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgAZJRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 04:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mJgpqR6VMzJm4Oc+FkqTprecqIxALcARLy3o/qnk8xA=; b=ZjlnSVLLfHsnXRmvtb5Wd4fgH
        r1byLuBqEJG6lvsesLSHKche97V3qVdF3GHlR/P7TPW128lbaS58OtOD90Ea+C0M7hTbOXUepa3vU
        cHZ5FpAbLDIW/UgJ8AYpuDEFimoeJF3cjfErZhdiSZ0r6d/YH2xmVL1rHkdsUmuGVE32Txl4kWmqZ
        FdxdwZsI681EHnwCihmTqOn5HsrEZwx4QW+c5tQs9wOYWR+PKjbiCGpQX8W5yN98/aBCL93ZOmPHh
        tgExYTTM6HUkKCDhnGwXfShwXdngRx65Cdg01P6jOe1uuiaC9GA6PFovbNcq78DjLZotmLeBXtuAC
        8ki5E56Uw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ive2s-0008Be-Rd
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 09:17:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: turn the xfs_buf_incore stub into an inline function
Date:   Sun, 26 Jan 2020 10:17:17 +0100
Message-Id: <20200126091717.516904-1-hch@lst.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the macro with an inline function to avoid compiler warnings with new
backports of kernel code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 03edf0d3..2b73963c 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -369,14 +369,12 @@ roundup_64(uint64_t x, uint32_t y)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
 
-/* avoid gcc warning */
-#define xfs_buf_incore(bt,blkno,len,lockit) ({		\
-	typeof(blkno) __foo = (blkno);			\
-	typeof(len) __bar = (len);			\
-	(blkno) = __foo;				\
-	(len) = __bar; /* no set-but-unused warning */	\
-	NULL;						\
-})
+static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
+		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
+{
+	return NULL;
+}
+
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-- 
2.24.1


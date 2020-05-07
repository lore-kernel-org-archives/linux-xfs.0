Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E89B4C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C81382083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YGecpKUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgEGMT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMT6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB4FC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=U6tZ8Vu+1g7jAHBh63Ktf7mA4C1sS5psRS+4LrdLtnU=; b=YGecpKUkeZuD09m8N/1KQnKQLX
        jsoP2RUdS4vHzxHE3Tf1bUuH8JcrG4Ai873poP7LU1XRnqcxVMOz08rOLSC5+OUHL4tQ6q/ilHfsr
        bdDms5NXTt85QNhWSvLo8NckfacK9+Obc1fbHrDwJUka+9d/E9YEB9affULEDwXZfYybMEYM+cSNA
        kHbPhY6QN/CNwdfBKzLzyusWG3f2elfUNsgBk/TdTx36VibIhqtXhx2AJ7bPoxFpIXVuZKiupxTKM
        7lm2yGX/GU6MD6s4bB5qxdl5vBj4r58Gayud34rFoD+Urevvs6fO508WqAr1dw5dsAiDwuCZV1euY
        RDJHDZfw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVN-0005Dy-Fa; Thu, 07 May 2020 12:19:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/58] xfs: embedded the attrlist cursor into struct xfs_attr_list_context
Date:   Thu,  7 May 2020 14:18:19 +0200
Message-Id: <20200507121851.304002-27-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: e3a19cdea84a42d44ef42ff8b5459c903992bbf2

The attrlist cursor only exists as part of an attr list context, so
embedd the structure instead of pointing to it.  Also give it a proper
xfs_ prefix and remove the obsolete typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h      | 6 +++---
 libxfs/xfs_attr_leaf.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index a6bedb0e..0d2d0590 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -31,14 +31,14 @@ struct xfs_attr_list_context;
 /*
  * Kernel-internal version of the attrlist cursor.
  */
-typedef struct attrlist_cursor_kern {
+struct xfs_attrlist_cursor_kern {
 	__u32	hashval;	/* hash value of next entry to add */
 	__u32	blkno;		/* block containing entry (suggestion) */
 	__u32	offset;		/* offset in list of equal-hashvals */
 	__u16	pad1;		/* padding to match user-level */
 	__u8	pad2;		/* padding to match user-level */
 	__u8	initted;	/* T/F: cursor has been initialized */
-} attrlist_cursor_kern_t;
+};
 
 
 /*========================================================================
@@ -53,7 +53,7 @@ typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*dp;		/* inode */
-	struct attrlist_cursor_kern *cursor;	/* position in list */
+	struct xfs_attrlist_cursor_kern cursor;	/* position in list */
 	void			*buffer;	/* output buffer */
 
 	/*
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 73615b1d..6dd2d937 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -8,7 +8,6 @@
 #define	__XFS_ATTR_LEAF_H__
 
 struct attrlist;
-struct attrlist_cursor_kern;
 struct xfs_attr_list_context;
 struct xfs_da_args;
 struct xfs_da_state;
-- 
2.26.2


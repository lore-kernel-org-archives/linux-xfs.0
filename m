Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA8CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0331620758
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hk7vaQIw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgERREn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8F9C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=jd0gBRliUSRr+T47eNk6iLhMsQ8vbLHrRMXyvsVzDwc=; b=Hk7vaQIw3lRW+PtXzw7ibIsZ5X
        fWNMYkvXabtkyv9buipAPCA7Xok+h58/yoniFfNTpQE4Z3hCuomw0AUfkyQwlbeHtUoAOUzUl+ocO
        Yjh8khVaDo1JpItHpGcWKmBewCdV5cRF6R/cAh/nWfM5xvU+B6E6Wr/6nYZiGuGQjP87pyB/FZ2XM
        jWh27KHtA+Yp3afIqU2/MsqSyxVuJny4TXwFJzyQKpaz09qTx/TiaCixZG8zugMxS+DLGuhO2JoQA
        KYyvmXRqCayCb+OnZ+eYTL3I0hCcFrYj5f9XT8qjbzYznQ5wmZopL4R0DiLBofgF5mMcgvn8AS3C8
        JW9DmwtQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajBy-0001vf-Vt
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: remove xfs_inode_ag_iterator
Date:   Mon, 18 May 2020 19:04:32 +0200
Message-Id: <20200518170437.1218883-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518170437.1218883-1-hch@lst.de>
References: <20200518170437.1218883-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is entirely unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 11 -----------
 fs/xfs/xfs_icache.h |  5 +----
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 922a29032e374..1f9b86768f054 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -979,17 +979,6 @@ xfs_inode_ag_iterator_flags(
 	return last_error;
 }
 
-int
-xfs_inode_ag_iterator(
-	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
-	int			flags,
-	void			*args)
-{
-	return xfs_inode_ag_iterator_flags(mp, execute, flags, args, 0);
-}
-
 int
 xfs_inode_ag_iterator_tag(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 48f1fd2bb6ad8..39712737c0d5c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -24,7 +24,7 @@ struct xfs_eofblocks {
  * tags for inode radix tree
  */
 #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_ag_iterator */
+					   in xfs_inode_ag_iterator* */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 #define XFS_ICI_EOFBLOCKS_TAG	1	/* inode has blocks beyond EOF */
 #define XFS_ICI_COWBLOCKS_TAG	2	/* inode can have cow blocks to gc */
@@ -71,9 +71,6 @@ int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-int xfs_inode_ag_iterator(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, int flags, void *args),
-	int flags, void *args);
 int xfs_inode_ag_iterator_flags(struct xfs_mount *mp,
 	int (*execute)(struct xfs_inode *ip, int flags, void *args),
 	int flags, void *args, int iter_flags);
-- 
2.26.2


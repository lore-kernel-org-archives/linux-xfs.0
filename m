Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBF7C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 08:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43833610A5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 08:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239720AbhHMIRh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 04:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbhHMIRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 04:17:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B36C061756
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 01:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hQ4jvj4luWArixFfkcImAH2kc5IVOiblJjS04JxQ8rU=; b=qg6MGJ2B0WNMwmrSpvoydmo1KY
        I2d5NdFQgNnAxRlRpsG/DIh4qdRkWKAoIJha4MCMyfYBMd2ubOrs75dbKdiMkRQ4Lzrj/UE2BGb1o
        6BjZgU0WLIbCR9fGi5+fNUEnkcV9MLeO8pl4ButdQ/PvXrM0YwO7X3k0/HZ1VXu/6Je1KGVMErl3m
        rwJdtrP0rYp+xJTpDzLybj+R9ohjhMC/pO0PkDZepshmsC3RivYpJGvd3JRjSRXkMTokJyWRW7PWQ
        m6P3DZULyVha7hUDzNLQapAQeCPgrTiYNWBFk8bekxPBA8PffodKBwnLLxQAbAU2oxjXus41+Yco4
        uCTGMPBA==;
Received: from [2001:4bb8:184:6215:e7f4:438c:fad2:ddc3] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mESMa-00FTyZ-Md; Fri, 13 Aug 2021 08:16:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] xfs: remove support for untagged lookups in xfs_icwalk*
Date:   Fri, 13 Aug 2021 10:16:23 +0200
Message-Id: <20210813081623.83323-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With quotaoff not allowing disabling of accounting there is no need
for untagged lookups in this code, so remove the dead leftovers.

Repoted-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 39 ++++-----------------------------------
 1 file changed, 4 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e7e69e55b7680a..f5a52ec084842d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -43,15 +43,6 @@ enum xfs_icwalk_goal {
 	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
 };
 
-#define XFS_ICWALK_NULL_TAG	(-1U)
-
-/* Compute the inode radix tree tag for this goal. */
-static inline unsigned int
-xfs_icwalk_tag(enum xfs_icwalk_goal goal)
-{
-	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
-}
-
 static int xfs_icwalk(struct xfs_mount *mp,
 		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
@@ -1676,22 +1667,14 @@ xfs_icwalk_ag(
 	nr_found = 0;
 	do {
 		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-		unsigned int	tag = xfs_icwalk_tag(goal);
 		int		error = 0;
 		int		i;
 
 		rcu_read_lock();
 
-		if (tag == XFS_ICWALK_NULL_TAG)
-			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH);
-		else
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **) batch, first_index,
-					XFS_LOOKUP_BATCH, tag);
-
+		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+				(void **) batch, first_index,
+				XFS_LOOKUP_BATCH, goal);
 		if (!nr_found) {
 			done = true;
 			rcu_read_unlock();
@@ -1769,20 +1752,6 @@ xfs_icwalk_ag(
 	return last_error;
 }
 
-/* Fetch the next (possibly tagged) per-AG structure. */
-static inline struct xfs_perag *
-xfs_icwalk_get_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	enum xfs_icwalk_goal	goal)
-{
-	unsigned int		tag = xfs_icwalk_tag(goal);
-
-	if (tag == XFS_ICWALK_NULL_TAG)
-		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
-}
-
 /* Walk all incore inodes to achieve a given goal. */
 static int
 xfs_icwalk(
@@ -1795,7 +1764,7 @@ xfs_icwalk(
 	int			last_error = 0;
 	xfs_agnumber_t		agno = 0;
 
-	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
+	while ((pag = xfs_perag_get_tag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
 		error = xfs_icwalk_ag(pag, goal, icw);
 		xfs_perag_put(pag);
-- 
2.30.2


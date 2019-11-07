Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3426EC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8A2206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Alh8cRA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfKGSZf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7RWczxnzQDR3jIng3nSmQiFi2Or2kQA20xO8tGLGi80=; b=Alh8cRA62UlUJyBVt2wlFXHgd
        f1XR8TKQ8yMXthhvW/Hy4LtF2II4bSBhpuBxi3b3VlTU87tWpvNI8fsXv9UIGA/857RRkjEI1Wxq2
        YzILflxMlmOP9LpyOWZMiHS6v00cxJYdysEuVQSMvGxylycD5QQzAu6kvE3JRxwW0mui1fbmw2xd1
        t9pofFS+5sEXz0wTtraQfUD51LTuoN+CGYlPq65lfX9dyYGtSIhBVklAKZTMlWS8cq5ihbm3tE5Fd
        9YCdLp+90mf7JuKKa3fVjV3lszOGq44im+mKtKnp1IHJoQCN9H0UZz4Mk+7yC/kjdoues2cHXUblC
        AtRtsmelQ==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTP-0004Pr-1y
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 31/46] xfs: cleanup xchk_dir_rec
Date:   Thu,  7 Nov 2019 19:23:55 +0100
Message-Id: <20191107182410.12660-32-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use an offset as the main means for iteration, and only do pointer
arithmetics to find the data/unused entries.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index bb08a1cbe523..501d60c9b09a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -187,7 +187,8 @@ xchk_dir_rec(
 	struct xfs_dir2_data_entry	*dent;
 	struct xfs_buf			*bp;
 	struct xfs_dir2_leaf_entry	*ent;
-	char				*p, *endp;
+	void				*endp;
+	unsigned int			offset;
 	xfs_ino_t			ino;
 	xfs_dablk_t			rec_bno;
 	xfs_dir2_db_t			db;
@@ -237,32 +238,31 @@ xchk_dir_rec(
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out_relse;
 
-	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
+	dent = bp->b_addr + off;
 
 	/* Make sure we got a real directory entry. */
-	p = (char *)mp->m_dir_inode_ops->data_entry_p(bp->b_addr);
+	offset = mp->m_dir_inode_ops->data_entry_offset;
 	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 	if (!endp) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	while (p < endp) {
-		struct xfs_dir2_data_entry	*dep;
-		struct xfs_dir2_data_unused	*dup;
+	for (;;) {
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+	
+		if (offset >= endp - bp->b_addr) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+			goto out_relse;
+		}
 
-		dup = (struct xfs_dir2_data_unused *)p;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			p += be16_to_cpu(dup->length);
+			offset += be16_to_cpu(dup->length);
 			continue;
 		}
-		dep = (struct xfs_dir2_data_entry *)p;
 		if (dep == dent)
 			break;
-		p += mp->m_dir_inode_ops->data_entsize(dep->namelen);
-	}
-	if (p >= endp) {
-		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
-		goto out_relse;
+		offset += mp->m_dir_inode_ops->data_entsize(dep->namelen);
 	}
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
-- 
2.20.1


Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FBDC5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD631206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y2RT49qz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKGSZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfKGSZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9EZYZeeOQ5p1kcORdQc10VWtHj3/M46IAYQbqVnh/6U=; b=Y2RT49qzqaaOxhCvT3eOGGIl8
        1IrdlwJzuYd76coiLl+qZb1BJPFGkkY3QSbu6o0ykJ0E24kFOK0jGJLxga6Qd1SQxzdlk0ZVJT17t
        1+5TjRQqsTiUbh+f/IrWWqDADrISvU/ZccFip6rzlBMCEYXaJeLQOG9PKryfVPG6kK/gXFMnIIrOb
        pxmlTlKUJtmLCSjefKGqHInUtDI4JvX9SXqSzijcWhKa4LzpzQAUYmMGMkUkysmau4/8bKGH9ji84
        /fg036DPaRgiQBZhAipG0KcljDsy+pN0m+6dUvLGCq7KtzQItvE5hfY4zWVKFVwIhoS4k29Kn7RtO
        IfPRP1ePg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTR-0004QI-Jk
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 32/46] xfs: cleanup xchk_directory_data_bestfree
Date:   Thu,  7 Nov 2019 19:23:56 +0100
Message-Id: <20191107182410.12660-33-hch@lst.de>
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
 fs/xfs/scrub/dir.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 501d60c9b09a..4cef21b9d336 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -327,14 +327,13 @@ xchk_directory_data_bestfree(
 	struct xfs_dir2_data_free	*bf;
 	struct xfs_mount		*mp = sc->mp;
 	const struct xfs_dir_ops	*d_ops;
-	char				*ptr;
-	char				*endptr;
 	u16				tag;
 	unsigned int			nr_bestfrees = 0;
 	unsigned int			nr_frees = 0;
 	unsigned int			smallest_bestfree;
 	int				newlen;
-	int				offset;
+	unsigned int			offset;
+	unsigned int			end;
 	int				error;
 
 	d_ops = sc->ip->d_ops;
@@ -368,13 +367,13 @@ xchk_directory_data_bestfree(
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
-		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
+		dup = bp->b_addr + offset;
 		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
 
 		/* bestfree doesn't match the entry it points at? */
 		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG) ||
 		    be16_to_cpu(dup->length) != be16_to_cpu(dfp->length) ||
-		    tag != ((char *)dup - (char *)bp->b_addr)) {
+		    tag != offset) {
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
@@ -390,30 +389,30 @@ xchk_directory_data_bestfree(
 	}
 
 	/* Make sure the bestfrees are actually the best free spaces. */
-	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
-	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
+	offset = d_ops->data_entry_offset;
+	end = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr) - bp->b_addr;
 
 	/* Iterate the entries, stopping when we hit or go past the end. */
-	while (ptr < endptr) {
-		dup = (struct xfs_dir2_data_unused *)ptr;
+	while (offset < end) {
+		dup = bp->b_addr + offset;
+
 		/* Skip real entries */
 		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
-			struct xfs_dir2_data_entry	*dep;
+			struct xfs_dir2_data_entry *dep = bp->b_addr + offset;
 
-			dep = (struct xfs_dir2_data_entry *)ptr;
 			newlen = d_ops->data_entsize(dep->namelen);
 			if (newlen <= 0) {
 				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 						lblk);
 				goto out_buf;
 			}
-			ptr += newlen;
+			offset += newlen;
 			continue;
 		}
 
 		/* Spot check this free entry */
 		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
-		if (tag != ((char *)dup - (char *)bp->b_addr)) {
+		if (tag != offset) {
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
@@ -432,13 +431,13 @@ xchk_directory_data_bestfree(
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 			goto out_buf;
 		}
-		ptr += newlen;
-		if (ptr <= endptr)
+		offset += newlen;
+		if (offset <= end)
 			nr_frees++;
 	}
 
 	/* We're required to fill all the space. */
-	if (ptr != endptr)
+	if (offset != end)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 
 	/* Did we see at least as many free slots as there are bestfrees? */
-- 
2.20.1


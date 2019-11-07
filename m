Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8656C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38F9206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cTAWvhlM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfKGSZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfKGSZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cMTYvIJWuXm8pAMBPPzu94B9cfMGiadO0dcTQSpMhvM=; b=cTAWvhlMjkxukULtbq8Ze3FxG
        O5QvI6dLFeP9GOzA99WVsOja0R4AY0H8adYelyRy+57ZleBv7xpbahoexDMdGtCRSxWnkPudVLobO
        ie9lT6HL2Eb9ZHTtY9e/rQv5UqLxsAPaeCa8zzljMRLTfujIohz0Wizcf7yi6YaMAJkTo5RN+2pid
        S40SOt/jTDyQKGds1erEhd2sFvMVd5aJMwB8SjazO82nQUxkfz7IY7FwqojNTTeOgEOUwrr1aziUm
        kLdwIRX/D3ywVJ5jSVyuP6hysi0bRO7bFEymsgp7pzro4xcWZJZroW+w6cr7Z+ETRscDUifjTnBfT
        xOKCjKzuA==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTW-0004R8-KU
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 34/46] xfs: cleanup xfs_dir2_data_freescan_int
Date:   Thu,  7 Nov 2019 19:23:58 +0100
Message-Id: <20191107182410.12660-35-hch@lst.de>
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
 fs/xfs/libxfs/xfs_dir2_data.c | 48 +++++++++++++++--------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 3ecec8e1c5f6..50e3fa092ff9 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -562,16 +562,15 @@ xfs_dir2_data_freeremove(
  */
 void
 xfs_dir2_data_freescan_int(
-	struct xfs_da_geometry	*geo,
-	const struct xfs_dir_ops *ops,
-	struct xfs_dir2_data_hdr *hdr,
-	int			*loghead)
+	struct xfs_da_geometry		*geo,
+	const struct xfs_dir_ops	*ops,
+	struct xfs_dir2_data_hdr	*hdr,
+	int				*loghead)
 {
-	xfs_dir2_data_entry_t	*dep;		/* active data entry */
-	xfs_dir2_data_unused_t	*dup;		/* unused data entry */
-	struct xfs_dir2_data_free *bf;
-	char			*endp;		/* end of block's data */
-	char			*p;		/* current entry pointer */
+	struct xfs_dir2_data_free	*bf = ops->data_bestfree_p(hdr);
+	void				*addr = hdr;
+	unsigned int			offset = ops->data_entry_offset;
+	unsigned int			end;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -581,37 +580,30 @@ xfs_dir2_data_freescan_int(
 	/*
 	 * Start by clearing the table.
 	 */
-	bf = ops->data_bestfree_p(hdr);
 	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
-	/*
-	 * Set up pointers.
-	 */
-	p = (char *)ops->data_entry_p(hdr);
-	endp = xfs_dir3_data_endp(geo, hdr);
-	/*
-	 * Loop over the block's entries.
-	 */
-	while (p < endp) {
-		dup = (xfs_dir2_data_unused_t *)p;
+
+	end = xfs_dir3_data_endp(geo, addr) - addr;
+	while (offset < end) {
+		struct xfs_dir2_data_unused	*dup = addr + offset;
+		struct xfs_dir2_data_entry	*dep = addr + offset;
+
 		/*
 		 * If it's a free entry, insert it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			ASSERT((char *)dup - (char *)hdr ==
+			ASSERT(offset ==
 			       be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)));
 			xfs_dir2_data_freeinsert(hdr, bf, dup, loghead);
-			p += be16_to_cpu(dup->length);
+			offset += be16_to_cpu(dup->length);
+			continue;
 		}
+
 		/*
 		 * For active entries, check their tags and skip them.
 		 */
-		else {
-			dep = (xfs_dir2_data_entry_t *)p;
-			ASSERT((char *)dep - (char *)hdr ==
-			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
-			p += ops->data_entsize(dep->namelen);
-		}
+		ASSERT(offset == be16_to_cpu(*ops->data_entry_tag_p(dep)));
+		offset += ops->data_entsize(dep->namelen);
 	}
 }
 
-- 
2.20.1


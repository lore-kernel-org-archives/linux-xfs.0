Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C553F30E0E5
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376330; cv=none; b=GZ0qdiXvRqORhtvwnAGJ1ehTe5wfOMEcC1q9YptArcn0SKAkUOazPDJqwz3HYyUrU2OValSYzPwM82/E905G72un3Cn1hjMggJQ6UmpkJVMNoZO34bFBjrQ4B5o8aEfw6K7Ttr7uSAaseDfqNR10qtTJellWo4gVyh8SLNFGobQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376330; c=relaxed/simple;
	bh=7mKuO0P5jcYyRHuLWT/J+KBhKbotYGfIoccSuf4WBbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EKrzM033UxEhCN46JfHtEl/2q/4pQ0aMuDp1OwbkZlpn/BULYvXWAuV473Q8qu3I5yLdVB/WE32pOrbAdJBqu591uokzmmV7auTxgsqM9eGJND5dVThsFPsBCTJhp3Ipyx39EO0fMsg6Bi6u3UJyiuobSudMr+Pe8ubYNXeVkh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=308MrTZE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="308MrTZE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gRQlFlWR6PweLZ6o12Lx6ws73AtTyk8U86Fg/u/39+s=; b=308MrTZEyYz3v4GUnEn48eSMd6
	yJmr1PaKcbemHYYB6Ra5r7xwlwH5bVr6QfIL7PPPZxqMrTC5iZXT0Oa5O/tfqWF6oVbQssQ9UVssn
	amrenK58VFboA8OvIqs5LoHGtbHLpfOfrZG1R6st/NbY+cInUm/Ib1Com+c6GfUTjJkpEQKcRDtGs
	6zAZjs5POW5y2KcP0oXhHvhJi5tTebYXolrRpFKLVEWzIhhNp1Ixeyc6iagpWsSQAVgsbRFKu7csL
	CW/ggYTe0ki0Ycvg/OeToIgYpmTalkxZ43WOoCFYY70jjrO9MEdwZEbY3uiApGaIQAHiA25+PXY0O
	khc2/BeQ==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS5Q-0000000CHtt-2ZnR;
	Mon, 10 Aug 2026 15:38:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use inode_init_always_gfp with __GFP_NOFAIL in xfs_inode_alloc
Date: Mon, 10 Aug 2026 08:38:38 -0700
Message-ID: <20260810153848.466459-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just like the inode allocation itself, allocation of the security data
inside of inode_init_always(_gfp) must not fail here as we can be inside
an already dirty transaction context.  Note that we do not have to pass
GFP_NOFS explicitly as we are already in a nofs context when in a
transaction, as seen by the call to alloc_inode_sb.

Also update the comment about this a bit to be more clear.

Fixes: bf904248a2ad ("[XFS] Combine the XFS and Linux inodes")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9d8dd30bd927..a857b8aa255c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -82,24 +82,20 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
 
 /*
  * Allocate and initialise an xfs_inode.
+ *
+ * This can happen in context of already dirtied transactions, so the memory
+ * allocations must not fail.
  */
 struct xfs_inode *
 xfs_inode_alloc(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
 {
+	gfp_t			gfp = GFP_KERNEL | __GFP_NOFAIL;
 	struct xfs_inode	*ip;
 
-	/*
-	 * XXX: If this didn't occur in transactions, we could drop GFP_NOFAIL
-	 * and return NULL here on ENOMEM.
-	 */
-	ip = alloc_inode_sb(mp->m_super, xfs_inode_cache, GFP_KERNEL | __GFP_NOFAIL);
-
-	if (inode_init_always(mp->m_super, VFS_I(ip))) {
-		kmem_cache_free(xfs_inode_cache, ip);
-		return NULL;
-	}
+	ip = alloc_inode_sb(mp->m_super, xfs_inode_cache, gfp);
+	inode_init_always_gfp(mp->m_super, VFS_I(ip), gfp);
 
 	VFS_I(ip)->i_ino = ino;
 	/* VFS doesn't initialise i_mode! */
-- 
2.53.0


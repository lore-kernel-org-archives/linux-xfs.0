Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC223ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777594; cv=none; b=Hz/74SIU8yBpQ2piAB8t3+hGpw3wI+XC8NUvupI19SXI/UHKaExBn0KDDo/buWQ3qZXyhQ1ejfv9qt6nE2OWZxN7C/TAszUZbYr7y/QfVom+nrfzpEZrC/Xvx51Xkcld+S3gJj5lNTzxvaD5cztzyVkQQbFtQJuuK35fmLLkAiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777594; c=relaxed/simple;
	bh=bjumHb24U3puXY7gAUZ5E5U5gi8GlxKb14cGT6NEX8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQbr/PSycwR91Jb8uZSBlQIRZWxEcT+jjyCgPx6qlo6NpNtFhcV37euUfwyl8pa6QrTmWkMBPrbFjOZqbayWJofuWm1dJuaOjpslNiMmP6l+DkFzall0wqBcqdnVVUqzc/kV4civuJPW57nwwhMaAr5o96LkFSntrbB11r427FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NrEzyQJP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NrEzyQJP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=625QnUaeeXh2s/uBCGZT37tOb2LO2hwsjIEmvbSPDgg=; b=NrEzyQJP2ITsnZCvdtBXngXiFK
	ZH3pag4kOtZ7UlOHiW/g1F0XjwkhyyfGKgoDaEmNK/BsGa7/LmYcq1W3VfDWev3YT11fgU3DTdtzi
	9iBCna5lWBr+jhgWY3aoEJ81410TBvo7SW4eTNGym/VnlDK9C4GYV0jKJobYS3V5yKmpu8Jpsh74d
	l2iqqq9fljD1vBhmkdySHWuQWfzkui7DWleRAd2TIAIU62kY0fIYbdtgbLRf2KZp9zIj9nF4P82uH
	zYRPz8a0B9XpQr3aHRT0nfIs6kYCVMe/gk4uRuge/lwLC8glX6LhyKP4OOo7wIB3G++zYx1oL8d8Z
	LCHKbvbw==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBo-00000005Mtn-2ytZ;
	Mon, 13 Jan 2025 14:13:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/15] xfs: simplify xfsaild_resubmit_item
Date: Mon, 13 Jan 2025 15:12:17 +0100
Message-ID: <20250113141228.113714-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Since commit acc8f8628c37 ("xfs: attach dquot buffer to dquot log item
buffer") all buf items that use bp->b_li_list are explicitly checked for
in the branch to just clears XFS_LI_FAILED.  Remove the dead arm that
calls xfs_clear_li_failed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_trans_ail.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f56d62dced97..0fcb1828e598 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -359,13 +359,8 @@ xfsaild_resubmit_item(
 	}
 
 	/* protected by ail_lock */
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-		if (bp->b_flags & (_XBF_INODES | _XBF_DQUOTS))
-			clear_bit(XFS_LI_FAILED, &lip->li_flags);
-		else
-			xfs_clear_li_failed(lip);
-	}
-
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		clear_bit(XFS_LI_FAILED, &lip->li_flags);
 	xfs_buf_unlock(bp);
 	return XFS_ITEM_SUCCESS;
 }
-- 
2.45.2


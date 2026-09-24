Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8765441F37D
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244373; cv=none; b=aogyNBRx0xRMcNNpSnwRiDgjViJqtwdt0R7JxJHTK1MHhZpg1m/YMuCnhg4/h94i7gLG8flqDSRcAtmMmvm1jbv/LJ3XTAN4/JQlfVJcRMJvBoIPzdNSj8n/dY2MKuy0v8lq1UPQclkIPN0EwZry80BQfESloyupQwKdl/B0qxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244373; c=relaxed/simple;
	bh=P4vunPBfdriEUB9YE181JhZi9+DwWNacPVeI6dr9Gqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvutFa/FujVrIFUeeJ7r7we92v4XsxRQsbWWDUhPrzLHiF20ZE2wtLQMw4WChJ0s/OaW3LEUOU843s90WsnzUfF2kj4KCWn/Xjwm2VHH6Owrd7AH7ShhEiIB1jEq3OqKE8R7HgFvpdMtqzJnEt3N8qKnXWN/4tgLV8it60Blt1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P3bv8hqq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P3bv8hqq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hR9dC84QF/o165A8J4vKngWYmYSd1zWZpg1wZo/89Uk=; b=P3bv8hqqTLhT3RXyBHuVehDrqi
	UeXQtJH8CiSSB1q2PflJhNzhSn2GpAu7ul3X2YeiQa/KMieMdnfLBpVOL0Aq7qjfTPnMziXwLaLXJ
	y9qHRSVAfo1Sp4PU7ESkVBYYW1jw92PAHqCcXflia5yDSp5AyOmHb6VchG53DF6NjRcF1xvcl+si/
	Ouo2Or8ye4KvLxxqhL07L3XXQme1DkT6wfeJPlMhF8kO2JW71tj1npzV5aw87DM9Lud0Rh6DTrgLe
	/M+UTC3zp+fxCCKDcn6g7rU8rlLTFpRzg7WnzFYtzJPjTwgkkKHSj2iPyYuptHZdkbshN8Q2AHJAb
	5XiTKBdA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gL4-0000000AfJW-1Qou;
	Thu, 24 Sep 2026 10:06:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/32] xfs: introduce XFS_BLI_PREALLOC
Date: Thu, 24 Sep 2026 12:04:03 +0200
Message-ID: <20260924100512.2733748-14-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 4d5a534c06d09083d7b70801a11201ff0b5bacd2

Add a flag so that the shadow CIL buffer for a buffer log item is always
sizes to the maximum to prevent reallocations.  This will be used for the
RT checksum item, where we know that we are going to fill it up very soon,
and (almost) sequentially, so there is no point in doing a constant
realloc cycle when more data is added to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_trans_resv.c | 2 +-
 libxfs/xfs_trans_resv.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 5b7660b1cd8a..3a9de562ac2b 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -46,7 +46,7 @@ xfs_buf_log_overhead(void)
  * will be changed in a transaction.  size is used to tell how many
  * bytes should be reserved per item.
  */
-STATIC uint
+uint
 xfs_calc_buf_res(
 	uint		nbufs,
 	uint		size)
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 336279e0fc61..1804e821f382 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -96,6 +96,7 @@ struct xfs_trans_resv {
 #define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
 #define	XFS_WRITE_LOG_COUNT_REFLINK	8
 
+uint xfs_calc_buf_res(uint nbufs, uint size);
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 
-- 
2.53.0


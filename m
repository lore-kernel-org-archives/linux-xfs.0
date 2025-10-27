Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BF2BDC2B
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548787; cv=none; b=Dln0ScoAw86QUPfRxyYi7gYSJ+vvUXnWHGimzAi4I+yWy8MHXreRGVAP/57M8+VcuvDfVrONmKFxYy/SfBjq9hhPu1sqjOmZcYxEDbQRsO/mI23OWZ2bNhNG3AYAxHkdn9M5Xv1sjqOY7GBZzGxZbQvklImC8zzasY5D0f95np4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548787; c=relaxed/simple;
	bh=x/V4Mb9XKhusWhMAt0l0bmFGPq72oA9hadtKRrbSwaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2vKfqIO592rcQGw086m0UM0xJeWS1WCCSOQPKylCh3FGPfwopErHE2trNJjVotM5TNvOpWLnl8fXjtAK6zGUuZAHgGvI2TogvOFEDQrPzMK3LM5lKjjLXzM3wyGEmQ0I5xun4MrVLHc2DscwMtvJAatTQPw/jz0KX40sZh6gmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tzI9JCyQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tzI9JCyQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pUq75t7eMeqjZ+pjfQXQjlIs0Gy2s/4F7dMrfN95y3s=; b=tzI9JCyQNxbaTJrYh0HPU/63i2
	O3phF5Gxi9gVRGZsljh4v5ICC+koYpWd2GUqN3rgZeyiO1KVNZdvv2M+CbYkp6V5MNiVdAwrvw44c
	ojtGyTXIMwYryKB9Ttr5R5vkicOYghx86tD0oeTpWpfK2GmvZktx65BPjRvIXP2EqP8EDXxiSz8ty
	iz3ZcS6CqQp3A06m4PaTzj6R9ZFHF11/2+wZJWbjUDOBBQCKU77CCM/5ZoP9Cz4w3AgQQXY5rO/vb
	mQSiX4IiYGZN1Hij1WsffqoHpH0G3RbVXwYleMWle8mEGbsIP+dCcJIBtUbrMSMxmXb0xrycqXjZn
	Vb1DqTHg==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHJA-0000000DFgI-3PMP;
	Mon, 27 Oct 2025 07:06:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 4/9] xfs: cleanup xlog_alloc_log a bit
Date: Mon, 27 Oct 2025 08:05:51 +0100
Message-ID: <20251027070610.729960-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Remove the separate head variable, move the ic_datap initialization
up a bit where the context is more obvious and remove the duplicate
memset right after a zeroing memory allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d9476124def6..3bd2f8787682 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1367,7 +1367,6 @@ xlog_alloc_log(
 	int			num_bblks)
 {
 	struct xlog		*log;
-	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
 	int			i;
@@ -1461,22 +1460,21 @@ xlog_alloc_log(
 				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (!iclog->ic_header)
 			goto out_free_iclog;
-		head = iclog->ic_header;
-		memset(head, 0, sizeof(xlog_rec_header_t));
-		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
-		head->h_version = cpu_to_be32(
+		iclog->ic_header->h_magicno =
+			cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
+		iclog->ic_header->h_version = cpu_to_be32(
 			xfs_has_logv2(log->l_mp) ? 2 : 1);
-		head->h_size = cpu_to_be32(log->l_iclog_size);
-		/* new fields */
-		head->h_fmt = cpu_to_be32(XLOG_FMT);
-		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
+		iclog->ic_header->h_size = cpu_to_be32(log->l_iclog_size);
+		iclog->ic_header->h_fmt = cpu_to_be32(XLOG_FMT);
+		memcpy(&iclog->ic_header->h_fs_uuid, &mp->m_sb.sb_uuid,
+			sizeof(iclog->ic_header->h_fs_uuid));
 
+		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 		iclog->ic_size = log->l_iclog_size - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
 		INIT_LIST_HEAD(&iclog->ic_callbacks);
-		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
 
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
-- 
2.47.3


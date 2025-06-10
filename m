Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA3E7083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532610; cv=none; b=WpXCri20X2Jh+/g2FPwTlMSN5BiQUmssGoT37WpO4lfcQT3rmHKoccfD6XyqScszWXPQy3Tw5xOHdts6+elD7+MiB1TPA4eSrax7AkPy4JA9ipqTxVnpEt1/TxBC+g7uhxOHiKbqpSRgWHgCDQvCagnAgYzvdYpgCNeZGwKiGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532610; c=relaxed/simple;
	bh=dZOhWSh/mwtLIFejJYIK347AKJeh+5Op+Xc7aQSD+zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6pOrrNZQc95L1wcszAbIuhH4vMFJzJcLC2SvouoJGa2B4oC0mq0HxYEfywHkaPFllrdiH5zif/Z2SYVYRy15VTSJ5jaDy1S0Gkx5hLJSFxlD7Vdpn64n19rIcGD/zTExKgBzBrygvEt4gd5NeBpIB7T1wCt90GtUznQBobryyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y9aXtR0G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y9aXtR0G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O/R8x/yyMXtF7IuYDpSJ8Nqs8oretukwH9G1uf2XO0s=; b=Y9aXtR0GQ70ztPAOfVblaC1ZW3
	or4V6d7JXnAmrQh9K6vZjZo0jsPsanpCpvf56LF6Ry8BVR2qCf9ffL4LMS3MLrJyiNKEo3hkrxIyH
	0pSNaqbnPkoyVb5jUEhi+Q7wJHqBj75QhQEX8l/vzARQ+aohUqr7FGLZ5PUdIaDdiXwY+9Qqzn374
	/ey5PHs2vaIpZ7T7ua5iGbWGY+9zntrX43qsNmQGhfLyEGOUYjEdOJmz+iKM8qCxzOSnVJ4+t/IAA
	/WCL/yHUteLh5Iyn9DIza5MzOKKvshlQVaJhTySPN5wYDe8DJT6ImbSoAPXWbOI1rilujJ8tNyxyq
	Y/A5P+Tw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrLs-00000005pGK-2uQJ;
	Tue, 10 Jun 2025 05:16:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/17] xfs: don't pass the old lv to xfs_cil_prepare_item
Date: Tue, 10 Jun 2025 07:14:58 +0200
Message-ID: <20250610051644.2052814-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

By the time xfs_cil_prepare_item is called, the old lv is still pointed
to by the log item.  Take it from there instead of spreading the old lv
logic over xlog_cil_insert_format_items and xfs_cil_prepare_item.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f66d2d430e4f..c3db01b2ea47 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -370,8 +370,8 @@ xlog_cil_alloc_shadow_bufs(
 STATIC void
 xfs_cil_prepare_item(
 	struct xlog		*log,
+	struct xfs_log_item	*lip,
 	struct xfs_log_vec	*lv,
-	struct xfs_log_vec	*old_lv,
 	int			*diff_len)
 {
 	/* Account for the new LV being passed in */
@@ -381,19 +381,19 @@ xfs_cil_prepare_item(
 	/*
 	 * If there is no old LV, this is the first time we've seen the item in
 	 * this CIL context and so we need to pin it. If we are replacing the
-	 * old_lv, then remove the space it accounts for and make it the shadow
+	 * old lv, then remove the space it accounts for and make it the shadow
 	 * buffer for later freeing. In both cases we are now switching to the
 	 * shadow buffer, so update the pointer to it appropriately.
 	 */
-	if (!old_lv) {
+	if (!lip->li_lv) {
 		if (lv->lv_item->li_ops->iop_pin)
 			lv->lv_item->li_ops->iop_pin(lv->lv_item);
 		lv->lv_item->li_lv_shadow = NULL;
-	} else if (old_lv != lv) {
+	} else if (lip->li_lv != lv) {
 		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
 
-		*diff_len -= old_lv->lv_bytes;
-		lv->lv_item->li_lv_shadow = old_lv;
+		*diff_len -= lip->li_lv->lv_bytes;
+		lv->lv_item->li_lv_shadow = lip->li_lv;
 	}
 
 	/* attach new log vector to log item */
@@ -453,7 +453,6 @@ xlog_cil_insert_format_items(
 
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		struct xfs_log_vec *lv;
-		struct xfs_log_vec *old_lv = NULL;
 		struct xfs_log_vec *shadow;
 		bool	ordered = false;
 
@@ -474,7 +473,6 @@ xlog_cil_insert_format_items(
 			continue;
 
 		/* compare to existing item size */
-		old_lv = lip->li_lv;
 		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
 			/* same or smaller, optimise common overwrite case */
 			lv = lip->li_lv;
@@ -510,7 +508,7 @@ xlog_cil_insert_format_items(
 		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
 		lip->li_ops->iop_format(lip, lv);
 insert:
-		xfs_cil_prepare_item(log, lv, old_lv, diff_len);
+		xfs_cil_prepare_item(log, lip, lv, diff_len);
 	}
 }
 
-- 
2.47.2


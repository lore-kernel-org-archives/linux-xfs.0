Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6272DEA72
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582697; cv=none; b=qkH3SBMzDCvF5Z72tKCa8LKuTKaUHmq54n2JNKKYYrIdPK/ZERUM6xng4qBnMW6QdusPcphL64GNh4y9ON1MomX7/Z/6BRqhWrSvVHSNybqcEO8yXyZax0ppkrKRQWEu72XIRIRZl9HeOboZ8vpefKzBawLE21BBzPVsyRYhP+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582697; c=relaxed/simple;
	bh=6EqkgQgXgavPW82zUfuJ7AOohAKfb22il6UH44tvEBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOWKga/tLJozKrNUZRuaSFouAm79NwNi+3aasj/7BZTuE80j7tODfO6qSfPXjqSEfwssx+eYVtL7wRDeBW1XIq12/8G5dZUpOCUCirsSXXsR52G08frM1vRFYH1rPKB87txa6oB4+NFz2wcpZFzOZMtZdKSrC+wkTUfzhdwhRNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OgDTP7qn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OgDTP7qn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uTGRHz7gKkTgIicNR16Dnb/Al5c9cQ/nh/+CbUWoJ5U=; b=OgDTP7qnvkwGPwaG2nmxLo5bJ4
	WbyurJmLlnpqDwmiGRhmKg1MTKWHKMAPB///B9LppmJPs4XfSXCVE7TxOBhEmG5HHYiZyfz6HSqwQ
	TE3bHQatpmhy5wLtHI7OmKxSiIMnWKRZrQ0tvxhLpxMjczY/2+6B4j1SFO48cT8/QqkFbvUTAlqQE
	vrzG1kbg3SrcsNvXER1ZOzR4qWMPgoGPYL/cwXdCkZHWmeFfadoYsxXY7rPwQek3CbvJqMHSulG0H
	4c26C3iv5TuEqY904XPJTebAy4Oi1Xxyl9LzoUV0VPcVMJmLb7B7WDHTVMEAo1RmicN9tgbiuiS/+
	mEWUAbYQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubeon-000000054kn-0VuV;
	Tue, 15 Jul 2025 12:31:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 02/18] xfs: cleanup the ordered item logic in xlog_cil_insert_format_items
Date: Tue, 15 Jul 2025 14:30:07 +0200
Message-ID: <20250715123125.1945534-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out handling of ordered items into a single branch in
xlog_cil_insert_format_items so that the rest of the code becomes more
clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 2c31c7c0ef97..9200301e539b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -452,9 +452,8 @@ xlog_cil_insert_format_items(
 	}
 
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
-		struct xfs_log_vec *lv;
-		struct xfs_log_vec *shadow;
-		bool	ordered = false;
+		struct xfs_log_vec *lv = lip->li_lv;
+		struct xfs_log_vec *shadow = lip->li_lv_shadow;
 
 		/* Skip items which aren't dirty in this transaction. */
 		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
@@ -464,21 +463,23 @@ xlog_cil_insert_format_items(
 		 * The formatting size information is already attached to
 		 * the shadow lv on the log item.
 		 */
-		shadow = lip->li_lv_shadow;
-		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
-			ordered = true;
+		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED) {
+			if (!lv) {
+				lv = shadow;
+				lv->lv_item = lip;
+			}
+			ASSERT(shadow->lv_size == lv->lv_size);
+			xfs_cil_prepare_item(log, lip, lv, diff_len);
+			continue;
+		}
 
 		/* Skip items that do not have any vectors for writing */
-		if (!shadow->lv_niovecs && !ordered)
+		if (!shadow->lv_niovecs)
 			continue;
 
 		/* compare to existing item size */
-		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
+		if (lv && shadow->lv_size <= lv->lv_size) {
 			/* same or smaller, optimise common overwrite case */
-			lv = lip->li_lv;
-
-			if (ordered)
-				goto insert;
 
 			/*
 			 * set the item up as though it is a new insertion so
@@ -498,16 +499,10 @@ xlog_cil_insert_format_items(
 			/* switch to shadow buffer! */
 			lv = shadow;
 			lv->lv_item = lip;
-			if (ordered) {
-				/* track as an ordered logvec */
-				ASSERT(lip->li_lv == NULL);
-				goto insert;
-			}
 		}
 
 		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
 		lip->li_ops->iop_format(lip, lv);
-insert:
 		xfs_cil_prepare_item(log, lip, lv, diff_len);
 	}
 }
-- 
2.47.2


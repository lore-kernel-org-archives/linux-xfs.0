Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA25D28D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366179; cv=none; b=jLta9xlIH9IIra0gVs6ZFToiW/gfsFbDqDAPEp6ReXpsLZxO4cpqyK4mBD86Me1bdIhm0Oah3cCc1kC24oUtNvvtj3IGJ+LOAkXhaN/e/DipFwjvUvJD0EHMGUPZNo1705nja3eDqmIL8nAh1Vkucu4qcyO29l2Ff+pOQvt6NrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366179; c=relaxed/simple;
	bh=sA13kw9FhD7gMvhsQfQNyymdnJAdif4ycdypkUsM61M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jTyTVoh55XVIx6xalotdbIF1qlE6S0+F98BktrJ4SB0READhjwKA7RKkHbisM37f3FBYdCHF9y+CjEwfEedyHxA9s0XTK8JEntVIKFs6WICRvojq5fMdU41mr7waz5bV65mrBrw2gM9wVkBfE/9RRBVe9zcZnp7yRsveUD8TtmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xLGoR9s/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xLGoR9s/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+tWV+bp6iGWTVnLeA5oPjcqfEgPGbJauCznjmy4+A6U=; b=xLGoR9s/6EnoqMwdDpO1HYP8sJ
	iwl0O9hPXR/Y/jqsU2na5OHaiXXRDkLcnmQjG/BA0sPjw97XJ2zmYVE3syAmBD3b7Q++gOitsTAzN
	GT0jP2i/UyIeC0Lqnkaw/5JMczTpx9YAQHWv6aOk8yBPArUg0a0wZqkFA8TMAbmuLyopgBPJNuksZ
	ejxfmrWnG9M2Up79Ybey6JX+cRmUGSSjEyroxl36KU4FosoUxGZKia073ZeDN5SeUFqqFtBX71/Lr
	q3nE/BhUJOrRP44Y2LLvSIH3LKPL8iZ1TDnohkOgOLv9EkyArkkHCTl+vG0lrrBx3aPnXmAJ0zaaK
	rQ23z3hw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1IxM-00000001S7g-3hVt;
	Mon, 29 Apr 2024 04:49:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: lift XREP_MAX_ITRUNCATE_EFIS out of the scrub code
Date: Mon, 29 Apr 2024 06:49:15 +0200
Message-Id: <20240429044917.1504566-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We want to play the same trick in the COW end I/O handler, so lift this
constant out of the scrub directory and change the prefix to XFS_.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_resv.h | 7 +++++++
 fs/xfs/scrub/newbt.c           | 2 +-
 fs/xfs/scrub/reap.c            | 2 +-
 fs/xfs/scrub/repair.h          | 8 --------
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 0554b9d775d269..51eb56560ee189 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -95,6 +95,13 @@ struct xfs_trans_resv {
 #define	XFS_ITRUNCATE_LOG_COUNT_REFLINK	8
 #define	XFS_WRITE_LOG_COUNT_REFLINK	8
 
+/*
+ * This is the maximum number of deferred extent freeing item extents (EFIs)
+ * that we'll attach to a transaction without rolling the transaction to avoid
+ * overrunning a tr_itruncate reservation.
+ */
+#define XFS_MAX_ITRUNCATE_EFIS		128
+
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
 uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
 
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 4a0271123d94ea..872f97db2a6425 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -452,7 +452,7 @@ xrep_newbt_free(
 		}
 
 		freed += ret;
-		if (freed >= XREP_MAX_ITRUNCATE_EFIS) {
+		if (freed >= XFS_MAX_ITRUNCATE_EFIS) {
 			error = xrep_defer_finish(sc);
 			if (error)
 				goto junkit;
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 01ceaa4efa16bf..433891b0d08c73 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -169,7 +169,7 @@ static inline bool xreap_want_roll(const struct xreap_state *rs)
 {
 	if (rs->force_roll)
 		return true;
-	if (rs->deferred > XREP_MAX_ITRUNCATE_EFIS)
+	if (rs->deferred > XFS_MAX_ITRUNCATE_EFIS)
 		return true;
 	if (rs->invalidated > XREAP_MAX_BINVAL)
 		return true;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 0e0dc2bf985c21..ec76774afffb31 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -17,14 +17,6 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 
-/*
- * This is the maximum number of deferred extent freeing item extents (EFIs)
- * that we'll attach to a transaction without rolling the transaction to avoid
- * overrunning a tr_itruncate reservation.
- */
-#define XREP_MAX_ITRUNCATE_EFIS	(128)
-
-
 /* Repair helpers */
 
 int xrep_attempt(struct xfs_scrub *sc, struct xchk_stats_run *run);
-- 
2.39.2


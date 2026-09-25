Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4384BE428
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349690; cv=none; b=lck3xrYCHUeK+AF6Rp6iWkmyWwQ+rWi0tzWJW6BgcFVRYrKSv3sR8YL+j4MojF2yxbJTqvP0T6pMirnPPLf2gkny3mvNBuJlK6whjQPvhg3axdn0yfVJFCWsphUGv6gXydPx7BjGTTgYbkCFZEMFT+AMt1xlO2oeBJA/HCI3BBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349690; c=relaxed/simple;
	bh=gcVviYdjEsB4w89ku7JS9CyF41owd1uA3swVD86VHtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn681kmInW0o+GSEa5X4nVSYRPMpsL5DMkdtuJgDENrhWYBDx3ZA8zBi3E3N4aVuwt53SIlTLDrwDO/BexE62KyeO/jxLfYp2ATRp82CVeldTVXPNEaEw0tP3f2WBLXl0MGdskUL0IuclaqJ1Sc4t1TkjvLKFPpPIRcjIiJO+Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pIjc9+2O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pIjc9+2O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VG7VUAxeNDPS7qMFP/nCSfV1kOPuao64av2fn6XiktA=; b=pIjc9+2OEncfq3QuYlYapH2Xp3
	DgyHCXticBtUN3kly//b5weL6pPokmMXTTQ0t/P3ugr3nCpxRfjEM5pbnEp3kKx011INTgL1oGQs8
	kHIsMySsjW43o+JvBA1U2QYT/QRonRHiUGH2HNfho1izcDRCCvArMLPesrVbrWibwa9Pmf0O/lv3H
	X0LSXPseFFgvMEAvQQCJMqZqELlgtIiWCLj1f1XjAAtKnNuBk70vK+AjJTiTFxYY71ZC6wNMoqga/
	LvDWvlcv+nyMxPMXaz4ks46Q4F8nCwziqkg+2yQ8XtCILYKHhgA99eu+P73/qnFyrSjZj56/uARnN
	eeVzIPLw==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jr-0000000Dldc-40zT;
	Fri, 25 Sep 2026 15:21:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/13] libxfs: remove the xfs_log_item_t and xfs_buf_log_item_t typedefs
Date: Fri, 25 Sep 2026 17:20:26 +0200
Message-ID: <20260925152107.3386097-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These are long gone from the kernel, so catch up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/logitem.c         |  8 ++++----
 libxfs/stubs/xfs_trans.h | 12 ++++++------
 libxfs/trans.c           |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index d09ff75e9ce2..0bb9088db351 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -74,10 +74,10 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 void
 xfs_buf_item_init(
 	struct xfs_buf		*bp,
-	xfs_mount_t		*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_log_item_t		*lip;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_log_item	*lip;
+	struct xfs_buf_log_item	*bip;
 
 #ifdef LI_DEBUG
 	fprintf(stderr, "buf_item_init for buffer %p\n", bp);
@@ -121,7 +121,7 @@ xfs_buf_item_init(
  */
 void
 xfs_buf_item_log(
-	xfs_buf_log_item_t	*bip,
+	struct xfs_buf_log_item	*bip,
 	uint			first,
 	uint			last)
 {
diff --git a/libxfs/stubs/xfs_trans.h b/libxfs/stubs/xfs_trans.h
index fcd58930cc85..1117aad80c2f 100644
--- a/libxfs/stubs/xfs_trans.h
+++ b/libxfs/stubs/xfs_trans.h
@@ -21,7 +21,7 @@ struct xfs_item_ops {
 	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
 };
 
-typedef struct xfs_log_item {
+struct xfs_log_item {
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
 	uint				li_type;	/* item type */
@@ -29,12 +29,12 @@ typedef struct xfs_log_item {
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
 	struct list_head		li_bio_list;	/* buffer item list */
 	const struct xfs_item_ops	*li_ops;	/* function list */
-} xfs_log_item_t;
+};
 
 #define XFS_LI_DIRTY	3	/* log item dirty in transaction */
 
 struct xfs_inode_log_item {
-	xfs_log_item_t		ili_item;		/* common portion */
+	struct xfs_log_item	ili_item;		/* common portion */
 	struct xfs_inode	*ili_inode;		/* inode pointer */
 	unsigned short		ili_lock_flags;		/* lock flags */
 	unsigned int		ili_dirty_flags;	/* dirty in current tx */
@@ -43,13 +43,13 @@ struct xfs_inode_log_item {
 	spinlock_t		ili_lock;
 };
 
-typedef struct xfs_buf_log_item {
-	xfs_log_item_t		bli_item;	/* common item structure */
+ struct xfs_buf_log_item {
+	struct xfs_log_item	bli_item;	/* common item structure */
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* recursion count */
 	struct xfs_buf_log_format	__bli_format;	/* in-log header */
-} xfs_buf_log_item_t;
+};
 
 #define XFS_BLI_DIRTY			(1<<0)
 #define XFS_BLI_HOLD			(1<<1)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 9dd2e244a812..aa303288a81c 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -941,7 +941,7 @@ free_item:
 
 static void
 buf_item_done(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_buf_log_item	*bip)
 {
 	struct xfs_buf		*bp;
 	int			hold;
@@ -972,7 +972,7 @@ trans_committed(
 		xfs_trans_del_item(lip);
 
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_done((xfs_buf_log_item_t *)lip);
+			buf_item_done((struct xfs_buf_log_item *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
 			inode_item_done((struct xfs_inode_log_item *)lip);
 		else {
@@ -985,7 +985,7 @@ trans_committed(
 
 static void
 buf_item_unlock(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_buf_log_item	*bip)
 {
 	struct xfs_buf		*bp = bip->bli_buf;
 	uint			hold;
@@ -1017,7 +1017,7 @@ xfs_trans_free_items(
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_unlock((xfs_buf_log_item_t *)lip);
+			buf_item_unlock((struct xfs_buf_log_item *)lip);
 		else if (lip->li_type == XFS_LI_INODE)
 			inode_item_unlock((struct xfs_inode_log_item *)lip);
 		else {
-- 
2.53.0


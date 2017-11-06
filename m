Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFOfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 09:35:06 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eBiUU-0001QG-4A
        for linux-xfs@vger.kernel.org; Mon, 06 Nov 2017 14:35:06 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] xfs: trivial sparse fixes for the new scrub code
Date: Mon,  6 Nov 2017 15:34:50 +0100
Message-Id: <20171106143456.13567-3-hch@lst.de>
In-Reply-To: <20171106143456.13567-1-hch@lst.de>
References: <20171106143456.13567-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c  | 4 ++--
 fs/xfs/scrub/bmap.c  | 2 +-
 fs/xfs/scrub/btree.c | 2 +-
 fs/xfs/scrub/dir.c   | 2 +-
 fs/xfs/scrub/scrub.c | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 51a553337dc4..99992dd8a5c3 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -91,7 +91,7 @@ xfs_scrub_xattr_listent(
 	int				valuelen)
 {
 	struct xfs_scrub_xattr		*sx;
-	struct xfs_da_args		args = {0};
+	struct xfs_da_args		args = { NULL };
 	int				error = 0;
 
 	sx = container_of(context, struct xfs_scrub_xattr, context);
@@ -420,7 +420,7 @@ int
 xfs_scrub_xattr(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_xattr		sx = { 0 };
+	struct xfs_scrub_xattr		sx = { { NULL } };
 	struct attrlist_cursor_kern	cursor = { 0 };
 	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 39fb2a537aea..42fec0bcd9e1 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -229,7 +229,7 @@ xfs_scrub_bmap(
 	int				whichfork)
 {
 	struct xfs_bmbt_irec		irec;
-	struct xfs_scrub_bmap_info	info = {0};
+	struct xfs_scrub_bmap_info	info = { NULL };
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_inode		*ip = sc->ip;
 	struct xfs_ifork		*ifp;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 9e8b67a07baf..a81440496e7b 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -414,7 +414,7 @@ xfs_scrub_btree(
 	struct xfs_owner_info		*oinfo,
 	void				*private)
 {
-	struct xfs_scrub_btree		bs = {0};
+	struct xfs_scrub_btree		bs = { NULL };
 	union xfs_btree_ptr		ptr;
 	union xfs_btree_ptr		*pp;
 	union xfs_btree_rec		*recp;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 73ac795aa6a5..d4cd7661633d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -560,7 +560,7 @@ xfs_scrub_directory_free_bestfree(
 	struct xfs_buf			*dbp;
 	struct xfs_buf			*bp;
 	__be16				*bestp;
-	__be16				best;
+	__u16				best;
 	unsigned int			stale = 0;
 	int				i;
 	int				error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8c8b52523fbc..9c42c4efd01e 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -123,7 +123,7 @@
  * structure state to decide (in broad terms) if scrub/repair are
  * supported by the running kernel.
  */
-int
+static int
 xfs_scrub_probe(
 	struct xfs_scrub_context	*sc)
 {
-- 
2.14.2


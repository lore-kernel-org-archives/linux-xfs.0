Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A59C83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BBA21974
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b9B6u91k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgD2PFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EDDC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=qspUYHYalX6V088Zl2DYOu0AwuETm3poMU7gWjO7Sxw=; b=b9B6u91kB4wraRV5HCsC413j05
        C4eacqAhIKNEB9YiDD5U1VWbZX28osd+mXCJZd9LEqm2Y4jB7DmPBotdI247w+RJWlBv+HQ/TU/AC
        CXaRJjc1VMsXXC7uxvwZZU43Qj9Bbjz81O1k/K9BDnSRsdZwEkqy+QF4ZgCPoRzYt7lxajH0hf8RQ
        9ka/s8giaepuSDuIHFCpc8zVmd0kigV0zMwyNAkEptI0Pt9KCbGFRe5sJ7ortn40kpaJUmgg2ZcK+
        mFA1G19H3h2ve+cWRb0cz97WwevoBW2M4j7UDE9KVZdr9M9sBPNYIbfbfgPhUKvFs3MJeON16YCku
        Udd5FTCw==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToH5-00009t-D4
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/11] xfs: remove the xfs_inode_log_item_t typedef
Date:   Wed, 29 Apr 2020 17:05:03 +0200
Message-Id: <20200429150511.2191150-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429150511.2191150-1-hch@lst.de>
References: <20200429150511.2191150-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c  | 2 +-
 fs/xfs/libxfs/xfs_trans_inode.c | 2 +-
 fs/xfs/xfs_inode.c              | 4 ++--
 fs/xfs/xfs_inode_item.c         | 2 +-
 fs/xfs/xfs_inode_item.h         | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 518c6f0ec3a61..3e9a42f1e23b9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -592,7 +592,7 @@ void
 xfs_iflush_fork(
 	xfs_inode_t		*ip,
 	xfs_dinode_t		*dip,
-	xfs_inode_log_item_t	*iip,
+	struct xfs_inode_log_item *iip,
 	int			whichfork)
 {
 	char			*cp;
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 2b8ccb5b975df..b5dfb66548422 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -27,7 +27,7 @@ xfs_trans_ijoin(
 	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (ip->i_itemp == NULL)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29d..0e2ef3f56be41 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2602,7 +2602,7 @@ xfs_ifree_cluster(
 	xfs_daddr_t		blkno;
 	xfs_buf_t		*bp;
 	xfs_inode_t		*ip;
-	xfs_inode_log_item_t	*iip;
+	struct xfs_inode_log_item *iip;
 	struct xfs_log_item	*lip;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -2662,7 +2662,7 @@ xfs_ifree_cluster(
 		 */
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 			if (lip->li_type == XFS_LI_INODE) {
-				iip = (xfs_inode_log_item_t *)lip;
+				iip = (struct xfs_inode_log_item *)lip;
 				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = xfs_istale_done;
 				xfs_trans_ail_copy_lsn(mp->m_ail,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f779cca2346f3..75b74bbe38e43 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -780,7 +780,7 @@ xfs_iflush_abort(
 	xfs_inode_t		*ip,
 	bool			stale)
 {
-	xfs_inode_log_item_t	*iip = ip->i_itemp;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
 
 	if (iip) {
 		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 07a60e74c39c8..ad667fd4ae622 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -13,7 +13,7 @@ struct xfs_bmbt_rec;
 struct xfs_inode;
 struct xfs_mount;
 
-typedef struct xfs_inode_log_item {
+struct xfs_inode_log_item {
 	struct xfs_log_item	ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
@@ -23,7 +23,7 @@ typedef struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;   /* fields when flushed */
 	unsigned int		ili_fields;	   /* fields to be logged */
 	unsigned int		ili_fsync_fields;  /* logged since last fsync */
-} xfs_inode_log_item_t;
+};
 
 static inline int xfs_inode_clean(xfs_inode_t *ip)
 {
-- 
2.26.2


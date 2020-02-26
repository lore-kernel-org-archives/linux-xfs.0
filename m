Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB070C4BA26
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F66724656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j/Y8NI1v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgBZUZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:25:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8XkYPT5OJ3uQ/cKkQ4p5hGvrKLEgl1WQErh7b+6DP0k=; b=j/Y8NI1vsL16vBBStTbKOr+OXo
        eYRVs60s44FMAYpgEJxlevwJiXy3Vzp283nQcJhcjHzEyMyrdpQBHjwLDPbCKU6x586/8/HghYZbV
        1K+5MuKLMOqdXYA5RWkAZX9uNS9H3ezXsfGKxp9rlHOtCVThqU8cxkONiPyfaxMIgR44Chlj+r84m
        DWQq/RNvMXbiIAmmVbMGXcliWkdMFtCbfYtAjTSk5Chm5wdJsOJCDAw5zIyHHmBA6ABpge8ABTGwz
        SzeY0qyagEAX9P7ZnX9Obv4UmvClfLZri661mOl4ub8tHPg/JM0FECGw7Kt8+yvTFLyPWTZmAPDrW
        19yj0WuA==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73FU-0001Ma-Sx; Wed, 26 Feb 2020 20:25:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/32] xfs: remove XFS_DA_OP_INCOMPLETE
Date:   Wed, 26 Feb 2020 12:23:02 -0800
Message-Id: <20200226202306.871241-29-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that we use the on-disk flags field also for the interface to the
lower level attr routines we can use the XFS_ATTR_INCOMPLETE definition
from the on-disk format directly instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
 fs/xfs/libxfs/xfs_da_btree.h  |  6 ++----
 fs/xfs/xfs_trace.h            |  3 ++-
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index dab1921dcfc6..e4fe3dca9883 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -898,7 +898,7 @@ xfs_attr_node_addname(
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->op_flags |= XFS_DA_OP_INCOMPLETE;
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5f3702172e96..4be04aeee278 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -456,7 +456,12 @@ xfs_attr_match(
 		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
-	if (args->attr_filter != (flags & XFS_ATTR_NSP_ONDISK_MASK))
+	/*
+	 * If we are looking for incomplete entries, show only those, else only
+	 * show complete entries.
+	 */
+	if (args->attr_filter !=
+	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
 		return false;
 	return true;
 }
@@ -2387,14 +2392,6 @@ xfs_attr3_leaf_lookup_int(
 /*
  * GROT: Add code to remove incomplete entries.
  */
-		/*
-		 * If we are looking for INCOMPLETE entries, show only those.
-		 * If we are looking for complete entries, show only those.
-		 */
-		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
-		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
-			continue;
-		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
 			if (!xfs_attr_match(args, name_loc->namelen,
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index f3660ae9eb3e..53e503b6f186 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -59,7 +59,7 @@ typedef struct xfs_da_args {
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
-	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
+	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
@@ -90,7 +90,6 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 #define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
-#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -98,8 +97,7 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
+	{ XFS_DA_OP_NOTIME,	"NOTIME" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 51dbc336f93b..4a69bffed706 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -38,7 +38,8 @@ struct xfs_inobt_rec_incore;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
-	{ XFS_ATTR_SECURE,	"SECURE" }
+	{ XFS_ATTR_SECURE,	"SECURE" }, \
+	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
-- 
2.24.1


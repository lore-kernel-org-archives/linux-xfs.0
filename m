Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56609C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376A1208E4
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GIvw79N7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgEGMTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B29C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bnY02lXFtCiwQDlDg4izRGHcHv3SmeREpratD5L2WBI=; b=GIvw79N7Vh/lQPq+8dyl/doclu
        tLiPTpZT8PTyIqoJBfzSli7RMgYSsq6eRF5J6KxVIgfX8aXnURJCplZJfNXrq/fbOoRLBrgOdZSeX
        8ZfBXEXHruz7bbRTepna0FfLcUDAM8XRXI+9UykezgWSV5xiskLMDl5+8Ur+CxdxfOVxnRi7HU3et
        TyF53zzHus3jT3/PJ0Vl89qofOrBIFn0akWqCyJntp4+A83c230VOMT5IaFycZCsv/GiG+ijnBvp7
        AP27NfpWSWVosbgxn0w430dHlYhTdBb61gjRZRoqlXqIJ23sF/4e6OExxGimjxq7vmQFDT3MdWf2F
        bjo9SNVQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVL-0005Da-3d; Thu, 07 May 2020 12:19:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 25/58] xfs: remove XFS_DA_OP_INCOMPLETE
Date:   Thu,  7 May 2020 14:18:18 +0200
Message-Id: <20200507121851.304002-26-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 254f800f810415cce05872c88e9ef797d81f4375

Now that we use the on-disk flags field also for the interface to the
lower level attr routines we can use the XFS_ATTR_INCOMPLETE definition
from the on-disk format directly instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c      |  2 +-
 libxfs/xfs_attr_leaf.c | 15 ++++++---------
 libxfs/xfs_da_btree.h  |  6 ++----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 36818814..469d6804 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -898,7 +898,7 @@ restart:
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->op_flags |= XFS_DA_OP_INCOMPLETE;
+		args->attr_filter |= XFS_ATTR_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index d560f94e..edd01eef 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -453,7 +453,12 @@ xfs_attr_match(
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
@@ -2384,14 +2389,6 @@ xfs_attr3_leaf_lookup_int(
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
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index f3660ae9..53e503b6 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
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
-- 
2.26.2


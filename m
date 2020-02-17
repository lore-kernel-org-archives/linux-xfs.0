Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA3FC33FA0
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90EB9207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BrkOFNUw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgBQNB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:01:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQNB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:01:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wXXm8FiBds8E1QqO0oBzDUAKGA2FrRfplYX4alvI9ZM=; b=BrkOFNUwCfqC+YURVtu5O84vmV
        f/MV3H613eSHwFvq2Ep9t2I4cRJQAoa7pstJDNwUmKs2OePU1LFAE5aVFrp3V4Z8o7DDM5mv7CEV/
        gAM0oF0ESK9FZKrDbb0B3t3/9WQZeyZO7le/UkEkrbs5X5xaBw5QXilbgMo2v27qpjNgDm4KOo2MT
        xXcKEtZ3/F00Lbv+nxnt+z5SWUfYmgek1Wt1iXPuirnpCYen3NrI2Kqq64B0288qUjIg9u16CBF4g
        DaFpJxo0cHZhVg674GYMcHVZaJ3PiXgdW3EnY3vYEw+24kUihHa0PRn56wDzibAEERzL8VMFHNfU6
        EhS7tEmg==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g1e-00021d-TH; Mon, 17 Feb 2020 13:01:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 30/31] xfs: remove XFS_DA_OP_INCOMPLETE
Date:   Mon, 17 Feb 2020 13:59:56 +0100
Message-Id: <20200217125957.263434-31-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
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
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
 fs/xfs/libxfs/xfs_types.h     |  6 ++----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d5c112b6dcdd..23e0d8ce39f8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -898,7 +898,7 @@ xfs_attr_node_addname(
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->op_flags |= XFS_DA_OP_INCOMPLETE;
+		args->attr_namespace |= XFS_ATTR_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 9081ba7af90a..fae322105457 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -456,7 +456,12 @@ xfs_attr_match(
 		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
-	if (args->attr_namespace != (flags & XFS_ATTR_NSP_ONDISK_MASK))
+	/*
+	 * If we are looking for incomplete entries, show only those, else only
+	 * show complete entries.
+	 */
+	if (args->attr_namespace !=
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 2b02f854ebaf..a2005e2d3baa 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -194,7 +194,7 @@ typedef struct xfs_da_args {
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
-	unsigned int	attr_namespace;	/* XFS_ATTR_{ROOT,SECURE} */
+	unsigned int	attr_namespace;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
@@ -225,7 +225,6 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 #define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
-#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -233,8 +232,7 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
+	{ XFS_DA_OP_NOTIME,	"NOTIME" }
 
 /*
  * Type verifier functions
-- 
2.24.1


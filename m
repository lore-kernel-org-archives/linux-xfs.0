Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB5CC2D0C8
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43E4E2077B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WgxD5Gdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfLLKzv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:55:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728722AbfLLKzv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Gi6DvFc7lcMXTvDbCh/HvqDl5Q655S0LI30cnWUef/g=; b=WgxD5GddGmwQIrEAkNcbKEUZzP
        ha+sPFRahLOX8eULClJcl1/Oxo1w6Qmd/UfNPxRQe8sOC53CwixGyMrOy4IRx4S/3pBivjKk4z4oH
        fprZt3LtZGJ08Qz0oI5HJ7oNzEHU4UIYRPQgBpyadGWcALjSE2Ltsem3ZAM1kLhbUjTtacgObbjCh
        LDUgK4JbZ7pooEQgHZ6N8JYg4jjN7wOf9oUg0fjyPIB4OU6ENNbwHp+VRocTMqsE74pG+Xx7EK817
        TLpxz5J9NBBMdtGjYywScsfbW2OEcme/Qk2gIasXFJueaTbR8fIAzqymyyTn8O4UUbXeFju9IUeGa
        ivNpbv7g==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM8N-0002ZY-8d; Thu, 12 Dec 2019 10:55:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 32/33] xfs: remove XFS_DA_OP_INCOMPLETE
Date:   Thu, 12 Dec 2019 11:54:32 +0100
Message-Id: <20191212105433.1692-33-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
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
---
 fs/xfs/libxfs/xfs_attr.c      |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c | 15 ++++++---------
 fs/xfs/libxfs/xfs_types.h     |  4 +---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2b9c0aa5af4a..20f791ea0aa3 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -894,7 +894,7 @@ xfs_attr_node_addname(
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
index 1bf84488d34c..1aec335dac92 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
2.20.1


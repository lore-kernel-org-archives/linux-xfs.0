Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F125AC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjEZCa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFC6B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6083564C4C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E3AC433D2;
        Fri, 26 May 2023 02:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068225;
        bh=ddPS84dK9WlfL8XfGcnZWQqW2mKRZ+CUzB8h34M1giE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h7OJhdrHLGfUlQOH/VYEbid7guIEMhE5WToxZkiqOmAVFmXfY22VXwcZyvbyHIv6B
         cfUxGOPKkh51t52CjgfwxqMZ0SuUfy7Ob0JZfZA3qn6Lyr53daEHZuvHelyjPyUSOK
         JXouCZy6+SMkFjEkkRWl4tPZqX8YfWFejXhP0oeWO5kSsRWuXxkyZ9Q6mCkt9xmkZc
         Crk2MVO4Azjih/kDrCv9PRQ7ZIj7CvQRvU5fxsgOuxTcDQF/jTAzG9npo1IujLWf58
         EbODJgCkCsjtwFVD8blUIX2qUVUqW1p0Vpn6LEE0dQXX/FJQni0nmadhkqHjONcUTb
         +1oN72CsscCjQ==
Date:   Thu, 25 May 2023 19:30:25 -0700
Subject: [PATCH 03/14] xfs: add raw parent pointer apis to support repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078636.3750196.6254103540594410626.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a couple of utility functions to set or remove parent pointers from
a file.  These functions will be used by repair code, hence they skip
the xattr logging that regular parent pointer updates use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c   |    2 +-
 libxfs/xfs_dir2.h   |    2 +-
 libxfs/xfs_parent.c |   37 +++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |    8 ++++++++
 4 files changed, 47 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 79b6ec893fd..b906f39e0fe 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -439,7 +439,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index f99788a1f3e..ca1949ed4f5 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -55,7 +55,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index fcf05dc5ed4..0e07fb4c176 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -365,3 +365,40 @@ xfs_parent_lookup(
 
 	return xfs_attr_get_ilocked(&scr->args);
 }
+
+/*
+ * Attach the parent pointer (@pptr -> @name) to @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  The update will not use logged
+ * xattrs.  This is for specialized repair functions only.  The scratchpad need
+ * not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+
+	return xfs_attr_set(&scr->args);
+}
+
+/*
+ * Remove the parent pointer (@rec -> @name) from @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  The update will not use logged
+ * xattrs.  This is for specialized repair functions only.  The scratchpad need
+ * not be initialized.
+ */
+int
+xfs_parent_unset(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_REMOVE;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 25bbb62fce5..f1ec9cce859 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -108,4 +108,12 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
+int xfs_parent_set(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
+int xfs_parent_unset(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *rec,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */


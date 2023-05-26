Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F59C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjEZCPz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjEZCPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:15:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F170513A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D3DE614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBADC433D2;
        Fri, 26 May 2023 02:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067353;
        bh=ORD4utI2Hb5GAtFW2uS2URZTBJTR2Dr9KmT1fC2lGPw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ai4HvoHg6FMxpIlgZT/tgVYFWvLEPnLQ8PR3PrKlJDgwJPpu/YIjSq8qrPFBdKdTB
         n4IAGscmuMkHivuDTFoXGgy5/Rm4yK0zRhmkRByiqv5+1JHji7gi2hmuQAaAbiF9fg
         itxvBnxUb9GPX1c230j2GNBzbBnrbGKUPmfZmlaRz6rHY6Kig0JpJQ82ro9Nyi8aW4
         fHIq6879CqHgUk+zJdM0BkdEbYVSe1sauFzDM+bJtaUOkWVRKDeF4+AsNsYBkJ5OMg
         /m74cRkukApPAkQQtqqg+UmokGJs5wenUvUjMkodaNlAZpahq3ImETMdoIEUueEk7L
         SomlwdV1FVksw==
Date:   Thu, 25 May 2023 19:15:52 -0700
Subject: [PATCH 05/17] xfs: add raw parent pointer apis to support repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073367.3745075.5122726017349785801.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_dir2.c   |    2 +-
 fs/xfs/libxfs/xfs_dir2.h   |    2 +-
 fs/xfs/libxfs/xfs_parent.c |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    8 ++++++++
 4 files changed, 47 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 51eed639f2df..525b23a3800b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -440,7 +440,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f99788a1f3e6..ca1949ed4f5e 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -55,7 +55,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index a0ffff5db76d..27685ce65a16 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -364,3 +364,40 @@ xfs_parent_lookup(
 
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 25bbb62fce5f..f1ec9cce859e 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
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


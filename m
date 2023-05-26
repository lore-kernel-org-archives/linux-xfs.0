Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2D5C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjEZBjb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE840E2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 689EE64C02
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE00C433EF;
        Fri, 26 May 2023 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065167;
        bh=J8KnBdrsavArxaeionVXV9A5oiD78vFyi9JJgt20AqY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HKxI8eJUf8znb6nG5hGjVba89358KOuVyB4+eFRPXL458bQbytKqgjJDmHIzqGurM
         I0jQgZnSBHvgTjoGCotKUkoHcDmPeuMqwX6j+NNtt6sNuteom9YCco6he2+Nw3DCw/
         i2iYIbNL0G/s/YNeet1v/X7eidBaqaPPDYsd9RvNb/5tKjYTj53c81bqmqr9eqLg/z
         c2LT4q8f7H3ubYCtH5mOfwPYq0tz6vRdelr4eFFcQryZNfuWIIqAo+PinXqAT7R0vh
         OLUHTT24TDYV4ND0JVwlzySYtTmpBIZwh3ETaTqqyloKnpAY9JUHbJ8egZTLJJWwWa
         OmpO5+KhiGeDg==
Date:   Thu, 25 May 2023 18:39:27 -0700
Subject: [PATCH 3/3] xfs: pin inodes that would otherwise overflow link count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069414.3738323.13467840103073038229.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
References: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The VFS inc_nlink function does not explicitly check for integer
overflows in the i_nlink field.  Instead, it checks the link count
against s_max_links in the vfs_{link,create,rename} functions.  XFS
sets the maximum link count to 2.1 billion, so integer overflows should
not be a problem.

However.  It's possible that online repair could find that a file has
more than four billion links, particularly if the link count got
corrupted while creating hardlinks to the file.  The di_nlinkv2 field is
not large enough to store a value larger than 2^32, so we ought to
define a magic pin value of ~0U which means that the inode never gets
deleted.  This will prevent a UAF error if the repair finds this
situation and users begin deleting links to the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    6 ++++++
 fs/xfs/scrub/nlinks.c      |    8 ++++----
 fs/xfs/scrub/repair.c      |   12 ++++++------
 fs/xfs/xfs_inode.c         |   16 ++++++++++++----
 4 files changed, 28 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0c457905cce5..977d30519738 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -891,6 +891,12 @@ static inline uint xfs_dinode_size(int version)
  */
 #define	XFS_MAXLINK		((1U << 31) - 1U)
 
+/*
+ * Any file that hits the maximum ondisk link count should be pinned to avoid
+ * a use-after-free situation.
+ */
+#define XFS_NLINK_PINNED	(~0U)
+
 /*
  * Values for di_format
  *
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 67e2c167fc36..0507b80458d1 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -93,8 +93,8 @@ xchk_setup_nlinks(
 
 /*
  * Add a delta to an nlink counter, being careful about integer overflow.
- * Clamp the value to U32_MAX because the ondisk format does not handle
- * link counts any higher.
+ * Clamp the value to XFS_NLINK_PINNED because the ondisk format does not
+ * handle link counts any higher.
  */
 static inline void
 careful_add(
@@ -103,7 +103,7 @@ careful_add(
 {
 	uint64_t	new_value = (uint64_t)(*nlinkp) + delta;
 
-	*nlinkp = min_t(uint64_t, new_value, U32_MAX);
+	*nlinkp = min_t(uint64_t, new_value, XFS_NLINK_PINNED);
 }
 
 /* Update incore link count information.  Caller must hold the nlinks lock. */
@@ -602,7 +602,7 @@ xchk_nlinks_compare_inode(
 	 * this.  The VFS won't let users increase the link count, but it will
 	 * let them decrease it.
 	 */
-	if (total_links > U32_MAX)
+	if (total_links > XFS_NLINK_PINNED)
 		xchk_ino_set_corrupt(sc, ip->i_ino);
 	else if (total_links > XFS_MAXLINK)
 		xchk_ino_set_warning(sc, ip->i_ino);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f42ce1995caa..042bd32f5799 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1163,15 +1163,15 @@ xrep_set_nlink(
 {
 	bool			ret = false;
 
-	if (nlink > U32_MAX) {
+	if (nlink > XFS_NLINK_PINNED) {
 		/*
 		 * The observed link count will overflow the nlink field.
 		 *
 		 * The VFS won't let users create more hardlinks if the link
 		 * count is larger than XFS_MAXLINK, but it will let them
-		 * delete hardlinks.  XFS_MAXLINK is half of U32_MAX, which
-		 * means that sysadmins could actually fix this situation by
-		 * deleting links and calling us again.
+		 * delete hardlinks.  XFS_MAXLINK is half of XFS_NLINK_PINNED,
+		 * which means that sysadmins could actually fix this situation
+		 * by deleting links and calling us again.
 		 *
 		 * Set the link count to the largest possible value that will
 		 * fit in the field.  This will buy us the most possible time
@@ -1179,9 +1179,9 @@ xrep_set_nlink(
 		 * As long as the link count stays above MAXLINK the undercount
 		 * problem will not get worse.
 		 */
-		BUILD_BUG_ON((uint64_t)XFS_MAXLINK >= U32_MAX);
+		BUILD_BUG_ON((uint64_t)XFS_MAXLINK >= XFS_NLINK_PINNED);
 
-		nlink = U32_MAX;
+		nlink = XFS_NLINK_PINNED;
 		ret = true;
 	}
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f7dfd8e50583..2edc52e747f2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -911,12 +911,16 @@ xfs_init_new_inode(
  */
 static int			/* error */
 xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
+	struct inode		*inode = VFS_I(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	drop_nlink(VFS_I(ip));
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		drop_nlink(VFS_I(ip));
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (VFS_I(ip)->i_nlink)
@@ -933,9 +937,13 @@ xfs_bumplink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
 {
+	struct inode		*inode = VFS_I(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	inc_nlink(VFS_I(ip));
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		inc_nlink(VFS_I(ip));
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 


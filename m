Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01872C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbjEZCFR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbjEZCFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C876D199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E4B64C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E0EC433EF;
        Fri, 26 May 2023 02:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066713;
        bh=bFOkAqBhfuJHtMiq74s/uvajBRIG3Aemw7a+nJ6KUak=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ibL9RPiw/CNw2eak3rl+7oUDpzF7VyGO+a4KjzaSM27JT1aDJIm4eHL5U9Zquhws0
         ES4f5ukXtxM7jC1GNsdYZGOXIuzq1L92hb9DYQrCcLXa7VIZoBEKFBEtYE/upqpFMM
         R+VVlTgyE3lCAAaF8TQ2TDFQng07dqje4jZ6MI9LiwCuiqPbpYr376nzzh+DNB8WJE
         3VsHW/Gq+Hs4eLlMOXJx4VuYSgud+0YLiEuHU1Gm5hls/L611kqrE1yJWCspZSOlWP
         q0QrOSsHPfJ6KfcrxwULA+zP0gd3J/ByC+QmAFjvL5nH8/CHevPk+DKz8kXUkBmIck
         4nIdKLVqQoNFA==
Date:   Thu, 25 May 2023 19:05:13 -0700
Subject: [PATCH 1/7] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506071777.3743141.13374658160925475322.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
References: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
[djwong: have one sorting function]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |    6 +++++-
 fs/xfs/libxfs/xfs_defer.h |    8 +++++++-
 fs/xfs/xfs_inode.c        |   27 ++++++++++++++++++---------
 fs/xfs/xfs_inode.h        |    2 ++
 4 files changed, 32 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 1619b9b928db..63cd15460277 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -830,7 +830,11 @@ xfs_defer_ops_continue(
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		xfs_sort_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos);
+		xfs_lock_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos,
+				XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index bcc48b0c75c9..91c9568575d7 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -71,7 +71,13 @@ extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2edc52e747f2..51abe06cdb31 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -440,7 +440,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
@@ -2705,7 +2705,7 @@ xfs_sort_for_rename(
 	struct xfs_inode	**i_tab,/* out: sorted array of inodes */
 	int			*num_inodes)  /* in/out: inodes in array */
 {
-	int			i, j;
+	int			i;
 
 	ASSERT(*num_inodes == __XFS_SORT_INODES);
 	memset(i_tab, 0, *num_inodes * sizeof(struct xfs_inode *));
@@ -2727,17 +2727,26 @@ xfs_sort_for_rename(
 		i_tab[i++] = wip;
 	*num_inodes = i;
 
+	xfs_sort_inodes(i_tab, *num_inodes);
+}
+
+void
+xfs_sort_inodes(
+	struct xfs_inode	**i_tab,
+	unsigned int		num_inodes)
+{
+	int			i, j;
+
+	ASSERT(num_inodes <= __XFS_SORT_INODES);
+
 	/*
 	 * Sort the elements via bubble sort.  (Remember, there are at
 	 * most 5 elements to sort, so this is adequate.)
 	 */
-	for (i = 0; i < *num_inodes; i++) {
-		for (j = 1; j < *num_inodes; j++) {
-			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino) {
-				struct xfs_inode *temp = i_tab[j];
-				i_tab[j] = i_tab[j-1];
-				i_tab[j-1] = temp;
-			}
+	for (i = 0; i < num_inodes; i++) {
+		for (j = 1; j < num_inodes; j++) {
+			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino)
+				swap(i_tab[j], i_tab[j - 1]);
 		}
 	}
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d870f9beb348..7e719c4affcf 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -603,6 +603,8 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
+void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);
 
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);


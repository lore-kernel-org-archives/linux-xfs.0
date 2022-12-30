Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B48C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiLaBwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiLaBwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:52:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB421DDD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:52:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA2AFB81E05
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0B3C433EF;
        Sat, 31 Dec 2022 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451562;
        bh=ojYa1ZradX95inJnXd8+IGxpgULiz00lhpdFfSAPcC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U1FFAZyQigcyqZDYa3vSs7KLjAgI+rMV1KUEUkiOiYVmhvkFGIps4bJzr+fiM8Nev
         fDZLEEsoXygVQ8dt6Gh2eD2eoqJF6usK7yUH73Qli+8VJSZUoOmAzpCM0DdVbSpBfE
         OWldGtGNBRM85sifKn3iRrhRu16Cy9gzu/njJ/WuYzX6u9JCpBGgPEF9ue8C5ereWE
         AlLeADZ3H9hAJ69bvOttLsilJLdoqx73hB8Egm/BNfLa21ERKuDTF6LswVSeuMB/iu
         n1NC6bIT60u7pGvYJh13vDvIWsHEYRYantWCCB/GxXWcPLctu3y2JrKscjyuV/OYXv
         ErlxbFvumSPHQ==
Subject: [PATCH 18/42] xfs: refactor reflink quota updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871153.717073.17408045000888577090.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hoist all quota updates for reflink into a helper function, since things
are about to become more complicated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1a8a254c81f4..455adcce994d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -750,6 +750,35 @@ xfs_reflink_cancel_cow_range(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+/*
+ * Update quota accounting for a remapping operation.  When we're remapping
+ * something from the CoW fork to the data fork, we must update the quota
+ * accounting for delayed allocations.  For remapping from the data fork to the
+ * data fork, use regular block accounting.
+ */
+static inline void
+xfs_reflink_update_quota(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	bool			is_cow,
+	int64_t			blocks)
+{
+	unsigned int		qflag;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		qflag = is_cow ? XFS_TRANS_DQ_DELRTBCOUNT :
+				 XFS_TRANS_DQ_RTBCOUNT;
+	} else {
+		qflag = is_cow ? XFS_TRANS_DQ_DELBCOUNT :
+				 XFS_TRANS_DQ_BCOUNT;
+	}
+	xfs_trans_mod_dquot_byino(tp, ip, qflag, blocks);
+}
+#else
+# define xfs_reflink_update_quota(tp, ip, is_cow, blocks)	((void)0)
+#endif
+
 /*
  * Remap part of the CoW fork into the data fork.
  *
@@ -852,8 +881,7 @@ xfs_reflink_end_cow_extent(
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
 		xfs_refcount_decrease_extent(tp, isrt, &data);
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				-data.br_blockcount);
+		xfs_reflink_update_quota(tp, ip, false, -data.br_blockcount);
 	} else if (data.br_startblock == DELAYSTARTBLOCK) {
 		int		done;
 
@@ -878,8 +906,7 @@ xfs_reflink_end_cow_extent(
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
-	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
-			(long)del.br_blockcount);
+	xfs_reflink_update_quota(tp, ip, true, del.br_blockcount);
 
 	/* Remove the mapping from the CoW fork. */
 	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
@@ -1369,7 +1396,7 @@ xfs_reflink_remap_extent(
 		qdelta += dmap->br_blockcount;
 	}
 
-	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
+	xfs_reflink_update_quota(tp, ip, false, qdelta);
 
 	/* Update dest isize if needed. */
 	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);


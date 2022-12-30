Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDEDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiLaBmz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:42:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8791E13E96
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:42:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A0EAB81DD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00EBC433D2;
        Sat, 31 Dec 2022 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450971;
        bh=xLECfKQGAwCkmJsBlQnvzeWitnN0Zg3Tzud6Rdb/gso=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jsY/41xJkIBeBTNtFCpdKi2tpG8eGgjuZ0lYLdqRXGAYgsPetLDi37zz6CwwJUT8H
         OtouXNqHO8uCryjA/z+9Rgk3HA0/KBQSLsrulKzN4OY+OM0R2T0P7CBjOxWIvjbBa8
         H2voy5iHHnbr2ftGQS9IGOJPc+d/6pUCr8scppaBZsC+DGvTssGteN8hzkHFE5WRwM
         RxLpdMKir5CvbRuBE405QB44LWxk2yIcWE38p7uOYVb5Rc3kOrSpW9hRssguDCi/i/
         UxwP/6algs3frTvuTVKCUd55HI5boFTW4PWokToZv4BBoTsdnyJVTn4wxm+BJ/Wh5E
         DU1SKYxQ00msw==
Subject: [PATCH 23/38] xfs: add realtime rmap btree when adding rt volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:19 -0800
Message-ID: <167243869928.715303.4697254359584699445.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're adding enough space to the realtime section to require the
creation of new realtime groups, create the rt rmap btree inode before
we start adding the space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |  100 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7b7e22b36d48..45c388ad4c1f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -28,6 +28,8 @@
 #include "xfs_rtgroup.h"
 #include "xfs_quota.h"
 #include "xfs_error.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
 
 /*
@@ -1049,6 +1051,87 @@ xfs_growfs_rt_init_primary(
 	return 0;
 }
 
+/* Add a metadata inode for a realtime rmap btree. */
+static int
+xfs_growfsrt_create_rtrmap(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_update	upd;
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= 0,
+		.rm_blockcount	= mp->m_sb.sb_rextsize,
+		.rm_owner	= XFS_RMAP_OWN_FS,
+		.rm_offset	= 0,
+		.rm_flags	= 0,
+	};
+	struct xfs_btree_cur	*cur;
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_rtrmapbt(mp) || rtg->rtg_rmapip)
+		return 0;
+
+	error = xfs_rtrmapbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		return error;
+
+	error = xfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		goto out_path;
+
+	error = xfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		goto out_path;
+
+	error = xfs_qm_dqattach(upd.dp);
+	if (error)
+		goto out_upd;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			xfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		goto out_end;
+
+	error = xfs_rtrmapbt_create(&tp, path, &upd, &ip);
+	if (error)
+		goto out_cancel;
+
+	lockdep_set_class(&ip->i_lock.mr_lock, &xfs_rrmapip_key);
+
+	cur = xfs_rtrmapbt_init_cursor(mp, tp, rtg, ip);
+	error = xfs_rmap_map_raw(cur, &rmap);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_end;
+
+	xfs_imeta_end_update(mp, &upd, error);
+	xfs_imeta_free_path(path);
+	xfs_finish_inode_setup(ip);
+	rtg->rtg_rmapip = ip;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_end:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (ip) {
+		xfs_finish_inode_setup(ip);
+		xfs_irele(ip);
+	}
+out_upd:
+	xfs_imeta_end_update(mp, &upd, error);
+out_path:
+	xfs_imeta_free_path(path);
+	return error;
+}
+
 /*
  * Check that changes to the realtime geometry won't affect the minimum
  * log size, which would cause the fs to become unusable.
@@ -1155,7 +1238,9 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
+	if (!xfs_has_rtgroups(mp) && xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
+	if (xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
@@ -1278,10 +1363,21 @@ xfs_growfs_rt(
 				nsbp->sb_rbmblocks);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
 
-		if (xfs_has_rtgroups(mp))
+		if (xfs_has_rtgroups(mp)) {
+			xfs_rgnumber_t	rgno = last_rgno;
+
 			nsbp->sb_rgcount = howmany_64(nsbp->sb_rblocks,
 						      nsbp->sb_rgblocks);
 
+			for_each_rtgroup_range(mp, rgno, nsbp->sb_rgcount, rtg) {
+				error = xfs_growfsrt_create_rtrmap(rtg);
+				if (error) {
+					xfs_rtgroup_put(rtg);
+					break;
+				}
+			}
+		}
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */


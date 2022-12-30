Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ACAC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiLaBzR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiLaBzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:55:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEDE1DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5E92B81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AAFC433D2;
        Sat, 31 Dec 2022 01:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451702;
        bh=QQamTzppxlCOWg3ZBDU8rMfJrtsB47pcOFWzLb6tW1o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fNkkegF/BbuHSI5O3O3IHnKu7uZxd7SDplIL9Jex3voKL0IuKe46XkwcsNXfCSlO8
         jB1fKWW96tEyqwDRnbLtg3Iz7HfGzhShd+OUqI7M60MBM1rqbjcWYoOciDVKG+gt3T
         iDGAHG9AxERaHmk5P0A5s3Bgj1UigOLQsCPdgwHi6sCXKMAnUCDxYcM3j5hXSLsOAD
         qbURVYavvwqWXsnE949X954wu+8ymrzXxYPGYI6QdyeUuIwEMZNnUpfc86AmTGMuSa
         uV2SQe9puKrCUj99KxmD0GuPkFioKDLLF5ObDit1bf9Zrnq1q3P9HB/L5cyWI7nagT
         SdtEOuBZE0NDg==
Subject: [PATCH 27/42] xfs: add realtime refcount btree when adding rt volume
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871279.717073.11606527521201327303.stgit@magnolia>
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

If we're adding enough space to the realtime section to require the
creation of new realtime groups, create the rt refcount btree inode
before we start adding the space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7f1ee9432e71..8929c4fffb53 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1134,6 +1134,73 @@ xfs_growfsrt_create_rtrmap(
 	return error;
 }
 
+/* Add a metadata inode for a realtime refcount btree. */
+static int
+xfs_growfsrt_create_rtrefcount(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_update	upd;
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_rtreflink(mp) || rtg->rtg_refcountip)
+		return 0;
+
+	error = xfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
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
+	error = xfs_rtrefcountbt_create(&tp, path, &upd, &ip);
+	if (error)
+		goto out_cancel;
+
+	lockdep_set_class(&ip->i_lock.mr_lock, &xfs_rrefcountip_key);
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_end;
+
+	xfs_imeta_end_update(mp, &upd, error);
+	xfs_imeta_free_path(path);
+	xfs_finish_inode_setup(ip);
+	rtg->rtg_refcountip = ip;
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
@@ -1241,9 +1308,11 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (!xfs_has_rtgroups(mp) && xfs_has_rmapbt(mp))
+	if (!xfs_has_rtgroups(mp) && (xfs_has_rmapbt(mp) || xfs_has_reflink(mp)))
 		return -EOPNOTSUPP;
-	if (xfs_has_reflink(mp) || xfs_has_quota(mp))
+	if (xfs_has_quota(mp))
+		return -EOPNOTSUPP;
+	if (xfs_has_reflink(mp) && in->extsize != 1)
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
@@ -1378,6 +1447,12 @@ xfs_growfs_rt(
 					xfs_rtgroup_put(rtg);
 					break;
 				}
+
+				error = xfs_growfsrt_create_rtrefcount(rtg);
+				if (error) {
+					xfs_rtgroup_put(rtg);
+					break;
+				}
 			}
 		}
 


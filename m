Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F74C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiLaDFF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:04:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C647D17410
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:04:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 749D9B81E5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3200CC433D2;
        Sat, 31 Dec 2022 03:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455888;
        bh=oIxP1rbWtl1dHC+1MVO6z6S5PxuL7q1l6byK7MPSyfE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t0t3Z9fpAkVy2tzow3KfpkOrfw0Gs8d8UJfofUx7gOeTXTtEqi+IQXV1gh6hkwEck
         ORJZPj/hRm2Awg7bdz4HUu88Hzljjz7jJ1ulERVvzxUIH9DqFUb5/iF3GzuETYnSeX
         T2oKe6dI4uClAuIIno5edPIHC+OnVvck+qTmveJ/OToeTG/8Fzy1e0CBIbf+mOfgiN
         k1RBKWUXTEgW8VOQ8B86i0s0wkSgQjZKx9rta7sKmGiZRV6OlQNj7DhBapbHfcRWU4
         dYFDsQ8k1RbVgWEYjdDFH4tXhQ7u3WNdsZk08TZ+Y4Q+rRPHidFOAZ8/OnxT/M1/J6
         UO7RFZ+nDgpkA==
Subject: [PATCH 41/41] mkfs: enable reflink on the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:13 -0800
Message-ID: <167243881313.734096.6333629617730277324.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow the creation of filesystems with both reflink and realtime volumes
enabled.  For now we don't support a realtime extent size > 1.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c   |    4 ++--
 mkfs/proto.c    |   44 +++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 100 insertions(+), 7 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 40ebbbce39d..a4023f78655 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -448,9 +448,9 @@ rtmount_init(
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	if (xfs_has_reflink(mp)) {
+	if (xfs_has_reflink(mp) && mp->m_sb.sb_rextsize > 1) {
 		fprintf(stderr,
-	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
+	_("%s: Reflink not compatible with realtime extent size > 1. Please try a newer xfsprogs.\n"),
 				progname);
 		return -1;
 	}
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 96eab25da45..c98568ca507 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -851,6 +851,48 @@ rtrmapbt_create(
 	libxfs_imeta_free_path(path);
 }
 
+/* Create the realtime refcount btree inode. */
+static void
+rtrefcountbt_create(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+	struct xfs_imeta_update	upd;
+	struct xfs_imeta_path	*path;
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = -libxfs_rtrefcountbt_create_path(mp, rtg->rtg_rgno, &path);
+	if (error)
+		fail( _("rtrefcount inode path creation failed"), error);
+
+	error = -libxfs_imeta_ensure_dirpath(mp, path);
+	if (error)
+		fail(_("rtgroup allocation failed"),
+				error);
+
+	error = -libxfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_rtrefcountbt_create(&tp, path, &upd,
+			&rtg->rtg_refcountip);
+	if (error)
+		fail(_("rtrefcount inode creation failed"), error);
+
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("rtrefcountbt commit failed"), error);
+
+	libxfs_imeta_end_update(mp, &upd, 0);
+	libxfs_imeta_free_path(path);
+}
+
 /* Initialize block headers of rt free space files. */
 static int
 init_rtblock_headers(
@@ -1033,6 +1075,8 @@ rtinit(
 	for_each_rtgroup(mp, rgno, rtg) {
 		if (xfs_has_rtrmapbt(mp))
 			rtrmapbt_create(rtg);
+		if (xfs_has_rtreflink(mp))
+			rtrefcountbt_create(rtg);
 	}
 
 	if (mp->m_sb.sb_rbmblocks) {
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dcce3d0136e..e406fa6a5ea 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2385,12 +2385,36 @@ _("inode btree counters not supported without finobt support\n"));
 	}
 
 	if (cli->xi->rtname) {
-		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
-			fprintf(stderr,
-_("reflink not supported with realtime devices\n"));
-			usage();
+		if (cli->rtextsize && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with rt extent size specified\n"));
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
+		if (cli->blocksize < XFS_MIN_RTEXTSIZE && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices with blocksize %d < %d\n"),
+						cli->blocksize,
+						XFS_MIN_RTEXTSIZE);
+				usage();
+			}
+			cli->sb_feat.reflink = false;
+		}
+		if (!cli->sb_feat.rtgroups && cli->sb_feat.reflink) {
+			if (cli_opt_set(&mopts, M_REFLINK) &&
+			    cli_opt_set(&ropts, R_RTGROUPS)) {
+				fprintf(stderr,
+_("reflink not supported on realtime devices without rtgroups feature\n"));
+				usage();
+			} else if (cli_opt_set(&mopts, M_REFLINK)) {
+				cli->sb_feat.rtgroups = true;
+			} else {
+				cli->sb_feat.reflink = false;
+			}
 		}
-		cli->sb_feat.reflink = false;
 
 		if (!cli->sb_feat.rtgroups && cli->sb_feat.rmapbt) {
 			if (cli_opt_set(&mopts, M_RMAPBT) &&
@@ -2558,6 +2582,19 @@ validate_rtextsize(
 			usage();
 		}
 		cfg->rtextblocks = (xfs_extlen_t)(rtextbytes >> cfg->blocklog);
+	} else if (cli->sb_feat.reflink && cli->xi->rtname) {
+		/*
+		 * reflink doesn't support rt extent size > 1FSB yet, so set
+		 * an extent size of 1FSB.  Make sure we still satisfy the
+		 * minimum rt extent size.
+		 */
+		if (cfg->blocksize < XFS_MIN_RTEXTSIZE) {
+			fprintf(stderr,
+		_("reflink not supported on rt volume with blocksize %d\n"),
+				cfg->blocksize);
+			usage();
+		}
+		cfg->rtextblocks = 1;
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2589,6 +2626,12 @@ validate_rtextsize(
 		}
 	}
 	ASSERT(cfg->rtextblocks);
+
+	if (cli->sb_feat.reflink && cfg->rtblocks > 0 && cfg->rtextblocks > 1) {
+		fprintf(stderr,
+_("reflink not supported on realtime with extent sizes > 1\n"));
+		usage();
+	}
 }
 
 /* Validate the incoming extsize hint. */
@@ -4583,10 +4626,16 @@ check_rt_meta_prealloc(
 		error = -libxfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
 		if (error)
 			prealloc_fail(mp, error, ask, _("realtime rmap btree"));
+
+		ask = libxfs_rtrefcountbt_calc_reserves(mp);
+		error = -libxfs_imeta_resv_init_inode(rtg->rtg_refcountip, ask);
+		if (error)
+			prealloc_fail(mp, error, ask, _("realtime refcount btree"));
 	}
 
 	/* Unreserve the realtime metadata reservations. */
 	for_each_rtgroup(mp, rgno, rtg) {
+		libxfs_imeta_resv_free_inode(rtg->rtg_refcountip);
 		libxfs_imeta_resv_free_inode(rtg->rtg_rmapip);
 	}
 


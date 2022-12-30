Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE84C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiLaCK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:10:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B30F78
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D24E6B81E07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEE9C433EF;
        Sat, 31 Dec 2022 02:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452651;
        bh=2gC0CC3ztY8hHO9eorvLd2RkFQsoUj4tL01S7R+uqww=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K7umhljeAG8ovIyqSDtC2BaLhypGKZ8hrWxlOeKkkd1QV4fHQjX0ELvM4GQMpwgAF
         ZZke+DvcwSgswUeHm62b16Gqe7VFeE6DcZ+P5G24mLk2Y0fNQ36baxpGIh04wHySIo
         E9dsxbUrWaVa2VQI2VXFVQwHkU3BWAq9nyhARjSDPkiEVirlccr8Fk+xRn4WGotRpC
         3yqrx05orWHKMrM2kbAEuu7/tyeX1JkcpdWaxjmv8pCdJNg+Ig8cs0wOZKotCJRB38
         mreMulCEK1/JXUVSAlYC1CCxiPhNVVReE2pKNh8bNU9PgrGhpTmWy+Wu7SawRntkVm
         b+HeXeF5e6oFA==
Subject: [PATCH 04/46] libxfs: convert all users to libxfs_imeta_create
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:19 -0800
Message-ID: <167243875995.725900.8561970485775658073.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert all open-coded sb metadata inode pointer logging to use
libxfs_imeta_create to create metadata inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   54 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 3121c35baa1..354c9fa8a02 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -680,8 +680,7 @@ static void
 rtinit(
 	struct xfs_mount	*mp)
 {
-	struct cred		creds;
-	struct fsxattr		fsxattrs;
+	struct xfs_imeta_update	upd;
 	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	struct xfs_inode	*rbmip;
 	struct xfs_inode	*rsumip;
@@ -696,45 +695,54 @@ rtinit(
 	int			error;
 
 	/* Create the realtime bitmap inode. */
-	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
+	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTBITMAP, &upd);
 	if (error)
 		res_failed(error);
 
-	memset(&creds, 0, sizeof(creds));
-	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
-			&rbmip);
-	if (error) {
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_imeta_create(&tp, &XFS_IMETA_RTBITMAP, S_IFREG, 0,
+			&rbmip, &upd);
+	if (error)
 		fail(_("Realtime bitmap inode allocation failed"), error);
-	}
-	/*
-	 * Do our thing with rbmip before allocating rsumip,
-	 * because the next call to createproto may
-	 * commit the transaction in which rbmip was allocated.
-	 */
-	mp->m_sb.sb_rbmino = rbmip->i_ino;
+
 	rbmip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-	rbmip->i_diflags = XFS_DIFLAG_NEWRTBM;
+	rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 	*(uint64_t *)&VFS_I(rbmip)->i_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
-	libxfs_log_sb(tp);
+	error = -libxfs_trans_commit(tp);
+	if (error)
+		fail(_("Completion of the realtime bitmap inode failed"),
+				error);
 	mp->m_rbmip = rbmip;
+	libxfs_imeta_end_update(mp, &upd, 0);
 
 	/* Create the realtime summary inode. */
-	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
-			&rsumip);
-	if (error) {
+	error = -libxfs_imeta_start_update(mp, &XFS_IMETA_RTSUMMARY, &upd);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			libxfs_imeta_create_space_res(mp), 0, 0, &tp);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_imeta_create(&tp, &XFS_IMETA_RTSUMMARY, S_IFREG, 0,
+			&rsumip, &upd);
+	if (error)
 		fail(_("Realtime summary inode allocation failed"), error);
-	}
-	mp->m_sb.sb_rsumino = rsumip->i_ino;
+
 	rsumip->i_disk_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
-	libxfs_log_sb(tp);
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		fail(_("Completion of the realtime summary inode failed"),
 				error);
 	mp->m_rsumip = rsumip;
+	libxfs_imeta_end_update(mp, &upd, 0);
 
 	/* Zero the realtime bitmap. */
 	blocks = mp->m_sb.sb_rbmblocks +


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C7AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiLaCx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:53:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5422618387
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:53:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E4761BF8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5768AC433D2;
        Sat, 31 Dec 2022 02:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455203;
        bh=r12IMMAMO5tvSP+Oa4yHmRkzkPmVQa966qh90iKGIYY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nqOBf8JEGJ4F2jucPVf73eF8g0ueMqfjlRNYEXQuBsI9W2gN9bknFrUFq1vYqfA2E
         G4h3PGK0HmMUtjEwlFK6+6dU0g45rKnGxYUI2YCNXTNQG1oBtp+RglsEpJqx84D1w3
         wdHEb/alMxfGCy1m2uHO6R7CWHLnY5NRLZdVFeclPMKAXEopF+2Kb428vGDoxO9jOe
         ZHOEFVCDanwDlCPgbLTo+DoIgTK8XNl9bEzP+LZZkma3gkxCQ/e2mlF8j9c3Y/fcgK
         d+5asM+y+XyincQ7u44AtJpeAJjpHouwrZXgEq4eS/fN6Sb6xyeWA7lvvL1VUig0vj
         dVAk+qyKZ9BWg==
Subject: [PATCH 1/4] libxfs: resync libxfs_alloc_file_space interface with the
 kernel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:04 -0800
Message-ID: <167243880412.733953.13235409478389540449.stgit@magnolia>
In-Reply-To: <167243880399.733953.2483387870694006201.stgit@magnolia>
References: <167243880399.733953.2483387870694006201.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the userspace xfs_alloc_file_space behave (more or less) like the
kernel version, at least as far as the interface goes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    4 ++--
 libxfs/util.c    |   40 +++++++++++++++++++---------------------
 mkfs/proto.c     |    2 +-
 3 files changed, 22 insertions(+), 24 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index b1e499569ac..d4985a5769f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -167,8 +167,8 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 /* Shared utility routines */
 
-extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
-				xfs_off_t, int, int);
+extern int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
+					xfs_off_t len, int alloc_type);
 
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
diff --git a/libxfs/util.c b/libxfs/util.c
index e8397fdc341..bb6867c21af 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -179,25 +179,23 @@ libxfs_mod_incore_sb(
  */
 int
 libxfs_alloc_file_space(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	xfs_off_t	len,
-	int		alloc_type,
-	int		attr_flags)
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len,
+	int			alloc_type)
 {
-	xfs_mount_t	*mp;
-	xfs_off_t	count;
-	xfs_filblks_t	datablocks;
-	xfs_filblks_t	allocated_fsb;
-	xfs_filblks_t	allocatesize_fsb;
-	xfs_bmbt_irec_t *imapp;
-	xfs_bmbt_irec_t imaps[1];
-	int		reccount;
-	uint		resblks;
-	xfs_fileoff_t	startoffset_fsb;
-	xfs_trans_t	*tp;
-	int		xfs_bmapi_flags;
-	int		error;
+	struct xfs_bmbt_irec	imaps[1];
+	struct xfs_bmbt_irec	*imapp;
+	struct xfs_mount	*mp;
+	struct xfs_trans	*tp;
+	xfs_off_t		count;
+	xfs_filblks_t		datablocks;
+	xfs_filblks_t		allocated_fsb;
+	xfs_filblks_t		allocatesize_fsb;
+	int			reccount;
+	uint			resblks;
+	xfs_fileoff_t		startoffset_fsb;
+	int			error;
 
 	if (len <= 0)
 		return -EINVAL;
@@ -206,7 +204,6 @@ libxfs_alloc_file_space(
 	error = 0;
 	imapp = &imaps[0];
 	reccount = 1;
-	xfs_bmapi_flags = alloc_type ? XFS_BMAPI_PREALLOC : 0;
 	mp = ip->i_mount;
 	startoffset_fsb = XFS_B_TO_FSBT(mp, offset);
 	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
@@ -227,8 +224,9 @@ libxfs_alloc_file_space(
 		}
 		xfs_trans_ijoin(tp, ip, 0);
 
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
-				xfs_bmapi_flags, 0, imapp, &reccount);
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+				allocatesize_fsb, alloc_type, resblks,
+				imapp, &reccount);
 
 		if (error)
 			goto error0;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 36af61ed5c0..b11b7fa5f95 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -179,7 +179,7 @@ rsvfile(
 	int		error;
 	xfs_trans_t	*tp;
 
-	error = -libxfs_alloc_file_space(ip, 0, llen, 1, 0);
+	error = -libxfs_alloc_file_space(ip, 0, llen, XFS_BMAPI_PREALLOC);
 
 	if (error) {
 		fail(_("error reserving space for a file"), error);


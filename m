Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4EEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiLaCFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:05:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFC22AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34117B81DD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00168C433EF;
        Sat, 31 Dec 2022 02:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452340;
        bh=8ainxc/DtULUp4Aovq2lDxJIEgJHpkVe6xt4WLPseX8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KyTOS8uSrkkQiTRpDFu0pcTaF365f/TyQpIy+jc88z6gtYplDwKWHMMEYOol/dmGy
         VbFG9rjtqAVzvcv2p7PThb6VOr4SVU+mQRnoAOILPXQ4ax1vT7yRA2eusAJRDaxQqz
         459R/L845Wl6EiGNgAjb4dxj/dRYQ0BN8cL/fB/T4X20atjaALLxbWyo20a8ycldYH
         Wgb95zT2zh/XtLKH5yvNzSsgMrQcLPdb0LNlcT5Nwvfsk7tBfwL3NVK1b5WJFLkp7L
         tBrMUGv9C0I78rIXGb3c+KI8Wdmv91BX63Mk6mmCEBSeRt+2CqaacgqsxU4ds3ymL/
         bTyFBBC0xTznQ==
Subject: [PATCH 10/26] libxfs: when creating a file in a directory,
 set the project id based on the parent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875442.723621.1176728186923814951.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're creating a file as a child of an existing directory, use
xfs_get_initial_prid to have the child inherit the project id of the
directory if the directory has PROJINHERIT set, just like the kernel
does.  This fixes mkfs project id propagation with -d projinherit=X when
protofiles are in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c           |    1 +
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 7f8f1164e08..c63cc0543d6 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -231,6 +231,7 @@ libxfs_dir_ialloc(
 		.pip		= dp,
 		.uid		= make_kuid(cr->cr_uid),
 		.gid		= make_kgid(cr->cr_gid),
+		.prid		= dp ? libxfs_get_initial_prid(dp) : 0,
 		.nlink		= nlink,
 		.rdev		= rdev,
 		.mode		= mode,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 01ad6e54624..5752733a833 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -136,6 +136,7 @@
 #define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_get_projid			libxfs_get_projid
+#define xfs_get_initial_prid		libxfs_get_initial_prid
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino


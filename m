Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DC0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiLaCNp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiLaCNo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:13:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA7E1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69CAE61D1B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BDFC433D2;
        Sat, 31 Dec 2022 02:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452822;
        bh=rrwmC+mJiK+rojDnCMCt56OcVlpwNrYT18zntilbBEA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQWbPuYGfzSp0/0GOWLnLeEhgVlFLwKuoXd4Sn9E2gPQyHa61001X6DenGz3zmIvy
         2m2kmjEwiORIecXLi6WZ0Ed/Jk4neARvKDLc1T6BQSb/ML/Cz8wLSEsZayuyTIHuF3
         igciMkyDFhxaDdcG52D1dqm36QcyVmARBmN2m40O2/3uIEgd1DHgUs1IG/77hnWkyM
         ziFuE1WuefjF1Lb2z4DN6a6BurvBDZKlVqvcxVxCwBqLesooFOeNOscUMrmvqOfdaJ
         z6nhs62ml6BqlZvXwMn2ZCrxnCG2vu7/LQWj9u4oO4OxKGLN5rFMWlQO2oLdJ4sLpP
         t4FSA+RZMS1Jg==
Subject: [PATCH 15/46] xfs: advertise metadata directory feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876134.725900.10165638247764460105.stgit@magnolia>
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

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                 |    1 +
 libxfs/xfs_sb.c                 |    2 ++
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 3 files changed, 6 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index a39fd65e6ee..7de31a6692a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 30) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1U << 31) /* atomic file extent swap */
 
 /*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 6452856d45b..55a5c5fc631 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1231,6 +1231,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_swapext_supported(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 7c563ca0454..19328bb4be4 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -214,6 +214,9 @@ Filesystem supports sharing blocks between files.
 .TP
 .B XFS_FSOP_GEOM_FLAGS_ATOMICSWAP
 Filesystem can exchange file contents atomically via FIEXCHANGE_RANGE.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_METADIR
+Filesystem contains a metadata directory tree.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP


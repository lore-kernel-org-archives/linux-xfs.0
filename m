Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2321CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiLaBOf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBOe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:14:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ED816588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 978EFCE1923
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1605C433EF;
        Sat, 31 Dec 2022 01:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449269;
        bh=67NzkSqfDR+MIw5zBBsZhX9y4ADp5JHp9SvtNyWiSBA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ajLwnjk7XisF/2qeZ/7Jt6nnYM0iG3epuAY61S5Uu0fBlL5AoV8GgvE21cjN9RK2D
         dd015sJQ4vsfb1Nwi89XVNa3JKTozDTzyvkbiLPL38fruwgcGcAxjB5gm74vJ4UpNm
         JYlyn8saP5AG2QAIQmY4se1THxQUno+mIISfLuk92AnjeK4kb5BPk11X5aBCsOfx57
         b/4pzAUl6dXsPWezODEp9pN0gh20SXPrHivCwhya3qmn6GwwmQ3kvoJScDRi/rttBR
         fkojkgYqRoxRX9R++tzUGomgdqEOsJ9Cje+dUW9FYq4Z1duA8z6ipOs49La2KhUhik
         IM9MukwS2Qn2g==
Subject: [PATCH 16/23] xfs: advertise metadata directory feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864683.708110.8530179836471196243.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/libxfs/xfs_sb.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a39fd65e6ee0..7de31a6692ae 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -239,6 +239,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 30) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1U << 31) /* atomic file extent swap */
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 181bede3b3f6..8ebedfe55b15 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1233,6 +1233,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_swapext_supported(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 


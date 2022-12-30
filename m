Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7F9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiLaAKm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiLaAKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:10:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454871E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:10:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02F3FB81E03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE1C433F2;
        Sat, 31 Dec 2022 00:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445438;
        bh=Qwx/j33fOB4L/aVHTedpe5jZBpdg0kzEkoB32H4yL8w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ARb4AK/CTt4TDpPi9QVG0kq34fxoYUvQXaa+4XHVqGahhCD1Lqxtc7QKPl6k9yNrj
         GhIixkhPd3n1OGQ40UHMnkNu611nwGQBuKW5zIccZd77bZ3drnJhbRz92prR6iM4wg
         ny9rPIzEaWm8ACKz6EsIWWtUJgsMvqJOJ/YBKMd7MzQ28kEbF7h3Ju0Rn1q87IXG6l
         EBN3jHl4iculkFdSe/Pc3mBzpiUrx0d0NWZZaRfWj2htZWTQM9RXvlpTWU2UztayYM
         El0/z92at2aqE3rUoXcDxrJn54kqP3DPV6ck41hBPe01zEaZxO2qOoMrs9UFSpSKrg
         69AcxuZ8qPYcg==
Subject: [PATCH 2/4] xfs: remember sick inodes that get inactivated
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:38 -0800
Message-ID: <167243865844.711359.15658344595314273079.stgit@magnolia>
In-Reply-To: <167243865816.711359.1865490497957941966.stgit@magnolia>
References: <167243865816.711359.1865490497957941966.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an unhealthy inode gets inactivated, remember this fact in the
per-fs health summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h        |    1 +
 libxfs/xfs_health.h    |    7 +++++--
 libxfs/xfs_inode_buf.c |    2 +-
 spaceman/health.c      |    4 ++++
 4 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 3885c56078f..417cf85c0f7 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -292,6 +292,7 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
+#define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index b3733f756bb..252334bc048 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -76,6 +76,7 @@ struct xfs_da_args;
 #define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+#define XFS_SICK_AG_INODES	(1 << 10) /* inactivated bad inodes */
 
 /* Observable health issues for inode metadata. */
 #define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
@@ -86,6 +87,8 @@ struct xfs_da_args;
 #define XFS_SICK_INO_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
+/* Don't propagate sick status to ag health summary during inactivation */
+#define XFS_SICK_INO_FORGET	(1 << 8)
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -122,12 +125,12 @@ struct xfs_da_args;
 #define XFS_SICK_FS_SECONDARY	(0)
 #define XFS_SICK_RT_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
-#define XFS_SICK_INO_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
 #define XFS_SICK_RT_INDIRECT	(0)
-#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index aad64c0a2e6..82eb3f91b9d 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -136,7 +136,7 @@ xfs_imap_to_bp(
 			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
-				XFS_SICK_AG_INOBT);
+				XFS_SICK_AG_INODES);
 	return error;
 }
 
diff --git a/spaceman/health.c b/spaceman/health.c
index 88b12c0b0ea..12fb67bab28 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -127,6 +127,10 @@ static const struct flag_map ag_flags[] = {
 		.descr = "reference count btree",
 		.has_fn = has_reflink,
 	},
+	{
+		.mask = XFS_AG_GEOM_SICK_INODES,
+		.descr = "overall inode state",
+	},
 	{0},
 };
 


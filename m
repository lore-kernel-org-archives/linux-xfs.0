Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627D6C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBPU5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjBPU5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:57:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84674D606
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91192B82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB0EC433D2;
        Thu, 16 Feb 2023 20:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581061;
        bh=xCdmQNGFfqXPHZIMNZgz937VJMuXEEHSkOx7Xk8VZCc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GWDpaOjqp/fqY1AjwQ3RrZme9bHQv/dxLWaqJUhy6DJrNjxMntY+ArVrczHp7Lv/A
         iEEOUMsh6ZthAIhHelWkfzxQ7YAnvXBtgFhUGJS3Lr0QDoat5ejXCMqhFNUDM7X/q4
         qoY2OhcrDd8Kit6iq6LGsyo4ErAby1byfrOkpev6ylvcJqCBQx+TJM0xJEwDdKKVb6
         SyULXSXSnioEbLRsCqpscHTXk6ovataRFHQ3WmGgD576rKh3i9yX+qWIgdD+G3Y8wb
         0tu7cuhhRvsSeyeuGyZlxWCNbOXAfuZxGzbzFkVciRE6nuGbYKB5ia/Sspdgk2bPQ5
         Xz8aILCPfwb9g==
Date:   Thu, 16 Feb 2023 12:57:40 -0800
Subject: [PATCH 16/25] xfsprogs: Add the parent pointer support to the
 superblock version 5.
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Mark Tinguely <tinguely@sgi.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879123.3476112.18429672769647602745.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 724321b7f1c737ce880ea0e6fa4422ad13c4d440

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/fsgeom.c    |    4 ++++
 libxfs/xfs_format.h |    4 +++-
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_sb.c     |    4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 3e7f0797..3bb753ac 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -31,6 +31,7 @@ xfs_report_geom(
 	int			bigtime_enabled;
 	int			inobtcount;
 	int			nrext64;
+	int			parent;
 
 	isint = geo->logstart > 0;
 	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
@@ -49,12 +50,14 @@ xfs_report_geom(
 	bigtime_enabled = geo->flags & XFS_FSOP_GEOM_FLAGS_BIGTIME ? 1 : 0;
 	inobtcount = geo->flags & XFS_FSOP_GEOM_FLAGS_INOBTCNT ? 1 : 0;
 	nrext64 = geo->flags & XFS_FSOP_GEOM_FLAGS_NREXT64 ? 1 : 0;
+	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
 
 	printf(_(
 "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
 "         =%-22s reflink=%-4u bigtime=%u inobtcount=%u nrext64=%u\n"
+"         =%-22s parent=%d\n"
 "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 "         =%-22s sunit=%-6u swidth=%u blks\n"
 "naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
@@ -65,6 +68,7 @@ xfs_report_geom(
 		"", geo->sectsize, attrversion, projid32bit,
 		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
 		"", reflink_enabled, bigtime_enabled, inobtcount, nrext64,
+		"", parent,
 		"", geo->blocksize, (unsigned long long)geo->datablocks,
 			geo->imaxpct,
 		"", geo->sunit, geo->swidth,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 371dc072..f413819b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 1cfd5bc6..b0b4d7a3 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d05f0e6e..2ce2ba75 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -171,6 +171,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1187,6 +1189,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;


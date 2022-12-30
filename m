Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F66FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbiLaC5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiLaC5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:57:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C842E1929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:57:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C976B81E64
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A16C433EF;
        Sat, 31 Dec 2022 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455421;
        bh=yWhvKQh2LGNGwiSFzvsUpOkAPqDTrd3IMvFs+GqQTnA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sn/G/xSCFaUb77EQnjALjKJjTEAm7rzAz3Lv+baxVzLwf4xivdNyAb0t6HyZBu2ky
         VG0Fli6d2JEmUZOriQBD2ZyepmSjjFTiK5UcJq9guireUhqKECZU/ksLKMZ9tGLKdf
         jRSantix/KS2unp8qdS9ibG463bvJ54URmV8MaQv91fiFZwZycVu0fE0O/V1aHfiwO
         Crh0o1W7M0toymoEE7f8Bea6UlzARKmgJVlH+21EzTvwpT1CFttIrd/k67WdJXczDz
         CFLD9W6gr8secu0IoR9vEk/1mO4PrkfzZkeG/D4qXHSIx/Mga9MqY3wGWwH504Th1J
         7lNdnCn2rLQfg==
Subject: [PATCH 11/41] xfs: wire up realtime refcount btree cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:09 -0800
Message-ID: <167243880914.734096.10585811176819741771.stgit@magnolia>
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

Wire up realtime refcount btree cursors wherever they're needed
throughout the code base.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |    7 ++++---
 libxfs/xfs_rtgroup.c  |   10 ++++++++++
 libxfs/xfs_rtgroup.h  |    5 ++++-
 3 files changed, 18 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 960dbb401bd..5bc68407215 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -24,6 +24,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -1483,9 +1484,9 @@ xfs_refcount_finish_one(
 	}
 	if (rcur == NULL) {
 		if (ri->ri_realtime) {
-			/* coming in a later patch */
-			ASSERT(0);
-			return -EFSCORRUPTED;
+			xfs_rtgroup_lock(tp, ri->ri_rtg, XFS_RTGLOCK_REFCOUNT);
+			rcur = xfs_rtrefcountbt_init_cursor(mp, tp, ri->ri_rtg,
+					ri->ri_rtg->rtg_refcountip);
 		} else {
 			error = xfs_alloc_read_agf(ri->ri_pag, tp,
 					XFS_ALLOC_FLAG_FREEING, &agbp);
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index f5f981609b4..d6a52084b3c 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -521,6 +521,13 @@ xfs_rtgroup_lock(
 		if (tp)
 			xfs_trans_ijoin(tp, rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 	}
+
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip) {
+		xfs_ilock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+		if (tp)
+			xfs_trans_ijoin(tp, rtg->rtg_refcountip,
+					XFS_ILOCK_EXCL);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -533,6 +540,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_REFCOUNT) && rtg->rtg_refcountip)
+		xfs_iunlock(rtg->rtg_refcountip, XFS_ILOCK_EXCL);
+
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
 		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
 
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 0f400f133d8..4f0358d6345 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -237,10 +237,13 @@ int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
 /* Lock the rt rmap inode in exclusive mode */
 #define XFS_RTGLOCK_RMAP		(1U << 2)
+/* Lock the rt refcount inode in exclusive mode */
+#define XFS_RTGLOCK_REFCOUNT		(1U << 3)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
 				 XFS_RTGLOCK_BITMAP_SHARED | \
-				 XFS_RTGLOCK_RMAP)
+				 XFS_RTGLOCK_RMAP | \
+				 XFS_RTGLOCK_REFCOUNT)
 
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);


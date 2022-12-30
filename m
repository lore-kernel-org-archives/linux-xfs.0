Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A111AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbiLaB5k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiLaB5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:57:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEA71C438
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:57:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE8FE61C44
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1572BC433D2;
        Sat, 31 Dec 2022 01:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451858;
        bh=j6sJA1G9PKSKfiUoy+6U45B4jtSSLXXWQIEfyAOtGSg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xh+tbRMiNDXuQ6SXdzlISTTqsnpR0z7ao9q2UCaahIObMr7SPzJ+XuRKs8c7JMgI8
         fNoiMA4ho7+78Nh+yiSdvucbwfI8C9lUDg1VoOJKefORuTu7MeZnHAuZfCa8bhCp9v
         SCGSog3v6OE+geLRgZYPdBx7KdxrBUyBqZzcDkpzv93wTztIrIv/STxsYiSIy8gO//
         Yn3NfB3vX/XKUsr8a8kYzx7T7ZBrk6rmEkIDM+5v2pmJJ93N1fd++M9Uiq9LyQQZar
         2LEgTv2Eqk0AS4+8HCIMmn9lUJG9V5HdBvUnrn05M1FuAlKFZQrP42cLZEf8i2EgbS
         tnRQn/rlWa/Og==
Subject: [PATCH 37/42] xfs: walk the rt reference count tree when rebuilding
 rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871421.717073.4694070852781910720.stgit@magnolia>
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

When we're rebuilding the data device rmap, if we encounter a "refcount"
format fork, we have to walk the (realtime) refcount btree inode to
build the appropriate mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 86c5338a12b9..24dcd3842ce6 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -32,6 +32,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -530,6 +531,39 @@ xrep_rmap_scan_rtrmapbt(
 	return -EFSCORRUPTED;
 }
 
+static int
+xrep_rmap_scan_rtrefcountbt(
+	struct xrep_rmap_ifork	*rf,
+	struct xfs_inode	*ip)
+{
+	struct xfs_scrub	*sc = rf->rr->sc;
+	struct xfs_btree_cur	*cur;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	if (rf->whichfork != XFS_DATA_FORK)
+		return -EFSCORRUPTED;
+
+	for_each_rtgroup(sc->mp, rgno, rtg) {
+		if (ip == rtg->rtg_refcountip) {
+			cur = xfs_rtrefcountbt_init_cursor(sc->mp, sc->tp, rtg,
+					ip);
+			error = xrep_rmap_scan_iroot_btree(rf, cur);
+			xfs_btree_del_cursor(cur, error);
+			xfs_rtgroup_put(rtg);
+			return error;
+		}
+	}
+
+	/*
+	 * We shouldn't find a refcount format inode that isn't associated with
+	 * an rtgroup!
+	 */
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
 /* Find all the extents from a given AG in an inode fork. */
 STATIC int
 xrep_rmap_scan_ifork(
@@ -561,6 +595,8 @@ xrep_rmap_scan_ifork(
 			return error;
 	} else if (ifp->if_format == XFS_DINODE_FMT_RMAP) {
 		return xrep_rmap_scan_rtrmapbt(&rf, ip);
+	} else if (ifp->if_format == XFS_DINODE_FMT_REFCOUNT) {
+		return xrep_rmap_scan_rtrefcountbt(&rf, ip);
 	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
 		return 0;
 	}


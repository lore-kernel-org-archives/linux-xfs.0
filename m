Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2536DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiLaB6b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaB61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:58:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4942E1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:58:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E14EB81DF0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE69C433D2;
        Sat, 31 Dec 2022 01:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451904;
        bh=QY4pfgUyOI8NRJ4WzmUz+mRd40gjGvc/tIkqvCVD7m0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dTpjysoMeQ+tfm5lcKLT+0mA8Es+0H/fWT6vL81EeXi0h8uWviAQxK++28I79R/pf
         0vA/0g2dbYcEN9JPqmxt6sByDk+E6kfZ9tLjfZknu8tHzvREVYXEm9hjTT/WrKKtiX
         8D6xrtN76KIoPxN1PVnycSSS+E9ctmmr4+eghkNoh4uQrXljl03wiyRZBd20LLJTjj
         0L6NUhKF60ZRqvQ122Dcs8z/R2T2IQbi5xx+PBwFag2B20dsve7JOlM/oV1nsLC7vD
         MyezV9zdtZJODuNZZOA9oBSHUj0Dwsdujj/+ysiNbCw4tH4eGfneu029oppd991Z66
         hdm7ksnXRXN6Q==
Subject: [PATCH 40/42] xfs: repair inodes that have a refcount btree in the
 data fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871465.717073.11753987612330457810.stgit@magnolia>
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

Plumb knowledge of refcount btrees into the inode core repair code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 3ce9ac5b0fc4..15dbb8a08b81 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -39,6 +39,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -977,6 +978,7 @@ xrep_dinode_ensure_forkoff(
 {
 	struct xfs_bmdr_block	*bmdr;
 	struct xfs_rtrmap_root	*rmdr;
+	struct xfs_rtrefcount_root *rcdr;
 	struct xfs_scrub	*sc = ri->sc;
 	xfs_extnum_t		attr_extents, data_extents;
 	size_t			bmdr_minsz = xfs_bmdr_space_calc(1);
@@ -1087,6 +1089,10 @@ xrep_dinode_ensure_forkoff(
 		rmdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
 		dfork_min = xfs_rtrmap_broot_space(sc->mp, rmdr);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		rcdr = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+		dfork_min = xfs_rtrefcount_broot_space(sc->mp, rcdr);
+		break;
 	default:
 		dfork_min = 0;
 		break;


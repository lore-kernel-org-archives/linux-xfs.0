Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61B5C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911AC60F58
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhHEHBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 03:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234448AbhHEHBZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 03:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4520560F58;
        Thu,  5 Aug 2021 07:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628146871;
        bh=jAltqYrDNqmTUYoNWzUoGyKqIMK5nsFH+8LKpeuHV00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ji33TB5i3tSaiS1zz/ZCoRkW9YSJqfWmU96ysA+mJRzUKRlqkR5kajmvkPKaBRlbV
         qvhGLvapTspMWA5aAaJjbmstD7U3yxk70xce0mr3Wov+l+Tukes1O2Vjuu9S687tAb
         4KzA1326pyMtaiwcu0Pzwynigb/N2vOnme3Sbt21hIO/fGT9Nsk2QLQfzGubYpwowh
         +UlBy/gNV/18VUNragikNUwFQsTnNWKTQCcQPIRowD8UC5wO4QO2zINWKy9sDQUvxZ
         AbDJ/6Cp1PU6mU9uk3XURyFPBbIeJ8Qa8Au55yKUo1iFGqMLZedIxi2syHyoPc9Y0K
         IQF/kIiUNvgJA==
Subject: [PATCH 5/5] xfs: dump log intent items that cannot be recovered due
 to corruption
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Aug 2021 00:01:11 -0700
Message-ID: <162814687097.2777088.3937845877884086271.stgit@magnolia>
In-Reply-To: <162814684332.2777088.14593133806068529811.stgit@magnolia>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we try to recover a log intent item and the operation fails due to
filesystem corruption, dump the contents of the item to the log for
further analysis.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c     |    3 +++
 fs/xfs/xfs_extfree_item.c  |    3 +++
 fs/xfs/xfs_refcount_item.c |    3 +++
 fs/xfs/xfs_rmap_item.c     |    3 +++
 4 files changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e3a691937e92..3d6f70da8820 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -522,6 +522,9 @@ xfs_bui_item_recover(
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
 			whichfork, bmap->me_startoff, bmap->me_startblock,
 			&count, state);
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bmap,
+				sizeof(*bmap));
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 2424230ca2c3..3f8a0713573a 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -629,6 +629,9 @@ xfs_efi_item_recover(
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
 					      extp->ext_len,
 					      &XFS_RMAP_OINFO_ANY_OWNER, false);
+		if (error == -EFSCORRUPTED)
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					extp, sizeof(*extp));
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 746f4eda724c..163615285b18 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -522,6 +522,9 @@ xfs_cui_item_recover(
 			error = xfs_trans_log_finish_refcount_update(tp, cudp,
 				type, refc->pe_startblock, refc->pe_len,
 				&new_fsb, &new_len, &rcur);
+		if (error == -EFSCORRUPTED)
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					refc, sizeof(*refc));
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dc4f0c9f0897..9b91a788722a 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -578,6 +578,9 @@ xfs_rui_item_recover(
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
 				rmap->me_len, state, &rcur);
+		if (error == -EFSCORRUPTED)
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					rmap, sizeof(*rmap));
 		if (error)
 			goto abort_error;
 


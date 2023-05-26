Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4906FC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236168AbjEZAx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbjEZAx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:53:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6285194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4079761B75
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4891C433EF;
        Fri, 26 May 2023 00:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062404;
        bh=t+hFsUACzmqCTCSKkKlBaJEHH0NYhiKDjm1aumS+sL0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DcQczb6xZQCrQ8mpLtoQWmuTdxYUQ/PWosV/qVOxE5tRcdhnCJrPWi8ZY85QuRGAX
         Jcu5QBfEo02DHXU3fO0Nl8anFhGw19vsFfjxwVH8ZTuF43O3mEuuBKy6nX9TUJ5+Yo
         D1olFJulutb62HbmnjrxlND6b4E5O6fCsgleL6+iv8nZvMsc4WuRfySUWCwDwX0N4b
         2Bb3CmJMm6lIk/VeJvwCQo8Uf+IkMpXgnt4UbwAHke7pdoqkQc0y4b4mOp29kGp4Km
         EFUox+xP1oT2AggNr3BOd0sxNuB/7qePS15OV5ITHPOw1LiQD6hEVmpYbJl8LZjARp
         EG5/KfS4VSZ/Q==
Date:   Thu, 25 May 2023 17:53:24 -0700
Subject: [PATCH 5/6] xfs: abort directory parent scrub scans if we encounter a
 zapped directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058382.3730405.11813139064416589382.stgit@frogsfrogsfrogs>
In-Reply-To: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
References: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the previous patch, we added some code to perform sufficient repairs
to an ondisk inode record such that the inode cache would be willing to
load the inode.  If the broken inode was a shortform directory, it will
reset the directory to something plausible, which is to say an empty
subdirectory of the root.  The telltale signs that something is
seriously wrong is the broken link count.

Such directories look clean, but they shouldn't participate in a
filesystem scan to find or confirm a directory parent pointer.  Create a
predicate that identifies such directories and abort the scrub.

Found by fuzzing xfs/1554 with multithreaded xfs_scrub enabled and
u3.bmx[0].startblock = zeroes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    1 +
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/dir.c    |   21 +++++++++++++++++++++
 fs/xfs/scrub/parent.c |   10 ++++++++++
 4 files changed, 34 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8482a003d1f7..de281833cadf 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -26,6 +26,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e9ea3b39b0ef..70546def3d3d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -173,6 +173,8 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+bool xchk_dir_looks_zapped(struct xfs_inode *dp);
+
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 0b491784b759..acae43d20f38 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -788,3 +788,24 @@ xchk_directory(
 		error = 0;
 	return error;
 }
+
+/*
+ * Decide if this directory has been zapped to satisfy the inode and ifork
+ * verifiers.  Checking and repairing should be postponed until the directory
+ * is fixed.
+ */
+bool
+xchk_dir_looks_zapped(
+	struct xfs_inode	*dp)
+{
+	/*
+	 * If the dinode repair found a bad data fork, it will reset the fork
+	 * to extents format with zero records and wait for the bmapbtd
+	 * scrubber to reconstruct the block mappings.  Directories always
+	 * contain some content, so this is a clear sign of a zapped directory.
+	 */
+	if (dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS)
+		return dp->i_df.if_nextents == 0;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index e6155d86f791..93d3b35679ab 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -156,6 +156,16 @@ xchk_parent_validate(
 		goto out_rele;
 	}
 
+	/*
+	 * We cannot yet validate this parent pointer if the directory looks as
+	 * though it has been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(dp)) {
+		error = -EFSCORRUPTED;
+		xchk_set_incomplete(sc);
+		goto out_unlock;
+	}
+
 	/* Look for a directory entry in the parent pointing to the child. */
 	error = xchk_dir_walk(sc, dp, xchk_parent_actor, &spc);
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))


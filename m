Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D6AC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiL3Xai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3Xab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:30:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500971DDDD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10D0FB81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B004EC43392;
        Fri, 30 Dec 2022 23:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443026;
        bh=tvl9oD9MUo8pMka76IcXdXVqPhzkzWBj36wkxfptnD0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=stAO39F6a/aB3GAnpnOET1YMsQb7pMUABKZNuFDf2lXv7AqaJhjZRz3tDQkMexZYS
         UcujbrHLxwHTlH9pyG/am/maoh9pcMoAcABfIS+soXlfu3OyR/ggnjnCU/p06f4hMy
         BBtY13+sqtch4duXoGCcuzth8MGYFwn/8uuv1nbfozYHz6HQfa8dEAonvrDsFB6kXy
         81eCTPwg5MpdhSEhEmuhpTAxh4ppNPGtdxBW46xEHO+yRlKY65G6wzOlTecA+N2BNv
         UCfPwCZUP4CZEh2eNCyOoPjEjNBBHZG0NgSnqkiRaZAjC7cyIJpcEpfrgJI47ZSB2W
         kZ9Ul7aM0W+Bg==
Subject: [PATCH 5/6] xfs: abort directory parent scrub scans if we encounter a
 zapped directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837310.694402.18143116509302770330.stgit@magnolia>
In-Reply-To: <167243837231.694402.7473901938296662729.stgit@magnolia>
References: <167243837231.694402.7473901938296662729.stgit@magnolia>
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
 fs/xfs/scrub/parent.c |   11 +++++++++++
 4 files changed, 35 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 6b9d852873d8..3fc392c1b1a8 100644
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
index c1a0a1ac19b2..4c90c45b9b34 100644
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
index 2a3107cc8ccb..5b3a9edc8932 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -854,3 +854,24 @@ xchk_directory(
 out:
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
index 8581a21bfbfd..371526f4369d 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -89,6 +89,17 @@ xchk_parent_count_parent_dentries(
 	 * if there is one.
 	 */
 	lock_mode = xfs_ilock_data_map_shared(parent);
+
+	/*
+	 * We cannot yet validate this parent pointer if the directory looks as
+	 * though it has been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(parent)) {
+		xfs_iunlock(parent, lock_mode);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
+
 	if (parent->i_df.if_nextents > 0)
 		error = xfs_dir3_data_readahead(parent, 0, 0);
 	xfs_iunlock(parent, lock_mode);


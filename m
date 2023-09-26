Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DE1E7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjI0AR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjI0APz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:15:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83E17D96
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:36:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3F5C433C8;
        Tue, 26 Sep 2023 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771381;
        bh=tp9zLje03hLdFAEtIO0o5d9N65AlQC8ufIgHwN0P17c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mCac/3KwOt25em8SKIrn/cHvHxSuK8i7KmS/NW123ixE/pt561UP7IZFHEWFY47pJ
         YRuQ8b5hLNH+3QAA9QHqM94FZ/YK6NapUBc54+nuSXvIp0CBoi+hKzvZU1UMV6G/Hu
         a97XS09it5DqwTxN3YjuIQiuaSWuXyZvTpJfcqrXAleljHX3jRpjQWerzKoeEFdx9G
         DNzPJ+q1sXDLVqhkYHk/aW4xMyh+r/O7SXs/uDSbCAmcNeKs/YNUUv+zdPxRn6ngsu
         Wad/3vJjHA96DcMf6fARL5gCOcjkfNAAfKARo26iOmyLY1k4RWFLaJYQM1aT4hggKl
         0jKNy9BN5R2Og==
Date:   Tue, 26 Sep 2023 16:36:20 -0700
Subject: [PATCH 5/7] xfs: abort directory parent scrub scans if we encounter a
 zapped directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577060436.3315095.696278759109119743.stgit@frogsfrogsfrogs>
In-Reply-To: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
References: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/parent.c |   17 +++++++++++++++++
 4 files changed, 41 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9b7d7010495b9..67ed4c55a27e3 100644
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
index 895918565df26..506b808b9fbb3 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -192,6 +192,8 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+bool xchk_dir_looks_zapped(struct xfs_inode *dp);
+
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 0b491784b7594..acae43d20f387 100644
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
index e6155d86f7916..7db8736721461 100644
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
+		error = -EBUSY;
+		xchk_set_incomplete(sc);
+		goto out_unlock;
+	}
+
 	/* Look for a directory entry in the parent pointing to the child. */
 	error = xchk_dir_walk(sc, dp, xchk_parent_actor, &spc);
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
@@ -217,6 +227,13 @@ xchk_parent(
 		 */
 		error = xchk_parent_validate(sc, parent_ino);
 	} while (error == -EAGAIN);
+	if (error == -EBUSY) {
+		/*
+		 * We could not scan a directory, so we marked the check
+		 * incomplete.  No further error return is necessary.
+		 */
+		return 0;
+	}
 
 	return error;
 }


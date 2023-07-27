Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5ADC00528
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbjG0We2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjG0We1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6C130D3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35FBD61F6E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976FBC433C7;
        Thu, 27 Jul 2023 22:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497205;
        bh=iwchNS+SvhNMpv7i0QeBnbK8VwC/51hdMNjEEnk1SZs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CdrIQasWTM2JSLscPCf4dQT96Xpv0VUB0sU62vl/QIugWZo3lwyj3oUgxw53Ud3wC
         /7fQHv39qG10/wJneMUeRQYbMVU2fKC31msuipT4Mf+W1x0G24MyqpEHX7K5Yc8cfq
         63g5grFDoo48GmWA2I6Pcuo2RkAiZCr9qhr8vagsEbgYekJtYh2OuU3Ux/iaedRqVS
         09mAoylGdCVAyjBN/9byqI2CnF74cd6zyIOCRLBizI/t6JYEsiVlVJ6CFZBvlXamWn
         L7uVw0F3pFl6VyqaQYk756h6RztXLrp74suBfH8+LZWKiB8uCU/QAN9JL520xxWCYC
         2vT1FOCZmxRbw==
Date:   Thu, 27 Jul 2023 15:33:25 -0700
Subject: [PATCH 5/6] xfs: abort directory parent scrub scans if we encounter a
 zapped directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626514.922543.2880684653900799043.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
References: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
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
index 32e599b6546cb..902236d871b9f 100644
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
index b7a86ffd21060..1f04e85be7a9b 100644
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
index e6155d86f7916..93d3b35679ab1 100644
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


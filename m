Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90240C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbjEZBdr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239784AbjEZBdq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:33:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA88189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 624F661248
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76D2C433EF;
        Fri, 26 May 2023 01:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064824;
        bh=z4JxA8/Hx2Ay0kS6naWfe+5E+zpfvDH35KQRewZyOjI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=I7eHOCBxaeyEVF0Jz3TUVErlSPMWptrW8hwXdxufhN85Cw0IHQnJg8Te1s7+qb4nU
         EQ+4CmQ8asqyaF2BlzGHTXQwG0OOj6/CK5o0Jg2CpdMvU6Ci7Lk2kx2xN9kM1ovkYP
         3MZGBJN4G0Q254StcpG8ZdlvqAUr+ZYtzI/okFvkne52V1PRepwVS/Ysf1eu9c1284
         ru8lnmc3yDEGPDDaZqCdeyFAZy2Wj9iYRiE7vtkTuAGtoD8qviFIwbimqnhuPbx+6l
         n12hUAJqrULLPW/MZIMCwHHcfLD5OZHRYjBC5TijHHqZNiZ6imrttEpXJMPNG2xk5N
         UDv8JpegcbLZA==
Date:   Thu, 25 May 2023 18:33:44 -0700
Subject: [PATCH 4/5] xfs: scrub should set preen if attr leaf has holes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <168506066884.3737146.15875743925038352634.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066818.3737146.14391441616329630322.stgit@frogsfrogsfrogs>
References: <168506066818.3737146.14391441616329630322.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an attr block indicates that it could use compaction, set the preen
flag to have the attr fork rebuilt, since the attr fork rebuilder can
take care of that for us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/attr.c    |    2 ++
 fs/xfs/scrub/dabtree.c |   16 ++++++++++++++++
 fs/xfs/scrub/dabtree.h |    1 +
 fs/xfs/scrub/trace.h   |    1 +
 4 files changed, 20 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 692e1b2837bb..7dccbc849b19 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -428,6 +428,8 @@ xchk_xattr_block(
 		xchk_da_set_corrupt(ds, level);
 	if (!xchk_xattr_set_map(ds->sc, ab->usedmap, 0, hdrsize))
 		xchk_da_set_corrupt(ds, level);
+	if (leafhdr.holes)
+		xchk_da_set_preen(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index c71254088dff..056de4819f86 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -78,6 +78,22 @@ xchk_da_set_corrupt(
 			__return_address);
 }
 
+/* Flag a da btree node in need of optimization. */
+void
+xchk_da_set_preen(
+	struct xchk_da_btree	*ds,
+	int			level)
+{
+	struct xfs_scrub	*sc = ds->sc;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xchk_fblock_preen(sc, ds->dargs.whichfork,
+			xfs_dir2_da_to_db(ds->dargs.geo,
+				ds->state->path.blk[level].blkno),
+			__return_address);
+}
+
+/* Find an entry at a certain level in a da btree. */
 static struct xfs_da_node_entry *
 xchk_da_btree_node_entry(
 	struct xchk_da_btree		*ds,
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 4f8c2138a1ec..d654c125feb4 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -35,6 +35,7 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 
 /* Check for da btree corruption. */
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 51855452b16b..77309927c5db 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -366,6 +366,7 @@ DEFINE_EVENT(xchk_fblock_error_class, name, \
 
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_preen);
 
 #ifdef CONFIG_XFS_QUOTA
 TRACE_EVENT(xchk_qcheck_error,


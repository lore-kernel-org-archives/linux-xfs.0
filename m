Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37364C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiL3WlS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiL3WlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:41:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D5512D1D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:41:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9750B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912DBC433F1;
        Fri, 30 Dec 2022 22:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440073;
        bh=t6ADI6qexZVEZyOaIQm0s3Vidy4W7ld0cPeDDqATPFg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QA6TWUe8zX0BnmxQbP9Tot4todlDs8ZGEcfELeOjS/whn7EZBKYzY0SbGcp/WsTE0
         JZTKh5bkMcfZYOKEFd9erREk7btby2PaXkm0v22AjLQ6r2+Z7RdA6qjAcWBYFWXiv+
         EYHUy5/FnIPz2vpobHV8x9Tt4xDz4LFDZwcVWPIGnIr8tCs4D4C6Lx09bno7VJVoMI
         FMM863TCv/j6Liw0dJFrcQI1TPIL55MT09G3MjEun1efO3OWDyHCeO7NidTrdNuuW8
         6QFVE2QUfi3uWRIA17dkPx04CWysrun8o59TOKbU3YajzriRNexSXmdyMVQtOejnp9
         2Is2zZ3da1NDA==
Subject: [PATCH 2/2] xfs: detect unwritten bit set in rmapbt node block keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:19 -0800
Message-ID: <167243827902.684208.14314428847488251866.stgit@magnolia>
In-Reply-To: <167243827872.684208.12327644447561431612.stgit@magnolia>
References: <167243827872.684208.12327644447561431612.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the last patch, we changed the rmapbt code to remove the UNWRITTEN
bit when creating an rmapbt key from an rmapbt record, and we changed
the rmapbt key comparison code to start considering the ATTR and BMBT
flags during lookup.  This brought the behavior of the rmapbt
implementation in line with its specification.

However, there may exist filesystems that have the unwritten bit still
set in the rmapbt keys.  We should detect these situations and flag the
rmapbt as one that would benefit from optimization.  Eventually, online
repair will be able to do something in response to this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |   10 +++++++++
 fs/xfs/scrub/btree.h |    2 ++
 fs/xfs/scrub/rmap.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index ebbf1c5fd0c6..634c504bac20 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -119,6 +119,16 @@ xchk_btree_xref_set_corrupt(
 			__return_address);
 }
 
+void
+xchk_btree_set_preen(
+	struct xfs_scrub	*sc,
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	__xchk_btree_set_corrupt(sc, cur, level, XFS_SCRUB_OFLAG_PREEN,
+			__return_address);
+}
+
 /*
  * Make sure this record is in order and doesn't stray outside of the parent
  * keys.
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index da61a53a0b61..26c499925b5e 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -19,6 +19,8 @@ bool xchk_btree_xref_process_error(struct xfs_scrub *sc,
 /* Check for btree corruption. */
 void xchk_btree_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_btree_cur *cur, int level);
+void xchk_btree_set_preen(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
+		int level);
 
 /* Check for btree xref discrepancies. */
 void xchk_btree_xref_set_corrupt(struct xfs_scrub *sc,
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index a039008dc078..215730a9d9bf 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -87,6 +87,58 @@ xchk_rmapbt_xref(
 		xchk_rmapbt_xref_refc(sc, irec);
 }
 
+/*
+ * Check for bogus UNWRITTEN flags in the rmapbt node block keys.
+ *
+ * In reverse mapping records, the file mapping extent state
+ * (XFS_RMAP_OFF_UNWRITTEN) is a record attribute, not a key field.  It is not
+ * involved in lookups in any way.  In older kernels, the functions that
+ * convert rmapbt records to keys forgot to filter out the extent state bit,
+ * even though the key comparison functions have filtered the flag correctly.
+ * If we spot an rmap key with the unwritten bit set in rm_offset, we should
+ * mark the btree as needing optimization to rebuild the btree without those
+ * flags.
+ */
+STATIC void
+xchk_rmapbt_check_unwritten_in_keyflags(
+	struct xchk_btree	*bs)
+{
+	struct xfs_scrub	*sc = bs->sc;
+	struct xfs_btree_cur	*cur = bs->cur;
+	struct xfs_btree_block	*keyblock;
+	union xfs_btree_key	*lkey, *hkey;
+	__be64			badflag = cpu_to_be64(XFS_RMAP_OFF_UNWRITTEN);
+	unsigned int		level;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_PREEN)
+		return;
+
+	for (level = 1; level < cur->bc_nlevels; level++) {
+		struct xfs_buf	*bp;
+		unsigned int	ptr;
+
+		/* Only check the first time we've seen this node block. */
+		if (cur->bc_levels[level].ptr > 1)
+			continue;
+
+		keyblock = xfs_btree_get_block(cur, level, &bp);
+		for (ptr = 1; ptr <= be16_to_cpu(keyblock->bb_numrecs); ptr++) {
+			lkey = xfs_btree_key_addr(cur, ptr, keyblock);
+
+			if (lkey->rmap.rm_offset & badflag) {
+				xchk_btree_set_preen(sc, cur, level);
+				break;
+			}
+
+			hkey = xfs_btree_high_key_addr(cur, ptr, keyblock);
+			if (hkey->rmap.rm_offset & badflag) {
+				xchk_btree_set_preen(sc, cur, level);
+				break;
+			}
+		}
+	}
+}
+
 /* Scrub an rmapbt record. */
 STATIC int
 xchk_rmapbt_rec(
@@ -101,6 +153,7 @@ xchk_rmapbt_rec(
 		return 0;
 	}
 
+	xchk_rmapbt_check_unwritten_in_keyflags(bs);
 	xchk_rmapbt_xref(bs->sc, &irec);
 	return 0;
 }


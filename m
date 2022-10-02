Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3F5C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJBS2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:28:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B39D3BC7B
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0E2B80D22
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C96CC433C1;
        Sun,  2 Oct 2022 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735309;
        bh=KaVVXpRAWgBWL6/OD8p/EixmFmbCTF8s4w9v0mnQizY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BnViCRrWE1Yqj8wIDNMiXlUfS4pO71mqmdva8ntz1KBjoNYRsgIGQPAh2m156kiwC
         m5m/oLQXjAuNmrD6PUma4DabDRi1n0JhasZkmdeElfgZ6xQpWqglJJILS2W9XTijpf
         OnOte378EtU2zV+x1EurgS9aHKhtria386yYLrP0fEEGkVJUAqP2DCq4NFLKTTrtsU
         1mWKB3NebpAvyRPlTVfUtFuDx/XpRIyL1OBXwk8d6ezaM20Y3Pn/KXiMKTxdrYHRFs
         EdYoQfciOlMxi3+1ecjoCr+B7zhdv6f1dDKxv1tKhkh+4cs0Rq6TBmfTmRMYXfc6P3
         ewIVjer1JWDFA==
Subject: [PATCH 2/2] xfs: pivot online scrub away from kmem.[ch]
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:52 -0700
Message-ID: <166473479220.1083296.3091934137369803342.stgit@magnolia>
In-Reply-To: <166473479188.1083296.3778962206344152398.stgit@magnolia>
References: <166473479188.1083296.3778962206344152398.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert all the online scrub code to use the Linux slab allocator
functions directly instead of going through the kmem wrappers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 fs/xfs/scrub/attr.c            |    2 +-
 fs/xfs/scrub/bitmap.c          |   11 ++++++-----
 fs/xfs/scrub/btree.c           |   10 +++++-----
 fs/xfs/scrub/dabtree.c         |    4 ++--
 fs/xfs/scrub/fscounters.c      |    2 +-
 fs/xfs/scrub/refcount.c        |   12 ++++++------
 fs/xfs/scrub/scrub.c           |    6 +++---
 8 files changed, 25 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 82ceb60ea5fc..d75d82151eeb 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -685,7 +685,7 @@ xrep_agfl_init_header(
 		if (br->len)
 			break;
 		list_del(&br->list);
-		kmem_free(br);
+		kfree(br);
 	}
 
 	/* Write new AGFL to disk. */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 11b2593a2be7..31529b9bf389 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -49,7 +49,7 @@ xchk_setup_xattr_buf(
 	if (ab) {
 		if (sz <= ab->sz)
 			return 0;
-		kmem_free(ab);
+		kvfree(ab);
 		sc->buf = NULL;
 	}
 
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index b89bf9de9b1c..a255f09e9f0a 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "scrub/scrub.h"
 #include "scrub/bitmap.h"
 
 /*
@@ -25,7 +26,7 @@ xbitmap_set(
 {
 	struct xbitmap_range	*bmr;
 
-	bmr = kmem_alloc(sizeof(struct xbitmap_range), KM_MAYFAIL);
+	bmr = kmalloc(sizeof(struct xbitmap_range), XCHK_GFP_FLAGS);
 	if (!bmr)
 		return -ENOMEM;
 
@@ -47,7 +48,7 @@ xbitmap_destroy(
 
 	for_each_xbitmap_extent(bmr, n, bitmap) {
 		list_del(&bmr->list);
-		kmem_free(bmr);
+		kfree(bmr);
 	}
 }
 
@@ -174,15 +175,15 @@ xbitmap_disunion(
 			/* Total overlap, just delete ex. */
 			lp = lp->next;
 			list_del(&br->list);
-			kmem_free(br);
+			kfree(br);
 			break;
 		case 0:
 			/*
 			 * Deleting from the middle: add the new right extent
 			 * and then shrink the left extent.
 			 */
-			new_br = kmem_alloc(sizeof(struct xbitmap_range),
-					KM_MAYFAIL);
+			new_br = kmalloc(sizeof(struct xbitmap_range),
+					XCHK_GFP_FLAGS);
 			if (!new_br) {
 				error = -ENOMEM;
 				goto out;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 2f4519590dc1..566a093b2cf3 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -431,10 +431,10 @@ xchk_btree_check_owner(
 	 * later scanning.
 	 */
 	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
-		co = kmem_alloc(sizeof(struct check_owner),
-				KM_MAYFAIL);
+		co = kmalloc(sizeof(struct check_owner), XCHK_GFP_FLAGS);
 		if (!co)
 			return -ENOMEM;
+		INIT_LIST_HEAD(&co->list);
 		co->level = level;
 		co->daddr = xfs_buf_daddr(bp);
 		list_add_tail(&co->list, &bs->to_check);
@@ -649,7 +649,7 @@ xchk_btree(
 		xchk_btree_set_corrupt(sc, cur, 0);
 		return 0;
 	}
-	bs = kmem_zalloc(cur_sz, KM_NOFS | KM_MAYFAIL);
+	bs = kzalloc(cur_sz, XCHK_GFP_FLAGS);
 	if (!bs)
 		return -ENOMEM;
 	bs->cur = cur;
@@ -740,9 +740,9 @@ xchk_btree(
 			error = xchk_btree_check_block_owner(bs, co->level,
 					co->daddr);
 		list_del(&co->list);
-		kmem_free(co);
+		kfree(co);
 	}
-	kmem_free(bs);
+	kfree(bs);
 
 	return error;
 }
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 84fe3d33d699..d17cee177085 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -486,7 +486,7 @@ xchk_da_btree(
 		return 0;
 
 	/* Set up initial da state. */
-	ds = kmem_zalloc(sizeof(struct xchk_da_btree), KM_NOFS | KM_MAYFAIL);
+	ds = kzalloc(sizeof(struct xchk_da_btree), XCHK_GFP_FLAGS);
 	if (!ds)
 		return -ENOMEM;
 	ds->dargs.dp = sc->ip;
@@ -591,6 +591,6 @@ xchk_da_btree(
 
 out_state:
 	xfs_da_state_free(ds->state);
-	kmem_free(ds);
+	kfree(ds);
 	return error;
 }
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 6a6f8fe7f87c..3c56f5890da4 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -116,7 +116,7 @@ xchk_setup_fscounters(
 	struct xchk_fscounters	*fsc;
 	int			error;
 
-	sc->buf = kmem_zalloc(sizeof(struct xchk_fscounters), 0);
+	sc->buf = kzalloc(sizeof(struct xchk_fscounters), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 	fsc = sc->buf;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index c68b767dc08f..f037e73922c1 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -127,8 +127,8 @@ xchk_refcountbt_rmap_check(
 		 * is healthy each rmap_irec we see will be in agbno order
 		 * so we don't need insertion sort here.
 		 */
-		frag = kmem_alloc(sizeof(struct xchk_refcnt_frag),
-				KM_MAYFAIL);
+		frag = kmalloc(sizeof(struct xchk_refcnt_frag),
+				XCHK_GFP_FLAGS);
 		if (!frag)
 			return -ENOMEM;
 		memcpy(&frag->rm, rec, sizeof(frag->rm));
@@ -215,7 +215,7 @@ xchk_refcountbt_process_rmap_fragments(
 				continue;
 			}
 			list_del(&frag->list);
-			kmem_free(frag);
+			kfree(frag);
 			nr++;
 		}
 
@@ -257,11 +257,11 @@ xchk_refcountbt_process_rmap_fragments(
 	/* Delete fragments and work list. */
 	list_for_each_entry_safe(frag, n, &worklist, list) {
 		list_del(&frag->list);
-		kmem_free(frag);
+		kfree(frag);
 	}
 	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
 		list_del(&frag->list);
-		kmem_free(frag);
+		kfree(frag);
 	}
 }
 
@@ -308,7 +308,7 @@ xchk_refcountbt_xref_rmap(
 out_free:
 	list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
 		list_del(&frag->list);
-		kmem_free(frag);
+		kfree(frag);
 	}
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2e8e400f10a9..07a7a75f987f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -174,7 +174,7 @@ xchk_teardown(
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->buf) {
-		kmem_free(sc->buf);
+		kvfree(sc->buf);
 		sc->buf = NULL;
 	}
 	return error;
@@ -467,7 +467,7 @@ xfs_scrub_metadata(
 	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_SCRUB,
  "EXPERIMENTAL online scrub feature in use. Use at your own risk!");
 
-	sc = kmem_zalloc(sizeof(struct xfs_scrub), KM_NOFS | KM_MAYFAIL);
+	sc = kzalloc(sizeof(struct xfs_scrub), XCHK_GFP_FLAGS);
 	if (!sc) {
 		error = -ENOMEM;
 		goto out;
@@ -557,7 +557,7 @@ xfs_scrub_metadata(
 out_teardown:
 	error = xchk_teardown(sc, error);
 out_sc:
-	kmem_free(sc);
+	kfree(sc);
 out:
 	trace_xchk_done(XFS_I(file_inode(file)), sm, error);
 	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {


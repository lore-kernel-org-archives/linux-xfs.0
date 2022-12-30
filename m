Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE22C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbiLaBs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiLaBsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:48:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB241DDD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:48:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C0D61CCE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFBBC433EF;
        Sat, 31 Dec 2022 01:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451329;
        bh=Q1IbYzDfk0/s8h5OwGZ1qFaBJodCHEUMF8ECQRM0QDc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G73kq3Lov5z01S/kYuU6KnrMcEYpa731EsLvfxyMH6ePAFmuTv0LJ0e2Dcy4IAfkl
         m+4VIzT3n8uoR8sxWldRrd8mFADhDRdRzKZIMghlXEv++Fo6dbujkNfU3ITofsKoLK
         JMVfZLExyf0FEm0XYxGoTNA4p+NkRmoK3JHIoHogwzehkRd2HRNb0blWg0oE8xP6yC
         bZoEC8U/f77HrRD5UFBf2oFnjBOFym2ywTm0FaLT4T7F+vD8coEZ5GDcB0TJfZ5tX9
         YIocLTJTc7kzf3EZ7OS/kxdFjRGjv7WCkA7j8m8aeUkoJJs8mUJ/p/MQzLHsUTTd2g
         PzyLrQDdbKQYg==
Subject: [PATCH 03/42] xfs: namespace the maximum length/refcount symbols
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870940.717073.2275494462076625238.stgit@magnolia>
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

Actually namespace these variables properly, so that readers can tell
that this is an XFS symbol, and that it's for the refcount
functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     |    4 ++--
 fs/xfs/libxfs/xfs_refcount.c   |   18 +++++++++---------
 fs/xfs/scrub/refcount.c        |    2 +-
 fs/xfs/scrub/refcount_repair.c |    4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c78fe8e78b8c..c49a946e79f3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1790,8 +1790,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 3d2269c6855a..e1f55edceccf 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -126,7 +126,7 @@ xfs_refcount_check_perag_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
 		return __this_address;
 
 	if (!xfs_refcount_check_domain(irec))
@@ -136,7 +136,7 @@ xfs_refcount_check_perag_irec(
 	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		return __this_address;
 
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
 		return __this_address;
 
 	return NULL;
@@ -860,9 +860,9 @@ xfs_refc_merge_refcount(
 	const struct xfs_refcount_irec	*irec,
 	enum xfs_refc_adjust_op		adjust)
 {
-	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
-	if (irec->rc_refcount == MAXREFCOUNT)
-		return MAXREFCOUNT;
+	/* Once a record hits XFS_REFC_REFCOUNT_MAX, it is pinned forever */
+	if (irec->rc_refcount == XFS_REFC_REFCOUNT_MAX)
+		return XFS_REFC_REFCOUNT_MAX;
 	return irec->rc_refcount + adjust;
 }
 
@@ -905,7 +905,7 @@ xfs_refc_want_merge_center(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount + right->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	*ulenp = ulen;
@@ -940,7 +940,7 @@ xfs_refc_want_merge_left(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -974,7 +974,7 @@ xfs_refc_want_merge_right(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cright->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -1201,7 +1201,7 @@ xfs_refcount_adjust_extents(
 		 * Adjust the reference count and either update the tree
 		 * (incr) or free the blocks (decr).
 		 */
-		if (ext.rc_refcount == MAXREFCOUNT)
+		if (ext.rc_refcount == XFS_REFC_REFCOUNT_MAX)
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 413885eca333..78b52c8a4d7f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -421,7 +421,7 @@ xchk_refcount_mergeable(
 	if (r1->rc_refcount != r2->rc_refcount)
 		return false;
 	if ((unsigned long long)r1->rc_blockcount + r2->rc_blockcount >
-			MAXREFCEXTLEN)
+			XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 539548cdc65a..81709afdd9e6 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -176,7 +176,7 @@ xrep_refc_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
-	irec.rc_refcount = min_t(uint64_t, MAXREFCOUNT, refcount);
+	irec.rc_refcount = min_t(uint64_t, XFS_REFC_REFCOUNT_MAX, refcount);
 
 	error = xrep_refc_check_ext(rr->sc, &irec);
 	if (error)
@@ -415,7 +415,7 @@ xrep_refc_find_refcounts(
 	/*
 	 * Set up a bag to store all the rmap records that we're tracking to
 	 * generate a reference count record.  If the size of the bag exceeds
-	 * MAXREFCOUNT, we clamp rc_refcount.
+	 * XFS_REFC_REFCOUNT_MAX, we clamp rc_refcount.
 	 */
 	error = rcbag_init(sc->mp, sc->xfile_buftarg, &rcstack);
 	if (error)


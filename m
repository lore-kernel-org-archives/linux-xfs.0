Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A73C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiLaCys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbiLaCyp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE401A07F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:54:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 612E2B81E0E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D90C433EF;
        Sat, 31 Dec 2022 02:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455281;
        bh=zRjCPzSDFB5Ghfe9Vjte/V58LSi2L/ofMZG1gidVZKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kEFWhfuOAX0R2TnI/VlpC7vAYo+PGQwn7v7vYlKfeaOKE5wq8nxF7irwBSDL3Vx7Y
         5yibSPmHIfgW12oOO6ISzJBxB2OtQWHgX4S0BOuYayHu6TGZG8S7c23RTIhU0qd5t+
         88bbh0VFZZbukgJzCnSFu8EU17VEBi1wAyKgXzy1qWXEmlxgxOC39CCM+WIH2Lo4Ez
         DD/UNJnQiSrKE3HvdIEM/u68DU4Q7GklJA1m2gGpZq8g078Hjgr6IEMy9cqDd8NWBF
         JtPqoOiS5jqVUU563ZzIzE3RGZHJl9JmrMNEX1PqKWPLl+vrcn3ngCec1brwMwboXB
         SL3XOtYPK6HKQ==
Subject: [PATCH 02/41] xfs: namespace the maximum length/refcount symbols
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:07 -0800
Message-ID: <167243880795.734096.12861685535329482667.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
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
 libxfs/xfs_format.h   |    4 ++--
 libxfs/xfs_refcount.c |   18 +++++++++---------
 repair/rmap.c         |    4 ++--
 repair/scan.c         |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index c78fe8e78b8..c49a946e79f 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1790,8 +1790,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 614525e12e3..e1d8b3c07bd 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -125,7 +125,7 @@ xfs_refcount_check_perag_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
 		return __this_address;
 
 	if (!xfs_refcount_check_domain(irec))
@@ -135,7 +135,7 @@ xfs_refcount_check_perag_irec(
 	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		return __this_address;
 
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
 		return __this_address;
 
 	return NULL;
@@ -859,9 +859,9 @@ xfs_refc_merge_refcount(
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
 
@@ -904,7 +904,7 @@ xfs_refc_want_merge_center(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount + right->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	*ulenp = ulen;
@@ -939,7 +939,7 @@ xfs_refc_want_merge_left(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -973,7 +973,7 @@ xfs_refc_want_merge_right(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cright->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -1200,7 +1200,7 @@ xfs_refcount_adjust_extents(
 		 * Adjust the reference count and either update the tree
 		 * (incr) or free the blocks (decr).
 		 */
-		if (ext.rc_refcount == MAXREFCOUNT)
+		if (ext.rc_refcount == XFS_REFC_REFCOUNT_MAX)
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
diff --git a/repair/rmap.c b/repair/rmap.c
index 9795f0ec577..15a3e2ecaec 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -996,8 +996,8 @@ refcount_emit(
 		agno, agbno, len, nr_rmaps);
 	rlrec.rc_startblock = agbno;
 	rlrec.rc_blockcount = len;
-	if (nr_rmaps > MAXREFCOUNT)
-		nr_rmaps = MAXREFCOUNT;
+	if (nr_rmaps > XFS_REFC_REFCOUNT_MAX)
+		nr_rmaps = XFS_REFC_REFCOUNT_MAX;
 	rlrec.rc_refcount = nr_rmaps;
 	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
diff --git a/repair/scan.c b/repair/scan.c
index 40e8007e698..0ff8afccedc 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1893,7 +1893,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 						break;
 					}
 				}
-			} else if (nr < 2 || nr > MAXREFCOUNT) {
+			} else if (nr < 2 || nr > XFS_REFC_REFCOUNT_MAX) {
 				do_warn(
 	_("invalid reference count %u in record %u of %s btree block %u/%u\n"),
 					nr, i, name, agno, bno);


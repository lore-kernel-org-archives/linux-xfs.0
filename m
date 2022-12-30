Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F81C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiL3Wi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Wi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:38:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67A317E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FE8E61645
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA69C433D2;
        Fri, 30 Dec 2022 22:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439933;
        bh=FbKfhxyKz7Z/tRPVAlnUNmaHwCijbCEOGb3QL5bCJpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XtH8IPICX/vkEtu35O2RCEbwM3lOMQAcq0OJ9N7n6+GpIm6V/JEuNn4tPQX0DCHNh
         7cskPlQxVcIiCMUACM1AK4VhK63tpNHpoQkdDb7DSh0mkWRWEqRIKCoQAZnpqqTIYx
         yQJI1L+8XpLTfzKtgWlsTl7GKf38tBW1CRQnATGvtqKf4cdmSf2sllfmvtETqhNqc6
         8ghX5p333aVzv2oxek1sNJYsIUnGSVGQAObKMeE3sduoD+yWv6Vqfr0TUjQDNCWKYp
         RPncSo3pw2SdoOBtbaCYYvsfszT2fGNFVVQ6XNZRa2ty4dOfP/MxU9WepS3mPMDbSG
         3C3vCn9Yb8DHw==
Subject: [PATCH 4/8] xfs: return a failure address from
 xfs_rmap_irec_offset_unpack
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:11 -0800
Message-ID: <167243827188.683855.7812242391100050024.stgit@magnolia>
In-Reply-To: <167243827121.683855.6049797551028464473.stgit@magnolia>
References: <167243827121.683855.6049797551028464473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_rmap_irec_offset_unpack returns only 0 or -EFSCORRUPTED.
Change this function to return the code address of a failed conversion
in preparation for the next patch, which standardizes localized record
checking and reporting code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |    9 ++++-----
 fs/xfs/libxfs/xfs_rmap.h |    9 +++++----
 fs/xfs/scrub/rmap.c      |   11 +++++------
 3 files changed, 14 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index c2624d11f041..830b38337cd5 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -193,7 +193,7 @@ xfs_rmap_delete(
 }
 
 /* Convert an internal btree record to an rmap record. */
-int
+xfs_failaddr_t
 xfs_rmap_btrec_to_irec(
 	const union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec		*irec)
@@ -2320,11 +2320,10 @@ xfs_rmap_query_range_helper(
 {
 	struct xfs_rmap_query_range_info	*query = priv;
 	struct xfs_rmap_irec			irec;
-	int					error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
-	if (error)
-		return error;
+	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL)
+		return -EFSCORRUPTED;
+
 	return query->fn(cur, &irec, query->priv);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 1472ae570a8a..6a08c403e8b7 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -62,13 +62,14 @@ xfs_rmap_irec_offset_pack(
 	return x;
 }
 
-static inline int
+static inline xfs_failaddr_t
 xfs_rmap_irec_offset_unpack(
 	__u64			offset,
 	struct xfs_rmap_irec	*irec)
 {
 	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
-		return -EFSCORRUPTED;
+		return __this_address;
+
 	irec->rm_offset = XFS_RMAP_OFF(offset);
 	irec->rm_flags = 0;
 	if (offset & XFS_RMAP_OFF_ATTR_FORK)
@@ -77,7 +78,7 @@ xfs_rmap_irec_offset_unpack(
 		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
 	if (offset & XFS_RMAP_OFF_UNWRITTEN)
 		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
-	return 0;
+	return NULL;
 }
 
 static inline void
@@ -192,7 +193,7 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 		const struct xfs_rmap_irec *b);
 union xfs_btree_rec;
-int xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
+xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exists);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index afc4f840b6bc..94650f11a4a5 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -100,11 +100,11 @@ xchk_rmapbt_rec(
 	bool			is_unwritten;
 	bool			is_bmbt;
 	bool			is_attr;
-	int			error;
 
-	error = xfs_rmap_btrec_to_irec(rec, &irec);
-	if (!xchk_btree_process_error(bs->sc, bs->cur, 0, &error))
-		goto out;
+	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
 
 	/* Check extent. */
 	if (irec.rm_startblock + irec.rm_blockcount <= irec.rm_startblock)
@@ -159,8 +159,7 @@ xchk_rmapbt_rec(
 	}
 
 	xchk_rmapbt_xref(bs->sc, &irec);
-out:
-	return error;
+	return 0;
 }
 
 /* Scrub the rmap btree for some AG. */


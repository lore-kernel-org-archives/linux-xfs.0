Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC649C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJBSgG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJBSgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0D736840
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:36:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07F3D60EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673B6C433D6;
        Sun,  2 Oct 2022 18:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735763;
        bh=Qg/RvxHzwGJLaP0y5Bo8XgGcId6apVaGLdq82D5MXxc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YR+oSESLI4Qm5wXOBUq/dlnXR9vt3bseKXr606CXuXs6f1qujxqOf/R7CeQMoa0ON
         RBuQBgZQn9m7BbC0sj613SmuyGCSvJiiB2hechbsc/fmyw+JTMEdQQTic1NO0Pk+OB
         Pu+Xni6AeN2zUgU5CfywO5d0eTHnOSSWZu4kunKmYX6WZqkbZdf+lkGwpicckwSNH8
         TOpXPtXAabfdoEMjzFUzHdm3oDXWDbEgWOhcbhe1D+svzkpjrNnDHazCiV2a8ltNJN
         IPoLFVmxqXEaOBxXaA738+Ds3dA4gJnA8va1gScSPcm0SjlWkWVBn6BS5AS+FvyWoy
         HBfFnjjePikyg==
Subject: [PATCH 4/6] xfs: flag refcount btree records that could be merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483660.1084923.12809453984875476542.stgit@magnolia>
In-Reply-To: <166473483595.1084923.1946295148534639238.stgit@magnolia>
References: <166473483595.1084923.1946295148534639238.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Complain if we encounter refcount btree records that could be merged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/refcount.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 2009efea923c..8282cabd630c 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -333,6 +333,9 @@ xchk_refcountbt_xref(
 }
 
 struct xchk_refcbt_records {
+	/* Previous refcount record. */
+	struct xfs_refcount_irec prev_rec;
+
 	/* The next AG block where we aren't expecting shared extents. */
 	xfs_agblock_t		next_unshared_agbno;
 
@@ -387,6 +390,52 @@ xchk_refcountbt_xref_gaps(
 		xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur);
 }
 
+static inline bool
+xchk_refcount_mergeable(
+	struct xchk_refcbt_records	*rrc,
+	const struct xfs_refcount_irec	*r2)
+{
+	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
+
+	/* Ignore if prev_rec is not yet initialized. */
+	if (r1->rc_blockcount > 0)
+		return false;
+
+	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)
+		return false;
+	if (r1->rc_refcount != r2->rc_refcount)
+		return false;
+	if ((unsigned long long)r1->rc_blockcount + r2->rc_blockcount >
+			MAXREFCEXTLEN)
+		return false;
+
+	return true;
+}
+
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_refcountbt_check_mergeable(
+	struct xchk_btree		*bs,
+	struct xchk_refcbt_records	*rrc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+	struct xfs_refcount_irec	irec = {
+		.rc_startblock		= bno,
+		.rc_blockcount		= len,
+		.rc_refcount		= refcount,
+	};
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (xchk_refcount_mergeable(rrc, &irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&rrc->prev_rec, &irec, sizeof(struct xfs_refcount_irec));
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xchk_refcountbt_rec(
@@ -421,6 +470,7 @@ xchk_refcountbt_rec(
 	if (refcount == 0)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	xchk_refcountbt_check_mergeable(bs, rrc, bno, len, refcount);
 	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
 
 	/*


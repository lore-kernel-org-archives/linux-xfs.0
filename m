Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42224C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiL3Wrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiL3Wrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:47:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAD818E1D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:47:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8021B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EEBC433EF;
        Fri, 30 Dec 2022 22:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440462;
        bh=bhWOl/1vqR0YuHs4vjO3i+h8uUT3KKNKVJPstqBGWiQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p2hTwMg5OLZ+w/2lQ69Z0EnLVpAYDAJv1gORfiwHjGuGQ1yT+i8+QkEd0yAYIwNNR
         dBg4cgBlJj6tD2AsxB4QmZkwNo1zl7ndUH9+3W6NQ+0fqU6ByooTNq/pTw8lrBcvdL
         zNoYzhy6Ed7HU/1gynVUhNCQV7JVZONRLqWUzyi37/C4b+eB+h4khmmHrlreUnhBtc
         2yPthfSAKxLqdQLkC6bjst6l8Fwu1OrAOeJQMCSWZ4UW6LZV/Ct2fPPIYgY+tmd8Gg
         oucZ5MFHFO3oSMQ5C1hb7vd1/e60enHA3Pj6B5DpNu8nFmPA8L0/zDJsIamr1h7+H4
         35F1Pwz26xIpQ==
Subject: [PATCH 4/6] xfs: flag refcount btree records that could be merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:42 -0800
Message-ID: <167243830280.686829.12458104861298123850.stgit@magnolia>
In-Reply-To: <167243830218.686829.12866790282629472160.stgit@magnolia>
References: <167243830218.686829.12866790282629472160.stgit@magnolia>
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
 fs/xfs/scrub/refcount.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index e99c1e1246f8..9d957d2df3e1 100644
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
 
@@ -390,6 +393,46 @@ xchk_refcountbt_xref_gaps(
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
+	if (r1->rc_domain != r2->rc_domain)
+		return false;
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
+	const struct xfs_refcount_irec	*irec)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (xchk_refcount_mergeable(rrc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&rrc->prev_rec, irec, sizeof(struct xfs_refcount_irec));
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xchk_refcountbt_rec(
@@ -414,6 +457,7 @@ xchk_refcountbt_rec(
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	rrc->prev_domain = irec.rc_domain;
 
+	xchk_refcountbt_check_mergeable(bs, rrc, &irec);
 	xchk_refcountbt_xref(bs->sc, &irec);
 
 	/*


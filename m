Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD44C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiL3Wtt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiL3Wts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:49:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E15017890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F93761AC4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AB3C433EF;
        Fri, 30 Dec 2022 22:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440587;
        bh=LqUM//4hsDq1ErTHGHi9N5XdWAys5/EX1/xBSarsw98=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=avyL7D9lVHrp8biagxM1CGoq+oeytMfpRdYTxpS4SEfJAi06r3P5THP8YT6QO2xM3
         lHycBtfJ6GdwAYLNbeV6t62w95xTat3cPI+Pv9o6/0VAVLlEoPeEIQhGOCZgr3ZjVZ
         W2o7+cgPHU+kqQCx+/n/lnqmzZlbeN24Fo8rLpUBPsOMpEuSDpOEhXD+6Sabj9KD2H
         yj/gCMXzuEzcbH8NWoMi6PdumUIy43OlPPUedlktiip8O8XdiE/V6ak23jjDBMWh/A
         XiYxSFQ2OCjU8EId8QIvB1VPDdXY1C/QtQSbcUHTd1MIcGhisXtZL20bHugKwsxs2X
         MLyBeZwmm5qJQ==
Subject: [PATCH 06/11] xfs: split valuebuf from xchk_xattr_buf.buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:46 -0800
Message-ID: <167243830693.687022.11588506062245157795.stgit@magnolia>
In-Reply-To: <167243830598.687022.17067931640967897645.stgit@magnolia>
References: <167243830598.687022.17067931640967897645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the xattr value buffer from somewhere in xchk_xattr_buf.buf[] to an
explicit pointer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   89 +++++++++++++++++++++++++--------------------------
 fs/xfs/scrub/attr.h |   21 ++----------
 2 files changed, 46 insertions(+), 64 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index c343ae932ae3..98371daa1397 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -31,6 +31,9 @@ xchk_xattr_buf_cleanup(
 	ab->freemap = NULL;
 	kvfree(ab->usedmap);
 	ab->usedmap = NULL;
+	kvfree(ab->value);
+	ab->value = NULL;
+	ab->value_sz = 0;
 }
 
 /*
@@ -44,54 +47,45 @@ xchk_setup_xattr_buf(
 	size_t			value_size,
 	gfp_t			flags)
 {
-	size_t			sz = value_size;
 	size_t			bmp_sz;
 	struct xchk_xattr_buf	*ab = sc->buf;
-	unsigned long		*old_usedmap = NULL;
-	unsigned long		*old_freemap = NULL;
+	void			*new_val;
 
 	bmp_sz = sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 
-	/*
-	 * If there's already a buffer, figure out if we need to reallocate it
-	 * to accommodate a larger size.
-	 */
-	if (ab) {
-		if (sz <= ab->sz)
-			return 0;
-		old_freemap = ab->freemap;
-		old_usedmap = ab->usedmap;
-		kvfree(ab);
-		sc->buf = NULL;
-	}
+	if (ab)
+		goto resize_value;
 
-	/*
-	 * Don't zero the buffer upon allocation to avoid runtime overhead.
-	 * All users must be careful never to read uninitialized contents.
-	 */
-	ab = kvmalloc(sizeof(*ab) + sz, flags);
+	ab = kvzalloc(sizeof(struct xchk_xattr_buf), flags);
 	if (!ab)
 		return -ENOMEM;
-	ab->sz = sz;
 	sc->buf = ab;
 	sc->buf_cleanup = xchk_xattr_buf_cleanup;
 
-	if (old_usedmap) {
-		ab->usedmap = old_usedmap;
-	} else {
-		ab->usedmap = kvmalloc(bmp_sz, flags);
-		if (!ab->usedmap)
-			return -ENOMEM;
-	}
+	ab->usedmap = kvmalloc(bmp_sz, flags);
+	if (!ab->usedmap)
+		return -ENOMEM;
+
+	ab->freemap = kvmalloc(bmp_sz, flags);
+	if (!ab->freemap)
+		return -ENOMEM;
 
-	if (old_freemap) {
-		ab->freemap = old_freemap;
-	} else {
-		ab->freemap = kvmalloc(bmp_sz, flags);
-		if (!ab->freemap)
-			return -ENOMEM;
+resize_value:
+	if (ab->value_sz >= value_size)
+		return 0;
+
+	if (ab->value) {
+		kvfree(ab->value);
+		ab->value = NULL;
+		ab->value_sz = 0;
 	}
 
+	new_val = kvmalloc(value_size, flags);
+	if (!new_val)
+		return -ENOMEM;
+
+	ab->value = new_val;
+	ab->value_sz = value_size;
 	return 0;
 }
 
@@ -140,11 +134,24 @@ xchk_xattr_listent(
 	int				namelen,
 	int				valuelen)
 {
+	struct xfs_da_args		args = {
+		.op_flags		= XFS_DA_OP_NOTIME,
+		.attr_filter		= flags & XFS_ATTR_NSP_ONDISK_MASK,
+		.geo			= context->dp->i_mount->m_attr_geo,
+		.whichfork		= XFS_ATTR_FORK,
+		.dp			= context->dp,
+		.name			= name,
+		.namelen		= namelen,
+		.hashval		= xfs_da_hashname(name, namelen),
+		.trans			= context->tp,
+		.valuelen		= valuelen,
+	};
+	struct xchk_xattr_buf		*ab;
 	struct xchk_xattr		*sx;
-	struct xfs_da_args		args = { NULL };
 	int				error = 0;
 
 	sx = container_of(context, struct xchk_xattr, context);
+	ab = sx->sc->buf;
 
 	if (xchk_should_terminate(sx->sc, &error)) {
 		context->seen_enough = error;
@@ -182,17 +189,7 @@ xchk_xattr_listent(
 		return;
 	}
 
-	args.op_flags = XFS_DA_OP_NOTIME;
-	args.attr_filter = flags & XFS_ATTR_NSP_ONDISK_MASK;
-	args.geo = context->dp->i_mount->m_attr_geo;
-	args.whichfork = XFS_ATTR_FORK;
-	args.dp = context->dp;
-	args.name = name;
-	args.namelen = namelen;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
-	args.trans = context->tp;
-	args.value = xchk_xattr_valuebuf(sx->sc);
-	args.valuelen = valuelen;
+	args.value = ab->value;
 
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index f6f033c19118..18445cc3d33b 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -16,24 +16,9 @@ struct xchk_xattr_buf {
 	/* Bitmap of free space in xattr leaf blocks. */
 	unsigned long		*freemap;
 
-	/* Size of @buf, in bytes. */
-	size_t			sz;
-
-	/*
-	 * Memory buffer -- used for extracting attr values while walking the
-	 * attributes.
-	 */
-	uint8_t			buf[];
+	/* Memory buffer used to extract xattr values. */
+	void			*value;
+	size_t			value_sz;
 };
 
-/* A place to store attribute values. */
-static inline uint8_t *
-xchk_xattr_valuebuf(
-	struct xfs_scrub	*sc)
-{
-	struct xchk_xattr_buf	*ab = sc->buf;
-
-	return ab->buf;
-}
-
 #endif	/* __XFS_SCRUB_ATTR_H__ */


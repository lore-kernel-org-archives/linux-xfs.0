Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC23CC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiL3WwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3WwI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:52:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181BC1AA29
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:52:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A70F661B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F1C433EF;
        Fri, 30 Dec 2022 22:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440727;
        bh=GG0Ka0hO9XMSQk2D8JuxouBqjVaQgRIx7SkNYWhQWF8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s3oHnBAoJn2SMWmE53IQ3bk77KiwnmdtnlEvWhbZEMYpTVGlfaX/0mDtLP8WTJwv5
         R52noGusIzg6/Psdi4DLBKxB4LUr6PuK1C6wUS/SXhV00XMSjF49nSFdyY/tVu3+Wm
         wOmpu9Mxjg2Rq/7pzXx2QA4dFeKCxwrmOszcAIG7II69dcS5TshqtqujDq9hpN4u7j
         PWjQNqNeTzHaGI9Gea2niEGeirX3gr4CF6UXFdvf1e7E0Jx2cYnMGAgubjXP1bdpBE
         l1h0pzY7ujunqaLOPIzP43dVdvYxKh+mEt9ii5ldPPTO6OsANL4FUEw289a1aZ36c2
         E4ryIqL3WfVhQ==
Subject: [PATCH 1/5] xfs: introduce bitmap type for AG blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:53 -0800
Message-ID: <167243831389.687445.8815017730004417857.stgit@magnolia>
In-Reply-To: <167243831370.687445.933956691451974089.stgit@magnolia>
References: <167243831370.687445.933956691451974089.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a typechecked bitmap for extents within an AG.  Online repair
uses bitmaps to store various different types of numbers, so let's make
it obvious when we're storing xfs_agblock_t (and later xfs_fsblock_t)
versus anything else.

In subsequent patches, we're going to use agblock bitmaps to enhance the
rmapbt checker to look for discrepancies between the rmapbt records and
AG metadata block usage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bitmap.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h |    1 +
 2 files changed, 49 insertions(+)


diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 7afd64a318d1..7f538effc196 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -39,4 +39,52 @@ int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 
 bool xbitmap_empty(struct xbitmap *bitmap);
 
+/* Bitmaps, but for type-checked for xfs_agblock_t */
+
+struct xagb_bitmap {
+	struct xbitmap	agbitmap;
+};
+
+static inline void xagb_bitmap_init(struct xagb_bitmap *bitmap)
+{
+	xbitmap_init(&bitmap->agbitmap);
+}
+
+static inline void xagb_bitmap_destroy(struct xagb_bitmap *bitmap)
+{
+	xbitmap_destroy(&bitmap->agbitmap);
+}
+
+static inline int xagb_bitmap_clear(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t len)
+{
+	return xbitmap_clear(&bitmap->agbitmap, start, len);
+}
+static inline int xagb_bitmap_set(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t len)
+{
+	return xbitmap_set(&bitmap->agbitmap, start, len);
+}
+
+static inline int xagb_bitmap_disunion(struct xagb_bitmap *bitmap,
+		struct xagb_bitmap *sub)
+{
+	return xbitmap_disunion(&bitmap->agbitmap, &sub->agbitmap);
+}
+
+static inline uint32_t xagb_bitmap_hweight(struct xagb_bitmap *bitmap)
+{
+	return xbitmap_hweight(&bitmap->agbitmap);
+}
+static inline bool xagb_bitmap_empty(struct xagb_bitmap *bitmap)
+{
+	return xbitmap_empty(&bitmap->agbitmap);
+}
+
+static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
+		xbitmap_walk_fn fn, void *priv)
+{
+	return xbitmap_walk(&bitmap->agbitmap, fn, priv);
+}
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 840f74ec431c..150157ac2489 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -31,6 +31,7 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		const struct xfs_buf_ops *ops);
 
 struct xbitmap;
+struct xagb_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
 int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xbitmap *btlist);


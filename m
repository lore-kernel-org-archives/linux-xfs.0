Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3D0C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiJBSg4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJBSgv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C1C3BC71
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08434B80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BC3C433C1;
        Sun,  2 Oct 2022 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735805;
        bh=k2VWo1anlwKV7yCap6dHWuywwAxtCaWHB6o88LEdOYo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pInVFsquCZWz3K3j2epNixTC6C/Vmazjvg/2Z5zz9zzvTwESjQ4rFtgXDZRIwQJhl
         CkXnxzMqayJsNYa9t+Ie5hitJpCjhYfIDsDzdAXyYu+OFz/Ed/srnnPtXHnnjLCMgZ
         JIN5fanRgcsasKrtGlnMu3xa238nkzEF+eEOBRaQIpYHEa5/9/IllH8oVYtmnuMsqd
         dqgOvip37oe6mA1SoyfNpvzs2qbRQ9+3MsHXe+v/4utN34cfpWdGmz3ev+EJagxSTE
         0vof23tdzjOb4pO7oHkadP9/abDsZtAYR2iRtuL2+RZZQecrLzkpbDn+4aqfpbhjru
         Z+gfcp8YNFmhg==
Subject: [PATCH 2/9] xfs: split freemap from xchk_xattr_buf.buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473484025.1085108.11305451681842952737.stgit@magnolia>
In-Reply-To: <166473483982.1085108.101544412199880535.stgit@magnolia>
References: <166473483982.1085108.101544412199880535.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the free space bitmap from somewhere in xchk_xattr_buf.buf[] to an
explicit pointer.  This is the start of removing the complex overloaded
memory buffer that is the source of weird memory misuse bugs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c  |   40 ++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/attr.h  |   15 ++++-----------
 fs/xfs/scrub/scrub.c |    3 +++
 fs/xfs/scrub/scrub.h |   10 ++++++++++
 4 files changed, 49 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a06a3adf72e0..a813e914d966 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -20,6 +20,17 @@
 #include "scrub/dabtree.h"
 #include "scrub/attr.h"
 
+/* Free the buffers linked from the xattr buffer. */
+static void
+xchk_xattr_buf_cleanup(
+	void			*priv)
+{
+	struct xchk_xattr_buf	*ab = priv;
+
+	kvfree(ab->freemap);
+	ab->freemap = NULL;
+}
+
 /*
  * Allocate enough memory to hold an attr value and attr block bitmaps,
  * reallocating the buffer if necessary.  Buffer contents are not preserved
@@ -32,15 +43,18 @@ xchk_setup_xattr_buf(
 	gfp_t			flags)
 {
 	size_t			sz;
+	size_t			bmp_sz;
 	struct xchk_xattr_buf	*ab = sc->buf;
+	unsigned long		*old_freemap = NULL;
+
+	bmp_sz = sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 
 	/*
 	 * We need enough space to read an xattr value from the file or enough
-	 * space to hold two copies of the xattr free space bitmap.  We don't
+	 * space to hold one copy of the xattr free space bitmap.  We don't
 	 * need the buffer space for both purposes at the same time.
 	 */
-	sz = 2 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
-	sz = max_t(size_t, sz, value_size);
+	sz = max_t(size_t, bmp_sz, value_size);
 
 	/*
 	 * If there's already a buffer, figure out if we need to reallocate it
@@ -49,6 +63,7 @@ xchk_setup_xattr_buf(
 	if (ab) {
 		if (sz <= ab->sz)
 			return 0;
+		old_freemap = ab->freemap;
 		kvfree(ab);
 		sc->buf = NULL;
 	}
@@ -60,9 +75,18 @@ xchk_setup_xattr_buf(
 	ab = kvmalloc(sizeof(*ab) + sz, flags);
 	if (!ab)
 		return -ENOMEM;
-
 	ab->sz = sz;
 	sc->buf = ab;
+	sc->buf_cleanup = xchk_xattr_buf_cleanup;
+
+	if (old_freemap) {
+		ab->freemap = old_freemap;
+	} else {
+		ab->freemap = kvmalloc(bmp_sz, flags);
+		if (!ab->freemap)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -216,21 +240,21 @@ xchk_xattr_check_freemap(
 	unsigned long			*map,
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
 {
-	unsigned long			*freemap = xchk_xattr_freemap(sc);
+	struct xchk_xattr_buf		*ab = sc->buf;
 	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
 	int				i;
 
 	/* Construct bitmap of freemap contents. */
-	bitmap_zero(freemap, mapsize);
+	bitmap_zero(ab->freemap, mapsize);
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
-		if (!xchk_xattr_set_map(sc, freemap,
+		if (!xchk_xattr_set_map(sc, ab->freemap,
 				leafhdr->freemap[i].base,
 				leafhdr->freemap[i].size))
 			return false;
 	}
 
 	/* Look for bits that are set in freemap and are marked in use. */
-	return !bitmap_intersects(freemap, map, mapsize);
+	return !bitmap_intersects(ab->freemap, map, mapsize);
 }
 
 /*
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index be133e0da71b..e6f11d44e84d 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -10,6 +10,9 @@
  * Temporary storage for online scrub and repair of extended attributes.
  */
 struct xchk_xattr_buf {
+	/* Bitmap of free space in xattr leaf blocks. */
+	unsigned long		*freemap;
+
 	/* Size of @buf, in bytes. */
 	size_t			sz;
 
@@ -20,8 +23,7 @@ struct xchk_xattr_buf {
 	 *
 	 * Each bitmap contains enough bits to track every byte in an attr
 	 * block (rounded up to the size of an unsigned long).  The attr block
-	 * used space bitmap starts at the beginning of the buffer; the free
-	 * space bitmap follows immediately after.
+	 * used space bitmap starts at the beginning of the buffer.
 	 */
 	uint8_t			buf[];
 };
@@ -46,13 +48,4 @@ xchk_xattr_usedmap(
 	return (unsigned long *)ab->buf;
 }
 
-/* A bitmap of free space computed by walking attr leaf block free info. */
-static inline unsigned long *
-xchk_xattr_freemap(
-	struct xfs_scrub	*sc)
-{
-	return xchk_xattr_usedmap(sc) +
-			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
-}
-
 #endif	/* __XFS_SCRUB_ATTR_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index bc9638c7a379..6697f5f32106 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -189,7 +189,10 @@ xchk_teardown(
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->buf) {
+		if (sc->buf_cleanup)
+			sc->buf_cleanup(sc->buf);
 		kvfree(sc->buf);
+		sc->buf_cleanup = NULL;
 		sc->buf = NULL;
 	}
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 20e74179d8a7..5d6e9a9527c3 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -77,7 +77,17 @@ struct xfs_scrub {
 	 */
 	struct xfs_inode		*ip;
 
+	/* Kernel memory buffer used by scrubbers; freed at teardown. */
 	void				*buf;
+
+	/*
+	 * Clean up resources owned by whatever is in the buffer.  Cleanup can
+	 * be deferred with this hook as a means for scrub functions to pass
+	 * data to repair functions.  This function must not free the buffer
+	 * itself.
+	 */
+	void				(*buf_cleanup)(void *buf);
+
 	uint				ilock_flags;
 
 	/* See the XCHK/XREP state flags below. */


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF42C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiL3WtS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiL3WtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:49:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF80C17890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:49:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E2A461B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5C8C433EF;
        Fri, 30 Dec 2022 22:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440556;
        bh=4a138goNjoPbpknXXH+7KQnPl0mC5lw50nIxB4rZz3A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P7Tm12UTH2h6pSCg3eH1fvZ7HxPLq3QkFIJ6J+ITt+vEWlr0wNT5bNRpv+KpmAmkL
         gphtHmIKRGHHVb9kObONsWkZJgx5Fdw9Ml/wvanr84jpZwkPUdBJKM0faP41vaXSPh
         Y8wAI79z36oRpIOyrDGxOl1CvclD0CWcYrspC0L93RQkfIvALBy8LBQX2lsPlKCWh1
         RYiar8SMGhkwv4gjktWZxfu4krSItwc/3HLYIGMTslEP3P5hjJmD8GNrkW2lWzXJ0I
         dBl3ZBgUcqhm8YCiTLTuk/j5kCIxsbqfhK0g7jZQlci9pSEbrDDZD9pM+5Id9Dy8Gr
         76ApSywlj1dcg==
Subject: [PATCH 04/11] xfs: split freemap from xchk_xattr_buf.buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:46 -0800
Message-ID: <167243830665.687022.13526373311629376767.stgit@magnolia>
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
index 6cd0ae99c2c5..fed159aba6e2 100644
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
 
@@ -222,21 +246,21 @@ xchk_xattr_check_freemap(
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


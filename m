Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A59C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiL3WtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiL3WtE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:49:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2509E17890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:49:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB92B81D95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7632DC433EF;
        Fri, 30 Dec 2022 22:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440540;
        bh=a/7nOQeSx/A/1bJixJqJWCVpfUw6V+/zIiK+q3yrMjU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jlqVS+30kqzVevmnOgb38nqhL1ucTHEZAecFj9ncQzho1nqcDl0isfXqPKfiqxrd1
         cI0ZmC2scwWQ2idRwdFeqC8DnQsswosHRHISW3/vk7KFz/iXI/bvZ0zlqqe9MkFvnG
         BORmpAOkbBqTTlCugerIyN/taBenN2wPwma2l/MUbgx0/0EC5WGkMsnlm8KG961YZH
         Qw27RL7J+2cdkLxqxW8lsM7mzjMb3a33Lpe/KsgHlsFzxe+dut8SMo36DCF+qUm7vL
         gL85llXcyG5Vh4/jMeVC47NBsNlweQlVU79pg8gA1lb5cKWUmvhmJbVunwi5M2YhiL
         D6Hgfv3XVel3w==
Subject: [PATCH 03/11] xfs: remove unnecessary dstmap in xattr scrubber
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:46 -0800
Message-ID: <167243830651.687022.10556281627856680898.stgit@magnolia>
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

Replace bitmap_and with bitmap_intersects in the xattr leaf block
scrubber, since we only care if there's overlap between the used space
bitmap and the free space bitmap.  This means we don't need dstmap any
more, and can thus reduce the memory requirements.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |    7 +++----
 fs/xfs/scrub/attr.h |   12 +-----------
 2 files changed, 4 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 3020892b796e..6cd0ae99c2c5 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -36,10 +36,10 @@ xchk_setup_xattr_buf(
 
 	/*
 	 * We need enough space to read an xattr value from the file or enough
-	 * space to hold three copies of the xattr free space bitmap.  We don't
+	 * space to hold two copies of the xattr free space bitmap.  We don't
 	 * need the buffer space for both purposes at the same time.
 	 */
-	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
+	sz = 2 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 	sz = max_t(size_t, sz, value_size);
 
 	/*
@@ -223,7 +223,6 @@ xchk_xattr_check_freemap(
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
 {
 	unsigned long			*freemap = xchk_xattr_freemap(sc);
-	unsigned long			*dstmap = xchk_xattr_dstmap(sc);
 	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
 	int				i;
 
@@ -237,7 +236,7 @@ xchk_xattr_check_freemap(
 	}
 
 	/* Look for bits that are set in freemap and are marked in use. */
-	return bitmap_and(dstmap, freemap, map, mapsize) == 0;
+	return !bitmap_intersects(freemap, map, mapsize);
 }
 
 /*
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index 3590e10e3e62..be133e0da71b 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -21,8 +21,7 @@ struct xchk_xattr_buf {
 	 * Each bitmap contains enough bits to track every byte in an attr
 	 * block (rounded up to the size of an unsigned long).  The attr block
 	 * used space bitmap starts at the beginning of the buffer; the free
-	 * space bitmap follows immediately after; and we have a third buffer
-	 * for storing intermediate bitmap results.
+	 * space bitmap follows immediately after.
 	 */
 	uint8_t			buf[];
 };
@@ -56,13 +55,4 @@ xchk_xattr_freemap(
 			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 }
 
-/* A bitmap used to hold temporary results. */
-static inline unsigned long *
-xchk_xattr_dstmap(
-	struct xfs_scrub	*sc)
-{
-	return xchk_xattr_freemap(sc) +
-			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
-}
-
 #endif	/* __XFS_SCRUB_ATTR_H__ */


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A1EC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJBSgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJBSgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:36:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1FF3B949
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BC0BB80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AE9C433D6;
        Sun,  2 Oct 2022 18:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735795;
        bh=vRqPa3b80E2x5fIGfH0UHFMIWb1KJTqNKaWTjD4rNnA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uGUdkT3zwwN//rI/lq3TMahABAIJbijWD4Jdjy5/6dYIQi9cjInroW2aH3aNiQuwQ
         +yN98312c3OTuHMkzc85BbrdT3fTVjCE+t/jf183vkNy8+F5D3Oi/lmJbLN27r2TOe
         su7AjBhUQ8XgkMPiHHOIok78G8vHGMjKNIRwdwp59du0a0H0mAJJu6zXlgAjk/ePlp
         7/RsrlmKYYwMxCe6oTO+N5Pfg6CqJiRAx87VMKouS9xLKUwT6iYMMfAWTt3xhnxnXt
         lrAeED0CI+ef7cb6uONz9dX/F44J/jIGCzydNn1yCjBp9oM2zOCGzQ3d9Dwlc4SN1R
         5nUM+Oji5Pr9g==
Subject: [PATCH 1/9] xfs: remove unnecessary dstmap in xattr scrubber
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473484011.1085108.17228408060261689272.stgit@magnolia>
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
index 31529b9bf389..a06a3adf72e0 100644
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
@@ -217,7 +217,6 @@ xchk_xattr_check_freemap(
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
 {
 	unsigned long			*freemap = xchk_xattr_freemap(sc);
-	unsigned long			*dstmap = xchk_xattr_dstmap(sc);
 	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
 	int				i;
 
@@ -231,7 +230,7 @@ xchk_xattr_check_freemap(
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


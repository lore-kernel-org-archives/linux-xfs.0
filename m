Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE72AC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiL3WvI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3WvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724B4BC3F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2711AB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1D7C433D2;
        Fri, 30 Dec 2022 22:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440664;
        bh=w9ck7W498vYxlsCSEbsjK9C/WeHqaK13TlWWhEyEv1c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IY9NMbIEaeymL9qu1QfkD4u61uId0jjReSRBbpt1rVNvaIZaX6p6tz/6XClEcXQvg
         ltTj5vg+eBuLMpIiT3TPL7HAsGtG4gF5TGtENYV4/GJZl+knRp4cMDtR9yE1qXXVcI
         1xLXxHSLdWZPherMIOwFFhhPE+8jDJqgpb1jORgHYh6ZSTFGoOHBERH5SUQ99nJ2y0
         ROFNpg72WjQ29HGQUq8zZd6Q9xMl6aaffxJlzRtuNvvIvTp8NIwkJ8ApYbqjQ0cgMG
         2IpceiFLrffgsK137UEr6XCDrPif9GkEQbDdanIb0/cZXho+KX+eb7enLywrAPEBhP
         PWv2arCkD4roQ==
Subject: [PATCH 11/11] xfs: only allocate free space bitmap for xattr scrub if
 needed
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:47 -0800
Message-ID: <167243830759.687022.9978671103538899221.stgit@magnolia>
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

The free space bitmap is only required if we're going to check the
bestfree space at the end of an xattr leaf block.  Therefore, we can
reduce the memory requirements of this scrubber if we can determine that
the xattr is in short format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ea4a723f175c..ea9d0f1a6fd0 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -37,6 +37,29 @@ xchk_xattr_buf_cleanup(
 	ab->value_sz = 0;
 }
 
+/*
+ * Allocate the free space bitmap if we're trying harder; there are leaf blocks
+ * in the attr fork; or we can't tell if there are leaf blocks.
+ */
+static inline bool
+xchk_xattr_want_freemap(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+
+	if (sc->flags & XCHK_TRY_HARDER)
+		return true;
+
+	if (!sc->ip)
+		return true;
+
+	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
+	if (!ifp)
+		return false;
+
+	return xfs_ifork_has_extents(ifp);
+}
+
 /*
  * Allocate enough memory to hold an attr value and attr block bitmaps,
  * reallocating the buffer if necessary.  Buffer contents are not preserved
@@ -66,9 +89,11 @@ xchk_setup_xattr_buf(
 	if (!ab->usedmap)
 		return -ENOMEM;
 
-	ab->freemap = kvmalloc(bmp_sz, XCHK_GFP_FLAGS);
-	if (!ab->freemap)
-		return -ENOMEM;
+	if (xchk_xattr_want_freemap(sc)) {
+		ab->freemap = kvmalloc(bmp_sz, XCHK_GFP_FLAGS);
+		if (!ab->freemap)
+			return -ENOMEM;
+	}
 
 resize_value:
 	if (ab->value_sz >= value_size)


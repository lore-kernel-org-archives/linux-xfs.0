Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03C5C0015E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbjGNOmo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbjGNOmn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:42:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4660130E8
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A20CF61D30
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0756CC433C7;
        Fri, 14 Jul 2023 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345757;
        bh=K23bJFCGkKB1J84q0TsjqBbL87WZJJj3kir0stOwC7g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jDjFJcSSuOeaKCwfHXjSg/OJUrM2V/bw3zRa1UBss3ZPYnA8gVk3nZh8vyMsFu40W
         lCn6Z6RbzHQw8mPkM+MKyiPGPnJ/cxY2QQ8TeZnLy176+tLtOTzeJUY8gSx2+O9pXv
         dOhBLEnEw4hDVsm10h0OfCxX5yvN6+VHdFg/70rJBSVfbD5Fbf7/AoY4bWb6iLSoyq
         P2xnYBvXMNCjADJ6DOIj0cMTdJqLNNYafODXQKDKC/6fwW3M/p7XpP2VLMoZ9itZTp
         y6vyysCkb089XoTtv37r05z+lHwl2FN9d66/e44msPWLVKBu1P+q2dPJNGau2uzzMi
         xLyoIHWU9C+Jg==
Subject: [PATCH 3/3] xfs: convert flex-array declarations in xfs attr
 shortform objects
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, keescook@chromium.org
Date:   Fri, 14 Jul 2023 07:42:36 -0700
Message-ID: <168934575659.3353217.14415944789032059368.stgit@frogsfrogsfrogs>
In-Reply-To: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
References: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As of 6.5-rc1, UBSAN trips over the ondisk extended attribute shortform
definitions using an array length of 1 to pretend to be a flex array.
Kernel compilers have to support unbounded array declarations, so let's
correct this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |    2 +-
 fs/xfs/xfs_ondisk.h           |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b2362717c42e..f9015f88eca7 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -591,7 +591,7 @@ struct xfs_attr_shortform {
 		uint8_t valuelen;	/* actual length of value (no NULL) */
 		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
 		uint8_t nameval[];	/* name & value bytes concatenated */
-	} list[1];			/* variable sized array */
+	} list[];			/* variable sized array */
 };
 
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 37be297f2532..c4cc99b70dd3 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -89,6 +89,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_shortform,	4);
 	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
 	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
 	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64ADBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiLaAUv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiLaAUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:20:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F42FDC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 825B2B81E7C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A37AC433EF;
        Sat, 31 Dec 2022 00:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446047;
        bh=bD2V3BTuxSFusMFiFgyhwKJNs+qlpCVstsgM2WVg4L8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E0zQqNhxZHo/FfFOqcPiHBe4rbjAJ0neW9AKzqio2Vzmx0lFdaL+mT40Rfr4u0efZ
         VGARm2TX4PU/8+yRDprPsIDEOXl33N+O6PtuCq6ZEqaSXhoaaYhuENSTqszspjqFw7
         zXBFTkqi1l19yfR0hgGm68RUdrJN8S5tpTwRkZ+0CS8RiUkrLJU5uiN7JKoLTTvQtt
         0NY+iB6VO1cH3weMPwdtf24Y6GJ51TZMwqvW2+8fYPnEdMR8y64UYubv23ylc2Q+47
         fLWU1Otji6Od1erF9yWr77DqqPLbhq8KD2woR7cO6YtfeF0hHreA1/H34ci8vY29Hw
         JixO1U2apsgRA==
Subject: [PATCH 08/19] xfs: condense directories after an atomic swap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868043.713817.545115454682669498.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The previous commit added a new swapext flag that enables us to perform
post-swap processing on file2 once we're done swapping the extent maps.
Now add this ability for directories.

This isn't used anywhere right now, but we need to have the basic ondisk
flags in place so that a future online directory repair feature can
create salvaged dirents in a temporary directory and swap the data forks
when ready.  If one file is in extents format and the other is inline,
we will have to promote both to extents format to perform the swap.
After the swap, we can try to condense the fixed directory down to
inline format if possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_swapext.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 68aa34de0ed..cb5bafe3112 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -25,6 +25,8 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -383,6 +385,42 @@ xfs_swapext_attr_to_sf(
 	return xfs_attr3_leaf_to_shortform(bp, &args, forkoff);
 }
 
+/* Convert inode2's block dir fork back to shortform, if possible.. */
+STATIC int
+xfs_swapext_dir_to_sf(
+	struct xfs_trans		*tp,
+	struct xfs_swapext_intent	*sxi)
+{
+	struct xfs_da_args	args = {
+		.dp		= sxi->sxi_ip2,
+		.geo		= tp->t_mountp->m_dir_geo,
+		.whichfork	= XFS_DATA_FORK,
+		.trans		= tp,
+	};
+	struct xfs_dir2_sf_hdr	sfh;
+	struct xfs_buf		*bp;
+	bool			isblock;
+	int			size;
+	int			error;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (!isblock)
+		return 0;
+
+	error = xfs_dir3_block_read(tp, sxi->sxi_ip2, &bp);
+	if (error)
+		return error;
+
+	size = xfs_dir2_block_sfsize(sxi->sxi_ip2, bp->b_addr, &sfh);
+	if (size > xfs_inode_data_fork_size(sxi->sxi_ip2))
+		return 0;
+
+	return xfs_dir2_block_to_sf(&args, bp, size, &sfh);
+}
+
 static inline void
 xfs_swapext_clear_reflink(
 	struct xfs_trans	*tp,
@@ -405,6 +443,8 @@ xfs_swapext_do_postop_work(
 
 		if (sxi->sxi_flags & XFS_SWAP_EXT_ATTR_FORK)
 			error = xfs_swapext_attr_to_sf(tp, sxi);
+		else if (S_ISDIR(VFS_I(sxi->sxi_ip2)->i_mode))
+			error = xfs_swapext_dir_to_sf(tp, sxi);
 		sxi->sxi_flags &= ~XFS_SWAP_EXT_CVT_INO2_SF;
 		if (error)
 			return error;
@@ -1059,7 +1099,9 @@ xfs_swapext(
 	if (req->req_flags & XFS_SWAP_REQ_SET_SIZES)
 		ASSERT(req->whichfork == XFS_DATA_FORK);
 	if (req->req_flags & XFS_SWAP_REQ_CVT_INO2_SF)
-		ASSERT(req->whichfork == XFS_ATTR_FORK);
+		ASSERT(req->whichfork == XFS_ATTR_FORK ||
+		       (req->whichfork == XFS_DATA_FORK &&
+			S_ISDIR(VFS_I(req->ip2)->i_mode)));
 
 	if (req->blockcount == 0)
 		return;


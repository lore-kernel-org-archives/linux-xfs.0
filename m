Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4E8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiLaBku (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiLaBkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:40:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7C026D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC4E861C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428D5C433D2;
        Sat, 31 Dec 2022 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450845;
        bh=qFzBq/EhLNaFDw7ysmqIEQRQVG0sBNIcnbwfHVz8riQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Wi0TS5dyTqwB73mHdUMKgM8LSPdC/6K0dtsc4tcxIDlQGxUUrbK8gv2yEw4ondrFt
         cInaghU/Z8Bg6mtLaGLYDIvdjvk0X0UAAUzmnZ+2MVUYzQ/I894KoqZwVQsAcDKiRe
         8TjUVtyy7NqkSv0QJlagHMnkLIN9J2X8tbYn3v70hlxTOF8pDP/aEbkMLmHGVxXwfY
         os1yDmKVghDDV99S/yIupXQVKjje72IcjrL/u0nZ/TkbOyEonUyNIcK5gbMUnKsrMN
         ifCYRCnMZBN2m/s4o9a65SLR1PSdSCYbCraiyd4p7qhE9wrBlVb40BwAw9FGGAYikO
         v3deg1H8zFBSA==
Subject: [PATCH 15/38] xfs: use realtime EFI to free extents when realtime
 rmap is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869812.715303.10166820015058214253.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When rmap is enabled, XFS expects a certain order of operations, which
is: 1) remove the file mapping, 2) remove the reverse mapping, and then
3) free the blocks.  xfs_bmap_del_extent_real tries to do 1 and 3 in the
same transaction, which means that when rtrmap is enabled, we have to
use realtime EFIs to maintain the expected order.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2e93b018d150..8c683db35788 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5094,7 +5094,6 @@ xfs_bmap_del_extent_real(
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
 	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
@@ -5108,6 +5107,8 @@ xfs_bmap_del_extent_real(
 	uint			qfield;	/* quota field to update */
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
+	bool			want_free = !(bflags & XFS_BMAPI_REMAP);
 
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -5138,17 +5139,24 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	flags = XFS_ILOG_CORE;
-	if (xfs_ifork_is_realtime(ip, whichfork)) {
-		if (!(bflags & XFS_BMAPI_REMAP)) {
+	if (isrt) {
+		/*
+		 * Historically, we did not use EFIs to free realtime extents.
+		 * However, when reverse mapping is enabled, we must maintain
+		 * the same order of operations as the data device, which is:
+		 * Remove the file mapping, remove the reverse mapping, and
+		 * then free the blocks.  This means that we must delay the
+		 * freeing until after we've scheduled the rmap update.
+		 */
+		if (want_free && !xfs_has_rtrmapbt(mp)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
 				goto done;
+			want_free = false;
 		}
-		do_fx = 0;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
-		do_fx = 1;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
 	nblks = del->br_blockcount;
@@ -5303,7 +5311,7 @@ xfs_bmap_del_extent_real(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
+	if (want_free) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
@@ -5312,6 +5320,8 @@ xfs_bmap_del_extent_real(
 			if ((bflags & XFS_BMAPI_NODISCARD) ||
 			    del->br_state == XFS_EXT_UNWRITTEN)
 				efi_flags |= XFS_FREE_EXTENT_SKIP_DISCARD;
+			if (isrt)
+				efi_flags |= XFS_FREE_EXTENT_REALTIME;
 
 			xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL, efi_flags);


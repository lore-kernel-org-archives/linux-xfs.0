Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E116C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiLaCp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiLaCpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:45:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E2C2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 547A7B81E5F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1903C433EF;
        Sat, 31 Dec 2022 02:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454721;
        bh=a3MrX4OXQLhPs8xMhkg3eQxsgDkLGbPAZ5XKCRW9n/A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uYmLvVyv8DXQI8phQGk1Y9XJkSj5Va1AVccsyIhhI/7CBJ0ruT/KvSAbP9l5gwgwL
         VDMHmt6SmlWie76eULySFpUzEiG3KWzUWI8rOy3904P76IV92mFzLSyug7ZHmEr1WH
         Q2PodWPzUWH2hpb+vaOV+nki/8cb8trSQ7SroAGuZi8KYe1U3EmxxH/IPxhx2QAr24
         RUoA3hqReO3zYKQW66tPUBk+0ZlhaFeJPeEZP57SDEqQh6Aqu0sR8fvvNEEgsr3wZE
         bUciHjSqcwPoJg4vO+ylm8S+IWbXQWS6+6trfOux5MuNlJox7lINh2XZm/zFIUDJZr
         UmhsCL6sVfFZg==
Subject: [PATCH 11/41] xfs: use realtime EFI to free extents when realtime
 rmap is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879742.732820.936671687151775416.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
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
 libxfs/xfs_bmap.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c6cfef01eea..d0588d3fa70 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5088,7 +5088,6 @@ xfs_bmap_del_extent_real(
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
-	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
 	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
@@ -5102,6 +5101,8 @@ xfs_bmap_del_extent_real(
 	uint			qfield;	/* quota field to update */
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
+	bool			isrt = xfs_ifork_is_realtime(ip, whichfork);
+	bool			want_free = !(bflags & XFS_BMAPI_REMAP);
 
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -5132,17 +5133,24 @@ xfs_bmap_del_extent_real(
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
@@ -5297,7 +5305,7 @@ xfs_bmap_del_extent_real(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
+	if (want_free) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
 			xfs_refcount_decrease_extent(tp, del);
 		} else {
@@ -5306,6 +5314,8 @@ xfs_bmap_del_extent_real(
 			if ((bflags & XFS_BMAPI_NODISCARD) ||
 			    del->br_state == XFS_EXT_UNWRITTEN)
 				efi_flags |= XFS_FREE_EXTENT_SKIP_DISCARD;
+			if (isrt)
+				efi_flags |= XFS_FREE_EXTENT_REALTIME;
 
 			xfs_free_extent_later(tp, del->br_startblock,
 					del->br_blockcount, NULL, efi_flags);


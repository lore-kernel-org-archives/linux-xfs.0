Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4BBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiL3WrI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiL3Wq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A48317890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:46:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44E10B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D22C433EF;
        Fri, 30 Dec 2022 22:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440416;
        bh=lRmzW831AgzWH7QEVXvhpQOyYhWQEd3nSrKhZI6YT30=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=agKzvnEh3s7EyT0H+It6NahboOYwi5xqjlVgGZQ+i4s3elh8LIpHjH6WWGc63Fpcs
         IcQP7BfswVjPgp9SPQu6pcJ/rHse2TFAKPVkzN1LpIKJg8P2d7FloQTqKkoRcEZuw0
         7Ec2cBhTtz2rZgbOuAiaQ7Z6TvXdH6VLn3MuwmR7FGhNSHmLXGbYklkpLHi9ZfFwwR
         bs+Rl7oUqHdcjbfIm92NgBAu6RkFJcwpBGNJDjSHZPVDTA3W7pGH99hHBDji5951hQ
         16rTobmOD+pEqVys2Nu4pvlC+D0rITY055/I+ZeBk9p85MavE/r1bLs3TEIVfLXER8
         vfwCBG0DUdw1w==
Subject: [PATCH 1/6] xfs: change bmap scrubber to store the previous mapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:42 -0800
Message-ID: <167243830238.686829.9730650982373010333.stgit@magnolia>
In-Reply-To: <167243830218.686829.12866790282629472160.stgit@magnolia>
References: <167243830218.686829.12866790282629472160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the inode data/attr/cow fork scrubber to remember the entire
previous mapping, not just the next expected offset.  No behavior
changes here, but this will enable some better checking in subsequent
patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fe13da54e133..14fe461cac4c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -94,7 +94,8 @@ xchk_setup_inode_bmap(
 struct xchk_bmap_info {
 	struct xfs_scrub	*sc;
 	struct xfs_iext_cursor	icur;
-	xfs_fileoff_t		lastoff;
+	struct xfs_bmbt_irec	prev_rec;
+
 	bool			is_rt;
 	bool			is_shared;
 	bool			was_loaded;
@@ -402,7 +403,8 @@ xchk_bmap_iextent(
 	 * Check for out-of-order extents.  This record could have come
 	 * from the incore list, for which there is no ordering check.
 	 */
-	if (irec->br_startoff < info->lastoff)
+	if (irec->br_startoff < info->prev_rec.br_startoff +
+				info->prev_rec.br_blockcount)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -709,7 +711,8 @@ xchk_bmap_iextent_delalloc(
 	 * Check for out-of-order extents.  This record could have come
 	 * from the incore list, for which there is no ordering check.
 	 */
-	if (irec->br_startoff < info->lastoff)
+	if (irec->br_startoff < info->prev_rec.br_startoff +
+				info->prev_rec.br_blockcount)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -803,7 +806,6 @@ xchk_bmap(
 		goto out;
 
 	/* Scrub extent records. */
-	info.lastoff = 0;
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	for_each_xfs_iext(ifp, &info.icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
@@ -820,7 +822,7 @@ xchk_bmap(
 			xchk_bmap_iextent_delalloc(ip, &info, &irec);
 		else
 			xchk_bmap_iextent(ip, &info, &irec);
-		info.lastoff = irec.br_startoff + irec.br_blockcount;
+		memcpy(&info.prev_rec, &irec, sizeof(struct xfs_bmbt_irec));
 	}
 
 	error = xchk_bmap_check_rmaps(sc, whichfork);


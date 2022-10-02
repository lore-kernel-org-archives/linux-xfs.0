Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C0AC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJBSff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJBSfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:35:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462532A956
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:35:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F64360F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98D4C433D6;
        Sun,  2 Oct 2022 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735731;
        bh=UBkf+Qtv+Qc5Zqh3Kys0oOebeY2eO+WGm9sAAvAu3GE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CotHJ7MOQgegByFqCirrBCKMymTtjw1eo/AviSmKvnWsSe1Lq7HSs9dICmsq7nVvD
         R6kEW27NhShSlKt8fuV13pP8Zm8AaN2dKJZjdbs1cWDY1mEqQ1R8ThNpgUV2XskXQz
         7BUgLciyOgCxBgqYH5er/xotc2h+3rrv+Qw+Xzl4W0ddeQGwL5bnOovP7wl0w6nG3d
         YQ1+UZ4k3cNndVOBtMVshUSPOALcPqybcEsjcdnIW1uDWTtDihztAX+f/5tQBSHD9y
         GS1V9eiWPqfA0hym8y3eLsfF4kif/f2Im1jCJ9zjgNHUMwnSCxsc7D8uev7eTO671f
         7CqDmgPX7lOxw==
Subject: [PATCH 1/6] xfs: change bmap scrubber to store the previous mapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483619.1084923.6959896326767155292.stgit@magnolia>
In-Reply-To: <166473483595.1084923.1946295148534639238.stgit@magnolia>
References: <166473483595.1084923.1946295148534639238.stgit@magnolia>
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
index d310f74fe650..aaa73a2bdd17 100644
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
 
@@ -703,7 +705,8 @@ xchk_bmap_iextent_delalloc(
 	 * Check for out-of-order extents.  This record could have come
 	 * from the incore list, for which there is no ordering check.
 	 */
-	if (irec->br_startoff < info->lastoff)
+	if (irec->br_startoff < info->prev_rec.br_startoff +
+				info->prev_rec.br_blockcount)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
@@ -797,7 +800,6 @@ xchk_bmap(
 		goto out;
 
 	/* Scrub extent records. */
-	info.lastoff = 0;
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	for_each_xfs_iext(ifp, &info.icur, &irec) {
 		if (xchk_should_terminate(sc, &error) ||
@@ -814,7 +816,7 @@ xchk_bmap(
 			xchk_bmap_iextent_delalloc(ip, &info, &irec);
 		else
 			xchk_bmap_iextent(ip, &info, &irec);
-		info.lastoff = irec.br_startoff + irec.br_blockcount;
+		memcpy(&info.prev_rec, &irec, sizeof(struct xfs_bmbt_irec));
 	}
 
 	error = xchk_bmap_check_rmaps(sc, whichfork);


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D36BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiLaBwO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiLaBwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:52:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4061DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:52:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB24B61CCE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4348BC433EF;
        Sat, 31 Dec 2022 01:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451531;
        bh=4ZA/1hA0wYQJb6znr2iokgOl90V6LTbtQ9O/AKnvl0Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aOrQKav7LvwI7TMLL4w0+DscK4cirIFQ1Al1tVNNUOe2MhBsoWYwsSNtPY+k2/gPu
         DodsLyieat2CFd/vTmDsAo0JJTSr7flwooEjp7SOenMKutuNKNpDa6qCKCfBMKNuTS
         whxibcOmYCS6LwtInss+TyC5pJQK/NfxvYWGdr41dWvAturL+wYs3YWVg7LsFXE8rb
         SCO9hUk7IfUV+FdvkvTMWeDz6zkmzN1Q3aAXQ3n3ME+NmuYFlDaL4w/Nv1EgcaMIOc
         o4Z9vTBIM6J5AJb2SdQxJeF4475xf+NWuTdT04s36XZtmpQbw+xghPeGjfNvJ58lp2
         QueC7eyvFak0g==
Subject: [PATCH 16/42] xfs: update rmap to allow cow staging extents in the rt
 rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871125.717073.9802618689897794582.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't error out on CoW staging extent records when realtime reflink is
enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index a533588a9b5b..891af03afccc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -274,6 +274,7 @@ xfs_rmap_check_rtgroup_irec(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				is_cow;
 
 	if (irec->rm_blockcount == 0)
 		return __this_address;
@@ -285,6 +286,12 @@ xfs_rmap_check_rtgroup_irec(
 			return __this_address;
 		if (irec->rm_offset != 0)
 			return __this_address;
+	} else if (irec->rm_owner == XFS_RMAP_OWN_COW) {
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
 	} else {
 		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
 					    irec->rm_blockcount))
@@ -301,8 +308,10 @@ xfs_rmap_check_rtgroup_irec(
 	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
 	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
 	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+	is_cow = xfs_has_rtreflink(mp) &&
+		 irec->rm_owner == XFS_RMAP_OWN_COW;
 
-	if (!is_inode && irec->rm_owner != XFS_RMAP_OWN_FS)
+	if (!is_inode && !is_cow && irec->rm_owner != XFS_RMAP_OWN_FS)
 		return __this_address;
 
 	if (!is_inode && irec->rm_offset != 0)
@@ -314,6 +323,9 @@ xfs_rmap_check_rtgroup_irec(
 	if (is_unwritten && !is_inode)
 		return __this_address;
 
+	if (is_unwritten && is_cow)
+		return __this_address;
+
 	/* Check for a valid fork offset, if applicable. */
 	if (is_inode &&
 	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))


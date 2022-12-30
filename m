Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74C4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiLaC5g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbiLaC5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:57:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFB5192B4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:57:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1715B81E68
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62491C433D2;
        Sat, 31 Dec 2022 02:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455452;
        bh=cPjWVhMn+CVsSXxzlxrTmt5RRWWddZ8G5kGqiY8Iu4s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DmtelhNmeLmdLZpHUr2Jseo5hOMvWYio3mkHvD0upd1RXt1ZFLxvjuxv5vrMKqxbe
         LoQZBOjIch9IKrlfwC0iXbxejmyD64MtmJ7HnMDKKvOfY5heu42kyHVopWgY1hh8Wh
         QZ2uwBEcRxTyQ5Qtu9YyfI73KvnpABdJpmoXMciPSiIoeNOWUunYiQqXvQFjodhVNK
         Llvj2tZvhWibACQE9gxqSZf08CjnoeU4czv/jESR3+MtNaFIxTnTdN/Z8Aj5hfAaeX
         b/faP88POrvwzCa3Jix2RKRN+CJ3/PQynjjrydWx/3+WdVNiTsy/0UttWmxyRreCDW
         ug4slUJDysBJw==
Subject: [PATCH 13/41] xfs: update rmap to allow cow staging extents in the rt
 rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:09 -0800
Message-ID: <167243880941.734096.13968884111379475420.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
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
 libxfs/xfs_rmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index a8ba49a89cf..1e2798ec709 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -273,6 +273,7 @@ xfs_rmap_check_rtgroup_irec(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				is_cow;
 
 	if (irec->rm_blockcount == 0)
 		return __this_address;
@@ -284,6 +285,12 @@ xfs_rmap_check_rtgroup_irec(
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
@@ -300,8 +307,10 @@ xfs_rmap_check_rtgroup_irec(
 	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
 	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
 	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+	is_cow = xfs_has_rtreflink(mp) &&
+		 irec->rm_owner == XFS_RMAP_OWN_COW;
 
-	if (!is_inode && irec->rm_owner != XFS_RMAP_OWN_FS)
+	if (!is_inode && !is_cow && irec->rm_owner != XFS_RMAP_OWN_FS)
 		return __this_address;
 
 	if (!is_inode && irec->rm_offset != 0)
@@ -313,6 +322,9 @@ xfs_rmap_check_rtgroup_irec(
 	if (is_unwritten && !is_inode)
 		return __this_address;
 
+	if (is_unwritten && is_cow)
+		return __this_address;
+
 	/* Check for a valid fork offset, if applicable. */
 	if (is_inode &&
 	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))


Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858D1C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbjEZBNU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbjEZBNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89F0E44
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CD6D64C2D
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC1FC4339B;
        Fri, 26 May 2023 01:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063590;
        bh=Y5HfAcKBXUS0VlX0NSOW18E6mwRaM3CyZaxyBrnv6G4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dVYGoqQShNP9UGUDKPuPBACWy94uzyP8xDhpg6ZeROSgJD0uKX2X9r6mIVBplcwYR
         5bM6YDYFbzi7Du/sR4stQfyP+capZHASuXOh/k8Aap9zN9YVEwzSU3GA7BMMFXJeOx
         brzPj471IhOTvymLHM1tA450Ip4vx7RWBI0A8q6/1bpryuQlzuvopSfNrwn9jP3A+E
         qfppzyu/jrvoXgXjyfwtd7E4CAll2fISnAzChkAoh1RJQR8yhn87qtvQYw3NE36Hkv
         /xC3RJ7Wkl0+EBqUe8rbZmL1Ja4fAnSceny624J8miqqWx5BnzEMLyqFfeQeLSp/7t
         swOBVIkdYGnOA==
Date:   Thu, 25 May 2023 18:13:10 -0700
Subject: [PATCH 4/4] xfs: support recovering bmap intent items targetting
 realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063909.3734058.4344017889198154665.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
References: <168506063846.3734058.6853885983674617900.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have reflink on the realtime device, bmap intent items have
to support remapping extents on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3668817a344b..e32abaa03635 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -362,6 +362,9 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 
 	/*
@@ -379,6 +382,9 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
@@ -467,6 +473,9 @@ xfs_bui_validate(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
+		return xfs_verify_rtext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
@@ -514,6 +523,12 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	if (!!(map->me_flags & XFS_BMAP_EXTENT_REALTIME) !=
+	    xfs_ifork_is_realtime(ip, fake.bi_whichfork)) {
+		error = -EFSCORRUPTED;
+		goto err_cancel;
+	}
+
 	if (fake.bi_type == XFS_BMAP_MAP)
 		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
 	else


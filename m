Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F0FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiL3Woy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbiL3Wox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:44:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7FF12D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28FAF61B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DEBC433EF;
        Fri, 30 Dec 2022 22:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440291;
        bh=BIf76ngF+9O6t9N3CzEhBiWCEE5ksSOH9nf4ojCE8mg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RXYBHDpxdh9qGbXiW53DM3NM8ZrKb4rrSkyP1X7Sm4FeinpPdIPgQ6bXI3vq+Yj9E
         b46a91TyuqStYxvtJnox9jJ7sUrbk+sv+72XqbwAC//dmPZoSQdvnYgHObmjbTh7N4
         8Lq7862S5ecoHvBrQ2D9nHRPetBTDX0cv2rqLkeOjaUVGpCC7y0sN4CThuRJQdh1rh
         ODP0uvpLledzR17+pP35ukJY3mmzJ7DkYWs1NUtOghy2116yWgu5apz0oixGm4I4vN
         tkr0W4XQV/+aSV3HoAK/aZ/grTCXCwuSPJBPxQz33BNRVqeUqf1eOTnq4l42bf/KQP
         h7/4Pmj/BjfCw==
Subject: [PATCH 2/2] xfs: ensure that single-owner file blocks are not owned
 by others
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:32 -0800
Message-ID: <167243829270.684733.16541016253685487518.stgit@magnolia>
In-Reply-To: <167243829239.684733.6811272411929910504.stgit@magnolia>
References: <167243829239.684733.6811272411929910504.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For any file fork mapping that can only have a single owner, make sure
that there are no other rmap owners for that mapping.  This patch
requires the more detailed checking provided by xfs_rmap_count_owners so
that we can know how many rmap records for a given range of space had a
matching owner, how many had a non-matching owner, and how many
conflicted with the records that have a matching owner.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index abc2da0b1824..b195bc0e09a4 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -308,6 +308,7 @@ xchk_bmap_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	struct xfs_owner_info	oinfo;
 	struct xfs_mount	*mp = info->sc->mp;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -328,19 +329,30 @@ xchk_bmap_iextent_xref(
 	xchk_bmap_xref_rmap(info, irec, agbno);
 	switch (info->whichfork) {
 	case XFS_DATA_FORK:
-		if (!xfs_is_reflink_inode(info->sc->ip))
+		if (!xfs_is_reflink_inode(info->sc->ip)) {
+			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+					info->whichfork, irec->br_startoff);
+			xchk_xref_is_only_owned_by(info->sc, agbno,
+					irec->br_blockcount, &oinfo);
 			xchk_xref_is_not_shared(info->sc, agbno,
 					irec->br_blockcount);
+		}
 		xchk_xref_is_not_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		break;
 	case XFS_ATTR_FORK:
+		xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+				info->whichfork, irec->br_startoff);
+		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
+				&oinfo);
 		xchk_xref_is_not_shared(info->sc, agbno,
 				irec->br_blockcount);
 		xchk_xref_is_not_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		break;
 	case XFS_COW_FORK:
+		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
+				&XFS_RMAP_OINFO_COW);
 		xchk_xref_is_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
 		xchk_xref_is_not_shared(info->sc, agbno,


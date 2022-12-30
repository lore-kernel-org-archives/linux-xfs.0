Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837A6C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiL3Xsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiL3Xsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:48:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5711DF3A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86AFFB81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B675C433EF;
        Fri, 30 Dec 2022 23:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444131;
        bh=dfq6BmYZpcuU/US8j6eJdmhmiAsXIkAxOA4NCu20oik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bt3rDbfynS4BWgmG7HSxvkczneYnUZxs/2j4ubLyMh1bj5Nha6cyXnlIyG2vFWNLS
         b9WAGkWcj1mFvsLl1YXuLvIu4CWPpKl7Tm9yPhAHPh9WfTBSgZQDnwHzKpZeFd1GgR
         n/PFwSabvjh47Hkd1/uYPNn4FGGEj/gx+3WCcQUe2C2yK81iNBiNCKISOH7008ATNY
         SEyWiQGBoON3fbOhaSUfXar2Brit3KW3FbtVJjAo+hK/jIMeUD2sWvuHduxn9xoBV/
         lNX4ek2Xdj9vRq2F86h/TxKTLk+m30R4zAJGflyYcoqiUsq8BZuBMnDwT95BfuCGSG
         DR7ZLMZYLe2rQ==
Subject: [PATCH 4/4] xfs: support recovering bmap intent items targetting
 realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:45 -0800
Message-ID: <167243842520.699102.10633826363372861202.stgit@magnolia>
In-Reply-To: <167243842459.699102.4471319762222972730.stgit@magnolia>
References: <167243842459.699102.4471319762222972730.stgit@magnolia>
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
 fs/xfs/xfs_bmap_item.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 82970413cb85..30a5402bb79c 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -319,7 +319,7 @@ xfs_bmap_update_log_item(
 		map->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
 	if (bi->bi_whichfork == XFS_ATTR_FORK)
 		map->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
-	if (xfs_ifork_is_realtime(bmap->bi_owner, bmap->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
 		map->me_flags |= XFS_BMAP_EXTENT_REALTIME;
 }
 
@@ -362,6 +362,9 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 	bi->bi_pag = xfs_perag_get(mp, agno);
 
@@ -380,6 +383,9 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+		return;
+
 	xfs_perag_drop_intents(bi->bi_pag);
 	xfs_perag_put(bi->bi_pag);
 }
@@ -469,6 +475,9 @@ xfs_bui_validate(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (map->me_flags & XFS_BMAP_EXTENT_REALTIME)
+		return xfs_verify_rtext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
@@ -516,6 +525,12 @@ xfs_bui_item_recover(
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


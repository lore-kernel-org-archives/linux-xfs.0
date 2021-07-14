Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B87C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4CED611C0
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbhGNV2V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235260AbhGNV2V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 17:28:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0752B61106;
        Wed, 14 Jul 2021 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626297929;
        bh=V0WtOD1xuAfkQZBtMHAhJtpBjA+7H5k+xHGHj7MVNqg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=raA5TyNy7qtAnyA+zrLRwnLucufTPy3ILM+0fbtCnnSsGStXTkb2XuuZ+ksw74KyJ
         vjOKBgyMbOLtq7VI8Lh13CDgmLIS3jaiUVOPVjnX+0iIBnmekdGJCcgMvlMSoKO1vN
         csoTxi5hJC0gHImGgyR9juK763xhcVbHQrspXshhyxHXljfiPN6vdwnIIVyCUm89uz
         GbIglwWjTKnvmMiD79ERpIrZ0veiXwqi2e3DJF3UZoI4/z9HJ6wmn+1ImdEFW18BxI
         2BFbaUk9K1iPD1RdYtNJBQKk8ejdPwWaJmSnxmNwy1j81LXUJmrcNOusi5IBTppVb1
         EH4IFJckXQE6g==
Subject: [PATCH 2/2] xfs: fix an integer overflow error in xfs_growfs_rt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 14 Jul 2021 14:25:28 -0700
Message-ID: <162629792874.487242.7435632593936391745.stgit@magnolia>
In-Reply-To: <162629791767.487242.2747879614157558075.stgit@magnolia>
References: <162629791767.487242.2747879614157558075.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During a realtime grow operation, we run a single transaction for each
rt bitmap block added to the filesystem.  This means that each step has
to be careful to increase sb_rblocks appropriately.

Fix the integer overflow error in this calculation that can happen when
the extent size is very large.  Found by running growfs to add a rt
volume to a filesystem formatted with a 1g rt extent size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8f6a05db4468..699066fb9052 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1021,7 +1021,8 @@ xfs_growfs_rt(
 		     ((sbp->sb_rextents & ((1 << mp->m_blkbit_log) - 1)) != 0);
 	     bmbno < nrbmblocks;
 	     bmbno++) {
-		xfs_trans_t	*tp;
+		struct xfs_trans	*tp;
+		xfs_rfsblock_t		nrblocks_step;
 
 		*nmp = *mp;
 		nsbp = &nmp->m_sb;
@@ -1030,10 +1031,9 @@ xfs_growfs_rt(
 		 */
 		nsbp->sb_rextsize = in->extsize;
 		nsbp->sb_rbmblocks = bmbno + 1;
-		nsbp->sb_rblocks =
-			XFS_RTMIN(nrblocks,
-				  nsbp->sb_rbmblocks * NBBY *
-				  nsbp->sb_blocksize * nsbp->sb_rextsize);
+		nrblocks_step = (bmbno + 1) * NBBY * nsbp->sb_blocksize *
+				nsbp->sb_rextsize;
+		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
 		nsbp->sb_rextents = nsbp->sb_rblocks;
 		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);
 		ASSERT(nsbp->sb_rextents != 0);


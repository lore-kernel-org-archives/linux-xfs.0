Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A022AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiLaCBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiLaCBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFA32AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:01:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7770961C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B50C433EF;
        Sat, 31 Dec 2022 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452106;
        bh=potMoBAhm3UGoSyc/uKP81gH6viWJzzE7CDFC9qgeu8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RE21Wlla+xGtZTJXmvoB+Uk2HcIl6uxfWopNU9sKfOT8a1Dtb3noTVJjtHMyAs/Ol
         LVUajz3cCXOkEZKCgrVVKG7GYKjJAO9VotGSi6iqp17udWonHsSLBXYrJ9weandGjK
         nKtbgLIHzUy5XnUopcf/j/6N5gMVVsHIglFnBJBxHLLrn6z8Z9fWkx5LgMqYvMmTP/
         T7+2aqSrexn+xEB7n7lpDWuLFy05/VgT4JmJtqauOto7ZIl+Jr+THNVFBoePbyQ2HG
         M+Y4Kpc0r/RLLKMBLisEuPwbiGvJIxi8Q/XGRy3p/JMUB6FmX84IyY1TkQ/xIA7LUl
         DM2xVd11VgQQQ==
Subject: [PATCH 2/3] xfs: fix rt growfs quota accounting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:42 -0800
Message-ID: <167243872255.719004.5461690119385910570.stgit@magnolia>
In-Reply-To: <167243872224.719004.160021889997830176.stgit@magnolia>
References: <167243872224.719004.160021889997830176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When growing the realtime bitmap or summary inodes, use
xfs_trans_alloc_inode to reserve quota for the blocks that could be
allocated to the file.  Although we never enforce limits against the
root dquot, making a reservation means that the bmap code will update
the quota block count, which is necessary for correct accounting.

Found by running xfs/521.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5e27cb7fce36..4165899cdc96 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -870,15 +870,10 @@ xfs_growfs_rt_alloc(
 		/*
 		 * Reserve space & log for one extent added to the file.
 		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtalloc, resblks,
-				0, 0, &tp);
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_growrtalloc,
+				resblks, 0, false, &tp);
 		if (error)
 			return error;
-		/*
-		 * Lock the inode.
-		 */
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -902,6 +897,7 @@ xfs_growfs_rt_alloc(
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
 		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
 		/*
@@ -914,15 +910,11 @@ xfs_growfs_rt_alloc(
 			/*
 			 * Reserve log for one block zeroing.
 			 */
-			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero,
-					0, 0, 0, &tp);
+			error = xfs_trans_alloc_inode(ip,
+					&M_RES(mp)->tr_growrtzero, 0, 0, false,
+					&tp);
 			if (error)
 				return error;
-			/*
-			 * Lock the bitmap inode.
-			 */
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
 			error = xfs_growfs_init_rtbuf(tp, ip, fsbno, buf_type);
 			if (error)
@@ -932,6 +924,7 @@ xfs_growfs_rt_alloc(
 			 * Commit the transaction.
 			 */
 			error = xfs_trans_commit(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			if (error)
 				return error;
 		}
@@ -945,6 +938,7 @@ xfs_growfs_rt_alloc(
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
@@ -1310,8 +1304,6 @@ xfs_growfs_rt(
 	/* Unsupported realtime features. */
 	if (!xfs_has_rtgroups(mp) && (xfs_has_rmapbt(mp) || xfs_has_reflink(mp)))
 		return -EOPNOTSUPP;
-	if (xfs_has_quota(mp))
-		return -EOPNOTSUPP;
 	if (xfs_has_reflink(mp) && !is_power_of_2(mp->m_sb.sb_rextsize) &&
 	    (XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) & ~PAGE_MASK))
 		return -EOPNOTSUPP;


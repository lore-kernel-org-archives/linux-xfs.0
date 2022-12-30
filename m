Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E571C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiLaBKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiLaBKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:10:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7387C18B37
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E240ACE191A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A6EC433EF;
        Sat, 31 Dec 2022 01:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449020;
        bh=jHlFA9s9JXdSIWR6E/qDBVglOEPIyp440wxiLt2Hs9s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jE4XNcdgJm0/5NgeUK42iwIPP9aAWmIzqMITDkgMllfIyKYyj6+iuh13NdBZgZGcv
         0+7TqK36H2Cf6ZemZKIk7chgolAhqRpnKioYk1P/LGyEVrl70nYIoodHEWMVp6++Fr
         r0CFPOcAUsThRRIHVic+ECOC02YsJD0shIbes6aJcmZf8qi2VXzkiBs4pR4cBkXwoZ
         Br4ZGri9myvLQjC7J2oFl9vLp9fpl6cCTgwHN2SZdOcax27dIo7ArCmQBWE4zhYi+0
         9RC9seDPFvRZbKkjtpp8ugJ6+0qjRH6crhPQxEz7LmSJvbJC4xpH+nrbyHuEF9UpCx
         CPjzLHQVmiMyQ==
Subject: [PATCH 20/20] xfs: get rid of cross_rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:21 -0800
Message-ID: <167243864118.707335.4987942983753574680.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of the largely pointless xfs_cross_rename now that we've
refactored its parent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   72 +++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4b9d680c5268..fdd5e5c89e62 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2177,54 +2177,6 @@ xfs_rename_call_nlink_hooks(
 		((void)0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
-static int
-xfs_finish_rename(
-	struct xfs_trans	*tp)
-{
-	/*
-	 * If this is a synchronous mount, make sure that the rename transaction
-	 * goes to disk before returning to the user.
-	 */
-	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
-		xfs_trans_set_sync(tp);
-
-	return xfs_trans_commit(tp);
-}
-
-/*
- * xfs_cross_rename()
- *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() syscall
- */
-STATIC int
-xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
-{
-	int			error;
-
-	error = xfs_dir_exchange(tp, dp1, name1, ip1, dp2, name2, ip2,
-			spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch))
-		xfs_rename_call_nlink_hooks(dp1, name1, ip1, dp2, name2, ip2,
-				NULL, RENAME_EXCHANGE);
-
-	return xfs_finish_rename(tp);
-
-out_trans_abort:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /*
  * xfs_rename_alloc_whiteout()
  *
@@ -2377,12 +2329,6 @@ xfs_rename(
 		goto out_trans_cancel;
 	}
 
-	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
-
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
 	 * We'll allow the rename to continue in reservationless mode if we hit
@@ -2434,8 +2380,13 @@ xfs_rename(
 		}
 	}
 
-	error = xfs_dir_rename(tp, src_dp, src_name, src_ip, target_dp,
-			target_name, target_ip, spaceres, wip);
+	if (flags & RENAME_EXCHANGE)
+		error = xfs_dir_exchange(tp, src_dp, src_name, src_ip,
+				target_dp, target_name, target_ip, spaceres);
+	else
+		error = xfs_dir_rename(tp, src_dp, src_name, src_ip,
+				target_dp, target_name, target_ip, spaceres,
+				wip);
 	if (error)
 		goto out_trans_cancel;
 
@@ -2452,7 +2403,14 @@ xfs_rename(
 		xfs_rename_call_nlink_hooks(src_dp, src_name, src_ip,
 				target_dp, target_name, target_ip, wip, flags);
 
-	error = xfs_finish_rename(tp);
+	/*
+	 * If this is a synchronous mount, make sure that the rename
+	 * transaction goes to disk before returning to the user.
+	 */
+	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
 	if (wip)
 		xfs_irele(wip);
 	return error;


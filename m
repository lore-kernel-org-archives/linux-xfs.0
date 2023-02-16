Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8382EC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBPUj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBPUj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:39:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AC6CC0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D47360AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B073CC433EF;
        Thu, 16 Feb 2023 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579997;
        bh=AyxI8j1KARAxJx4RfXjzej0s22wRKl+/oAxqaGBPahI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PT8rkyKlOlF8Z9SoY/NV5i8OGObYmdWZc1TXYctUwZd+zGVBSGGcIFmrgJvqhDHJi
         J5CX2jkswZKezNzVuwfSlqz2DIgfa0+CuTvaMdNdL58DBuK4lWQLDQJjf/UQXr6KqG
         4AIlQU1nl1KioiXtBsJ7EiItrKGGnm7+ATuQi4cZ0PiwPijVToTB3HqpDZGap1GyDh
         MDdE8IEFeQPMALGFPwhTxMAaolQDjgzlXgLoFn6XrrSGYb5Uduc+8IlvmDNuqfYmLa
         rEg9frfbHB6J8mX3OjaNYGqHGZVEFe9G5ftWVjisqNv+dl9oVF841jX5fWQSuAydC5
         5DBVi2+e5BlJw==
Date:   Thu, 16 Feb 2023 12:39:57 -0800
Subject: [PATCH 28/28] xfs: add xfs_trans_mod_sb tracing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872789.3473407.18173047314099746828.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Reservationless operations are not allowed with parent pointers because
the attr expansion may cause a shutdown if  an operation is retried without
reservation and succeeds without enough space for the parent pointer.  Add
tracing to detect if this shutdown occurs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trans.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 43f4b0943f49..bfb7e87e7794 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -375,8 +375,10 @@ xfs_trans_mod_sb(
 		 */
 		if (delta < 0) {
 			tp->t_blk_res_used += (uint)-delta;
-			if (tp->t_blk_res_used > tp->t_blk_res)
+			if (tp->t_blk_res_used > tp->t_blk_res) {
+				xfs_err(mp, "URK blkres 0x%x used 0x%x", tp->t_blk_res, tp->t_blk_res_used);
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			}
 		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
 			int64_t	blkres_delta;
 


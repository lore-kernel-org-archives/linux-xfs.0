Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32472C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 16:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKXQ7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXQ7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 11:59:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5538CB54CF
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 08:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1150FB82899
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 16:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9EAC433C1;
        Thu, 24 Nov 2022 16:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669309175;
        bh=B+rifbk15R8VDExDcIh4ROAoGhjJRQcwXJct6Y6SuXY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dT3hftHtsbHL3hvDCdp3pk43STiaW0lNtPidrwnwCpbxtzHdgAUXuGyuxHFnbJhZJ
         Z9UFKyGDu6ccu1l5+AYqZz1st/kMk8Y5TbNyr5q9woDCQuBZUOA2sB2pKzCzGOHySb
         IZTtNMjeOMX0/cvmFNTK5G/fNzNYXtgg1lX3zsmzJKlGI/9FtD4AdO+jeHfBzPKRjx
         Sz43SR8qHI1xU+sSsOgs9xsF3EImDDZxFSbQwI/yv7hO0stpAykTyTV2rbhcoKyolD
         hktG1dFPm0dWqTe+/eLwkS2a3cASTm8UlCRZZznjVCMhmQ0jeYgfj11lZ9/3h4lyi9
         qgxOGSfE1F/6w==
Subject: [PATCH 3/3] xfs: shut up -Wuninitialized in xfsaild_push
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Nov 2022 08:59:35 -0800
Message-ID: <166930917525.2061853.17523624187254825450.stgit@magnolia>
In-Reply-To: <166930915825.2061853.2470510849612284907.stgit@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

-Wuninitialized complains about @target in xfsaild_push being
uninitialized in the case where the waitqueue is active but there is no
last item in the AIL to wait for.  I /think/ it should never be the case
that the subsequent xfs_trans_ail_cursor_first returns a log item and
hence we'll never end up at XFS_LSN_CMP, but let's make this explicit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans_ail.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f51df7d94ef7..7d4109af193e 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -422,7 +422,7 @@ xfsaild_push(
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		lsn;
-	xfs_lsn_t		target;
+	xfs_lsn_t		target = NULLCOMMITLSN;
 	long			tout;
 	int			stuck = 0;
 	int			flushing = 0;
@@ -472,6 +472,8 @@ xfsaild_push(
 
 	XFS_STATS_INC(mp, xs_push_ail);
 
+	ASSERT(target != NULLCOMMITLSN);
+
 	lsn = lip->li_lsn;
 	while ((XFS_LSN_CMP(lip->li_lsn, target) <= 0)) {
 		int	lock_result;


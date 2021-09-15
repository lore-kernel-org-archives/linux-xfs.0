Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B3AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E01610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhIOXMA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXMA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C947D600D4;
        Wed, 15 Sep 2021 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747440;
        bh=C2GTVH5bI55VJw0RQ2K6zZJCLOc5RtgS7lPOMQjfsnQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n3DPAxnAzvHo8MC5FrkFBn3qZrzlGmjpYgd8zBWRStiQKoUEJEPc0aDYae6AgVOPA
         9yJWTUbiGNdse+pZJVrjnGqE9xNm9KAjBLb2Jak0TZH23edoOng3ugTtjtg6qHGQi/
         kq1QIZpaa3FVL19h0Suhlguv30YnL82gp+x85zgSdJ0ZeypL6pAM+qVbBA9atggkgf
         6kj8hu5+L/k2zEnYFyDhSAiz4B6AMJZGtq/Xkx94HWB5H56TBKMWHj60XAawJuS7UV
         OVXe9vgBir3/+fjkLNoA+ZwuLaFUgMwvxda0MaaGnE04PYgj10cGsvfYPR/k0u/zfv
         hUeZqnMfbPRfw==
Subject: [PATCH 45/61] xfs: Remove redundant assignment to busy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:40 -0700
Message-ID: <163174744054.350433.11261075036145807103.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Source kernel commit: 9673261c32dc2f30863b803374b726a72d16b07c

Variable busy is set to false, but this value is never read as it is
overwritten or not used later on, hence it is a redundant assignment
and can be removed.

Clean up the following clang-analyzer warning:

fs/xfs/libxfs/xfs_alloc.c:1679:2: warning: Value stored to 'busy' is
never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 369bb0ba..5f455342 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1672,7 +1672,6 @@ xfs_alloc_ag_vextent_size(
 	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
 					args->pag, XFS_BTNUM_CNT);
 	bno_cur = NULL;
-	busy = false;
 
 	/*
 	 * Look for an entry >= maxlen+alignment-1 blocks.


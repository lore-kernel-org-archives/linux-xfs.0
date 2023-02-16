Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFE3C636D7
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBPVNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjBPVNi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:13:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B9548E22
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:13:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F41CB828F3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F5C433D2;
        Thu, 16 Feb 2023 21:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582015;
        bh=5Vn5balPm1WW1YkS2Pr03cLZHmtXj2FVAcFH6kl20VY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mi+0X962hmG1Lj51/RFfMS2FiSb/ghKvAn1zN8ceiOWyqqO5wq5XgF4fy3ZqfxLCU
         H7oyABgxN7rz/1Zk/fq+0SsFpcpBm8264M2UkmLIxmCDjunZkv3GOwt8VNKi2/1w0m
         VWKkKBYhajy7hG8cVy4mK95mDBXw0BiYgFaTvapD758TrKbmp6zsdQXrFUYywuuaQc
         nKC0qNf2zhZo0wRWAVdgSQjsbUiNlAwBLuzmQCVfInwUjhsmc2WyWY4lTUeHvpoh+0
         xvUgvGKJpEU1+9+JPT+u/mkJ8gBrG/oSzYNUIDcl47I6O9O8GlAOJfQ1BVcnowCrWr
         L87eK9P2C0dzQ==
Date:   Thu, 16 Feb 2023 13:13:34 -0800
Subject: [PATCH 3/3] mkfs: enable parent pointers by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657883099.3478343.13727736396375441177.stgit@magnolia>
In-Reply-To: <167657883060.3478343.13279613574882662321.stgit@magnolia>
References: <167657883060.3478343.13279613574882662321.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 325f8617..5f090c08 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4088,7 +4088,7 @@ main(
 			.rmapbt = true,
 			.reflink = true,
 			.inobtcnt = true,
-			.parent_pointers = false,
+			.parent_pointers = true,
 			.nodalign = false,
 			.nortalign = false,
 			.bigtime = true,


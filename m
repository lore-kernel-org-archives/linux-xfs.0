Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBFEC77B60
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjCPTWh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCPTWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:22:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AD365C7D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECF2A620EE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A97AC433EF;
        Thu, 16 Mar 2023 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994552;
        bh=7unI4aM4kWj0c4FF4eod83BtE4iRejRvVLdrHGZCPqI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VyYE04xy7v7YHqz5l73+pc2vepHwBM5Pm8YpXpcpHZEfKKH8pfEbdPGCjIT2GQCRB
         QQhD/CyfUGBsR0hVM19v5FSArjtVPDx/e0OIhn0nh50Ga1y58tQXsgWYxm29hC4GIF
         fLMmJdevJr7RSq2gh7e7oO48iwUBc37I7OKRXveaOlXi7omkTscrVoYnjsB2hpNkVE
         78BY9YUrxtofc6JwX/gcbzQSA/lEUhi6J4OEu/KbKoR8t0TtOKyEnPjL71VuI2xf0C
         rR1sbrAZ+jZrvjS3BPwjRNFZAueyJQFeppdOnDNO3rTeSCddyLLYtfm2FxEflz25WG
         UTNZs+73XYbXQ==
Date:   Thu, 16 Mar 2023 12:22:31 -0700
Subject: [PATCH 04/17] xfs: preserve VLOOKUP in xfs_attr_set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414413.15363.13959734432816342056.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Preserve the attr-value lookup flag when calling xfs_attr_set.  Normal
xattr users will never use this, but parent pointer fsck will.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 756d93526075..86672061c99e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -999,11 +999,11 @@ xfs_attr_set(
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
+	 * removal to fail as well.  Preserve the logged and vlookup flags,
+	 * since we need to pass them through to the lower levels.
 	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	args->op_flags &= (XFS_DA_OP_LOGGED | XFS_DA_OP_VLOOKUP);
+	args->op_flags |= XFS_DA_OP_OKNOENT;
 
 	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);


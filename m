Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6F7C77B72
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 15:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDTPKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 11:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjDTPKC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 11:10:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C565581
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 08:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A9DA641BD
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 15:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF44CC433D2;
        Thu, 20 Apr 2023 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682003400;
        bh=TEYxKh5UIsR0lJlNEYiYqanQBJiRzsiVlLQxqYeyXT0=;
        h=Date:From:To:Cc:Subject:From;
        b=KbmGOgmJLSRARMJ1yNucq4lEkkRPFfrC5W+83m7m/I1yEDvl3xitPT6Qo8ZMz7fHz
         CYGmxcfAQjQxPAsbGlOk3YlbabxVh1R9iqTeLqwSj2PS6zNRjJOWup/XONhvwWLkJt
         mhYMAarVUyx3da31xFGU47XMJIGSLH5t9qSrMgJkGNZrbUqpT385ScdYSGnCARKIGy
         CP2J3d1jRWWBVePbSGbmqEtgJyX0UX/Tq+QkanqVlq+sjGVn+Y0u+gIcxNHg5REQ0r
         MWeWyBLZU96wXc6n9QlwpbbhJJKdP5BXIrS7JvPSR93sC/4EMgpC0tyYlRZLbvx500
         jR+gFsmNIqiPw==
Date:   Thu, 20 Apr 2023 08:10:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: drop EXPERIMENTAL tag for large extent counts
Message-ID: <20230420151000.GH360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This feature has been baking in upstream for ~10mo with no bug reports.
It seems to work fine here, let's get rid of the scary warnings?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4d2e87462ac4..dc13ff4ea25e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1683,10 +1683,6 @@ xfs_fs_fill_super(
 		goto out_filestream_unmount;
 	}
 
-	if (xfs_has_large_extent_counts(mp))
-		xfs_warn(mp,
-	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
-
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

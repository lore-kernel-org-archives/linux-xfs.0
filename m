Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A8AC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 02:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjBICix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 21:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjBICiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 21:38:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9CE1C5BF
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 18:38:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B6F61825
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 02:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B81C433D2;
        Thu,  9 Feb 2023 02:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675910329;
        bh=M8vJPq02gNABcu+6HusGAq1XpKKkchkAChfc+2uKBSA=;
        h=Date:From:To:Cc:Subject:From;
        b=MoPJJFvXVQRldUNE1BAIwejGFJsZrSXi0gjB4IqnREWPtgV57ID8PlWUZyg/7yms/
         xcw2NBnA/1KH2yuDXbtLjiftq14XfMfsjQ76q+/sF4TTrzdYrfGOQx+ktEgHokwyi7
         wF/sd8HFkwlqOXlngBRdOIOK/z0IdOIRQGmyr0qJDfIjhmLaj4yPIYwql/ubbCcuns
         JulC1S/yo8P6XaJ0saS3qGKqJbD/gKDrcZ6yAtDVkB0YTT9iZHq8IIm5fKwt5wG+PL
         6pSbO6XxIczOn8B+gNTSTPvxIvUy6XQvJK3R8ddzEDa+61Q/JA7blvJpnKcRaZvAPw
         L+IXhAcIxr48w==
Date:   Wed, 8 Feb 2023 18:38:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_io: fix bmap command not detecting realtime files with
 xattrs
Message-ID: <Y+RcuAFlqnxNBw5I@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the bmap command so that it will detect a realtime file if any of
the other file flags (e.g. xattrs) are set.  Observed via xfs/556.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io/bmap.c b/io/bmap.c
index a78e0c65440..11bbc0629cf 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -118,7 +118,7 @@ bmap_f(
 			return 0;
 		}
 
-		if (fsx.fsx_xflags == FS_XFLAG_REALTIME) {
+		if (fsx.fsx_xflags & FS_XFLAG_REALTIME) {
 			/*
 			 * ag info not applicable to rt, continue
 			 * without ag output.

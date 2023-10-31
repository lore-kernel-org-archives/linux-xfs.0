Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1AFC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 23:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376887AbjJaXsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 19:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376284AbjJaXsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 19:48:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19678BD
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 16:48:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96B0C433C7;
        Tue, 31 Oct 2023 23:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698796100;
        bh=3V9euhU0MLx0KKIk13/slsDg2pnOZt8KziSPT2oAkL8=;
        h=Date:From:To:Cc:Subject:From;
        b=K93eT1A0GkeYMJ21vsiApY/qNGoKPkEzgWOLaiiCTLoOlmAQyL9JQq64i822pD0LJ
         MOFh54uZDLI0BZQj67+n3ahMberRt2sXxXUHcR9q9OGu2pZM+65bJquCUx9we99Xre
         J1mGH6MX4ByGkZLjF6P7EgQ47hkGQL7pwpOT0vnp1cBu7FRg9vOaWf3afcIEyRuS1M
         75VgP54ePp2QIG6e6hb9lV/QHjqxTa25ojhXqEV/tikZ6t2FfSthlqXka+c6b2EJbB
         OCIVGeR5k4w5c5avjg4Juxb6Xv7rgwvNzJbCTaLz7RfM/58PJN+rgFKnmtA+BswxA2
         KNBIdZACJcQuQ==
Date:   Tue, 31 Oct 2023 16:48:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] iomap: rotate maintainers
Message-ID: <20231031234820.GB1205221@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Per a discussion last week, let's improve coordination between fs/iomap/
and the rest of the VFS by shifting Christian into the role of git tree
maintainer.  I'll stay on as reviewer and main developer, which will
free up some more time to clean up the code base a bit and help
filesystem maintainers port off of bufferheads and onto iomap.

Link: https://lore.kernel.org/linux-fsdevel/20231026-gehofft-vorfreude-a5079bff7373@brauner/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a7bd8bd80e9..b26f145614ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10951,7 +10951,8 @@ S:	Maintained
 F:	drivers/net/ethernet/sgi/ioc3-eth.c
 
 IOMAP FILESYSTEM LIBRARY
-M:	Darrick J. Wong <djwong@kernel.org>
+M:	Christian Brauner <brauner@kernel.org>
+R:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported

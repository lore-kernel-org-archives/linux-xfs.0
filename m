Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0413CA0FE1
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 05:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242411AbjIAFHt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 01:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbjIAFHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 01:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D82CFE
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 22:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48FEFB82488
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 05:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83B5C433C8;
        Fri,  1 Sep 2023 05:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693544859;
        bh=O2QCljtrCqLvGRO7BZoIZw5vy1qMtmP7ur8Rygq2gZE=;
        h=Date:From:To:Cc:Subject:From;
        b=SNf4DR4KojIRlQYQc4vN2/0xELvB7NqqKI1Fimxb0yEu7bRAgvMHZGGCuZTtFJmvI
         FKEvvmlN/0GZNj3CXvarPp/W+JIDritOUs6Rtx5nAwcnnbKKPKvoa0l5i3/q5CnTrT
         3tFD7aLHRFUW/kSRCGBM1SRcSXPxvP/reQ71Mp3vvJDmcRoAI6Z6/DPVhyaB5mpro3
         cz1tmv5HiCVxVp4YA6JPGXGjsHz+A5PB4WHfwFkYjMHm0NpHuFRBmEIG5x0MizCBci
         3k0CShLP8V48StREDtfGE5MOKP0BLy0VnZ6y2foiVWaXkZe65lE69TGe9wOs1lL1lX
         f9dhbpQMEbaiw==
Date:   Thu, 31 Aug 2023 22:07:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: require a relatively recent V5 filesystem for LARP mode
Message-ID: <20230901050739.GO28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While reviewing the FIEXCHANGE code in XFS, I realized that the function
that enables logged xattrs doesn't actually check that the superblock
has a LOG_INCOMPAT feature bit field.  Add a check to refuse the
operation if we don't have a V5 filesystem...

...but on second though, let's require either reflink or rmap so that we
only have to deal with LARP mode on relatively /modern/ kernel.  4.14 is
about as far back as I feel like going.

Seeing as LARP is a debugging-only option anyway, this isn't likely to
affect any real users.

Fixes: d9c61ccb3b09 ("xfs: move xfs_attr_use_log_assist out of xfs_log.c")
Really-Fixes: f3f36c893f26 ("xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xattr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 43e5c219aaed..a3975f325f4e 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -46,6 +46,17 @@ xfs_attr_grab_log_assist(
 	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
 		return 0;
 
+	/*
+	 * Check if the filesystem featureset is new enough to set this log
+	 * incompat feature bit.  Strictly speaking, the minimum requirement is
+	 * a V5 filesystem for the superblock field, but we'll require rmap
+	 * or reflink to avoid having to deal with really old kernels.
+	 */
+	if (!xfs_has_reflink(mp) && !xfs_has_rmapbt(mp)) {
+		error = -EOPNOTSUPP;
+		goto drop_incompat;
+	}
+
 	/* Enable log-assisted xattrs. */
 	error = xfs_add_incompat_log_feature(mp,
 			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);

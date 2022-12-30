Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623DEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiLaAFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiLaAFb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:05:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EEB14D14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A87BCE19FC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96034C433D2;
        Sat, 31 Dec 2022 00:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445127;
        bh=XH86zN/DxT8HwXBgzspYADprt3aoDvAE4xBe2RvWEHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HMoy6wexTZY2qlh0NhmcJLKp3qfOq+t/CkmXwKoGgFref4o/vBiLKo6jN/C3ri/sf
         BP/aMu7rkJm/x/lQgQ3QtrBUkqGMc9OqaWk2XQabAvj4RWolvi/thejE1ZBs4ry8a4
         rocuDJL8FzaGtIpUW5JwMa9siOIacJS8hDP6AL90HInbtf8ISZ7CwEBPNobMuTnOeT
         4gaCijYfxxPGR1APliGNoYWiLs5Es51disk1SpPdsARpGjCf3N3PGPviNCOwHCDgpG
         bwGos7zteBaPbo01bqqv1x1sMFIpKHzD44IcvpHZZVjjSGZzd2DDHWhGYyut7QvoZ6
         rPIQHD4/hTaEg==
Subject: [PATCH 2/5] xfs: implement block reservation accounting for btrees
 we're staging
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863930.707598.16411891612752740522.stgit@magnolia>
In-Reply-To: <167243863904.707598.12385476439101029022.stgit@magnolia>
References: <167243863904.707598.12385476439101029022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new xrep_newbt structure to encapsulate a fake root for
creating a staged btree cursor as well as to track all the blocks that
we need to reserve in order to build that btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree_staging.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index f0d2976050a..d6dea3f0088 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -38,11 +38,8 @@ struct xbtree_ifakeroot {
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
 
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
+	/* Which fork is this btree being built for? */
+	int			if_whichfork;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */


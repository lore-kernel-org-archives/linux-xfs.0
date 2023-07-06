Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88720EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 02:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjGFC0d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 22:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjGFC0d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 22:26:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2741990
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 19:26:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 016276185C
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 02:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C66CC433C7;
        Thu,  6 Jul 2023 02:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688610391;
        bh=2DJbIl4mzzS11Yq4Mg4+0CE5BdUpy1vMmqF1JhkLGNs=;
        h=Date:From:To:Cc:Subject:From;
        b=UtzCEsCQTeLBfRPJR2C2NmuTo0XZ4onR+49hdJbE2+U1cPaPfoNWDqxx3sNLJu+yY
         DMW7Yz7ArpR72fNYxrG2mnjAILaTMZ5irTd/5wNMnZUezeuo7Qyo8/vkqgN/YICzBD
         tmpJdFjbyiC6IfvSPRkwGFluhp2MolDif+MOVZnbKp7Tquj+zAaGC/jIzgLlQdL19p
         8HgrUkHBEccALmUJr7ye0uYja58MlPXHJc+aZqKi4s1CWTpUC9gkKQD4IQeDRgmtPN
         NUjzg4dajBxI9ZPtqOSblO9CR3msVaSxqSD259tG8QmW/NYbYjkpcs7NMZtQa1o9in
         mgRGbVVFZxFqQ==
Date:   Wed, 5 Jul 2023 19:26:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix uninit warning in xfs_growfs_data
Message-ID: <20230706022630.GA11476@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quiet down this gcc warning:

fs/xfs/xfs_fsops.c: In function ‘xfs_growfs_data’:
fs/xfs/xfs_fsops.c:219:21: error: ‘lastag_extended’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
  219 |                 if (lastag_extended) {
      |                     ^~~~~~~~~~~~~~~
fs/xfs/xfs_fsops.c:100:33: note: ‘lastag_extended’ was declared here
  100 |         bool                    lastag_extended;
      |                                 ^~~~~~~~~~~~~~~

By setting its value explicitly.  From code analysis I don't think this
is a real problem, but I have better things to do than analyse this
closely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 65473bc52c7d..96edc87bf030 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -97,7 +97,7 @@ xfs_growfs_data_private(
 	xfs_agnumber_t		nagimax = 0;
 	xfs_rfsblock_t		nb, nb_div, nb_mod;
 	int64_t			delta;
-	bool			lastag_extended;
+	bool			lastag_extended = false;
 	xfs_agnumber_t		oagcount;
 	struct xfs_trans	*tp;
 	struct aghdr_init_data	id = {};

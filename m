Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41061C07E99
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 22:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F6961242
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 22:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhGLWKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 18:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhGLWKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jul 2021 18:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A99611C1;
        Mon, 12 Jul 2021 22:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626127651;
        bh=J/N5eThwmcZ5P330x/13TXXybtS2Hre61Tkh+Q4hLQs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H+NCRrjvkgS8kismIDCNUTePVrAKVt3uMucz4qMThSATwqkO4KmOC+fYAhTs8CcsJ
         QwbH3ff75sCZkVwAx71Py9RtNlZ2OG2RZpC9Wm/CNJnmkzFTTpk82sIoI2uQmbV70L
         5bw/92rEDiVPWm7IQJ4+ig+DX+Wvaa9hNf6qQsf+jDvMPFLzwZtex0QlfVWZTnJxlw
         eZ48rzeDqmFFNYd51Au7A3510OWAqJsiKevsBfyGXVbHAYmYt1MjwnOwt/n0grVJYl
         Jafn3p0y7UA4EbkI+ay+ZtjUZQOKdXiijc8rC5hVuAp6KFnxYsX3gU5LALZPZHWoQz
         5AjcwPQRibkDQ==
Subject: [PATCH 2/2] xfs: fix an integer overflow error in xfs_growfs_rt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 12 Jul 2021 15:07:31 -0700
Message-ID: <162612765097.39052.11033534688048926480.stgit@magnolia>
In-Reply-To: <162612763990.39052.10884597587360249026.stgit@magnolia>
References: <162612763990.39052.10884597587360249026.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During a realtime grow operation, we run a single transaction for each
rt bitmap block added to the filesystem.  This means that each step has
to be careful to increase sb_rblocks appropriately.

Fix the integer overflow error in this calculation that can happen when
the extent size is very large.  Found by running growfs to add a rt
volume to a filesystem formatted with a 1g rt extent size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8920bce4fb0a..a47d43c30283 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1019,7 +1019,7 @@ xfs_growfs_rt(
 		nsbp->sb_rbmblocks = bmbno + 1;
 		nsbp->sb_rblocks =
 			XFS_RTMIN(nrblocks,
-				  nsbp->sb_rbmblocks * NBBY *
+				  (xfs_rfsblock_t)nsbp->sb_rbmblocks * NBBY *
 				  nsbp->sb_blocksize * nsbp->sb_rextsize);
 		nsbp->sb_rextents = nsbp->sb_rblocks;
 		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);


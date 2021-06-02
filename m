Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908FDC47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 779FE613C5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhFBAys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhFBAys (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5C40613CA;
        Wed,  2 Jun 2021 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595186;
        bh=j3LMsh4lmfB3F41dYCgQiQgP7JVuDrGbXOslZn4SURM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=knho+I2fHEoL4uClDcBZ46u6+dxr9DDd+ACrrc2kq7tlu6D+tFT4ZtXT3MJKJ+cLz
         ABdXFhbR2Apre5uoUUFnr7DnedD9NnsKSJY5yEkWe+jkbhrwutpkr2AshNVkw2p7zu
         6jRrb4mTHXIf/CLiqj+y4q79gkky/gwHsx4TDyEci5SwwlPtN6yDEbW5ZwqgMJHmcK
         vEBfnWcYLc+0FBYhlOgCocu7q+9yR2rgGDqG0H5F5W6HaxEtLu0Myf9hJtuxWzX2sP
         fMeWx8NbV5dLD6kqOe/YdaH8QuOzinvIHtS8mCls4BXyLVR8KvWXtPkrqdTvIpLWwS
         3vYS60zxMfdXQ==
Subject: [PATCH 06/14] xfs: move xfs_inew_wait call into xfs_dqrele_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:05 -0700
Message-ID: <162259518565.662681.11590996146177657551.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the INEW wait into xfs_dqrele_inode so that we can drop the
iter_flags parameter in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bc88d33f7f24..b22a3fe20c4a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -803,6 +803,9 @@ xfs_dqrele_inode(
 {
 	struct xfs_eofblocks	*eofb = priv;
 
+	if (xfs_iflags_test(ip, XFS_INEW))
+		xfs_inew_wait(ip);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (eofb->eof_flags & XFS_EOFB_DROP_UDQUOT) {
 		xfs_qm_dqrele(ip->i_udquot);
@@ -841,8 +844,8 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
 
-	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&eofb, XFS_ICWALK_DQRELE);
+	return xfs_inode_walk(mp, 0, xfs_dqrele_inode, &eofb,
+			XFS_ICWALK_DQRELE);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)


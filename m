Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63622C47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4739C611CB
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhEaWm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhEaWm7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A78611CA;
        Mon, 31 May 2021 22:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500879;
        bh=On1KisaY724niV5YETgIzrty25KZCppMYFGwZzZCQWc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jtrGEjs05wzWv+/9anQtIPVMGnJ0/ZMXj839Do6vX360jVm3AV5zEj0j11fHLmvvR
         hlpZHtnqYwi4uk5/k2Tl6yaeg9uO18YRoHhCeNOQPm77z+7UCOGPAkO8VvMRAdqQEJ
         EPez+BA4++SN59JRSWbyknGucw4xebfA0nDjyCVd/uvwqdBfLL8KffYp7E+zSwEu7E
         enuOGJrfQWWnXOwzU7PzZIOaiivNzz0GWzXYNOoznPLsFOoN/PNrb14ScyLNLKSKMq
         fi7ujhcsk3BuXf1yNEB/kXPYPU8EMYG/DFBT2BeDRP4OTynkEooVoZCbe/fcfHZ1bC
         EKjzk4nspDzcA==
Subject: [PATCH 5/5] xfs: move xfs_inew_wait call into xfs_dqrele_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:41:18 -0700
Message-ID: <162250087868.490412.809961177992047138.stgit@locust>
In-Reply-To: <162250085103.490412.4291071116538386696.stgit@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
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
index 5501318b5db0..859ab1279d8d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -981,6 +981,9 @@ xfs_dqrele_inode(
 {
 	struct xfs_eofblocks	*eofb = priv;
 
+	if (xfs_iflags_test(ip, XFS_INEW))
+		xfs_inew_wait(ip);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (eofb->eof_flags & XFS_EOFB_DROP_UDQUOT) {
 		xfs_qm_dqrele(ip->i_udquot);
@@ -1019,8 +1022,8 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
 
-	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&eofb, XFS_ICI_DQRELE_NONTAG);
+	return xfs_inode_walk(mp, 0, xfs_dqrele_inode, &eofb,
+			XFS_ICI_DQRELE_NONTAG);
 }
 
 /*


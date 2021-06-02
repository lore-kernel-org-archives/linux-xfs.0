Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC2FC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9BE2613CD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhFBAzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhFBAzK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FE5613C5;
        Wed,  2 Jun 2021 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595208;
        bh=vrDG9J2jGPubgEDB0ciwoLck1gX777tyclxMkW/cTA4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TfDd8XawQ/6cJQsVQSPqt3Non+bOIVuI2dY8G/DZue6agvw9qYhoJ4eiZx0e3jh03
         ic1YHi4Zg1rkMEpSXs6YPAzeDYlMg5yV8AIPIqUaTNGX0Fh5vTVHCTXqTknivjaIlP
         uz630jHFdjUi0WinwmN6p8F1gR/T1rrYEvAR+pa2UdYEgRpQk7BxXJzw89uA4USfZp
         0LpRvRJTRtvWTv07G010h1labw1RG6kYe0CP5Wes62J9Vvsbtm8cuJ1FAkL1mrVvJM
         rOSVx8AuhVeoSU5zT+eyYcw3L4oHfjYbWLb1yckVMxjpx68zE7ZE/l7VQxp2oAS8BP
         rnWwLTGfC1p0g==
Subject: [PATCH 10/14] xfs: clean up xfs_dqrele_inode calling conventions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:27 -0700
Message-ID: <162259520763.662681.11880671088212649919.stgit@locust>
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

Similar to the last patch, establish that xfs_dqrele_inode is
responsible for cleaning up anything that xfs_dqrele_inode_grab touches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5922010b956d..7d956c842ae1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -794,7 +794,7 @@ xfs_dqrele_igrab(
 }
 
 /* Drop this inode's dquots. */
-static int
+static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
 	void			*priv)
@@ -818,7 +818,7 @@ xfs_dqrele_inode(
 		ip->i_pdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
+	xfs_irele(ip);
 }
 
 /*
@@ -846,7 +846,7 @@ xfs_dqrele_all_inodes(
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
-# define xfs_dqrele_inode(ip, priv)	(0)
+# define xfs_dqrele_inode(ip, priv)	((void)0)
 #endif /* CONFIG_XFS_QUOTA */
 
 /*
@@ -1778,8 +1778,7 @@ xfs_inode_walk_ag(
 				continue;
 			switch (goal) {
 			case XFS_ICWALK_DQRELE:
-				error = xfs_dqrele_inode(batch[i], args);
-				xfs_irele(batch[i]);
+				xfs_dqrele_inode(batch[i], args);
 				break;
 			case XFS_ICWALK_BLOCKGC:
 				error = xfs_blockgc_scan_inode(batch[i], args);


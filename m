Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A3FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbiLaBHC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiLaBHB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:07:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220651573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF7E3B81DE6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7ADC433EF;
        Sat, 31 Dec 2022 01:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448817;
        bh=hy3vBtUlSK3owKpnKRIUO+0a115PSlhduXNOVthMFGQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PnBbHHh/mzCbsrlEjKqOnogmcj24o588Vf3PxkVMRa41n9e/Uj5hk0P9ON6Wex2CD
         Tr8dOXg3y3tirDtJ2Y4hfpUM02KSaszWAEI3r4PukUVCThMPTc3KJ/d9tTgCC+rVZD
         BIYYxjGaD4091nRCFUCjVc5Jaa9ffzf0hZq5htecOShSDUfWzLpx66g7C1t1GcEgTY
         k5ZS8PxEKFxBeMSoCoeEkolaNmjz3OMQ0JbgKv7HVzamRZKP/QUW+HuEyxjvvE78fM
         kXKSDLfPKEVLYKuUSN/+j994aefoi4ISe75jnkDx+p9ulBttS3pA7lRBydB9+97pzd
         Oal/U1GMTz+Uw==
Subject: [PATCH 07/20] xfs: use xfs_trans_ichgtime to set times when
 allocating inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863932.707335.13862526907703121698.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use xfs_trans_ichgtime to set the inode times when allocating an inode,
instead of open-coding them here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ffbf504891aa..7a634a1ea111 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -689,10 +689,11 @@ xfs_icreate(
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip;
-	unsigned int		flags;
-	int			error;
-	struct timespec64	tv;
 	struct inode		*inode;
+	unsigned int		flags;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
+					XFS_ICHGTIME_ACCESS;
+	int			error;
 
 	/*
 	 * Protect against obviously corrupt allocation btree records. Later
@@ -755,20 +756,17 @@ xfs_icreate(
 	ip->i_df.if_nextents = 0;
 	ASSERT(ip->i_nblocks == 0);
 
-	tv = current_time(inode);
-	inode->i_mtime = tv;
-	inode->i_atime = tv;
-	inode->i_ctime = tv;
-
 	ip->i_extsize = 0;
 	ip->i_diflags = 0;
 
 	if (xfs_has_v3inodes(mp)) {
 		inode_set_iversion(inode, 1);
 		ip->i_cowextsize = 0;
-		ip->i_crtime = tv;
+		times |= XFS_ICHGTIME_CREATE;
 	}
 
+	xfs_trans_ichgtime(tp, ip, times);
+
 	flags = XFS_ILOG_CORE;
 	switch (args->mode & S_IFMT) {
 	case S_IFIFO:


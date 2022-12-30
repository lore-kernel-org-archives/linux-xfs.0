Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D90EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbiLaCF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:05:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A952AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C131BB81C23
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73286C433D2;
        Sat, 31 Dec 2022 02:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452324;
        bh=HvJQNooKpEqCgg1vfdBOGkA1mLQKJ7kFlKYpE5JOVZw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b6J3+j24VDdF2d9g5rejrPtci52HJZINLFIxL/5nJuNIuOmKzzEja8h4PDlc/BO0L
         v+RYuGrq4XiMWZmPcHB9ZzO0U+RCPNHeC423vXeN3KZmQd7np+wD4wSlYJqdN/dC3n
         DRQ2jQz9oPkhmp5/L8Jpco7HTFYX0hSiBMSXmUfQZlgKKqOItn5yCpcpDyQgECOJfE
         sUUS7ySVGXKTEiobnP9KoAGHXxlqXUoUyLKdi0B60nYV3N+4t8lY4kln4RAtp9uORb
         IhpA0jy3eMJA9sdLnmRFXklKr18Bfh6L+X7LDUNF9MyrzfsHR5WXFkWp/RZ1pg34tv
         z2PesH4LaXRdQ==
Subject: [PATCH 09/26] libxfs: set access time when creating files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875431.723621.17001516036883152447.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Set the access time on files that we're creating, to match the behavior
of the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index c14a4c5a27f..7f8f1164e08 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -73,7 +73,8 @@ libxfs_icreate(
 	struct xfs_inode	*pip = args->pip;
 	struct xfs_inode	*ip;
 	unsigned int		flags;
-	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
+					XFS_ICHGTIME_ACCESS;
 	int			error;
 
 	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);


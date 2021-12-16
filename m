Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D20EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 01:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhLPBJY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPBJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B1C061574
        for <linux-xfs@vger.kernel.org>; Wed, 15 Dec 2021 17:09:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95EFDB8226D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47549C36AE1;
        Thu, 16 Dec 2021 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616961;
        bh=y+64aMttUIyIIpHriH84iy+QSi4K638GQ6bE5Mq3Knc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=prsw7XfNIBd/njBLQFHz8CDDl8esLQy8jfaiKHzaPWfHBK+Ik+pbp9l3JoRIH+zlo
         mmon4bPRevUYX0Cjv3Uix2mw84/OWNE4vwH2Fok3v6J/HIZMyKZ98knDX4Vd/0Lz04
         c4IqCS/3X6kd5xYwtkyIzYXoCRSgHJ46SC6lUay4tLDeCjlDgTwoIpQg31Iyo1sPve
         Z+V3S2v4ZG+Uwy+++rx+gBTddK8Jc2KG2nZL4UBmaq3UAluTerg71mdB33plMx+alO
         Ta6kcKR4w/G3kyTfOFzVQgpyoW5fjo26F8MYG9W6eA5Vm/l1t42XJAWTSnvA87AQQj
         MaMgr93hMGwNw==
Subject: [PATCH 1/7] xfs: take the ILOCK when accessing the inode core
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:21 -0800
Message-ID: <163961696098.3129691.10143704907338536631.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I was poking around in the directory code while diagnosing online fsck
bugs, and noticed that xfs_readdir doesn't actually take the directory
ILOCK when it calls xfs_dir2_isblock.  xfs_dir_open most probably loaded
the data fork mappings and the VFS took i_rwsem (aka IOLOCK_SHARED) so
we're protected against writer threads, but we really need to follow the
locking model like we do in other places.  The same applies to the
shortform getdents function.

While we're at it, clean up the somewhat strange structure of this
function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dir2_readdir.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 8310005af00f..25560151c273 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -507,8 +507,9 @@ xfs_readdir(
 	size_t			bufsize)
 {
 	struct xfs_da_args	args = { NULL };
-	int			rval;
-	int			v;
+	unsigned int		lock_mode;
+	int			error;
+	int			isblock;
 
 	trace_xfs_readdir(dp);
 
@@ -522,14 +523,19 @@ xfs_readdir(
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
 
-	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-		rval = xfs_dir2_sf_getdents(&args, ctx);
-	else if ((rval = xfs_dir2_isblock(&args, &v)))
-		;
-	else if (v)
-		rval = xfs_dir2_block_getdents(&args, ctx);
-	else
-		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
+	lock_mode = xfs_ilock_data_map_shared(dp);
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		xfs_iunlock(dp, lock_mode);
+		return xfs_dir2_sf_getdents(&args, ctx);
+	}
 
-	return rval;
+	error = xfs_dir2_isblock(&args, &isblock);
+	xfs_iunlock(dp, lock_mode);
+	if (error)
+		return error;
+
+	if (isblock)
+		return xfs_dir2_block_getdents(&args, ctx);
+
+	return xfs_dir2_leaf_getdents(&args, ctx, bufsize);
 }


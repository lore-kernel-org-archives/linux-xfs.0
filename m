Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665D4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbiLaBGq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:06:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969D52DF9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:06:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48752B81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F56C433D2;
        Sat, 31 Dec 2022 01:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448802;
        bh=bK+rZrpSEjIwHetom15pPw1EiIzBU/FSEr2ingZnJnk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WaI0NqZ9GofNaJtFkUeovq8WKCL9DM9pNorB4AFGkFLw4oBThPae7fR1gn/v+OoIs
         ObX0Nis0nFAc/iUUSbiiq0xHGI8JY1SgvJNVp/4WnIucZiTd6D71oUOI/wnc7kFmJA
         axI9sTPUVYu9kEAq9UhYcBUjdTs29gwFi3byPaQNL88hSLxgPg9WVpzWavG0CANYIB
         GGyBaF74M3M5SHkEoL1xT5SLv1sXHLt7CB9+s2AQo6uXFDZvnmoT/ZWwEPZesMucMt
         M7wqFKX2gRrF9cax1yiYe7gnJokANyvjQNUjXpxLg4SJs4+3GaqbEIZfXr4EIANV9C
         ac4FulpE2B+ZA==
Subject: [PATCH 06/20] xfs: implement atime updates in xfs_trans_ichgtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863918.707335.13942694678423467250.stgit@magnolia>
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

Enable xfs_trans_ichgtime to change the inode access time so that we can
use this function to set inode times when allocating inodes instead of
open-coding it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_shared.h      |    1 +
 fs/xfs/libxfs/xfs_trans_inode.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 5127fa88531f..acf527eb0e1c 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -137,6 +137,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
 #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
 #define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
+#define	XFS_ICHGTIME_ACCESS	0x8	/* last access timestamp */
 
 /* Computed inode geometry for the filesystem. */
 struct xfs_ino_geometry {
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 8b5547073379..6a3a869635bf 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -69,6 +69,8 @@ xfs_trans_ichgtime(
 		inode->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
+	if (flags & XFS_ICHGTIME_ACCESS)
+		inode->i_atime = tv;
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }


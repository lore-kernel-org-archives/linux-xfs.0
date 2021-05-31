Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0778AC47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2711611CA
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhEaWmZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232349AbhEaWmY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE489611CA;
        Mon, 31 May 2021 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500844;
        bh=lfFzw1Nvy74WSLO6yhZcW1Q4+LvfjpCE36rrS351i4s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SssfXYO+fTS6cn8SHeSvs6YtaAGg9DaNzJ+QhQEdZVrSeKnZNLW/y1XpjTZ5RoO3a
         7N8CywXngyE1xASJPOMSNxppETDAG6UnGOmQXA+fGWsjiPrXdYCY+AFXf3us3imI4Y
         XlbZHTWxxrTUEnaC0JvVsJUD7QSFuD3AkbIMW/uTSaC85MUk19P0kXH2+f3uiqwtr9
         0ai4OJDpXEMsMlUaLjDnJbxounVivURL+XsjjDSkkde/dfN2mnV5rX6xMDRv5ZDqkd
         1YiXWVrJCHCXrvb9+m5v8vQUUqGS37jJjeI7yhMuYtI/un7ZFPGOUYIDLIvsDOBX80
         PIWI3eXFh6Z2A==
Subject: [PATCH 2/3] xfs: clean up open-coded fs block unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:40:43 -0700
Message-ID: <162250084368.490289.286869347542521014.stgit@locust>
In-Reply-To: <162250083252.490289.17618066691063888710.stgit@locust>
References: <162250083252.490289.17618066691063888710.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace some open-coded fs block unit conversions with the standard
conversion macro.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +-
 fs/xfs/xfs_iops.c             |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f3254a4f4cb4..04ce361688f7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -612,7 +612,7 @@ xfs_inode_validate_extsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
 	else
 		blocksize_bytes = mp->m_sb.sb_blocksize;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index dfe24b7f26e5..93c082db04b7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -543,7 +543,7 @@ xfs_stat_blksize(
 	 * always return the realtime extent size.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		return xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
+		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip));
 
 	/*
 	 * Allow large block sizes to be reported to userspace programs if the
@@ -560,7 +560,7 @@ xfs_stat_blksize(
 	 */
 	if (mp->m_flags & XFS_MOUNT_LARGEIO) {
 		if (mp->m_swidth)
-			return mp->m_swidth << mp->m_sb.sb_blocklog;
+			return XFS_FSB_TO_B(mp, mp->m_swidth);
 		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
 			return 1U << mp->m_allocsize_log;
 	}


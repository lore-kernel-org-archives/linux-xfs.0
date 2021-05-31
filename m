Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712A1C47080
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D549611CA
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhEaWmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhEaWmS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7913B60FDC;
        Mon, 31 May 2021 22:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500838;
        bh=nAwCqaiwrssocsshXbDRAj7NSFihXmpFzgiPwxwIJTs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uQztKdS7RcgHz2BI1vsz9v4EWl9/WN3J/vGK7TdgVyX4tHabPJrD3TXZNjeW8K0Sq
         ut0NEFgak3skfc7nMDfWvhq71UES735oQT//veJ7UVfsnKBSmSlFd0CYJyIbp7gDx7
         oKe8bDEWkUOd3P02ajUtn6kldZn7FItt+ttk9O+lnM/Hs7tcbF3jznZPt6vo6RELYz
         2I4KjRPQ85gQd949t9dsVw2w497ARMVrzS0e/XcCBs/a0YQVK9JIf03bIK47yhBjOm
         d8jyHkuY42AQ6Xgcitn394I87U1wFWdifv+EHKli7KrrM7TAkMr/zJziO4FWd7U19b
         ezLDVayIkB7yA==
Subject: [PATCH 1/3] xfs: set ip->i_diflags directly in
 xfs_inode_inherit_flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:40:38 -0700
Message-ID: <162250083819.490289.18171121927859927558.stgit@locust>
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

Remove the unnecessary convenience variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e4c2da4566f1..1e28997c6f78 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -689,47 +689,44 @@ xfs_inode_inherit_flags(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
-	unsigned int		di_flags = 0;
 	xfs_failaddr_t		failaddr;
 	umode_t			mode = VFS_I(ip)->i_mode;
 
 	if (S_ISDIR(mode)) {
 		if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
+			ip->i_diflags |= XFS_DIFLAG_RTINHERIT;
 		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+			ip->i_diflags |= XFS_DIFLAG_EXTSZINHERIT;
 			ip->i_extsize = pip->i_extsize;
 		}
 		if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
-			di_flags |= XFS_DIFLAG_PROJINHERIT;
+			ip->i_diflags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(mode)) {
 		if ((pip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 		    xfs_sb_version_hasrealtime(&ip->i_mount->m_sb))
-			di_flags |= XFS_DIFLAG_REALTIME;
+			ip->i_diflags |= XFS_DIFLAG_REALTIME;
 		if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
-			di_flags |= XFS_DIFLAG_EXTSIZE;
+			ip->i_diflags |= XFS_DIFLAG_EXTSIZE;
 			ip->i_extsize = pip->i_extsize;
 		}
 	}
 	if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
 	    xfs_inherit_noatime)
-		di_flags |= XFS_DIFLAG_NOATIME;
+		ip->i_diflags |= XFS_DIFLAG_NOATIME;
 	if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
 	    xfs_inherit_nodump)
-		di_flags |= XFS_DIFLAG_NODUMP;
+		ip->i_diflags |= XFS_DIFLAG_NODUMP;
 	if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
 	    xfs_inherit_sync)
-		di_flags |= XFS_DIFLAG_SYNC;
+		ip->i_diflags |= XFS_DIFLAG_SYNC;
 	if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
 	    xfs_inherit_nosymlinks)
-		di_flags |= XFS_DIFLAG_NOSYMLINKS;
+		ip->i_diflags |= XFS_DIFLAG_NOSYMLINKS;
 	if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
 	    xfs_inherit_nodefrag)
-		di_flags |= XFS_DIFLAG_NODEFRAG;
+		ip->i_diflags |= XFS_DIFLAG_NODEFRAG;
 	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
-		di_flags |= XFS_DIFLAG_FILESTREAM;
-
-	ip->i_diflags |= di_flags;
+		ip->i_diflags |= XFS_DIFLAG_FILESTREAM;
 
 	/*
 	 * Inode verifiers on older kernels only check that the extent size


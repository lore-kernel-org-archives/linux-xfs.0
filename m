Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365E7C433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7E561264
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhEMBDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233723AbhEMBDO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0663C61264;
        Thu, 13 May 2021 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867725;
        bh=iC0BHWTjsZq7/9R77rr+qacsZPFzo3Mc3PvYSP+uxbg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OhXlO6pe0OHsM9ZZdyIKImOR6YC4tj4MmHw2QmKueqOsbhW3j6bKH/Jyl5foGfzDt
         U8lvLAJJ3H8tit3q6u7pACmq6JdA0oL2kxWjcn0JnqyZwf/ULZzfbWbkwCa7UVRDBb
         Pxq2DkveZYglz8bJOLxr//8W3c4TsMm4wcfOsRjonxfO9WIORycRSF+7BAWonKqkGV
         8M9UtfaI66gfh71Ie85PGkEaBQgI5glHeevvcZzKoQY3yWc9brjCLpWGOXWD0sWHL9
         nTfGemQI5ugNTJRW9owQG3R5xuCFtGDcQHKQWa9QB9Myjwp1IH1MEkAHfwVs5Btjx3
         Lv5fMkkcgzIGQ==
Subject: [PATCH 4/4] xfs: apply rt extent alignment constraints to cow extsize
 hint
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:02:04 -0700
Message-ID: <162086772452.3685783.890036737343315171.stgit@magnolia>
In-Reply-To: <162086770193.3685783.14418051698714099173.stgit@magnolia>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Even though reflink and copy-on-write aren't supported on the realtime
volume, if we ever turn that on, we'd still be constrained to the same
rt extent alignment requirements because cow involves remapping, and
we can only allocate and free in rtextsize units on the realtime volume.

At the moment there aren't any filesystems with rt and reflink in the
wild, so this is should be a zero-risk change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 25261dd73290..704faf806e46 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -628,14 +628,21 @@ xfs_inode_validate_cowextsize(
 	uint16_t			flags,
 	uint64_t			flags2)
 {
-	bool				rt_flag;
+	bool				rt_flag, rtinherit_flag;
 	bool				hint_flag;
 	uint32_t			cowextsize_bytes;
+	uint32_t			blocksize_bytes;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
+	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
+	if (rt_flag || (rtinherit_flag && hint_flag))
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+	else
+		blocksize_bytes = mp->m_sb.sb_blocksize;
+
 	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
 		return __this_address;
 
@@ -652,13 +659,13 @@ xfs_inode_validate_cowextsize(
 	if (hint_flag && rt_flag)
 		return __this_address;
 
-	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
+	if (cowextsize_bytes % blocksize_bytes)
 		return __this_address;
 
 	if (cowextsize > MAXEXTLEN)
 		return __this_address;
 
-	if (cowextsize > mp->m_sb.sb_agblocks / 2)
+	if (!rt_flag && cowextsize > mp->m_sb.sb_agblocks / 2)
 		return __this_address;
 
 	return NULL;


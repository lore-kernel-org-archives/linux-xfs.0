Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D08C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8865B61090
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhEMBDI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233367AbhEMBDI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A40C61090;
        Thu, 13 May 2021 01:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867719;
        bh=nv9tIm03fHOsYGhTf2cHo26wlcKky2dfXChtHMZw59o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tuasGGdDhzms8DL98SFIPcXY2HOS6LMNrOg8/dYj/yLlDZGG6CyCtHv0KBEg0rZEf
         mWU1m5hNtOvrLxV4c1+MoiYlYoJ9BDa8r1DS9f2ToM2UdT+7REctgscnK51uKmyFg0
         7iYdC0wgdPnnGlt1ohHnqm9eyRlhCglxQsvAhmRPUHJlRgbAGiwh6kn8RptPXLmCWy
         HbVSg20VNbT6qdA7GSJno304Tx6sjK0QKxlXAsodN9tyQsGi6uWtnIq22+2pz9Z+va
         VMQH3lxHsYolSePkW1KM53xkT2goOqzHZxCg87r1yEeshzaY0wp47UIOocE/Uq7CfF
         83JmJROJrqitw==
Subject: [PATCH 3/4] xfs: validate extsz hints against rt extent size when
 rtinherit is set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:58 -0700
Message-ID: <162086771885.3685783.16422648250546171771.stgit@magnolia>
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

The RTINHERIT bit can be set on a directory so that newly created
regular files will have the REALTIME bit set to store their data on the
realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
the directory, the hint will also be copied into the new file.

As pointed out in previous patches, for realtime files we require the
extent size hint be an integer multiple of the realtime extent, but we
don't perform the same validation on a directory with both RTINHERIT and
EXTSZINHERIT set, even though the only use-case of that combination is
to propagate extent size hints into new realtime files.  This leads to
inode corruption errors when the bad values are propagated.

Strengthen the validation routine to avoid this situation and fix the
open-coded unit conversion while we're at it.  Note that this is
technically a breaking change to the ondisk format, but the risk should
be minimal because (a) most vendors disable realtime, (b) letting
unaligned hints propagate to new files would immediately crash the
filesystem, and (c) xfs_repair flags such filesystems as corrupt, so
anyone with such a configuration is broken already anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5c9a7440d9e4..25261dd73290 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -569,19 +569,20 @@ xfs_inode_validate_extsize(
 	uint16_t			mode,
 	uint16_t			flags)
 {
-	bool				rt_flag;
+	bool				rt_flag, rtinherit_flag;
 	bool				hint_flag;
 	bool				inherit_flag;
 	uint32_t			extsize_bytes;
 	uint32_t			blocksize_bytes;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
+	rtinherit_flag = (flags & XFS_DIFLAG_RTINHERIT);
 	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
 	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
 	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
 
-	if (rt_flag)
-		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+	if (rt_flag || (rtinherit_flag && inherit_flag))
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
 	else
 		blocksize_bytes = mp->m_sb.sb_blocksize;
 


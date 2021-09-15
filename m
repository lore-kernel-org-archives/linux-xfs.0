Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACE3C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E377E610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhIOXJt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXJt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C2A610A4;
        Wed, 15 Sep 2021 23:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747309;
        bh=uFsooZ5yvS/lHvCCKclo4tbXz18NL8E+grcMVN7krxU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sqXoJBDwMJ69mLakMVuOLmRtjVHiBbJsnDZpddCRLEcizNavGxjYMjth9hbxsJraE
         QH7aYQN/MooVQmlIUN2XYATl1keA5a1ZhMUAuY4iPF4vpGiuGzNvkEwSBjE6vLCarR
         BbJUV/r2mRXzspK2bIku/R4njZVTiML9GwkuYPTgycpYgfWstACeshud/RPpva8hMa
         yW1ocsy+IcD6AyuVtI7l3wVPHDxayRCW7XKt/SRw15wAFikS8V/uYVZWQrzMfeAdvZ
         n/9rWZNbgx1Arzy7BD6zS1xtHBMNISUyd6YquXNLXETOTcXpSYQGhxj4oWXJfMgXLD
         ikukP5wWNHpAQ==
Subject: [PATCH 21/61] xfs: clean up open-coded fs block unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:29 -0700
Message-ID: <163174730935.350433.15027636024868841057.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a7bcb147fef39054fe324a1a988470f5da127196

Replace some open-coded fs block unit conversions with the standard
conversion macro.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index a9ed7f24..70caf6e7 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -609,7 +609,7 @@ xfs_inode_validate_extsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
+		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
 	else
 		blocksize_bytes = mp->m_sb.sb_blocksize;
 


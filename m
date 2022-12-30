Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D2BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiLaC6F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:58:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3A11929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:58:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A53761CE2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8817CC433D2;
        Sat, 31 Dec 2022 02:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455483;
        bh=uDv2D60GjyJgmz6HucK57WQjNlH+4R5iMoo4Q2JgJhE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZR4C+FiSU4j76liROCZ6AoDiaqvMuNmv/du+kJE50P0+y6e8L61+Qc0WSLbihPLgM
         8H5drMea3mtIzi8sL0C7cfC5PM/MYhDVN9JxWTHfI7tLb0SPuZ2lvkRFuBlA7yTGc+
         P+sRsxVeaqThjjxLZp4CmrafaM6by5o8Jb8Y3+GFUQG2rIKCMwx2ZL/oXyWdRFGE51
         GgrAFzsBigHmEvRvAd7Zmm91zrMmO1Z+t4/g2NUG56AHExNUYvMQ9qJpkjtE8wGNzw
         BXsgG+KdZv9MGsc+XbaViRWwNCJ2mCM1dB4FRxhxsZKvFrxFmOJSHqHrLGYnWH4ZwW
         0JMUblb2CQ+xQ==
Subject: [PATCH 15/41] xfs: allow inodes to have the realtime and reflink
 flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:09 -0800
Message-ID: <167243880967.734096.16934342980181414694.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we can share blocks between realtime files, allow this
combination.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 004dafdf1bd..b2e47c3adca 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -672,7 +672,8 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* don't let reflink and realtime mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
 	/* COW extent size hint validation */


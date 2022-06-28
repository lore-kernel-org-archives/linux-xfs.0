Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AD7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiF1Utu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiF1Utu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5262D3056A
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC02961851
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481E8C341C8;
        Tue, 28 Jun 2022 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449388;
        bh=FiT3k3K/vkUbfVPrkYDu5kfdGJzqRgXWGnAbWtXRMM0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R7mTmSaNuXaGGiNBp3QjUfovCdZZTjGyH6hXhoV03ZCmbXE1vtAiiXChebCTeKWbP
         Sz7caKy+aWuIZ5uSCoao86ibY7WVWeUTvcqwOpTYJZiNJ33BfkBYZBHUSdlg7apYPi
         bcKf5b+JD2cYs3mG2qqYv/mWWrB1Vx90nbjg2sp87x6Z9l/F6lXq3CZL/ZK9zDQvfd
         N+ESjhM3br0VGSjSQvuzQmWz5kmvVu7TNm4MOn2t8doKwwmkBtr1YYAnShCJgpeFM6
         avBg/Caq6vKXa2agZtgeBeaysQ1bXn0fPIuEpsqNodeBsfZlPep8BiMbohPt7l0JmQ
         mqXuGdulPwixA==
Subject: [PATCH 6/6] mkfs: always use new_diflags2 to initialize new inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:47 -0700
Message-ID: <165644938793.1089996.3898370820373975650.stgit@magnolia>
In-Reply-To: <165644935451.1089996.13716062701488693755.stgit@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The new_diflags2 field that's set in the inode geometry represent
features that we want enabled for /all/ newly created inodes.
Unfortunately, mkfs doesn't do that because xfs_flags2diflags2 doesn't
read new_diflags2.  Change the new_diflags2 logic to match the kernel.

Without this fix, the root directory gets created without the
DIFLAG2_NREXT64 iflag set, but files created by a protofile /do/ have it
turned on.

This wasn't an issue with DIFLAG2_BIGTIME because xfs_trans_log_inode
quietly turns that on whenever possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index d2389198..5d2383e9 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -286,8 +286,10 @@ libxfs_init_new_inode(
 
 	if (xfs_has_v3inodes(ip->i_mount)) {
 		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = pip ? ip->i_mount->m_ino_geo.new_diflags2 :
-				xfs_flags2diflags2(ip, fsx->fsx_xflags);
+		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+		if (!pip)
+			ip->i_diflags2 = xfs_flags2diflags2(ip,
+							fsx->fsx_xflags);
 		ip->i_crtime = VFS_I(ip)->i_mtime; /* struct copy */
 		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
 	}


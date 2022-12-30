Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AD6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbiLaCF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:05:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836071021
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22A3F61CB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CD7C433EF;
        Sat, 31 Dec 2022 02:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452355;
        bh=mLpfzIp/FIGuKvfEQ4BTBFAUkduH6cnlmvtaIV9TJGc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hwCQ9SwCQEucT1PaJvVj2Dr6vuSwzES6OeAtotdAajaTCo7vWrycn6w5D1bVD2rLM
         M320lrpP7JdtkKjrLlIIzqTEzbY+zC5mak9U9l9c0VH8dz8oEZ3o/7R7cOkpiQ64a3
         Xd1X5guRZyfGMb+s/Lj02SnkpD/d+Ftsiou58TlSl+t5KbAUKkVHEldEsX8FPOVl/y
         3VmvN/hfxFpfy2lTUuH0Unuo6gD1RbIcrjM4/g36WAGvISS7f7CUW9jpEpR4YbGU+N
         5F4CJwiy/5eriWR0QWqafEguSJWyZoI4vzmfUPA/QjZo96uVssNZ0S1WafrMYNiTH0
         d6CuVvxHsLvTw==
Subject: [PATCH 11/26] libxfs: pass flags2 from parent to child when creating
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875454.723621.6299952463214494674.stgit@magnolia>
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

When mkfs creates a new file as a child of an existing directory, we
should propagate the flags2 field from parent to child like the kernel
does.  This ensures that mkfs propagates cowextsize hints properly when
protofiles are in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index c63cc0543d6..9835c708021 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -59,6 +59,20 @@ xfs_inode_propagate_flags(
 	ip->i_diflags |= di_flags;
 }
 
+/* Propagate di_flags2 from a parent inode to a child inode. */
+static void
+xfs_inode_inherit_flags2(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = pip->i_cowextsize;
+	}
+	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+}
+
 /*
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
@@ -123,6 +137,8 @@ libxfs_icreate(
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
 			xfs_inode_propagate_flags(ip, pip);
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
+			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;


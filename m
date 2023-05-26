Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B173C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZCHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjEZCGd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:06:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA14E198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66F5364C5A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9F6C433D2;
        Fri, 26 May 2023 02:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066791;
        bh=9gmzWY6In6hawyNPkI2Zu0DmhcY72VbXMBmwFPEbCl4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=eIBRzwh6/AZr3/awXU4eH5j0yg9T+ODPMw3OdT6rsXrUWP4SQNEsJZw0vpcpC2oVY
         bzZEJ3Q5QmhG4Y/O2EcmP2zUOu1vFIq4ZhCLVzfAVEL893qu6t42o5i+39hu5dOHxl
         7k0Sy9hfm36wF11D6DWQW/tD72DnVKDrGVqZ4OhHp7OsWSFokPlTVUKVtGcjGYW8Jw
         A/yyu/xK/kHi5kTyVtKTwqZsyiJaUFC6rwgvXzdKDFjxujk1wfBqefmWrnVxwwP4Zq
         gcCEFda0atWRJbntXl16Qh8MIrzTBMGnKBSrRt5BQ6QRqKont63BcSSC5c1fCjri8E
         YorZ/VivegZhg==
Date:   Thu, 25 May 2023 19:06:31 -0700
Subject: [PATCH 6/7] xfs: don't pick up IOLOCK during rmapbt repair scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506071850.3743141.16907958753107060727.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
References: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've fixed the directory operations to hold the ILOCK until
they're finished with rmapbt updates for directory shape changes, we no
longer need to take this lock when scanning directories for rmapbt
records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 2a9598a6fddb..c51f49afc1f1 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -567,23 +567,9 @@ xrep_rmap_scan_inode(
 	struct xrep_rmap	*rr,
 	struct xfs_inode	*ip)
 {
-	unsigned int		lock_mode = 0;
+	unsigned int		lock_mode = xrep_rmap_scan_ilock(ip);
 	int			error;
 
-	/*
-	 * Directory updates (create/link/unlink/rename) drop the directory's
-	 * ILOCK before finishing any rmapbt updates associated with directory
-	 * shape changes.  For this scan to coordinate correctly with the live
-	 * update hook, we must take the only lock (i_rwsem) that is held all
-	 * the way to dir op completion.  This will get fixed by the parent
-	 * pointer patchset.
-	 */
-	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-		lock_mode = XFS_IOLOCK_SHARED;
-		xfs_ilock(ip, lock_mode);
-	}
-	lock_mode |= xrep_rmap_scan_ilock(ip);
-
 	/* Check the data fork. */
 	error = xrep_rmap_scan_ifork(rr, ip, XFS_DATA_FORK);
 	if (error)


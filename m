Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90AAC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbiATAVF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58522 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiATAVE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94FE36150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7A6C004E1;
        Thu, 20 Jan 2022 00:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638064;
        bh=0vmsGVGXEF3jf1dsuXDoBlef8vAjjaGcoos7mTamxqg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uVDzgKzSqYhSQLYJbdi+lKJ8Dt3dZhBbcP37YouS7VsIU7q2M96+Gu2A8tkFxSEYB
         MLSyn+OLkRffbBn/CDGnqFzbUuZKzKWT2gXzRpD2GRdQY6/oZ6lQILCkHz/iFpw57Y
         puPJcsC2jigg0AqKJ/nRwHTnUNAAYAAb7y6b72yDOnJb7nI7wxmb7IPx67zeYSK1Sy
         E/h3Qxbho/+rYbfiX0GzheCxRb6dVPnX0MCbCGk7UxILTHEDsoIdxeYD61wfkeaT0b
         abeDqjvUo3tQ/6TcVAqMQoLK5O0RjBYROrdB2hBQarwwt8tYjcuVWc/n9+lQNuq3rs
         KHDWCxA7xou4A==
Subject: [PATCH 40/45] libxfs: clean up remaining LIBXFS_MOUNT flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:21:03 -0800
Message-ID: <164263806365.860211.2349495659133555895.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that userspace libxfs also uses m_opstate to track operational
state, the LIBXFS_MOUNT_* flags are only used for the flags argument
passed to libxfs_mount().  Update the comment to reflect this, and clean
up the flags and function declaration whiel we're at it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    6 ++++--
 libxfs/init.c       |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 37398fd3..dc2206de 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -248,8 +248,10 @@ static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
 __XFS_UNSUPP_OPSTATE(readonly)
 __XFS_UNSUPP_OPSTATE(shutdown)
 
-#define LIBXFS_MOUNT_DEBUGGER		0x0001
-#define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
+/* don't fail on device size or AG count checks */
+#define LIBXFS_MOUNT_DEBUGGER		(1U << 0)
+/* report metadata corruption to stdout */
+#define LIBXFS_MOUNT_REPORT_CORRUPTION	(1U << 1)
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 093ce878..f59444ab 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -725,7 +725,7 @@ libxfs_mount(
 	mp->m_features = xfs_sb_version_to_features(sb);
 	if (flags & LIBXFS_MOUNT_DEBUGGER)
 		xfs_set_debugger(mp);
-	if (flags & LIBXFS_MOUNT_WANT_CORRUPTED)
+	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
 		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 


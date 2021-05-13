Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE43C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0369C61090
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhEMBCu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhEMBCt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE7961005;
        Thu, 13 May 2021 01:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867700;
        bh=sXxo4/hq19v7C/YnjOcX7IMgm7dY3lDdLqdneDhyses=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ku3rOxMvXtUi4zvGKCQYFCPyGSFo1hkxWYrmmjGTus3t8Wwax0QYir1hXjx/IYZFF
         S75N51DBFso8wlFssjKDH5O/7S7BIUQ8UsWNQyUGfyvco/ertmOEVz4FstviQ1o5Sx
         cJgtMUy+StQ3pnMzl25U4FaETHxaA8Du/CjAngMt8T7QFfD5BcwXpWppaljnCzKBc4
         8vlzZyj0nwqk+zMc9CDPMk0nriPsHUO1FPDL7XrfXkiWohqVHinum6ld4t8RiLeQaL
         P1u/vkYJsccPYv2ynn4NN4ae+WlFthqoDjWTdBqXxupVsOWh+r+RsutLfLiKTMum1D
         jsHQbcgXneuXg==
Subject: [PATCH 2/2] xfs: restore old ioctl definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:39 -0700
Message-ID: <162086769988.3685697.8916977231906580597.stgit@magnolia>
In-Reply-To: <162086768823.3685697.11936501771461638870.stgit@magnolia>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These ioctl definitions in xfs_fs.h are part of the userspace ABI and
were mistakenly removed during the 5.13 merge window.

Fixes: 9fefd5db08ce ("xfs: convert to fileattr")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a83bdd0c47a8..bde2b4c64dbe 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -770,6 +770,8 @@ struct xfs_scrub_metadata {
 /*
  * ioctl commands that are used by Linux filesystems
  */
+#define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
+#define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
 #define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
 
 /*
@@ -780,6 +782,8 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
 #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
 #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
+#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
+#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)


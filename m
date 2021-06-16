Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11ACC48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23266112D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhFPX5n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPX5n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 19:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF946112D;
        Wed, 16 Jun 2021 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623887736;
        bh=Jcu7xPvBGdtjQfLOXJYY2qVHj9sx9V1byLs35YQxkyY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KRVbla5a49elhnXKo4tnI6AeOzqflNjsuShCARZf3EFFN0k8Toqu18oZ7KvqEzA+4
         r24yPGtfHGfJLfq70i+N535jIn/DooLP5PYq5SZ6eFdQJ+UDyfiI2EJxlkYrWI9PLk
         QWWmcMmwbN8jG7Uyuiu+83UsZhkrcXdG9vnxcu9MpUBRi8+7WQLnOWt9JNO0Hhp7c2
         +hMc9E8R52SS953ToK/xLSk/2FNRcayEY+GHgwfi5d+ETVyKnr9ERGA8gQhign+kWf
         93f4vHNZ8DhbS0M/WAgZ/1ztgD3+8XxHSoUYkUSYpIU5pzNqGG5AE7p+HkWfo+f3Bo
         G1Zt/ETU4Og+A==
Subject: [PATCH 2/2] xfs: print name of function causing fs shutdown instead
 of hex pointer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Jun 2021 16:55:36 -0700
Message-ID: <162388773604.3427063.17701184250204042441.stgit@locust>
In-Reply-To: <162388772484.3427063.6225456710511333443.stgit@locust>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_do_force_shutdown, print the symbolic name of the function that
called us to shut down the filesystem instead of a raw hex pointer.
This makes debugging a lot easier:

XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
	fs/xfs/xfs_log.c. Return address = ffffffffa038bc38

becomes:

XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 07c745cd483e..b7f979eca1e2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -543,7 +543,7 @@ xfs_do_force_shutdown(
 	}
 
 	xfs_notice(mp,
-"%s(0x%x) called from line %d of file %s. Return address = "PTR_FMT,
+"%s(0x%x) called from line %d of file %s. Return address = %pS",
 		__func__, flags, lnnum, fname, __return_address);
 
 	if (flags & SHUTDOWN_CORRUPT_INCORE) {


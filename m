Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88233C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700C161209
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhFRS4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 14:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhFRS4O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 14:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55E8C613E2;
        Fri, 18 Jun 2021 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042445;
        bh=f1hw58I/DOcO+olYszejb9hFX41cDm58bja+XIhTh0w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bUSLXezew2lrZGHfK1tJLe4VKaTVhEZSEKyEcHgSuBgygCbdrH5VHIB0Cli6d50DH
         B5WEe5z26WkItPw0tBytwqn7BLYT+BJgoSjN3kSa7zyMc35UbhQVHJdT4vUCzQbbyp
         ez2jaZ8VAy8WaCbPPxxI6kTA8Zahd2KA2s2mHHJzUOQjxXRC18Z9FiOntjs9enp+G3
         3wCPvJB1Ulsa5hkEQHRIS7TYOwxw6K/yOvxOtNF5f5eLH+RBDQxVG4L1kzPbDRxHlO
         AcglmruvUIhotXoYiul6zqzto3gyCdV25CsuRbA3mtDCh1n1Hz5Ft4fhVu2V5krmCl
         ++1fJcUxwarOw==
Subject: [PATCH 2/3] xfs: print name of function causing fs shutdown instead
 of hex pointer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, chandanrlinux@gmail.com, bfoster@redhat.com
Date:   Fri, 18 Jun 2021 11:54:05 -0700
Message-ID: <162404244503.2377241.5074228710477395763.stgit@locust>
In-Reply-To: <162404243382.2377241.18273624393083430320.stgit@locust>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
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


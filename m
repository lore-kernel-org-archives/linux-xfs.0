Return-Path: <SRS0=BAu2=4Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8606EC10F29
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Mar 2020 04:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F2B2072A
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Mar 2020 04:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583642193;
	bh=loe6aelRK8BRuTbQFnMlnfza3XiOZYkr9EAXe/Wi6HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AkIJKQZjzcFv//Fjh5k8IavAYVE2W9rqCwtexPoIPmkUdtYMua/TdDq4XUbnKpyif
	 HGwWBUuLYEl39LIwV6UTejZjQZqx3vJNBHMGFXuTQg3QfMYdxHf0zYEKoqapN3p5/u
	 tFmwTwqzNvyLQ0DAAuqthsG6wAaErmhMyDhiFw3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgCHEga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 Mar 2020 23:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgCHEga (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 7 Mar 2020 23:36:30 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85D12072A;
        Sun,  8 Mar 2020 04:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583642189;
        bh=loe6aelRK8BRuTbQFnMlnfza3XiOZYkr9EAXe/Wi6HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcrjQK+M0c9DPTvMBYTVd5oL2+iepHhvdb/70KA8/xWR4DsrwpeiXQoppBmsAKP6Y
         MZgvsnm/TpSdRNISqKrBLSzPEJqQdV6szLtOv9501qWtB4WiwbpZmmih2pNlbKYmCg
         kjERC0J74QnpaQIgK4Xxk7Kee0MeISYM5j5WbKYg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: clear PF_MEMALLOC before exiting xfsaild thread
Date:   Sat,  7 Mar 2020 20:35:40 -0800
Message-Id: <20200308043540.1034779-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0000000000000e7156059f751d7b@google.com>
References: <0000000000000e7156059f751d7b@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Leaving PF_MEMALLOC set when exiting a kthread causes it to remain set
during do_exit().  That can confuse things.  For example, if BSD process
accounting is enabled, then it's possible for do_exit() to end up
calling ext4_write_inode().  That triggers the
WARN_ON_ONCE(current->flags & PF_MEMALLOC) there, as it assumes
(appropriately) that inodes aren't written when allocating memory.

This case was reported by syzbot at
https://lkml.kernel.org/r/0000000000000e7156059f751d7b@google.com.

Fix this in xfsaild() by using the helper functions to save and restore
PF_MEMALLOC.

Reported-by: syzbot+1f9dc49e8de2582d90c2@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/xfs/xfs_trans_ail.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 00cc5b8734be..3bc570c90ad9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -529,8 +529,9 @@ xfsaild(
 {
 	struct xfs_ail	*ailp = data;
 	long		tout = 0;	/* milliseconds */
+	unsigned int	noreclaim_flag;
 
-	current->flags |= PF_MEMALLOC;
+	noreclaim_flag = memalloc_noreclaim_save();
 	set_freezable();
 
 	while (1) {
@@ -601,6 +602,7 @@ xfsaild(
 		tout = xfsaild_push(ailp);
 	}
 
+	memalloc_noreclaim_restore(noreclaim_flag);
 	return 0;
 }
 
-- 
2.25.1


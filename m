Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227C7C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6C26103E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhG1VQe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhG1VQd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51BB61039;
        Wed, 28 Jul 2021 21:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506991;
        bh=WbCJMzWWkXkn+WV0a2ncp0oOB+zCbI5i6z5JR7780YA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZLCk778Tezlyc86BSSCgjsk7bdfV1+Op1alIk5PcWIkS2sk/KKhTICVrnQDnrUg7T
         u+90teLERhie0nFMaLE+Rr5iIlR8nbYvR+sC40pnRBxnupo2+DhIOsQwQJPlJmgyeE
         mtgRR4Jlbz/wYqb/KhRcAcPdPtZKphLM8dhTCqIcg2cx+eBpPrCzVO49/d5BVpm4k/
         TJ3j8rk1vS5i4OnayXcGkYCx5vrjq8rbwmyJ21wQkXApTOlIBLh0NKVTiIGAb38R4p
         0E6n9O+D0Wq0CYFzbk4HZ8SS71VHq+pS2Jf26lnjJ5jc5xhG6vmfIbdeLspLdCtME/
         DkZ8519CASoEg==
Subject: [PATCH 2/2] xfs_quota: allow users to truncate group and project
 quota files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:31 -0700
Message-ID: <162750699156.45897.5293513702700120618.stgit@magnolia>
In-Reply-To: <162750698055.45897.6106668678411666392.stgit@magnolia>
References: <162750698055.45897.6106668678411666392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 79ac1ae4, I /think/ xfsprogs gained the ability to deal with
project or group quotas.  For some reason, the quota remove command was
structured so that if the user passes both -g and -p, it will only ask
the kernel truncate the group quota file.  This is a strange behavior
since -ug results in truncation requests for both user and group quota
files, and the kernel is smart enough to return 0 if asked to truncate a
quota file that doesn't exist.

In other words, this is a seemingly arbitrary limitation of the command.
It's an unexpected behavior since we don't do any sort of parameter
validation to warn users when -p is silently ignored.  Modern V5
filesystems support both group and project quotas, so it's all the more
surprising that you can't do group and project all at once.  Remove this
pointless restriction.

Found while triaging xfs/007 regressions.

Fixes: 79ac1ae4 ("Fix xfs_quota disable, enable, off and remove commands Merge of master-melb:xfs-cmds:29395a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 quota/state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/quota/state.c b/quota/state.c
index 19d34ed0..260ef51d 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -462,7 +462,8 @@ remove_extents(
 	if (type & XFS_GROUP_QUOTA) {
 		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
 			return;
-	} else if (type & XFS_PROJ_QUOTA) {
+	}
+	if (type & XFS_PROJ_QUOTA) {
 		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
 			return;
 	}


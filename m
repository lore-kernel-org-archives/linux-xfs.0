Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8535BC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E1D264F84
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhBCTo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhBCTo2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE8C64F8C;
        Wed,  3 Feb 2021 19:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381415;
        bh=wth1mPw6zDUfJmHmaklJbpm4fEomTnWcWyStpH68IP8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kHVkc+B39/O9mvOU3ANqskatP3YhWbpVNNA6jqhhTUIq93dWeggHywpmIryzTJ/OR
         I95QhXwdrTt+v6hxjgslKBNv8AllYKCdaWTTrEqYDbCr6oqeEldhjD/0LRf3/coz5y
         xXpQl/7Xg4tfcQCX44adAII0d0O0xxuLHZxMLBLtsmcCwKKo2Kz6vPTwn4OY2XLYEl
         9Kxwu/l1hXos3DZ+bGDHvTBQGMdWqINtFyx8kK0Z/qAFQiNrKs1H6NQTD6qDG8Pa23
         8e9raouVNqLzAT6k1BqaBchDVG0XX5b6AWiNw9CtQJYGDiZjDD8JV8QAIXLq3Ti8Iq
         eaiyi348awpMQ==
Subject: [PATCH 4/5] xfs_repair: fix unmount error message to have a newline
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Wed, 03 Feb 2021 11:43:35 -0800
Message-ID: <161238141506.1278306.4561190457129017334.stgit@magnolia>
In-Reply-To: <161238139177.1278306.5915396345874239435.stgit@magnolia>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a newline so that this is consistent with the other error messages.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 724661d8..9409f0d8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1136,7 +1136,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	error = -libxfs_umount(mp);
 	if (error)
 		do_error(
-	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair."),
+	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
 				error);
 
 	libxfs_destroy(&x);


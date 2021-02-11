Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D362BC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9979964E57
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBKXAP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhBKXAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4970064E4B;
        Thu, 11 Feb 2021 22:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084370;
        bh=2+ktohsYSZ7SIz6e/CLwjMvXUZiKLZYu7GuXyJiIEvw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZWSRdH1ga9b9+U6yotbk9pzZaLrb4VBeV8/JaZ0S4NEuwXineK9k23WsvnYgiCGaE
         crX6DeS+WVqfX0f7aoAw9/YBMH0LPaxbBS/i0vR4wufcvUFE6TVq+Fu4FFjOYDKVMY
         0SUjds/jlsMB2m/xlCoIDQEl4PkobSc2DqrkT56bC3y4sbnQzW8xoapy6Qum5ZiFg7
         cCT3v0mwGcVuzuepCSWxuxOmf6gn6cyH0rA5Mh1dN6OUnAMwohQ4JFsFJsMkpyZTUo
         QutXRj8HTVhBH2IPRPeEPknyKqui39B/YroK09eWAIywN6fsPQzbtVdyO+VstrRrk6
         HD28nqntdfBeg==
Subject: [PATCH 05/11] xfs_repair: fix unmount error message to have a newline
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:29 -0800
Message-ID: <161308436971.3850286.1647270104945019584.stgit@magnolia>
In-Reply-To: <161308434132.3850286.13801623440532587184.stgit@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


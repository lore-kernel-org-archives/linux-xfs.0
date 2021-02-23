Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB87C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135B964E57
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhBWDBj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230493AbhBWDB3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A43664E5B;
        Tue, 23 Feb 2021 03:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049247;
        bh=wLjx/zdHCYBAr+Pp5wO9gpMk6qorZlHu3+whzYhq3GY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WodlmoBEfN1/7blrT2TGs3IOm31NhD+3NtRkGNv/bPA/MwC1IAKTZ2vbjmtiu2DjP
         JVtRNmsxmUvOnv2cRXnuQRov88eFiEWI703Nyq7Rq2y/6b7cOjc2gBLb9IA4VaakIb
         Mf8kSBo5vGG/oXySMigzv+N6QDhDzEeKMSTbx8i6eLF7PXdvio4AjWt9xoqX+RmbjP
         q63LZNKp0hSHJSgr7u4VsKJ+JSnEMNZhqyi/HYbswD5bjXhRUOuJrwUEIPx4AiSVWh
         oZKupBwww8NmUatt+maQRVDg32ceB1cOHTo/0TjQR+Cg/A2JL5ktCc1L9PI4K1JcZl
         ZlLppm2vg5uhg==
Subject: [PATCH 5/7] xfs_repair: fix unmount error message to have a newline
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:47 -0800
Message-ID: <161404924715.425352.7240443385329836467.stgit@magnolia>
In-Reply-To: <161404921827.425352.18151735716678009691.stgit@magnolia>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
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
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
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


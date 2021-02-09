Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13886C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42FB64EBC
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBIEOy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230225AbhBIEN0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D5B364EBF;
        Tue,  9 Feb 2021 04:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843827;
        bh=wth1mPw6zDUfJmHmaklJbpm4fEomTnWcWyStpH68IP8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aDwxM1+BuAFRUPPZ8UongACsk91z2dl2ibF8xWk4/XjdEVyRMy+Gw4L+IwWnebpwN
         Ce8L9EqRaX1Z/+WhTIjCXQMM3g9YJYrcYFNrvUu/vAAKC6eESiWWPxq8rE9M+rYDPD
         5g9CEIT3zAlmdiZ+zOqLUGwmpEsC19fjukzkFESQMKs+IclFz/8bm7N8ulD1tE4aez
         yY/ztLeHsO0ug5KsDQP0Sv47cpk39vLu3Mv0evufhG7hdDfPU5GGL3xFR2zn0ARJcb
         3Cycp63ivddGeZAhfSE0FT846Zmr8QdMM0J32olJZhiYRg9YzM5F1Z1mnyVUmNxtm/
         vW7fpZEbFOyyQ==
Subject: [PATCH 04/10] xfs_repair: fix unmount error message to have a newline
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:26 -0800
Message-ID: <161284382691.3057868.2014492091458444565.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
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


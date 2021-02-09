Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11088C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74F864E4F
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBIESh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:18:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhBIEPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:15:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5316D64ED1;
        Tue,  9 Feb 2021 04:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843910;
        bh=BMNuSXxFHaU1RWlxw5KUtZejymyyRxkRwaNaeuuoLO4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Okf+TXse3omaAmLb15fHooZhwWKDrKmPYaQSh+ICcmonZvW/GjgyhnxVhNwyCTUUI
         AjXv1FyxZPYuhmc8fIDq5FqqYs5o6gioM79NIuwRekbFPwoOTQXp7gvRG8FB5vIGuH
         0/f5JM7kUF7PB3e11VYuE88XPrvzF97xJEWEifPtYO+U5e5h7Kbi7EgQMkmpYhs0s5
         r43g5oYGlJC2ts/9d6OF40s4htG6FiZUYORC6NkKD24Ip6wBG4WO2XmLDpAr/NyRQY
         71skvI/PSchWMVwt1C0cNhHBaI1f6gZ+VfnyjuQhK9E/3w3By6CQiXyTkL4wvE+/fJ
         eG0y+44rkpW9w==
Subject: [PATCH 6/6] xfs_scrub: fix weirdness in directory name check code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:49 -0800
Message-ID: <161284390991.3058224.12921304382202456726.stgit@magnolia>
In-Reply-To: <161284387610.3058224.6236053293202575597.stgit@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the redundant second check of fd and ISDIR in check_inode_names,
and rework the comment to describe why we can't run phase 5 if we found
other corruptions in the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index ee1e5d6c..1ef234bf 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -278,7 +278,12 @@ check_inode_names(
 			goto out;
 	}
 
-	/* Open the dir, let the kernel try to reconnect it to the root. */
+	/*
+	 * Warn about naming problems in the directory entries.  Opening the
+	 * dir by handle means the kernel will try to reconnect it to the root.
+	 * If the reconnection fails due to corruption in the parents we get
+	 * ESTALE, which is why we skip phase 5 if we found corruption.
+	 */
 	if (S_ISDIR(bstat->bs_mode)) {
 		fd = scrub_open_handle(handle);
 		if (fd < 0) {
@@ -288,10 +293,7 @@ check_inode_names(
 			str_errno(ctx, descr_render(&dsc));
 			goto out;
 		}
-	}
 
-	/* Warn about naming problems in the directory entries. */
-	if (fd >= 0 && S_ISDIR(bstat->bs_mode)) {
 		error = check_dirent_names(ctx, &dsc, &fd, bstat);
 		if (error)
 			goto out;


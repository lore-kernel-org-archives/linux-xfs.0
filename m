Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B63C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjBPVJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBPVJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:09:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB92BEC4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BA05B828E1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8758C433D2;
        Thu, 16 Feb 2023 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581780;
        bh=pow9LpkeR9xlR8pOXmuEdz9b2fdAglGJeH13cxpqZ3w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DA7f1ccHMIdJllq4NV4SNDQki7XXehEUZvP8L09pDylNXKyyroddEe3gdlZSiZCbh
         w5ElYmPwyyg8DB5epLzA92V00G9kl2EmkcCILRqlL796TnTSetf1Rb2DvFjddq52mF
         NiZIiVchnNodl2WbJAoq8krSXhDkTI/275VQhHfsPJpyOQU9pOK91PJnWJ4+kPKmZA
         7IIiVsoiTldKAg+woJ9dHvlmyKJ0YinlTTfjug1Myf1DW8h27znDoTCX2KVNcAPimJ
         arLDecPI2x2KqJSxedELpvWKTC90EujvMZ6VT4PyvQD4GRbX+cfyivz/qr37gscYY8
         RXbpx1s6qLRDQ==
Date:   Thu, 16 Feb 2023 13:09:40 -0800
Subject: [PATCH 5/8] xfs_repair: wipe ondisk parent pointers when there are
 none
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882031.3477807.10832130110488009545.stgit@magnolia>
In-Reply-To: <167657881963.3477807.5005383731904631094.stgit@magnolia>
References: <167657881963.3477807.5005383731904631094.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Erase all the parent pointers when there aren't any found by the
directory entry scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 53ac1013..b1f5fb4e 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -567,8 +567,13 @@ remove_file_pptr(
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
 {
+	struct xfs_slab_cursor	*cur;
+	struct file_pptr	*file_pptr;
+	int			error;
+
 	if (no_modify) {
 		do_warn(_("would delete unlinked ino %llu parent pointers\n"),
 				(unsigned long long)ip->i_ino);
@@ -577,7 +582,25 @@ clear_all_pptrs(
 
 	do_warn(_("deleting unlinked ino %llu parent pointers\n"),
 			(unsigned long long)ip->i_ino);
-	/* XXX actually do the work */
+
+	error = -init_slab_cursor(fscan->file_pptr_recs, NULL, &cur);
+	if (error)
+		do_error(_("init ino %llu pptr cursor failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	while ((file_pptr = pop_slab_cursor(cur)) != NULL) {
+		error = remove_file_pptr(ip, file_pptr);
+		if (error)
+			do_error(
+ _("wiping ino %llu pptr (ino %llu gen 0x%x diroffset %u) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen, file_pptr->diroffset,
+				strerror(error));
+	}
+
+	free_slab_cursor(&cur);
 }
 
 /* Add @ag_pptr to @ip. */
@@ -790,7 +813,7 @@ crosscheck_file_parent_ptrs(
 		 * file.
 		 */
 		if (fscan->nr_file_pptrs > 0)
-			clear_all_pptrs(ip);
+			clear_all_pptrs(ip, fscan);
 
 		return;
 	}


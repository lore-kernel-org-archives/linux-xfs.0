Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D49C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjDFTlq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjDFTlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DEAFF
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7DCD60CEB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A2DC433EF;
        Thu,  6 Apr 2023 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810103;
        bh=uUBdt4V9psGltj4oTmjmNHzfsOFLSXknoRHbYmcnThs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=m+pNZXnld/P4qmoGXyV6TIhqa0qXOnb+8xCXAsQjs146it4jVsxRkQahx6WriWtZN
         IQ3m2saqcgEbqfOCnXpq7HGCPouCL7Vo2dXCilIIk0xwgGfR90TmjLwyIOsigkhiCk
         yWvwHw4heD//V9dA3IQhoNvHc/9QZKM3fof7n1y0kFN+b4tZ5G+g4mysKfJ4dVQywQ
         uEJ7WmCM4YgLjDc93wYCJvq2f/NE51MVsWxH5fVTzsa+H63IuycvTLCGc2jbu7uagH
         depnuA2k2CVoXHJ9ffmLCBMNVe5WEPinLa+y5hpQJuudoY8kboetly7jP1w7MuE/Z/
         PhYl9yL7lVXzw==
Date:   Thu, 06 Apr 2023 12:41:42 -0700
Subject: [PATCH 7/7] xfs_repair: wipe ondisk parent pointers when there are
 none
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828351.617551.7075585272227618287.stgit@frogsfrogsfrogs>
In-Reply-To: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
References: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
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
 repair/pptr.c |   41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 1a0836ed4..980d367ac 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -715,8 +715,13 @@ remove_file_pptr(
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
@@ -725,7 +730,37 @@ clear_all_pptrs(
 
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
+		unsigned char	name[MAXNAMELEN];
+
+		error = load_file_pptr_name(fscan, file_pptr, name);
+		if (error)
+			do_error(
+  _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
+					(unsigned long long)ip->i_ino,
+					(unsigned long long)file_pptr->parent_ino,
+					file_pptr->parent_gen,
+					(unsigned long long)file_pptr->name_cookie,
+					strerror(error));
+
+		error = remove_file_pptr(ip, file_pptr, name);
+		if (error)
+			do_error(
+ _("wiping ino %llu pptr (ino %llu gen 0x%x) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				strerror(error));
+	}
+
+	free_slab_cursor(&cur);
 }
 
 /* Add @ag_pptr to @ip. */
@@ -994,7 +1029,7 @@ crosscheck_file_parent_ptrs(
 		 * file.
 		 */
 		if (fscan->nr_file_pptrs > 0)
-			clear_all_pptrs(ip);
+			clear_all_pptrs(ip, fscan);
 
 		return;
 	}


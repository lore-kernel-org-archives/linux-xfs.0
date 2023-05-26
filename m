Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41304C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjEZCdF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjEZCdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:33:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223C79C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B5864C4C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A6C433D2;
        Fri, 26 May 2023 02:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068382;
        bh=+PhHdsuFepIE02NZXctdso+7RynXNExMuSNcU6STUkQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OwPA/5yczd6uh7/j2x7kXoyp2Q8YoVq/Q62VNDrtQ9SBxClahpZ0vYNtANLepmWXW
         2loS2jUTk9smeiecMMZTLAkk35k4U5sWKJDIwc5Ej+8D/z8vTO6rWDuoWLLGoMw5l/
         BAXUCK+COyvzfeMU1rwU1M3HbkJcJjEQpE4aIvuLgdyt1LztlWYhMDXvcnCMadqg7h
         8okVqcemJGzlt6ywWqAX0yjvhXCKNbRqKRdDhcf2Cz7dQZ24jOAWd6sM8wcvOZb5+B
         fFGRCmUwB2PIgfeBQrXz70ce2PKQUU3TXEHflMFvTL5R1oncd41ECWtAfIE2XTrlHI
         88eLwON4qJJRg==
Date:   Thu, 25 May 2023 19:33:01 -0700
Subject: [PATCH 13/14] xfs_repair: wipe ondisk parent pointers when there are
 none
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078769.3750196.13426202843945317406.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
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
index ae5cc260e1f..19611a14b68 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -718,8 +718,13 @@ remove_file_pptr(
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
@@ -728,7 +733,37 @@ clear_all_pptrs(
 
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
@@ -997,7 +1032,7 @@ crosscheck_file_parent_ptrs(
 		 * file.
 		 */
 		if (fscan->nr_file_pptrs > 0)
-			clear_all_pptrs(ip);
+			clear_all_pptrs(ip, fscan);
 
 		return;
 	}


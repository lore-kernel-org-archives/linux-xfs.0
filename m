Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1725C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjFEPhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbjFEPhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C01AD
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B9C62171
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4D6C433D2;
        Mon,  5 Jun 2023 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979465;
        bh=jP5wRy8S6JvUZ/QNuygRTdm57+ZI36f5z/3wphI8cfA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=T/e6dThd/bNg0F4fbz4C3oKuMA5wV5n4Aa5AdAq0A8J2XgaC1u4haQt/Qy44OLR/1
         EuWCr993VWZXu4W5p86ul5HP61APii2M0KyEhe1R3fJQ9toOw8nVqwLK7Vi5mRFdbm
         B9prktt8Nf5OUQaF3+etrco3vVtGh12QFqOHppPkBUyVgKU+8YNEAEmW/QxWfijQP7
         oWQEVrLkFvER2MxAY7XTVrD1ty9YSDCcSUzj/H6Eulon9AVaD5HwzcqRHxV469RkO6
         9//fCfIbfMZ8IEORJL4NA/hjkiIInCvA+D7fJZUStTV6ydMRZfoGqgY3kUqfSOxbWz
         pWyjxH/37qI2A==
Subject: [PATCH 2/5] xfs_repair: don't log inode problems without printing
 resolution
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:44 -0700
Message-ID: <168597946479.1226461.5013927667528240327.stgit@frogsfrogsfrogs>
In-Reply-To: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're running in repair mode without the verbose flag, I see a bunch
of stuff like this:

entry "FOO" in directory inode XXX points to non-existent inode YYY

This output is less than helpful, since it doesn't tell us that repair
is actually fixing the problem.  We're fixing a corruption, so we should
always say that we're going to fix it.

Fixes: 6c39a3cbda3 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 37573b4301b..39470185ea4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1176,13 +1176,10 @@ entry_junked(
 	xfs_ino_t	ino2)
 {
 	do_warn(msg, iname, ino1, ino2);
-	if (!no_modify) {
-		if (verbose)
-			do_warn(_(", marking entry to be junked\n"));
-		else
-			do_warn("\n");
-	} else
-		do_warn(_(", would junk entry\n"));
+	if (!no_modify)
+		do_warn(_("junking entry\n"));
+	else
+		do_warn(_("would junk entry\n"));
 	return !no_modify;
 }
 
@@ -1682,7 +1679,7 @@ longform_dir2_entry_check_data(
 		if (irec == NULL)  {
 			nbad++;
 			if (entry_junked(
-	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ""),
+	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ", "),
 					fname, ip->i_ino, inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1699,7 +1696,7 @@ longform_dir2_entry_check_data(
 		if (is_inode_free(irec, ino_offset))  {
 			nbad++;
 			if (entry_junked(
-	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64),
+	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
 					fname, ip->i_ino, inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1717,7 +1714,7 @@ longform_dir2_entry_check_data(
 			if (!inode_isadir(irec, ino_offset)) {
 				nbad++;
 				if (entry_junked(
-	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
+	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
 						ORPHANAGE, inum, ip->i_ino)) {
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1739,7 +1736,7 @@ longform_dir2_entry_check_data(
 				dep->name, libxfs_dir2_data_get_ftype(mp, dep))) {
 			nbad++;
 			if (entry_junked(
-	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 					fname, inum, ip->i_ino)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1770,7 +1767,7 @@ longform_dir2_entry_check_data(
 				/* ".." should be in the first block */
 				nbad++;
 				if (entry_junked(
-	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block"), fname,
+	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block, "), fname,
 						inum, ip->i_ino)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
@@ -1803,7 +1800,7 @@ longform_dir2_entry_check_data(
 				/* "." should be the first entry */
 				nbad++;
 				if (entry_junked(
-	_("entry \"%s\" in dir %" PRIu64 " is not the first entry"),
+	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
 						fname, inum, ip->i_ino)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';


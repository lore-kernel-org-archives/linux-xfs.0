Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C447C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjFEPhy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbjFEPhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4B298
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B4CF61539
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8FBC433EF;
        Mon,  5 Jun 2023 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979470;
        bh=nyZPwDErTisQs1C5epu9B5c5OK9joUOWBtR54MAai50=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XmWvRQlo7CRGl4z5a1l9f9DWATk6eoPA3VsBcDlAKP64abfIwjx4J+dLWxhlQTNnS
         grrf6MroanhmBKMscg0n+YdlLau9Vy8sPyPNWbyEKE+f0sz5rGo1ebiC2aHtI6YAGG
         Dii6XToK3gQ0E9Bk6Ayv/Up/HY/2pTuWsCbBEkNTWy6rNdTCz8r6WgO38YkMJUETlk
         UxIaQzY2Mt3juIz+sElv+HawezS6JwfrPwKVM7G31jDPkb8Uxwz9eumYm5cavuKpnl
         vy4Aes5MyaGJ4n9SqtjyOnPaow2p9x1M8ArPEG+Wxek0c2wQh6iLxOI/Dnrqd/+cEt
         OLzx0XcWXN0gA==
Subject: [PATCH 3/5] xfs_repair: fix messaging when shortform_dir2_junk is
 called
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:50 -0700
Message-ID: <168597947041.1226461.4921645137801552482.stgit@frogsfrogsfrogs>
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

This function is called when we've decide to junk a shortform directory
entry.  This is obviously corruption of some kind, so we should always
say something, particularly if we're in !verbose repair mode.
Otherwise, if we're in non-verbose repair mode, we print things like:

entry "FOO" in shortform directory XXX references non-existent inode YYY

Without telling the sysadmin that we're removing the dirent.

Fixes: aaca101b1ae ("xfs_repair: add support for validating dirent ftype field")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 39470185ea4..a457429b3c6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2441,10 +2441,7 @@ shortform_dir2_junk(
 	 */
 	(*index)--;
 
-	if (verbose)
-		do_warn(_("junking entry\n"));
-	else
-		do_warn("\n");
+	do_warn(_("junking entry\n"));
 	return sfep;
 }
 
@@ -2593,7 +2590,7 @@ shortform_dir2_entry_check(
 
 		if (irec == NULL)  {
 			do_warn(
-	_("entry \"%s\" in shortform directory %" PRIu64 " references non-existent inode %" PRIu64 "\n"),
+	_("entry \"%s\" in shortform directory %" PRIu64 " references non-existent inode %" PRIu64 ", "),
 				fname, ino, lino);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
@@ -2610,7 +2607,7 @@ shortform_dir2_entry_check(
 		 */
 		if (is_inode_free(irec, ino_offset))  {
 			do_warn(
-	_("entry \"%s\" in shortform directory inode %" PRIu64 " points to free inode %" PRIu64 "\n"),
+	_("entry \"%s\" in shortform directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
 				fname, ino, lino);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
@@ -2626,7 +2623,7 @@ shortform_dir2_entry_check(
 			 */
 			if (!inode_isadir(irec, ino_offset)) {
 				do_warn(
-	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory"),
+	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
 					ORPHANAGE, lino, ino);
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
@@ -2648,7 +2645,7 @@ shortform_dir2_entry_check(
 				lino, sfep->namelen, sfep->name,
 				libxfs_dir2_sf_get_ftype(mp, sfep))) {
 			do_warn(
-_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
+_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name, "),
 				fname, lino, ino);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
@@ -2673,7 +2670,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 			if (is_inode_reached(irec, ino_offset))  {
 				do_warn(
 	_("entry \"%s\" in directory inode %" PRIu64
-	  " references already connected inode %" PRIu64 ".\n"),
+	  " references already connected inode %" PRIu64 ", "),
 					fname, ino, lino);
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
@@ -2697,7 +2694,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				do_warn(
 	_("entry \"%s\" in directory inode %" PRIu64
 	  " not consistent with .. value (%" PRIu64
-	  ") in inode %" PRIu64 ",\n"),
+	  ") in inode %" PRIu64 ", "),
 					fname, ino, parent, lino);
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,


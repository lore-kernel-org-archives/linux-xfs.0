Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207B0C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbjFEPhn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbjFEPhm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C49D2
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4340862282
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BA3C4339C;
        Mon,  5 Jun 2023 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979459;
        bh=Lxe5TVdlmqRhRLVrAiHrIcgjgeNRZaj1MV6eNfxqRTQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=slU66fZoOhLNRWLTmo7hVd9z5MpAMhw+Zlo+N7AjW6ELjjJWP5e1myi0JhfDAvGVS
         lhBoj1w9l3B4czhBp0qNeA/jetKUJ0Vhv9qGscvwiSSI0R9VVaQGBX6hTYZSrlIV/e
         8TcPmeNyGPp8hv4t1Y54u3FFL/l8wJaut52BLxjOaYogWBjbxBPbYI9CWLQR8kVBgi
         8x3AqhrTNm0cuXQ3BDMkJyxVgZsB9Ft/pcl6rh9Onx8b3jjP5fo2e8pyJaVR3Wd4Bg
         JZofbZLyYLkmJQ+0kcraMyLnXKU73m1+r3JAnGI1R2rtoHk75lli1pc4M910O/loD6
         hzlMN/Ko4bkYg==
Subject: [PATCH 1/5] xfs_repair: don't spray correcting imap all by itself
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:39 -0700
Message-ID: <168597945921.1226461.946607316221373794.stgit@frogsfrogsfrogs>
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

In xfs/155, I occasionally see this in the xfs_repair output:

correcting imap
correcting imap
correcting imap
...

This is completely useless, since we don't actually log which inode
prompted this message.  This logic has been here for a really long time,
but ... I can't make heads nor tails of it.  If we're running in verbose
or dry-run mode, then print the inode number, but not if we're running
in fixit mode?

A few lines later, if we're running in verbose dry-run mode, we print
"correcting imap" even though we're not going to write anything.

If we get here, the inode looks like it's in use, but the inode index
says it isn't.  This is a corruption, so either we fix it or we say that
we would fix it.

Fixes: 6c39a3cbda3 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index cf6a5e399d4..33008853789 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -871,13 +871,11 @@ process_inode_chunk(
 		 */
 		if (is_used)  {
 			if (is_inode_free(ino_rec, irec_offset))  {
-				if (verbose || no_modify)  {
-					do_warn(
+				do_warn(
 	_("imap claims in-use inode %" PRIu64 " is free, "),
 						ino);
-				}
 
-				if (verbose || !no_modify)
+				if (!no_modify)
 					do_warn(_("correcting imap\n"));
 				else
 					do_warn(_("would correct imap\n"));

